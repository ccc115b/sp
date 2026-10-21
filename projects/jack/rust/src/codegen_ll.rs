//! AST --codegen--> LLVM IR (.ll)。與 codegen.rs(JVM 版)平行的後端。
//!
//! 型別對應: int/char/boolean -> i32;物件與陣列 -> ptr(不透明指標)。
//! Jack 沒有繼承,方法呼叫直接用名稱修飾 `@Class_sub`;兩個整數間
//! 的關係運算結果以 -1(true)/0(false) 表示,與 JVM 版一致。
//!
//! 產出方式: 每個使用者類別一個 .ll 模組(對應一個 .class):
//!   - 欄位 -> `%class.Name = type { ... }`(有名稱的 struct)
//!   - 靜態變數 -> 全域變數 `@"Class.name"`
//!   - Jack OS 內建類別與跨類別呼叫 -> `declare` 外部函式
//!   - `Array.new(n)` -> malloc(n*4),`a[i]` -> GEP i32
//!   - 字串字面量 -> 唯讀常數 + `@jack_string_lit`

use std::collections::{HashMap, HashSet};
use std::fmt::Write as _;

use crate::ast::{CallE, ClassDecl, Expr, Kind, Stmt, SubDecl};
use crate::error::{CompileError, Result};

const INT: &str = "i32";
const PTR: &str = "ptr";

#[derive(Clone, Copy, PartialEq, Eq, Debug)]
enum VKind {
    Local,
    Field,
    Static,
}

#[derive(Clone, Debug)]
struct Var {
    name: String,
    jack_ty: String,
    ll: String, // "i32" 或 "ptr"
    kind: VKind,
    /// Field: 在 struct 中的索引;Static: 全域名稱;Local: alloca 暫存器。
    field_idx: usize,
    global: String,
    addr: String,
}

/// 呼叫時需要的子程式簽章(從 SubDecl 萃取,避免同時借用 self)。
#[derive(Clone)]
struct SubSig {
    kind: Kind,
    name: String,
    nparams: usize,
    param_types: Vec<String>,
    ret: String, // Jack 型別("void" 表示無回傳)
}

/// 子程式的 llvm 符號名稱: `@Class_sub`(Jack 無繼承,同類別內名稱唯一)。
fn mangle(class: &str, sub: &str) -> String {
    format!("{class}_{sub}")
}

/// Jack 型別 -> llvm 型別("i32" / "ptr")。
fn ll_of(ty: &str) -> &'static str {
    match ty {
        "int" | "char" | "boolean" => INT,
        _ => PTR,
    }
}

/// llvm 型別回推顯示名稱(錯誤訊息用)。
fn show_ll(ll: &str) -> String {
    match ll {
        INT => "int".to_string(),
        PTR => "object".to_string(),
        "void" => "void".to_string(),
        _ => ll.to_string(),
    }
}

/// 字串字面量 -> LLVM `c"..."` 形式(非可列印字元以 \XX 跳脫,結尾補 \00)。
fn llvm_escape(s: &str) -> String {
    let mut out = String::from("c\"");
    for b in s.bytes() {
        if (32..127).contains(&b) && b != b'"' && b != b'\\' {
            out.push(b as char);
        } else {
            let _ = write!(out, "\\{:02X}", b);
        }
    }
    out.push_str("\\00\"");
    out
}

fn find_sub<'a>(c: &'a ClassDecl, name: &str) -> Option<&'a SubDecl> {
    c.subs.iter().find(|s| s.name == name)
}

pub struct Gen {
    classes: HashMap<String, ClassDecl>,
    cls: ClassDecl,
    // ---- 目前函式 ----
    lines: Vec<String>,
    tmp: usize,
    label: usize,
    vars: HashMap<String, Var>,
    class_vars: HashMap<String, Var>,
    this_addr: String,
    sub_ret: String,
    /// 最後一條指令是否為終端指令(ret/br),用來決定要不要補 label。
    terminated: bool,
    line: usize,
    // ---- 目前模組(類別) ----
    structs: Vec<String>,  // %class.X = type ...
    globals: Vec<String>,  // 靜態變數
    strs: Vec<String>,     // 字串常數
    declares: Vec<String>, // declare 外部函式(去重)
    decl_set: HashSet<String>,
    str_count: usize,
}

impl Gen {
    pub fn new(classes: HashMap<String, ClassDecl>) -> Self {
        Gen {
            classes,
            cls: ClassDecl::default(),
            lines: Vec::new(),
            tmp: 0,
            label: 0,
            vars: HashMap::new(),
            class_vars: HashMap::new(),
            this_addr: String::new(),
            sub_ret: "void".to_string(),
            terminated: false,
            line: 1,
            structs: Vec::new(),
            globals: Vec::new(),
            strs: Vec::new(),
            declares: Vec::new(),
            decl_set: HashSet::new(),
            str_count: 0,
        }
    }

    fn err(&self, msg: impl Into<String>) -> CompileError {
        CompileError::new(&self.cls.file, self.line, msg)
    }

    // ---------- types ----------

    /// 檢查型別是否存在,回傳對應的 llvm 型別。
    fn ty(&self, t: &str) -> Result<&'static str> {
        match t {
            "int" | "char" | "boolean" | "Array" | "Object" | "String" => Ok(ll_of(t)),
            _ => {
                if self.classes.contains_key(t) {
                    Ok(PTR)
                } else {
                    Err(self.err(format!("unknown type '{t}'")))
                }
            }
        }
    }

    fn ret_ty(&self, t: &str) -> Result<&'static str> {
        if t == "void" {
            Ok("void")
        } else {
            self.ty(t)
        }
    }

    fn sub_sig(&self, c: &ClassDecl, name: &str) -> Result<SubSig> {
        let s = find_sub(c, name)
            .ok_or_else(|| self.err(format!("class {} has no subroutine '{}'", c.name, name)))?;
        Ok(SubSig {
            kind: s.kind,
            name: s.name.clone(),
            nparams: s.params.len(),
            param_types: s.params.iter().map(|p| p.ty.clone()).collect(),
            ret: s.ret.clone(),
        })
    }

    // ---------- module ----------

    /// 產生所有使用者類別的 .ll,回傳 (類別名稱, IR 內容),順序 = 原始檔順序。
    pub fn gen_module(&mut self, user: &[ClassDecl]) -> Result<Vec<(String, String)>> {
        let mut out = Vec::with_capacity(user.len());
        for c in user {
            out.push((c.name.clone(), self.gen_class(c)?));
        }
        Ok(out)
    }

    fn gen_class(&mut self, c: &ClassDecl) -> Result<String> {
        self.cls = c.clone();
        self.line = 1;
        self.structs.clear();
        self.globals.clear();
        self.strs.clear();
        self.declares.clear();
        self.decl_set.clear();
        self.str_count = 0;
        self.class_vars.clear();

        // 欄位 -> struct 索引;靜態變數 -> 全域變數。
        let mut field_tys: Vec<String> = Vec::new();
        for v in &c.fields {
            if self.class_vars.contains_key(&v.name) {
                return Err(self.err(format!("duplicate field '{}'", v.name)));
            }
            let ll = self.ty(&v.ty)?;
            self.class_vars.insert(
                v.name.clone(),
                Var {
                    name: v.name.clone(),
                    jack_ty: v.ty.clone(),
                    ll: ll.to_string(),
                    kind: VKind::Field,
                    field_idx: field_tys.len(),
                    global: String::new(),
                    addr: String::new(),
                },
            );
            field_tys.push(ll.to_string());
        }
        // 空類別補一個 padding 欄位,讓 struct 至少可被 GEP 取大小。
        if field_tys.is_empty() {
            field_tys.push(INT.to_string());
        }
        self.structs
            .push(format!("%class.{} = type {{ {} }}", c.name, field_tys.join(", ")));

        for v in &c.statics {
            if self.class_vars.contains_key(&v.name) {
                return Err(self.err(format!("duplicate field '{}'", v.name)));
            }
            let ll = self.ty(&v.ty)?;
            let gname = format!("@\"{}.{}\"", c.name, v.name);
            let init = if ll == INT { "0" } else { "null" };
            self.globals.push(format!("{gname} = global {ll} {init}"));
            self.class_vars.insert(
                v.name.clone(),
                Var {
                    name: v.name.clone(),
                    jack_ty: v.ty.clone(),
                    ll: ll.to_string(),
                    kind: VKind::Static,
                    field_idx: 0,
                    global: gname,
                    addr: String::new(),
                },
            );
        }

        let mut seen: HashSet<&str> = HashSet::new();
        for s in &c.subs {
            if !seen.insert(s.name.as_str()) {
                self.line = s.line;
                return Err(self.err(format!("duplicate subroutine '{}'", s.name)));
            }
        }

        let mut funcs: Vec<String> = Vec::new();
        for s in &c.subs {
            funcs.push(self.gen_sub(s)?);
        }

        // Main.main() 橋接入口。
        if c.name == "Main"
            && c.subs
                .iter()
                .any(|s| s.kind == Kind::Function && s.name == "main" && s.params.is_empty())
        {
            let f = mangle("Main", "main");
            funcs.push(format!(
                "define i32 @main() {{\nentry:\n  call void @\"{f}\"()\n  ret i32 0\n}}"
            ));
        }

        let mut text = String::new();
        let _ = writeln!(text, "; ModuleID = '{}'", c.name);
        for l in &self.structs {
            let _ = writeln!(text, "{l}");
        }
        for l in &self.globals {
            let _ = writeln!(text, "{l}");
        }
        for l in &self.strs {
            let _ = writeln!(text, "{l}");
        }
        for l in &self.declares {
            let _ = writeln!(text, "{l}");
        }
        for f in &funcs {
            let _ = writeln!(text, "{f}");
        }
        Ok(text)
    }

    // ---------- helpers ----------

    fn t(&mut self) -> String {
        let r = format!("%t{}", self.tmp);
        self.tmp += 1;
        r
    }

    fn l(&mut self) -> String {
        let r = format!("L{}", self.label);
        self.label += 1;
        r
    }

    fn emit(&mut self, s: impl Into<String>) {
        self.lines.push(s.into());
    }

    fn emit_label(&mut self, name: &str) {
        self.lines.push(format!("{name}:"));
        self.terminated = false;
    }

    fn declare_extern(&mut self, decl: String) {
        if self.decl_set.insert(decl.clone()) {
            self.declares.push(decl);
        }
    }

    fn lookup(&self, name: &str) -> Option<Var> {
        self.vars.get(name).cloned().or_else(|| self.class_vars.get(name).cloned())
    }

    fn load_this(&mut self) -> Result<String> {
        if self.this_addr.is_empty() {
            return Err(self.err("'this' / field access is not allowed inside a function"));
        }
        let r = self.t();
        self.emit(format!("{r} = load {PTR}, ptr {}", self.this_addr));
        Ok(r)
    }

    fn load_var(&mut self, v: &Var) -> Result<String> {
        match v.kind {
            VKind::Local => {
                let r = self.t();
                self.emit(format!("{r} = load {}, ptr {}", v.ll, v.addr));
                Ok(r)
            }
            VKind::Field => {
                let this = self.load_this()?;
                let p = self.t();
                self.emit(format!(
                    "{p} = getelementptr %class.{}, ptr {this}, i32 0, i32 {}",
                    self.cls.name, v.field_idx
                ));
                let r = self.t();
                self.emit(format!("{r} = load {}, ptr {p}", v.ll));
                Ok(r)
            }
            VKind::Static => {
                let r = self.t();
                self.emit(format!("{r} = load {}, ptr {}", v.ll, v.global));
                Ok(r)
            }
        }
    }

    /// 產生 e 並轉成型別 to(INT/PTR),回傳值的文字(暫存器或常數)。
    fn gen_as(&mut self, e: &Expr, to: &str) -> Result<String> {
        if to == INT {
            match e {
                Expr::IntC(v) => return Ok(v.to_string()),
                Expr::KwC(k) if k == "false" => return Ok("0".to_string()),
                Expr::KwC(k) if k == "true" => return Ok("-1".to_string()),
                Expr::KwC(k) if k == "null" => return Ok("0".to_string()),
                _ => {}
            }
        } else if let Expr::IntC(0) = e {
            // 0 常數可以當 null 使用。
            return Ok("null".to_string());
        } else if let Expr::KwC(k) = e {
            if k == "null" {
                return Ok("null".to_string());
            }
        }
        let (t, v) = self.gen(e)?;
        if t == "void" {
            return Err(self.err("void subroutine used as a value"));
        }
        if t != to {
            return Err(self.err(format!(
                "type mismatch: expected {} but got {}",
                show_ll(to),
                show_ll(&t)
            )));
        }
        Ok(v)
    }

    // ---------- statements ----------

    fn gen_statements(&mut self, list: &[Stmt]) -> Result<()> {
        for s in list {
            self.gen_statement(s)?;
        }
        Ok(())
    }

    fn gen_statement(&mut self, stmt: &Stmt) -> Result<()> {
        match stmt {
            Stmt::Let { name, index, value, line } => {
                self.line = *line;
                let v = self
                    .lookup(name)
                    .ok_or_else(|| self.err(format!("undefined variable '{name}'")))?;
                if let Some(idx) = index {
                    if v.jack_ty != "Array" {
                        return Err(self.err(format!("'{}' is not an Array", v.name)));
                    }
                    let base = self.load_var(&v)?;
                    let i = self.gen_as(idx, INT)?;
                    let val = self.gen_as(value, INT)?;
                    let p = self.t();
                    self.emit(format!("{p} = getelementptr {INT}, ptr {base}, {INT} {i}"));
                    self.emit(format!("store {INT} {val}, ptr {p}"));
                } else {
                    match v.kind {
                        VKind::Local => {
                            let val = self.gen_as(value, &v.ll)?;
                            self.emit(format!("store {} {}, ptr {}", v.ll, val, v.addr));
                        }
                        VKind::Field => {
                            let this = self.load_this()?;
                            let val = self.gen_as(value, &v.ll)?;
                            let p = self.t();
                            self.emit(format!(
                                "{p} = getelementptr %class.{}, ptr {this}, i32 0, i32 {}",
                                self.cls.name, v.field_idx
                            ));
                            self.emit(format!("store {} {}, ptr {}", v.ll, val, p));
                        }
                        VKind::Static => {
                            let val = self.gen_as(value, &v.ll)?;
                            self.emit(format!("store {} {}, ptr {}", v.ll, val, v.global));
                        }
                    }
                }
            }
            Stmt::If { cond, then, els, line } => {
                self.line = *line;
                let c = self.gen_as(cond, INT)?;
                let b = self.t();
                self.emit(format!("{b} = icmp ne {INT} {c}, 0"));
                let l_then = self.l();
                let l_els = self.l();
                let l_end = self.l();
                let l_false = if els.is_some() { l_els.clone() } else { l_end.clone() };
                self.emit(format!("br i1 {b}, label %{l_then}, label %{l_false}"));
                self.terminated = true;
                self.emit_label(&l_then);
                self.gen_statements(then)?;
                if !self.terminated {
                    self.emit(format!("br label %{l_end}"));
                    self.terminated = true;
                }
                if let Some(e) = els {
                    self.emit_label(&l_els);
                    self.gen_statements(e)?;
                    if !self.terminated {
                        self.emit(format!("br label %{l_end}"));
                        self.terminated = true;
                    }
                }
                self.emit_label(&l_end);
            }
            Stmt::While { cond, body, line } => {
                self.line = *line;
                let l_top = self.l();
                let l_body = self.l();
                let l_end = self.l();
                if !self.terminated {
                    self.emit(format!("br label %{l_top}"));
                    self.terminated = true;
                }
                self.emit_label(&l_top);
                let c = self.gen_as(cond, INT)?;
                let b = self.t();
                self.emit(format!("{b} = icmp ne {INT} {c}, 0"));
                self.emit(format!("br i1 {b}, label %{l_body}, label %{l_end}"));
                self.terminated = true;
                self.emit_label(&l_body);
                self.gen_statements(body)?;
                if !self.terminated {
                    self.emit(format!("br label %{l_top}"));
                    self.terminated = true;
                }
                self.emit_label(&l_end);
            }
            Stmt::Do { call, line } => {
                self.line = *line;
                self.gen_call(call)?;
            }
            Stmt::Return { value, line } => {
                self.line = *line;
                let rd = self.sub_ret.clone();
                if rd == "void" {
                    if value.is_some() {
                        return Err(self.err("void subroutine cannot return a value"));
                    }
                    self.emit("ret void");
                } else {
                    let v = value
                        .as_ref()
                        .ok_or_else(|| self.err("non-void subroutine must return a value"))?;
                    let ll = self.ret_ty(&rd)?;
                    let val = self.gen_as(v, ll)?;
                    self.emit(format!("ret {ll} {val}"));
                }
                self.terminated = true;
            }
        }
        Ok(())
    }

    // ---------- expressions ----------

    /// 產生運算式,回傳 (llvm 型別, 值文字)。型別為 INT / PTR / "void"。
    fn gen(&mut self, e: &Expr) -> Result<(String, String)> {
        match e {
            Expr::IntC(v) => Ok((INT.to_string(), v.to_string())),
            Expr::StrC(s) => {
                let bytes = s.bytes().count() + 1;
                let gname = format!("@.str.{}", self.str_count);
                self.str_count += 1;
                self.strs.push(format!(
                    "{gname} = private unnamed_addr constant [{bytes} x i8] {}",
                    llvm_escape(s)
                ));
                self.declare_extern("declare ptr @jack_string_lit(ptr)".to_string());
                let r = self.t();
                self.emit(format!("{r} = call {PTR} @jack_string_lit(ptr {gname})"));
                Ok((PTR.to_string(), r))
            }
            Expr::KwC(k) => match k.as_str() {
                "true" => Ok((INT.to_string(), "-1".to_string())),
                "false" => Ok((INT.to_string(), "0".to_string())),
                "null" => Ok((PTR.to_string(), "null".to_string())),
                _ => {
                    let this = self.load_this()?;
                    Ok((PTR.to_string(), this))
                }
            },
            Expr::VarE { name, line } => {
                self.line = *line;
                let v = self
                    .lookup(name)
                    .ok_or_else(|| self.err(format!("undefined variable '{name}'")))?;
                let r = self.load_var(&v)?;
                Ok((v.ll, r))
            }
            Expr::IndexE { name, index, line } => {
                self.line = *line;
                let v = self
                    .lookup(name)
                    .ok_or_else(|| self.err(format!("undefined variable '{name}'")))?;
                if v.jack_ty != "Array" {
                    return Err(self.err(format!("'{}' is not an Array", v.name)));
                }
                let base = self.load_var(&v)?;
                let i = self.gen_as(index, INT)?;
                let p = self.t();
                self.emit(format!("{p} = getelementptr {INT}, ptr {base}, {INT} {i}"));
                let r = self.t();
                self.emit(format!("{r} = load {INT}, ptr {p}"));
                Ok((INT.to_string(), r))
            }
            Expr::Call(c) => self.gen_call(c),
            Expr::Bin { l, op, r } => self.gen_bin(l, op, r),
            Expr::Un { op, e } => {
                let v = self.gen_as(e, INT)?;
                let r = self.t();
                if op == "-" {
                    self.emit(format!("{r} = sub nsw {INT} 0, {v}"));
                } else {
                    self.emit(format!("{r} = xor {INT} {v}, -1"));
                }
                Ok((INT.to_string(), r))
            }
        }
    }

    fn gen_bin(&mut self, l: &Expr, op: &str, r: &Expr) -> Result<(String, String)> {
        let (lt, lv) = self.gen(l)?;
        if lt == "void" {
            return Err(self.err("void subroutine used as a value"));
        }
        let (rt, rv) = self.gen(r)?;
        if rt == "void" {
            return Err(self.err("void subroutine used as a value"));
        }
        let out = self.t();
        match op {
            "+" | "-" | "*" | "/" | "&" | "|" => {
                if lt != INT || rt != INT {
                    return Err(self.err(format!(
                        "operator needs int operands, got {} and {}",
                        show_ll(&lt),
                        show_ll(&rt)
                    )));
                }
                let ins = match op {
                    "+" => format!("add nsw {INT} {lv}, {rv}"),
                    "-" => format!("sub nsw {INT} {lv}, {rv}"),
                    "*" => format!("mul nsw {INT} {lv}, {rv}"),
                    "/" => format!("sdiv {INT} {lv}, {rv}"),
                    "&" => format!("and {INT} {lv}, {rv}"),
                    _ => format!("or {INT} {lv}, {rv}"),
                };
                self.emit(format!("{out} = {ins}"));
            }
            "<" | ">" => {
                if lt != INT || rt != INT {
                    return Err(self.err(format!(
                        "operator needs int operands, got {} and {}",
                        show_ll(&lt),
                        show_ll(&rt)
                    )));
                }
                let pred = if op == "<" { "slt" } else { "sgt" };
                self.emit_compare(&out, &format!("icmp {pred} {INT} {lv}, {rv}"));
            }
            _ => {
                // "="(相等比較)
                if (lt == INT) != (rt == INT) {
                    return Err(self.err(format!(
                        "cannot compare {} with {}",
                        show_ll(&lt),
                        show_ll(&rt)
                    )));
                }
                let ty = if lt == INT { INT } else { PTR };
                self.emit_compare(&out, &format!("icmp eq {ty} {lv}, {rv}"));
            }
        }
        Ok((INT.to_string(), out))
    }

    /// icmp 結果轉成 Jack 慣例的 -1(true)/0(false)。
    fn emit_compare(&mut self, out: &str, icmp: &str) {
        let c = self.t();
        self.emit(format!("{c} = {icmp}"));
        let z = self.t();
        self.emit(format!("{z} = zext i1 {c} to {INT}"));
        self.emit(format!("{out} = sub {INT} 0, {z}"));
    }

    fn gen_args(&mut self, sig: &SubSig, c: &CallE) -> Result<Vec<String>> {
        if sig.nparams != c.args.len() {
            return Err(self.err(format!(
                "'{}' expects {} argument(s) but got {}",
                sig.name,
                sig.nparams,
                c.args.len()
            )));
        }
        let mut args = Vec::with_capacity(c.args.len());
        for (i, a) in c.args.iter().enumerate() {
            let ll = self.ty(&sig.param_types[i])?;
            let v = self.gen_as(a, ll)?;
            args.push(format!("{ll} {v}"));
        }
        Ok(args)
    }

    /// 是否為本模組(同類別)內有定義的子程式。
    fn is_local_sub(&self, class: &str, sub: &str) -> bool {
        self.cls.name == class && find_sub(&self.cls, sub).is_some()
    }

    fn emit_call(&mut self, ret_ll: &str, fname: &str, args: &[String]) -> String {
        if ret_ll == "void" {
            self.emit(format!("call void @\"{fname}\"({})", args.join(", ")));
            String::new()
        } else {
            let r = self.t();
            self.emit(format!("{r} = call {ret_ll} @\"{fname}\"({})", args.join(", ")));
            r
        }
    }

    /// 對外部(非本模組定義)的子程式補 declare。
    fn declare_for(&mut self, oc: &ClassDecl, sig: &SubSig) {
        if self.is_local_sub(&oc.name, &sig.name) {
            return;
        }
        let f = mangle(&oc.name, &sig.name);
        let mut params: Vec<String> = Vec::new();
        if sig.kind == Kind::Method {
            params.push(PTR.to_string());
        }
        for p in &sig.param_types {
            params.push(ll_of(p).to_string());
        }
        let ret = if sig.ret == "void" { "void".to_string() } else { ll_of(&sig.ret).to_string() };
        self.declare_extern(format!("declare {ret} @\"{f}\"({})", params.join(", ")));
    }

    fn gen_call(&mut self, c: &CallE) -> Result<(String, String)> {
        self.line = c.line;
        if c.target.is_none() {
            // foo(...) -> 目前類別的 method / function
            let sig = self.sub_sig(&self.cls, &c.name)?;
            let mut args = Vec::new();
            if sig.kind == Kind::Method {
                let this = self.load_this()?;
                args.push(format!("{PTR} {this}"));
            }
            args.extend(self.gen_args(&sig, c)?);
            let f = mangle(&self.cls.name, &sig.name);
            let ret = self.ret_ty(&sig.ret)?.to_string();
            let r = self.emit_call(&ret, &f, &args);
            return Ok((ret, r));
        }

        let target = c.target.as_ref().unwrap();
        if let Some(v) = self.lookup(target) {
            // obj.method(...)
            let oc = self
                .classes
                .get(&v.jack_ty)
                .ok_or_else(|| {
                    self.err(format!(
                        "cannot call a method on '{}' of type {}",
                        v.name, v.jack_ty
                    ))
                })?
                .clone();
            let sig = self.sub_sig(&oc, &c.name)?;
            if sig.kind != Kind::Method {
                return Err(self.err(format!("'{}.{}' is not a method", oc.name, sig.name)));
            }
            let base = self.load_var(&v)?;
            if oc.name == "Array" {
                // Array.dispose(): 記憶體由 malloc 配置,這裡直接 free。
                self.declare_extern("declare void @free(ptr)".to_string());
                self.emit(format!("call void @free(ptr {base})"));
                return Ok(("void".to_string(), String::new()));
            }
            let mut args = vec![format!("{PTR} {base}")];
            args.extend(self.gen_args(&sig, c)?);
            self.declare_for(&oc, &sig);
            let f = mangle(&oc.name, &sig.name);
            let ret = self.ret_ty(&sig.ret)?.to_string();
            let r = self.emit_call(&ret, &f, &args);
            return Ok((ret, r));
        }

        // Class.function(...) / Class.new(...)
        let oc = self
            .classes
            .get(target)
            .ok_or_else(|| self.err(format!("undefined variable or class '{target}'")))?
            .clone();
        let sig = self.sub_sig(&oc, &c.name)?;
        if sig.kind == Kind::Method {
            return Err(self.err(format!(
                "'{}.{}' is a method; call it on an object",
                oc.name, sig.name
            )));
        }
        if oc.builtin && oc.name == "Array" && sig.name == "new" {
            // Array.new(size) -> malloc(size * 4)
            if sig.nparams != c.args.len() {
                return Err(self.err(format!(
                    "'{}' expects {} argument(s) but got {}",
                    sig.name,
                    sig.nparams,
                    c.args.len()
                )));
            }
            let sz = self.gen_as(&c.args[0], INT)?;
            self.declare_extern("declare ptr @malloc(i64)".to_string());
            let b = self.t();
            self.emit(format!("{b} = mul nsw {INT} {sz}, 4"));
            let b64 = self.t();
            self.emit(format!("{b64} = sext {INT} {b} to i64"));
            let m = self.t();
            self.emit(format!("{m} = call {PTR} @malloc(i64 {b64})"));
            return Ok((PTR.to_string(), m));
        }
        let args = self.gen_args(&sig, c)?;
        if oc.builtin {
            // Jack OS 內建類別 -> 外部函式。
            let f = mangle(&oc.name, &sig.name);
            let ret = self.ret_ty(&sig.ret)?.to_string();
            let mut ps: Vec<String> = Vec::new();
            for p in &sig.param_types {
                ps.push(ll_of(p).to_string());
            }
            self.declare_extern(format!("declare {ret} @\"{f}\"({})", ps.join(", ")));
            let r = self.emit_call(&ret, &f, &args);
            return Ok((ret, r));
        }
        self.declare_for(&oc, &sig);
        let f = mangle(&oc.name, &sig.name);
        let ret = self.ret_ty(&sig.ret)?.to_string();
        let r = self.emit_call(&ret, &f, &args);
        Ok((ret, r))
    }

    // ---------- subroutine ----------

    fn gen_sub(&mut self, s: &SubDecl) -> Result<String> {
        self.line = s.line;
        self.lines = Vec::new();
        self.tmp = 0;
        self.label = 0;
        self.vars.clear();
        self.terminated = false;
        self.sub_ret = s.ret.clone();

        let is_method = s.kind == Kind::Method;
        let is_ctor = s.kind == Kind::Constructor;
        let ret_ll = self.ret_ty(&s.ret)?.to_string();

        if is_ctor && self.ty(&self.cls.name)? != PTR {
            return Err(self.err(format!("constructor must return {}", self.cls.name)));
        }

        // 參數列(method 會多一個 this)。
        let mut sig_line = String::new();
        if is_method {
            sig_line.push_str("ptr %this");
        }
        for p in &s.params {
            let ll = self.ty(&p.ty)?;
            if !sig_line.is_empty() {
                sig_line.push_str(", ");
            }
            sig_line.push_str(&format!("{ll} %\"{}\"", p.name));
        }

        // entry: 配置 this 與所有變數的 stack slot。
        if is_ctor {
            // this = malloc(sizeof(%class.C));欄位清為 0/null。
            self.this_addr = "%this.addr".to_string();
            self.emit(format!("{} = alloca {PTR}", self.this_addr));
            self.declare_extern("declare ptr @malloc(i64)".to_string());
            let szp = self.t();
            self.emit(format!("{szp} = getelementptr %class.{}, ptr null, i32 1", self.cls.name));
            let sz = self.t();
            self.emit(format!("{sz} = ptrtoint ptr {szp} to i64"));
            let m = self.t();
            self.emit(format!("{m} = call {PTR} @malloc(i64 {sz})"));
            self.emit(format!("store {PTR} {m}, ptr {}", self.this_addr));
            let fields: Vec<(usize, String, bool)> = self
                .class_vars
                .values()
                .filter(|v| v.kind == VKind::Field)
                .map(|v| (v.field_idx, v.ll.clone(), v.ll == INT))
                .collect();
            for (idx, ll, is_int) in fields {
                let init = if is_int { "0" } else { "null" };
                let p = self.t();
                self.emit(format!(
                    "{p} = getelementptr %class.{}, ptr {m}, i32 0, i32 {idx}",
                    self.cls.name
                ));
                self.emit(format!("store {ll} {init}, ptr {p}"));
            }
        } else if is_method {
            self.this_addr = "%this.addr".to_string();
            self.emit(format!("{} = alloca {PTR}", self.this_addr));
            self.emit(format!("store {PTR} %this, ptr {}", self.this_addr));
        } else {
            self.this_addr = String::new();
        }
        for p in &s.params {
            let ll = self.ty(&p.ty)?;
            let addr = format!("%l.{}", p.name);
            self.emit(format!("{addr} = alloca {ll}"));
            self.emit(format!("store {ll} %\"{}\", ptr {addr}", p.name));
            self.vars.insert(
                p.name.clone(),
                Var {
                    name: p.name.clone(),
                    jack_ty: p.ty.clone(),
                    ll: ll.to_string(),
                    kind: VKind::Local,
                    field_idx: 0,
                    global: String::new(),
                    addr,
                },
            );
        }
        for v in &s.locals {
            if self.vars.contains_key(&v.name) {
                return Err(self.err(format!("duplicate variable '{}'", v.name)));
            }
            let ll = self.ty(&v.ty)?;
            let addr = format!("%l.{}", v.name);
            self.emit(format!("{addr} = alloca {ll}"));
            let init = if ll == INT { "0" } else { "null" };
            self.emit(format!("store {ll} {init}, ptr {addr}"));
            self.vars.insert(
                v.name.clone(),
                Var {
                    name: v.name.clone(),
                    jack_ty: v.ty.clone(),
                    ll: ll.to_string(),
                    kind: VKind::Local,
                    field_idx: 0,
                    global: String::new(),
                    addr,
                },
            );
        }

        self.gen_statements(&s.body)?;

        // 保險用的結尾 return(控制流可能掉出方法尾端)。
        if !self.terminated {
            self.emit_fallback_ret(is_ctor, &ret_ll)?;
        } else if is_ctor {
            // 前面已有 return;補一個空區塊保底,讓函式一定以 return 結束。
            let l = self.l();
            self.emit_label(&l);
            self.emit_fallback_ret(is_ctor, &ret_ll)?;
        }

        let f = mangle(&self.cls.name, &s.name);
        let body = std::mem::take(&mut self.lines);
        let mut out = String::new();
        let _ = write!(out, "define {ret_ll} @\"{f}\"({sig_line}) {{\nentry:\n");
        for l in body {
            let _ = writeln!(out, "  {l}");
        }
        let _ = writeln!(out, "}}");
        Ok(out)
    }

    /// 掉出函式尾端時補的 return(ctor 回 this,void 不回值,int 回 0,其他回 null)。
    fn emit_fallback_ret(&mut self, is_ctor: bool, ret_ll: &str) -> Result<()> {
        if is_ctor {
            let this = self.load_this()?;
            self.emit(format!("ret {PTR} {this}"));
        } else if ret_ll == "void" {
            self.emit("ret void");
        } else if ret_ll == INT {
            self.emit(format!("ret {INT} 0"));
        } else {
            self.emit(format!("ret {PTR} null"));
        }
        self.terminated = true;
        Ok(())
    }
}
