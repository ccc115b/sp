use std::collections::{HashMap, HashSet};
use std::hash::{Hash, Hasher};

use crate::elf::{OutRel, OutSection, OutSym};
use crate::expr::{self, EvalCtx, Expr, SymInfo, Val};
use crate::insts::{self, EncEnv, EncOut, Operand, ABS_SYM};
use crate::isa::{self, IsaSpec, Mabi};
use crate::parser::{AsmError, DataItem, Dir, Item, PResult, Parser, NUMREF};

pub const SHT_PROGBITS: u32 = 1;
pub const SHT_NOBITS: u32 = 8;
pub const SHT_NOTE: u32 = 7;
pub const SHT_RISCV_ATTRIBUTES: u32 = 0x7000_0003;
pub const SHN_ABS: u32 = 0xfff1;
pub const SHN_COMMON: u32 = 0xfff2;

#[derive(Debug, Clone)]
pub struct Sym {
    pub name: String,
    pub bind: u8,
    pub vis: u8,
    pub ty: u8,
    pub defined: bool,
    pub abs: bool,
    pub is_label: bool,
    pub defined_pass: usize,
    pub sec: usize,
    pub value: u64,
    pub size: u64,
    pub common: Option<(u64, u64)>,
}

#[derive(Debug, Clone)]
pub struct AnonSym {
    pub name: String,
    pub sec: usize,
    pub value: u64,
}

#[derive(Debug, Clone)]
pub struct Rel {
    pub off: u64,
    pub ty: u32,
    pub sym: String,
    pub addend: i64,
}

#[derive(Debug, Clone)]
pub struct Section {
    pub name: String,
    pub sh_type: u32,
    pub sh_flags: u64,
    pub entsize: u64,
    pub addralign: u64,
    pub data: Vec<u8>,
    pub relocs: Vec<Rel>,
}

#[derive(Debug, Clone)]
enum AttrVal {
    Str(String),
    Int(u64),
}

pub struct Assembler {
    pub xlen: u8,
    pub exts: u32,
    pub mabi: Mabi,
    pub rvc_opt: bool,
    pub relax: bool,
    pub final_pass: bool,
    pub sections: Vec<Section>,
    pub cur: usize,
    pub sec_stack: Vec<usize>,
    pub syms: HashMap<String, Sym>,
    pub sym_order: Vec<String>,
    pub anon: Vec<AnonSym>,
    pub anon_map: HashMap<String, usize>,
    pub defined_in_file: HashSet<String>,
    pub pending_equ: Vec<(String, Expr, bool, crate::lexer::SrcLoc)>,
    attrs: Vec<(u32, AttrVal)>,
    pub opt_stack: Vec<(bool, u32, bool)>,
    pub has_attrs: bool,
    pub arch_str: Option<String>,
    pub pcrel_ctr: u64,
    num_def_names: HashMap<usize, String>,
}

fn defaults_for(name: &str) -> (u32, u64, u64, u64) {
    match name {
        ".text" => (SHT_PROGBITS, 0x6, 0, 4),
        ".data" | ".sdata" => (SHT_PROGBITS, 0x3, 0, 1),
        ".rodata" | ".srodata" => (SHT_PROGBITS, 0x2, 0, 1),
        ".bss" | ".sbss" => (SHT_NOBITS, 0x3, 0, 1),
        ".comment" => (SHT_PROGBITS, 0x30, 1, 1),
        ".note.GNU-stack" => (SHT_PROGBITS, 0, 0, 1),
        ".init" | ".fini" => (SHT_PROGBITS, 0x6, 0, 4),
        ".riscv.attributes" => (SHT_RISCV_ATTRIBUTES, 0, 0, 1),
        _ => (SHT_PROGBITS, 0, 0, 1),
    }
}

impl Assembler {
    pub fn new(spec: IsaSpec, mabi: Mabi) -> Self {
        let mut sections = Vec::new();
        for n in [".text", ".data", ".bss"] {
            let (t, f, e, a) = defaults_for(n);
            sections.push(Section {
                name: n.to_string(),
                sh_type: t,
                sh_flags: f,
                entsize: e,
                addralign: a,
                data: Vec::new(),
                relocs: Vec::new(),
            });
        }
        Assembler {
            xlen: spec.xlen,
            exts: spec.exts,
            mabi,
            rvc_opt: spec.exts & isa::EXT_C != 0,
            relax: true,
            final_pass: false,
            sections,
            cur: 0,
            sec_stack: Vec::new(),
            syms: HashMap::new(),
            sym_order: Vec::new(),
            anon: Vec::new(),
            anon_map: HashMap::new(),
            defined_in_file: HashSet::new(),
            pending_equ: Vec::new(),
            attrs: Vec::new(),
            opt_stack: Vec::new(),
            has_attrs: false,
            arch_str: None,
            pcrel_ctr: 0,
            num_def_names: HashMap::new(),
        }
    }

    fn ensure_sym(&mut self, name: &str) -> &mut Sym {
        if !self.syms.contains_key(name) {
            self.sym_order.push(name.to_string());
            self.syms.insert(
                name.to_string(),
                Sym {
                    name: name.to_string(),
                    bind: 0,
                    vis: 0,
                    ty: 0,
                    defined: false,
                    abs: false,
                    is_label: false,
                    defined_pass: usize::MAX,
                    sec: 0,
                    value: 0,
                    size: 0,
                    common: None,
                },
            );
        }
        self.syms.get_mut(name).unwrap()
    }

    fn ensure_section(&mut self, name: &str) -> usize {
        if let Some(i) = self.sections.iter().position(|s| s.name == name) {
            return i;
        }
        let (t, f, e, a) = defaults_for(name);
        self.sections.push(Section {
            name: name.to_string(),
            sh_type: t,
            sh_flags: f,
            entsize: e,
            addralign: a,
            data: Vec::new(),
            relocs: Vec::new(),
        });
        self.sections.len() - 1
    }

    fn cur_sec(&self) -> &Section {
        &self.sections[self.cur]
    }

    fn cur_offset(&self) -> u64 {
        self.sections[self.cur].data.len() as u64
    }

    fn lookup_syminfo(&self, name: &str) -> Option<SymInfo> {
        if let Some(s) = self.syms.get(name) {
            if s.defined {
                return Some(SymInfo { defined: true, abs: s.abs, value: s.value as i128, sec: s.sec });
            }
            return None;
        }
        if let Some(a) = self.anon_map.get(name) {
            let a = &self.anon[*a];
            return Some(SymInfo { defined: true, abs: false, value: a.value as i128, sec: a.sec });
        }
        None
    }

    fn eval(&self, e: &Expr) -> Result<Val, String> {
        let ctx = EvalCtx { lookup: &|n: &str| self.lookup_syminfo(n), cur_offset: self.cur_offset() };
        expr::eval(e, &ctx)
    }

    fn define_anon(&mut self, name: &str, sec: usize, value: u64) {
        if let Some(i) = self.anon_map.get(name) {
            let a = &mut self.anon[*i];
            a.sec = sec;
            a.value = value;
        } else {
            self.anon_map.insert(name.to_string(), self.anon.len());
            self.anon.push(AnonSym { name: name.to_string(), sec, value });
        }
    }

    pub fn prescan(&mut self, items: &mut [Item]) -> PResult<()> {
        let mut seen: HashMap<String, crate::lexer::SrcLoc> = HashMap::new();
        let mut num_counts: HashMap<i128, u32> = HashMap::new();
        for (idx, item) in items.iter().enumerate() {
            match item {
                Item::Label { name, loc } => {
                    if let Some(prev) = seen.get(name) {
                        return Err(AsmError::new(
                            loc,
                            format!("symbol '{}' is already defined at {}:{}", name, prev.file, prev.line),
                        ));
                    }
                    seen.insert(name.clone(), loc.clone());
                    self.defined_in_file.insert(name.clone());
                }
                Item::NumLabelDef { num } => {
                    let k = num_counts.entry(*num).or_insert(0);
                    let name = format!(".L{}\u{2}{}", num, k);
                    *k += 1;
                    self.num_def_names.insert(idx, name.clone());
                    self.defined_in_file.insert(name);
                }
                Item::Equ { name, equiv, loc, .. } => {
                    if *equiv {
                        if let Some(prev) = seen.get(name) {
                            return Err(AsmError::new(
                                loc,
                                format!(".equiv symbol '{}' is already defined at {}:{}", name, prev.file, prev.line),
                            ));
                        }
                    }
                    seen.entry(name.clone()).or_insert_with(|| loc.clone());
                    self.defined_in_file.insert(name.clone());
                }
                Item::Insn { .. } | Item::Dir(..) => {}
            }
        }
        for (idx, item) in items.iter_mut().enumerate() {
            if let Item::Insn { ops, loc, .. } = item {
                for op in ops.iter_mut() {
                    let oe = match op {
                        Operand::Expr(e) => e,
                        Operand::Mem(e, _) => e,
                        _ => continue,
                    };
                    rewrite_numrefs(oe, idx, &self.num_def_names, loc)?;
                }
            }
        }
        Ok(())
    }

    fn fingerprint(&self) -> u64 {
        let mut h = std::collections::hash_map::DefaultHasher::new();
        for n in &self.sym_order {
            if let Some(s) = self.syms.get(n) {
                s.defined.hash(&mut h);
                s.abs.hash(&mut h);
                s.value.hash(&mut h);
                s.sec.hash(&mut h);
            }
        }
        for a in &self.anon {
            a.value.hash(&mut h);
            a.sec.hash(&mut h);
        }
        for s in &self.sections {
            s.data.len().hash(&mut h);
            s.relocs.len().hash(&mut h);
        }
        self.pending_equ.len().hash(&mut h);
        h.finish()
    }

    pub fn assemble(&mut self, items: &mut [Item]) -> PResult<()> {
        self.prescan(items)?;
        let mut prev: Option<u64> = None;
        for pass in 0..16 {
            self.final_pass = false;
            self.layout(items, pass)?;
            let fp = self.fingerprint();
            if prev == Some(fp) {
                break;
            }
            prev = Some(fp);
        }
        self.final_pass = true;
        self.layout(items, 16)?;
        Ok(())
    }

    fn layout(&mut self, items: &[Item], pass: usize) -> PResult<()> {
        for s in self.sections.iter_mut() {
            s.data.clear();
            s.relocs.clear();
        }
        self.cur = 0;
        self.sec_stack.clear();
        self.pcrel_ctr = 0;
        self.pending_equ.clear();
        self.attrs.clear();
        self.has_attrs = false;
        self.opt_stack.clear();
        for (idx, item) in items.iter().enumerate() {
            self.process_item(idx, item, pass).map_err(|mut e| {
                if e.loc.is_none() {
                    if let Item::Insn { loc, .. } | Item::Label { loc, .. } = item {
                        e.loc = Some(loc.clone());
                    }
                }
                e
            })?;
        }
        self.resolve_pending()?;
        Ok(())
    }

    fn resolve_pending(&mut self) -> PResult<()> {
        let pending = std::mem::take(&mut self.pending_equ);
        let mut remaining = Vec::new();
        for (name, expr, equiv, loc) in pending {
            match self.eval(&expr) {
                Ok(Val::Abs(v)) => {
                    let s = self.ensure_sym(&name);
                    if equiv && s.defined {
                        return Err(AsmError::new(&loc, format!(".equiv symbol '{}' redefined", name)));
                    }
                    s.defined = true;
                    s.defined_pass = usize::MAX;
                    s.abs = true;
                    s.is_label = false;
                    s.value = v as u64;
                }
                Ok(_) | Err(_) => remaining.push((name, expr, equiv, loc)),
            }
        }
        self.pending_equ = remaining;
        if self.final_pass {
            if let Some((name, expr, _, loc)) = self.pending_equ.first() {
                let msg = self
                    .eval(expr)
                    .err()
                    .unwrap_or_else(|| format!("cannot resolve .equ '{}'", name));
                return Err(AsmError::new(loc, format!(".equ '{}': {}", name, msg)));
            }
        }
        Ok(())
    }

    fn process_item(&mut self, idx: usize, item: &Item, pass: usize) -> PResult<()> {
        let _ = pass;
        match item {
            Item::Label { name, loc: _ } => {
                let off = self.cur_offset();
                let sec = self.cur;
                let s = self.ensure_sym(name);
                if s.defined && s.defined_pass == pass && (s.is_label || s.abs) {
                    return Err(AsmError::plain(format!("symbol '{}' already defined", name)));
                }
                s.defined = true;
                s.defined_pass = pass;
                s.is_label = true;
                s.abs = false;
                s.sec = sec;
                s.value = off;
            }
            Item::NumLabelDef { num: _ } => {
                if let Some(name) = self.num_def_names.get(&idx) {
                    let name = name.clone();
                    let off = self.cur_offset();
                    let sec = self.cur;
                    self.define_anon(&name, sec, off);
                }
            }
            Item::Equ { name, expr, equiv, loc } => {
                self.do_equ(name, expr, *equiv, loc, pass)?;
            }
            Item::Dir(d, loc) => self.process_dir(d, loc, pass)?,
            Item::Insn { mnem, ops, loc } => {
                let start = self.cur_offset();
                let mut out = EncOut::new(self.pcrel_ctr);
                {
                    let lookup = |n: &str| self.lookup_syminfo(n);
                    let env = EncEnv {
                        xlen: self.xlen,
                        exts: self.exts,
                        relax: self.relax,
                        final_pass: self.final_pass,
                        cur_offset: start,
                        cur_section: self.cur,
                        cur_section_sym: self.sections[self.cur].name.as_str(),
                        lookup: &lookup,
                        defined_in_file: &self.defined_in_file,
                    };
                    insts::assemble_insn(mnem, ops, &env, &mut out)
                        .map_err(|msg| AsmError::new(loc, msg))?;
                }
                self.pcrel_ctr = out.pcrel_ctr;
                let sec = &mut self.sections[self.cur];
                for w in &out.words {
                    sec.data.extend_from_slice(&w.to_le_bytes());
                }
                let (relocs, anon) = (std::mem::take(&mut out.relocs), std::mem::take(&mut out.anon_defs));
                for (name, relval) in anon {
                    self.define_anon(&name, self.cur, start + relval);
                }
                let sec = &mut self.sections[self.cur];
                for (roff, ty, sym, addend) in relocs {
                    sec.relocs.push(Rel { off: start + roff, ty, sym, addend });
                }
            }
        }
        Ok(())
    }

    fn emit_bytes(&mut self, bytes: &[u8]) {
        self.sections[self.cur].data.extend_from_slice(bytes);
    }

    fn align_to(&mut self, align: u64, fill: u8, max: Option<u64>, nobits: bool) {
        if align <= 1 {
            return;
        }
        let s = &mut self.sections[self.cur];
        s.addralign = s.addralign.max(align);
        if nobits {
            return;
        }
        let len = s.data.len() as u64;
        let need = (align - (len % align)) % align;
        if let Some(m) = max {
            if need > m {
                return;
            }
        }
        for _ in 0..need {
            s.data.push(fill);
        }
    }

    fn add_reloc(&mut self, ty: u32, sym: &str, addend: i64) {
        let off = self.cur_offset();
        let sym = if sym == expr::DOT_SYM { self.sections[self.cur].name.clone() } else { sym.to_string() };
        self.sections[self.cur].relocs.push(Rel { off, ty, sym, addend });
    }

    fn do_equ(&mut self, name: &str, expr: &Expr, equiv: bool, loc: &crate::lexer::SrcLoc, pass: usize) -> PResult<()> {
        match self.eval(expr) {
            Ok(Val::Abs(v)) => {
                let s = self.ensure_sym(name);
                if equiv && s.defined && s.defined_pass == pass {
                    return Err(AsmError::new(loc, format!(".equiv symbol '{}' redefined", name)));
                }
                if s.defined && s.defined_pass == pass && s.is_label {
                    return Err(AsmError::new(loc, format!("symbol '{}' already defined", name)));
                }
                s.defined = true;
                s.defined_pass = pass;
                s.abs = true;
                s.is_label = false;
                s.value = v as u64;
            }
            _ => {
                self.pending_equ.push((name.to_string(), expr.clone(), equiv, loc.clone()));
            }
        }
        Ok(())
    }

    fn process_dir(&mut self, d: &Dir, loc: &crate::lexer::SrcLoc, pass: usize) -> PResult<()> {
        match d {
            Dir::KnownSection(n) => {
                let i = self.ensure_section(n);
                self.cur = i;
            }
            Dir::Section { name, flags, ty, entsize } => {
                let i = self.apply_section(name, flags.as_deref(), ty.as_deref(), entsize.clone(), loc)?;
                self.cur = i;
            }
            Dir::PushSection { name, flags, ty, entsize } => {
                self.sec_stack.push(self.cur);
                let i = self.apply_section(name, flags.as_deref(), ty.as_deref(), entsize.clone(), loc)?;
                self.cur = i;
            }
            Dir::PopSection => {
                match self.sec_stack.pop() {
                    Some(i) => self.cur = i,
                    None => return Err(AsmError::new(loc, ".popsection without .pushsection")),
                }
            }
            Dir::Globl(names) | Dir::Weak(names) => {
                let bind = if matches!(d, Dir::Weak(_)) { 2 } else { 1 };
                for n in names {
                    let s = self.ensure_sym(n);
                    s.bind = bind;
                }
            }
            Dir::Local(names) => {
                for n in names {
                    let s = self.ensure_sym(n);
                    s.bind = 0;
                }
            }
            Dir::Vis { hidden, names } => {
                let v = if *hidden { 2u8 } else { 0u8 };
                for n in names {
                    let s = self.ensure_sym(n);
                    s.vis = v;
                }
            }
            Dir::Type { name, ty } => {
                let s = self.ensure_sym(name);
                s.ty = *ty;
            }
            Dir::Size { name, expr } => {
                let v = match self.eval(expr)? {
                    Val::Abs(v) => v,
                    _ => return Err(AsmError::new(loc, ".size expression must be absolute")),
                };
                if v < 0 {
                    return Err(AsmError::new(loc, ".size expression is negative"));
                }
                let s = self.ensure_sym(name);
                s.size = v as u64;
            }
            Dir::Align { pow, fill, max } => {
                let p = self.abs_u64(pow, loc, ".align")?;
                if p > 32 {
                    return Err(AsmError::new(loc, ".align amount too large"));
                }
                let fill = match fill {
                    Some(e) => self.abs_u64(e, loc, "fill value")? as u8,
                    None => 0,
                };
                let max = match max {
                    Some(e) => Some(self.abs_u64(e, loc, "max skip")?),
                    None => None,
                };
                let nobits = self.cur_sec().sh_type == SHT_NOBITS;
                self.align_to(1u64 << p, fill, max, nobits);
            }
            Dir::BAlign { bytes, fill, max } => {
                let a = self.abs_u64(bytes, loc, ".balign")?;
                let fill = match fill {
                    Some(e) => self.abs_u64(e, loc, "fill value")? as u8,
                    None => 0,
                };
                let max = match max {
                    Some(e) => Some(self.abs_u64(e, loc, "max skip")?),
                    None => None,
                };
                let nobits = self.cur_sec().sh_type == SHT_NOBITS;
                self.align_to(a, fill, max, nobits);
            }
            Dir::Data { size, items } => {
                for it in items {
                    match it {
                        DataItem::Float(f) => {
                            let bits = if *size == 4 {
                                (*f as f32).to_bits() as u64
                            } else {
                                f.to_bits()
                            };
                            self.emit_bytes(&bits.to_le_bytes()[..*size as usize]);
                        }
                        DataItem::Expr(e) => match self.eval(e)? {
                            Val::Abs(v) => {
                                let (lo, hi) = match size {
                                    1 => (-128i128, 255i128),
                                    2 => (-32768, 65535),
                                    4 => (i32::MIN as i128, u32::MAX as i128),
                                    _ => (i64::MIN as i128, u64::MAX as i128),
                                };
                                if self.final_pass && (v < lo || v > hi) {
                                    return Err(AsmError::new(loc, format!("value {} out of range for {}-byte data", v, size)));
                                }
                                let uv = (v as u64).to_le_bytes();
                                self.emit_bytes(&uv[..*size as usize]);
                            }
                            Val::Rel { sym, addend } => {
                                let ty = if *size == 8 { insts::R_RISCV_64 } else { insts::R_RISCV_32 };
                                if *size != 4 && *size != 8 {
                                    return Err(AsmError::new(
                                        loc,
                                        format!("cannot represent relocation in {}-byte data", size),
                                    ));
                                }
                                self.add_reloc(ty, &sym, addend as i64);
                                self.emit_bytes(&[0u8; 8][..*size as usize]);
                            }
                            Val::Mod { .. } => {
                                return Err(AsmError::new(loc, "%hi/%lo not allowed in data directive"));
                            }
                        },
                    }
                }
            }
            Dir::Leb128 { items, signed } => {
                for e in items {
                    let v = match self.eval(e)? {
                        Val::Abs(v) => v,
                        _ => return Err(AsmError::new(loc, "leb128 value must be absolute")),
                    };
                    let mut buf = Vec::new();
                    if *signed {
                        write_sleb128(&mut buf, v as i64);
                    } else {
                        if self.final_pass && v < 0 {
                            return Err(AsmError::new(loc, ".uleb128 value is negative"));
                        }
                        write_uleb128(&mut buf, v as u64);
                    }
                    self.emit_bytes(&buf);
                }
            }
            Dir::Ascii { strs, z } => {
                for s in strs {
                    self.emit_bytes(s.as_bytes());
                    if *z {
                        self.emit_bytes(&[0]);
                    }
                }
            }
            Dir::Zero { n, fill } => {
                let n = self.abs_u64(n, loc, ".zero")?;
                let f = match fill {
                    Some(e) => self.abs_u64(e, loc, "fill value")? as u8,
                    None => 0,
                };
                let nobits = self.cur_sec().sh_type == SHT_NOBITS;
                if nobits {
                    let cur = &mut self.sections[self.cur];
                    let newlen = cur.data.len() + n as usize;
                    cur.data.resize(newlen, 0);
                } else {
                    let mut v = vec![f; n as usize];
                    self.emit_bytes(&v);
                    v.clear();
                }
            }
            Dir::Comm { name, size, align, local } => {
                let sz = self.abs_u64(size, loc, ".comm size")?;
                let al = match align {
                    Some(e) => self.abs_u64(e, loc, ".comm alignment")?,
                    None => sz.next_power_of_two().max(1),
                };
                let s = self.ensure_sym(name);
                if s.defined && s.defined_pass == pass {
                    return Err(AsmError::new(loc, format!("symbol '{}' already defined", name)));
                }
                s.bind = if *local { 0 } else { 1 };
                s.ty = 1;
                match &mut s.common {
                    Some((osz, oal)) => {
                        *osz = (*osz).max(sz);
                        *oal = (*oal).max(al);
                    }
                    None => s.common = Some((sz, al)),
                }
            }
            Dir::OptionArgs(args) => self.process_option(args, loc)?,
            Dir::Attribute { tag, str_val, int_val } => {
                let id = attr_tag_id(tag)?;
                let val = if let Some(s) = str_val {
                    AttrVal::Str(s.clone())
                } else {
                    let e = int_val.as_ref().unwrap();
                    match self.eval(e)? {
                        Val::Abs(v) => AttrVal::Int(v as u64),
                        _ => return Err(AsmError::new(loc, ".attribute value must be absolute")),
                    }
                };
                if id == 5 {
                    if let AttrVal::Str(ref s) = val {
                        if let Ok(spec) = isa::parse_isa(s) {
                            self.exts = spec.exts;
                            self.rvc_opt = spec.exts & isa::EXT_C != 0;
                        }
                    }
                }
                self.has_attrs = true;
                self.attrs.push((id, val));
            }
            Dir::IdentStr(s) => {
                let i = self.ensure_section(".comment");
                let saved = self.cur;
                self.cur = i;
                self.emit_bytes(s.as_bytes());
                self.emit_bytes(&[0]);
                self.cur = saved;
            }
            Dir::Ignore => {}
            Dir::Incbin { path, skip, count } => {
                let data = std::fs::read(path)
                    .map_err(|e| AsmError::new(loc, format!("cannot read '{}': {}", path, e)))?;
                let skip = match skip {
                    Some(e) => self.abs_u64(e, loc, ".incbin skip")? as usize,
                    None => 0,
                };
                let cnt = match count {
                    Some(e) => self.abs_u64(e, loc, ".incbin count")? as usize,
                    None => data.len().saturating_sub(skip),
                };
                let end = (skip + cnt).min(data.len());
                if skip < data.len() {
                    self.emit_bytes(&data[skip..end]);
                }
            }
            Dir::Equ { name, expr, equiv } => self.do_equ(name, expr, *equiv, loc, pass)?,
        }
        Ok(())
    }

    fn abs_u64(&self, e: &Expr, loc: &crate::lexer::SrcLoc, what: &str) -> PResult<u64> {
        match self.eval(e)? {
            Val::Abs(v) if v >= 0 => Ok(v as u64),
            Val::Abs(v) => Err(AsmError::new(loc, format!("{} is negative ({})", what, v))),
            _ => Err(AsmError::new(loc, format!("{} must be an absolute constant", what))),
        }
    }

    fn apply_section(
        &mut self,
        name: &str,
        flags: Option<&str>,
        ty: Option<&str>,
        entsize: Option<Expr>,
        loc: &crate::lexer::SrcLoc,
    ) -> PResult<usize> {
        let i = self.ensure_section(name);
        if let Some(f) = flags {
            let mut v = 0u64;
            for c in f.chars() {
                v |= match c {
                    'w' => 0x1,
                    'a' => 0x2,
                    'x' => 0x4,
                    'M' => 0x10,
                    'S' => 0x20,
                    'I' => 0x40,
                    'G' => 0x80,
                    'T' => 0x400,
                    'E' => 0x8000_0000,
                    'e' => 0x8000_0000,
                    _ => return Err(AsmError::new(loc, format!("unknown section flag '{}'", c))),
                };
            }
            self.sections[i].sh_flags = v;
        }
        if let Some(t) = ty {
            let v = match t {
                "progbits" => SHT_PROGBITS,
                "nobits" => SHT_NOBITS,
                "note" => SHT_NOTE,
                "unwind" => 0x7000_0001,
                "init_array" => 14,
                "fini_array" => 15,
                "preinit_array" => 16,
                "attributes" => SHT_RISCV_ATTRIBUTES,
                "symbol_table" | "symtab" => 2,
                "string" | "strtab" => 3,
                other => {
                    return Err(AsmError::new(loc, format!("unknown section type '@{}'", other)));
                }
            };
            self.sections[i].sh_type = v;
            if v == SHT_NOBITS {
                self.sections[i].data.clear();
            }
        }
        if let Some(e) = entsize {
            let v = self.abs_u64(&e, loc, "section entsize")?;
            self.sections[i].entsize = v;
        }
        Ok(i)
    }

    fn process_option(&mut self, args: &[String], loc: &crate::lexer::SrcLoc) -> PResult<()> {
        match args.first().map(|s| s.as_str()) {
            Some("rvc") => self.rvc_opt = true,
            Some("norvc") => {}
            Some("relax") => self.relax = true,
            Some("norelax") => self.relax = false,
            Some("push") => self.opt_stack.push((self.relax, self.exts, self.rvc_opt)),
            Some("pop") => {
                if let Some((r, e, v)) = self.opt_stack.pop() {
                    self.relax = r;
                    self.exts = e;
                    self.rvc_opt = v;
                }
            }
            Some("arch") => {
                let isa_str = args.get(1).ok_or_else(|| AsmError::new(loc, ".option arch needs an ISA string"))?;
                let spec = isa::parse_isa(isa_str).map_err(|m| AsmError::new(loc, m))?;
                self.exts = spec.exts;
                self.rvc_opt = spec.exts & isa::EXT_C != 0;
                self.arch_str = Some(canonical_arch(&spec));
                self.has_attrs = true;
            }
            _ => {}
        }
        Ok(())
    }

    pub fn build_output(&mut self) -> (u32, Vec<OutSection>, Vec<OutSym>, u32, Option<Vec<u8>>) {
        let rvc = self.rvc_opt || self.exts & isa::EXT_C != 0;
        let eflags = isa::e_flags(rvc, self.mabi);

        let mut order: Vec<usize> = Vec::new();
        for want in [".text", ".data", ".bss"] {
            if let Some(i) = self.sections.iter().position(|s| s.name == want) {
                order.push(i);
            }
        }
        for (i, s) in self.sections.iter().enumerate() {
            if !order.contains(&i) && s.name != ".riscv.attributes" {
                order.push(i);
            }
        }
        let mut out_index = HashMap::new();
        {
            let mut next = 1u32;
            for &si in order.iter() {
                out_index.insert(si, next);
                next += 1;
                if !self.sections[si].relocs.is_empty() {
                    next += 1;
                }
            }
        }

        let mut syms: Vec<OutSym> = Vec::new();
        syms.push(OutSym {
            name: String::new(),
            bind: 0,
            vis: 0,
            ty: 0,
            shndx: 0,
            value: 0,
            size: 0,
        });
        for &si in &order {
            syms.push(OutSym {
                name: self.sections[si].name.clone(),
                bind: 0,
                vis: 0,
                ty: 3,
                shndx: out_index[&si],
                value: 0,
                size: 0,
            });
        }
        let abs_idx = syms.len() as u32;
        syms.push(OutSym {
            name: String::new(),
            bind: 0,
            vis: 0,
            ty: 0,
            shndx: SHN_ABS,
            value: 0,
            size: 0,
        });
        let mut name_to_idx: HashMap<String, u32> = HashMap::new();
        name_to_idx.insert(ABS_SYM.to_string(), abs_idx);
        for &si in &order {
            name_to_idx.insert(self.sections[si].name.clone(), out_index[&si]);
        }
        let text_si = order.iter().find(|&&i| self.sections[i].name == ".text").copied();
        if let Some(tsi) = text_si {
            if !self.sections[tsi].data.is_empty() {
                let arch = self.arch_str.clone().unwrap_or_else(|| canonical_arch(&IsaSpec { xlen: self.xlen, exts: self.exts }));
                syms.push(OutSym {
                    name: format!("$x{}", arch),
                    bind: 0,
                    vis: 0,
                    ty: 0,
                    shndx: out_index[&tsi],
                    value: 0,
                    size: 0,
                });
            }
        }
        let first_global: u32;
        for n in &self.sym_order {
            let s = &self.syms[n];
            if s.bind == 0 && s.defined && s.common.is_none() {
                name_to_idx.insert(n.clone(), syms.len() as u32);
                syms.push(sym_to_out(s, &out_index, SHN_ABS, SHN_COMMON));
            }
        }
        for a in &self.anon {
            name_to_idx.insert(a.name.clone(), syms.len() as u32);
            syms.push(OutSym {
                name: clean_name(&a.name),
                bind: 0,
                vis: 0,
                ty: 0,
                shndx: *out_index.get(&a.sec).unwrap_or(&0),
                value: a.value,
                size: 0,
            });
        }
        first_global = syms.len() as u32;
        for n in &self.sym_order {
            let s = &self.syms[n];
            let include = s.bind != 0 || s.common.is_some();
            if include {
                name_to_idx.entry(n.clone()).or_insert(syms.len() as u32);
                syms.push(sym_to_out(s, &out_index, SHN_ABS, SHN_COMMON));
            }
        }
        let mut extra_und: Vec<String> = Vec::new();
        for s in &self.sections {
            for r in &s.relocs {
                if r.sym.is_empty() {
                    continue;
                }
                if !name_to_idx.contains_key(&r.sym) {
                    name_to_idx.insert(r.sym.clone(), syms.len() as u32 + extra_und.len() as u32);
                    extra_und.push(r.sym.clone());
                }
            }
        }
        for n in &extra_und {
            syms.push(OutSym {
                name: n.clone(),
                bind: 1,
                vis: 0,
                ty: 0,
                shndx: 0,
                value: 0,
                size: 0,
            });
        }
        for (k, v) in &name_to_idx {
            if *v as usize >= syms.len() {
                panic!("internal symbol index error for {}", k);
            }
        }

        let mut out_secs: Vec<OutSection> = Vec::new();
        let out_of = |si: usize, secs: &mut Vec<OutSection>, a: &Assembler| {
            let s = &a.sections[si];
            let mut rels: Vec<OutRel> = Vec::new();
            for r in &s.relocs {
                let idx = if r.sym.is_empty() {
                    0
                } else {
                    name_to_idx.get(&r.sym).copied().unwrap_or(0)
                };
                rels.push(OutRel { off: r.off, ty: r.ty, sym: idx, addend: r.addend });
            }
            secs.push(OutSection {
                name: s.name.clone(),
                sh_type: s.sh_type,
                sh_flags: s.sh_flags,
                entsize: s.entsize,
                addralign: s.addralign.max(1),
                data: s.data.clone(),
                relocs: rels,
                rela_name: format!(".rela{}", s.name),
            });
        };
        for &si in &order {
            out_of(si, &mut out_secs, self);
        }

        let attr_bytes = if self.has_attrs && !self.attrs.is_empty() {
            Some(build_attributes(&self.attrs))
        } else {
            None
        };

        (eflags, out_secs, syms, first_global, attr_bytes)
    }
}

fn clean_name(n: &str) -> String {
    if n.starts_with('\u{1}') {
        String::new()
    } else {
        n.to_string()
    }
}

fn sym_to_out(s: &Sym, out_index: &HashMap<usize, u32>, shn_abs: u32, shn_common: u32) -> OutSym {
    if let Some((size, align)) = s.common {
        return OutSym {
            name: s.name.clone(),
            bind: if s.bind == 0 { 0 } else { s.bind },
            vis: s.vis,
            ty: 1,
            shndx: shn_common,
            value: align,
            size,
        };
    }
    let shndx = if s.abs {
        shn_abs
    } else if s.defined {
        *out_index.get(&s.sec).unwrap_or(&0)
    } else {
        0
    };
    OutSym {
        name: s.name.clone(),
        bind: s.bind,
        vis: s.vis,
        ty: s.ty,
        shndx,
        value: s.value,
        size: s.size,
    }
}

fn attr_tag_id(tag: &str) -> PResult<u32> {
    Ok(match tag {
        "stack_align" => 4,
        "arch" => 5,
        "unaligned_access" => 6,
        "priv_spec" => 8,
        "priv_spec_minor" => 10,
        "priv_spec_revision" => 12,
        other => {
            if let Ok(v) = other.parse::<u32>() {
                v
            } else {
                return Err(AsmError::plain(format!("unknown attribute tag '{}'", other)));
            }
        }
    })
}

fn build_attributes(attrs: &[(u32, AttrVal)]) -> Vec<u8> {
    let mut pairs = Vec::new();
    for (id, val) in attrs {
        if id == &5 {
            if let AttrVal::Str(s) = val {
                write_uleb128(&mut pairs, *id as u64);
                pairs.extend_from_slice(s.as_bytes());
                pairs.push(0);
            }
        } else {
            if let AttrVal::Int(v) = val {
                write_uleb128(&mut pairs, *id as u64);
                write_uleb128(&mut pairs, *v);
            }
        }
    }
    let sub_len = 1 + 4 + pairs.len();
    let vendor_len = 4 + 6 + sub_len;
    let mut out = Vec::new();
    out.push(b'A');
    out.extend_from_slice(&(vendor_len as u32).to_le_bytes());
    out.extend_from_slice(b"riscv\0");
    out.push(1);
    out.extend_from_slice(&(sub_len as u32).to_le_bytes());
    out.extend_from_slice(&pairs);
    out
}

pub fn write_uleb128(out: &mut Vec<u8>, mut v: u64) {
    loop {
        let b = (v & 0x7f) as u8;
        v >>= 7;
        if v == 0 {
            out.push(b);
            break;
        }
        out.push(b | 0x80);
    }
}

pub fn write_sleb128(out: &mut Vec<u8>, mut v: i64) {
    loop {
        let b = (v & 0x7f) as u8;
        v >>= 7;
        let done = (v == 0 && b & 0x40 == 0) || (v == -1 && b & 0x40 != 0);
        if done {
            out.push(b);
            break;
        }
        out.push(b | 0x80);
    }
}

fn rewrite_numrefs(
    e: &mut Expr,
    item_idx: usize,
    names: &HashMap<usize, String>,
    loc: &crate::lexer::SrcLoc,
) -> PResult<()> {
    match e {
        Expr::Sym(s) if s.starts_with(NUMREF) => {
            let spec: String = s.chars().skip(1).collect();
            let rest = spec.strip_prefix("num").ok_or_else(|| AsmError::new(loc, "bad numeric label"))?;
            let (numstr, dir) = rest.split_at(rest.len() - 1);
            let num: i128 = numstr.parse().map_err(|_| AsmError::new(loc, "bad numeric label"))?;
            let back = dir == "b";
            let cands: Vec<(usize, &String)> = names
                .iter()
                .filter(|(i, _)| {
                    if back {
                        **i < item_idx
                    } else {
                        **i > item_idx
                    }
                })
                .map(|(i, n)| (*i, n))
                .collect();
            let best = if back {
                cands.iter().map(|(i, _)| *i).max()
            } else {
                cands.iter().map(|(i, _)| *i).min()
            };
            match best.and_then(|i| names.get(&i)) {
                Some(n) => {
                    let n = n.clone();
                    *s = n;
                    Ok(())
                }
                None => Err(AsmError::new(
                    loc,
                    format!("undefined numeric label '{}{}'", num, dir),
                )),
            }
        }
        Expr::Bin(_, a, b) => {
            rewrite_numrefs(a, item_idx, names, loc)?;
            rewrite_numrefs(b, item_idx, names, loc)
        }
        Expr::Neg(a) | Expr::Not(a) => rewrite_numrefs(a, item_idx, names, loc),
        Expr::Reloc(_, a) => rewrite_numrefs(a, item_idx, names, loc),
        _ => Ok(()),
    }
}

fn canonical_arch(spec: &IsaSpec) -> String {
    let base = if spec.xlen == 32 { "rv32i2p1" } else { "rv64i2p1" };
    let mut parts = vec![base.to_string()];
    let e = spec.exts;
    if e & isa::EXT_M != 0 {
        parts.push("m2p0".into());
        parts.push("zmmul1p0".into());
    }
    if e & isa::EXT_A != 0 {
        parts.push("a2p1".into());
        parts.push("zaamo1p0".into());
        parts.push("zalrsc1p0".into());
    }
    if e & isa::EXT_F != 0 {
        parts.push("f2p2".into());
    }
    if e & isa::EXT_D != 0 {
        parts.push("d2p2".into());
    }
    if e & isa::EXT_C != 0 {
        parts.push("c2p0".into());
    }
    if e & isa::EXT_ZICSR != 0 {
        parts.push("zicsr2p0".into());
    }
    if e & isa::EXT_ZIFENCEI != 0 {
        parts.push("zifencei1p0".into());
    }
    parts.join("_")
}

pub fn parse_and_assemble(
    sources: &[(String, String)],
    include_dirs: &[String],
    spec: IsaSpec,
    mabi: Mabi,
    defsyms: &[(String, i128)],
) -> Result<(u32, Vec<OutSection>, Vec<OutSym>, u32, Option<Vec<u8>>), AsmError> {
    let mut all_items = Vec::new();
    for (src, file) in sources {
        let p = Parser::new(src, file, include_dirs.to_vec())?;
        let items = p.parse()?;
        all_items.extend(items);
    }
    let mut asm = Assembler::new(spec, mabi);
    let _ = &mut all_items;
    for (n, v) in defsyms {
        let s = asm.ensure_sym(n);
        s.defined = true;
        s.abs = true;
        s.value = *v as u64;
        asm.defined_in_file.insert(n.clone());
    }
    asm.assemble(&mut all_items)?;
    Ok(asm.build_output())
}
