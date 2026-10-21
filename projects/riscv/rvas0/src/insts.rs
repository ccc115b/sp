use std::collections::HashSet;

use crate::expr::{self, EvalCtx, Expr, SymInfo, Val};
use crate::isa::{EXT_A, EXT_D, EXT_F, EXT_M};
use crate::regs::{parse_csr};

pub const R_RISCV_32: u32 = 1;
pub const R_RISCV_64: u32 = 2;
pub const R_RISCV_BRANCH: u32 = 16;
pub const R_RISCV_JAL: u32 = 17;
pub const R_RISCV_CALL_PLT: u32 = 19;
pub const R_RISCV_PCREL_HI20: u32 = 23;
pub const R_RISCV_PCREL_LO12_I: u32 = 24;
pub const R_RISCV_PCREL_LO12_J: u32 = 25;
pub const R_RISCV_HI20: u32 = 26;
pub const R_RISCV_LO12_I: u32 = 27;
pub const R_RISCV_LO12_S: u32 = 28;
pub const R_RISCV_RELAX: u32 = 51;

pub const ABS_SYM: &str = "\u{1}abs";

#[derive(Debug, Clone)]
pub enum Operand {
    RegI(u32),
    RegF(u32),
    Expr(Expr),
    Mem(Expr, u32),
}

#[derive(Clone, Copy, PartialEq, Eq)]
pub enum Kind {
    R,
    I,
    Sh,
    Ld,
    St,
    B,
    U,
    J,
    Jalr,
    R4,
    Amo,
    Lr,
    Csr,
    CsrI,
    Fixed,
    Fence,
    Sfence,
    FpAr,
    Fp3,
    FpCmp,
    FpClass,
    F2I,
    I2F,
    F2F,
    MvI2F,
    MvF2I,
    FpLd,
    FpSt,
}

pub struct InstDef {
    pub name: &'static str,
    pub ext: u32,
    pub kind: Kind,
    pub op: u32,
    pub f3: u32,
    pub f7: u32,
    pub rs2: u32,
}

macro_rules! defs {
    ($(($n:literal, $e:expr, $k:ident, $op:expr, $f3:expr, $f7:expr, $rs2:expr)),* $(,)?) => {
        &[ $(InstDef { name: $n, ext: $e, kind: Kind::$k, op: $op, f3: $f3, f7: $f7, rs2: $rs2 }),* ]
    };
}

const I_: u32 = crate::isa::EXT_I;
const ZI: u32 = crate::isa::EXT_ZICSR;

static BASE: &[InstDef] = defs![
    ("lui", I_, U, 0x37, 0, 0, 0),
    ("auipc", I_, U, 0x17, 0, 0, 0),
    ("jal", I_, J, 0x6F, 0, 0, 0),
    ("jalr", I_, Jalr, 0x67, 0, 0, 0),
    ("beq", I_, B, 0x63, 0, 0, 0),
    ("bne", I_, B, 0x63, 1, 0, 0),
    ("blt", I_, B, 0x63, 4, 0, 0),
    ("bge", I_, B, 0x63, 5, 0, 0),
    ("bltu", I_, B, 0x63, 6, 0, 0),
    ("bgeu", I_, B, 0x63, 7, 0, 0),
    ("lb", I_, Ld, 0x03, 0, 0, 0),
    ("lh", I_, Ld, 0x03, 1, 0, 0),
    ("lw", I_, Ld, 0x03, 2, 0, 0),
    ("ld", I_, Ld, 0x03, 3, 0, 0),
    ("lbu", I_, Ld, 0x03, 4, 0, 0),
    ("lhu", I_, Ld, 0x03, 5, 0, 0),
    ("lwu", I_, Ld, 0x03, 6, 0, 0),
    ("sb", I_, St, 0x23, 0, 0, 0),
    ("sh", I_, St, 0x23, 1, 0, 0),
    ("sw", I_, St, 0x23, 2, 0, 0),
    ("sd", I_, St, 0x23, 3, 0, 0),
    ("addi", I_, I, 0x13, 0, 0, 0),
    ("slti", I_, I, 0x13, 2, 0, 0),
    ("sltiu", I_, I, 0x13, 3, 0, 0),
    ("xori", I_, I, 0x13, 4, 0, 0),
    ("ori", I_, I, 0x13, 6, 0, 0),
    ("andi", I_, I, 0x13, 7, 0, 0),
    ("slli", I_, Sh, 0x13, 1, 0x00, 0),
    ("srli", I_, Sh, 0x13, 5, 0x00, 0),
    ("srai", I_, Sh, 0x13, 5, 0x20, 0),
    ("add", I_, R, 0x33, 0, 0x00, 0),
    ("sub", I_, R, 0x33, 0, 0x20, 0),
    ("sll", I_, R, 0x33, 1, 0x00, 0),
    ("slt", I_, R, 0x33, 2, 0x00, 0),
    ("sltu", I_, R, 0x33, 3, 0x00, 0),
    ("xor", I_, R, 0x33, 4, 0x00, 0),
    ("srl", I_, R, 0x33, 5, 0x00, 0),
    ("sra", I_, R, 0x33, 5, 0x20, 0),
    ("or", I_, R, 0x33, 6, 0x00, 0),
    ("and", I_, R, 0x33, 7, 0x00, 0),
    ("addiw", I_, I, 0x1B, 0, 0, 0),
    ("slliw", I_, Sh, 0x1B, 1, 0x00, 0),
    ("srliw", I_, Sh, 0x1B, 5, 0x00, 0),
    ("sraiw", I_, Sh, 0x1B, 5, 0x20, 0),
    ("addw", I_, R, 0x3B, 0, 0x00, 0),
    ("subw", I_, R, 0x3B, 0, 0x20, 0),
    ("sllw", I_, R, 0x3B, 1, 0x00, 0),
    ("srlw", I_, R, 0x3B, 5, 0x00, 0),
    ("sraw", I_, R, 0x3B, 5, 0x20, 0),
    ("fence", I_, Fence, 0x0F, 0, 0, 0),
    ("fence.i", I_, Fixed, 0x0000100F, 0, 0, 0),
    ("ecall", I_, Fixed, 0x00000073, 0, 0, 0),
    ("ebreak", I_, Fixed, 0x00100073, 0, 0, 0),
    ("mret", I_, Fixed, 0x30200073, 0, 0, 0),
    ("sret", I_, Fixed, 0x10200073, 0, 0, 0),
    ("dret", I_, Fixed, 0x7B200073, 0, 0, 0),
    ("wfi", I_, Fixed, 0x10500073, 0, 0, 0),
    ("fence.tso", I_, Fixed, 0x8330000F, 0, 0, 0),
    ("pause", I_, Fixed, 0x0100000F, 0, 0, 0),
    ("sfence.vma", I_, Sfence, 0x73, 0, 0x09, 0),
    ("csrrw", ZI, Csr, 0x73, 1, 0, 0),
    ("csrrs", ZI, Csr, 0x73, 2, 0, 0),
    ("csrrc", ZI, Csr, 0x73, 3, 0, 0),
    ("csrrwi", ZI, CsrI, 0x73, 5, 0, 0),
    ("csrrsi", ZI, CsrI, 0x73, 6, 0, 0),
    ("csrrci", ZI, CsrI, 0x73, 7, 0, 0),
    ("mul", crate::isa::EXT_M, R, 0x33, 0, 0x01, 0),
    ("mulh", crate::isa::EXT_M, R, 0x33, 1, 0x01, 0),
    ("mulhsu", crate::isa::EXT_M, R, 0x33, 2, 0x01, 0),
    ("mulhu", crate::isa::EXT_M, R, 0x33, 3, 0x01, 0),
    ("div", crate::isa::EXT_M, R, 0x33, 4, 0x01, 0),
    ("divu", crate::isa::EXT_M, R, 0x33, 5, 0x01, 0),
    ("rem", crate::isa::EXT_M, R, 0x33, 6, 0x01, 0),
    ("remu", crate::isa::EXT_M, R, 0x33, 7, 0x01, 0),
    ("mulw", crate::isa::EXT_M, R, 0x3B, 0, 0x01, 0),
    ("divw", crate::isa::EXT_M, R, 0x3B, 4, 0x01, 0),
    ("divuw", crate::isa::EXT_M, R, 0x3B, 5, 0x01, 0),
    ("remw", crate::isa::EXT_M, R, 0x3B, 6, 0x01, 0),
    ("remuw", crate::isa::EXT_M, R, 0x3B, 7, 0x01, 0),
    ("lr.w", crate::isa::EXT_A, Lr, 0x2F, 2, 0x02, 0),
    ("lr.d", crate::isa::EXT_A, Lr, 0x2F, 3, 0x02, 0),
    ("sc.w", crate::isa::EXT_A, Amo, 0x2F, 2, 0x03, 0),
    ("sc.d", crate::isa::EXT_A, Amo, 0x2F, 3, 0x03, 0),
    ("amoswap.w", crate::isa::EXT_A, Amo, 0x2F, 2, 0x01, 0),
    ("amoswap.d", crate::isa::EXT_A, Amo, 0x2F, 3, 0x01, 0),
    ("amoadd.w", crate::isa::EXT_A, Amo, 0x2F, 2, 0x00, 0),
    ("amoadd.d", crate::isa::EXT_A, Amo, 0x2F, 3, 0x00, 0),
    ("amoxor.w", crate::isa::EXT_A, Amo, 0x2F, 2, 0x04, 0),
    ("amoxor.d", crate::isa::EXT_A, Amo, 0x2F, 3, 0x04, 0),
    ("amoand.w", crate::isa::EXT_A, Amo, 0x2F, 2, 0x0C, 0),
    ("amoand.d", crate::isa::EXT_A, Amo, 0x2F, 3, 0x0C, 0),
    ("amoor.w", crate::isa::EXT_A, Amo, 0x2F, 2, 0x08, 0),
    ("amoor.d", crate::isa::EXT_A, Amo, 0x2F, 3, 0x08, 0),
    ("amomin.w", crate::isa::EXT_A, Amo, 0x2F, 2, 0x10, 0),
    ("amomin.d", crate::isa::EXT_A, Amo, 0x2F, 3, 0x10, 0),
    ("amomax.w", crate::isa::EXT_A, Amo, 0x2F, 2, 0x14, 0),
    ("amomax.d", crate::isa::EXT_A, Amo, 0x2F, 3, 0x14, 0),
    ("amominu.w", crate::isa::EXT_A, Amo, 0x2F, 2, 0x18, 0),
    ("amominu.d", crate::isa::EXT_A, Amo, 0x2F, 3, 0x18, 0),
    ("amomaxu.w", crate::isa::EXT_A, Amo, 0x2F, 2, 0x1C, 0),
    ("amomaxu.d", crate::isa::EXT_A, Amo, 0x2F, 3, 0x1C, 0),
    ("fadd.s", crate::isa::EXT_F, FpAr, 0x53, 0, 0x00, 0),
    ("fadd.d", crate::isa::EXT_D, FpAr, 0x53, 0, 0x01, 0),
    ("fsub.s", crate::isa::EXT_F, FpAr, 0x53, 0, 0x04, 0),
    ("fsub.d", crate::isa::EXT_D, FpAr, 0x53, 0, 0x05, 0),
    ("fmul.s", crate::isa::EXT_F, FpAr, 0x53, 0, 0x08, 0),
    ("fmul.d", crate::isa::EXT_D, FpAr, 0x53, 0, 0x09, 0),
    ("fdiv.s", crate::isa::EXT_F, FpAr, 0x53, 0, 0x0C, 0),
    ("fdiv.d", crate::isa::EXT_D, FpAr, 0x53, 0, 0x0D, 0),
    ("fsqrt.s", crate::isa::EXT_F, F2F, 0x53, 0, 0x2C, 0),
    ("fsqrt.d", crate::isa::EXT_D, F2F, 0x53, 0, 0x2D, 0),
    ("fsgnj.s", crate::isa::EXT_F, Fp3, 0x53, 0, 0x10, 0),
    ("fsgnjn.s", crate::isa::EXT_F, Fp3, 0x53, 1, 0x10, 0),
    ("fsgnjx.s", crate::isa::EXT_F, Fp3, 0x53, 2, 0x10, 0),
    ("fsgnj.d", crate::isa::EXT_D, Fp3, 0x53, 0, 0x11, 0),
    ("fsgnjn.d", crate::isa::EXT_D, Fp3, 0x53, 1, 0x11, 0),
    ("fsgnjx.d", crate::isa::EXT_D, Fp3, 0x53, 2, 0x11, 0),
    ("fmin.s", crate::isa::EXT_F, Fp3, 0x53, 0, 0x14, 0),
    ("fmax.s", crate::isa::EXT_F, Fp3, 0x53, 1, 0x14, 0),
    ("fmin.d", crate::isa::EXT_D, Fp3, 0x53, 0, 0x15, 0),
    ("fmax.d", crate::isa::EXT_D, Fp3, 0x53, 1, 0x15, 0),
    ("fcvt.s.d", crate::isa::EXT_D, F2F, 0x53, 0, 0x20, 1),
    ("fcvt.d.s", crate::isa::EXT_F, F2F, 0x53, 0, 0x21, 0),
    ("fcvt.w.s", crate::isa::EXT_F, F2I, 0x53, 0, 0x60, 0),
    ("fcvt.wu.s", crate::isa::EXT_F, F2I, 0x53, 0, 0x60, 1),
    ("fcvt.l.s", crate::isa::EXT_F, F2I, 0x53, 0, 0x60, 2),
    ("fcvt.lu.s", crate::isa::EXT_F, F2I, 0x53, 0, 0x60, 3),
    ("fcvt.w.d", crate::isa::EXT_D, F2I, 0x53, 0, 0x61, 0),
    ("fcvt.wu.d", crate::isa::EXT_D, F2I, 0x53, 0, 0x61, 1),
    ("fcvt.l.d", crate::isa::EXT_D, F2I, 0x53, 0, 0x61, 2),
    ("fcvt.lu.d", crate::isa::EXT_D, F2I, 0x53, 0, 0x61, 3),
    ("fcvt.s.w", crate::isa::EXT_F, I2F, 0x53, 0, 0x68, 0),
    ("fcvt.s.wu", crate::isa::EXT_F, I2F, 0x53, 0, 0x68, 1),
    ("fcvt.s.l", crate::isa::EXT_F, I2F, 0x53, 0, 0x68, 2),
    ("fcvt.s.lu", crate::isa::EXT_F, I2F, 0x53, 0, 0x68, 3),
    ("fcvt.d.w", crate::isa::EXT_D, I2F, 0x53, 0, 0x69, 0),
    ("fcvt.d.wu", crate::isa::EXT_D, I2F, 0x53, 0, 0x69, 1),
    ("fcvt.d.l", crate::isa::EXT_D, I2F, 0x53, 0, 0x69, 2),
    ("fcvt.d.lu", crate::isa::EXT_D, I2F, 0x53, 0, 0x69, 3),
    ("fmv.x.w", crate::isa::EXT_F, MvF2I, 0x53, 0, 0x70, 0),
    ("fclass.s", crate::isa::EXT_F, FpClass, 0x53, 1, 0x70, 0),
    ("fmv.x.d", crate::isa::EXT_D, MvF2I, 0x53, 0, 0x71, 0),
    ("fclass.d", crate::isa::EXT_D, FpClass, 0x53, 1, 0x71, 0),
    ("fmv.w.x", crate::isa::EXT_F, MvI2F, 0x53, 0, 0x78, 0),
    ("fmv.d.x", crate::isa::EXT_D, MvI2F, 0x53, 0, 0x79, 0),
    ("fle.s", crate::isa::EXT_F, FpCmp, 0x53, 0, 0x50, 0),
    ("flt.s", crate::isa::EXT_F, FpCmp, 0x53, 1, 0x50, 0),
    ("feq.s", crate::isa::EXT_F, FpCmp, 0x53, 2, 0x50, 0),
    ("fle.d", crate::isa::EXT_D, FpCmp, 0x53, 0, 0x51, 0),
    ("flt.d", crate::isa::EXT_D, FpCmp, 0x53, 1, 0x51, 0),
    ("feq.d", crate::isa::EXT_D, FpCmp, 0x53, 2, 0x51, 0),
    ("flw", crate::isa::EXT_F, FpLd, 0x07, 2, 0, 0),
    ("fld", crate::isa::EXT_D, FpLd, 0x07, 3, 0, 0),
    ("fsw", crate::isa::EXT_F, FpSt, 0x27, 2, 0, 0),
    ("fsd", crate::isa::EXT_D, FpSt, 0x27, 3, 0, 0),
    ("fmadd.s", crate::isa::EXT_F, R4, 0x43, 0, 0, 0),
    ("fmsub.s", crate::isa::EXT_F, R4, 0x47, 0, 0, 0),
    ("fnmsub.s", crate::isa::EXT_F, R4, 0x4B, 0, 0, 0),
    ("fnmadd.s", crate::isa::EXT_F, R4, 0x4F, 0, 0, 0),
    ("fmadd.d", crate::isa::EXT_D, R4, 0x43, 1, 0, 0),
    ("fmsub.d", crate::isa::EXT_D, R4, 0x47, 1, 0, 0),
    ("fnmsub.d", crate::isa::EXT_D, R4, 0x4B, 1, 0, 0),
    ("fnmadd.d", crate::isa::EXT_D, R4, 0x4F, 1, 0, 0),
];

pub fn lookup(name: &str) -> Option<&'static InstDef> {
    BASE.iter().find(|d| d.name == name)
}

pub struct EncEnv<'a> {
    pub xlen: u8,
    pub exts: u32,
    pub relax: bool,
    pub final_pass: bool,
    pub cur_offset: u64,
    pub cur_section: usize,
    pub cur_section_sym: &'a str,
    pub lookup: &'a dyn Fn(&str) -> Option<SymInfo>,
    pub defined_in_file: &'a HashSet<String>,
}

pub struct EncOut {
    pub words: Vec<u32>,
    pub relocs: Vec<(u64, u32, String, i64)>,
    pub anon_defs: Vec<(String, u64)>,
    pub pcrel_ctr: u64,
}

impl EncOut {
    pub fn new(pcrel_base: u64) -> Self {
        EncOut { words: Vec::new(), relocs: Vec::new(), anon_defs: Vec::new(), pcrel_ctr: pcrel_base }
    }
    fn word(&mut self, w: u32) {
        self.words.push(w);
    }
    fn rel(&mut self, ty: u32, sym: &str, addend: i64) {
        let off = (self.words.len() as u64) * 4;
        self.relocs.push((off, ty, sym.to_string(), addend));
    }
    fn relax_here(&mut self, env: &EncEnv) {
        if env.relax {
            let off = (self.words.len() as u64) * 4;
            self.relocs.push((off, R_RISCV_RELAX, String::new(), 0));
        }
    }
    fn new_pcrel_sym(&mut self, at_word: u64) -> String {
        let n = format!(".L{} ", self.pcrel_ctr);
        self.pcrel_ctr += 1;
        self.anon_defs.push((n.clone(), at_word * 4));
        n
    }
}

fn r_t(op: u32, f3: u32, f7: u32, rd: u32, rs1: u32, rs2: u32) -> u32 {
    op | rd << 7 | f3 << 12 | rs1 << 15 | rs2 << 20 | f7 << 25
}

fn i_t(op: u32, f3: u32, rd: u32, rs1: u32, imm: i64) -> u32 {
    op | rd << 7 | f3 << 12 | rs1 << 15 | ((imm as u32) & 0xfff) << 20
}

fn s_t(op: u32, f3: u32, imm: i64, rs1: u32, rs2: u32) -> u32 {
    let i = (imm as u32) & 0xfff;
    op | rs2 << 20 | rs1 << 15 | f3 << 12 | (i & 0x1f) << 7 | (i >> 5) << 25
}

fn b_t(op: u32, f3: u32, imm: i64, rs1: u32, rs2: u32) -> u32 {
    let i = (imm as u32) & 0x1fff;
    op | rs2 << 20 | rs1 << 15 | f3 << 12
        | ((i >> 12) & 1) << 31
        | ((i >> 5) & 0x3f) << 25
        | ((i >> 1) & 0xf) << 8
        | ((i >> 11) & 1) << 7
}

fn u_t(op: u32, rd: u32, imm20: i64) -> u32 {
    op | rd << 7 | ((imm20 as u32) & 0xfffff) << 12
}

fn j_t(op: u32, rd: u32, imm: i64) -> u32 {
    let i = (imm as u32) & 0x1fffff;
    op | rd << 7
        | ((i >> 20) & 1) << 31
        | ((i >> 1) & 0x3ff) << 21
        | ((i >> 11) & 1) << 20
        | ((i >> 12) & 0xff) << 12
}

fn ext_missing(ext: u32, env: &EncEnv) -> Option<&'static str> {
    let (name, bit) = match ext {
        EXT_M => ("m", EXT_M),
        crate::isa::EXT_A => ("a", EXT_A),
        EXT_F => ("f", EXT_F),
        EXT_D => ("d", EXT_D),
        _ => return None,
    };
    if env.exts & bit == 0 {
        Some(name)
    } else {
        None
    }
}

fn eval(env: &EncEnv, e: &Expr) -> Result<Val, String> {
    expr::eval(e, &EvalCtx { lookup: env.lookup, cur_offset: env.cur_offset })
}

fn expr_of(op: &Operand) -> Result<&Expr, String> {
    match op {
        Operand::Expr(e) => Ok(e),
        Operand::Mem(..) => Err("unexpected memory operand here".into()),
        _ => Err("unexpected register operand here".into()),
    }
}

fn want_abs(env: &EncEnv, e: &Expr, what: &str) -> Result<i64, String> {
    match eval(env, e)? {
        Val::Abs(v) => Ok(v as i64),
        Val::Rel { sym, .. } => {
            if (env.lookup)(&sym).map_or(false, |i| i.defined) {
                Err(format!("{}: expression must be absolute (symbol '{}' is relocatable)", what, sym))
            } else if env.final_pass {
                Err(format!("symbol '{}' is undefined", sym))
            } else {
                Ok(0)
            }
        }
        Val::Mod { .. } => Err(format!("{}: unexpected %hi/%lo modifier here", what)),
    }
}

fn want_mem_off(
    env: &EncEnv,
    e: &Expr,
    s_type: bool,
) -> Result<(i64, Option<(u32, String, i64)>), String> {
    match eval(env, e)? {
        Val::Abs(v) => Ok((v as i64, None)),
        Val::Mod { kind, sym, addend } => {
            let ty = match kind {
                expr::RelocKind::RiscvLo12I => {
                    if s_type {
                        R_RISCV_LO12_S
                    } else {
                        R_RISCV_LO12_I
                    }
                }
                expr::RelocKind::RiscvPcrelLo12I => {
                    if s_type {
                        R_RISCV_PCREL_LO12_J
                    } else {
                        R_RISCV_PCREL_LO12_I
                    }
                }
                _ => return Err("unsupported relocation modifier in address offset".into()),
            };
            Ok((0, Some((ty, sym, addend as i64))))
        }
        Val::Rel { sym, .. } => {
            Err(format!("symbol '{}' requires %%lo()/%%hi() in address offset", sym))
        }
    }
}

fn parse_rm(op: &Operand) -> Result<u32, String> {
    match op {
        Operand::Expr(Expr::Sym(s)) => match s.as_str() {
            "rne" => Ok(0),
            "rtz" => Ok(1),
            "rdn" => Ok(2),
            "rup" => Ok(3),
            "rmm" => Ok(4),
            "dyn" => Ok(7),
            other => Err(format!("unknown rounding mode '{}'", other)),
        },
        Operand::Expr(Expr::Num(n)) if (0..=7).contains(n) => Ok(*n as u32),
        _ => Err("invalid rounding mode operand".into()),
    }
}

fn csr_value(env: &EncEnv, op: &Operand) -> Result<u32, String> {
    if let Operand::Expr(Expr::Sym(name)) = op {
        if let Some(v) = parse_csr(name) {
            if (env.lookup)(name).map_or(true, |i| !i.defined || !i.abs) {
                return Ok(v);
            }
        }
    }
    let v = want_abs(env, expr_of(op)?, "csr")?;
    if !(0..=0xfff).contains(&v) {
        return Err(format!("csr address 0x{:x} out of range", v));
    }
    Ok(v as u32)
}

fn check_imm(env: &EncEnv, v: i64, lo: i64, hi: i64, what: &str) -> Result<(), String> {
    if env.final_pass && (v < lo || v > hi) {
        return Err(format!("{} {} out of range [{},{}]", what, v, lo, hi));
    }
    Ok(())
}

pub fn assemble_insn(
    mnem: &str,
    ops: &[Operand],
    env: &EncEnv,
    out: &mut EncOut,
) -> Result<(), String> {
    if let Some(w) = lookup_pseudo_fixed(mnem) {
        if !ops.is_empty() {
            return Err(format!("'{}' takes no operands", mnem));
        }
        out.word(w);
        return Ok(());
    }
    if let Some((base, newops)) = rewrite_pseudo(mnem, ops)? {
        return encode_base(base, &newops, env, out);
    }
    match mnem {
        "li" => return emit_li(ops, env, out),
        "la" | "lla" => return emit_la(ops, env, out),
        "call" => return emit_call(ops, env, out, false),
        "tail" => return emit_call(ops, env, out, true),
        _ => {}
    }
    encode_base(mnem, ops, env, out)
}

fn lookup_pseudo_fixed(m: &str) -> Option<u32> {
    match m {
        "unimp" => Some(0xC0001073),
        _ => None,
    }
}

fn rewrite_pseudo(m: &str, ops: &[Operand]) -> Result<Option<(&'static str, Vec<Operand>)>, String> {
    let reg = |i: usize| -> Result<Operand, String> {
        match ops.get(i) {
            Some(Operand::RegI(r)) => Ok(Operand::RegI(*r)),
            Some(Operand::RegF(_)) => Err(format!("'{}' expects integer registers", m)),
            Some(_) => Err(format!("'{}': unexpected operand type", m)),
            None => Err(format!("'{}': wrong number of operands", m)),
        }
    };
    let e = |i: usize| -> Result<Operand, String> {
        match ops.get(i) {
            Some(o @ Operand::Expr(_)) => Ok(o.clone()),
            Some(Operand::Mem(..)) => Err(format!("'{}': unexpected memory operand", m)),
            Some(_) => Err(format!("'{}': unexpected register operand", m)),
            None => Err(format!("'{}': wrong number of operands", m)),
        }
    };
    let out: Option<(&'static str, Vec<Operand>)> = match m {
        "nop" => Some(("addi", vec![Operand::RegI(0), Operand::RegI(0), Operand::Expr(Expr::Num(0))])),
        "mv" => Some(("addi", vec![reg(0)?, reg(1)?, Operand::Expr(Expr::Num(0))])),
        "not" => Some(("xori", vec![reg(0)?, reg(1)?, Operand::Expr(Expr::Num(-1))])),
        "neg" => Some(("sub", vec![reg(0)?, Operand::RegI(0), reg(1)?])),
        "negw" => Some(("subw", vec![reg(0)?, Operand::RegI(0), reg(1)?])),
        "sext.w" => Some(("addiw", vec![reg(0)?, reg(1)?, Operand::Expr(Expr::Num(0))])),
        "seqz" => Some(("sltiu", vec![reg(0)?, reg(1)?, Operand::Expr(Expr::Num(1))])),
        "snez" => Some(("sltu", vec![reg(0)?, Operand::RegI(0), reg(1)?])),
        "sltz" => Some(("slt", vec![reg(0)?, reg(1)?, Operand::RegI(0)])),
        "sgtz" => Some(("slt", vec![reg(0)?, Operand::RegI(0), reg(1)?])),
        "beqz" => Some(("beq", vec![reg(0)?, Operand::RegI(0), e(1)?])),
        "bnez" => Some(("bne", vec![reg(0)?, Operand::RegI(0), e(1)?])),
        "blez" => Some(("bge", vec![Operand::RegI(0), reg(0)?, e(1)?])),
        "bgez" => Some(("bge", vec![reg(0)?, Operand::RegI(0), e(1)?])),
        "bltz" => Some(("blt", vec![reg(0)?, Operand::RegI(0), e(1)?])),
        "bgtz" => Some(("blt", vec![Operand::RegI(0), reg(0)?, e(1)?])),
        "bgt" => Some(("blt", vec![reg(1)?, reg(0)?, e(2)?])),
        "ble" => Some(("bge", vec![reg(1)?, reg(0)?, e(2)?])),
        "bgtu" => Some(("bltu", vec![reg(1)?, reg(0)?, e(2)?])),
        "bleu" => Some(("bgeu", vec![reg(1)?, reg(0)?, e(2)?])),
        "j" => Some(("jal", vec![Operand::RegI(0), e(0)?])),
        "jr" => Some(("jalr", vec![Operand::RegI(0), Operand::Mem(Expr::Num(0), reg_int(ops, 0)?)])),
        "ret" => Some(("jalr", vec![Operand::RegI(0), Operand::Mem(Expr::Num(0), 1)])),
        "csrr" => Some(("csrrs", vec![reg(0)?, e(1)?, Operand::RegI(0)])),
        "csrw" => Some(("csrrw", vec![Operand::RegI(0), e(0)?, reg(1)?])),
        "csrs" => Some(("csrrs", vec![Operand::RegI(0), e(0)?, reg(1)?])),
        "csrc" => Some(("csrrc", vec![Operand::RegI(0), e(0)?, reg(1)?])),
        "csrwi" => Some(("csrrwi", vec![Operand::RegI(0), e(0)?, reg(1)?])),
        "csrsi" => Some(("csrrsi", vec![Operand::RegI(0), e(0)?, reg(1)?])),
        "csrci" => Some(("csrrci", vec![Operand::RegI(0), e(0)?, reg(1)?])),
        "rdcycle" => Some(("csrrs", vec![reg(0)?, Operand::Expr(Expr::Num(0xC00)), Operand::RegI(0)])),
        "rdtime" => Some(("csrrs", vec![reg(0)?, Operand::Expr(Expr::Num(0xC01)), Operand::RegI(0)])),
        "rdinstret" => Some(("csrrs", vec![reg(0)?, Operand::Expr(Expr::Num(0xC02)), Operand::RegI(0)])),
        "fmv.s" | "fmv.d" | "fneg.s" | "fneg.d" | "fabs.s" | "fabs.d" => {
            let (rd, rs) = match (ops.get(0), ops.get(1), ops.get(2)) {
                (Some(Operand::RegF(a)), Some(Operand::RegF(b)), None) => (*a, *b),
                _ => return Err(format!("'{}' expects two floating point registers", m)),
            };
            let base: &'static str = match m {
                "fmv.s" => "fsgnj.s",
                "fmv.d" => "fsgnj.d",
                "fneg.s" => "fsgnjn.s",
                "fneg.d" => "fsgnjn.d",
                "fabs.s" => "fsgnjx.s",
                _ => "fsgnjx.d",
            };
            Some((base, vec![Operand::RegF(rd), Operand::RegF(rs), Operand::RegF(rs)]))
        }
        _ => None,
    };
    Ok(out)
}

fn reg_int(ops: &[Operand], i: usize) -> Result<u32, String> {
    match ops.get(i) {
        Some(Operand::RegI(r)) => Ok(*r),
        _ => Err("expected integer register".into()),
    }
}

fn emit_li(ops: &[Operand], env: &EncEnv, out: &mut EncOut) -> Result<(), String> {
    let rd = reg_int(ops, 0).map_err(|_| "'li' expects an integer register".to_string())?;
    let e = match ops.get(1) {
        Some(Operand::Expr(e)) => e,
        _ => return Err("'li' expects an immediate".into()),
    };
    let v128 = want_abs(env, e, "li")?;
    let v: i64 = if env.xlen == 32 { v128 as i32 as i64 } else { v128 as i64 };
    li_seq(rd, v, env, out);
    Ok(())
}

fn li_seq(rd: u32, v: i64, env: &EncEnv, out: &mut EncOut) {
    if v >= -2048 && v <= 2047 {
        out.word(i_t(0x13, 0, rd, 0, v));
        return;
    }
    let fits32 = v >= i32::MIN as i64 && v <= i32::MAX as i64;
    if env.xlen == 32 || fits32 {
        let hi = ((v + 0x800) >> 12) & 0xfffff;
        let lo = {
            let x = v & 0xfff;
            if x & 0x800 != 0 { x - 0x1000 } else { x }
        };
        out.word(u_t(0x37, rd, hi));
        if lo != 0 {
            let op = if env.xlen == 64 { 0x1B } else { 0x13 };
            out.word(i_t(op, 0, rd, rd, lo));
        }
        return;
    }
    let hi = (v + 0x800) >> 12;
    let lo = v - (hi << 12);
    li_seq(rd, hi, env, out);
    out.word(i_t(0x13, 1, rd, rd, 12));
    if lo != 0 {
        out.word(i_t(0x13, 0, rd, rd, lo));
    }
}

fn want_rel_target(env: &EncEnv, e: &Expr) -> Result<Option<(String, i64)>, String> {
    match eval(env, e)? {
        Val::Rel { sym, addend } => Ok(Some((sym, addend as i64))),
        Val::Abs(_) => Ok(None),
        Val::Mod { .. } => Err("unexpected %hi/%lo modifier in branch/jump target".into()),
    }
}

fn emit_la(ops: &[Operand], env: &EncEnv, out: &mut EncOut) -> Result<(), String> {
    let rd = reg_int(ops, 0).map_err(|_| "'la' expects an integer register".to_string())?;
    let e = match ops.get(1) {
        Some(Operand::Expr(e)) => e,
        _ => return Err("'la' expects an address expression".into()),
    };
    let (sym, addend) = match want_rel_target(env, e)? {
        Some(p) => p,
        None => return Err("'la' requires a symbol".into()),
    };
    let hi_sym = if sym == expr::DOT_SYM { env.cur_section_sym.to_string() } else { sym };
    out.rel(R_RISCV_PCREL_HI20, &hi_sym, addend);
    out.relax_here(env);
    out.word(u_t(0x17, rd, 0));
    let lo_sym = out.new_pcrel_sym(0);
    out.rel(R_RISCV_PCREL_LO12_I, &lo_sym, 0);
    out.relax_here(env);
    out.word(i_t(0x13, 0, rd, rd, 0));
    Ok(())
}

fn emit_call(ops: &[Operand], env: &EncEnv, out: &mut EncOut, is_tail: bool) -> Result<(), String> {
    let e = match ops.get(0) {
        Some(Operand::Expr(e)) => e,
        _ => return Err("'call'/'tail' expects a symbol".into()),
    };
    let (sym, addend) = match want_rel_target(env, e)? {
        Some(p) => p,
        None => return Err("'call'/'tail' requires a symbol".into()),
    };
    let tmp = if is_tail { 6 } else { 1 };
    let rd = if is_tail { 0 } else { 1 };
    out.rel(R_RISCV_CALL_PLT, &sym, addend);
    out.relax_here(env);
    out.word(u_t(0x17, tmp, 0));
    out.word(i_t(0x67, 0, rd, tmp, 0));
    Ok(())
}

fn load_with_sym(
    d: &InstDef,
    rd: u32,
    sym: &str,
    addend: i64,
    env: &EncEnv,
    out: &mut EncOut,
) {
    let hi_sym = if sym == expr::DOT_SYM { env.cur_section_sym.to_string() } else { sym.to_string() };
    out.rel(R_RISCV_PCREL_HI20, &hi_sym, addend);
    out.relax_here(env);
    out.word(u_t(0x17, rd, 0));
    let lo_sym = out.new_pcrel_sym(0);
    out.rel(R_RISCV_PCREL_LO12_I, &lo_sym, 0);
    out.relax_here(env);
    out.word(i_t(d.op, d.f3, rd, rd, 0));
}

fn emit_branch(f3: u32, rs1: u32, rs2: u32, e: &Expr, env: &EncEnv, out: &mut EncOut) -> Result<(), String> {
    let val = eval(env, e)?;
    match val {
        Val::Rel { sym, addend } if sym == expr::DOT_SYM => {
            let delta = addend as i64 - env.cur_offset as i64;
            if env.final_pass {
                check_imm(env, delta, -4096, 4094, "branch target")?;
            }
            out.rel(R_RISCV_BRANCH, env.cur_section_sym, addend as i64);
            out.word(b_t(0x63, f3, delta, rs1, rs2));
            Ok(())
        }
        Val::Rel { sym, addend } => {
            let info = (env.lookup)(&sym);
            let in_file = env.defined_in_file.contains(&sym);
            if in_file && info.as_ref().map_or(false, |i| i.defined) {
                let info = info.unwrap();
                let delta = if info.sec == env.cur_section {
                    (info.value as i64) + addend as i64 - env.cur_offset as i64
                } else {
                    0
                };
                if info.sec == env.cur_section && env.final_pass {
                    check_imm(env, delta, -4096, 4094, "branch target")?;
                }
                out.rel(R_RISCV_BRANCH, &sym, addend as i64);
                out.word(b_t(0x63, f3, delta, rs1, rs2));
                Ok(())
            } else if in_file {
                out.rel(R_RISCV_BRANCH, &sym, addend as i64);
                out.word(b_t(0x63, f3, 0, rs1, rs2));
                Ok(())
            } else {
                out.word(b_t(0x63, f3 ^ 1, 8, rs1, rs2));
                out.rel(R_RISCV_JAL, &sym, addend as i64);
                out.word(j_t(0x6F, 0, 0));
                Ok(())
            }
        }
        Val::Abs(v) => {
            out.word(b_t(0x63, f3 ^ 1, 8, rs1, rs2));
            out.rel(R_RISCV_JAL, ABS_SYM, v as i64);
            out.word(j_t(0x6F, 0, 0));
            Ok(())
        }
        Val::Mod { kind, .. } => {
            Err(format!("unsupported relocation modifier {:?} in branch target", kind))
        }
    }
}

fn jump_target(e: &Expr, env: &EncEnv) -> Result<(i64, Option<(u32, String, i64)>), String> {
    match eval(env, e)? {
        Val::Rel { sym, addend } if sym == expr::DOT_SYM => {
            let delta = addend as i64 - env.cur_offset as i64;
            Ok((delta, Some((R_RISCV_JAL, env.cur_section_sym.to_string(), addend as i64))))
        }
        Val::Rel { sym, addend } => {
            let info = (env.lookup)(&sym);
            if info.as_ref().map_or(false, |i| i.defined) {
                let info = info.unwrap();
                if info.abs {
                    Ok((0, Some((R_RISCV_JAL, ABS_SYM.to_string(), (info.value + addend as i128) as i64))))
                } else if info.sec == env.cur_section {
                    let delta = (info.value as i64) + addend as i64 - env.cur_offset as i64;
                    if env.final_pass {
                        check_imm(env, delta, -1048576, 1048574, "jump target")?;
                    }
                    Ok((delta, Some((R_RISCV_JAL, sym, addend as i64))))
                } else {
                    Ok((0, Some((R_RISCV_JAL, sym, addend as i64))))
                }
            } else {
                Ok((0, Some((R_RISCV_JAL, sym, addend as i64))))
            }
        }
        Val::Abs(v) => Ok((0, Some((R_RISCV_JAL, ABS_SYM.to_string(), v as i64)))),
        Val::Mod { kind, .. } => Err(format!("unsupported relocation modifier {:?} in jump target", kind)),
    }
}

fn encode_base(m: &str, ops: &[Operand], env: &EncEnv, out: &mut EncOut) -> Result<(), String> {
    let (name, aq, rl) = split_amo_suffix(m)?;
    let d = lookup(name).ok_or_else(|| format!("unknown instruction '{}'", m))?;
    if let Some(ext) = ext_missing(d.ext, env) {
        return Err(format!(
            "instruction '{}' requires the '{}' extension (use -march with {})",
            m, ext, ext
        ));
    }
    let amo_bits = (d.f7 << 2) | (aq << 1) | rl;
    match d.kind {
        Kind::Fixed => {
            if !ops.is_empty() {
                return Err(format!("'{}' takes no operands", m));
            }
            out.word(d.op);
        }
        Kind::Fence => {
            let get_bits = |i: usize| -> Result<u32, String> {
                match ops.get(i) {
                    Some(Operand::Expr(Expr::Sym(s))) => Ok(fence_bits(s)),
                    None => Ok(0xf),
                    _ => Err(format!("'{}': expected privilege string like iorw", m)),
                }
            };
            let pred = get_bits(0)?;
            let succ = if ops.len() > 1 { get_bits(1)? } else { 0xf };
            if ops.len() > 2 {
                return Err(format!("'{}': too many operands", m));
            }
            out.word(i_t(d.op, 0, 0, 0, ((pred as i64) << 4) | succ as i64));
        }
        Kind::Sfence => {
            let (rs1, rs2) = match ops.len() {
                0 => (0, 0),
                1 => (reg_i(&ops[0])?, 0),
                2 => (reg_i(&ops[0])?, reg_i(&ops[1])?),
                _ => return Err(format!("'{}': too many operands", m)),
            };
            out.word(r_t(d.op, 0, d.f7, 0, rs1, rs2));
        }
        Kind::R => {
            if ops.len() != 3 {
                return Err(format!("'{}' expects 3 operands", m));
            }
            out.word(r_t(d.op, d.f3, d.f7, reg_i(&ops[0])?, reg_i(&ops[1])?, reg_i(&ops[2])?));
        }
        Kind::I => {
            if ops.len() != 3 {
                return Err(format!("'{}' expects 3 operands", m));
            }
            let rd = reg_i(&ops[0])?;
            let rs1 = reg_i(&ops[1])?;
            let imm = match eval(env, expr_of(&ops[2])?)? {
                Val::Abs(v) => v as i64,
                Val::Mod { kind, sym, addend } => match kind {
                    expr::RelocKind::RiscvLo12I => {
                        out.rel(R_RISCV_LO12_I, &sym, addend as i64);
                        out.relax_here(env);
                        0
                    }
                    expr::RelocKind::RiscvPcrelLo12I => {
                        out.rel(R_RISCV_PCREL_LO12_I, &sym, addend as i64);
                        out.relax_here(env);
                        0
                    }
                    _ => return Err(format!("'{}': unsupported relocation modifier", m)),
                },
                Val::Rel { sym, .. } => {
                    return Err(format!("'{}': symbol '{}' needs %%lo() or a constant", m, sym));
                }
            };
            check_imm(env, imm, -2048, 2047, "immediate")?;
            out.word(i_t(d.op, d.f3, rd, rs1, imm));
        }
        Kind::Sh => {
            if ops.len() != 3 {
                return Err(format!("'{}' expects 3 operands", m));
            }
            let rd = reg_i(&ops[0])?;
            let rs1 = reg_i(&ops[1])?;
            let sh = want_abs(env, expr_of(&ops[2])?, "shift amount")?;
            let bits: u32 = if env.xlen == 64 && !name.ends_with('w') { 6 } else { 5 };
            check_imm(env, sh, 0, (1i64 << bits) - 1, "shift amount")?;
            let imm = if bits == 6 {
                ((d.f7 >> 1) << 6) | ((sh as u32) & 0x3f)
            } else {
                (d.f7 << 5) | ((sh as u32) & 0x1f)
            };
            out.word(d.op | rd << 7 | d.f3 << 12 | rs1 << 15 | (imm & 0xfff) << 20);
        }
        Kind::Ld | Kind::FpLd => {
            let rd = match (d.kind, ops.get(0)) {
                (Kind::Ld, Some(Operand::RegI(r))) => *r,
                (Kind::FpLd, Some(Operand::RegF(r))) => *r,
                _ => return Err(format!("'{}': bad destination register", m)),
            };
            match ops.get(1) {
                Some(Operand::Mem(off, base)) => {
                    let (imm, rel) = want_mem_off(env, off, false)?;
                    if let Some((ty, sym, addend)) = rel {
                        out.rel(ty, &sym, addend);
                        out.relax_here(env);
                    }
                    check_imm(env, imm, -2048, 2047, "offset")?;
                    out.word(i_t(d.op, d.f3, rd, *base, imm));
                }
                Some(o @ Operand::Expr(_)) => {
                    let (sym, addend) = match want_rel_target(env, expr_of(o)?)? {
                        Some(p) => p,
                        None => return Err(format!("'{}': illegal operands", m)),
                    };
                    load_with_sym(d, rd, &sym, addend, env, out);
                }
                _ => return Err(format!("'{}': illegal operands", m)),
            };
        }
        Kind::St | Kind::FpSt => {
            let rs2 = match (d.kind, ops.get(0)) {
                (Kind::St, Some(Operand::RegI(r))) => *r,
                (Kind::FpSt, Some(Operand::RegF(r))) => *r,
                _ => return Err(format!("'{}': bad source register", m)),
            };
            match ops.get(1) {
                Some(Operand::Mem(off, base)) => {
                    let (imm, rel) = want_mem_off(env, off, true)?;
                    if let Some((ty, sym, addend)) = rel {
                        out.rel(ty, &sym, addend);
                        out.relax_here(env);
                    }
                    check_imm(env, imm, -2048, 2047, "offset")?;
                    out.word(s_t(d.op, d.f3, imm, *base, rs2));
                }
                _ => return Err(format!("'{}': illegal operands (stores need offset(base))", m)),
            }
        }
        Kind::B => {
            if ops.len() != 3 {
                return Err(format!("'{}' expects 3 operands", m));
            }
            let rs1 = reg_i(&ops[0])?;
            let rs2 = reg_i(&ops[1])?;
            emit_branch(d.f3, rs1, rs2, expr_of(&ops[2])?, env, out)?;
        }
        Kind::U => {
            if ops.len() != 2 {
                return Err(format!("'{}' expects 2 operands", m));
            }
            let rd = reg_i(&ops[0])?;
            match eval(env, expr_of(&ops[1])?)? {
                Val::Abs(v) => {
                    check_imm(env, v as i64, 0, 0xfffff, "immediate")?;
                    out.word(u_t(d.op, rd, v as i64));
                }
                Val::Mod { kind, sym, addend } => {
                    let ty = match kind {
                        expr::RelocKind::RiscvHi20 => R_RISCV_HI20,
                        expr::RelocKind::RiscvPcrelHi20 => R_RISCV_PCREL_HI20,
                        _ => return Err(format!("'{}': unsupported relocation modifier", m)),
                    };
                    out.rel(ty, &sym, addend as i64);
                    out.relax_here(env);
                    out.word(u_t(d.op, rd, 0));
                }
                Val::Rel { sym, .. } => {
                    return Err(format!("'{}': symbol '{}' needs %%hi() or a constant", m, sym));
                }
            }
        }
        Kind::J => {
            let (rd, te) = match ops {
                [Operand::RegI(rd), o] => (*rd, expr_of(o)?),
                [o] => (1, expr_of(o)?),
                _ => return Err(format!("'{}': illegal operands", m)),
            };
            let (imm, rel) = jump_target(te, env)?;
            if let Some((ty, sym, addend)) = rel {
                out.rel(ty, &sym, addend);
            }
            out.word(j_t(d.op, rd, imm));
        }
        Kind::Jalr => {
            let (rd, rs1, imm) = match ops {
                [Operand::RegI(rd), Operand::Mem(off, base)] => {
                    let (imm, rel) = want_mem_off(env, off, false)?;
                    if let Some((ty, sym, addend)) = rel {
                        out.rel(ty, &sym, addend);
                    }
                    check_imm(env, imm, -2048, 2047, "offset")?;
                    (*rd, *base, imm)
                }
                [Operand::RegI(rd), Operand::RegI(rs)] => (*rd, *rs, 0),
                [Operand::RegI(rd), Operand::RegI(rs), o] => {
                    let imm = want_abs(env, expr_of(o)?, "offset")?;
                    check_imm(env, imm, -2048, 2047, "offset")?;
                    (*rd, *rs, imm)
                }
                [Operand::RegI(rs)] => (1, *rs, 0),
                _ => return Err(format!("'{}': illegal operands", m)),
            };
            out.word(i_t(d.op, 0, rd, rs1, imm));
        }
        Kind::R4 => {
            if ops.len() != 4 && ops.len() != 5 {
                return Err(format!("'{}' expects 4 operands", m));
            }
            let rd = reg_f(&ops[0])?;
            let rs1 = reg_f(&ops[1])?;
            let rs2 = reg_f(&ops[2])?;
            let rs3 = reg_f(&ops[3])?;
            let rm = if ops.len() == 5 { parse_rm(&ops[4])? } else { 7 };
            out.word(d.op | rd << 7 | rm << 12 | rs1 << 15 | rs2 << 20 | d.f3 << 25 | rs3 << 27);
        }
        Kind::Amo | Kind::Lr => {
            if d.kind == Kind::Lr {
                if ops.len() != 2 {
                    return Err(format!("'{}' expects 2 operands", m));
                }
                let rd = reg_i(&ops[0])?;
                let (base, offv) = match ops.get(1) {
                    Some(Operand::Mem(off, base)) => (*base, want_abs(env, off, "offset")?),
                    _ => return Err(format!("'{}': illegal operands", m)),
                };
                if offv != 0 {
                    return Err(format!("'{}': offset must be 0", m));
                }
                out.word(r_t(d.op, d.f3, amo_bits, rd, base, 0));
            } else {
                if ops.len() != 3 {
                    return Err(format!("'{}' expects 3 operands", m));
                }
                let rd = reg_i(&ops[0])?;
                let rs2 = reg_i(&ops[1])?;
                let (base, offv) = match ops.get(2) {
                    Some(Operand::Mem(off, base)) => (*base, want_abs(env, off, "offset")?),
                    _ => return Err(format!("'{}': illegal operands", m)),
                };
                if offv != 0 {
                    return Err(format!("'{}': offset must be 0", m));
                }
                out.word(r_t(d.op, d.f3, amo_bits, rd, base, rs2));
            }
        }
        Kind::Csr | Kind::CsrI => {
            if ops.len() != 3 {
                return Err(format!("'{}' expects 3 operands", m));
            }
            let rd = reg_i(&ops[0])?;
            let csr = csr_value(env, &ops[1])?;
            if d.kind == Kind::Csr {
                let rs1 = reg_i(&ops[2])?;
                out.word(i_t(d.op, d.f3, rd, rs1, csr as i64));
            } else {
                let u = want_abs(env, expr_of(&ops[2])?, "csr immediate")?;
                check_imm(env, u, 0, 31, "csr immediate")?;
                out.word(i_t(d.op, d.f3, rd, u as u32, csr as i64));
            }
        }
        Kind::FpAr => {
            if ops.len() != 3 && ops.len() != 4 {
                return Err(format!("'{}' expects 3 operands", m));
            }
            let rd = reg_f(&ops[0])?;
            let rs1 = reg_f(&ops[1])?;
            let rs2 = reg_f(&ops[2])?;
            let rm = if ops.len() == 4 { parse_rm(&ops[3])? } else { 7 };
            out.word(r_t(d.op, rm, d.f7, rd, rs1, rs2));
        }
        Kind::Fp3 => {
            if ops.len() != 3 {
                return Err(format!("'{}' expects 3 operands", m));
            }
            out.word(r_t(d.op, d.f3, d.f7, reg_f(&ops[0])?, reg_f(&ops[1])?, reg_f(&ops[2])?));
        }
        Kind::FpCmp => {
            if ops.len() != 3 {
                return Err(format!("'{}' expects 3 operands", m));
            }
            out.word(r_t(d.op, d.f3, d.f7, reg_i(&ops[0])?, reg_f(&ops[1])?, reg_f(&ops[2])?));
        }
        Kind::FpClass => {
            if ops.len() != 2 {
                return Err(format!("'{}' expects 2 operands", m));
            }
            out.word(r_t(d.op, d.f3, d.f7, reg_i(&ops[0])?, reg_f(&ops[1])?, 0));
        }
        Kind::F2I | Kind::I2F | Kind::F2F => {
            if ops.len() != 2 && ops.len() != 3 {
                return Err(format!("'{}' expects 2 operands", m));
            }
            let def_rm = if d.kind == Kind::F2F && (d.f7 == 0x20 || d.f7 == 0x21) { 0 } else { 7 };
            let rm = if ops.len() == 3 { parse_rm(&ops[2])? } else { def_rm };
            match d.kind {
                Kind::F2I => out.word(r_t(d.op, rm, d.f7, reg_i(&ops[0])?, reg_f(&ops[1])?, d.rs2)),
                Kind::I2F => out.word(r_t(d.op, rm, d.f7, reg_f(&ops[0])?, reg_i(&ops[1])?, d.rs2)),
                _ => out.word(r_t(d.op, rm, d.f7, reg_f(&ops[0])?, reg_f(&ops[1])?, d.rs2)),
            }
        }
        Kind::MvI2F => {
            if ops.len() != 2 {
                return Err(format!("'{}' expects 2 operands", m));
            }
            out.word(r_t(d.op, 0, d.f7, reg_f(&ops[0])?, reg_i(&ops[1])?, 0));
        }
        Kind::MvF2I => {
            if ops.len() != 2 {
                return Err(format!("'{}' expects 2 operands", m));
            }
            out.word(r_t(d.op, 0, d.f7, reg_i(&ops[0])?, reg_f(&ops[1])?, 0));
        }
    }
    Ok(())
}

fn reg_i(op: &Operand) -> Result<u32, String> {
    match op {
        Operand::RegI(r) => Ok(*r),
        Operand::RegF(_) => Err("expected integer register, got floating point register".into()),
        _ => Err("expected integer register".into()),
    }
}

fn reg_f(op: &Operand) -> Result<u32, String> {
    match op {
        Operand::RegF(r) => Ok(*r),
        Operand::RegI(_) => Err("expected floating point register, got integer register".into()),
        _ => Err("expected floating point register".into()),
    }
}

fn fence_bits(s: &str) -> u32 {
    let mut v = 0;
    for c in s.chars() {
        match c {
            'i' => v |= 8,
            'o' => v |= 4,
            'r' => v |= 2,
            'w' => v |= 1,
            _ => {}
        }
    }
    v
}

fn split_amo_suffix(m: &str) -> Result<(&str, u32, u32), String> {
    for (sfx, aq, rl) in [(".aqrl", 1u32, 1u32), (".aq", 1, 0), (".rl", 0, 1)] {
        if let Some(base) = m.strip_suffix(sfx) {
            if base.starts_with("amo") || base.starts_with("lr.") || base.starts_with("sc.") {
                return Ok((base, aq, rl));
            }
        }
    }
    Ok((m, 0, 0))
}
