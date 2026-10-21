//! .class 檔案寫出器:ConstPool、ClassFile、位元組碼緩衝區 Code 與 JVM opcodes。

use std::collections::HashMap;

// JVM opcodes(與 Java 版常數相同)
pub const ACONST_NULL: u8 = 1;
pub const ILOAD: u8 = 21;
pub const ALOAD: u8 = 25;
pub const ISTORE: u8 = 54;
pub const ASTORE: u8 = 58;
pub const IALOAD: u8 = 46;
pub const IASTORE: u8 = 79;
pub const POP: u8 = 87;
pub const DUP: u8 = 89;
pub const IADD: u8 = 96;
pub const ISUB: u8 = 100;
pub const IMUL: u8 = 104;
pub const IDIV: u8 = 108;
pub const INEG: u8 = 116;
pub const IAND: u8 = 126;
pub const IOR: u8 = 128;
pub const IXOR: u8 = 130;
pub const IFEQ: u8 = 153;
pub const IF_ICMPEQ: u8 = 159;
pub const IF_ICMPLT: u8 = 161;
pub const IF_ICMPGT: u8 = 163;
pub const IF_ACMPEQ: u8 = 165;
pub const GOTO: u8 = 167;
pub const IRETURN: u8 = 172;
pub const ARETURN: u8 = 176;
pub const RETURN: u8 = 177;
pub const GETSTATIC: u8 = 178;
pub const PUTSTATIC: u8 = 179;
pub const GETFIELD: u8 = 180;
pub const PUTFIELD: u8 = 181;
pub const INVOKEVIRTUAL: u8 = 182;
pub const INVOKESPECIAL: u8 = 183;
pub const INVOKESTATIC: u8 = 184;
pub const NEW: u8 = 187;
pub const NEWARRAY: u8 = 188;

/// Java 的 `DataOutputStream.writeUTF` 使用 modified UTF-8:
/// NUL 編成 2 位元組,補充字元以代理對各編 3 位元組(與標準 UTF-8 不同)。
fn mutf8(s: &str) -> Vec<u8> {
    let mut out = Vec::new();
    for cu in s.encode_utf16() {
        match cu {
            0 => {
                out.push(0xC0);
                out.push(0x80);
            }
            1..=0x7F => out.push(cu as u8),
            0x80..=0x7FF => {
                out.push(0xC0 | (cu >> 6) as u8);
                out.push(0x80 | (cu & 0x3F) as u8);
            }
            _ => {
                out.push(0xE0 | (cu >> 12) as u8);
                out.push(0x80 | ((cu >> 6) & 0x3F) as u8);
                out.push(0x80 | (cu & 0x3F) as u8);
            }
        }
    }
    out
}

pub struct ConstPool {
    buf: Vec<u8>,
    map: HashMap<String, u16>,
    pub count: u32,
}

impl ConstPool {
    pub fn new() -> Self {
        ConstPool { buf: Vec::new(), map: HashMap::new(), count: 1 }
    }

    fn w(&mut self, tag: u8, vals: &[u16]) {
        self.buf.push(tag);
        for v in vals {
            self.buf.extend_from_slice(&v.to_be_bytes());
        }
    }

    fn done(&mut self, key: String) -> u16 {
        let idx = self.count as u16;
        self.map.insert(key, idx);
        self.count += 1;
        idx
    }

    pub fn utf8(&mut self, s: &str) -> u16 {
        let key = format!("U{s}");
        if let Some(&i) = self.map.get(&key) {
            return i;
        }
        let b = mutf8(s);
        self.buf.push(1);
        self.buf.extend_from_slice(&(b.len() as u16).to_be_bytes());
        self.buf.extend_from_slice(&b);
        self.done(key)
    }

    pub fn cls(&mut self, n: &str) -> u16 {
        let key = format!("C{n}");
        if let Some(&i) = self.map.get(&key) {
            return i;
        }
        let u = self.utf8(n);
        self.w(7, &[u]);
        self.done(key)
    }

    pub fn string(&mut self, s: &str) -> u16 {
        let key = format!("S{s}");
        if let Some(&i) = self.map.get(&key) {
            return i;
        }
        let u = self.utf8(s);
        self.w(8, &[u]);
        self.done(key)
    }

    pub fn integer(&mut self, v: i32) -> u16 {
        let key = format!("I{v}");
        if let Some(&i) = self.map.get(&key) {
            return i;
        }
        self.buf.push(3);
        self.buf.extend_from_slice(&v.to_be_bytes());
        self.done(key)
    }

    fn name_type(&mut self, n: &str, d: &str) -> u16 {
        let key = format!("N{n}:{d}");
        if let Some(&i) = self.map.get(&key) {
            return i;
        }
        let a = self.utf8(n);
        let b = self.utf8(d);
        self.w(12, &[a, b]);
        self.done(key)
    }

    fn entry(&mut self, tag: u8, owner: &str, n: &str, d: &str) -> u16 {
        let key = format!("R{tag}{owner}.{n}:{d}");
        if let Some(&i) = self.map.get(&key) {
            return i;
        }
        let c = self.cls(owner);
        let nt = self.name_type(n, d);
        self.w(tag, &[c, nt]);
        self.done(key)
    }

    pub fn field(&mut self, o: &str, n: &str, d: &str) -> u16 {
        self.entry(9, o, n, d)
    }

    pub fn method(&mut self, o: &str, n: &str, d: &str) -> u16 {
        self.entry(10, o, n, d)
    }
}

/// 位元組碼緩衝區,同時追蹤運算堆疊深度以計算 max_stack。
pub struct Code {
    bytes: Vec<u8>,
    cur: i32,
    pub max: i32,
    pub max_locals: i32,
}

/// 尚未定位的跳轉標籤;fix 存 (opcode 位置, 運算元位置)。
pub struct Label {
    pos: i32,
    depth: i32,
    fix: Vec<(usize, usize)>,
}

impl Label {
    pub fn new() -> Self {
        Label { pos: -1, depth: -1, fix: Vec::new() }
    }
}

impl Default for Label {
    fn default() -> Self {
        Self::new()
    }
}

impl Code {
    pub fn new() -> Self {
        Code { bytes: Vec::new(), cur: 0, max: 0, max_locals: 0 }
    }

    pub fn u1(&mut self, b: u8) {
        self.bytes.push(b);
    }

    pub fn u2(&mut self, v: u16) {
        self.bytes.extend_from_slice(&v.to_be_bytes());
    }

    fn adj(&mut self, d: i32) {
        self.cur += d;
        if self.cur > self.max {
            self.max = self.cur;
        }
    }

    pub fn op(&mut self, o: u8, d: i32) {
        self.u1(o);
        self.adj(d);
    }

    pub fn len(&self) -> usize {
        self.bytes.len()
    }

    pub fn as_bytes(&self) -> &[u8] {
        &self.bytes
    }

    pub fn push_int(&mut self, cp: &mut ConstPool, v: i32) {
        if (-1..=5).contains(&v) {
            self.op((3 + v) as u8, 1);
        } else if (-128..=127).contains(&v) {
            self.u1(16);
            self.u1(v as u8);
            self.adj(1);
        } else if (-32768..=32767).contains(&v) {
            self.u1(17);
            self.u2(v as u16);
            self.adj(1);
        } else {
            let idx = cp.integer(v);
            if idx < 256 {
                self.u1(18);
                self.u1(idx as u8);
            } else {
                self.u1(19);
                self.u2(idx);
            }
            self.adj(1);
        }
    }

    pub fn push_string(&mut self, cp: &mut ConstPool, s: &str) {
        let idx = cp.string(s);
        if idx < 256 {
            self.u1(18);
            self.u1(idx as u8);
        } else {
            self.u1(19);
            self.u2(idx);
        }
        self.adj(1);
    }

    pub fn local(&mut self, op: u8, slot: i32, delta: i32) {
        if slot < 256 {
            self.u1(op);
            self.u1(slot as u8);
        } else {
            self.u1(196);
            self.u1(op);
            self.u2(slot as u16);
        }
        self.adj(delta);
    }

    pub fn invoke(&mut self, cp: &mut ConstPool, op: u8, owner: &str, name: &str, desc: &str) {
        let idx = cp.method(owner, name, desc);
        self.u1(op);
        self.u2(idx);
        let mut args = 0;
        let mut i = 1;
        let b = desc.as_bytes();
        while b[i] != b')' {
            while b[i] == b'[' {
                i += 1;
            }
            if b[i] == b'L' {
                i = i + desc[i..].find(';').expect("bad descriptor");
            }
            i += 1;
            args += 1;
        }
        let ret = if desc.ends_with(")V") { 0 } else { 1 };
        let recv = if op == INVOKESTATIC { 0 } else { 1 };
        self.adj(ret - args - recv);
    }

    pub fn field(&mut self, cp: &mut ConstPool, op: u8, owner: &str, name: &str, desc: &str) {
        let idx = cp.field(owner, name, desc);
        self.u1(op);
        self.u2(idx);
        let d = match op {
            GETSTATIC => 1,
            PUTSTATIC => -1,
            GETFIELD => 0,
            _ => -2,
        };
        self.adj(d);
    }

    pub fn new_obj(&mut self, cp: &mut ConstPool, cls: &str) {
        let idx = cp.cls(cls);
        self.u1(NEW);
        self.u2(idx);
        self.adj(1);
    }

    pub fn jump(&mut self, op: u8, pops: i32, l: &mut Label) {
        let at = self.bytes.len();
        self.u1(op);
        if l.pos >= 0 {
            let off = l.pos - at as i32;
            self.u2(off as u16);
        } else {
            l.fix.push((at, self.bytes.len()));
            self.u2(0);
        }
        self.adj(-pops);
        if l.depth < 0 {
            l.depth = self.cur;
        }
    }

    pub fn place(&mut self, l: &mut Label) {
        l.pos = self.bytes.len() as i32;
        if l.depth >= 0 {
            self.cur = l.depth;
        } else {
            l.depth = self.cur;
        }
        let mut patched = Vec::with_capacity(l.fix.len());
        for &(op_at, arg_at) in &l.fix {
            let off = self.bytes.len() as i32 - op_at as i32;
            if off > 32767 {
                panic!("method too large");
            }
            patched.push((arg_at, off as u16));
        }
        for (arg_at, off) in patched {
            self.bytes[arg_at] = (off >> 8) as u8;
            self.bytes[arg_at + 1] = off as u8;
        }
        l.fix.clear();
    }
}

pub struct ClassFile {
    pub cp: ConstPool,
    this_idx: u16,
    super_idx: u16,
    code_attr_idx: u16,
    fields: Vec<Vec<u8>>,
    methods: Vec<Vec<u8>>,
}

impl ClassFile {
    pub fn new(name: &str) -> Self {
        let mut cp = ConstPool::new();
        let this_idx = cp.cls(name);
        let super_idx = cp.cls("java/lang/Object");
        let code_attr_idx = cp.utf8("Code");
        ClassFile { cp, this_idx, super_idx, code_attr_idx, fields: Vec::new(), methods: Vec::new() }
    }

    pub fn add_field(&mut self, acc: u16, name: &str, desc: &str) {
        let n = self.cp.utf8(name);
        let d = self.cp.utf8(desc);
        let mut b = Vec::new();
        b.extend_from_slice(&acc.to_be_bytes());
        b.extend_from_slice(&n.to_be_bytes());
        b.extend_from_slice(&d.to_be_bytes());
        b.extend_from_slice(&0u16.to_be_bytes());
        self.fields.push(b);
    }

    pub fn add_method(&mut self, acc: u16, name: &str, desc: &str, code: &Code) {
        let n = self.cp.utf8(name);
        let d = self.cp.utf8(desc);
        let mut b = Vec::new();
        b.extend_from_slice(&acc.to_be_bytes());
        b.extend_from_slice(&n.to_be_bytes());
        b.extend_from_slice(&d.to_be_bytes());
        b.extend_from_slice(&1u16.to_be_bytes()); // attributes_count
        b.extend_from_slice(&self.code_attr_idx.to_be_bytes());
        b.extend_from_slice(&((2 + 2 + 4 + code.len() + 2 + 2) as u32).to_be_bytes());
        b.extend_from_slice(&(code.max as u16).to_be_bytes());
        b.extend_from_slice(&(code.max_locals as u16).to_be_bytes());
        b.extend_from_slice(&(code.len() as u32).to_be_bytes());
        b.extend_from_slice(code.as_bytes());
        b.extend_from_slice(&0u16.to_be_bytes()); // exception_table_length
        b.extend_from_slice(&0u16.to_be_bytes()); // attributes_count
        self.methods.push(b);
    }

    pub fn to_bytes(&self) -> Vec<u8> {
        let mut d = Vec::new();
        d.extend_from_slice(&0xCAFEBABEu32.to_be_bytes());
        d.extend_from_slice(&0u16.to_be_bytes()); // minor_version
        d.extend_from_slice(&50u16.to_be_bytes()); // major: Java 6,不需要 StackMapTable
        d.extend_from_slice(&(self.cp.count as u16).to_be_bytes());
        d.extend_from_slice(&self.cp.buf);
        d.extend_from_slice(&0x0021u16.to_be_bytes()); // ACC_PUBLIC | ACC_SUPER
        d.extend_from_slice(&self.this_idx.to_be_bytes());
        d.extend_from_slice(&self.super_idx.to_be_bytes());
        d.extend_from_slice(&0u16.to_be_bytes()); // interfaces
        d.extend_from_slice(&(self.fields.len() as u16).to_be_bytes());
        for f in &self.fields {
            d.extend_from_slice(f);
        }
        d.extend_from_slice(&(self.methods.len() as u16).to_be_bytes());
        for m in &self.methods {
            d.extend_from_slice(m);
        }
        d.extend_from_slice(&0u16.to_be_bytes()); // class attributes
        d
    }
}
