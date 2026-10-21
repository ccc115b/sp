//! bytecode 直譯器：載入 Code attribute 並逐步執行。

use std::cell::RefCell;
use std::rc::Rc;

use crate::classfile::{ClassFile, Const};
use crate::Res;

// ───────────────────────── 執行期值 ─────────────────────────

#[derive(Clone)]
pub enum Value {
    Int(i32),
    Str(Rc<str>),
    Arr(Rc<RefCell<Vec<i32>>>),
    Out, // System.out
    Null,
}

impl Value {
    fn int(&self) -> Res<i32> {
        match self {
            Value::Int(v) => Ok(*v),
            _ => Err("expected int on stack".into()),
        }
    }
    fn arr(&self) -> Res<Rc<RefCell<Vec<i32>>>> {
        match self {
            Value::Arr(a) => Ok(a.clone()),
            Value::Null => Err("java.lang.NullPointerException".into()),
            _ => Err("expected array on stack".into()),
        }
    }
    fn same_ref(&self, o: &Value) -> bool {
        match (self, o) {
            (Value::Null, Value::Null) | (Value::Out, Value::Out) => true,
            (Value::Str(a), Value::Str(b)) => Rc::ptr_eq(a, b),
            (Value::Arr(a), Value::Arr(b)) => Rc::ptr_eq(a, b),
            _ => false,
        }
    }
}

// ───────────────────────── 直譯器 ─────────────────────────

const MAX_DEPTH: usize = 3000;

pub struct Vm {
    class: Rc<ClassFile>,
    trace: bool,
    depth: usize,
}

impl Vm {
    pub fn new(class: Rc<ClassFile>, trace: bool) -> Vm {
        Vm { class, trace, depth: 0 }
    }

    pub fn invoke(&mut self, mi: usize, args: Vec<Value>) -> Res<Option<Value>> {
        if self.depth >= MAX_DEPTH {
            return Err("java.lang.StackOverflowError".into());
        }
        self.depth += 1;
        let r = self.run(mi, args);
        self.depth -= 1;
        r
    }

    fn run(&mut self, mi: usize, args: Vec<Value>) -> Res<Option<Value>> {
        let class = Rc::clone(&self.class);
        let m = &class.methods[mi];
        let code = &m.code;
        if code.is_empty() {
            return Err(format!("method {} has no Code (native/abstract?)", m.name));
        }

        let mut locals = vec![Value::Null; m.max_locals.max(args.len())];
        for (i, a) in args.into_iter().enumerate() {
            locals[i] = a;
        }
        let mut st: Vec<Value> = Vec::with_capacity(m.max_stack);
        let mut pc = 0usize;

        macro_rules! pop {
            () => {
                st.pop().ok_or("operand stack underflow")?
            };
        }
        let u2 = |p: usize| -> u16 { ((code[p] as u16) << 8) | code[p + 1] as u16 };
        let target = |pc: usize| -> usize { (pc as isize + u2(pc + 1) as i16 as isize) as usize };

        loop {
            let op = *code.get(pc).ok_or("pc out of range")?;
            if self.trace {
                eprintln!("[{}.{} pc={:<3} op=0x{:02x} depth={}]", class.name, m.name, pc, op, st.len());
            }
            let mut next = pc + 1;
            match op {
                0x00 => {} // nop
                0x01 => st.push(Value::Null),
                0x02..=0x08 => st.push(Value::Int(op as i32 - 3)), // iconst_m1..5
                0x10 => { st.push(Value::Int(code[pc + 1] as i8 as i32)); next = pc + 2; }
                0x11 => { st.push(Value::Int(u2(pc + 1) as i16 as i32)); next = pc + 3; }
                0x12 | 0x13 => {
                    // ldc / ldc_w
                    let (idx, len) = if op == 0x12 { (code[pc + 1] as u16, 2) } else { (u2(pc + 1), 3) };
                    match class.cp.get(idx as usize) {
                        Some(Const::Int(v)) => st.push(Value::Int(*v)),
                        Some(Const::Str(u)) => st.push(Value::Str(Rc::from(class.utf8(*u)?))),
                        _ => return Err(format!("ldc: unsupported constant #{idx}")),
                    }
                    next = pc + len;
                }

                // ── 載入 / 儲存 ──
                0x15 | 0x19 => { st.push(locals[code[pc + 1] as usize].clone()); next = pc + 2; }
                0x1a..=0x1d => st.push(locals[(op - 0x1a) as usize].clone()),
                0x2a..=0x2d => st.push(locals[(op - 0x2a) as usize].clone()),
                0x36 | 0x3a => { locals[code[pc + 1] as usize] = pop!(); next = pc + 2; }
                0x3b..=0x3e => locals[(op - 0x3b) as usize] = pop!(),
                0x4b..=0x4e => locals[(op - 0x4b) as usize] = pop!(),

                // ── int 陣列 ──
                0xbc => {
                    let len = pop!().int()?;
                    if code[pc + 1] != 10 {
                        return Err("newarray: only int[] is supported".into());
                    }
                    if len < 0 {
                        return Err("java.lang.NegativeArraySizeException".into());
                    }
                    st.push(Value::Arr(Rc::new(RefCell::new(vec![0; len as usize]))));
                    next = pc + 2;
                }
                0x2e => {
                    let i = pop!().int()?;
                    let a = pop!().arr()?;
                    let v = *a.borrow().get(i as usize)
                        .ok_or_else(|| format!("java.lang.ArrayIndexOutOfBoundsException: {i}"))?;
                    st.push(Value::Int(v));
                }
                0x4f => {
                    let v = pop!().int()?;
                    let i = pop!().int()?;
                    let a = pop!().arr()?;
                    *a.borrow_mut().get_mut(i as usize)
                        .ok_or_else(|| format!("java.lang.ArrayIndexOutOfBoundsException: {i}"))? = v;
                }
                0xbe => {
                    let n = pop!().arr()?.borrow().len();
                    st.push(Value::Int(n as i32));
                }

                // ── stack 操作 ──
                0x57 => { pop!(); }
                0x59 => { let v = st.last().ok_or("operand stack underflow")?.clone(); st.push(v); }
                0x5f => { let b = pop!(); let a = pop!(); st.push(b); st.push(a); }

                // ── 算術 / 位元 ──
                0x60 | 0x64 | 0x68 | 0x6c | 0x70 | 0x78 | 0x7a | 0x7c | 0x7e | 0x80 | 0x82 => {
                    let b = pop!().int()?;
                    let a = pop!().int()?;
                    let r = match op {
                        0x60 => a.wrapping_add(b),
                        0x64 => a.wrapping_sub(b),
                        0x68 => a.wrapping_mul(b),
                        0x6c | 0x70 => {
                            if b == 0 {
                                return Err("java.lang.ArithmeticException: / by zero".into());
                            }
                            if op == 0x6c { a.wrapping_div(b) } else { a.wrapping_rem(b) }
                        }
                        0x78 => a.wrapping_shl(b as u32),
                        0x7a => a.wrapping_shr(b as u32),
                        0x7c => (a as u32).wrapping_shr(b as u32) as i32,
                        0x7e => a & b,
                        0x80 => a | b,
                        _ => a ^ b,
                    };
                    st.push(Value::Int(r));
                }
                0x74 => { let a = pop!().int()?; st.push(Value::Int(a.wrapping_neg())); }
                0x84 => {
                    let n = code[pc + 1] as usize;
                    let c = code[pc + 2] as i8 as i32;
                    locals[n] = Value::Int(locals[n].int()?.wrapping_add(c));
                    next = pc + 3;
                }
                0x91 => { let a = pop!().int()?; st.push(Value::Int(a as i8 as i32)); }
                0x92 => { let a = pop!().int()?; st.push(Value::Int(a as u16 as i32)); }
                0x93 => { let a = pop!().int()?; st.push(Value::Int(a as i16 as i32)); }

                // ── 分支 ──
                0x99..=0x9e => {
                    let v = pop!().int()?;
                    let t = match op {
                        0x99 => v == 0, 0x9a => v != 0, 0x9b => v < 0,
                        0x9c => v >= 0, 0x9d => v > 0, _ => v <= 0,
                    };
                    next = if t { target(pc) } else { pc + 3 };
                }
                0x9f..=0xa4 => {
                    let b = pop!().int()?;
                    let a = pop!().int()?;
                    let t = match op {
                        0x9f => a == b, 0xa0 => a != b, 0xa1 => a < b,
                        0xa2 => a >= b, 0xa3 => a > b, _ => a <= b,
                    };
                    next = if t { target(pc) } else { pc + 3 };
                }
                0xa5 | 0xa6 => {
                    let b = pop!();
                    let a = pop!();
                    next = if a.same_ref(&b) == (op == 0xa5) { target(pc) } else { pc + 3 };
                }
                0xc6 | 0xc7 => {
                    let is_null = matches!(pop!(), Value::Null);
                    next = if is_null == (op == 0xc6) { target(pc) } else { pc + 3 };
                }
                0xa7 => next = target(pc),

                // ── 返回 ──
                0xac | 0xb0 => return Ok(Some(pop!())),
                0xb1 => return Ok(None),

                // ── 欄位 / 方法 ──
                0xb2 => {
                    let (c, n, _) = class.member(u2(pc + 1))?;
                    if c == "java/lang/System" && n == "out" {
                        st.push(Value::Out);
                    } else {
                        return Err(format!("getstatic {c}.{n} not supported"));
                    }
                    next = pc + 3;
                }
                0xb6 => {
                    let (c, n, d) = class.member(u2(pc + 1))?;
                    if c == "java/io/PrintStream" && (n == "println" || n == "print") {
                        let text = match d {
                            "()V" => String::new(),
                            "(I)V" | "(B)V" | "(S)V" => pop!().int()?.to_string(),
                            "(Z)V" => (pop!().int()? != 0).to_string(),
                            "(C)V" => char::from_u32(pop!().int()? as u32).unwrap_or('?').to_string(),
                            "(Ljava/lang/String;)V" => match pop!() {
                                Value::Str(s) => s.to_string(),
                                Value::Null => "null".into(),
                                _ => return Err("println: expected String".into()),
                            },
                            _ => return Err(format!("PrintStream.{n}{d} not supported")),
                        };
                        pop!(); // receiver
                        if n == "println" { println!("{text}") } else { print!("{text}") }
                    } else {
                        return Err(format!("invokevirtual {c}.{n}{d} not supported"));
                    }
                    next = pc + 3;
                }
                0xb8 => {
                    let (c, n, d) = class.member(u2(pc + 1))?;
                    if c != class.name {
                        return Err(format!("invokestatic {c}.{n}{d}: only same-class calls supported"));
                    }
                    let callee = class.find_method(n, d)
                        .ok_or_else(|| format!("java.lang.NoSuchMethodError: {n}{d}"))?;
                    let nargs = class.methods[callee].nargs;
                    if st.len() < nargs {
                        return Err("operand stack underflow".into());
                    }
                    let args = st.split_off(st.len() - nargs);
                    if let Some(v) = self.invoke(callee, args)? {
                        st.push(v);
                    }
                    next = pc + 3;
                }

                _ => return Err(format!("unsupported opcode 0x{:02x} at {}.{} pc={}", op, class.name, m.name, pc)),
            }
            pc = next;
        }
    }
}
