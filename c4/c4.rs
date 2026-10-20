// c4.rs - C4 Compiler in Rust (100% Faithful Port)
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
    pub const LEA: i64 = 0;
    pub const IMM: i64 = 1;
    pub const JMP: i64 = 2;
    pub const JSR: i64 = 3;
    pub const BZ: i64 = 4;
    pub const BNZ: i64 = 5;
    pub const ENT: i64 = 6;
    pub const ADJ: i64 = 7;
    pub const LEV: i64 = 8;
    pub const LI: i64 = 9;
    pub const LC: i64 = 10;
    pub const SI: i64 = 11;
    pub const SC: i64 = 12;
    pub const PSH: i64 = 13;
    pub const OR: i64 = 14;
    pub const XOR: i64 = 15;
    pub const AND: i64 = 16;
    pub const EQ: i64 = 17;
    pub const NE: i64 = 18;
    pub const LT: i64 = 19;
    pub const GT: i64 = 20;
    pub const LE: i64 = 21;
    pub const GE: i64 = 22;
    pub const SHL: i64 = 23;
    pub const SHR: i64 = 24;
    pub const ADD: i64 = 25;
    pub const SUB: i64 = 26;
    pub const MUL: i64 = 27;
    pub const DIV: i64 = 28;
    pub const MOD: i64 = 29;
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

const OP_NAMES: [&str; 41] = [
    "LEA ", "IMM ", "JMP ", "JSR ", "BZ  ", "BNZ ", "ENT ", "ADJ ", "LEV ", "LI  ", "LC  ",
    "SI  ", "SC  ", "PSH ", "OR  ", "XOR ", "AND ", "EQ  ", "NE  ", "LT  ", "GT  ", "LE  ",
    "GE  ", "SHL ", "SHR ", "ADD ", "SUB ", "MUL ", "DIV ", "MOD ", "OPEN", "CREA", "READ",
    "WRIT", "CLOS", "PRTF", "MALC", "FREE", "MSET", "MCMP", "EXIT",
];

const CHAR_TY: Cell = 0;
const INT_TY: Cell = 1;
const PTR_TY: Cell = 2;

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
}

struct Compiler {
    src_bytes: Vec<u8>,
    pos: usize,
    line: Cell,
    lp: usize,

    tk: Cell,
    ival: Cell,
    ty: Cell,
    loc: Cell,
    src_flag: bool,

    text: Vec<Cell>,
    line_info: Vec<Cell>,
    rel_data: Vec<Cell>,
    data: Vec<u8>,
    sym: Vec<Ident>,
    cur_id_idx: usize,
    le: usize,
}

impl Compiler {
    fn new(src_bytes: Vec<u8>, src_flag: bool) -> Self {
        Compiler {
            src_bytes,
            pos: 0,
            line: 1,
            lp: 0,
            tk: 0,
            ival: 0,
            ty: 0,
            loc: 0,
            src_flag,
            text: vec![0],
            line_info: vec![0],
            rel_data: Vec::new(),
            data: Vec::new(),
            sym: Vec::new(),
            cur_id_idx: 0,
            le: 0,
        }
    }

    fn emit(&mut self, val: Cell) {
        self.text.push(val);
        self.line_info.push(self.line);
    }

    fn mark_data_reloc(&mut self) {
        self.rel_data.push(self.text.len() as Cell);
    }

    fn next(&mut self) {
        while self.pos < self.src_bytes.len() {
            let b = self.src_bytes[self.pos];
            self.tk = b as Cell;
            self.pos += 1;

            if self.tk == '\n' as Cell {
                if self.src_flag {
                    let line_str = String::from_utf8_lossy(&self.src_bytes[self.lp..self.pos]);
                    print!("{}: {}", self.line, line_str);
                    self.lp = self.pos;
                    while self.le + 1 < self.text.len() {
                        self.le += 1;
                        let code = self.text[self.le];
                        print!("{}", OP_NAMES[code as usize]);
                        if code <= op::ADJ {
                            self.le += 1;
                            println!(" {}", self.text[self.le]);
                        } else {
                            println!();
                        }
                    }
                }
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
                return; // 關鍵修復：遇到 '!' 永遠要 return！
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

    fn expr(&mut self, lev: Cell) {
        if self.tk == 0 {
            eprintln!("{}: unexpected eof in expression", self.line);
            std::process::exit(1);
        } else if self.tk == tok::Num {
            let v = self.ival;
            self.emit(op::IMM);
            self.emit(v);
            self.next();
            self.ty = INT_TY;
        } else if self.tk == '"' as Cell {
            let v = self.ival;
            self.emit(op::IMM);
            self.mark_data_reloc();
            self.emit(v);
            self.next();
            while self.tk == '"' as Cell {
                self.next();
            }
            self.data.push(0);
            while self.data.len() % 8 != 0 {
                self.data.push(0);
            }
            self.ty = PTR_TY;
        } else if self.tk == tok::Sizeof {
            self.next();
            if self.tk == '(' as Cell { self.next(); } else { eprintln!("{}: open paren expected in sizeof", self.line); std::process::exit(1); }
            self.ty = INT_TY;
            if self.tk == tok::Int { self.next(); }
            else if self.tk == tok::Char { self.next(); self.ty = CHAR_TY; }
            while self.tk == tok::Mul { self.next(); self.ty += PTR_TY; }
            if self.tk == ')' as Cell { self.next(); } else { eprintln!("{}: close paren expected in sizeof", self.line); std::process::exit(1); }
            let sz = if self.ty == CHAR_TY { 1 } else { 8 };
            self.emit(op::IMM);
            self.emit(sz);
            self.ty = INT_TY;
        } else if self.tk == tok::Id {
            let id_idx = self.cur_id_idx;
            self.next();
            if self.tk == '(' as Cell {
                self.next();
                let mut t = 0;
                while self.tk != ')' as Cell {
                    self.expr(tok::Assign);
                    self.emit(op::PSH);
                    t += 1;
                    if self.tk == ',' as Cell { self.next(); }
                }
                self.next();
                let cls = self.sym[id_idx].class;
                let val = self.sym[id_idx].val;
                if cls == tok::Sys {
                    self.emit(val);
                } else if cls == tok::Fun {
                    self.emit(op::JSR);
                    self.emit(val);
                } else {
                    eprintln!("{}: bad function call", self.line);
                    std::process::exit(1);
                }
                if t > 0 {
                    self.emit(op::ADJ);
                    self.emit(t);
                }
                self.ty = self.sym[id_idx].ty;
            } else if self.sym[id_idx].class == tok::Num {
                let v = self.sym[id_idx].val;
                self.emit(op::IMM);
                self.emit(v);
                self.ty = INT_TY;
            } else {
                let cls = self.sym[id_idx].class;
                let val = self.sym[id_idx].val;
                if cls == tok::Loc {
                    self.emit(op::LEA);
                    self.emit(self.loc - val);
                } else if cls == tok::Glo {
                    self.emit(op::IMM);
                    self.mark_data_reloc();
                    self.emit(val);
                } else {
                    eprintln!("{}: undefined variable", self.line);
                    std::process::exit(1);
                }
                self.ty = self.sym[id_idx].ty;
                self.emit(if self.ty == CHAR_TY { op::LC } else { op::LI });
            }
        } else if self.tk == '(' as Cell {
            self.next();
            if self.tk == tok::Int || self.tk == tok::Char {
                let mut t = if self.tk == tok::Int { INT_TY } else { CHAR_TY };
                self.next();
                while self.tk == tok::Mul { self.next(); t += PTR_TY; }
                if self.tk == ')' as Cell { self.next(); } else { eprintln!("{}: bad cast", self.line); std::process::exit(1); }
                self.expr(tok::Inc);
                self.ty = t;
            } else {
                self.expr(tok::Assign);
                if self.tk == ')' as Cell { self.next(); } else { eprintln!("{}: close paren expected", self.line); std::process::exit(1); }
            }
        } else if self.tk == tok::Mul {
            self.next();
            self.expr(tok::Inc);
            if self.ty > INT_TY { self.ty -= PTR_TY; } else { eprintln!("{}: bad dereference", self.line); std::process::exit(1); }
            self.emit(if self.ty == CHAR_TY { op::LC } else { op::LI });
        } else if self.tk == tok::And {
            self.next();
            self.expr(tok::Inc);
            let last = *self.text.last().unwrap();
            if last == op::LC || last == op::LI {
                self.text.pop();
                self.line_info.pop();
            } else {
                eprintln!("{}: bad address-of", self.line);
                std::process::exit(1);
            }
            self.ty += PTR_TY;
        } else if self.tk == '!' as Cell {
            self.next(); self.expr(tok::Inc); self.emit(op::PSH); self.emit(op::IMM); self.emit(0); self.emit(op::EQ); self.ty = INT_TY;
        } else if self.tk == '~' as Cell {
            self.next(); self.expr(tok::Inc); self.emit(op::PSH); self.emit(op::IMM); self.emit(-1); self.emit(op::XOR); self.ty = INT_TY;
        } else if self.tk == tok::Add {
            self.next(); self.expr(tok::Inc); self.ty = INT_TY;
        } else if self.tk == tok::Sub {
            self.next(); self.emit(op::IMM);
            if self.tk == tok::Num {
                let v = -self.ival; self.emit(v); self.next();
            } else {
                self.emit(-1); self.emit(op::PSH); self.expr(tok::Inc); self.emit(op::MUL);
            }
            self.ty = INT_TY;
        } else if self.tk == tok::Inc || self.tk == tok::Dec {
            let t = self.tk; self.next(); self.expr(tok::Inc);
            let last_idx = self.text.len() - 1;
            let last = self.text[last_idx];
            if last == op::LC { self.text[last_idx] = op::PSH; self.emit(op::LC); }
            else if last == op::LI { self.text[last_idx] = op::PSH; self.emit(op::LI); }
            else { eprintln!("{}: bad lvalue in pre-increment", self.line); std::process::exit(1); }
            self.emit(op::PSH);
            self.emit(op::IMM);
            self.emit(if self.ty > PTR_TY { 8 } else { 1 });
            self.emit(if t == tok::Inc { op::ADD } else { op::SUB });
            self.emit(if self.ty == CHAR_TY { op::SC } else { op::SI });
        } else {
            eprintln!("{}: bad expression", self.line);
            std::process::exit(1);
        }

        while self.tk >= lev {
            let t = self.ty;
            if self.tk == tok::Assign {
                self.next();
                let last_idx = self.text.len() - 1;
                let last = self.text[last_idx];
                if last == op::LC || last == op::LI { self.text[last_idx] = op::PSH; }
                else { eprintln!("{}: bad lvalue in assignment", self.line); std::process::exit(1); }
                self.expr(tok::Assign);
                self.ty = t;
                self.emit(if self.ty == CHAR_TY { op::SC } else { op::SI });
            } else if self.tk == tok::Cond {
                self.next();
                self.emit(op::BZ);
                self.emit(0);
                let bz_addr_idx = self.text.len() - 1;
                self.expr(tok::Assign);
                if self.tk == ':' as Cell { self.next(); } else { eprintln!("{}: conditional missing colon", self.line); std::process::exit(1); }
                self.text[bz_addr_idx] = (self.text.len() + 2) as Cell;
                self.emit(op::JMP);
                self.emit(0);
                let jmp_addr_idx = self.text.len() - 1;
                self.expr(tok::Cond);
                self.text[jmp_addr_idx] = self.text.len() as Cell;
            } else if self.tk == tok::Lor {
                self.next();
                self.emit(op::BNZ); self.emit(0);
                let d = self.text.len() - 1;
                self.expr(tok::Lan);
                self.text[d] = self.text.len() as Cell;
                self.ty = INT_TY;
            } else if self.tk == tok::Lan {
                self.next();
                self.emit(op::BZ); self.emit(0);
                let d = self.text.len() - 1;
                self.expr(tok::Or);
                self.text[d] = self.text.len() as Cell;
                self.ty = INT_TY;
            } else if self.tk == tok::Or { self.next(); self.emit(op::PSH); self.expr(tok::Xor); self.emit(op::OR); self.ty = INT_TY; }
            else if self.tk == tok::Xor { self.next(); self.emit(op::PSH); self.expr(tok::And); self.emit(op::XOR); self.ty = INT_TY; }
            else if self.tk == tok::And { self.next(); self.emit(op::PSH); self.expr(tok::Eq); self.emit(op::AND); self.ty = INT_TY; }
            else if self.tk == tok::Eq { self.next(); self.emit(op::PSH); self.expr(tok::Lt); self.emit(op::EQ); self.ty = INT_TY; }
            else if self.tk == tok::Ne { self.next(); self.emit(op::PSH); self.expr(tok::Lt); self.emit(op::NE); self.ty = INT_TY; }
            else if self.tk == tok::Lt { self.next(); self.emit(op::PSH); self.expr(tok::Shl); self.emit(op::LT); self.ty = INT_TY; }
            else if self.tk == tok::Gt { self.next(); self.emit(op::PSH); self.expr(tok::Shl); self.emit(op::GT); self.ty = INT_TY; }
            else if self.tk == tok::Le { self.next(); self.emit(op::PSH); self.expr(tok::Shl); self.emit(op::LE); self.ty = INT_TY; }
            else if self.tk == tok::Ge { self.next(); self.emit(op::PSH); self.expr(tok::Shl); self.emit(op::GE); self.ty = INT_TY; }
            else if self.tk == tok::Shl { self.next(); self.emit(op::PSH); self.expr(tok::Add); self.emit(op::SHL); self.ty = INT_TY; }
            else if self.tk == tok::Shr { self.next(); self.emit(op::PSH); self.expr(tok::Add); self.emit(op::SHR); self.ty = INT_TY; }
            else if self.tk == tok::Add {
                self.next(); self.emit(op::PSH); self.expr(tok::Mul);
                self.ty = t;
                if self.ty > PTR_TY {
                    self.emit(op::PSH); self.emit(op::IMM); self.emit(8); self.emit(op::MUL);
                }
                self.emit(op::ADD);
            } else if self.tk == tok::Sub {
                self.next(); self.emit(op::PSH); self.expr(tok::Mul);
                if t > PTR_TY && t == self.ty {
                    self.emit(op::SUB); self.emit(op::PSH); self.emit(op::IMM); self.emit(8); self.emit(op::DIV); self.ty = INT_TY;
                } else {
                    self.ty = t;
                    if self.ty > PTR_TY {
                        self.emit(op::PSH); self.emit(op::IMM); self.emit(8); self.emit(op::MUL); self.emit(op::SUB);
                    } else {
                        self.emit(op::SUB);
                    }
                }
            } else if self.tk == tok::Mul { self.next(); self.emit(op::PSH); self.expr(tok::Inc); self.emit(op::MUL); self.ty = INT_TY; }
            else if self.tk == tok::Div { self.next(); self.emit(op::PSH); self.expr(tok::Inc); self.emit(op::DIV); self.ty = INT_TY; }
            else if self.tk == tok::Mod { self.next(); self.emit(op::PSH); self.expr(tok::Inc); self.emit(op::MOD); self.ty = INT_TY; }
            else if self.tk == tok::Inc || self.tk == tok::Dec {
                let last_idx = self.text.len() - 1;
                let last = self.text[last_idx];
                if last == op::LC { self.text[last_idx] = op::PSH; self.emit(op::LC); }
                else if last == op::LI { self.text[last_idx] = op::PSH; self.emit(op::LI); }
                else { eprintln!("{}: bad lvalue in post-increment", self.line); std::process::exit(1); }
                self.emit(op::PSH); self.emit(op::IMM); self.emit(if self.ty > PTR_TY { 8 } else { 1 });
                self.emit(if self.tk == tok::Inc { op::ADD } else { op::SUB });
                self.emit(if self.ty == CHAR_TY { op::SC } else { op::SI });
                self.emit(op::PSH); self.emit(op::IMM); self.emit(if self.ty > PTR_TY { 8 } else { 1 });
                self.emit(if self.tk == tok::Inc { op::SUB } else { op::ADD });
                self.next();
            } else if self.tk == tok::Brak {
                self.next(); self.emit(op::PSH); self.expr(tok::Assign);
                if self.tk == ']' as Cell { self.next(); } else { eprintln!("{}: close bracket expected", self.line); std::process::exit(1); }
                if t > PTR_TY { self.emit(op::PSH); self.emit(op::IMM); self.emit(8); self.emit(op::MUL); }
                else if t < PTR_TY { eprintln!("{}: pointer type expected", self.line); std::process::exit(1); }
                self.emit(op::ADD);
                self.ty = t - PTR_TY;
                self.emit(if self.ty == CHAR_TY { op::LC } else { op::LI });
            } else {
                eprintln!("{}: bad expression", self.line);
                std::process::exit(1);
            }
        }
    }

    fn stmt(&mut self) {
        if self.tk == tok::If {
            self.next();
            if self.tk == '(' as Cell { self.next(); } else { eprintln!("{}: open paren expected", self.line); std::process::exit(1); }
            self.expr(tok::Assign);
            if self.tk == ')' as Cell { self.next(); } else { eprintln!("{}: close paren expected", self.line); std::process::exit(1); }
            self.emit(op::BZ); self.emit(0);
            let b_idx = self.text.len() - 1;
            self.stmt();
            if self.tk == tok::Else {
                self.text[b_idx] = (self.text.len() + 2) as Cell;
                self.emit(op::JMP); self.emit(0);
                let else_jmp = self.text.len() - 1;
                self.next();
                self.stmt();
                self.text[else_jmp] = self.text.len() as Cell;
            } else {
                self.text[b_idx] = self.text.len() as Cell;
            }
        } else if self.tk == tok::While {
            self.next();
            let a = self.text.len();
            if self.tk == '(' as Cell { self.next(); } else { eprintln!("{}: open paren expected", self.line); std::process::exit(1); }
            self.expr(tok::Assign);
            if self.tk == ')' as Cell { self.next(); } else { eprintln!("{}: close paren expected", self.line); std::process::exit(1); }
            self.emit(op::BZ); self.emit(0);
            let b_idx = self.text.len() - 1;
            self.stmt();
            self.emit(op::JMP); self.emit(a as Cell);
            self.text[b_idx] = self.text.len() as Cell;
        } else if self.tk == tok::Return {
            self.next();
            if self.tk != ';' as Cell { self.expr(tok::Assign); }
            self.emit(op::LEV);
            if self.tk == ';' as Cell { self.next(); } else { eprintln!("{}: semicolon expected", self.line); std::process::exit(1); }
        } else if self.tk == '{' as Cell {
            self.next();
            while self.tk != '}' as Cell { self.stmt(); }
            self.next();
        } else if self.tk == ';' as Cell {
            self.next();
        } else {
            self.expr(tok::Assign);
            if self.tk == ';' as Cell { self.next(); } else { eprintln!("{}: semicolon expected", self.line); std::process::exit(1); }
        }
    }

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

    fn compile(&mut self) -> Cell {
        self.init_keywords();
        self.next();

        let mut idmain_val = 0;

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
                    self.sym[id_idx].val = self.text.len() as Cell;
                    if self.sym[id_idx].name == "main" {
                        idmain_val = self.sym[id_idx].val;
                    }

                    self.next();
                    let mut i = 0;
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
                        self.sym[pid].hval = self.sym[pid].val;     self.sym[pid].val = i;
                        i += 1;
                        self.next();
                        if self.tk == ',' as Cell { self.next(); }
                    }
                    self.next();
                    if self.tk != '{' as Cell { eprintln!("{}: bad function definition", self.line); std::process::exit(1); }
                    self.loc = i + 1;
                    i += 1;
                    self.next();

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
                            i += 1;
                            self.sym[lid].val = i;
                            self.next();
                            if self.tk == ',' as Cell { self.next(); }
                        }
                        self.next();
                    }

                    self.emit(op::ENT);
                    self.emit(i - self.loc);
                    while self.tk != '}' as Cell { self.stmt(); }
                    self.emit(op::LEV);

                    for s in self.sym.iter_mut() {
                        if s.class == tok::Loc {
                            s.class = s.hclass;
                            s.ty = s.hty;
                            s.val = s.hval;
                        }
                    }
                } else { // Global variable
                    self.sym[id_idx].class = tok::Glo;
                    self.sym[id_idx].val = self.data.len() as Cell;
                    for _ in 0..8 { self.data.push(0); }
                }
                if self.tk == ',' as Cell { self.next(); }
            }
            self.next();
        }

        idmain_val
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let mut src_flag = false;
    let mut infile = None;
    let mut outfile = "a.c4b".to_string();

    let mut i = 1;
    while i < args.len() {
        if args[i] == "-s" {
            src_flag = true;
        } else if args[i] == "-o" && i + 1 < args.len() {
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
            eprintln!("usage: c4 [-s] [-o outfile] infile.c [outfile.bc]");
            std::process::exit(1);
        }
    };

    let mut f = File::open(&input_path).expect("could not open input file");
    let mut src_bytes = Vec::new();
    f.read_to_end(&mut src_bytes).expect("could not read input file");

    let mut compiler = Compiler::new(src_bytes.clone(), src_flag);
    let main_off = compiler.compile();

    if main_off == 0 {
        eprintln!("main() not defined");
        std::process::exit(1);
    }

    let text_words = (compiler.text.len() - 1) as Cell;
    let data_bytes = compiler.data.len() as Cell;
    let rel_count = compiler.rel_data.len() as Cell;
    let src_len = src_bytes.len() as Cell;

    let header: [Cell; 6] = [
        0x43344243, // "C4BC"
        main_off,
        text_words,
        data_bytes,
        rel_count,
        src_len,
    ];

    let mut out = File::create(&outfile).expect("could not open output file");

    for h in &header {
        out.write_all(&h.to_le_bytes()).unwrap();
    }
    for word in &compiler.text[1..] {
        out.write_all(&word.to_le_bytes()).unwrap();
    }
    out.write_all(&compiler.data).unwrap();
    for r in &compiler.rel_data {
        out.write_all(&r.to_le_bytes()).unwrap();
    }
    for l in &compiler.line_info[1..] {
        out.write_all(&l.to_le_bytes()).unwrap();
    }
    out.write_all(&src_bytes).unwrap();
}