//! RV64IMA + Zicsr 的單核心直譯器,只有 Machine mode。

use crate::bus::{Bus, DRAM_BASE};

const MSTATUS: usize = 0x300;
const MISA: usize = 0x301;
const MIE: usize = 0x304;
const MTVEC: usize = 0x305;
const MSCRATCH: usize = 0x340;
const MEPC: usize = 0x341;
const MCAUSE: usize = 0x342;
const MTVAL: usize = 0x343;
const MIP: usize = 0x344;

const MSTATUS_MIE: u64 = 1 << 3;
const MSTATUS_MPIE: u64 = 1 << 7;
const MSTATUS_MPP: u64 = 3 << 11;

pub const REG_NAMES: [&str; 32] = [
    "zero", "ra", "sp", "gp", "tp", "t0", "t1", "t2", "s0", "s1", "a0", "a1", "a2", "a3", "a4",
    "a5", "a6", "a7", "s2", "s3", "s4", "s5", "s6", "s7", "s8", "s9", "s10", "s11", "t3", "t4",
    "t5", "t6",
];

#[derive(Debug, Clone, Copy)]
pub enum Exception {
    InstrAddrMisaligned(u64),
    #[allow(dead_code)]
    InstrAccessFault(u64),
    IllegalInstruction(u64),
    Breakpoint(u64),
    LoadAccessFault(u64),
    StoreMisaligned(u64),
    StoreAccessFault(u64),
    EcallFromM,
}

impl Exception {
    fn code(self) -> u64 {
        use Exception::*;
        match self {
            InstrAddrMisaligned(_) => 0,
            InstrAccessFault(_) => 1,
            IllegalInstruction(_) => 2,
            Breakpoint(_) => 3,
            LoadAccessFault(_) => 5,
            StoreMisaligned(_) => 6,
            StoreAccessFault(_) => 7,
            EcallFromM => 11,
        }
    }
    fn tval(self) -> u64 {
        use Exception::*;
        match self {
            InstrAddrMisaligned(v) | InstrAccessFault(v) | IllegalInstruction(v)
            | Breakpoint(v) | LoadAccessFault(v) | StoreMisaligned(v) | StoreAccessFault(v) => v,
            EcallFromM => 0,
        }
    }
}

fn sext32(x: u32) -> u64 {
    x as i32 as i64 as u64
}

pub struct Cpu {
    pub x: [u64; 32],
    pub pc: u64,
    csr: Vec<u64>,
    pub bus: Bus,
    pub trace: bool,
    pub instret: u64,
    reservation: Option<u64>,
}

type R<T> = Result<T, Exception>;

impl Cpu {
    pub fn new(mem_bytes: usize, echo: bool) -> Self {
        let mut csr = vec![0u64; 4096];
        csr[MSTATUS] = MSTATUS_MPP;
        Cpu {
            x: [0; 32],
            pc: DRAM_BASE,
            csr,
            bus: Bus::new(mem_bytes, echo),
            trace: false,
            instret: 0,
            reservation: None,
        }
    }

    // ---------------- CSR ----------------

    fn mip(&self) -> u64 {
        let mut v = 0;
        if self.bus.clint.msip & 1 != 0 {
            v |= 1 << 3;
        }
        if self.bus.clint.mtime >= self.bus.clint.mtimecmp {
            v |= 1 << 7;
        }
        v
    }

    fn csr_read(&self, a: usize) -> Option<u64> {
        Some(match a {
            MISA => (2u64 << 62) | (1 << 8) | (1 << 12) | 1, // RV64 I M A
            MIP => self.mip(),
            0xf11..=0xf14 => 0, // mvendorid/marchid/mimpid/mhartid
            0xc00 | 0xb00 | 0xc02 | 0xb02 => self.instret,
            0xc01 => self.bus.clint.mtime,
            MSTATUS | MIE | MTVEC | MSCRATCH | MEPC | MCAUSE | MTVAL | 0x306 => self.csr[a],
            _ => return None,
        })
    }

    fn csr_write(&mut self, a: usize, v: u64) -> Option<()> {
        match a {
            MSTATUS => self.csr[a] = (v & (MSTATUS_MIE | MSTATUS_MPIE)) | MSTATUS_MPP,
            MIE => self.csr[a] = v & ((1 << 3) | (1 << 7) | (1 << 11)),
            MTVEC => self.csr[a] = v & !2,
            MEPC => self.csr[a] = v & !3, // 無 C 擴充,IALIGN=32
            MSCRATCH | MCAUSE | MTVAL | 0x306 => self.csr[a] = v,
            // 唯讀 / WARL:忽略寫入
            MISA | MIP | 0xf11..=0xf14 | 0xc00..=0xc02 | 0xb00 | 0xb02 => {}
            _ => return None,
        }
        Some(())
    }

    // ---------------- Trap ----------------

    fn take_trap(&mut self, cause: u64, tval: u64, interrupt: bool) -> Result<(), String> {
        let mtvec = self.csr[MTVEC];
        if !interrupt && mtvec == 0 {
            return Err(format!(
                "未處理的例外 cause={} pc={:#x} tval={:#x}(mtvec 尚未設定)",
                cause, self.pc, tval
            ));
        }
        self.csr[MEPC] = self.pc;
        self.csr[MCAUSE] = if interrupt { (1 << 63) | cause } else { cause };
        self.csr[MTVAL] = tval;
        let st = self.csr[MSTATUS];
        let mie = (st & MSTATUS_MIE) != 0;
        let mut ns = (st & !(MSTATUS_MIE | MSTATUS_MPIE)) | MSTATUS_MPP;
        if mie {
            ns |= MSTATUS_MPIE;
        }
        self.csr[MSTATUS] = ns;
        let base = mtvec & !3;
        self.pc = if interrupt && (mtvec & 1) == 1 { base + 4 * cause } else { base };
        Ok(())
    }

    fn pending_interrupt(&self) -> Option<u64> {
        if self.csr[MSTATUS] & MSTATUS_MIE == 0 {
            return None;
        }
        let p = self.mip() & self.csr[MIE];
        if p & (1 << 3) != 0 {
            Some(3)
        } else if p & (1 << 7) != 0 {
            Some(7)
        } else {
            None
        }
    }

    // ---------------- 執行 ----------------

    /// 執行一個指令週期(含中斷檢查)。回傳 Err 代表無法繼續的致命錯誤。
    pub fn step(&mut self) -> Result<(), String> {
        self.bus.clint.mtime = self.bus.clint.mtime.wrapping_add(1);
        if let Some(c) = self.pending_interrupt() {
            return self.take_trap(c, 0, true);
        }
        if self.pc & 3 != 0 {
            return self.take_trap(0, self.pc, false);
        }
        let inst = match self.bus.load(self.pc, 4) {
            Some(v) => v as u32,
            None => return self.take_trap(1, self.pc, false),
        };
        if self.trace {
            eprintln!("{:#010x}: {:08x}", self.pc, inst);
        }
        match self.execute(inst) {
            Ok(()) => {
                self.instret += 1;
                Ok(())
            }
            Err(e) => self.take_trap(e.code(), e.tval(), false),
        }
    }

    fn wr(&mut self, rd: usize, v: u64) {
        if rd != 0 {
            self.x[rd] = v;
        }
    }

    fn mem_load(&mut self, addr: u64, size: u64) -> R<u64> {
        self.bus.load(addr, size).ok_or(Exception::LoadAccessFault(addr))
    }

    fn mem_store(&mut self, addr: u64, size: u64, v: u64) -> R<()> {
        self.bus.store(addr, size, v).ok_or(Exception::StoreAccessFault(addr))
    }

    fn execute(&mut self, inst: u32) -> R<()> {
        let pc = self.pc;
        let mut next = pc.wrapping_add(4);
        let illegal = Exception::IllegalInstruction(inst as u64);

        let opcode = inst & 0x7f;
        let rd = ((inst >> 7) & 0x1f) as usize;
        let f3 = (inst >> 12) & 7;
        let rs1 = ((inst >> 15) & 0x1f) as usize;
        let rs2 = ((inst >> 20) & 0x1f) as usize;
        let f7 = inst >> 25;
        let a = self.x[rs1];
        let b = self.x[rs2];

        let imm_i = ((inst as i32) >> 20) as i64 as u64;
        let imm_s = ((((inst as i32) >> 25) << 5) as i64 as u64) | ((inst >> 7) & 0x1f) as u64;
        let imm_b = ((((inst as i32) >> 31) << 12) as i64 as u64)
            | (((inst >> 7) & 1) << 11) as u64
            | (((inst >> 25) & 0x3f) << 5) as u64
            | (((inst >> 8) & 0xf) << 1) as u64;
        let imm_u = (inst & 0xffff_f000) as i32 as i64 as u64;
        let imm_j = ((((inst as i32) >> 31) << 20) as i64 as u64)
            | (inst & 0x000f_f000) as u64
            | (((inst >> 20) & 1) << 11) as u64
            | (((inst >> 21) & 0x3ff) << 1) as u64;

        match opcode {
            0x37 => self.wr(rd, imm_u), // LUI
            0x17 => self.wr(rd, pc.wrapping_add(imm_u)), // AUIPC
            0x6f => {
                // JAL
                let t = pc.wrapping_add(imm_j);
                if t & 3 != 0 {
                    return Err(Exception::InstrAddrMisaligned(t));
                }
                self.wr(rd, next);
                next = t;
            }
            0x67 => {
                // JALR
                if f3 != 0 {
                    return Err(illegal);
                }
                let t = a.wrapping_add(imm_i) & !1;
                if t & 3 != 0 {
                    return Err(Exception::InstrAddrMisaligned(t));
                }
                self.wr(rd, next);
                next = t;
            }
            0x63 => {
                let taken = match f3 {
                    0 => a == b,
                    1 => a != b,
                    4 => (a as i64) < (b as i64),
                    5 => (a as i64) >= (b as i64),
                    6 => a < b,
                    7 => a >= b,
                    _ => return Err(illegal),
                };
                if taken {
                    let t = pc.wrapping_add(imm_b);
                    if t & 3 != 0 {
                        return Err(Exception::InstrAddrMisaligned(t));
                    }
                    next = t;
                }
            }
            0x03 => {
                let addr = a.wrapping_add(imm_i);
                let v = match f3 {
                    0 => self.mem_load(addr, 1)? as i8 as i64 as u64,
                    1 => self.mem_load(addr, 2)? as i16 as i64 as u64,
                    2 => self.mem_load(addr, 4)? as i32 as i64 as u64,
                    3 => self.mem_load(addr, 8)?,
                    4 => self.mem_load(addr, 1)?,
                    5 => self.mem_load(addr, 2)?,
                    6 => self.mem_load(addr, 4)?,
                    _ => return Err(illegal),
                };
                self.wr(rd, v);
            }
            0x23 => {
                let addr = a.wrapping_add(imm_s);
                let size = match f3 {
                    0 => 1,
                    1 => 2,
                    2 => 4,
                    3 => 8,
                    _ => return Err(illegal),
                };
                self.mem_store(addr, size, b)?;
            }
            0x13 => {
                let sh = (inst >> 20) & 0x3f;
                let v = match f3 {
                    0 => a.wrapping_add(imm_i),
                    2 => ((a as i64) < (imm_i as i64)) as u64,
                    3 => (a < imm_i) as u64,
                    4 => a ^ imm_i,
                    6 => a | imm_i,
                    7 => a & imm_i,
                    1 => {
                        if inst >> 26 != 0 {
                            return Err(illegal);
                        }
                        a << sh
                    }
                    5 => match inst >> 26 {
                        0x00 => a >> sh,
                        0x10 => ((a as i64) >> sh) as u64,
                        _ => return Err(illegal),
                    },
                    _ => unreachable!(),
                };
                self.wr(rd, v);
            }
            0x1b => {
                let sh = (inst >> 20) & 0x1f;
                let v = match f3 {
                    0 => sext32((a as u32).wrapping_add(imm_i as u32)),
                    1 if f7 == 0 => sext32((a as u32) << sh),
                    5 if f7 == 0 => sext32((a as u32) >> sh),
                    5 if f7 == 0x20 => sext32(((a as u32 as i32) >> sh) as u32),
                    _ => return Err(illegal),
                };
                self.wr(rd, v);
            }
            0x33 => {
                let v = if f7 == 1 {
                    match f3 {
                        0 => a.wrapping_mul(b),
                        1 => ((a as i64 as i128 * b as i64 as i128) >> 64) as u64,
                        2 => ((a as i64 as i128 * b as u128 as i128) >> 64) as u64,
                        3 => ((a as u128 * b as u128) >> 64) as u64,
                        4 => {
                            if b == 0 { u64::MAX } else { (a as i64).wrapping_div(b as i64) as u64 }
                        }
                        5 => {
                            if b == 0 { u64::MAX } else { a / b }
                        }
                        6 => {
                            if b == 0 { a } else { (a as i64).wrapping_rem(b as i64) as u64 }
                        }
                        _ => {
                            if b == 0 { a } else { a % b }
                        }
                    }
                } else {
                    match (f7, f3) {
                        (0x00, 0) => a.wrapping_add(b),
                        (0x20, 0) => a.wrapping_sub(b),
                        (0x00, 1) => a << (b & 63),
                        (0x00, 2) => ((a as i64) < (b as i64)) as u64,
                        (0x00, 3) => (a < b) as u64,
                        (0x00, 4) => a ^ b,
                        (0x00, 5) => a >> (b & 63),
                        (0x20, 5) => ((a as i64) >> (b & 63)) as u64,
                        (0x00, 6) => a | b,
                        (0x00, 7) => a & b,
                        _ => return Err(illegal),
                    }
                };
                self.wr(rd, v);
            }
            0x3b => {
                let (x, y) = (a as u32, b as u32);
                let v = if f7 == 1 {
                    match f3 {
                        0 => sext32(x.wrapping_mul(y)),
                        4 => {
                            if y == 0 { u64::MAX } else { sext32((x as i32).wrapping_div(y as i32) as u32) }
                        }
                        5 => {
                            if y == 0 { u64::MAX } else { sext32(x / y) }
                        }
                        6 => {
                            if y == 0 { sext32(x) } else { sext32((x as i32).wrapping_rem(y as i32) as u32) }
                        }
                        7 => {
                            if y == 0 { sext32(x) } else { sext32(x % y) }
                        }
                        _ => return Err(illegal),
                    }
                } else {
                    match (f7, f3) {
                        (0x00, 0) => sext32(x.wrapping_add(y)),
                        (0x20, 0) => sext32(x.wrapping_sub(y)),
                        (0x00, 1) => sext32(x << (y & 31)),
                        (0x00, 5) => sext32(x >> (y & 31)),
                        (0x20, 5) => sext32(((x as i32) >> (y & 31)) as u32),
                        _ => return Err(illegal),
                    }
                };
                self.wr(rd, v);
            }
            0x0f => {} // FENCE / FENCE.I:單核心,視為 nop
            0x2f => self.amo(inst, f3, rd, a, b)?,
            0x73 => next = self.system(inst, f3, rd, rs1, a, next)?,
            _ => return Err(illegal),
        }
        self.pc = next;
        Ok(())
    }

    fn amo(&mut self, inst: u32, f3: u32, rd: usize, addr: u64, b: u64) -> R<()> {
        let size: u64 = match f3 {
            2 => 4,
            3 => 8,
            _ => return Err(Exception::IllegalInstruction(inst as u64)),
        };
        if addr & (size - 1) != 0 {
            return Err(Exception::StoreMisaligned(addr));
        }
        let ext = |v: u64| if size == 4 { sext32(v as u32) } else { v };
        let f5 = inst >> 27;
        match f5 {
            0x02 => {
                let v = ext(self.mem_load(addr, size)?);
                self.reservation = Some(addr);
                self.wr(rd, v);
            }
            0x03 => {
                if self.reservation == Some(addr) {
                    self.mem_store(addr, size, b)?;
                    self.wr(rd, 0);
                } else {
                    self.wr(rd, 1);
                }
                self.reservation = None;
            }
            _ => {
                let old = ext(self.mem_load(addr, size)?);
                let bb = ext(b);
                let new = match f5 {
                    0x01 => bb,
                    0x00 => old.wrapping_add(bb),
                    0x04 => old ^ bb,
                    0x0c => old & bb,
                    0x08 => old | bb,
                    0x10 => if (old as i64) < (bb as i64) { old } else { bb },
                    0x14 => if (old as i64) > (bb as i64) { old } else { bb },
                    0x18 => old.min(bb),
                    0x1c => old.max(bb),
                    _ => return Err(Exception::IllegalInstruction(inst as u64)),
                };
                self.mem_store(addr, size, new)?;
                self.wr(rd, old);
            }
        }
        Ok(())
    }

    fn system(&mut self, inst: u32, f3: u32, rd: usize, rs1: usize, a: u64, next: u64) -> R<u64> {
        let illegal = Exception::IllegalInstruction(inst as u64);
        let csr = (inst >> 20) as usize;
        if f3 == 0 {
            if rd != 0 || rs1 != 0 {
                return Err(illegal);
            }
            return match csr {
                0x000 => Err(Exception::EcallFromM),
                0x001 => Err(Exception::Breakpoint(self.pc)),
                0x105 => Ok(next), // WFI:當作 nop
                0x302 => {
                    // MRET
                    let st = self.csr[MSTATUS];
                    let mpie = st & MSTATUS_MPIE != 0;
                    let mut ns = (st & !MSTATUS_MIE) | MSTATUS_MPIE | MSTATUS_MPP;
                    if mpie {
                        ns |= MSTATUS_MIE;
                    }
                    self.csr[MSTATUS] = ns;
                    Ok(self.csr[MEPC])
                }
                _ => Err(illegal),
            };
        }
        let src = if f3 >= 4 { rs1 as u64 } else { a };
        let old = self.csr_read(csr).ok_or(illegal)?;
        let new = match f3 & 3 {
            1 => Some(src),
            2 => if rs1 != 0 { Some(old | src) } else { None },
            3 => if rs1 != 0 { Some(old & !src) } else { None },
            _ => return Err(illegal),
        };
        if let Some(v) = new {
            self.csr_write(csr, v).ok_or(illegal)?;
        }
        self.wr(rd, old);
        Ok(next)
    }

    pub fn dump_regs(&self) {
        eprintln!("pc  = {:#018x}   instret = {}", self.pc, self.instret);
        for i in (0..32).step_by(4) {
            eprintln!(
                "{:>4}={:016x} {:>4}={:016x} {:>4}={:016x} {:>4}={:016x}",
                REG_NAMES[i], self.x[i], REG_NAMES[i + 1], self.x[i + 1],
                REG_NAMES[i + 2], self.x[i + 2], REG_NAMES[i + 3], self.x[i + 3]
            );
        }
        eprintln!(
            "mstatus={:#x} mepc={:#x} mcause={:#x} mtval={:#x} mtvec={:#x}",
            self.csr[MSTATUS], self.csr[MEPC], self.csr[MCAUSE], self.csr[MTVAL], self.csr[MTVEC]
        );
    }
}
