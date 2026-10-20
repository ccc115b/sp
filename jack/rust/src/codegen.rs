//! AST --codegen--> .class 位元組碼。對應 Java 版的 `Gen` 類別。

use std::collections::{HashMap, HashSet};

use crate::ast::{CallE, ClassDecl, Expr, Kind, Stmt, SubDecl, VarDecl};
use crate::classfile::*;
use crate::error::{CompileError, Result};

#[derive(Clone, Copy, PartialEq, Eq, Debug)]
pub enum VKind {
    Local,
    Field,
    Static,
}

#[derive(Clone, Debug)]
pub struct Var {
    pub name: String,
    pub kind: VKind,
    pub ty: String,
    pub desc: String,
    pub slot: i32,
}

/// 呼叫時需要的子程式簽章(從 SubDecl 萃取出來,避免同時借用 self)。
#[derive(Clone)]
struct SubSig {
    kind: Kind,
    name: String,
    nparams: usize,
    param_types: Vec<String>,
    ret: String,
    jvm_name: String,
    desc: String,
}

fn find_sub<'a>(c: &'a ClassDecl, name: &str) -> Option<&'a SubDecl> {
    c.subs.iter().find(|s| s.name == name)
}

pub struct Gen {
    classes: HashMap<String, ClassDecl>,
    cls: ClassDecl,
    cf: ClassFile,
    code: Code,
    sub: SubDecl,
    vars: HashMap<String, Var>,
    class_vars: HashMap<String, Var>,
    this_slot: i32,
    line: usize,
}

impl Gen {
    pub fn new(classes: HashMap<String, ClassDecl>) -> Self {
        Gen {
            classes,
            cls: ClassDecl::default(),
            cf: ClassFile::new(""),
            code: Code::new(),
            sub: SubDecl::default(),
            vars: HashMap::new(),
            class_vars: HashMap::new(),
            this_slot: 0,
            line: 1,
        }
    }

    fn err(&self, msg: impl Into<String>) -> CompileError {
        CompileError::new(&self.cls.file, self.line, msg)
    }

    // ---------- types ----------

    fn desc(&self, t: &str) -> Result<String> {
        Ok(match t {
            "int" | "char" | "boolean" => "I".to_string(),
            "void" => "V".to_string(),
            "Array" => "[I".to_string(),
            "Object" => "Ljava/lang/Object;".to_string(),
            _ => {
                let c = self
                    .classes
                    .get(t)
                    .ok_or_else(|| self.err(format!("unknown type '{t}'")))?;
                format!("L{};", c.jvm_name)
            }
        })
    }

    fn is_ref(d: &str) -> bool {
        d != "I" && d != "V"
    }

    fn show(d: &str) -> String {
        match d {
            "I" => "int".to_string(),
            "N" => "null".to_string(),
            "V" => "void".to_string(),
            "[I" => "Array".to_string(),
            "Ljack/JString;" => "String".to_string(),
            _ => {
                let mut ch: Vec<char> = d.chars().collect();
                if ch.len() >= 2 {
                    ch.pop();
                    ch.remove(0);
                }
                ch.into_iter().collect::<String>().replace("jack/", "")
            }
        }
    }

    fn sub_desc(&self, s: &SubDecl) -> Result<String> {
        let mut sb = String::from("(");
        for p in &s.params {
            sb.push_str(&self.desc(&p.ty)?);
        }
        sb.push(')');
        sb.push_str(&self.desc(&s.ret)?);
        Ok(sb)
    }

    fn sig_of(&self, s: &SubDecl) -> Result<SubSig> {
        let mut param_types = Vec::with_capacity(s.params.len());
        for p in &s.params {
            param_types.push(p.ty.clone());
        }
        Ok(SubSig {
            kind: s.kind,
            name: s.name.clone(),
            nparams: s.params.len(),
            param_types,
            ret: self.desc(&s.ret)?,
            jvm_name: s.jvm_name(),
            desc: self.sub_desc(s)?,
        })
    }

    // ---------- class ----------

    pub fn gen_class(&mut self, c: &ClassDecl) -> Result<Vec<u8>> {
        self.cls = c.clone();
        self.line = 1;
        self.cf = ClassFile::new(&c.jvm_name);
        self.class_vars.clear();
        for v in &c.statics {
            if self.class_vars.contains_key(&v.name) {
                return Err(self.err(format!("duplicate field '{}'", v.name)));
            }
            let d = self.desc(&v.ty)?;
            self.class_vars.insert(
                v.name.clone(),
                Var { name: v.name.clone(), kind: VKind::Static, ty: v.ty.clone(), desc: d.clone(), slot: -1 },
            );
            self.cf.add_field(0x0009, &v.name, &d);
        }
        for v in &c.fields {
            if self.class_vars.contains_key(&v.name) {
                return Err(self.err(format!("duplicate field '{}'", v.name)));
            }
            let d = self.desc(&v.ty)?;
            self.class_vars.insert(
                v.name.clone(),
                Var { name: v.name.clone(), kind: VKind::Field, ty: v.ty.clone(), desc: d.clone(), slot: -1 },
            );
            self.cf.add_field(0x0001, &v.name, &d);
        }
        let mut seen: HashSet<&str> = HashSet::new();
        for s in &c.subs {
            if !seen.insert(s.name.as_str()) {
                self.line = s.line;
                return Err(self.err(format!("duplicate subroutine '{}'", s.name)));
            }
        }

        // 預設建構子
        let mut init = Code::new();
        init.local(ALOAD, 0, 1);
        init.invoke(&mut self.cf.cp, INVOKESPECIAL, "java/lang/Object", "<init>", "()V");
        init.op(RETURN, 0);
        init.max_locals = 1;
        self.cf.add_method(0x0001, "<init>", "()V", &init);

        for s in &c.subs {
            self.gen_sub(s)?;
        }
        Ok(self.cf.to_bytes())
    }

    fn gen_sub(&mut self, s: &SubDecl) -> Result<()> {
        self.sub = s.clone();
        self.line = s.line;
        self.code = Code::new();
        self.vars.clear();
        let is_method = s.kind == Kind::Method;
        let is_ctor = s.kind == Kind::Constructor;
        let mut slot = 0;
        if is_method {
            self.this_slot = 0;
            slot = 1;
        }
        for p in &s.params {
            slot = self.declare(p, slot)?;
        }
        if is_ctor {
            self.this_slot = slot;
            slot += 1;
        }
        for v in &s.locals {
            slot = self.declare(v, slot)?;
        }
        self.code.max_locals = slot;

        let self_desc = format!("L{};", self.cls.jvm_name);
        let ret_desc = self.desc(&s.ret)?;
        if is_ctor && ret_desc != self_desc {
            return Err(self.err(format!("constructor must return {}", self.cls.name)));
        }

        if is_ctor {
            let jvm = self.cls.jvm_name.clone();
            self.code.new_obj(&mut self.cf.cp, &jvm);
            self.code.op(DUP, 1);
            self.code.invoke(&mut self.cf.cp, INVOKESPECIAL, &jvm, "<init>", "()V");
            self.code.local(ASTORE, self.this_slot, -1);
        }
        for v in &s.locals {
            let var = self.lookup(&v.name).expect("just declared");
            self.push_default(&var.desc);
            self.store_local(&var);
        }

        self.gen_statements(&s.body)?;

        // 保險用的結尾 return(讓控制流不會掉出方法尾端)
        self.line = s.line;
        if is_ctor {
            self.code.local(ALOAD, self.this_slot, 1);
            self.code.op(ARETURN, -1);
        } else if ret_desc == "V" {
            self.code.op(RETURN, 0);
        } else if ret_desc == "I" {
            self.code.push_int(&mut self.cf.cp, 0);
            self.code.op(IRETURN, -1);
        } else {
            self.code.op(ACONST_NULL, 1);
            self.code.op(ARETURN, -1);
        }

        let acc: u16 = if is_method { 0x0001 } else { 0x0009 };
        let d = self.sub_desc(s)?;
        let jvm = s.jvm_name();
        self.cf.add_method(acc, &jvm, &d, &self.code);

        // function main() -> public static void main(String[])
        if s.kind == Kind::Function && s.name == "main" && s.params.is_empty() {
            let mut br = Code::new();
            let owner = self.cls.jvm_name.clone();
            br.invoke(&mut self.cf.cp, INVOKESTATIC, &owner, "main", &d);
            if ret_desc != "V" {
                br.op(POP, -1);
            }
            br.op(RETURN, 0);
            br.max_locals = 1;
            self.cf.add_method(0x0009, "main", "([Ljava/lang/String;)V", &br);
        }
        Ok(())
    }

    fn declare(&mut self, v: &VarDecl, slot: i32) -> Result<i32> {
        if self.vars.contains_key(&v.name) {
            return Err(self.err(format!("duplicate variable '{}'", v.name)));
        }
        let d = self.desc(&v.ty)?;
        self.vars.insert(
            v.name.clone(),
            Var { name: v.name.clone(), kind: VKind::Local, ty: v.ty.clone(), desc: d, slot },
        );
        Ok(slot + 1)
    }

    // ---------- helpers ----------

    fn lookup(&self, name: &str) -> Option<Var> {
        self.vars.get(name).cloned().or_else(|| self.class_vars.get(name).cloned())
    }

    fn is_static(&self) -> bool {
        self.sub.kind == Kind::Function
    }

    fn load_this(&mut self) -> Result<()> {
        if self.is_static() {
            return Err(self.err("'this' / field access is not allowed inside a function"));
        }
        self.code.local(ALOAD, self.this_slot, 1);
        Ok(())
    }

    fn load_var(&mut self, v: &Var) -> Result<()> {
        match v.kind {
            VKind::Local => {
                let op = if v.desc == "I" { ILOAD } else { ALOAD };
                self.code.local(op, v.slot, 1);
            }
            VKind::Field => {
                self.load_this()?;
                let owner = self.cls.jvm_name.clone();
                let (n, d) = (v.name.clone(), v.desc.clone());
                self.code.field(&mut self.cf.cp, GETFIELD, &owner, &n, &d);
            }
            VKind::Static => {
                let owner = self.cls.jvm_name.clone();
                let (n, d) = (v.name.clone(), v.desc.clone());
                self.code.field(&mut self.cf.cp, GETSTATIC, &owner, &n, &d);
            }
        }
        Ok(())
    }

    fn store_local(&mut self, v: &Var) {
        let op = if v.desc == "I" { ISTORE } else { ASTORE };
        self.code.local(op, v.slot, -1);
    }

    fn push_default(&mut self, d: &str) {
        if d == "I" {
            self.code.push_int(&mut self.cf.cp, 0);
        } else {
            self.code.op(ACONST_NULL, 1);
        }
    }

    fn coerce(&mut self, from: &str, to: &str) -> Result<()> {
        if from == "V" {
            return Err(self.err("void subroutine used as a value"));
        }
        if from == to {
            return Ok(());
        }
        if from == "N" {
            if to == "I" {
                self.code.op(POP, -1);
                self.code.push_int(&mut self.cf.cp, 0);
            }
            return Ok(());
        }
        if to == "Ljava/lang/Object;" && Self::is_ref(from) {
            return Ok(());
        }
        Err(self.err(format!(
            "type mismatch: expected {} but got {}",
            Self::show(to),
            Self::show(from)
        )))
    }

    /// 產生 e 並轉成型別 to;`0` 常數可以當作 null 使用。
    fn gen_as(&mut self, e: &Expr, to: &str) -> Result<()> {
        if let Expr::IntC(0) = e {
            if Self::is_ref(to) {
                self.code.op(ACONST_NULL, 1);
                return Ok(());
            }
        }
        let from = self.gen(e)?;
        self.coerce(&from, to)
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
                    if v.desc != "[I" {
                        return Err(self.err(format!("'{}' is not an Array", v.name)));
                    }
                    self.load_var(&v)?;
                    self.gen_as(idx, "I")?;
                    self.gen_as(value, "I")?;
                    self.code.op(IASTORE, -3);
                } else {
                    match v.kind {
                        VKind::Local => {
                            let d = v.desc.clone();
                            self.gen_as(value, &d)?;
                            self.store_local(&v);
                        }
                        VKind::Field => {
                            self.load_this()?;
                            let d = v.desc.clone();
                            self.gen_as(value, &d)?;
                            let owner = self.cls.jvm_name.clone();
                            let (n, dd) = (v.name.clone(), v.desc.clone());
                            self.code.field(&mut self.cf.cp, PUTFIELD, &owner, &n, &dd);
                        }
                        VKind::Static => {
                            let d = v.desc.clone();
                            self.gen_as(value, &d)?;
                            let owner = self.cls.jvm_name.clone();
                            let (n, dd) = (v.name.clone(), v.desc.clone());
                            self.code.field(&mut self.cf.cp, PUTSTATIC, &owner, &n, &dd);
                        }
                    }
                }
            }
            Stmt::If { cond, then, els, line } => {
                self.line = *line;
                let mut l_els = Label::new();
                let mut l_end = Label::new();
                self.gen_as(cond, "I")?;
                self.code.jump(IFEQ, 1, &mut l_els);
                self.gen_statements(then)?;
                if let Some(e) = els {
                    self.code.jump(GOTO, 0, &mut l_end);
                    self.code.place(&mut l_els);
                    self.gen_statements(e)?;
                    self.code.place(&mut l_end);
                } else {
                    self.code.place(&mut l_els);
                }
            }
            Stmt::While { cond, body, line } => {
                self.line = *line;
                let mut l_top = Label::new();
                let mut l_end = Label::new();
                self.code.place(&mut l_top);
                self.gen_as(cond, "I")?;
                self.code.jump(IFEQ, 1, &mut l_end);
                self.gen_statements(body)?;
                self.code.jump(GOTO, 0, &mut l_top);
                self.code.place(&mut l_end);
            }
            Stmt::Do { call, line } => {
                self.line = *line;
                let r = self.gen_call(call)?;
                if r != "V" {
                    self.code.op(POP, -1);
                }
            }
            Stmt::Return { value, line } => {
                self.line = *line;
                let rd = self.desc(&self.sub.ret.clone())?;
                if rd == "V" {
                    if value.is_some() {
                        return Err(self.err("void subroutine cannot return a value"));
                    }
                    self.code.op(RETURN, 0);
                } else {
                    let v = value
                        .as_ref()
                        .ok_or_else(|| self.err("non-void subroutine must return a value"))?;
                    self.gen_as(v, &rd)?;
                    let op = if rd == "I" { IRETURN } else { ARETURN };
                    self.code.op(op, -1);
                }
            }
        }
        Ok(())
    }

    // ---------- expressions ----------

    /// 產生運算式,回傳其 descriptor ("I", "[I", "LFoo;", 或 null 常數的 "N")。
    fn gen(&mut self, e: &Expr) -> Result<String> {
        match e {
            Expr::IntC(v) => {
                self.code.push_int(&mut self.cf.cp, *v);
                Ok("I".to_string())
            }
            Expr::StrC(s) => {
                self.code.new_obj(&mut self.cf.cp, "jack/JString");
                self.code.op(DUP, 1);
                self.code.push_string(&mut self.cf.cp, s);
                self.code.invoke(
                    &mut self.cf.cp,
                    INVOKESPECIAL,
                    "jack/JString",
                    "<init>",
                    "(Ljava/lang/String;)V",
                );
                Ok("Ljack/JString;".to_string())
            }
            Expr::KwC(k) => match k.as_str() {
                "true" => {
                    self.code.push_int(&mut self.cf.cp, -1);
                    Ok("I".to_string())
                }
                "false" => {
                    self.code.push_int(&mut self.cf.cp, 0);
                    Ok("I".to_string())
                }
                "null" => {
                    self.code.op(ACONST_NULL, 1);
                    Ok("N".to_string())
                }
                _ => {
                    self.load_this()?;
                    Ok(format!("L{};", self.cls.jvm_name))
                }
            },
            Expr::VarE { name, line } => {
                self.line = *line;
                let v = self
                    .lookup(name)
                    .ok_or_else(|| self.err(format!("undefined variable '{name}'")))?;
                self.load_var(&v)?;
                Ok(v.desc)
            }
            Expr::IndexE { name, index, line } => {
                self.line = *line;
                let v = self
                    .lookup(name)
                    .ok_or_else(|| self.err(format!("undefined variable '{name}'")))?;
                if v.desc != "[I" {
                    return Err(self.err(format!("'{}' is not an Array", v.name)));
                }
                self.load_var(&v)?;
                self.gen_as(index, "I")?;
                self.code.op(IALOAD, -1);
                Ok("I".to_string())
            }
            Expr::Call(c) => self.gen_call(c),
            Expr::Bin { l, op, r } => self.gen_bin(l, op, r),
            Expr::Un { op, e } => {
                self.gen_as(e, "I")?;
                if op == "-" {
                    self.code.op(INEG, 0);
                } else {
                    self.code.push_int(&mut self.cf.cp, -1);
                    self.code.op(IXOR, -1);
                }
                Ok("I".to_string())
            }
        }
    }

    fn gen_bin(&mut self, l: &Expr, op: &str, r: &Expr) -> Result<String> {
        let ls = self.gen(l)?;
        let rs = if op == "=" && Self::is_ref(&ls) {
            if let Expr::IntC(0) = r {
                self.code.op(ACONST_NULL, 1);
                "N".to_string()
            } else {
                self.gen(r)?
            }
        } else {
            self.gen(r)?
        };

        match op {
            "+" => self.arith(IADD, &ls, &rs)?,
            "-" => self.arith(ISUB, &ls, &rs)?,
            "*" => self.arith(IMUL, &ls, &rs)?,
            "/" => self.arith(IDIV, &ls, &rs)?,
            "&" => self.arith(IAND, &ls, &rs)?,
            "|" => self.arith(IOR, &ls, &rs)?,
            "<" => {
                self.ints_only(&ls, &rs)?;
                self.compare(IF_ICMPLT);
            }
            ">" => {
                self.ints_only(&ls, &rs)?;
                self.compare(IF_ICMPGT);
            }
            _ => {
                // "="
                let li = ls == "I";
                let ri = rs == "I";
                if li && ri {
                    self.compare(IF_ICMPEQ);
                } else if li || ri {
                    return Err(self.err(format!(
                        "cannot compare {} with {}",
                        Self::show(&ls),
                        Self::show(&rs)
                    )));
                } else {
                    self.compare(IF_ACMPEQ);
                }
            }
        }
        Ok("I".to_string())
    }

    fn ints_only(&mut self, l: &str, r: &str) -> Result<()> {
        if l == "V" || r == "V" {
            return Err(self.err("void subroutine used as a value"));
        }
        if l != "I" || r != "I" {
            return Err(self.err(format!(
                "operator needs int operands, got {} and {}",
                Self::show(l),
                Self::show(r)
            )));
        }
        Ok(())
    }

    fn arith(&mut self, op: u8, l: &str, r: &str) -> Result<()> {
        self.ints_only(l, r)?;
        self.code.op(op, -1);
        Ok(())
    }

    /// 比較後在堆疊上放 -1(true) 或 0(false)。
    fn compare(&mut self, ifop: u8) {
        let mut t = Label::new();
        let mut end = Label::new();
        self.code.jump(ifop, 2, &mut t);
        self.code.push_int(&mut self.cf.cp, 0);
        self.code.jump(GOTO, 0, &mut end);
        self.code.place(&mut t);
        self.code.push_int(&mut self.cf.cp, -1);
        self.code.place(&mut end);
    }

    fn gen_args(&mut self, sig: &SubSig, c: &CallE) -> Result<()> {
        if sig.nparams != c.args.len() {
            return Err(self.err(format!(
                "'{}' expects {} argument(s) but got {}",
                sig.name,
                sig.nparams,
                c.args.len()
            )));
        }
        for (i, a) in c.args.iter().enumerate() {
            let d = self.desc(&sig.param_types[i])?;
            self.gen_as(a, &d)?;
        }
        Ok(())
    }

    fn gen_call(&mut self, c: &CallE) -> Result<String> {
        self.line = c.line;
        let target = match &c.target {
            None => {
                // foo(...) -> 目前類別的 method / function
                let sig = {
                    let s = find_sub(&self.cls, &c.name).ok_or_else(|| {
                        self.err(format!(
                            "undefined subroutine '{}' in class {}",
                            c.name, self.cls.name
                        ))
                    })?;
                    self.sig_of(s)?
                };
                if sig.kind == Kind::Method {
                    self.load_this()?;
                }
                self.gen_args(&sig, c)?;
                let owner = self.cls.jvm_name.clone();
                let op = if sig.kind == Kind::Method { INVOKEVIRTUAL } else { INVOKESTATIC };
                self.code.invoke(&mut self.cf.cp, op, &owner, &sig.jvm_name, &sig.desc);
                return Ok(sig.ret);
            }
            Some(t) => t.clone(),
        };

        if let Some(v) = self.lookup(&target) {
            // obj.method(...)
            let (oc_name, oc_jvm, sig) = {
                let oc = self.classes.get(&v.ty).ok_or_else(|| {
                    self.err(format!(
                        "cannot call a method on '{}' of type {}",
                        v.name, v.ty
                    ))
                })?;
                let s = find_sub(oc, &c.name).ok_or_else(|| {
                    self.err(format!("class {} has no subroutine '{}'", oc.name, c.name))
                })?;
                if s.kind != Kind::Method {
                    return Err(self.err(format!("'{}.{}' is not a method", oc.name, s.name)));
                }
                let sig = self.sig_of(s)?;
                (oc.name.clone(), oc.jvm_name.clone(), sig)
            };
            self.load_var(&v)?;
            if oc_name == "Array" {
                // Array.dispose(): int[] 由 GC 管理
                self.code.op(POP, -1);
                return Ok("V".to_string());
            }
            self.gen_args(&sig, c)?;
            self.code.invoke(&mut self.cf.cp, INVOKEVIRTUAL, &oc_jvm, &sig.jvm_name, &sig.desc);
            return Ok(sig.ret);
        }

        // Class.function(...) / Class.new(...)
        let (oc_name, oc_jvm, sig) = {
            let oc = self.classes.get(&target).ok_or_else(|| {
                self.err(format!("undefined variable or class '{target}'"))
            })?;
            let s = find_sub(oc, &c.name).ok_or_else(|| {
                self.err(format!("class {} has no subroutine '{}'", oc.name, c.name))
            })?;
            if s.kind == Kind::Method {
                return Err(self.err(format!(
                    "'{}.{}' is a method; call it on an object",
                    oc.name, s.name
                )));
            }
            let sig = self.sig_of(s)?;
            (oc.name.clone(), oc.jvm_name.clone(), sig)
        };
        if oc_name == "Array" && sig.name == "new" {
            self.gen_args(&sig, c)?;
            self.code.u1(NEWARRAY);
            self.code.u1(10); // T_INT
            return Ok("[I".to_string());
        }
        self.gen_args(&sig, c)?;
        self.code.invoke(&mut self.cf.cp, INVOKESTATIC, &oc_jvm, &sig.jvm_name, &sig.desc);
        Ok(sig.ret)
    }
}
