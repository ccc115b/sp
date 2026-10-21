//! RV64IMAC + Zicsr 單核心直譯器(壓縮指令先展開成 32 位元再執行)。
//!
//! - 特權模式:M / S / U
//! - CSR:完整的 M-mode 陷阱 CSR + S-mode CSR(sstatus/sie/sip/stvec/sepc/…/satp)
//! - 例外與中斷委派:medeleg / mideleg
//! - 虛擬記憶體:Sv39(三層頁表、超級頁、SUM / MXR / MPRV、硬體更新 A/D、TLB)

use crate::bus::{Bus, DRAM_BASE};
use crate::rvc;

pub const PRV_U: u64 = 0;
pub const PRV_S: u64 = 1;
pub const PRV_M: u64 = 3;

// ---- CSR 位址 ----
const CSR_SSTATUS: usize = 0x100;
const CSR_SIE: usize = 0x104;
const CSR_STVEC: usize = 0x105;
const CSR_SCOUNTEREN: usize = 0x106;
const CSR_SSCRATCH: usize = 0x140;
const CSR_SEPC: usize = 0x141;
const CSR_SCAUSE: usize = 0x142;
const CSR_STVAL: usize = 0x143;
const CSR_SIP: usize = 0x144;
const CSR_SATP: usize = 0x180;
const CSR_MSTATUS: usize = 0x300;
const CSR_MISA: usize = 0x301;
const CSR_MEDELEG: usize = 0x302;
const CSR_MIDELEG: usize = 0x303;
const CSR_MIE: usize = 0x304;
const CSR_MTVEC: usize = 0x305;
const CSR_MCOUNTEREN: usize = 0x306;
const CSR_MSCRATCH: usize = 0x340;
const CSR_MEPC: usize = 0x341;
const CSR_MCAUSE: usize = 0x342;
const CSR_MTVAL: usize = 0x343;
const CSR_MIP: usize = 0x344;
const CSR_MENVCFG: usize = 0x30a;
const CSR_STIMECMP: usize = 0x14d;
const MENVCFG_STCE: u64 = 1 << 63; // Sstc:允許使用 stimecmp
const MENVCFG_ADUE: u64 = 1 << 61; // Svadu:硬體更新 A/D(本實作永遠開啟)

// ---- mstatus 位元 ----
const ST_SIE: u64 = 1 << 1;
const ST_MIE: u64 = 1 << 3;
const ST_SPIE: u64 = 1 << 5;
const ST_MPIE: u64 = 1 << 7;
const ST_SPP: u64 = 1 << 8;
const ST_MPP: u64 = 3 << 11;
const ST_MPRV: u64 = 1 << 17;
const ST_SUM: u64 = 1 << 18;
const ST_MXR: u64 = 1 << 19;
const ST_TVM: u64 = 1 << 20;
const ST_TW: u64 = 1 << 21;
const ST_TSR: u64 = 1 << 22;
const MSTATUS_WMASK: u64 =
    ST_SIE | ST_MIE | ST_SPIE | ST_MPIE | ST_SPP | ST_MPP | ST_MPRV | ST_SUM | ST_MXR | ST_TVM | ST_TW | ST_TSR;
const SSTATUS_MASK: u64 = ST_SIE | ST_SPIE | ST_SPP | ST_SUM | ST_MXR;
const XL_BITS: u64 = (2 << 32) | (2 << 34); // UXL = SXL = 64 位元

// ---- 中斷位元(mip / mie / mideleg)----
const IRQ_S_BITS: u64 = (1 << 1) | (1 << 5) | (1 << 9); // SSI STI SEI
const IRQ_ALL: u64 = IRQ_S_BITS | (1 << 3) | (1 << 7) | (1 << 11);
const MEDELEG_MASK: u64 = 0x3ff | (1 << 12) | (1 << 13) | (1 << 15); // 不含 M-mode ecall(11)

// ---- PTE 位元 ----
const PTE_V: u64 = 1;
const PTE_R: u64 = 1 << 1;
const PTE_W: u64 = 1 << 2;
const PTE_X: u64 = 1 << 3;
const PTE_U: u64 = 1 << 4;
const PTE_A: u64 = 1 << 6;
const PTE_D: u64 = 1 << 7;

const TLB_SIZE: usize = 256;

pub const REG_NAMES: [&str; 32] = [
    "zero", "ra", "sp", "gp", "tp", "t0", "t1", "t2", "s0", "s1", "a0", "a1", "a2", "a3", "a4",
    "a5", "a6", "a7", "s2", "s3", "s4", "s5", "s6", "s7", "s8", "s9", "s10", "s11", "t3", "t4",
    "t5", "t6",
];

#[derive(Debug, Clone, Copy)]
pub enum Exception {
    #[allow(dead_code)]
    InstrAddrMisaligned(u64),
    #[allow(dead_code)]
    InstrAccessFault(u64),
    IllegalInstruction(u64),
    Breakpoint(u64),
    LoadAccessFault(u64),
    StoreMisaligned(u64),
    StoreAccessFault(u64),
    EcallFromU,
    EcallFromS,
    EcallFromM,
    InstrPageFault(u64),
    LoadPageFault(u64),
    StorePageFault(u64),
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
            EcallFromU => 8,
            EcallFromS => 9,
            EcallFromM => 11,
            InstrPageFault(_) => 12,
            LoadPageFault(_) => 13,
            StorePageFault(_) => 15,
        }
    }
    fn tval(self) -> u64 {
        use Exception::*;
        match self {
            InstrAddrMisaligned(v) | InstrAccessFault(v) | IllegalInstruction(v) | Breakpoint(v)
            | LoadAccessFault(v) | StoreMisaligned(v) | StoreAccessFault(v) | InstrPageFault(v)
            | LoadPageFault(v) | StorePageFault(v) => v,
            EcallFromU | EcallFromS | EcallFromM => 0,
        }
    }
}

#[derive(Clone, Copy, PartialEq, Eq)]
enum Access {
    Fetch,
    Load,
    Store,
}

#[derive(Clone, Copy)]
struct TlbEntry {
    vpn: u64, // u64::MAX = 無效
    ppn: u64, // 4KB 粒度的實體頁號
    flags: u64, // PTE 低 8 位元
}

fn sext32(x: u32) -> u64 {
    x as i32 as i64 as u64
}

fn perm_ok(flags: u64, acc: Access, prv: u64, sum: bool, mxr: bool) -> bool {
    let (r, w, x, u) = (flags & PTE_R != 0, flags & PTE_W != 0, flags & PTE_X != 0, flags & PTE_U != 0);
    if u {
        if prv == PRV_S && (acc == Access::Fetch || !sum) {
            return false;
        }
    } else if prv == PRV_U {
        return false;
    }
    match acc {
        Access::Fetch => x,
        Access::Load => r || (mxr && x),
        Access::Store => w,
    }
}

pub struct Cpu {
    pub x: [u64; 32],
    pub pc: u64,
    pub prv: u64,
    mstatus: u64,
    mie: u64,
    mip_sw: u64, // 可由軟體寫入的 pending 位元(SSIP / STIP / SEIP)
    mideleg: u64,
    medeleg: u64,
    satp: u64,
    menvcfg: u64,
    stimecmp: u64,
    csr: Vec<u64>,
    tlb: Vec<TlbEntry>,
    pub bus: Bus,
    pub trace: bool,
    pub instret: u64,
    reservation: Option<u64>,
    raw_inst: u32, // 目前指令的原始編碼(壓縮指令為 16 位元),供 illegal 例外的 tval 使用
}

type R<T> = Result<T, Exception>;

impl Cpu {
    pub fn new(mem_bytes: usize, echo: bool) -> Self {
        Cpu {
            x: [0; 32],
            pc: DRAM_BASE,
            prv: PRV_M,
            mstatus: ST_MPP,
            mie: 0,
            mip_sw: 0,
            mideleg: 0,
            medeleg: 0,
            satp: 0,
            menvcfg: 0,
            stimecmp: u64::MAX,
            csr: vec![0u64; 4096],
            tlb: vec![TlbEntry { vpn: u64::MAX, ppn: 0, flags: 0 }; TLB_SIZE],
            bus: Bus::new(mem_bytes, echo),
            trace: false,
            instret: 0,
            reservation: None,
            raw_inst: 0,
        }
    }

    fn tlb_flush(&mut self) {
        for e in self.tlb.iter_mut() {
            e.vpn = u64::MAX;
        }
    }

    // ---------------- 虛擬記憶體 (Sv39) ----------------

    fn page_fault(acc: Access, va: u64) -> Exception {
        match acc {
            Access::Fetch => Exception::InstrPageFault(va),
            Access::Load => Exception::LoadPageFault(va),
            Access::Store => Exception::StorePageFault(va),
        }
    }

    fn access_fault(acc: Access, va: u64) -> Exception {
        match acc {
            Access::Fetch => Exception::InstrAccessFault(va),
            Access::Load => Exception::LoadAccessFault(va),
            Access::Store => Exception::StoreAccessFault(va),
        }
    }

    /// 虛擬位址 → 實體位址。
    fn translate(&mut self, va: u64, acc: Access) -> R<u64> {
        let mut prv = self.prv;
        if acc != Access::Fetch && prv == PRV_M && self.mstatus & ST_MPRV != 0 {
            prv = (self.mstatus >> 11) & 3; // MPRV:資料存取以 MPP 的權限進行
        }
        if prv == PRV_M || (self.satp >> 60) != 8 {
            return Ok(va);
        }
        // Sv39:位址的 63..39 必須是 bit 38 的符號延伸
        if ((va as i64) << 25) >> 25 != va as i64 {
            return Err(Self::page_fault(acc, va));
        }
        let sum = self.mstatus & ST_SUM != 0;
        let mxr = self.mstatus & ST_MXR != 0;
        let vpn = va >> 12;
        let idx = (vpn as usize) & (TLB_SIZE - 1);
        let e = self.tlb[idx];
        if e.vpn == vpn && perm_ok(e.flags, acc, prv, sum, mxr) && (acc != Access::Store || e.flags & PTE_D != 0) {
            return Ok((e.ppn << 12) | (va & 0xfff));
        }

        // 走訪頁表
        let mut table = (self.satp & 0xfff_ffff_ffff) << 12;
        let mut level: i32 = 2;
        let (pte, pte_addr) = loop {
            let vpn_i = (va >> (12 + 9 * level as u64)) & 0x1ff;
            let addr = table + vpn_i * 8;
            let pte = self.bus.load(addr, 8).ok_or_else(|| Self::access_fault(acc, va))?;
            if pte & PTE_V == 0 || (pte & PTE_R == 0 && pte & PTE_W != 0) {
                return Err(Self::page_fault(acc, va));
            }
            if pte & (PTE_R | PTE_X) != 0 {
                break (pte, addr); // 葉節點
            }
            if level == 0 {
                return Err(Self::page_fault(acc, va));
            }
            level -= 1;
            table = ((pte >> 10) & 0xfff_ffff_ffff) << 12;
        };

        if !perm_ok(pte, acc, prv, sum, mxr) {
            return Err(Self::page_fault(acc, va));
        }
        let ppn = (pte >> 10) & 0xfff_ffff_ffff;
        let low_mask = (1u64 << (9 * level as u64)) - 1;
        if ppn & low_mask != 0 {
            return Err(Self::page_fault(acc, va)); // 超級頁未對齊
        }
        // 硬體更新 A / D 位元
        let mut new_pte = pte | PTE_A;
        if acc == Access::Store {
            new_pte |= PTE_D;
        }
        if new_pte != pte {
            self.bus.store(pte_addr, 8, new_pte).ok_or_else(|| Self::access_fault(acc, va))?;
        }
        let ppn4k = (ppn & !low_mask) | (vpn & low_mask);
        self.tlb[idx] = TlbEntry { vpn, ppn: ppn4k, flags: new_pte & 0xff };
        Ok((ppn4k << 12) | (va & 0xfff))
    }

    /// 取指:回傳 (展開後的 32 位元指令, 指令長度, 原始編碼)。
    fn fetch(&mut self) -> R<(u32, u64, u32)> {
        let pa = self.translate(self.pc, Access::Fetch)?;
        let in_page = (self.pc & 0xfff) <= 0xffc;
        let lo = if in_page {
            if let Some(w) = self.bus.load(pa, 4) {
                // 快速路徑:一次讀 4 位元組
                let lo = w as u16;
                if lo & 3 != 3 {
                    return rvc::expand(lo).map(|e| (e, 2, lo as u32)).ok_or(Exception::IllegalInstruction(lo as u64));
                }
                return Ok((w as u32, 4, w as u32));
            }
            self.bus.load(pa, 2).ok_or(Exception::InstrAccessFault(self.pc))? as u16
        } else {
            self.bus.load(pa, 2).ok_or(Exception::InstrAccessFault(self.pc))? as u16
        };
        if lo & 3 != 3 {
            return rvc::expand(lo).map(|e| (e, 2, lo as u32)).ok_or(Exception::IllegalInstruction(lo as u64));
        }
        // 32 位元指令的後半可能落在下一頁,需獨立轉換
        let va2 = self.pc.wrapping_add(2);
        let pa2 = if in_page { pa + 2 } else { self.translate(va2, Access::Fetch)? };
        let hi = self.bus.load(pa2, 2).ok_or(Exception::InstrAccessFault(va2))? as u32;
        let raw = lo as u32 | (hi << 16);
        Ok((raw, 4, raw))
    }

    fn mem_load(&mut self, va: u64, size: u64) -> R<u64> {
        if (va & 0xfff) + size > 0x1000 {
            // 跨頁:逐位元組處理
            let mut v = 0u64;
            for i in 0..size {
                let pa = self.translate(va.wrapping_add(i), Access::Load)?;
                let b = self.bus.load(pa, 1).ok_or(Exception::LoadAccessFault(va))?;
                v |= b << (8 * i);
            }
            return Ok(v);
        }
        let pa = self.translate(va, Access::Load)?;
        self.bus.load(pa, size).ok_or(Exception::LoadAccessFault(va))
    }

    fn mem_store(&mut self, va: u64, size: u64, val: u64) -> R<()> {
        if (va & 0xfff) + size > 0x1000 {
            let mut pas = [0u64; 8];
            for i in 0..size {
                pas[i as usize] = self.translate(va.wrapping_add(i), Access::Store)?;
            }
            for i in 0..size {
                self.bus.store(pas[i as usize], 1, (val >> (8 * i)) & 0xff).ok_or(Exception::StoreAccessFault(va))?;
            }
            return Ok(());
        }
        let pa = self.translate(va, Access::Store)?;
        self.bus.store(pa, size, val).ok_or(Exception::StoreAccessFault(va))
    }

    // ---------------- CSR ----------------

    fn mip(&self) -> u64 {
        let mut v = self.mip_sw;
        if self.bus.clint.msip & 1 != 0 {
            v |= 1 << 3;
        }
        if self.bus.clint.mtime >= self.bus.clint.mtimecmp {
            v |= 1 << 7;
        }
        if self.menvcfg & MENVCFG_STCE != 0 {
            // Sstc:STIP 由 time >= stimecmp 決定,軟體不能直接設
            v &= !(1 << 5);
            if self.bus.clint.mtime >= self.stimecmp {
                v |= 1 << 5;
            }
        }
        if self.bus.plic.ctx_pending(0) {
            v |= 1 << 11; // MEIP
        }
        if self.bus.plic.ctx_pending(1) {
            v |= 1 << 9; // SEIP
        }
        v
    }

    fn csr_access_ok(&self, a: usize, write: bool) -> bool {
        if self.prv < ((a >> 8) & 3) as u64 {
            return false;
        }
        if write && (a >> 10) == 3 {
            return false; // 唯讀 CSR
        }
        if a == CSR_SATP && self.prv == PRV_S && self.mstatus & ST_TVM != 0 {
            return false;
        }
        if a == CSR_STIMECMP && self.prv == PRV_S && (self.menvcfg & MENVCFG_STCE == 0 || self.csr[CSR_MCOUNTEREN] & 2 == 0) {
            return false;
        }
        true
    }

    fn csr_read(&self, a: usize) -> Option<u64> {
        Some(match a {
            CSR_MSTATUS => self.mstatus | XL_BITS,
            CSR_SSTATUS => (self.mstatus & SSTATUS_MASK) | (2 << 32),
            CSR_MISA => (2u64 << 62) | (1 << 0) | (1 << 2) | (1 << 8) | (1 << 12) | (1 << 18) | (1 << 20), // A C I M S U
            CSR_MEDELEG => self.medeleg,
            CSR_MIDELEG => self.mideleg,
            CSR_MIE => self.mie,
            CSR_MIP => self.mip(),
            CSR_SIE => self.mie & self.mideleg,
            CSR_SIP => self.mip() & self.mideleg,
            CSR_SATP => self.satp,
            CSR_MENVCFG => self.menvcfg,
            CSR_STIMECMP => self.stimecmp,
            0x3a0..=0x3af | 0x3b0..=0x3ef => self.csr[a], // PMP(只存值,不做保護檢查)
            0xf11..=0xf14 => 0,
            0xc00 | 0xb00 | 0xc02 | 0xb02 => self.instret,
            0xc01 => self.bus.clint.mtime,
            CSR_MTVEC | CSR_MSCRATCH | CSR_MEPC | CSR_MCAUSE | CSR_MTVAL | CSR_MCOUNTEREN
            | CSR_STVEC | CSR_SSCRATCH | CSR_SEPC | CSR_SCAUSE | CSR_STVAL | CSR_SCOUNTEREN => self.csr[a],
            _ => return None,
        })
    }

    fn csr_write(&mut self, a: usize, v: u64) -> Option<()> {
        match a {
            CSR_MSTATUS => {
                let mut n = (self.mstatus & !MSTATUS_WMASK) | (v & MSTATUS_WMASK);
                if (n >> 11) & 3 == 2 {
                    n = (n & !ST_MPP) | (self.mstatus & ST_MPP); // MPP 不接受保留值 2
                }
                self.mstatus = n;
            }
            CSR_SSTATUS => self.mstatus = (self.mstatus & !SSTATUS_MASK) | (v & SSTATUS_MASK),
            CSR_MEDELEG => self.medeleg = v & MEDELEG_MASK,
            CSR_MIDELEG => self.mideleg = v & IRQ_S_BITS,
            CSR_MIE => self.mie = v & IRQ_ALL,
            CSR_SIE => {
                let m = self.mideleg & IRQ_S_BITS;
                self.mie = (self.mie & !m) | (v & m);
            }
            CSR_MIP => self.mip_sw = (self.mip_sw & !IRQ_S_BITS) | (v & IRQ_S_BITS),
            CSR_SIP => {
                let m = self.mideleg & (1 << 1); // S-mode 只能寫 SSIP
                self.mip_sw = (self.mip_sw & !m) | (v & m);
            }
            CSR_SATP => {
                let mode = v >> 60;
                if mode == 0 || mode == 8 {
                    self.satp = v;
                    self.tlb_flush();
                } // 不支援的模式:寫入無效(WARL)
            }
            CSR_MENVCFG => self.menvcfg = v & (MENVCFG_STCE | MENVCFG_ADUE),
            CSR_STIMECMP => self.stimecmp = v,
            0x3a0..=0x3af | 0x3b0..=0x3ef => self.csr[a] = v,
            CSR_MTVEC | CSR_STVEC => self.csr[a] = v & !2,
            CSR_MEPC | CSR_SEPC => self.csr[a] = v & !1, // 有 C 擴充,IALIGN=16
            CSR_MSCRATCH | CSR_MCAUSE | CSR_MTVAL | CSR_MCOUNTEREN | CSR_SSCRATCH | CSR_SCAUSE
            | CSR_STVAL | CSR_SCOUNTEREN => self.csr[a] = v,
            CSR_MISA | 0xf11..=0xf14 | 0xc00..=0xc02 | 0xb00 | 0xb02 => {} // 唯讀 / WARL
            _ => return None,
        }
        Some(())
    }

    // ---------------- Trap ----------------

    fn take_trap(&mut self, cause: u64, tval: u64, interrupt: bool) -> Result<(), String> {
        let deleg = if interrupt { self.mideleg } else { self.medeleg };
        let to_s = self.prv <= PRV_S && (deleg >> cause) & 1 == 1;
        let tvec = if to_s { self.csr[CSR_STVEC] } else { self.csr[CSR_MTVEC] };
        if !interrupt && tvec == 0 {
            return Err(format!(
                "未處理的例外 cause={} pc={:#x} tval={:#x}({} 尚未設定,目前模式 {})",
                cause, self.pc, tval,
                if to_s { "stvec" } else { "mtvec" },
                ["U", "S", "?", "M"][self.prv as usize]
            ));
        }
        let base = tvec & !3;
        let newpc = if interrupt && tvec & 1 == 1 { base + 4 * cause } else { base };
        let cause_val = if interrupt { (1 << 63) | cause } else { cause };
        let st = self.mstatus;
        if to_s {
            self.csr[CSR_SEPC] = self.pc;
            self.csr[CSR_SCAUSE] = cause_val;
            self.csr[CSR_STVAL] = tval;
            let mut ns = st & !(ST_SPIE | ST_SIE | ST_SPP);
            if st & ST_SIE != 0 {
                ns |= ST_SPIE;
            }
            if self.prv == PRV_S {
                ns |= ST_SPP;
            }
            self.mstatus = ns;
            self.prv = PRV_S;
        } else {
            self.csr[CSR_MEPC] = self.pc;
            self.csr[CSR_MCAUSE] = cause_val;
            self.csr[CSR_MTVAL] = tval;
            let mut ns = st & !(ST_MPIE | ST_MIE | ST_MPP);
            if st & ST_MIE != 0 {
                ns |= ST_MPIE;
            }
            ns |= self.prv << 11;
            self.mstatus = ns;
            self.prv = PRV_M;
        }
        self.pc = newpc;
        Ok(())
    }

    fn pending_interrupt(&self) -> Option<u64> {
        if self.mie == 0 {
            return None; // 快速路徑:沒有任何中斷被啟用
        }
        let pend = self.mip() & self.mie;
        if pend == 0 {
            return None;
        }
        let m_en = self.prv < PRV_M || self.mstatus & ST_MIE != 0;
        let s_en = self.prv < PRV_S || (self.prv == PRV_S && self.mstatus & ST_SIE != 0);
        let mut act = 0;
        if m_en {
            act |= pend & !self.mideleg;
        }
        if s_en {
            act |= pend & self.mideleg;
        }
        // 優先順序:MEI, MSI, MTI, SEI, SSI, STI
        [11u64, 3, 7, 9, 1, 5].into_iter().find(|&c| (act >> c) & 1 == 1)
    }

    // ---------------- 執行 ----------------

    /// 執行一個指令週期(含中斷檢查)。回傳 Err 代表無法繼續的致命錯誤。
    pub fn step(&mut self) -> Result<(), String> {
        self.bus.clint.mtime = self.bus.clint.mtime.wrapping_add(1);
        if self.bus.clint.mtime & 0x3ff == 0 {
            self.bus.poll(); // 收 stdin、更新裝置中斷線
        }
        if let Some(c) = self.pending_interrupt() {
            return self.take_trap(c, 0, true);
        }
        if self.pc & 1 != 0 {
            return self.take_trap(0, self.pc, false);
        }
        let (inst, len, raw) = match self.fetch() {
            Ok(v) => v,
            Err(e) => return self.take_trap(e.code(), e.tval(), false),
        };
        self.raw_inst = raw;
        if self.trace {
            let w = if len == 2 { 4 } else { 8 };
            eprintln!("[{}] {:#010x}: {:0w$x}", ["U", "S", "?", "M"][self.prv as usize], self.pc, raw, w = w);
        }
        match self.execute(inst, len) {
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

    fn execute(&mut self, inst: u32, len: u64) -> R<()> {
        let pc = self.pc;
        let mut next = pc.wrapping_add(len);
        let illegal = Exception::IllegalInstruction(self.raw_inst as u64);

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
                let t = pc.wrapping_add(imm_j);
                self.wr(rd, next);
                next = t;
            }
            0x67 => {
                if f3 != 0 {
                    return Err(illegal);
                }
                let t = a.wrapping_add(imm_i) & !1;
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
                        4 => if b == 0 { u64::MAX } else { (a as i64).wrapping_div(b as i64) as u64 },
                        5 => if b == 0 { u64::MAX } else { a / b },
                        6 => if b == 0 { a } else { (a as i64).wrapping_rem(b as i64) as u64 },
                        _ => if b == 0 { a } else { a % b },
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
                        4 => if y == 0 { u64::MAX } else { sext32((x as i32).wrapping_div(y as i32) as u32) },
                        5 => if y == 0 { u64::MAX } else { sext32(x / y) },
                        6 => if y == 0 { sext32(x) } else { sext32((x as i32).wrapping_rem(y as i32) as u32) },
                        7 => if y == 0 { sext32(x) } else { sext32(x % y) },
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
            _ => return Err(Exception::IllegalInstruction(self.raw_inst as u64)),
        };
        if addr & (size - 1) != 0 {
            return Err(Exception::StoreMisaligned(addr));
        }
        let ext = |v: u64| if size == 4 { sext32(v as u32) } else { v };
        let f5 = inst >> 27;
        match f5 {
            0x02 => {
                let pa = self.translate(addr, Access::Load)?;
                let v = ext(self.bus.load(pa, size).ok_or(Exception::LoadAccessFault(addr))?);
                self.reservation = Some(pa);
                self.wr(rd, v);
            }
            0x03 => {
                let pa = self.translate(addr, Access::Store)?;
                if self.reservation == Some(pa) {
                    self.bus.store(pa, size, b).ok_or(Exception::StoreAccessFault(addr))?;
                    self.wr(rd, 0);
                } else {
                    self.wr(rd, 1);
                }
                self.reservation = None;
            }
            _ => {
                // AMO 同時讀寫,權限與錯誤都以 store/AMO 回報
                let pa = self.translate(addr, Access::Store)?;
                let old = ext(self.bus.load(pa, size).ok_or(Exception::StoreAccessFault(addr))?);
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
                    _ => return Err(Exception::IllegalInstruction(self.raw_inst as u64)),
                };
                self.bus.store(pa, size, new).ok_or(Exception::StoreAccessFault(addr))?;
                self.wr(rd, old);
            }
        }
        Ok(())
    }

    fn system(&mut self, inst: u32, f3: u32, rd: usize, rs1: usize, a: u64, next: u64) -> R<u64> {
        let illegal = Exception::IllegalInstruction(self.raw_inst as u64);
        let csr = (inst >> 20) as usize;
        if f3 == 0 {
            if inst >> 25 == 0x09 {
                // SFENCE.VMA
                if rd != 0 || self.prv == PRV_U || (self.prv == PRV_S && self.mstatus & ST_TVM != 0) {
                    return Err(illegal);
                }
                self.tlb_flush();
                return Ok(next);
            }
            if rd != 0 || rs1 != 0 {
                return Err(illegal);
            }
            return match csr {
                0x000 => Err(match self.prv {
                    PRV_U => Exception::EcallFromU,
                    PRV_S => Exception::EcallFromS,
                    _ => Exception::EcallFromM,
                }),
                0x001 => Err(Exception::Breakpoint(self.pc)),
                0x105 => {
                    // WFI
                    if self.prv == PRV_U || (self.prv == PRV_S && self.mstatus & ST_TW != 0) {
                        return Err(illegal);
                    }
                    Ok(next)
                }
                0x302 => {
                    // MRET
                    if self.prv != PRV_M {
                        return Err(illegal);
                    }
                    let st = self.mstatus;
                    let mpp = (st >> 11) & 3;
                    let mut ns = st & !(ST_MIE | ST_MPP);
                    if st & ST_MPIE != 0 {
                        ns |= ST_MIE;
                    }
                    ns |= ST_MPIE;
                    if mpp != PRV_M {
                        ns &= !ST_MPRV;
                    }
                    self.mstatus = ns;
                    self.prv = mpp;
                    Ok(self.csr[CSR_MEPC])
                }
                0x102 => {
                    // SRET
                    if self.prv == PRV_U || (self.prv == PRV_S && self.mstatus & ST_TSR != 0) {
                        return Err(illegal);
                    }
                    let st = self.mstatus;
                    let spp = if st & ST_SPP != 0 { PRV_S } else { PRV_U };
                    let mut ns = st & !(ST_SIE | ST_SPP | ST_MPRV);
                    if st & ST_SPIE != 0 {
                        ns |= ST_SIE;
                    }
                    ns |= ST_SPIE;
                    self.mstatus = ns;
                    self.prv = spp;
                    Ok(self.csr[CSR_SEPC])
                }
                _ => Err(illegal),
            };
        }
        let src = if f3 >= 4 { rs1 as u64 } else { a };
        let will_write = (f3 & 3) == 1 || rs1 != 0;
        if !self.csr_access_ok(csr, will_write) {
            return Err(illegal);
        }
        let old = self.csr_read(csr).ok_or(illegal)?;
        let new = match f3 & 3 {
            1 => src,
            2 => old | src,
            3 => old & !src,
            _ => return Err(illegal),
        };
        if will_write {
            self.csr_write(csr, new).ok_or(illegal)?;
        }
        self.wr(rd, old);
        Ok(next)
    }

    pub fn dump_regs(&self) {
        eprintln!(
            "pc  = {:#018x}   prv = {}   instret = {}",
            self.pc, ["U", "S", "?", "M"][self.prv as usize], self.instret
        );
        for i in (0..32).step_by(4) {
            eprintln!(
                "{:>4}={:016x} {:>4}={:016x} {:>4}={:016x} {:>4}={:016x}",
                REG_NAMES[i], self.x[i], REG_NAMES[i + 1], self.x[i + 1],
                REG_NAMES[i + 2], self.x[i + 2], REG_NAMES[i + 3], self.x[i + 3]
            );
        }
        eprintln!(
            "mstatus={:#x} mepc={:#x} mcause={:#x} mtval={:#x} mtvec={:#x}",
            self.mstatus, self.csr[CSR_MEPC], self.csr[CSR_MCAUSE], self.csr[CSR_MTVAL], self.csr[CSR_MTVEC]
        );
        eprintln!(
            "sepc={:#x} scause={:#x} stval={:#x} stvec={:#x} satp={:#x}",
            self.csr[CSR_SEPC], self.csr[CSR_SCAUSE], self.csr[CSR_STVAL], self.csr[CSR_STVEC], self.satp
        );
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::demo::i_type;

    const ROOT: u64 = 0x8010_0000;
    const L1: u64 = 0x8010_1000;
    const L0: u64 = 0x8010_2000;

    fn cpu() -> Cpu {
        Cpu::new(4 << 20, false)
    }

    fn pte(c: &mut Cpu, at: u64, pa: u64, flags: u64) {
        c.bus.store(at, 8, ((pa >> 12) << 10) | flags).unwrap();
    }

    /// VA 0x4000_0000 起的 4KB 對映:root[1] → L1[0] → L0[...]
    fn paging() -> Cpu {
        let mut c = cpu();
        pte(&mut c, ROOT + 8, L1, PTE_V);
        pte(&mut c, L1, L0, PTE_V);
        c.satp = (8 << 60) | (ROOT >> 12);
        c
    }

    #[test]
    fn sv39_4k_page_and_permissions() {
        let mut c = paging();
        pte(&mut c, L0, 0x8020_0000, PTE_V | PTE_R | PTE_W | PTE_U | PTE_A | PTE_D);
        pte(&mut c, L0 + 8, 0x8020_1000, PTE_V | PTE_R | PTE_U | PTE_A); // 唯讀
        c.prv = PRV_U;
        assert!(matches!(c.translate(0x4000_0010, Access::Load), Ok(0x8020_0010)));
        assert!(matches!(c.translate(0x4000_1000, Access::Load), Ok(0x8020_1000)));
        assert!(matches!(c.translate(0x4000_1000, Access::Store), Err(Exception::StorePageFault(0x4000_1000))));
        assert!(matches!(c.translate(0x4000_0000, Access::Fetch), Err(Exception::InstrPageFault(_)))); // 無 X
        assert!(matches!(c.translate(0x4000_2000, Access::Load), Err(Exception::LoadPageFault(_)))); // 未映射
        assert!(matches!(c.translate(0x0000_8000_0000_0000, Access::Load), Err(Exception::LoadPageFault(_)))); // 非標準位址
    }

    #[test]
    fn sum_and_tlb_do_not_bypass_permissions() {
        let mut c = paging();
        pte(&mut c, L0, 0x8020_0000, PTE_V | PTE_R | PTE_W | PTE_U | PTE_A | PTE_D);
        c.prv = PRV_U;
        assert!(c.translate(0x4000_0000, Access::Load).is_ok()); // 填入 TLB
        c.prv = PRV_S; // S-mode 沒開 SUM,即使 TLB 命中也要失敗
        assert!(matches!(c.translate(0x4000_0000, Access::Load), Err(Exception::LoadPageFault(_))));
        c.mstatus |= ST_SUM;
        assert!(c.translate(0x4000_0000, Access::Load).is_ok());
        assert!(matches!(c.translate(0x4000_0000, Access::Fetch), Err(Exception::InstrPageFault(_)))); // S 永不能執行 U 頁
    }

    #[test]
    fn mxr_makes_execute_only_pages_readable() {
        let mut c = paging();
        pte(&mut c, L0, 0x8020_0000, PTE_V | PTE_X | PTE_U | PTE_A);
        c.prv = PRV_U;
        assert!(matches!(c.translate(0x4000_0000, Access::Load), Err(Exception::LoadPageFault(_))));
        c.mstatus |= ST_MXR;
        assert!(c.translate(0x4000_0000, Access::Load).is_ok());
    }

    #[test]
    fn hardware_updates_accessed_and_dirty() {
        let mut c = paging();
        pte(&mut c, L0, 0x8020_0000, PTE_V | PTE_R | PTE_W | PTE_U);
        c.prv = PRV_U;
        c.translate(0x4000_0000, Access::Load).unwrap();
        assert_eq!(c.bus.load(L0, 8).unwrap() & (PTE_A | PTE_D), PTE_A);
        c.translate(0x4000_0000, Access::Store).unwrap(); // TLB 命中但 D=0 → 必須重新走訪
        assert_eq!(c.bus.load(L0, 8).unwrap() & (PTE_A | PTE_D), PTE_A | PTE_D);
    }

    #[test]
    fn gigapage_and_misaligned_superpage() {
        let mut c = cpu();
        c.bus.store(ROOT + 2 * 8, 8, ((0x8000_0000u64 >> 12) << 10) | PTE_V | PTE_R | PTE_W | PTE_X | PTE_A | PTE_D).unwrap();
        c.bus.store(ROOT + 3 * 8, 8, ((0x4_0001u64) << 10) | PTE_V | PTE_R | PTE_A).unwrap(); // 未對齊 1GB
        c.satp = (8 << 60) | (ROOT >> 12);
        c.prv = PRV_S;
        assert!(matches!(c.translate(0x8123_4567, Access::Fetch), Ok(0x8123_4567)));
        assert!(matches!(c.translate(0xc000_0000, Access::Load), Err(Exception::LoadPageFault(_))));
    }

    #[test]
    fn mprv_uses_mpp_for_data_accesses() {
        let mut c = paging();
        pte(&mut c, L0, 0x8020_0000, PTE_V | PTE_R | PTE_W | PTE_A | PTE_D);
        c.prv = PRV_M;
        assert!(matches!(c.translate(0x4000_0000, Access::Load), Ok(0x4000_0000))); // M-mode 不經分頁
        c.mstatus = (c.mstatus & !ST_MPP) | (PRV_S << 11) | ST_MPRV;
        assert!(matches!(c.translate(0x4000_0000, Access::Load), Ok(0x8020_0000)));
        assert!(matches!(c.translate(0x4000_0000, Access::Fetch), Ok(0x4000_0000))); // 取指不受 MPRV 影響
    }

    #[test]
    fn exceptions_delegate_to_s_and_sret_returns() {
        let mut c = cpu();
        c.bus.store(DRAM_BASE, 4, 0x73).unwrap(); // ecall
        c.bus.store(DRAM_BASE + 0x100, 4, 0x1020_0073).unwrap(); // sret
        c.pc = DRAM_BASE;
        c.prv = PRV_U;
        c.medeleg = 1 << 8;
        c.csr[CSR_STVEC] = DRAM_BASE + 0x100;
        c.step().unwrap();
        assert_eq!((c.prv, c.pc), (PRV_S, DRAM_BASE + 0x100));
        assert_eq!((c.csr[CSR_SCAUSE], c.csr[CSR_SEPC]), (8, DRAM_BASE));
        assert_eq!(c.mstatus & ST_SPP, 0); // 來自 U
        c.csr[CSR_SEPC] = DRAM_BASE;
        c.step().unwrap(); // sret
        assert_eq!((c.prv, c.pc), (PRV_U, DRAM_BASE));
    }

    #[test]
    fn undelegated_exception_goes_to_m_with_previous_mode() {
        let mut c = cpu();
        c.bus.store(DRAM_BASE, 4, i_type(0x73, 2, 5, 0, 0x300) as u64).unwrap(); // csrr t0, mstatus(U-mode 不可)
        c.pc = DRAM_BASE;
        c.prv = PRV_U;
        c.csr[CSR_MTVEC] = DRAM_BASE + 0x200;
        c.step().unwrap();
        assert_eq!((c.prv, c.pc, c.csr[CSR_MCAUSE]), (PRV_M, DRAM_BASE + 0x200, 2));
        assert_eq!((c.mstatus >> 11) & 3, PRV_U);
    }

    #[test]
    fn delegated_interrupt_taken_in_u_but_not_in_m() {
        let mut c = cpu();
        c.bus.store(DRAM_BASE, 4, 0x13).unwrap(); // nop
        c.pc = DRAM_BASE;
        c.mie = 1 << 1;
        c.mip_sw = 1 << 1;
        c.mideleg = 1 << 1;
        c.csr[CSR_STVEC] = DRAM_BASE + 0x100;
        c.prv = PRV_M;
        c.mstatus |= ST_MIE;
        c.step().unwrap(); // M-mode 不會被委派給 S 的中斷打斷
        assert_eq!(c.pc, DRAM_BASE + 4);
        c.pc = DRAM_BASE;
        c.prv = PRV_U;
        c.step().unwrap();
        assert_eq!((c.prv, c.pc, c.csr[CSR_SCAUSE]), (PRV_S, DRAM_BASE + 0x100, (1 << 63) | 1));
    }

    #[test]
    fn sstc_timer_and_plic_external_interrupts() {
        let mut c = cpu();
        c.bus.store(DRAM_BASE, 4, 0x13).unwrap(); // nop
        c.pc = DRAM_BASE;
        c.prv = PRV_S;
        c.mie = 1 << 5;
        c.mideleg = 1 << 5;
        c.mstatus |= ST_SIE;
        c.csr[CSR_STVEC] = DRAM_BASE + 0x100;
        c.menvcfg = MENVCFG_STCE;
        c.stimecmp = 1_000;
        c.step().unwrap(); // time < stimecmp:不會中斷
        assert_eq!(c.pc, DRAM_BASE + 4);
        c.pc = DRAM_BASE;
        c.bus.clint.mtime = 1_000;
        c.step().unwrap();
        assert_eq!((c.pc, c.csr[CSR_SCAUSE]), (DRAM_BASE + 0x100, (1 << 63) | 5));

        // PLIC → SEIP
        let mut c = cpu();
        c.bus.plic.write(4 * 10, 1);
        c.bus.plic.write(0x2080, 1 << 10);
        c.bus.plic.set_level(10, true);
        assert_ne!(c.mip() & (1 << 9), 0);
        assert_eq!(c.mip() & (1 << 11), 0);
    }

    #[test]
    fn compressed_and_mixed_length_instructions() {
        let mut c = cpu();
        // 2 位元組:c.li a0,5;接著 4 位元組:addi a1,a0,1(位址 2 對齊);再接 c.j .(自旋)
        c.bus.store(DRAM_BASE, 2, 0x4515).unwrap();
        c.bus.store(DRAM_BASE + 2, 4, 0x0015_0593).unwrap();
        c.pc = DRAM_BASE;
        c.step().unwrap();
        assert_eq!((c.pc, c.x[10]), (DRAM_BASE + 2, 5));
        c.step().unwrap();
        assert_eq!((c.pc, c.x[11]), (DRAM_BASE + 6, 6));

        // 32 位元指令跨越 4KB 頁界:addi a0,x0,5 放在 0xffe
        let mut c = cpu();
        c.bus.store(DRAM_BASE + 0xffe, 4, 0x0050_0513).unwrap();
        c.pc = DRAM_BASE + 0xffe;
        c.step().unwrap();
        assert_eq!((c.pc, c.x[10]), (DRAM_BASE + 0x1002, 5));

        // 非法壓縮指令(全 0):tval 為 16 位元原始編碼,mepc 指向該指令
        let mut c = cpu();
        c.csr[CSR_MTVEC] = DRAM_BASE + 0x100;
        c.pc = DRAM_BASE + 0x10;
        c.step().unwrap();
        assert_eq!((c.pc, c.csr[CSR_MCAUSE], c.csr[CSR_MEPC]), (DRAM_BASE + 0x100, 2, DRAM_BASE + 0x10));

        // jalr 的連結位址要加 2(壓縮的 c.jalr)
        let mut c = cpu();
        c.bus.store(DRAM_BASE, 2, 0x9282).unwrap(); // c.jalr t0
        c.x[5] = DRAM_BASE + 0x40;
        c.pc = DRAM_BASE;
        c.step().unwrap();
        assert_eq!((c.pc, c.x[1]), (DRAM_BASE + 0x40, DRAM_BASE + 2));
    }
}
