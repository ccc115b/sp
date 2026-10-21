use crate::ast::{CallE, ClassDecl, Expr, Kind, Stmt, SubDecl, VarDecl};
use crate::error::{CompileError, Result};
use crate::lexer::{Token, TT};

pub struct Parser<'a> {
    file: &'a str,
    t: Vec<Token>,
    p: usize,
}

impl<'a> Parser<'a> {
    pub fn new(file: &'a str, t: Vec<Token>) -> Self {
        Parser { file, t, p: 0 }
    }

    fn peek(&self) -> &Token {
        &self.t[self.p]
    }
    fn is_sym(&self, s: &str) -> bool {
        self.peek().is_sym(s)
    }
    fn is_kw(&self, s: &str) -> bool {
        self.peek().is_kw(s)
    }
    fn accept_sym(&mut self, s: &str) -> bool {
        if self.is_sym(s) {
            self.p += 1;
            true
        } else {
            false
        }
    }
    fn expect_sym(&mut self, s: &str) -> Result<()> {
        if self.accept_sym(s) {
            Ok(())
        } else {
            Err(self.err(&format!("expected '{s}'")))
        }
    }
    fn expect_kw(&mut self, s: &str) -> Result<()> {
        if self.is_kw(s) {
            self.p += 1;
            Ok(())
        } else {
            Err(self.err(&format!("expected '{s}'")))
        }
    }
    fn ident(&mut self) -> Result<String> {
        let k = self.peek().clone();
        if k.tt != TT::Ident {
            return Err(self.err("expected identifier"));
        }
        self.p += 1;
        Ok(k.text)
    }
    fn err(&self, m: &str) -> CompileError {
        let k = self.peek();
        CompileError::new(self.file, k.line, format!("{m} but found '{}'", k.text))
    }

    pub fn parse_file(&mut self) -> Result<Vec<ClassDecl>> {
        let mut list = Vec::new();
        while self.peek().tt != TT::Eof {
            list.push(self.parse_class()?);
        }
        Ok(list)
    }

    fn parse_type(&mut self, allow_void: bool) -> Result<String> {
        let k = self.peek().clone();
        if k.tt == TT::Keyword
            && (k.text == "int"
                || k.text == "char"
                || k.text == "boolean"
                || (allow_void && k.text == "void"))
        {
            self.p += 1;
            return Ok(k.text);
        }
        if k.tt == TT::Ident {
            self.p += 1;
            return Ok(k.text);
        }
        Err(self.err("expected type"))
    }

    fn parse_class(&mut self) -> Result<ClassDecl> {
        let mut c = ClassDecl { file: self.file.to_string(), ..Default::default() };
        self.expect_kw("class")?;
        c.name = self.ident()?;
        self.expect_sym("{")?;
        while self.is_kw("static") || self.is_kw("field") {
            let st = self.peek().text == "static";
            self.p += 1;
            let ty = self.parse_type(false)?;
            loop {
                let name = self.ident()?;
                let v = VarDecl { name, ty: ty.clone() };
                if st {
                    c.statics.push(v);
                } else {
                    c.fields.push(v);
                }
                if !self.accept_sym(",") {
                    break;
                }
            }
            self.expect_sym(";")?;
        }
        while self.is_kw("constructor") || self.is_kw("function") || self.is_kw("method") {
            c.subs.push(self.parse_sub()?);
        }
        self.expect_sym("}")?;
        Ok(c)
    }

    fn parse_sub(&mut self) -> Result<SubDecl> {
        let mut s = SubDecl { line: self.peek().line, ..Default::default() };
        let kw = self.t[self.p].text.clone();
        self.p += 1;
        s.kind = match kw.as_str() {
            "constructor" => Kind::Constructor,
            "function" => Kind::Function,
            _ => Kind::Method,
        };
        s.ret = self.parse_type(true)?;
        s.name = self.ident()?;
        self.expect_sym("(")?;
        if !self.is_sym(")") {
            loop {
                let ty = self.parse_type(false)?;
                let name = self.ident()?;
                s.params.push(VarDecl { name, ty });
                if !self.accept_sym(",") {
                    break;
                }
            }
        }
        self.expect_sym(")")?;
        self.expect_sym("{")?;
        while self.is_kw("var") {
            self.p += 1;
            let ty = self.parse_type(false)?;
            loop {
                let name = self.ident()?;
                s.locals.push(VarDecl { name, ty: ty.clone() });
                if !self.accept_sym(",") {
                    break;
                }
            }
            self.expect_sym(";")?;
        }
        s.body = self.parse_statements()?;
        self.expect_sym("}")?;
        Ok(s)
    }

    fn parse_statements(&mut self) -> Result<Vec<Stmt>> {
        let mut list = Vec::new();
        while self.is_kw("let") || self.is_kw("if") || self.is_kw("while") || self.is_kw("do")
            || self.is_kw("return")
        {
            list.push(self.parse_statement()?);
        }
        Ok(list)
    }

    fn parse_block(&mut self) -> Result<Vec<Stmt>> {
        self.expect_sym("{")?;
        let b = self.parse_statements()?;
        self.expect_sym("}")?;
        Ok(b)
    }

    fn parse_statement(&mut self) -> Result<Stmt> {
        let ln = self.peek().line;
        if self.is_kw("let") {
            self.p += 1;
            let name = self.ident()?;
            let index = if self.accept_sym("[") {
                let e = self.parse_expr()?;
                self.expect_sym("]")?;
                Some(Box::new(e))
            } else {
                None
            };
            self.expect_sym("=")?;
            let value = Box::new(self.parse_expr()?);
            self.expect_sym(";")?;
            return Ok(Stmt::Let { name, index, value, line: ln });
        }
        if self.is_kw("if") {
            self.p += 1;
            self.expect_sym("(")?;
            let cond = Box::new(self.parse_expr()?);
            self.expect_sym(")")?;
            let then = self.parse_block()?;
            let els = if self.is_kw("else") {
                self.p += 1;
                Some(self.parse_block()?)
            } else {
                None
            };
            return Ok(Stmt::If { cond, then, els, line: ln });
        }
        if self.is_kw("while") {
            self.p += 1;
            self.expect_sym("(")?;
            let cond = Box::new(self.parse_expr()?);
            self.expect_sym(")")?;
            let body = self.parse_block()?;
            return Ok(Stmt::While { cond, body, line: ln });
        }
        if self.is_kw("do") {
            self.p += 1;
            let first = self.ident()?;
            let call = self.parse_call_rest(first, ln)?;
            self.expect_sym(";")?;
            return Ok(Stmt::Do { call, line: ln });
        }
        if self.is_kw("return") {
            self.p += 1;
            let value = if self.is_sym(";") {
                None
            } else {
                Some(Box::new(self.parse_expr()?))
            };
            self.expect_sym(";")?;
            return Ok(Stmt::Return { value, line: ln });
        }
        Err(self.err("expected statement"))
    }

    /// 已經讀過第一個識別字 first;接下來是 `.name(args)` 或 `(args)`。
    fn parse_call_rest(&mut self, first: String, ln: usize) -> Result<CallE> {
        let mut target = None;
        let mut name = first;
        if self.accept_sym(".") {
            target = Some(name);
            name = self.ident()?;
        }
        self.expect_sym("(")?;
        let mut args = Vec::new();
        if !self.is_sym(")") {
            loop {
                args.push(self.parse_expr()?);
                if !self.accept_sym(",") {
                    break;
                }
            }
        }
        self.expect_sym(")")?;
        Ok(CallE { target, name, args, line: ln })
    }

    fn is_op(&self) -> bool {
        let k = self.peek();
        k.tt == TT::Symbol && "+-*/&|<>=".contains(k.text.as_str())
    }

    /// Jack 沒有運算子優先順序,一律由左至右。
    fn parse_expr(&mut self) -> Result<Expr> {
        let mut l = self.parse_term()?;
        while self.is_op() {
            let op = self.t[self.p].text.clone();
            self.p += 1;
            let r = self.parse_term()?;
            l = Expr::Bin { l: Box::new(l), op, r: Box::new(r) };
        }
        Ok(l)
    }

    fn parse_term(&mut self) -> Result<Expr> {
        let k = self.peek().clone();
        let ln = k.line;
        match k.tt {
            TT::Int => {
                self.p += 1;
                let v: i64 = k
                    .text
                    .parse()
                    .map_err(|_| CompileError::new(self.file, ln, "integer constant too large"))?;
                if v > i32::MAX as i64 {
                    return Err(CompileError::new(self.file, ln, "integer constant too large"));
                }
                Ok(Expr::IntC(v as i32))
            }
            TT::Str => {
                self.p += 1;
                Ok(Expr::StrC(k.text))
            }
            TT::Keyword => {
                if k.text == "true" || k.text == "false" || k.text == "null" || k.text == "this" {
                    self.p += 1;
                    return Ok(Expr::KwC(k.text));
                }
                Err(self.err("expected expression"))
            }
            TT::Ident => {
                self.p += 1;
                if self.is_sym("[") {
                    self.p += 1;
                    let index = self.parse_expr()?;
                    self.expect_sym("]")?;
                    return Ok(Expr::IndexE { name: k.text, index: Box::new(index), line: ln });
                }
                if self.is_sym("(") || self.is_sym(".") {
                    return Ok(Expr::Call(self.parse_call_rest(k.text, ln)?));
                }
                Ok(Expr::VarE { name: k.text, line: ln })
            }
            TT::Symbol => {
                if k.text == "(" {
                    self.p += 1;
                    let e = self.parse_expr()?;
                    self.expect_sym(")")?;
                    return Ok(e);
                }
                if k.text == "-" || k.text == "~" {
                    self.p += 1;
                    let e = self.parse_term()?;
                    return Ok(Expr::Un { op: k.text, e: Box::new(e) });
                }
                Err(self.err("expected expression"))
            }
            TT::Eof => Err(self.err("expected expression")),
        }
    }
}
