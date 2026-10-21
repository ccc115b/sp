use std::collections::HashMap;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum RelocKind {
    RiscvPcrelHi20,
    RiscvPcrelLo12I,
    RiscvPcrelLo12J,
    RiscvHi20,
    RiscvLo12I,
    RiscvLo12S,
}

#[derive(Debug, Clone)]
pub enum Expr {
    Num(i128),
    Sym(String),
    Dot,
    Bin(BinOp, Box<Expr>, Box<Expr>),
    Neg(Box<Expr>),
    Not(Box<Expr>),
    Reloc(RelocKind, Box<Expr>),
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum BinOp {
    Add,
    Sub,
    Mul,
    Div,
    Mod,
    Shl,
    Shr,
    And,
    Or,
    Xor,
}

#[derive(Debug, Clone, PartialEq)]
pub enum Val {
    Abs(i128),
    Rel { sym: String, addend: i128 },
    Mod { kind: RelocKind, sym: String, addend: i128 },
}

impl Val {
    pub fn abs(&self) -> Option<i128> {
        match self {
            Val::Abs(v) => Some(*v),
            _ => None,
        }
    }
}

pub struct EvalCtx<'a> {
    pub symbols: &'a HashMap<String, SymInfo>,
    pub cur_offset: u64,
}

#[derive(Debug, Clone)]
pub struct SymInfo {
    pub defined: bool,
    pub abs: bool,
    pub value: i128,
}

pub fn eval(e: &Expr, ctx: &EvalCtx) -> Result<Val, String> {
    match e {
        Expr::Num(n) => Ok(Val::Abs(*n)),
        Expr::Dot => Ok(Val::Abs(ctx.cur_offset as i128)),
        Expr::Sym(name) => {
            if let Some(s) = ctx.symbols.get(name) {
                if s.defined && s.abs {
                    return Ok(Val::Abs(s.value));
                }
            }
            Ok(Val::Rel { sym: name.clone(), addend: 0 })
        }
        Expr::Neg(x) => match eval(x, ctx)? {
            Val::Abs(v) => Ok(Val::Abs(-v)),
            _ => Err("cannot negate a relocatable expression".into()),
        },
        Expr::Not(x) => match eval(x, ctx)? {
            Val::Abs(v) => Ok(Val::Abs(!v)),
            _ => Err("cannot complement a relocatable expression".into()),
        },
        Expr::Reloc(kind, inner) => {
            let v = eval(inner, ctx)?;
            match v {
                Val::Rel { sym, addend } => Ok(Val::Mod { kind, sym, addend }),
                Val::Abs(_) => Err("%hi/%lo relocation requires a symbol".into()),
                Val::Mod { .. } => Err("nested relocation modifier".into()),
            }
        }
        Expr::Bin(op, a, b) => {
            let va = eval(a, ctx)?;
            let vb = eval(b, ctx)?;
            binop(*op, va, vb)
        }
    }
}

fn binop(op: BinOp, a: Val, b: Val) -> Result<Val, String> {
    match (a, b) {
        (Val::Abs(x), Val::Abs(y)) => {
            let v = match op {
                BinOp::Add => x.wrapping_add(y),
                BinOp::Sub => x.wrapping_sub(y),
                BinOp::Mul => x.wrapping_mul(y),
                BinOp::Div => {
                    if y == 0 {
                        return Err("division by zero".into());
                    }
                    x.wrapping_div(y)
                }
                BinOp::Mod => {
                    if y == 0 {
                        return Err("division by zero".into());
                    }
                    x.wrapping_rem(y)
                }
                BinOp::Shl => x.wrapping_shl(y as u32),
                BinOp::Shr => x.wrapping_shr(y as u32),
                BinOp::And => x & y,
                BinOp::Or => x | y,
                BinOp::Xor => x ^ y,
            };
            Ok(Val::Abs(v))
        }
        (Val::Rel { sym, addend }, Val::Abs(y)) => match op {
            BinOp::Add => Ok(Val::Rel { sym, addend: addend.wrapping_add(y) }),
            BinOp::Sub => Ok(Val::Rel { sym, addend: addend.wrapping_sub(y) }),
            _ => Err("invalid arithmetic on relocatable symbol".into()),
        },
        (Val::Abs(x), Val::Rel { sym, addend }) => match op {
            BinOp::Add => Ok(Val::Rel { sym, addend: addend.wrapping_add(x) }),
            _ => Err("invalid arithmetic on relocatable symbol".into()),
        },
        (Val::Mod { kind, sym, addend }, Val::Abs(y)) => match op {
            BinOp::Add => Ok(Val::Mod { kind, sym, addend: addend.wrapping_add(y) }),
            BinOp::Sub => Ok(Val::Mod { kind, sym, addend: addend.wrapping_sub(y) }),
            _ => Err("invalid arithmetic on relocation expression".into()),
        },
        _ => Err("cannot combine two relocatable expressions".into()),
    }
}
