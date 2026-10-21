//! ll2rv — 將 LLVM IR (.ll) 轉換為 RISC-V 64 (RV64GC, LP64 ABI) 組合語言 (.s)
//!
//! 設計：最簡單的「每個 SSA 值一個堆疊槽」(-O0 風格) 程式碼產生器。
//!   * 整數值在槽內一律以「符號延伸成 64 位元」的正規形式保存 (i1 為 0/1)。
//!   * phi 在 CFG 邊上以堆疊槽複製實作 (含 swap 問題的暫存區)。
//!   * 暫存器：t0-t2 為運算暫存，t5/t6 為內部暫存，a0-a7 為呼叫參數。
//!   * 不支援：浮點、向量、i128、聚合值 (struct/array) 的 load/store/phi、
//!     可變參數函式的「定義」(呼叫 printf 之類的外部 variadic 函式則可以)。

use std::collections::HashMap;
use std::fmt::Write as _;
use std::{env, fs, process};

type Res<T> = Result<T, String>;

fn align_up(x: u64, a: u64) -> u64 {
    let a = a.max(1);
    (x + a - 1) / a * a
}

// ───────────────────────────── 型別 ─────────────────────────────

#[derive(Clone, Debug, PartialEq)]
enum Ty {
    Void,
    Int(u32),
    Ptr,
    Array(u64, Box<Ty>),
    Struct(Vec<Ty>),
}

impl Ty {
    fn size(&self) -> u64 {
        match self {
            Ty::Void => 0,
            Ty::Int(b) => match *b {
                0..=8 => 1,
                9..=16 => 2,
                17..=32 => 4,
                _ => 8,
            },
            Ty::Ptr => 8,
            Ty::Array(n, t) => n * t.size(),
            Ty::Struct(f) => {
                let mut off = 0;
                let mut al = 1;
                for t in f {
                    off = align_up(off, t.align()) + t.size();
                    al = al.max(t.align());
                }
                align_up(off, al)
            }
        }
    }
    fn align(&self) -> u64 {
        match self {
            Ty::Void => 1,
            Ty::Array(_, t) => t.align(),
            Ty::Struct(f) => f.iter().map(|t| t.align()).max().unwrap_or(1),
            _ => self.size().max(1),
        }
    }
    /// 純量位元寬度 (指標視為 64)
    fn bits(&self) -> Res<u32> {
        match self {
            Ty::Int(b) if *b >= 1 && *b <= 64 => Ok(*b),
            Ty::Ptr => Ok(64),
            t => Err(format!("unsupported scalar type {:?}", t)),
        }
    }
}

fn field_offset(f: &[Ty], idx: usize) -> u64 {
    let mut off = 0;
    for (i, t) in f.iter().enumerate() {
        off = align_up(off, t.align());
        if i == idx {
            return off;
        }
        off += t.size();
    }
    off
}

// ───────────────────────────── IR ─────────────────────────────

#[derive(Clone, Debug)]
enum Val {
    Local(String),
    Global(String),
    Int(i64),
}

#[derive(Clone, Debug)]
enum Inst {
    Bin { dst: String, op: String, ty: Ty, a: Val, b: Val },
    Icmp { dst: String, pred: String, ty: Ty, a: Val, b: Val },
    Alloca { dst: String, ty: Ty, count: u64 },
    Load { dst: String, ty: Ty, ptr: Val },
    Store { ty: Ty, val: Val, ptr: Val },
    Gep { dst: String, ty: Ty, ptr: Val, idx: Vec<Val> },
    Cast { dst: String, op: String, from: Ty, v: Val, to: Ty },
    Select { dst: String, c: Val, a: Val, b: Val },
    Phi { dst: String, inc: Vec<(Val, String)> },
    Call { dst: Option<String>, ret: Ty, callee: Val, args: Vec<(Ty, Val)> },
    Br(String),
    CondBr(Val, String, String),
    Switch { v: Val, def: String, cases: Vec<(i64, String)> },
    Ret(Option<(Ty, Val)>),
    Unreachable,
    Nop,
}

struct Block {
    name: String,
    insts: Vec<Inst>,
}

struct Func {
    name: String,
    params: Vec<(Ty, String)>,
    blocks: Vec<Block>,
    global: bool,
}

enum Item {
    Bytes(Vec<u8>),
    Zero(u64),
    Sym(String),
}

struct Global {
    name: String,
    ty: Ty,
    init: Vec<Item>,
    constant: bool,
    all_zero: bool,
    global: bool,
}

#[derive(Default)]
struct Module {
    globals: Vec<Global>,
    funcs: Vec<Func>,
}

// ───────────────────────────── 小工具 ─────────────────────────────

fn clean(s: &str) -> String {
    s.trim().trim_start_matches(['%', '@']).trim_matches('"').to_string()
}

fn strip_comment(l: &str) -> &str {
    let mut q = false;
    for (i, c) in l.char_indices() {
        if c == '"' {
            q = !q;
        } else if c == ';' && !q {
            return &l[..i];
        }
    }
    l
}

/// 以最外層逗號切分 (忽略括號與字串內的逗號)
fn split_top(s: &str) -> Vec<&str> {
    let mut v = vec![];
    let (mut d, mut q, mut st) = (0i32, false, 0usize);
    for (i, c) in s.char_indices() {
        match c {
            '"' => q = !q,
            '(' | '[' | '{' if !q => d += 1,
            ')' | ']' | '}' if !q => d -= 1,
            ',' if !q && d == 0 => {
                v.push(s[st..i].trim());
                st = i + 1;
            }
            _ => {}
        }
    }
    v.push(s[st..].trim());
    v
}

/// s 以 '(' 開頭，回傳對應 ')' 的位置
fn matching(s: &str) -> Res<usize> {
    let mut d = 0;
    for (i, c) in s.char_indices() {
        match c {
            '(' => d += 1,
            ')' => {
                d -= 1;
                if d == 0 {
                    return Ok(i);
                }
            }
            _ => {}
        }
    }
    Err("unbalanced parentheses".into())
}

fn at<'a>(p: &[&'a str], i: usize) -> Res<&'a str> {
    p.get(i).copied().ok_or_else(|| "too few operands".to_string())
}

fn val(tok: &str) -> Res<Val> {
    let t = tok.trim();
    Ok(match t {
        "true" => Val::Int(1),
        "false" => Val::Int(0),
        "null" | "undef" | "poison" | "zeroinitializer" => Val::Int(0),
        _ if t.starts_with('%') => Val::Local(clean(t)),
        _ if t.starts_with('@') => Val::Global(clean(t)),
        _ => Val::Int(
            t.parse::<i128>()
                .map_err(|_| format!("unsupported operand '{t}'"))? as i64,
        ),
    })
}

fn lab(s: &str) -> Res<String> {
    s.split_whitespace().last().map(clean).ok_or_else(|| "missing label".to_string())
}

const FLAGS: &[&str] = &[
    "nsw", "nuw", "exact", "disjoint", "inbounds", "nneg", "samesign", "nusw", "volatile",
    "atomic", "fast", "nnan", "ninf", "nsz", "arcp", "contract", "afn", "reassoc",
];
const CALL_FLAGS: &[&str] = &[
    "tail", "musttail", "notail", "fastcc", "ccc", "coldcc", "nnan", "ninf", "nsz", "arcp",
    "contract", "afn", "reassoc", "fast", "noundef", "zeroext", "signext", "inreg", "nonnull",
    "noalias", "nocapture", "readonly", "writeonly", "nofree", "returned", "nonnull", "captures",
];

fn strip_words<'a>(mut s: &'a str, set: &[&str]) -> &'a str {
    loop {
        s = s.trim_start();
        let w = s.split_whitespace().next().unwrap_or("");
        if w.is_empty() {
            return s;
        }
        if set.contains(&w) {
            s = &s[w.len()..];
        } else if w == "align" {
            // align N
            let r = s[w.len()..].trim_start();
            let n = r.split_whitespace().next().unwrap_or("");
            s = &r[n.len()..];
        } else if w.find('(').map_or(false, |p| p > 0 && w[..p].bytes().all(|c| c.is_ascii_alphabetic())) {
            // dereferenceable(8) / range(i32 0, 2) 這類帶括號的屬性
            let start = s.find('(').unwrap();
            match matching(&s[start..]) {
                Ok(e) => s = &s[start + e + 1..],
                Err(_) => return s,
            }
        } else {
            return s;
        }
    }
}

// ───────────────────────────── 剖析 ─────────────────────────────

struct Types(HashMap<String, Ty>);

impl Types {
    fn parse<'a>(&self, s: &'a str) -> Res<(Ty, &'a str)> {
        let s = s.trim_start();
        let (mut ty, mut rest) = if let Some(r) = s.strip_prefix('[') {
            let r = r.trim_start();
            let end = r.find(char::is_whitespace).ok_or("bad array type")?;
            let n: u64 = r[..end].parse().map_err(|_| "bad array length".to_string())?;
            let r = r[end..].trim_start().strip_prefix('x').ok_or("expected 'x' in array type")?;
            let (t, r) = self.parse(r)?;
            let r = r.trim_start().strip_prefix(']').ok_or("expected ']'")?;
            (Ty::Array(n, Box::new(t)), r)
        } else if s.starts_with("<{") {
            return Err("packed structs are not supported".into());
        } else if let Some(mut r) = s.strip_prefix('{') {
            let mut fields = vec![];
            loop {
                r = r.trim_start();
                if let Some(x) = r.strip_prefix('}') {
                    r = x;
                    break;
                }
                let (t, x) = self.parse(r)?;
                fields.push(t);
                r = x.trim_start();
                if let Some(x) = r.strip_prefix(',') {
                    r = x;
                }
            }
            (Ty::Struct(fields), r)
        } else {
            let end = s
                .find(|c: char| c.is_whitespace() || ",)]}*(".contains(c))
                .unwrap_or(s.len());
            let w = &s[..end];
            let t = if w == "void" {
                Ty::Void
            } else if w == "ptr" {
                Ty::Ptr
            } else if w.len() > 1 && w.starts_with('i') && w[1..].bytes().all(|b| b.is_ascii_digit()) {
                Ty::Int(w[1..].parse().map_err(|_| "bad int type".to_string())?)
            } else if w.starts_with('%') {
                self.0.get(&clean(w)).cloned().ok_or_else(|| format!("unknown type {w}"))?
            } else {
                return Err(format!("unsupported type '{w}'"));
            };
            (t, &s[end..])
        };
        while let Some(r) = rest.strip_prefix('*') {
            ty = Ty::Ptr; // 舊式 typed pointer
            rest = r;
        }
        Ok((ty, rest))
    }

    /// "ty [attrs] value"
    fn tv(&self, s: &str) -> Res<(Ty, Val)> {
        let (t, r) = self.parse(s)?;
        let tok = r
            .split_whitespace()
            .last()
            .ok_or_else(|| format!("missing operand in '{s}'"))?;
        Ok((t, val(tok)?))
    }

    fn parse_inst(&self, line: &str) -> Res<Inst> {
        let (dst, body) = match line.split_once(" = ") {
            Some((d, b)) if d.trim().starts_with('%') => (Some(clean(d)), b.trim()),
            _ => (None, line.trim()),
        };
        let body = strip_words(body, &["tail", "musttail", "notail"]);
        let (op, rest) = body.split_once(char::is_whitespace).unwrap_or((body, ""));
        let rest = rest.trim();
        let need = || dst.clone().ok_or_else(|| format!("'{op}' needs a result name"));
        match op {
            "add" | "sub" | "mul" | "sdiv" | "udiv" | "srem" | "urem" | "and" | "or" | "xor"
            | "shl" | "lshr" | "ashr" => {
                let (ty, r) = self.parse(strip_words(rest, FLAGS))?;
                let p = split_top(r);
                Ok(Inst::Bin { dst: need()?, op: op.into(), ty, a: val(at(&p, 0)?)?, b: val(at(&p, 1)?)? })
            }
            "icmp" => {
                let rest = strip_words(rest, FLAGS);
                let (pred, r) = rest.split_once(char::is_whitespace).ok_or("bad icmp")?;
                let (ty, r) = self.parse(r)?;
                let p = split_top(r);
                Ok(Inst::Icmp { dst: need()?, pred: pred.into(), ty, a: val(at(&p, 0)?)?, b: val(at(&p, 1)?)? })
            }
            "alloca" => {
                let p = split_top(rest);
                let ty = self.parse(at(&p, 0)?)?.0;
                let mut count = 1u64;
                for x in &p[1..] {
                    if x.starts_with("align") || x.starts_with("addrspace") || x.starts_with('!') {
                        continue;
                    }
                    match self.tv(x)?.1 {
                        Val::Int(n) => count = n as u64,
                        _ => return Err("dynamic alloca is not supported".into()),
                    }
                }
                Ok(Inst::Alloca { dst: need()?, ty, count })
            }
            "load" => {
                let p = split_top(strip_words(rest, FLAGS));
                Ok(Inst::Load { dst: need()?, ty: self.parse(at(&p, 0)?)?.0, ptr: self.tv(at(&p, 1)?)?.1 })
            }
            "store" => {
                let p = split_top(strip_words(rest, FLAGS));
                let (ty, v) = self.tv(at(&p, 0)?)?;
                Ok(Inst::Store { ty, val: v, ptr: self.tv(at(&p, 1)?)?.1 })
            }
            "getelementptr" => {
                let p = split_top(strip_words(rest, FLAGS));
                let ty = self.parse(at(&p, 0)?)?.0;
                let ptr = self.tv(at(&p, 1)?)?.1;
                let mut idx = vec![];
                for x in &p[2..] {
                    idx.push(self.tv(x)?.1);
                }
                Ok(Inst::Gep { dst: need()?, ty, ptr, idx })
            }
            "zext" | "sext" | "trunc" | "bitcast" | "ptrtoint" | "inttoptr" | "addrspacecast" => {
                let rest = strip_words(rest, FLAGS);
                let (l, r) = rest.rsplit_once(" to ").ok_or("bad cast")?;
                let (from, v) = self.tv(l)?;
                Ok(Inst::Cast { dst: need()?, op: op.into(), from, v, to: self.parse(r)?.0 })
            }
            "freeze" => {
                let (ty, v) = self.tv(rest)?;
                Ok(Inst::Cast { dst: need()?, op: "bitcast".into(), from: ty.clone(), v, to: ty })
            }
            "select" => {
                let p = split_top(strip_words(rest, FLAGS));
                Ok(Inst::Select {
                    dst: need()?,
                    c: self.tv(at(&p, 0)?)?.1,
                    a: self.tv(at(&p, 1)?)?.1,
                    b: self.tv(at(&p, 2)?)?.1,
                })
            }
            "phi" => {
                let (_, r) = self.parse(strip_words(rest, FLAGS))?;
                let mut inc = vec![];
                for g in split_top(r) {
                    let g = g.trim().trim_start_matches('[').trim_end_matches(']');
                    let p = split_top(g);
                    inc.push((val(at(&p, 0)?)?, lab(at(&p, 1)?)?));
                }
                Ok(Inst::Phi { dst: need()?, inc })
            }
            "call" => {
                let r = strip_words(rest, CALL_FLAGS);
                let (ret, r) = self.parse(r)?;
                let mut r = r.trim_start();
                if r.starts_with('(') {
                    r = r[matching(r)? + 1..].trim_start(); // 函式型別，如 (ptr, ...)
                }
                let p = r.find('(').ok_or("bad call")?;
                let callee = val(r[..p].trim())?;
                if let Val::Global(g) = &callee {
                    if g.starts_with("llvm.dbg.") || g.starts_with("llvm.lifetime.") {
                        return Ok(Inst::Nop);
                    }
                }
                let end = p + matching(&r[p..])?;
                let mut args = vec![];
                for a in split_top(&r[p + 1..end]) {
                    if !a.is_empty() {
                        args.push(self.tv(a)?);
                    }
                }
                Ok(Inst::Call { dst, ret, callee, args })
            }
            "br" => {
                if rest.starts_with("label") {
                    Ok(Inst::Br(lab(rest)?))
                } else {
                    let p = split_top(rest);
                    Ok(Inst::CondBr(self.tv(at(&p, 0)?)?.1, lab(at(&p, 1)?)?, lab(at(&p, 2)?)?))
                }
            }
            "switch" => {
                let lb = rest.find('[').ok_or("bad switch")?;
                let rb = rest.rfind(']').ok_or("bad switch")?;
                let head = split_top(&rest[..lb]);
                let v = self.tv(at(&head, 0)?)?.1;
                let def = lab(at(&head, 1)?)?;
                let toks: Vec<String> =
                    rest[lb + 1..rb].replace(',', " ").split_whitespace().map(String::from).collect();
                let mut cases = vec![];
                for c in toks.chunks(4) {
                    if c.len() < 4 {
                        return Err("bad switch case".into());
                    }
                    match val(&c[1])? {
                        Val::Int(n) => cases.push((n, clean(&c[3]))),
                        _ => return Err("non-constant switch case".into()),
                    }
                }
                Ok(Inst::Switch { v, def, cases })
            }
            "ret" => {
                if rest == "void" {
                    Ok(Inst::Ret(None))
                } else {
                    Ok(Inst::Ret(Some(self.tv(rest)?)))
                }
            }
            "unreachable" => Ok(Inst::Unreachable),
            _ => Err(format!("unsupported instruction '{op}'")),
        }
    }

    // ---- 全域變數 ----

    fn init(&self, ty: &Ty, s: &str, out: &mut Vec<Item>) -> Res<()> {
        let s = s.trim();
        if matches!(s, "zeroinitializer" | "undef" | "poison" | "null") {
            out.push(Item::Zero(ty.size()));
            return Ok(());
        }
        match ty {
            Ty::Int(_) => {
                let n = match s {
                    "true" => 1,
                    "false" => 0,
                    _ => s.parse::<i128>().map_err(|_| format!("bad integer constant '{s}'"))? as i64,
                };
                out.push(Item::Bytes(n.to_le_bytes()[..ty.size() as usize].to_vec()));
            }
            Ty::Ptr => {
                if !s.starts_with('@') {
                    return Err(format!("unsupported pointer constant '{s}'"));
                }
                out.push(Item::Sym(clean(s)));
            }
            Ty::Array(n, t) => {
                if let Some(r) = s.strip_prefix("c\"") {
                    let r = r.strip_suffix('"').ok_or("bad string constant")?;
                    let mut b = unescape(r);
                    b.resize((n * t.size()) as usize, 0);
                    out.push(Item::Bytes(b));
                } else {
                    let inner = s
                        .strip_prefix('[')
                        .and_then(|x| x.strip_suffix(']'))
                        .ok_or_else(|| format!("bad array initializer '{s}'"))?;
                    for el in split_top(inner) {
                        if el.is_empty() {
                            continue;
                        }
                        let (_, rest) = self.parse(el)?;
                        self.init(t, rest, out)?;
                    }
                }
            }
            Ty::Struct(fields) => {
                let inner = s
                    .strip_prefix('{')
                    .and_then(|x| x.strip_suffix('}'))
                    .ok_or_else(|| format!("bad struct initializer '{s}'"))?;
                let elems: Vec<&str> = split_top(inner).into_iter().filter(|e| !e.is_empty()).collect();
                let mut off = 0;
                for (f, el) in fields.iter().zip(elems) {
                    let a = align_up(off, f.align());
                    if a > off {
                        out.push(Item::Zero(a - off));
                    }
                    let (_, rest) = self.parse(el)?;
                    self.init(f, rest, out)?;
                    off = a + f.size();
                }
                if ty.size() > off {
                    out.push(Item::Zero(ty.size() - off));
                }
            }
            Ty::Void => {}
        }
        Ok(())
    }

    fn parse_global(&self, line: &str) -> Res<Option<Global>> {
        let (lhs, rhs) = line.split_once('=').ok_or("bad global")?;
        let name = clean(lhs);
        let padded = format!(" {} ", rhs.trim());
        let (pos, kw) = [" global ", " constant "]
            .iter()
            .filter_map(|k| padded.find(k).map(|p| (p, *k)))
            .min()
            .ok_or("bad global definition")?;
        let prefix = &padded[..pos];
        if prefix.split_whitespace().any(|w| w == "external") {
            return Ok(None); // 只是宣告
        }
        let is_local = prefix.split_whitespace().any(|w| w == "internal" || w == "private");
        let (ty, rest) = self.parse(&padded[pos + kw.len()..])?;
        let first = split_top(rest).into_iter().next().unwrap_or("");
        let init_txt = if first.is_empty() || first.starts_with("align") { "zeroinitializer" } else { first };
        let mut init = vec![];
        self.init(&ty, init_txt, &mut init)?;
        let all_zero = init.iter().all(|i| match i {
            Item::Zero(_) => true,
            Item::Bytes(b) => b.iter().all(|x| *x == 0),
            Item::Sym(_) => false,
        });
        Ok(Some(Global { name, ty, init, constant: kw == " constant ", all_zero, global: !is_local }))
    }
}

fn unescape(s: &str) -> Vec<u8> {
    let b = s.as_bytes();
    let mut v = vec![];
    let mut i = 0;
    while i < b.len() {
        if b[i] == b'\\' && i + 2 < b.len() + 0 && b[i + 1] != b'\\' {
            if let Ok(x) = u8::from_str_radix(&s[i + 1..i + 3], 16) {
                v.push(x);
                i += 3;
                continue;
            }
        }
        if b[i] == b'\\' && i + 1 < b.len() && b[i + 1] == b'\\' {
            v.push(b'\\');
            i += 2;
            continue;
        }
        v.push(b[i]);
        i += 1;
    }
    v
}

fn parse_func(types: &Types, lines: &[&str], start: usize) -> Res<(Func, usize)> {
    let h = lines[start];
    let at_pos = h.find('@').ok_or("define without name")?;
    let lp = h[at_pos..].find('(').ok_or("define without '('")? + at_pos;
    let name = clean(&h[at_pos..lp]);
    let rp = lp + matching(&h[lp..])?;
    let prefix = &h[..at_pos];
    let global = !prefix.split_whitespace().any(|w| w == "internal" || w == "private");
    let mut params = vec![];
    let mut next_id = 0u64;
    for p in split_top(&h[lp + 1..rp]) {
        if p.is_empty() {
            continue;
        }
        if p == "..." {
            return Err("variadic function definitions are not supported".into());
        }
        let (ty, r) = types.parse(p)?;
        let n = r.split_whitespace().last().filter(|t| t.starts_with('%')).ok_or("unnamed parameter")?;
        let n = clean(n);
        if let Ok(k) = n.parse::<u64>() {
            next_id = next_id.max(k + 1);
        }
        params.push((ty, n));
    }

    let mut blocks: Vec<Block> = vec![];
    let mut i = start + 1;
    while i < lines.len() && lines[i] != "}" {
        let mut joined = String::new();
        let mut l = lines[i];
        if l.starts_with("switch") && !l.contains(']') {
            // 多行 switch：合併到 ']' 為止
            joined.push_str(l);
            while i + 1 < lines.len() && !joined.contains(']') {
                i += 1;
                joined.push(' ');
                joined.push_str(lines[i]);
            }
            l = &joined;
        }
        if !l.is_empty() {
            if l.ends_with(':') && !l.contains(char::is_whitespace) {
                blocks.push(Block { name: clean(&l[..l.len() - 1]), insts: vec![] });
            } else {
                if blocks.is_empty() {
                    blocks.push(Block { name: next_id.to_string(), insts: vec![] });
                }
                let l = l.split(", !").next().unwrap_or(l);
                let inst = types.parse_inst(l).map_err(|e| format!("line {}: {}", i + 1, e))?;
                blocks.last_mut().unwrap().insts.push(inst);
            }
        }
        i += 1;
    }
    Ok((Func { name, params, blocks, global }, i + 1))
}

fn parse_module(src: &str) -> Res<Module> {
    let lines: Vec<&str> = src.lines().map(|l| strip_comment(l).trim()).collect();
    let mut types = Types(HashMap::new());
    for _ in 0..2 {
        for l in &lines {
            if l.starts_with('%') {
                if let Some((n, r)) = l.split_once(" = type ") {
                    if let Ok((t, _)) = types.parse(r) {
                        types.0.insert(clean(n), t);
                    }
                }
            }
        }
    }
    let mut m = Module::default();
    let mut i = 0;
    while i < lines.len() {
        let l = lines[i];
        if l.starts_with("define") {
            let (f, next) = parse_func(&types, &lines, i).map_err(|e| {
                if e.starts_with("line ") { e } else { format!("line {}: {}", i + 1, e) }
            })?;
            m.funcs.push(f);
            i = next;
            continue;
        }
        if l.starts_with('@') {
            if let Some(g) = types.parse_global(l).map_err(|e| format!("line {}: {}", i + 1, e))? {
                m.globals.push(g);
            }
        }
        i += 1;
    }
    Ok(m)
}

// ───────────────────────────── 程式碼產生 ─────────────────────────────

fn fits(i: i64) -> bool {
    (-2048..2048).contains(&i)
}

/// 回傳 "off(base)"；offset 超出 12 位元時用 t6 輔助
fn mem(out: &mut String, base: &str, off: i64) -> String {
    if fits(off) {
        format!("{off}({base})")
    } else {
        let _ = writeln!(out, "\tli t6, {off}\n\tadd t6, {base}, t6");
        "0(t6)".into()
    }
}

fn addi(out: &mut String, rd: &str, rs: &str, imm: i64) {
    if imm == 0 && rd == rs {
        return;
    }
    if fits(imm) {
        let _ = writeln!(out, "\taddi {rd}, {rs}, {imm}");
    } else {
        let _ = writeln!(out, "\tli t6, {imm}\n\tadd {rd}, {rs}, t6");
    }
}

#[derive(Clone, Copy)]
enum Loc {
    Slot(i64), // s0 相對，內容為 64 位元值
    Addr(i64), // s0 相對，alloca 的儲存空間本身
}

type PhiList = Vec<(String, Vec<(Val, String)>)>;

struct Gen<'a> {
    f: &'a Func,
    body: String,
    locs: HashMap<String, Loc>,
    tmp: HashMap<String, i64>,
    phis: HashMap<String, PhiList>,
    stubs: Vec<(String, String, String)>,
    cur: u64,
    n: usize,
}

impl<'a> Gen<'a> {
    fn new(f: &'a Func) -> Self {
        Gen {
            f,
            body: String::new(),
            locs: HashMap::new(),
            tmp: HashMap::new(),
            phis: HashMap::new(),
            stubs: vec![],
            cur: 16, // s0-8: ra, s0-16: 舊 s0
            n: 0,
        }
    }

    fn e(&mut self, s: String) {
        self.body.push('\t');
        self.body.push_str(&s);
        self.body.push('\n');
    }

    fn alloc(&mut self, size: u64, align: u64) -> i64 {
        self.cur = align_up(self.cur + size, align.min(16));
        -(self.cur as i64)
    }

    fn lbl(&self, b: &str) -> String {
        format!(".L{}_{}", self.f.name, b)
    }

    fn norm(&mut self, r: &str, bits: u32) {
        match bits {
            64 => {}
            32 => self.e(format!("sext.w {r}, {r}")),
            1 => self.e(format!("andi {r}, {r}, 1")),
            b => {
                let s = 64 - b;
                self.e(format!("slli {r}, {r}, {s}"));
                self.e(format!("srai {r}, {r}, {s}"));
            }
        }
    }

    fn zext(&mut self, r: &str, bits: u32) {
        match bits {
            64 => {}
            1 => self.e(format!("andi {r}, {r}, 1")),
            8 => self.e(format!("andi {r}, {r}, 255")),
            b => {
                let s = 64 - b;
                self.e(format!("slli {r}, {r}, {s}"));
                self.e(format!("srli {r}, {r}, {s}"));
            }
        }
    }

    fn load_val(&mut self, reg: &str, v: &Val) -> Res<()> {
        match v {
            Val::Int(n) => self.e(format!("li {reg}, {n}")),
            Val::Global(g) => self.e(format!("lla {reg}, {g}")),
            Val::Local(n) => match self.locs.get(n).copied() {
                Some(Loc::Slot(o)) => {
                    let m = mem(&mut self.body, "s0", o);
                    self.e(format!("ld {reg}, {m}"));
                }
                Some(Loc::Addr(o)) => addi(&mut self.body, reg, "s0", o),
                None => return Err(format!("use of undefined value %{n}")),
            },
        }
        Ok(())
    }

    fn store_dst(&mut self, dst: &str, reg: &str) -> Res<()> {
        match self.locs.get(dst).copied() {
            Some(Loc::Slot(o)) => {
                let m = mem(&mut self.body, "s0", o);
                self.e(format!("sd {reg}, {m}"));
                Ok(())
            }
            _ => Err(format!("no slot for %{dst}")),
        }
    }

    fn scale(&mut self, reg: &str, s: u64) {
        if s == 1 {
        } else if s.is_power_of_two() {
            self.e(format!("slli {reg}, {reg}, {}", s.trailing_zeros()));
        } else {
            self.e(format!("li t2, {s}"));
            self.e(format!("mul {reg}, {reg}, t2"));
        }
    }

    fn epilogue(&mut self) {
        self.e("ld ra, -8(s0)".into());
        self.e("ld t5, -16(s0)".into());
        self.e("mv sp, s0".into());
        self.e("mv s0, t5".into());
        self.e("ret".into());
    }

    fn phi_copies(&mut self, from: &str, to: &str) -> Res<()> {
        let Some(phis) = self.phis.get(to).cloned() else { return Ok(()) };
        let items: Vec<(String, Val)> = phis
            .iter()
            .filter_map(|(d, inc)| inc.iter().find(|(_, l)| l == from).map(|(v, _)| (d.clone(), v.clone())))
            .collect();
        if items.len() == 1 {
            self.load_val("t0", &items[0].1)?;
            self.store_dst(&items[0].0, "t0")?;
        } else {
            for (d, v) in &items {
                self.load_val("t0", v)?;
                let o = self.tmp[d];
                let m = mem(&mut self.body, "s0", o);
                self.e(format!("sd t0, {m}"));
            }
            for (d, _) in &items {
                let o = self.tmp[d];
                let m = mem(&mut self.body, "s0", o);
                self.e(format!("ld t0, {m}"));
                self.store_dst(d, "t0")?;
            }
        }
        Ok(())
    }

    /// 取得跳往 `to` 的標籤；若 `to` 有 phi，建立「邊 stub」於 terminator 之後輸出
    fn edge(&mut self, from: &str, to: &str) -> String {
        if self.phis.get(to).map_or(true, |v| v.is_empty()) {
            return self.lbl(to);
        }
        self.n += 1;
        let l = format!(".L{}_e{}", self.f.name, self.n);
        self.stubs.push((l.clone(), from.to_string(), to.to_string()));
        l
    }

    fn flush_stubs(&mut self) -> Res<()> {
        for (l, from, to) in std::mem::take(&mut self.stubs) {
            self.body.push_str(&format!("{l}:\n"));
            self.phi_copies(&from, &to)?;
            let t = self.lbl(&to);
            self.e(format!("j {t}"));
        }
        Ok(())
    }

    fn inst(&mut self, blk: &str, i: &Inst) -> Res<()> {
        match i {
            Inst::Nop | Inst::Phi { .. } | Inst::Alloca { .. } => {}
            Inst::Bin { dst, op, ty, a, b } => {
                let bits = ty.bits()?;
                self.load_val("t0", a)?;
                self.load_val("t1", b)?;
                let (w, full) = (bits == 32, bits == 64);
                if !w && !full {
                    if op == "udiv" || op == "urem" {
                        self.zext("t0", bits);
                        self.zext("t1", bits);
                    } else if op == "lshr" {
                        self.zext("t0", bits);
                    }
                }
                let m = match (op.as_str(), w) {
                    ("add", true) => "addw", ("add", _) => "add",
                    ("sub", true) => "subw", ("sub", _) => "sub",
                    ("mul", true) => "mulw", ("mul", _) => "mul",
                    ("sdiv", true) => "divw", ("sdiv", _) => "div",
                    ("udiv", true) => "divuw", ("udiv", _) => "divu",
                    ("srem", true) => "remw", ("srem", _) => "rem",
                    ("urem", true) => "remuw", ("urem", _) => "remu",
                    ("and", _) => "and", ("or", _) => "or", ("xor", _) => "xor",
                    ("shl", true) => "sllw", ("shl", _) => "sll",
                    ("lshr", true) => "srlw", ("lshr", _) => "srl",
                    ("ashr", true) => "sraw", ("ashr", _) => "sra",
                    _ => return Err(format!("bad op {op}")),
                };
                self.e(format!("{m} t0, t0, t1"));
                if !w && !matches!(op.as_str(), "and" | "or" | "xor" | "ashr") {
                    self.norm("t0", bits);
                }
                self.store_dst(dst, "t0")?;
            }
            Inst::Icmp { dst, pred, ty, a, b } => {
                let bits = ty.bits()?;
                self.load_val("t0", a)?;
                self.load_val("t1", b)?;
                if pred.starts_with('u') && bits < 64 {
                    self.zext("t0", bits);
                    self.zext("t1", bits);
                }
                match pred.as_str() {
                    "eq" => {
                        self.e("sub t0, t0, t1".into());
                        self.e("seqz t0, t0".into());
                    }
                    "ne" => {
                        self.e("sub t0, t0, t1".into());
                        self.e("snez t0, t0".into());
                    }
                    p => {
                        let (ins, swap, inv) = match p {
                            "slt" => ("slt", false, false),
                            "sgt" => ("slt", true, false),
                            "sle" => ("slt", true, true),
                            "sge" => ("slt", false, true),
                            "ult" => ("sltu", false, false),
                            "ugt" => ("sltu", true, false),
                            "ule" => ("sltu", true, true),
                            "uge" => ("sltu", false, true),
                            _ => return Err(format!("bad icmp predicate {p}")),
                        };
                        if swap {
                            self.e(format!("{ins} t0, t1, t0"));
                        } else {
                            self.e(format!("{ins} t0, t0, t1"));
                        }
                        if inv {
                            self.e("xori t0, t0, 1".into());
                        }
                    }
                }
                self.store_dst(dst, "t0")?;
            }
            Inst::Load { dst, ty, ptr } => {
                let bits = ty.bits()?;
                self.load_val("t0", ptr)?;
                let m = match ty.size() {
                    1 => if bits == 1 { "lbu" } else { "lb" },
                    2 => "lh",
                    4 => "lw",
                    _ => "ld",
                };
                self.e(format!("{m} t0, 0(t0)"));
                if !matches!(bits, 8 | 16 | 32 | 64) {
                    self.norm("t0", bits);
                }
                self.store_dst(dst, "t0")?;
            }
            Inst::Store { ty, val, ptr } => {
                ty.bits()?;
                self.load_val("t0", val)?;
                self.load_val("t1", ptr)?;
                let m = match ty.size() {
                    1 => "sb",
                    2 => "sh",
                    4 => "sw",
                    _ => "sd",
                };
                self.e(format!("{m} t0, 0(t1)"));
            }
            Inst::Gep { dst, ty, ptr, idx } => {
                self.load_val("t0", ptr)?;
                let mut cur = ty.clone();
                let mut konst: i64 = 0;
                for (k, ix) in idx.iter().enumerate() {
                    let sc = if k == 0 {
                        ty.size()
                    } else {
                        match cur.clone() {
                            Ty::Array(_, t) => {
                                let s = t.size();
                                cur = *t;
                                s
                            }
                            Ty::Struct(f) => {
                                let Val::Int(n) = ix else {
                                    return Err("struct index must be constant".into());
                                };
                                let n = *n as usize;
                                if n >= f.len() {
                                    return Err("struct index out of range".into());
                                }
                                konst += field_offset(&f, n) as i64;
                                cur = f[n].clone();
                                continue;
                            }
                            t => return Err(format!("cannot index into {:?}", t)),
                        }
                    };
                    match ix {
                        Val::Int(n) => konst = konst.wrapping_add(n.wrapping_mul(sc as i64)),
                        v => {
                            self.load_val("t1", v)?;
                            self.scale("t1", sc);
                            self.e("add t0, t0, t1".into());
                        }
                    }
                }
                addi(&mut self.body, "t0", "t0", konst);
                self.store_dst(dst, "t0")?;
            }
            Inst::Cast { dst, op, from, v, to } => {
                let (fb, tb) = (from.bits()?, to.bits()?);
                self.load_val("t0", v)?;
                match op.as_str() {
                    "zext" => self.zext("t0", fb),
                    "sext" => {
                        if fb == 1 {
                            self.e("neg t0, t0".into());
                        }
                    }
                    _ => self.norm("t0", tb),
                }
                self.store_dst(dst, "t0")?;
            }
            Inst::Select { dst, c, a, b } => {
                let id = self.n;
                self.n += 1;
                let f = self.f.name.clone();
                self.load_val("t0", c)?;
                self.e(format!("beqz t0, .L{f}_s{id}a"));
                self.load_val("t1", a)?;
                self.e(format!("j .L{f}_s{id}b"));
                self.body.push_str(&format!(".L{f}_s{id}a:\n"));
                self.load_val("t1", b)?;
                self.body.push_str(&format!(".L{f}_s{id}b:\n"));
                self.store_dst(dst, "t1")?;
            }
            Inst::Call { dst, ret, callee, args } => {
                let mut target = match callee {
                    Val::Global(g) => Some(g.clone()),
                    _ => None,
                };
                let mut args: &[(Ty, Val)] = args;
                if let Some(g) = &target {
                    let repl = if g.starts_with("llvm.memcpy") {
                        Some("memcpy")
                    } else if g.starts_with("llvm.memmove") {
                        Some("memmove")
                    } else if g.starts_with("llvm.memset") {
                        Some("memset")
                    } else {
                        None
                    };
                    if let Some(r) = repl {
                        target = Some(r.into());
                        args = &args[..3.min(args.len())];
                    }
                }
                let ns = args.len().saturating_sub(8) as u64;
                let space = align_up(ns * 8, 16) as i64;
                if space > 0 {
                    addi(&mut self.body, "sp", "sp", -space);
                }
                for (k, (ty, v)) in args.iter().enumerate().skip(8) {
                    ty.bits()?;
                    self.load_val("t0", v)?;
                    let m = mem(&mut self.body, "sp", ((k - 8) * 8) as i64);
                    self.e(format!("sd t0, {m}"));
                }
                for (k, (ty, v)) in args.iter().enumerate().take(8) {
                    ty.bits()?;
                    self.load_val(&format!("a{k}"), v)?;
                }
                match &target {
                    Some(t) => self.e(format!("call {t}")),
                    None => {
                        self.load_val("t1", callee)?;
                        self.e("jalr t1".into());
                    }
                }
                if space > 0 {
                    addi(&mut self.body, "sp", "sp", space);
                }
                if let (Some(d), false) = (dst, *ret == Ty::Void) {
                    let bits = ret.bits()?;
                    self.norm("a0", bits);
                    self.store_dst(d, "a0")?;
                }
            }
            Inst::Br(t) => {
                self.phi_copies(blk, t)?;
                let l = self.lbl(t);
                self.e(format!("j {l}"));
            }
            Inst::CondBr(c, t, f) => {
                self.load_val("t0", c)?;
                let lt = self.edge(blk, t);
                self.e(format!("bnez t0, {lt}"));
                self.phi_copies(blk, f)?;
                let lf = self.lbl(f);
                self.e(format!("j {lf}"));
            }
            Inst::Switch { v, def, cases } => {
                self.load_val("t0", v)?;
                for (c, t) in cases {
                    let l = self.edge(blk, t);
                    self.e(format!("li t1, {c}"));
                    self.e(format!("beq t0, t1, {l}"));
                }
                self.phi_copies(blk, def)?;
                let l = self.lbl(def);
                self.e(format!("j {l}"));
            }
            Inst::Ret(r) => {
                if let Some((ty, v)) = r {
                    ty.bits()?;
                    self.load_val("a0", v)?;
                }
                self.epilogue();
            }
            Inst::Unreachable => self.e("ebreak".into()),
        }
        Ok(())
    }

    fn run(mut self) -> Res<String> {
        let f = self.f;
        // 1. 預先配置所有 SSA 值的堆疊槽 (避免前向參照問題)
        for (_, n) in &f.params {
            let o = self.alloc(8, 8);
            self.locs.insert(n.clone(), Loc::Slot(o));
        }
        for b in &f.blocks {
            for i in &b.insts {
                match i {
                    Inst::Alloca { dst, ty, count } => {
                        let o = self.alloc((ty.size() * count).max(1), ty.align());
                        self.locs.insert(dst.clone(), Loc::Addr(o));
                    }
                    Inst::Phi { dst, inc } => {
                        let o = self.alloc(8, 8);
                        self.locs.insert(dst.clone(), Loc::Slot(o));
                        let t = self.alloc(8, 8);
                        self.tmp.insert(dst.clone(), t);
                        self.phis.entry(b.name.clone()).or_default().push((dst.clone(), inc.clone()));
                    }
                    Inst::Bin { dst, .. }
                    | Inst::Icmp { dst, .. }
                    | Inst::Load { dst, .. }
                    | Inst::Gep { dst, .. }
                    | Inst::Cast { dst, .. }
                    | Inst::Select { dst, .. }
                    | Inst::Call { dst: Some(dst), .. } => {
                        let o = self.alloc(8, 8);
                        self.locs.insert(dst.clone(), Loc::Slot(o));
                    }
                    _ => {}
                }
            }
        }
        // 2. 參數 → 槽
        for (i, (ty, name)) in f.params.iter().enumerate() {
            let bits = ty.bits()?;
            if i < 8 {
                self.e(format!("mv t0, a{i}"));
            } else {
                let m = mem(&mut self.body, "s0", ((i - 8) * 8) as i64);
                self.e(format!("ld t0, {m}"));
            }
            self.norm("t0", bits);
            self.store_dst(name, "t0")?;
        }
        // 3. 基本區塊
        for b in &f.blocks {
            let l = self.lbl(&b.name);
            self.body.push_str(&format!("{l}:\n"));
            for i in &b.insts {
                self.inst(&b.name, i).map_err(|e| format!("in @{}: {}", f.name, e))?;
                self.flush_stubs()?;
            }
        }
        // 4. 組合：函式頭 + prologue + 內容
        let fs = align_up(self.cur, 16) as i64;
        let mut out = String::new();
        let _ = writeln!(out, "\t.text\n\t.p2align 1");
        if f.global {
            let _ = writeln!(out, "\t.globl {}", f.name);
        }
        let _ = writeln!(out, "\t.type {0}, @function\n{0}:", f.name);
        addi(&mut out, "sp", "sp", -fs);
        let m = mem(&mut out, "sp", fs - 8);
        let _ = writeln!(out, "\tsd ra, {m}");
        let m = mem(&mut out, "sp", fs - 16);
        let _ = writeln!(out, "\tsd s0, {m}");
        addi(&mut out, "s0", "sp", fs);
        out.push_str(&self.body);
        let _ = writeln!(out, "\t.size {0}, .-{0}\n", f.name);
        Ok(out)
    }
}

fn emit_global(g: &Global, out: &mut String) {
    let sec = if g.constant {
        ".section .rodata"
    } else if g.all_zero {
        ".bss"
    } else {
        ".data"
    };
    let _ = writeln!(out, "\t{sec}");
    if g.global {
        let _ = writeln!(out, "\t.globl {}", g.name);
    }
    let _ = writeln!(
        out,
        "\t.p2align {}\n\t.type {1}, @object\n\t.size {1}, {2}\n{1}:",
        g.ty.align().trailing_zeros(),
        g.name,
        g.ty.size()
    );
    for it in &g.init {
        match it {
            Item::Zero(n) => {
                if *n > 0 {
                    let _ = writeln!(out, "\t.zero {n}");
                }
            }
            Item::Sym(s) => {
                let _ = writeln!(out, "\t.dword {s}");
            }
            Item::Bytes(b) => {
                for ch in b.chunks(16) {
                    let l: Vec<String> = ch.iter().map(|x| x.to_string()).collect();
                    let _ = writeln!(out, "\t.byte {}", l.join(", "));
                }
            }
        }
    }
    out.push('\n');
}

fn compile(src: &str) -> Res<String> {
    let m = parse_module(src)?;
    let mut out = String::from("# Generated by ll2rv (RV64GC, LP64)\n\n");
    for g in &m.globals {
        emit_global(g, &mut out);
    }
    for f in &m.funcs {
        out.push_str(&Gen::new(f).run()?);
    }
    Ok(out)
}

fn main() {
    let mut input = None;
    let mut output = None;
    let mut args = env::args().skip(1);
    while let Some(a) = args.next() {
        match a.as_str() {
            "-o" => output = args.next(),
            "-h" | "--help" => {
                println!("用法: ll2rv <input.ll> [-o output.s]   (-o - 表示輸出到 stdout)");
                return;
            }
            _ => input = Some(a),
        }
    }
    let Some(input) = input else {
        eprintln!("用法: ll2rv <input.ll> [-o output.s]");
        process::exit(2);
    };
    let src = fs::read_to_string(&input).unwrap_or_else(|e| {
        eprintln!("ll2rv: 無法讀取 {input}: {e}");
        process::exit(1);
    });
    let asm = compile(&src).unwrap_or_else(|e| {
        eprintln!("ll2rv: error: {e}");
        process::exit(1);
    });
    let output = output.unwrap_or_else(|| {
        let p = std::path::Path::new(&input);
        p.with_extension("s").to_string_lossy().into_owned()
    });
    if output == "-" {
        print!("{asm}");
    } else if let Err(e) = fs::write(&output, asm) {
        eprintln!("ll2rv: 無法寫入 {output}: {e}");
        process::exit(1);
    }
}
