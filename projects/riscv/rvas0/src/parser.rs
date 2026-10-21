use crate::expr::{BinOp, Expr, RelocKind};
use crate::insts::Operand;
use crate::lexer::{LexError, Lexer, SrcLoc, Tok};
use crate::regs::{parse_fp_reg, parse_int_reg};

#[derive(Debug)]
pub struct AsmError {
    pub loc: Option<SrcLoc>,
    pub msg: String,
}

impl From<String> for AsmError {
    fn from(msg: String) -> Self {
        AsmError { loc: None, msg }
    }
}

impl AsmError {
    pub fn new(loc: &SrcLoc, msg: impl Into<String>) -> Self {
        AsmError { loc: Some(loc.clone()), msg: msg.into() }
    }
    pub fn plain(msg: impl Into<String>) -> Self {
        AsmError { loc: None, msg: msg.into() }
    }
}

impl std::fmt::Display for AsmError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match &self.loc {
            Some(l) => write!(f, "{}: error: {}", l, self.msg),
            None => write!(f, "rvas: error: {}", self.msg),
        }
    }
}

pub type PResult<T> = Result<T, AsmError>;

#[derive(Debug, Clone)]
pub enum DataItem {
    Expr(Expr),
    Float(f64),
}

#[derive(Debug, Clone)]
pub enum Dir {
    Section { name: String, flags: Option<String>, ty: Option<String>, entsize: Option<Expr> },
    PushSection { name: String, flags: Option<String>, ty: Option<String>, entsize: Option<Expr> },
    PopSection,
    KnownSection(&'static str),
    Globl(Vec<String>),
    Local(Vec<String>),
    Weak(Vec<String>),
    Vis { hidden: bool, names: Vec<String> },
    Type { name: String, ty: u8 },
    Size { name: String, expr: Expr },
    Align { pow: Expr, fill: Option<Expr>, max: Option<Expr> },
    BAlign { bytes: Expr, fill: Option<Expr>, max: Option<Expr> },
    Data { size: u32, items: Vec<DataItem> },
    Ascii { strs: Vec<String>, z: bool },
    Zero { n: Expr, fill: Option<Expr> },
    Comm { name: String, size: Expr, align: Option<Expr>, local: bool },
    OptionArgs(Vec<String>),
    Attribute { tag: String, str_val: Option<String>, int_val: Option<Expr> },
    IdentStr(String),
    Equ { name: String, expr: Expr, equiv: bool },
    Leb128 { items: Vec<Expr>, signed: bool },
    Ignore,
    Incbin { path: String, skip: Option<Expr>, count: Option<Expr> },
}

#[derive(Debug, Clone)]
pub enum Item {
    Label { name: String, loc: SrcLoc },
    NumLabelDef { num: i128 },
    Equ { name: String, expr: Expr, equiv: bool, loc: SrcLoc },
    Dir(Dir, SrcLoc),
    Insn { mnem: String, ops: Vec<Operand>, loc: SrcLoc },
}

pub const NUMREF: char = '\u{1}';

pub struct Parser {
    toks: Vec<(Tok, SrcLoc)>,
    pos: usize,
    include_dirs: Vec<String>,
    include_count: usize,
}

impl Parser {
    pub fn new(src: &str, file: &str, include_dirs: Vec<String>) -> PResult<Self> {
        let toks = tokenize(src, file)?;
        Ok(Parser { toks, pos: 0, include_dirs, include_count: 0 })
    }

    fn peek(&self) -> Option<&(Tok, SrcLoc)> {
        self.toks.get(self.pos)
    }

    fn peek_tok(&self) -> Option<&Tok> {
        self.toks.get(self.pos).map(|(t, _)| t)
    }

    fn at_eof(&self) -> bool {
        matches!(self.peek_tok(), None | Some(Tok::Eof))
    }

    fn eat_newlines(&mut self) {
        while matches!(self.peek_tok(), Some(Tok::Newline)) {
            self.pos += 1;
        }
    }

    pub fn parse(mut self) -> PResult<Vec<Item>> {
        let mut items = Vec::new();
        loop {
            self.eat_newlines();
            if self.at_eof() {
                break;
            }
            match self.peek().cloned() {
                Some((Tok::Num(n), loc)) => {
                    self.pos += 1;
                    match self.peek_tok() {
                        Some(Tok::Punct(":")) => {
                            self.pos += 1;
                            items.push(Item::NumLabelDef { num: n });
                        }
                        _ => return Err(AsmError::new(&loc, "junk after number at start of line")),
                    }
                }
                Some((Tok::Ident(s), loc)) => {
                    let starts_dot = s.starts_with('.') && s != ".";
                    let next_is_colon = matches!(self.toks.get(self.pos + 1).map(|(t, _)| t), Some(Tok::Punct(":")));
                    let next_is_eq = matches!(self.toks.get(self.pos + 1).map(|(t, _)| t), Some(Tok::Punct("=")));
                    if next_is_colon {
                        self.pos += 2;
                        items.push(Item::Label { name: s, loc });
                        continue;
                    }
                    if next_is_eq {
                        self.pos += 2;
                        let e = self.parse_expr()?;
                        self.expect_eol()?;
                        items.push(Item::Equ { name: s, expr: e, equiv: false, loc });
                        continue;
                    }
                    if starts_dot {
                        self.pos += 1;
                        let dir = self.parse_directive(&s, &loc)?;
                        items.push(Item::Dir(dir, loc));
                    } else {
                        self.pos += 1;
                        let ops = self.parse_operands()?;
                        self.expect_eol()?;
                        items.push(Item::Insn { mnem: s, ops, loc });
                    }
                }
                Some((tok, loc)) => {
                    return Err(AsmError::new(&loc, format!("unexpected token {:?}", tok)));
                }
                None => break,
            }
        }
        Ok(items)
    }

    fn expect_eol(&mut self) -> PResult<()> {
        match self.peek_tok() {
            None | Some(Tok::Eof) | Some(Tok::Newline) => Ok(()),
            Some(t) => {
                let loc = self.peek().unwrap().1.clone();
                Err(AsmError::new(&loc, format!("junk at end of line: {:?}", t)))
            }
        }
    }

    fn parse_operands(&mut self) -> PResult<Vec<Operand>> {
        let mut ops = Vec::new();
        if matches!(self.peek_tok(), None | Some(Tok::Eof) | Some(Tok::Newline)) {
            return Ok(ops);
        }
        loop {
            ops.push(self.parse_operand()?);
            match self.peek_tok() {
                Some(Tok::Punct(",")) => {
                    self.pos += 1;
                }
                _ => break,
            }
        }
        Ok(ops)
    }

    fn parse_operand(&mut self) -> PResult<Operand> {
        let loc = self.peek().map(|(_, l)| l.clone()).unwrap_or(SrcLoc { file: "?".into(), line: 0 });
        match self.peek_tok() {
            Some(Tok::Punct("(")) => {
                self.pos += 1;
                let base = self.parse_reg(&loc)?;
                self.expect_punct(")")?;
                return Ok(Operand::Mem(Expr::Num(0), base));
            }
            Some(Tok::Ident(s)) => {
                if let Some(r) = parse_int_reg(s) {
                    self.pos += 1;
                    return Ok(Operand::RegI(r));
                }
                if let Some(r) = parse_fp_reg(s) {
                    self.pos += 1;
                    return Ok(Operand::RegF(r));
                }
            }
            _ => {}
        }
        let e = self.parse_expr()?;
        if matches!(self.peek_tok(), Some(Tok::Punct("("))) {
            self.pos += 1;
            let base = self.parse_reg(&loc)?;
            self.expect_punct(")")?;
            Ok(Operand::Mem(e, base))
        } else {
            Ok(Operand::Expr(e))
        }
    }

    fn parse_reg(&mut self, loc: &SrcLoc) -> PResult<u32> {
        match self.peek_tok() {
            Some(Tok::Ident(s)) => {
                if let Some(r) = parse_int_reg(s) {
                    self.pos += 1;
                    return Ok(r);
                }
                if let Some(r) = parse_fp_reg(s) {
                    self.pos += 1;
                    return Ok(r);
                }
                Err(AsmError::new(loc, format!("expected register, got '{}'", s)))
            }
            _ => Err(AsmError::new(loc, "expected register")),
        }
    }

    fn expect_punct(&mut self, p: &str) -> PResult<()> {
        match self.peek_tok() {
            Some(Tok::Punct(x)) if *x == p => {
                self.pos += 1;
                Ok(())
            }
            _ => {
                let loc = self.peek().map(|(_, l)| l.clone()).unwrap_or(SrcLoc { file: "?".into(), line: 0 });
                Err(AsmError::new(&loc, format!("expected '{}'", p)))
            }
        }
    }

    fn parse_expr(&mut self) -> PResult<Expr> {
        self.parse_bin(0)
    }

    fn parse_bin(&mut self, min_prec: u8) -> PResult<Expr> {
        let mut lhs = self.parse_unary()?;
        loop {
            let (op, prec) = match self.peek_tok() {
                Some(Tok::Punct("+")) => (BinOp::Add, 7u8),
                Some(Tok::Punct("-")) => (BinOp::Sub, 7),
                Some(Tok::Punct("*")) => (BinOp::Mul, 8),
                Some(Tok::Punct("/")) => (BinOp::Div, 8),
                Some(Tok::Punct("%")) => (BinOp::Mod, 8),
                Some(Tok::Punct("<<")) => (BinOp::Shl, 6),
                Some(Tok::Punct(">>")) => (BinOp::Shr, 6),
                Some(Tok::Punct("&")) => (BinOp::And, 5),
                Some(Tok::Punct("|")) => (BinOp::Or, 3),
                Some(Tok::Punct("^")) => (BinOp::Xor, 4),
                Some(Tok::Punct("&&")) => (BinOp::And, 2),
                Some(Tok::Punct("||")) => (BinOp::Or, 1),
                _ => break,
            };
            if prec < min_prec {
                break;
            }
            self.pos += 1;
            let rhs = self.parse_bin(prec + 1)?;
            lhs = Expr::Bin(op, Box::new(lhs), Box::new(rhs));
        }
        Ok(lhs)
    }

    fn parse_unary(&mut self) -> PResult<Expr> {
        match self.peek_tok() {
            Some(Tok::Punct("-")) => {
                self.pos += 1;
                Ok(Expr::Neg(Box::new(self.parse_unary()?)))
            }
            Some(Tok::Punct("+")) => {
                self.pos += 1;
                self.parse_unary()
            }
            Some(Tok::Punct("~")) => {
                self.pos += 1;
                Ok(Expr::Not(Box::new(self.parse_unary()?)))
            }
            Some(Tok::Punct("!")) => {
                self.pos += 1;
                let inner = self.parse_unary()?;
                Ok(Expr::Bin(BinOp::Xor, Box::new(inner), Box::new(Expr::Num(0))))
            }
            _ => self.parse_primary(),
        }
    }

    fn parse_primary(&mut self) -> PResult<Expr> {
        let (tok, loc) = match self.peek().cloned() {
            Some(x) => x,
            None => return Err(AsmError::plain("unexpected end of input in expression")),
        };
        match tok {
            Tok::Num(n) => {
                self.pos += 1;
                if let Some(Tok::Ident(s)) = self.peek_tok().cloned() {
                    if (s == "b" || s == "f") && n >= 0 && n < 100000 {
                        self.pos += 1;
                        return Ok(Expr::Sym(format!("{}num{}{}", NUMREF, n, s)));
                    }
                }
                Ok(Expr::Num(n))
            }
            Tok::Float(f) => {
                let _ = f;
                Err(AsmError::new(&loc, "floating point constant not allowed here"))
            }
            Tok::Ident(s) => {
                self.pos += 1;
                if s == "." {
                    Ok(Expr::Dot)
                } else {
                    Ok(Expr::Sym(s))
                }
            }
            Tok::Punct("(") => {
                self.pos += 1;
                let e = self.parse_expr()?;
                self.expect_punct(")")?;
                Ok(e)
            }
            Tok::Punct("%") => {
                self.pos += 1;
                let name = match self.peek_tok() {
                    Some(Tok::Ident(s)) => s.clone(),
                    _ => return Err(AsmError::new(&loc, "expected relocation modifier after '%'")),
                };
                self.pos += 1;
                self.expect_punct("(")?;
                let inner = self.parse_expr()?;
                self.expect_punct(")")?;
                let kind = match name.as_str() {
                    "hi" => RelocKind::RiscvHi20,
                    "lo" => RelocKind::RiscvLo12I,
                    "pcrel_hi" => RelocKind::RiscvPcrelHi20,
                    "pcrel_lo" => RelocKind::RiscvPcrelLo12I,
                    other => {
                        return Err(AsmError::new(&loc, format!("unsupported relocation modifier '%{}'", other)))
                    }
                };
                Ok(Expr::Reloc(kind, Box::new(inner)))
            }
            Tok::Str(s) => Err(AsmError::new(&loc, format!("unexpected string \"{}\" in expression", s))),
            t => Err(AsmError::new(&loc, format!("unexpected token {:?} in expression", t))),
        }
    }

    fn parse_ident(&mut self, what: &str) -> PResult<String> {
        match self.peek_tok() {
            Some(Tok::Ident(s)) => {
                let s = s.clone();
                self.pos += 1;
                Ok(s)
            }
            Some(Tok::Str(s)) => {
                let s = s.clone();
                self.pos += 1;
                Ok(s)
            }
            _ => {
                let loc = self.peek().map(|(_, l)| l.clone()).unwrap_or(SrcLoc { file: "?".into(), line: 0 });
                Err(AsmError::new(&loc, format!("expected {}", what)))
            }
        }
    }

    fn parse_ident_list(&mut self) -> PResult<Vec<String>> {
        let mut v = vec![self.parse_ident("symbol name")?];
        while matches!(self.peek_tok(), Some(Tok::Punct(","))) {
            self.pos += 1;
            v.push(self.parse_ident("symbol name")?);
        }
        Ok(v)
    }

    fn parse_expr_list(&mut self) -> PResult<Vec<Expr>> {
        let mut v = vec![self.parse_expr()?];
        while matches!(self.peek_tok(), Some(Tok::Punct(","))) {
            self.pos += 1;
            v.push(self.parse_expr()?);
        }
        Ok(v)
    }

    fn opt_expr(&mut self) -> PResult<Option<Expr>> {
        if matches!(self.peek_tok(), Some(Tok::Punct(","))) {
            self.pos += 1;
            Ok(Some(self.parse_expr()?))
        } else {
            Ok(None)
        }
    }

    fn parse_section_tail(&mut self) -> PResult<(String, Option<String>, Option<String>, Option<Expr>)> {
        let name = self.parse_ident("section name")?;
        let mut flags = None;
        let mut ty = None;
        let mut entsize = None;
        if matches!(self.peek_tok(), Some(Tok::Punct(","))) {
            self.pos += 1;
            flags = match self.peek_tok() {
                Some(Tok::Str(s)) => {
                    let s = s.clone();
                    self.pos += 1;
                    Some(s)
                }
                _ => return Err(AsmError::plain("expected flags string in .section")),
            };
            if matches!(self.peek_tok(), Some(Tok::Punct(","))) {
                self.pos += 1;
                match self.peek_tok() {
                    Some(Tok::Punct("@")) | Some(Tok::Punct("%")) => {
                        self.pos += 1;
                    }
                    _ => {}
                }
                ty = Some(self.parse_ident("section type")?);
                if matches!(self.peek_tok(), Some(Tok::Punct(","))) {
                    self.pos += 1;
                    entsize = Some(self.parse_expr()?);
                }
            }
        }
        Ok((name, flags, ty, entsize))
    }

    fn parse_directive(&mut self, name: &str, loc: &SrcLoc) -> PResult<Dir> {
        let d = match name {
            ".text" => Dir::KnownSection(".text"),
            ".data" => Dir::KnownSection(".data"),
            ".bss" => Dir::KnownSection(".bss"),
            ".rodata" => Dir::KnownSection(".rodata"),
            ".sdata" => Dir::KnownSection(".sdata"),
            ".sbss" => Dir::KnownSection(".sbss"),
            ".srodata" => Dir::KnownSection(".srodata"),
            ".section" => {
                let (n, f, t, e) = self.parse_section_tail()?;
                Dir::Section { name: n, flags: f, ty: t, entsize: e }
            }
            ".pushsection" => {
                let (n, f, t, e) = self.parse_section_tail()?;
                Dir::PushSection { name: n, flags: f, ty: t, entsize: e }
            }
            ".popsection" => Dir::PopSection,
            ".globl" | ".global" => Dir::Globl(self.parse_ident_list()?),
            ".local" => Dir::Local(self.parse_ident_list()?),
            ".weak" => Dir::Weak(self.parse_ident_list()?),
            ".hidden" => Dir::Vis { hidden: true, names: self.parse_ident_list()? },
            ".internal" | ".protected" => Dir::Vis { hidden: false, names: self.parse_ident_list()? },
            ".type" => {
                let sym = self.parse_ident("symbol name")?;
                self.expect_punct(",")?;
                match self.peek_tok() {
                    Some(Tok::Punct("@")) | Some(Tok::Punct("%")) => {
                        self.pos += 1;
                    }
                    _ => {}
                }
                let tname = self.parse_ident("type")?;
                let ty = match tname.trim_start_matches("@").trim_start_matches('%') {
                    "function" => 2u8,
                    "object" => 1,
                    "notype" => 0,
                    "gnu_unique_object" => 1,
                    other => {
                        return Err(AsmError::new(loc, format!("unsupported .type '{}'", other)));
                    }
                };
                Dir::Type { name: sym, ty }
            }
            ".size" => {
                let sym = self.parse_ident("symbol name")?;
                self.expect_punct(",")?;
                let e = self.parse_expr()?;
                Dir::Size { name: sym, expr: e }
            }
            ".align" | ".p2align" => {
                let pow = self.parse_expr()?;
                let fill = self.opt_expr()?;
                let max = self.opt_expr()?;
                Dir::Align { pow, fill, max }
            }
            ".balign" => {
                let bytes = self.parse_expr()?;
                let fill = self.opt_expr()?;
                let max = self.opt_expr()?;
                Dir::BAlign { bytes, fill, max }
            }
            ".byte" => Dir::Data { size: 1, items: to_items(self.parse_expr_list()?) },
            ".half" | ".short" | ".2byte" => Dir::Data { size: 2, items: to_items(self.parse_expr_list()?) },
            ".word" | ".long" | ".4byte" | ".int" => Dir::Data { size: 4, items: to_items(self.parse_expr_list()?) },
            ".dword" | ".quad" | ".8byte" => Dir::Data { size: 8, items: to_items(self.parse_expr_list()?) },
            ".float" | ".single" => Dir::Data { size: 4, items: self.parse_float_list()? },
            ".double" => Dir::Data { size: 8, items: self.parse_float_list()? },
            ".ascii" => Dir::Ascii { strs: self.parse_str_list()?, z: false },
            ".asciz" | ".string" => Dir::Ascii { strs: self.parse_str_list()?, z: true },
            ".zero" | ".space" | ".skip" => {
                let n = self.parse_expr()?;
                let fill = self.opt_expr()?;
                Dir::Zero { n, fill }
            }
            ".comm" => {
                let sym = self.parse_ident("symbol name")?;
                self.expect_punct(",")?;
                let size = self.parse_expr()?;
                let align = self.opt_expr()?;
                Dir::Comm { name: sym, size, align, local: false }
            }
            ".lcomm" => {
                let sym = self.parse_ident("symbol name")?;
                self.expect_punct(",")?;
                let size = self.parse_expr()?;
                let align = self.opt_expr()?;
                Dir::Comm { name: sym, size, align, local: true }
            }
            ".equ" | ".set" | ".eqv" => {
                let sym = self.parse_ident("symbol name")?;
                self.expect_punct(",")?;
                let e = self.parse_expr()?;
                Dir::Equ { name: sym, expr: e, equiv: false }
            }
            ".equiv" => {
                let sym = self.parse_ident("symbol name")?;
                self.expect_punct(",")?;
                let e = self.parse_expr()?;
                Dir::Equ { name: sym, expr: e, equiv: true }
            }
            ".option" => {
                let mut args = Vec::new();
                loop {
                    match self.peek_tok() {
                        Some(Tok::Ident(s)) => args.push(s.clone()),
                        Some(Tok::Num(n)) => args.push(n.to_string()),
                        Some(Tok::Str(s)) => args.push(s.clone()),
                        _ => break,
                    }
                    self.pos += 1;
                    if matches!(self.peek_tok(), Some(Tok::Punct(","))) {
                        self.pos += 1;
                        continue;
                    }
                    break;
                }
                Dir::OptionArgs(args)
            }
            ".attribute" => {
                let tag = match self.peek_tok() {
                    Some(Tok::Ident(s)) => {
                        let s = s.clone();
                        self.pos += 1;
                        s
                    }
                    Some(Tok::Str(s)) => {
                        let s = s.clone();
                        self.pos += 1;
                        s
                    }
                    _ => return Err(AsmError::new(loc, "expected attribute tag")),
                };
                self.expect_punct(",")?;
                match self.peek_tok() {
                    Some(Tok::Str(s)) => {
                        let s = s.clone();
                        self.pos += 1;
                        Dir::Attribute { tag, str_val: Some(s), int_val: None }
                    }
                    _ => {
                        let e = self.parse_expr()?;
                        Dir::Attribute { tag, str_val: None, int_val: Some(e) }
                    }
                }
            }
            ".ident" => {
                let s = match self.peek_tok() {
                    Some(Tok::Str(s)) => {
                        let s = s.clone();
                        self.pos += 1;
                        s
                    }
                    _ => return Err(AsmError::new(loc, ".ident expects a string")),
                };
                Dir::IdentStr(s)
            }
            ".include" => {
                let p = match self.peek_tok() {
                    Some(Tok::Str(s)) => {
                        let s = s.clone();
                        self.pos += 1;
                        s
                    }
                    _ => return Err(AsmError::new(loc, ".include expects a string")),
                };
                self.splice_include(&p, loc)?;
                Dir::Ignore
            }
            ".incbin" => {
                let p = match self.peek_tok() {
                    Some(Tok::Str(s)) => {
                        let s = s.clone();
                        self.pos += 1;
                        s
                    }
                    _ => return Err(AsmError::new(loc, ".incbin expects a string")),
                };
                let skip = self.opt_expr()?;
                let count = self.opt_expr()?;
                Dir::Incbin { path: p, skip, count }
            }
            ".uleb128" => Dir::Leb128 { items: self.parse_expr_list()?, signed: false },
            ".sleb128" => Dir::Leb128 { items: self.parse_expr_list()?, signed: true },
            _ => {
                if is_ignored_directive(name) {
                    while !matches!(self.peek_tok(), None | Some(Tok::Eof) | Some(Tok::Newline)) {
                        self.pos += 1;
                    }
                    return Ok(Dir::Ignore);
                } else {
                    return Err(AsmError::new(loc, format!("unknown directive '{}'", name)));
                }
            }
        };
        self.expect_eol()?;
        Ok(d)
    }

    fn splice_include(&mut self, path: &str, loc: &SrcLoc) -> PResult<()> {
        if self.include_count > 512 {
            return Err(AsmError::new(loc, "too many .include directives"));
        }
        let mut candidates: Vec<std::path::PathBuf> = Vec::new();
        let p = std::path::Path::new(path);
        if p.is_absolute() {
            candidates.push(p.to_path_buf());
        } else {
            candidates.push(p.to_path_buf());
            for d in &self.include_dirs {
                candidates.push(std::path::Path::new(d).join(p));
            }
        }
        let mut found = None;
        for c in &candidates {
            if c.is_file() {
                found = Some(c.clone());
                break;
            }
        }
        let path = found.ok_or_else(|| AsmError::new(loc, format!("cannot find include file '{}'", path)))?;
        let src = std::fs::read_to_string(&path)
            .map_err(|e| AsmError::new(loc, format!("cannot read '{}': {}", path.display(), e)))?;
        let fname = path.file_name().map(|s| s.to_string_lossy().into_owned()).unwrap_or_default();
        let sub = tokenize(&src, &fname)?;
        let _n = sub.len();
        let end = sub.last().map(|(_, l)| l.line).unwrap_or(0);
        let _ = end;
        self.toks.splice(self.pos..self.pos, sub);
        self.include_count += 1;
        Ok(())
    }

    fn parse_float_list(&mut self) -> PResult<Vec<DataItem>> {
        let mut v = Vec::new();
        loop {
            let neg = if matches!(self.peek_tok(), Some(Tok::Punct("-"))) {
                self.pos += 1;
                true
            } else {
                false
            };
            let f = match self.peek_tok() {
                Some(Tok::Float(f)) => {
                    let f = *f;
                    self.pos += 1;
                    f
                }
                Some(Tok::Num(n)) => {
                    let n = *n;
                    self.pos += 1;
                    n as f64
                }
                _ => return Err(AsmError::plain("expected floating point literal")),
            };
            v.push(DataItem::Float(if neg { -f } else { f }));
            if matches!(self.peek_tok(), Some(Tok::Punct(","))) {
                self.pos += 1;
                continue;
            }
            break;
        }
        Ok(v)
    }

    fn parse_str_list(&mut self) -> PResult<Vec<String>> {
        let mut v = Vec::new();
        loop {
            match self.peek_tok() {
                Some(Tok::Str(s)) => {
                    v.push(s.clone());
                    self.pos += 1;
                }
                _ => return Err(AsmError::plain("expected string literal")),
            }
            if matches!(self.peek_tok(), Some(Tok::Punct(","))) {
                self.pos += 1;
                continue;
            }
            break;
        }
        Ok(v)
    }
}

fn to_items(v: Vec<Expr>) -> Vec<DataItem> {
    v.into_iter().map(DataItem::Expr).collect()
}

fn is_ignored_directive(name: &str) -> bool {
    matches!(
        name,
        ".file"
            | ".loc"
            | ".loc_mark_labels"
            | ".cfi_startproc"
            | ".cfi_endproc"
            | ".cfi_def_cfa"
            | ".cfi_def_cfa_offset"
            | ".cfi_def_cfa_register"
            | ".cfi_offset"
            | ".cfi_rel_offset"
            | ".cfi_restore"
            | ".cfi_undefined"
            | ".cfi_register"
            | ".cfi_return_column"
            | ".cfi_remember_state"
            | ".cfi_restore_state"
            | ".cfi_escape"
            | ".cfi_personality"
            | ".cfi_lsda"
            | ".cfi_sections"
            | ".cfi_inline_lsda"
            | ".cfi_signal_frame"
            | ".cfi_window_save"
            | ".addrsig"
            | ".addrsig_sym"
            | ".previous"
            | ".func"
            | ".endfunc"
            | ".reloc"
            | ".weakref"
            | ".subsection"
            | ".irp"
            | ".rept"
            | ".endr"
            | ".if"
            | ".else"
            | ".elseif"
            | ".endif"
            | ".ifndef"
            | ".ifdef"
            | ".ifc"
            | ".ifeq"
            | ".ifge"
            | ".ifgt"
            | ".ifle"
            | ".iflt"
            | ".ifne"
            | ".ifnc"
    )
}

fn tokenize(src: &str, file: &str) -> PResult<Vec<(Tok, SrcLoc)>> {
    Lexer::new(src, file).tokenize().map_err(|LexError { loc, msg }| AsmError { loc: Some(loc), msg })
}
