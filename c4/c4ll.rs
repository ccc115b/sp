// c4ll.rs - C4 front-end that emits LLVM IR (.ll), runnable with lli
use std::env;
use std::fs::File;
use std::io::{Read, Write};

type Cell = i64;

#[allow(non_upper_case_globals)]
mod tok {
    pub const Num: i64 = 128;
    pub const Fun: i64 = 129;
    pub const Sys: i64 = 130;
    pub const Glo: i64 = 131;
    pub const Loc: i64 = 132;
    pub const Id: i64 = 133;
    pub const Char: i64 = 134;
    pub const Else: i64 = 135;
    pub const Enum: i64 = 136;
    pub const If: i64 = 137;
    pub const Int: i64 = 138;
    pub const Return: i64 = 139;
    pub const Sizeof: i64 = 140;
    pub const While: i64 = 141;
    pub const Assign: i64 = 142;
    pub const Cond: i64 = 143;
    pub const Lor: i64 = 144;
    pub const Lan: i64 = 145;
    pub const Or: i64 = 146;
    pub const Xor: i64 = 147;
    pub const And: i64 = 148;
    pub const Eq: i64 = 149;
    pub const Ne: i64 = 150;
    pub const Lt: i64 = 151;
    pub const Gt: i64 = 152;
    pub const Le: i64 = 153;
    pub const Ge: i64 = 154;
    pub const Shl: i64 = 155;
    pub const Shr: i64 = 156;
    pub const Add: i64 = 157;
    pub const Sub: i64 = 158;
    pub const Mul: i64 = 159;
    pub const Div: i64 = 160;
    pub const Mod: i64 = 161;
    pub const Inc: i64 = 162;
    pub const Dec: i64 = 163;
    pub const Brak: i64 = 164;
}

#[allow(dead_code)]
mod op {
    pub const OPEN: i64 = 30;
    pub const CREA: i64 = 31;
    pub const READ: i64 = 32;
    pub const WRIT: i64 = 33;
    pub const CLOS: i64 = 34;
    pub const PRTF: i64 = 35;
    pub const MALC: i64 = 36;
    pub const FREE: i64 = 37;
    pub const MSET: i64 = 38;
    pub const MCMP: i64 = 39;
    pub const EXIT: i64 = 40;
}

const CHAR_TY: Cell = 0;
const INT_TY: Cell = 1;
const PTR_TY: Cell = 2;

const DECLS: &str = "\
declare i32 @printf(ptr, ...)
declare ptr @malloc(i64)
declare void @free(ptr)
declare ptr @memset(ptr, i32, i64)
declare i32 @memcmp(ptr, ptr, i64)
declare i32 @open(ptr, i32, ...)
declare i32 @creat(ptr, i32)
declare i64 @read(i32, ptr, i64)
declare i64 @write(i32, ptr, i64)
declare i32 @close(i32)
declare void @exit(i32) noreturn
";

#[derive(Clone, Default)]
struct Ident {
    tk: Cell,
    hash: Cell,
    name: String,
    class: Cell,
    ty: Cell,
    val: Cell,
    hclass: Cell,
    hty: Cell,
    hval: Cell,
    slot: String,
}

struct Val {
    ty: Cell,
    v: String,
    addr: Option<String>,
}

struct Compiler {
    src_bytes: Vec<u8>,
    pos: usize,
    line: Cell,

    tk: Cell,
    ival: Cell,
    ty: Cell,
    loc: Cell,

    data: Vec<u8>,
    sym: Vec<Ident>,
    cur_id_idx: usize,

    ir_head: String,
    ir_body: String,
    ir_funcs: String,
    fn_header: String,
    tmp_n: usize,
    lbl_n: usize,
    slot_n: usize,
    str_n: usize,
    cur_block: String,
    terminated: bool,
    last_v: String,
    fn_is_main: bool,
}

impl Compiler {
    fn new(src_bytes: Vec<u8>) -> Self {
        Compiler {
            src_bytes,
            pos: 0,
            line: 1,
            tk: 0,
            ival: 0,
            ty: 0,
            loc: 0,
            data: Vec::new(),
            sym: Vec::new(),
            cur_id_idx: 0,
            ir_head: String::new(),
            ir_body: String::new(),
            ir_funcs: String::new(),
            fn_header: String::new(),
            tmp_n: 0,
            lbl_n: 0,
            slot_n: 0,
            str_n: 0,
            cur_block: "entry".to_string(),
            terminated: false,
            last_v: "0".to_string(),
            fn_is_main: false,
        }
    }

    // ---------- IR emit helpers ----------

    fn new_tmp(&mut self, p: &str) -> String {
        self.tmp_n += 1;
        format!("%{}{}", p, self.tmp_n)
    }

    fn new_lbl(&mut self, p: &str) -> String {
        self.lbl_n += 1;
        format!("{}.{}", p, self.lbl_n)
    }

    fn ins(&mut self, s: &str) {
        if self.terminated {
            let l = self.new_lbl("dead");
            self.ir_body.push_str(&format!("{}:\n", l));
            self.cur_block = l;
            self.terminated = false;
        }
        self.ir_body.push_str("  ");
        self.ir_body.push_str(s);
        self.ir_body.push('\n');
    }

    fn set_block(&mut self, l: String) {
        self.ir_body.push_str(&format!("{}:\n", l));
        self.cur_block = l;
        self.terminated = false;
    }

    fn br(&mut self, l: &str) {
        self.ins(&format!("br label %{}", l));
        self.terminated = true;
    }

    fn br_cond(&mut self, c: &str, t: &str, f: &str) {
        self.ins(&format!("br i1 {}, label %{}, label %{}", c, t, f));
        self.terminated = true;
    }

    fn ptrtoint(&mut self, p: &str) -> String {
        let t = self.new_tmp("a");
        self.ins(&format!("{} = ptrtoint ptr {} to i64", t, p));
        t
    }

    fn inttoptr(&mut self, a: &str) -> String {
        let t = self.new_tmp("p");
        self.ins(&format!("{} = inttoptr i64 {} to ptr", t, a));
        t
    }

    fn trunc_i32(&mut self, a: &str) -> String {
        let t = self.new_tmp("w");
        self.ins(&format!("{} = trunc i64 {} to i32", t, a));
        t
    }

    fn sext_i32(&mut self, a: &str) -> String {
        let t = self.new_tmp("v");
        self.ins(&format!("{} = sext i32 {} to i64", t, a));
        t
    }

    fn load(&mut self, addr: &str, ty: Cell) -> String {
        let p = self.inttoptr(addr);
        if ty == CHAR_TY {
            let b = self.new_tmp("b");
            self.ins(&format!("{} = load i8, ptr {}", b, p));
            let s = self.new_tmp("c");
            self.ins(&format!("{} = sext i8 {} to i64", s, b));
            s
        } else {
            let v = self.new_tmp("v");
            self.ins(&format!("{} = load i64, ptr {}", v, p));
            v
        }
    }

    fn store(&mut self, addr: &str, ty: Cell, val: &str) {
        let p = self.inttoptr(addr);
        if ty == CHAR_TY {
            let b = self.new_tmp("b");
            self.ins(&format!("{} = trunc i64 {} to i8", b, val));
            self.ins(&format!("store i8 {}, ptr {}", b, p));
        } else {
            self.ins(&format!("store i64 {}, ptr {}", val, p));
        }
    }

    fn binop(&mut self, o: &str, a: &str, b: &str) -> String {
        let t = self.new_tmp("t");
        self.ins(&format!("{} = {} i64 {}, {}", t, o, a, b));
        t
    }

    fn icmp(&mut self, pred: &str, a: &str, b: &str) -> String {
        let c = self.new_tmp("c");
        self.ins(&format!("{} = icmp {} i64 {}, {}", c, pred, a, b));
        let z = self.new_tmp("b");
        self.ins(&format!("{} = zext i1 {} to i64", z, c));
        z
    }

    fn read_cstr(&self, off: usize) -> Vec<u8> {
        let mut out = Vec::new();
        let mut i = off;
        while i < self.data.len() && self.data[i] != 0 {
            out.push(self.data[i]);
            i += 1;
        }
        out
    }

    fn add_str_const(&mut self, bytes: &[u8]) -> String {
        self.str_n += 1;
        let name = format!("@.str.{}", self.str_n);
        let mut esc = String::new();
        for &b in bytes {
            if b == b'"' {
                esc.push_str("\\22");
            } else if b == b'\\' {
                esc.push_str("\\5c");
            } else if b >= 0x20 && b < 0x7f {
                esc.push(b as char);
            } else {
                esc.push_str(&format!("\\{:02x}", b));
            }
        }
        esc.push_str("\\00");
        self.ir_head.push_str(&format!(
            "{} = private unnamed_addr constant [{} x i8] c\"{}\"\n",
            name,
            bytes.len() + 1,
            esc
        ));
        name
    }

    fn end_fn(&mut self) {
        if !self.terminated {
            let v = self.last_v.clone();
            if self.fn_is_main {
                let t = self.new_tmp("rv");
                self.ins(&format!("{} = trunc i64 {} to i32", t, &v));
                self.ins(&format!("ret i32 {}", t));
            } else {
                self.ins(&format!("ret i64 {}", v));
            }
            self.terminated = true;
        }
        self.ir_funcs.push_str(&self.fn_header);
        self.ir_funcs.push_str(&self.ir_body);
        self.ir_funcs.push_str("}\n\n");
    }

    // ---------- lexer (same as c4.rs, strings NUL-terminated in data) ----------

    fn next(&mut self) {
        while self.pos < self.src_bytes.len() {
            let b = self.src_bytes[self.pos];
            self.tk = b as Cell;
            self.pos += 1;

            if self.tk == '\n' as Cell {
                self.line += 1;
            } else if self.tk == '#' as Cell {
                while self.pos < self.src_bytes.len() && self.src_bytes[self.pos] != b'\n' {
                    self.pos += 1;
                }
            } else if (b >= b'a' && b <= b'z') || (b >= b'A' && b <= b'Z') || b == b'_' {
                let pp = self.pos - 1;
                let mut hash = self.tk;
                while self.pos < self.src_bytes.len() {
                    let c = self.src_bytes[self.pos];
                    if (c >= b'a' && c <= b'z') || (c >= b'A' && c <= b'Z') || (c >= b'0' && c <= b'9') || c == b'_' {
                        hash = hash.wrapping_mul(147).wrapping_add(c as Cell);
                        self.pos += 1;
                    } else {
                        break;
                    }
                }
                let id_len = self.pos - pp;
                hash = (hash << 6) + id_len as Cell;
                let name = String::from_utf8_lossy(&self.src_bytes[pp..self.pos]).to_string();

                let mut found = None;
                for (idx, item) in self.sym.iter().enumerate() {
                    if item.tk != 0 && item.hash == hash && item.name == name {
                        found = Some(idx);
                        break;
                    }
                }

                if let Some(idx) = found {
                    self.cur_id_idx = idx;
                    self.tk = self.sym[idx].tk;
                    return;
                } else {
                    let mut ident = Ident::default();
                    ident.name = name;
                    ident.hash = hash;
                    ident.tk = tok::Id;
                    self.sym.push(ident);
                    self.cur_id_idx = self.sym.len() - 1;
                    self.tk = tok::Id;
                    return;
                }
            } else if b >= b'0' && b <= b'9' {
                self.ival = self.tk - '0' as Cell;
                if self.ival != 0 {
                    while self.pos < self.src_bytes.len() && self.src_bytes[self.pos] >= b'0' && self.src_bytes[self.pos] <= b'9' {
                        self.ival = self.ival * 10 + (self.src_bytes[self.pos] - b'0') as Cell;
                        self.pos += 1;
                    }
                } else if self.pos < self.src_bytes.len() && (self.src_bytes[self.pos] == b'x' || self.src_bytes[self.pos] == b'X') {
                    self.pos += 1;
                    while self.pos < self.src_bytes.len() {
                        let c = self.src_bytes[self.pos];
                        if c >= b'0' && c <= b'9' {
                            self.ival = self.ival * 16 + (c - b'0') as Cell;
                        } else if c >= b'a' && c <= b'f' {
                            self.ival = self.ival * 16 + (c - b'a' + 10) as Cell;
                        } else if c >= b'A' && c <= b'F' {
                            self.ival = self.ival * 16 + (c - b'A' + 10) as Cell;
                        } else {
                            break;
                        }
                        self.pos += 1;
                    }
                } else {
                    while self.pos < self.src_bytes.len() && self.src_bytes[self.pos] >= b'0' && self.src_bytes[self.pos] <= b'7' {
                        self.ival = self.ival * 8 + (self.src_bytes[self.pos] - b'0') as Cell;
                        self.pos += 1;
                    }
                }
                self.tk = tok::Num;
                return;
            } else if self.tk == '/' as Cell {
                if self.pos < self.src_bytes.len() && self.src_bytes[self.pos] == b'/' {
                    self.pos += 1;
                    while self.pos < self.src_bytes.len() && self.src_bytes[self.pos] != b'\n' {
                        self.pos += 1;
                    }
                } else {
                    self.tk = tok::Div;
                    return;
                }
            } else if self.tk == '\'' as Cell || self.tk == '"' as Cell {
                let quote = self.tk as u8;
                let pp_data_off = self.data.len();
                while self.pos < self.src_bytes.len() && self.src_bytes[self.pos] != quote {
                    let mut ch_val = self.src_bytes[self.pos] as Cell;
                    self.pos += 1;
                    if ch_val == '\\' as Cell {
                        if self.pos < self.src_bytes.len() {
                            ch_val = self.src_bytes[self.pos] as Cell;
                            self.pos += 1;
                            if ch_val == 'n' as Cell { ch_val = '\n' as Cell; }
                        }
                    }
                    if quote == b'"' {
                        self.data.push(ch_val as u8);
                    } else {
                        self.ival = ch_val;
                    }
                }
                self.pos += 1;
                if quote == b'"' {
                    self.data.push(0);
                    self.ival = pp_data_off as Cell;
                } else {
                    self.tk = tok::Num;
                }
                return;
            } else if self.tk == '=' as Cell {
                if self.pos < self.src_bytes.len() && self.src_bytes[self.pos] == b'=' { self.pos += 1; self.tk = tok::Eq; } else { self.tk = tok::Assign; } return;
            } else if self.tk == '+' as Cell {
                if self.pos < self.src_bytes.len() && self.src_bytes[self.pos] == b'+' { self.pos += 1; self.tk = tok::Inc; } else { self.tk = tok::Add; } return;
            } else if self.tk == '-' as Cell {
                if self.pos < self.src_bytes.len() && self.src_bytes[self.pos] == b'-' { self.pos += 1; self.tk = tok::Dec; } else { self.tk = tok::Sub; } return;
            } else if self.tk == '!' as Cell {
                if self.pos < self.src_bytes.len() && self.src_bytes[self.pos] == b'=' {
                    self.pos += 1;
                    self.tk = tok::Ne;
                }
                return;
            } else if self.tk == '<' as Cell {
                if self.pos < self.src_bytes.len() && self.src_bytes[self.pos] == b'=' { self.pos += 1; self.tk = tok::Le; }
                else if self.pos < self.src_bytes.len() && self.src_bytes[self.pos] == b'<' { self.pos += 1; self.tk = tok::Shl; }
                else { self.tk = tok::Lt; } return;
            } else if self.tk == '>' as Cell {
                if self.pos < self.src_bytes.len() && self.src_bytes[self.pos] == b'=' { self.pos += 1; self.tk = tok::Ge; }
                else if self.pos < self.src_bytes.len() && self.src_bytes[self.pos] == b'>' { self.pos += 1; self.tk = tok::Shr; }
                else { self.tk = tok::Gt; } return;
            } else if self.tk == '|' as Cell {
                if self.pos < self.src_bytes.len() && self.src_bytes[self.pos] == b'|' { self.pos += 1; self.tk = tok::Lor; } else { self.tk = tok::Or; } return;
            } else if self.tk == '&' as Cell {
                if self.pos < self.src_bytes.len() && self.src_bytes[self.pos] == b'&' { self.pos += 1; self.tk = tok::Lan; } else { self.tk = tok::And; } return;
            } else if self.tk == '^' as Cell { self.tk = tok::Xor; return; }
            else if self.tk == '%' as Cell { self.tk = tok::Mod; return; }
            else if self.tk == '*' as Cell { self.tk = tok::Mul; return; }
            else if self.tk == '[' as Cell { self.tk = tok::Brak; return; }
            else if self.tk == '?' as Cell { self.tk = tok::Cond; return; }
            else if self.tk == '~' as Cell || self.tk == ';' as Cell || self.tk == '{' as Cell || self.tk == '}' as Cell
                 || self.tk == '(' as Cell || self.tk == ')' as Cell || self.tk == ']' as Cell || self.tk == ',' as Cell || self.tk == ':' as Cell {
                return;
            }
        }
        self.tk = 0;
    }

    // ---------- system calls ----------

    fn sys_call(&mut self, sc: Cell, args: Vec<Val>) -> Val {
        let av: Vec<String> = args.iter().map(|a| a.v.clone()).collect();
        let v = match sc {
            op::OPEN => {
                let p = self.inttoptr(&av[0]);
                let f = self.trunc_i32(&av[1]);
                let r = self.new_tmp("r");
                self.ins(&format!("{} = call i32 @open(ptr {}, i32 {})", r, p, f));
                self.sext_i32(&r)
            }
            op::CREA => {
                let p = self.inttoptr(&av[0]);
                let f = self.trunc_i32(&av[1]);
                let r = self.new_tmp("r");
                self.ins(&format!("{} = call i32 @creat(ptr {}, i32 {})", r, p, f));
                self.sext_i32(&r)
            }
            op::READ => {
                let fd = self.trunc_i32(&av[0]);
                let buf = self.inttoptr(&av[1]);
                let r = self.new_tmp("r");
                self.ins(&format!("{} = call i64 @read(i32 {}, ptr {}, i64 {})", r, fd, buf, av[2]));
                r
            }
            op::WRIT => {
                let fd = self.trunc_i32(&av[0]);
                let buf = self.inttoptr(&av[1]);
                let r = self.new_tmp("r");
                self.ins(&format!("{} = call i64 @write(i32 {}, ptr {}, i64 {})", r, fd, buf, av[2]));
                r
            }
            op::CLOS => {
                let fd = self.trunc_i32(&av[0]);
                let r = self.new_tmp("r");
                self.ins(&format!("{} = call i32 @close(i32 {})", r, fd));
                self.sext_i32(&r)
            }
            op::PRTF => {
                let fp = self.inttoptr(&av[0]);
                let rest: Vec<String> = av[1..].iter().map(|a| format!("i64 {}", a)).collect();
                let all = if rest.is_empty() {
                    format!("ptr {}", fp)
                } else {
                    format!("ptr {}, {}", fp, rest.join(", "))
                };
                let r = self.new_tmp("r");
                self.ins(&format!("{} = call i32 (ptr, ...) @printf({})", r, all));
                self.sext_i32(&r)
            }
            op::MALC => {
                let r = self.new_tmp("r");
                self.ins(&format!("{} = call ptr @malloc(i64 {})", r, av[0]));
                self.ptrtoint(&r)
            }
            op::FREE => {
                let p = self.inttoptr(&av[0]);
                self.ins(&format!("call void @free(ptr {})", p));
                "0".to_string()
            }
            op::MSET => {
                let p = self.inttoptr(&av[0]);
                let c = self.trunc_i32(&av[1]);
                let r = self.new_tmp("r");
                self.ins(&format!("{} = call ptr @memset(ptr {}, i32 {}, i64 {})", r, p, c, av[2]));
                self.ptrtoint(&r)
            }
            op::MCMP => {
                let p1 = self.inttoptr(&av[0]);
                let p2 = self.inttoptr(&av[1]);
                let r = self.new_tmp("r");
                self.ins(&format!("{} = call i32 @memcmp(ptr {}, ptr {}, i64 {})", r, p1, p2, av[2]));
                self.sext_i32(&r)
            }
            op::EXIT => {
                let c = self.trunc_i32(&av[0]);
                self.ins(&format!("call void @exit(i32 {})", c));
                self.terminated = true;
                "0".to_string()
            }
            _ => unreachable!(),
        };
        Val { ty: INT_TY, v, addr: None }
    }

    // ---------- expression ----------

    fn expr(&mut self, lev: Cell) -> Val {
        let r = self.expr_inner(lev);
        self.last_v = r.v.clone();
        r
    }

    fn expr_inner(&mut self, lev: Cell) -> Val {
        let mut base: Val;
        if self.tk == 0 {
            eprintln!("{}: unexpected eof in expression", self.line);
            std::process::exit(1);
        } else if self.tk == tok::Num {
            let v = self.ival;
            self.next();
            base = Val { ty: INT_TY, v: v.to_string(), addr: None };
        } else if self.tk == '"' as Cell {
            let mut bytes = self.read_cstr(self.ival as usize);
            self.next();
            while self.tk == '"' as Cell {
                bytes.extend(self.read_cstr(self.ival as usize));
                self.next();
            }
            let name = self.add_str_const(&bytes);
            let a = self.ptrtoint(&name);
            base = Val { ty: PTR_TY, v: a, addr: None };
        } else if self.tk == tok::Sizeof {
            self.next();
            if self.tk == '(' as Cell { self.next(); } else { eprintln!("{}: open paren expected in sizeof", self.line); std::process::exit(1); }
            self.ty = INT_TY;
            if self.tk == tok::Int { self.next(); }
            else if self.tk == tok::Char { self.next(); self.ty = CHAR_TY; }
            while self.tk == tok::Mul { self.next(); self.ty += PTR_TY; }
            if self.tk == ')' as Cell { self.next(); } else { eprintln!("{}: close paren expected in sizeof", self.line); std::process::exit(1); }
            let sz = if self.ty == CHAR_TY { 1 } else { 8 };
            self.ty = INT_TY;
            base = Val { ty: INT_TY, v: sz.to_string(), addr: None };
        } else if self.tk == tok::Id {
            let id_idx = self.cur_id_idx;
            self.next();
            if self.tk == '(' as Cell {
                self.next();
                let mut argvv: Vec<Val> = Vec::new();
                while self.tk != ')' as Cell {
                    let a = self.expr(tok::Assign);
                    argvv.push(a);
                    if self.tk == ',' as Cell { self.next(); }
                }
                self.next();
                let cls = self.sym[id_idx].class;
                let val = self.sym[id_idx].val;
                base = if cls == tok::Sys {
                    self.sys_call(val, argvv)
                } else if cls == tok::Fun {
                    let name = self.sym[id_idx].name.clone();
                    let cargs: Vec<String> = argvv.iter().map(|a| format!("i64 {}", a.v)).collect();
                    let r = self.new_tmp("r");
                    self.ins(&format!("{} = call i64 @{}({})", r, name, cargs.join(", ")));
                    Val { ty: self.sym[id_idx].ty, v: r, addr: None }
                } else {
                    eprintln!("{}: bad function call", self.line);
                    std::process::exit(1)
                };
            } else if self.sym[id_idx].class == tok::Num {
                let v = self.sym[id_idx].val;
                base = Val { ty: INT_TY, v: v.to_string(), addr: None };
            } else {
                let cls = self.sym[id_idx].class;
                let ty = self.sym[id_idx].ty;
                if cls == tok::Loc {
                    let slot = self.sym[id_idx].slot.clone();
                    let a = self.ptrtoint(&slot);
                    let v = self.load(&a, ty);
                    base = Val { ty, v, addr: Some(a) };
                } else if cls == tok::Glo {
                    let gname = format!("@g_{}", self.sym[id_idx].name);
                    let a = self.ptrtoint(&gname);
                    let v = self.load(&a, ty);
                    base = Val { ty, v, addr: Some(a) };
                } else {
                    eprintln!("{}: undefined variable", self.line);
                    std::process::exit(1);
                }
            }
        } else if self.tk == '(' as Cell {
            self.next();
            if self.tk == tok::Int || self.tk == tok::Char {
                let mut t = if self.tk == tok::Int { INT_TY } else { CHAR_TY };
                self.next();
                while self.tk == tok::Mul { self.next(); t += PTR_TY; }
                if self.tk == ')' as Cell { self.next(); } else { eprintln!("{}: bad cast", self.line); std::process::exit(1); }
                let e = self.expr(tok::Inc);
                base = Val { ty: t, v: e.v, addr: None };
            } else {
                let e = self.expr(tok::Assign);
                if self.tk == ')' as Cell { self.next(); } else { eprintln!("{}: close paren expected", self.line); std::process::exit(1); }
                base = e;
            }
        } else if self.tk == tok::Mul {
            self.next();
            let e = self.expr(tok::Inc);
            if e.ty > INT_TY {
                let ty = e.ty - PTR_TY;
                let a = e.v.clone();
                let v = self.load(&a, ty);
                base = Val { ty, v, addr: Some(a) };
            } else {
                eprintln!("{}: bad dereference", self.line);
                std::process::exit(1);
            }
        } else if self.tk == tok::And {
            self.next();
            let e = self.expr(tok::Inc);
            match e.addr {
                Some(a) => { base = Val { ty: e.ty + PTR_TY, v: a, addr: None }; }
                None => {
                    eprintln!("{}: bad address-of", self.line);
                    std::process::exit(1);
                }
            }
        } else if self.tk == '!' as Cell {
            self.next();
            let e = self.expr(tok::Inc);
            let c = self.new_tmp("c");
            self.ins(&format!("{} = icmp eq i64 {}, 0", c, e.v));
            let z = self.new_tmp("b");
            self.ins(&format!("{} = zext i1 {} to i64", z, c));
            base = Val { ty: INT_TY, v: z, addr: None };
        } else if self.tk == '~' as Cell {
            self.next();
            let e = self.expr(tok::Inc);
            let v = self.binop("xor", &e.v, "-1");
            base = Val { ty: INT_TY, v, addr: None };
        } else if self.tk == tok::Add {
            self.next();
            let e = self.expr(tok::Inc);
            base = Val { ty: INT_TY, v: e.v, addr: None };
        } else if self.tk == tok::Sub {
            self.next();
            if self.tk == tok::Num {
                let v = -self.ival;
                self.next();
                base = Val { ty: INT_TY, v: v.to_string(), addr: None };
            } else {
                let e = self.expr(tok::Inc);
                let v = self.binop("mul", "-1", &e.v);
                base = Val { ty: INT_TY, v, addr: None };
            }
        } else if self.tk == tok::Inc || self.tk == tok::Dec {
            let t = self.tk;
            self.next();
            let e = self.expr(tok::Inc);
            let addr = match &e.addr {
                Some(a) => a.clone(),
                None => {
                    eprintln!("{}: bad lvalue in pre-increment", self.line);
                    std::process::exit(1);
                }
            };
            let step: Cell = if e.ty > PTR_TY { 8 } else { 1 };
            let opname = if t == tok::Inc { "add" } else { "sub" };
            let nv = self.binop(opname, &e.v, &step.to_string());
            self.store(&addr, e.ty, &nv);
            base = Val { ty: e.ty, v: nv, addr: None };
        } else {
            eprintln!("{}: bad expression", self.line);
            std::process::exit(1);
        };

        while self.tk >= lev {
            let t = base.ty;
            let e = base;
            if self.tk == tok::Assign {
                self.next();
                let addr = match &e.addr {
                    Some(a) => a.clone(),
                    None => {
                        eprintln!("{}: bad lvalue in assignment", self.line);
                        std::process::exit(1);
                    }
                };
                let rhs = self.expr(tok::Assign);
                self.store(&addr, e.ty, &rhs.v);
                base = Val { ty: e.ty, v: rhs.v, addr: None };
            } else if self.tk == tok::Cond {
                self.next();
                let c1 = self.new_tmp("c");
                self.ins(&format!("{} = icmp ne i64 {}, 0", c1, e.v));
                let bt = self.new_lbl("cond.t");
                let bf = self.new_lbl("cond.f");
                let be = self.new_lbl("cond.end");
                self.br_cond(&c1, &bt, &bf);
                self.set_block(bt);
                let vt = self.expr(tok::Assign);
                if self.tk == ':' as Cell { self.next(); } else { eprintln!("{}: conditional missing colon", self.line); std::process::exit(1); }
                let t_block = self.cur_block.clone();
                let t_term = self.terminated;
                if !t_term { self.br(&be); }
                self.set_block(bf);
                let vf = self.expr(tok::Cond);
                let f_block = self.cur_block.clone();
                let f_term = self.terminated;
                if !f_term { self.br(&be); }
                self.set_block(be);
                if t_term && f_term {
                    self.terminated = true;
                    base = Val { ty: INT_TY, v: "0".to_string(), addr: None };
                } else {
                    let mut inc: Vec<String> = Vec::new();
                    if !t_term { inc.push(format!("[ {}, %{} ]", vt.v, t_block)); }
                    if !f_term { inc.push(format!("[ {}, %{} ]", vf.v, f_block)); }
                    let p = self.new_tmp("sel");
                    self.ins(&format!("{} = phi i64 {}", p, inc.join(", ")));
                    let rty = if f_term { vt.ty } else { vf.ty };
                    base = Val { ty: rty, v: p, addr: None };
                }
            } else if self.tk == tok::Lor {
                self.next();
                let c1 = self.new_tmp("c");
                self.ins(&format!("{} = icmp ne i64 {}, 0", c1, e.v));
                let brhs = self.new_lbl("lor.rhs");
                let bend = self.new_lbl("lor.end");
                let entry = self.cur_block.clone();
                self.br_cond(&c1, &brhs, &bend);
                self.set_block(brhs);
                let rhs = self.expr(tok::Lan);
                let c2 = self.new_tmp("c");
                self.ins(&format!("{} = icmp ne i64 {}, 0", c2, rhs.v));
                let r_block = self.cur_block.clone();
                let r_term = self.terminated;
                if !r_term { self.br(&bend); }
                self.set_block(bend);
                let p = self.new_tmp("b");
                if r_term {
                    self.ins(&format!("{} = phi i1 [ true, %{} ]", p, entry));
                } else {
                    self.ins(&format!("{} = phi i1 [ true, %{} ], [ {}, %{} ]", p, entry, c2, r_block));
                }
                let z = self.new_tmp("b");
                self.ins(&format!("{} = zext i1 {} to i64", z, p));
                base = Val { ty: INT_TY, v: z, addr: None };
            } else if self.tk == tok::Lan {
                self.next();
                let c1 = self.new_tmp("c");
                self.ins(&format!("{} = icmp ne i64 {}, 0", c1, e.v));
                let brhs = self.new_lbl("lan.rhs");
                let bend = self.new_lbl("lan.end");
                let entry = self.cur_block.clone();
                self.br_cond(&c1, &brhs, &bend);
                self.set_block(brhs);
                let rhs = self.expr(tok::Or);
                let c2 = self.new_tmp("c");
                self.ins(&format!("{} = icmp ne i64 {}, 0", c2, rhs.v));
                let r_block = self.cur_block.clone();
                let r_term = self.terminated;
                if !r_term { self.br(&bend); }
                self.set_block(bend);
                let p = self.new_tmp("b");
                if r_term {
                    self.ins(&format!("{} = phi i1 [ false, %{} ]", p, entry));
                } else {
                    self.ins(&format!("{} = phi i1 [ false, %{} ], [ {}, %{} ]", p, entry, c2, r_block));
                }
                let z = self.new_tmp("b");
                self.ins(&format!("{} = zext i1 {} to i64", z, p));
                base = Val { ty: INT_TY, v: z, addr: None };
            } else if self.tk == tok::Or {
                self.next();
                let rhs = self.expr(tok::Xor);
                let v = self.binop("or", &e.v, &rhs.v);
                base = Val { ty: INT_TY, v, addr: None };
            } else if self.tk == tok::Xor {
                self.next();
                let rhs = self.expr(tok::And);
                let v = self.binop("xor", &e.v, &rhs.v);
                base = Val { ty: INT_TY, v, addr: None };
            } else if self.tk == tok::And {
                self.next();
                let rhs = self.expr(tok::Eq);
                let v = self.binop("and", &e.v, &rhs.v);
                base = Val { ty: INT_TY, v, addr: None };
            } else if self.tk == tok::Eq {
                self.next();
                let rhs = self.expr(tok::Lt);
                let v = self.icmp("eq", &e.v, &rhs.v);
                base = Val { ty: INT_TY, v, addr: None };
            } else if self.tk == tok::Ne {
                self.next();
                let rhs = self.expr(tok::Lt);
                let v = self.icmp("ne", &e.v, &rhs.v);
                base = Val { ty: INT_TY, v, addr: None };
            } else if self.tk == tok::Lt {
                self.next();
                let rhs = self.expr(tok::Shl);
                let v = self.icmp("slt", &e.v, &rhs.v);
                base = Val { ty: INT_TY, v, addr: None };
            } else if self.tk == tok::Gt {
                self.next();
                let rhs = self.expr(tok::Shl);
                let v = self.icmp("sgt", &e.v, &rhs.v);
                base = Val { ty: INT_TY, v, addr: None };
            } else if self.tk == tok::Le {
                self.next();
                let rhs = self.expr(tok::Shl);
                let v = self.icmp("sle", &e.v, &rhs.v);
                base = Val { ty: INT_TY, v, addr: None };
            } else if self.tk == tok::Ge {
                self.next();
                let rhs = self.expr(tok::Shl);
                let v = self.icmp("sge", &e.v, &rhs.v);
                base = Val { ty: INT_TY, v, addr: None };
            } else if self.tk == tok::Shl {
                self.next();
                let rhs = self.expr(tok::Add);
                let v = self.binop("shl", &e.v, &rhs.v);
                base = Val { ty: INT_TY, v, addr: None };
            } else if self.tk == tok::Shr {
                self.next();
                let rhs = self.expr(tok::Add);
                let v = self.binop("ashr", &e.v, &rhs.v);
                base = Val { ty: INT_TY, v, addr: None };
            } else if self.tk == tok::Add {
                self.next();
                let rhs = self.expr(tok::Mul);
                if t > PTR_TY {
                    let m = self.binop("mul", &rhs.v, "8");
                    let v = self.binop("add", &e.v, &m);
                    base = Val { ty: t, v, addr: None };
                } else {
                    let v = self.binop("add", &e.v, &rhs.v);
                    base = Val { ty: t, v, addr: None };
                }
            } else if self.tk == tok::Sub {
                self.next();
                let rhs = self.expr(tok::Mul);
                if t > PTR_TY && t == rhs.ty {
                    let s = self.binop("sub", &e.v, &rhs.v);
                    let v = self.binop("sdiv", &s, "8");
                    base = Val { ty: INT_TY, v, addr: None };
                } else if t > PTR_TY {
                    let m = self.binop("mul", &rhs.v, "8");
                    let v = self.binop("sub", &e.v, &m);
                    base = Val { ty: t, v, addr: None };
                } else {
                    let v = self.binop("sub", &e.v, &rhs.v);
                    base = Val { ty: t, v, addr: None };
                }
            } else if self.tk == tok::Mul {
                self.next();
                let rhs = self.expr(tok::Inc);
                let v = self.binop("mul", &e.v, &rhs.v);
                base = Val { ty: INT_TY, v, addr: None };
            } else if self.tk == tok::Div {
                self.next();
                let rhs = self.expr(tok::Inc);
                let v = self.binop("sdiv", &e.v, &rhs.v);
                base = Val { ty: INT_TY, v, addr: None };
            } else if self.tk == tok::Mod {
                self.next();
                let rhs = self.expr(tok::Inc);
                let v = self.binop("srem", &e.v, &rhs.v);
                base = Val { ty: INT_TY, v, addr: None };
            } else if self.tk == tok::Inc || self.tk == tok::Dec {
                let t2 = self.tk;
                let addr = match &e.addr {
                    Some(a) => a.clone(),
                    None => {
                        eprintln!("{}: bad lvalue in post-increment", self.line);
                        std::process::exit(1);
                    }
                };
                let step: Cell = if e.ty > PTR_TY { 8 } else { 1 };
                let opname = if t2 == tok::Inc { "add" } else { "sub" };
                let nv = self.binop(opname, &e.v, &step.to_string());
                self.store(&addr, e.ty, &nv);
                base = Val { ty: e.ty, v: e.v.clone(), addr: None };
                self.next();
            } else if self.tk == tok::Brak {
                self.next();
                let idx = self.expr(tok::Assign);
                if self.tk == ']' as Cell { self.next(); } else { eprintln!("{}: close bracket expected", self.line); std::process::exit(1); }
                let addr = if t > PTR_TY {
                    let m = self.binop("mul", &idx.v, "8");
                    self.binop("add", &e.v, &m)
                } else if t < PTR_TY {
                    eprintln!("{}: pointer type expected", self.line);
                    std::process::exit(1);
                } else {
                    self.binop("add", &e.v, &idx.v)
                };
                let ty = t - PTR_TY;
                let v = self.load(&addr, ty);
                base = Val { ty, v, addr: Some(addr) };
            } else {
                eprintln!("{}: bad expression", self.line);
                std::process::exit(1);
            }
        }
        base
    }

    // ---------- statements ----------

    fn stmt(&mut self) {
        if self.tk == tok::If {
            self.next();
            if self.tk == '(' as Cell { self.next(); } else { eprintln!("{}: open paren expected", self.line); std::process::exit(1); }
            let e = self.expr(tok::Assign);
            if self.tk == ')' as Cell { self.next(); } else { eprintln!("{}: close paren expected", self.line); std::process::exit(1); }
            let c1 = self.new_tmp("c");
            self.ins(&format!("{} = icmp ne i64 {}, 0", c1, e.v));
            let lt = self.new_lbl("if.then");
            let le = self.new_lbl("if.else");
            let lend = self.new_lbl("if.end");
            self.br_cond(&c1, &lt, &le);
            self.set_block(lt);
            self.stmt();
            if !self.terminated { self.br(&lend); }
            self.set_block(le);
            if self.tk == tok::Else {
                self.next();
                self.stmt();
                if !self.terminated { self.br(&lend); }
            } else {
                self.br(&lend);
            }
            self.set_block(lend);
        } else if self.tk == tok::While {
            self.next();
            let lc = self.new_lbl("wh.cond");
            let lb = self.new_lbl("wh.body");
            let lend = self.new_lbl("wh.end");
            self.br(&lc);
            self.set_block(lc.clone());
            if self.tk == '(' as Cell { self.next(); } else { eprintln!("{}: open paren expected", self.line); std::process::exit(1); }
            let e = self.expr(tok::Assign);
            if self.tk == ')' as Cell { self.next(); } else { eprintln!("{}: close paren expected", self.line); std::process::exit(1); }
            let c1 = self.new_tmp("c");
            self.ins(&format!("{} = icmp ne i64 {}, 0", c1, e.v));
            self.br_cond(&c1, &lb, &lend);
            self.set_block(lb);
            self.stmt();
            if !self.terminated { self.br(&lc); }
            self.set_block(lend);
        } else if self.tk == tok::Return {
            self.next();
            let v = if self.tk != ';' as Cell {
                let e = self.expr(tok::Assign);
                e.v
            } else {
                "0".to_string()
            };
            if self.tk == ';' as Cell { self.next(); } else { eprintln!("{}: semicolon expected", self.line); std::process::exit(1); }
            if self.fn_is_main {
                let t = self.new_tmp("rv");
                self.ins(&format!("{} = trunc i64 {} to i32", t, &v));
                self.ins(&format!("ret i32 {}", t));
            } else {
                self.ins(&format!("ret i64 {}", v));
            }
            self.terminated = true;
        } else if self.tk == '{' as Cell {
            self.next();
            while self.tk != '}' as Cell { self.stmt(); }
            self.next();
        } else if self.tk == ';' as Cell {
            self.next();
        } else {
            let e = self.expr(tok::Assign);
            if self.tk == ';' as Cell { self.next(); } else { eprintln!("{}: semicolon expected", self.line); std::process::exit(1); }
            self.last_v = e.v;
        }
    }

    // ---------- keywords ----------

    fn init_keywords(&mut self) {
        let kw = "char else enum if int return sizeof while open creat read write close printf malloc free memset memcmp exit void main";
        let kw_bytes = kw.as_bytes().to_vec();
        let old_src = std::mem::replace(&mut self.src_bytes, kw_bytes);
        self.pos = 0;

        let mut i = tok::Char;
        while i <= tok::While {
            self.next();
            let idx = self.cur_id_idx;
            self.sym[idx].tk = i;
            i += 1;
        }
        let mut sys_op = op::OPEN;
        while sys_op <= op::EXIT {
            self.next();
            let idx = self.cur_id_idx;
            self.sym[idx].class = tok::Sys;
            self.sym[idx].ty = INT_TY;
            self.sym[idx].val = sys_op;
            sys_op += 1;
        }
        self.next(); // void
        let void_idx = self.cur_id_idx;
        self.sym[void_idx].tk = tok::Char;

        self.next(); // main

        self.src_bytes = old_src;
        self.pos = 0;
        self.line = 1;
    }

    // ---------- top level ----------

    fn compile(&mut self) -> bool {
        self.init_keywords();
        self.next();

        let mut found_main = false;

        while self.tk != 0 {
            let mut bt = INT_TY;
            if self.tk == tok::Int { self.next(); }
            else if self.tk == tok::Char { self.next(); bt = CHAR_TY; }
            else if self.tk == tok::Enum {
                self.next();
                if self.tk != '{' as Cell { self.next(); }
                if self.tk == '{' as Cell {
                    self.next();
                    let mut eval = 0;
                    while self.tk != '}' as Cell {
                        if self.tk != tok::Id { eprintln!("{}: bad enum identifier", self.line); std::process::exit(1); }
                        let idx = self.cur_id_idx;
                        self.next();
                        if self.tk == tok::Assign {
                            self.next();
                            if self.tk != tok::Num { eprintln!("{}: bad enum initializer", self.line); std::process::exit(1); }
                            eval = self.ival;
                            self.next();
                        }
                        self.sym[idx].class = tok::Num;
                        self.sym[idx].ty = INT_TY;
                        self.sym[idx].val = eval;
                        eval += 1;
                        if self.tk == ',' as Cell { self.next(); }
                    }
                    self.next();
                }
            }

            while self.tk != ';' as Cell && self.tk != '}' as Cell {
                let mut ty = bt;
                while self.tk == tok::Mul { self.next(); ty += PTR_TY; }
                if self.tk != tok::Id { eprintln!("{}: bad global declaration", self.line); std::process::exit(1); }
                let id_idx = self.cur_id_idx;
                if self.sym[id_idx].class != 0 { eprintln!("{}: duplicate global definition", self.line); std::process::exit(1); }
                self.next();
                self.sym[id_idx].ty = ty;

                if self.tk == '(' as Cell { // Function
                    self.sym[id_idx].class = tok::Fun;
                    let is_main = self.sym[id_idx].name == "main";
                    if is_main { found_main = true; }
                    let fname = self.sym[id_idx].name.clone();

                    self.next();
                    let mut params: Vec<(usize, Cell, String)> = Vec::new();
                    self.slot_n = 0;
                    while self.tk != ')' as Cell {
                        let mut pty = INT_TY;
                        if self.tk == tok::Int { self.next(); }
                        else if self.tk == tok::Char { self.next(); pty = CHAR_TY; }
                        while self.tk == tok::Mul { self.next(); pty += PTR_TY; }
                        if self.tk != tok::Id { eprintln!("{}: bad parameter declaration", self.line); std::process::exit(1); }
                        let pid = self.cur_id_idx;
                        if self.sym[pid].class == tok::Loc { eprintln!("{}: duplicate parameter definition", self.line); std::process::exit(1); }
                        self.sym[pid].hclass = self.sym[pid].class; self.sym[pid].class = tok::Loc;
                        self.sym[pid].hty = self.sym[pid].ty;       self.sym[pid].ty = pty;
                        self.sym[pid].hval = self.sym[pid].val;     self.sym[pid].val = params.len() as Cell;
                        let slot = format!("%s.{}", self.slot_n);
                        self.slot_n += 1;
                        self.sym[pid].slot = slot.clone();
                        params.push((pid, pty, slot));
                        self.next();
                        if self.tk == ',' as Cell { self.next(); }
                    }
                    self.next();
                    if self.tk != '{' as Cell { eprintln!("{}: bad function definition", self.line); std::process::exit(1); }
                    self.loc = params.len() as Cell + 1;
                    self.next();

                    let mut locals: Vec<(usize, Cell, String)> = Vec::new();
                    while self.tk == tok::Int || self.tk == tok::Char {
                        let lbt = if self.tk == tok::Int { INT_TY } else { CHAR_TY };
                        self.next();
                        while self.tk != ';' as Cell {
                            let mut lty = lbt;
                            while self.tk == tok::Mul { self.next(); lty += PTR_TY; }
                            if self.tk != tok::Id { eprintln!("{}: bad local declaration", self.line); std::process::exit(1); }
                            let lid = self.cur_id_idx;
                            if self.sym[lid].class == tok::Loc { eprintln!("{}: duplicate local definition", self.line); std::process::exit(1); }
                            self.sym[lid].hclass = self.sym[lid].class; self.sym[lid].class = tok::Loc;
                            self.sym[lid].hty = self.sym[lid].ty;       self.sym[lid].ty = lty;
                            self.sym[lid].hval = self.sym[lid].val;
                            self.sym[lid].val = self.loc;
                            self.loc += 1;
                            let slot = format!("%s.{}", self.slot_n);
                            self.slot_n += 1;
                            self.sym[lid].slot = slot.clone();
                            locals.push((lid, lty, slot));
                            self.next();
                            if self.tk == ',' as Cell { self.next(); }
                        }
                        self.next();
                    }

                    // prologue
                    self.ir_body.clear();
                    self.ir_body.push_str("entry:\n");
                    self.cur_block = "entry".to_string();
                    self.terminated = false;
                    self.tmp_n = 0;
                    self.lbl_n = 0;
                    self.last_v = "0".to_string();
                    self.fn_is_main = is_main;

                    if is_main {
                        self.fn_header = format!("define i32 @main(i32 %.argc, ptr %.argv) {{\n");
                    } else {
                        let ps: Vec<String> = (0..params.len()).map(|i| format!("i64 %a.{}", i)).collect();
                        self.fn_header = format!("define i64 @{}({}) {{\n", fname, ps.join(", "));
                    }

                    for (k, (_idx, _pty, slot)) in params.iter().enumerate() {
                        self.ins(&format!("{} = alloca i64", slot));
                        let sv = if is_main && k == 0 {
                            let t = self.new_tmp("ac");
                            self.ins(&format!("{} = sext i32 %.argc to i64", t));
                            t
                        } else if is_main && k == 1 {
                            let t = self.new_tmp("av");
                            self.ins(&format!("{} = ptrtoint ptr %.argv to i64", t));
                            t
                        } else if is_main {
                            "0".to_string()
                        } else {
                            format!("%a.{}", k)
                        };
                        self.ins(&format!("store i64 {}, ptr {}", sv, slot));
                    }
                    for (_idx, _pty, slot) in locals.iter() {
                        self.ins(&format!("{} = alloca i64", slot));
                    }

                    while self.tk != '}' as Cell { self.stmt(); }
                    self.end_fn();

                    for s in self.sym.iter_mut() {
                        if s.class == tok::Loc {
                            s.class = s.hclass;
                            s.ty = s.hty;
                            s.val = s.hval;
                            s.slot.clear();
                        }
                    }
                } else { // Global variable
                    self.sym[id_idx].class = tok::Glo;
                    let gname = format!("@g_{}", self.sym[id_idx].name);
                    let gdesc = if ty == CHAR_TY {
                        "i8 0".to_string()
                    } else if ty >= PTR_TY {
                        "ptr null".to_string()
                    } else {
                        "i64 0".to_string()
                    };
                    self.ir_head.push_str(&format!("{} = global {}\n", gname, gdesc));
                }
                if self.tk == ',' as Cell { self.next(); }
            }
            self.next();
        }

        found_main
    }

    fn module(&self) -> String {
        let mut m = String::new();
        m.push_str("; ModuleID = 'c4ll'\nsource_filename = \"c4ll\"\n\n");
        m.push_str(DECLS);
        m.push('\n');
        m.push_str(&self.ir_head);
        m.push('\n');
        m.push_str(&self.ir_funcs);
        m
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let mut infile = None;
    let mut outfile = "a.ll".to_string();

    let mut i = 1;
    while i < args.len() {
        if args[i] == "-o" && i + 1 < args.len() {
            i += 1;
            outfile = args[i].clone();
        } else if infile.is_none() {
            infile = Some(args[i].clone());
        } else {
            outfile = args[i].clone();
        }
        i += 1;
    }

    let input_path = match infile {
        Some(path) => path,
        None => {
            eprintln!("usage: c4ll [-o outfile.ll] infile.c");
            std::process::exit(1);
        }
    };

    let mut f = File::open(&input_path).expect("could not open input file");
    let mut src_bytes = Vec::new();
    f.read_to_end(&mut src_bytes).expect("could not read input file");

    let mut compiler = Compiler::new(src_bytes);
    if !compiler.compile() {
        eprintln!("main() not defined");
        std::process::exit(1);
    }

    let mut out = File::create(&outfile).expect("could not open output file");
    out.write_all(compiler.module().as_bytes()).unwrap();
}
