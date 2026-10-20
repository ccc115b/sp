//! jvm0 — 一個用 Rust 寫成的微型 JVM。
//!
//! 支援範圍（刻意縮小）：
//!   * 單一 .class 檔、`public static void main(String[])` 為入口
//!   * 型別：int / boolean / char / byte / short、String 常數、int[]
//!   * 指令：常數載入、區域變數、算術與位元運算、比較與分支、
//!           靜態方法呼叫（含遞迴）、int 陣列、System.out.print/println
//!
//! 用法：jvm0 [-t|--trace] Foo.class

use std::cell::RefCell;
use std::io::Write;
use std::rc::Rc;

type Res<T> = Result<T, String>;

// ───────────────────────── Class file 解析 ─────────────────────────

#[derive(Clone)]
enum Const {
    Utf8(String),
    Int(i32),
    Str(u16),
    Class(u16),
    Ref { class: u16, nt: u16 }, // Field/Method/InterfaceMethod ref
    NameType { name: u16, desc: u16 },
    Other, // 目前用不到的項目（long/double/float/invokedynamic…）
}

struct Method {
    name: String,
    desc: String,
    access: u16,
    max_stack: usize,
    max_locals: usize,
    code: Vec<u8>,
    nargs: usize,
}

struct ClassFile {
    cp: Vec<Const>,
    name: String,
    methods: Vec<Method>,
}

struct Reader<'a> {
    d: &'a [u8],
    p: usize,
}

impl<'a> Reader<'a> {
    fn bytes(&mut self, n: usize) -> Res<&'a [u8]> {
        let end = self.p.checked_add(n).filter(|&e| e <= self.d.len());
        let end = end.ok_or("unexpected end of class file")?;
        let s = &self.d[self.p..end];
        self.p = end;
        Ok(s)
    }
    fn u1(&mut self) -> Res<u8> {
        Ok(self.bytes(1)?[0])
    }
    fn u2(&mut self) -> Res<u16> {
        let b = self.bytes(2)?;
        Ok(u16::from_be_bytes([b[0], b[1]]))
    }
    fn u4(&mut self) -> Res<u32> {
        let b = self.bytes(4)?;
        Ok(u32::from_be_bytes([b[0], b[1], b[2], b[3]]))
    }
}

/// 計算 descriptor 的參數個數（每個參數佔一個 slot；不支援 long/double）。
fn count_args(desc: &str) -> Res<usize> {
    let b = desc.as_bytes();
    let (mut i, mut n) = (1, 0);
    while i < b.len() && b[i] != b')' {
        match b[i] {
            b'I' | b'Z' | b'B' | b'C' | b'S' => i += 1,
            b'J' | b'D' | b'F' => return Err(format!("unsupported type in {desc}")),
            b'L' => {
                while b[i] != b';' {
                    i += 1;
                }
                i += 1;
            }
            b'[' => {
                while b[i] == b'[' {
                    i += 1;
                }
                if b[i] == b'L' {
                    while b[i] != b';' {
                        i += 1;
                    }
                }
                i += 1;
            }
            c => return Err(format!("bad descriptor char '{}'", c as char)),
        }
        n += 1;
    }
    Ok(n)
}

impl ClassFile {
    fn utf8(&self, i: u16) -> Res<&str> {
        match self.cp.get(i as usize) {
            Some(Const::Utf8(s)) => Ok(s),
            _ => Err(format!("constant #{i} is not Utf8")),
        }
    }
    fn class_name(&self, i: u16) -> Res<&str> {
        match self.cp.get(i as usize) {
            Some(Const::Class(n)) => self.utf8(*n),
            _ => Err(format!("constant #{i} is not Class")),
        }
    }
    /// 解析 Fieldref / Methodref → (類別, 名稱, descriptor)
    fn member(&self, i: u16) -> Res<(&str, &str, &str)> {
        match self.cp.get(i as usize) {
            Some(Const::Ref { class, nt }) => match self.cp.get(*nt as usize) {
                Some(Const::NameType { name, desc }) => {
                    Ok((self.class_name(*class)?, self.utf8(*name)?, self.utf8(*desc)?))
                }
                _ => Err("bad NameAndType".into()),
            },
            _ => Err(format!("constant #{i} is not a member ref")),
        }
    }
    fn find_method(&self, name: &str, desc: &str) -> Option<usize> {
        self.methods.iter().position(|m| m.name == name && m.desc == desc)
    }

    fn parse(data: &[u8]) -> Res<ClassFile> {
        let mut r = Reader { d: data, p: 0 };
        if r.u4()? != 0xCAFE_BABE {
            return Err("not a class file (bad magic)".into());
        }
        r.u2()?; // minor
        r.u2()?; // major

        let n = r.u2()? as usize;
        let mut cp = vec![Const::Other; n];
        let mut i = 1;
        while i < n {
            let mut extra = 0;
            let c = match r.u1()? {
                1 => {
                    let len = r.u2()? as usize;
                    Const::Utf8(String::from_utf8_lossy(r.bytes(len)?).into_owned())
                }
                3 => Const::Int(r.u4()? as i32),
                4 => { r.u4()?; Const::Other }
                5 | 6 => { r.u4()?; r.u4()?; extra = 1; Const::Other }
                7 => Const::Class(r.u2()?),
                8 => Const::Str(r.u2()?),
                9 | 10 | 11 => Const::Ref { class: r.u2()?, nt: r.u2()? },
                12 => Const::NameType { name: r.u2()?, desc: r.u2()? },
                15 => { r.u1()?; r.u2()?; Const::Other }
                16 | 19 | 20 => { r.u2()?; Const::Other }
                17 | 18 => { r.u4()?; Const::Other }
                t => return Err(format!("unknown constant pool tag {t}")),
            };
            cp[i] = c;
            i += 1 + extra;
        }

        let mut cf = ClassFile { cp, name: String::new(), methods: vec![] };
        r.u2()?; // access_flags
        let this = r.u2()?;
        cf.name = cf.class_name(this)?.to_string();
        r.u2()?; // super_class
        let ifaces = r.u2()? as usize;
        r.bytes(ifaces * 2)?;

        // fields：略過
        for _ in 0..r.u2()? {
            r.bytes(6)?;
            for _ in 0..r.u2()? {
                r.u2()?;
                let len = r.u4()? as usize;
                r.bytes(len)?;
            }
        }

        // methods
        for _ in 0..r.u2()? {
            let access = r.u2()?;
            let name = cf.utf8(r.u2()?)?.to_string();
            let desc = cf.utf8(r.u2()?)?.to_string();
            let mut m = Method {
                nargs: count_args(&desc).unwrap_or(0),
                name, desc, access, max_stack: 0, max_locals: 0, code: vec![],
            };
            for _ in 0..r.u2()? {
                let an = cf.utf8(r.u2()?)?.to_string();
                let len = r.u4()? as usize;
                let body = r.bytes(len)?;
                if an == "Code" {
                    let mut s = Reader { d: body, p: 0 };
                    m.max_stack = s.u2()? as usize;
                    m.max_locals = s.u2()? as usize;
                    let clen = s.u4()? as usize;
                    m.code = s.bytes(clen)?.to_vec();
                }
            }
            cf.methods.push(m);
        }
        Ok(cf)
    }
}

// ───────────────────────── 執行期值 ─────────────────────────

#[derive(Clone)]
enum Value {
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

struct Vm {
    class: Rc<ClassFile>,
    trace: bool,
    depth: usize,
}

impl Vm {
    fn invoke(&mut self, mi: usize, args: Vec<Value>) -> Res<Option<Value>> {
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

// ───────────────────────── 進入點 ─────────────────────────

fn run_file(path: &str, trace: bool) -> Res<()> {
    let data = std::fs::read(path).map_err(|e| format!("cannot read {path}: {e}"))?;
    let class = Rc::new(ClassFile::parse(&data)?);
    let main = class
        .find_method("main", "([Ljava/lang/String;)V")
        .ok_or("no `public static void main(String[])` found")?;
    if class.methods[main].access & 0x0008 == 0 {
        return Err("main is not static".into());
    }
    let mut vm = Vm { class, trace, depth: 0 };
    vm.invoke(main, vec![Value::Null])?;
    Ok(())
}

fn main() {
    let mut trace = false;
    let mut file = None;
    for a in std::env::args().skip(1) {
        match a.as_str() {
            "-t" | "--trace" => trace = true,
            _ => file = Some(a),
        }
    }
    let Some(file) = file else {
        eprintln!("usage: jvm0 [-t|--trace] <Class.class>");
        std::process::exit(2);
    };

    // 遞迴深度大時需要較大的 Rust stack
    let h = std::thread::Builder::new()
        .stack_size(256 * 1024 * 1024)
        .spawn(move || run_file(&file, trace))
        .unwrap();
    let r = h.join().unwrap();
    std::io::stdout().flush().ok();
    if let Err(e) = r {
        eprintln!("Exception in thread \"main\" {e}");
        std::process::exit(1);
    }
}
