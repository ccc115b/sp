// parser：遞迴下降語法分析器，一邊解析一邊輸出 VM 指令。
// 它向 tokenizer 拿 token、向 symbols 查名字、向 vm 要指令字串。

use crate::symbols::{Seg, Symbols};
use crate::tokenizer::{report_errors, tokenize, Error, Kind, Token};
use crate::vm;

// subroutine 的三種種類，決定關鍵字、argument 起點與函式前言
#[derive(Clone, Copy, PartialEq)]
enum Sub {
    Function,
    Method,
    Ctor,
}

impl Sub {
    fn keyword(self) -> &'static str {
        match self {
            Sub::Function => "function",
            Sub::Method => "method",
            Sub::Ctor => "constructor",
        }
    }
}

// ---------------------------------------------------------------------- parser

// 錯誤同步的層級：class 變數、subroutine、陳述三處的安全落點不一樣
#[derive(Clone, Copy, PartialEq)]
enum Level {
    ClassVar,
    Class,
    Stmt,
}

struct Parser {
    toks: Vec<Token>,
    pos: usize,
    label_id: usize,
    current_class: String,
    errors: Vec<Error>,
    /// 本段落已經報過錯，後續錯誤先不記（避免連鎖反應）
    failed: bool,
}

impl Parser {
    fn peek(&self) -> &Kind {
        &self.toks[self.pos].kind
    }

    fn next(&mut self) -> Kind {
        let k = self.toks[self.pos].kind.clone();
        self.pos += 1;
        k
    }

    /// 在目前位置記一個錯誤（同一段落只記第一個）
    fn error(&mut self, msg: &str) {
        let line = self.toks[self.pos].line;
        let col = self.toks[self.pos].col;
        self.record(line, col, msg);
    }

    fn record(&mut self, line: usize, col: usize, msg: &str) {
        if self.failed {
            return;
        }
        self.failed = true;
        self.errors.push(Error { line, col, msg: msg.to_string() });
    }

    /// 丟棄目前段落剩下的 token，跳到下一個可重新開始的地方
    fn synchronize(&mut self, level: Level) {
        self.failed = false;
        if self.at_stop(level) {
            return;
        }
        self.pos += 1;
        while !self.at_eof() && !self.at_stop(level) {
            self.pos += 1;
        }
    }

    fn at_stop(&self, level: Level) -> bool {
        if self.at_sym('}') {
            return true;
        }
        let kws: &[&str] = match level {
            Level::ClassVar => {
                &["static", "field", "function", "method", "constructor"]
            }
            Level::Class => &["function", "method", "constructor"],
            Level::Stmt => &["let", "if", "while", "do", "return"],
        };
        kws.iter().any(|k| self.at_kw(k))
    }

    fn at_sym(&self, c: char) -> bool {
        matches!(self.peek(), Kind::Sym(s) if *s == c)
    }

    fn at_kw(&self, s: &str) -> bool {
        matches!(self.peek(), Kind::Kw(k) if k == s)
    }

    fn at_eof(&self) -> bool {
        matches!(self.peek(), Kind::Eof)
    }

    fn accept_sym(&mut self, c: char) -> bool {
        if self.at_sym(c) {
            self.pos += 1;
            true
        } else {
            false
        }
    }

    fn expect_sym(&mut self, c: char) {
        if !self.accept_sym(c) {
            let d = self.describe();
            self.error(&format!("預期 '{}' 但遇到 {}", c, d));
        }
    }

    fn accept_kw(&mut self, s: &str) -> bool {
        if self.at_kw(s) {
            self.pos += 1;
            true
        } else {
            false
        }
    }

    fn expect_kw(&mut self, s: &str) {
        if !self.accept_kw(s) {
            let d = self.describe();
            self.error(&format!("預期關鍵字 '{}' 但遇到 {}", s, d));
        }
    }

    fn expect_id(&mut self) -> String {
        let start = self.pos;
        match self.next() {
            Kind::Id(name) => name,
            _ => {
                let tok = &self.toks[start];
                let (line, col, desc) = (tok.line, tok.col, tok.kind.describe());
                self.record(line, col, &format!("預期識別字但遇到 {}", desc));
                String::new()
            }
        }
    }

    fn describe(&self) -> String {
        self.peek().describe()
    }

    /// 在指定的 token 位置記一個錯誤（用來指向已被取走的識別字）
    fn record_at(&mut self, start: usize, msg: &str) {
        let line = self.toks[start].line;
        let col = self.toks[start].col;
        self.record(line, col, msg);
    }

    // type := 'void' | 'int' | 'boolean' | 'char' | identifier
    fn parse_type(&mut self) -> String {
        let start = self.pos;
        match self.next() {
            Kind::Kw(k) if k == "void" || k == "int" || k == "boolean" || k == "char" => k,
            Kind::Id(name) => name,
            _ => {
                let tok = &self.toks[start];
                let (line, col, desc) = (tok.line, tok.col, tok.kind.describe());
                self.record(line, col, &format!("預期型別但遇到 {}", desc));
                String::new()
            }
        }
    }

    // class := 'class' identifier '{' classVarDec* subroutineDec* '}'
    fn parse_class(&mut self) -> String {
        self.expect_kw("class");
        let name = self.expect_id();
        self.current_class = name.clone();
        self.expect_sym('{');
        let mut sym = Symbols::new_class();
        self.parse_class_var_decls(&mut sym);
        let mut out = String::new();
        loop {
            if self.failed {
                self.synchronize(Level::Class);
            }
            if self.at_sym('}') || self.at_eof() {
                break;
            }
            if self.at_kw("function") {
                out += &self.parse_function(&name, &mut sym, Sub::Function);
            } else if self.at_kw("method") {
                out += &self.parse_function(&name, &mut sym, Sub::Method);
            } else if self.at_kw("constructor") {
                out += &self.parse_function(&name, &mut sym, Sub::Ctor);
            } else if self.at_kw("static") || self.at_kw("field") {
                self.error("class 變數（static/field）必須宣告在 subroutine 之前");
            } else {
                let d = self.describe();
                self.error(&format!(
                    "預期 subroutine（function/method/constructor）但遇到 {}",
                    d
                ));
            }
        }
        self.expect_sym('}');
        out
    }

    // classVarDec := ('static' | 'field') type id { ',' id } ';'
    fn parse_class_var_decls(&mut self, sym: &mut Symbols) {
        loop {
            if self.failed {
                self.synchronize(Level::ClassVar);
            }
            let seg = if self.at_kw("static") {
                self.expect_kw("static");
                Seg::Static
            } else if self.at_kw("field") {
                self.expect_kw("field");
                Seg::Field
            } else {
                break;
            };
            let typ = self.parse_type();
            loop {
                if self.failed {
                    break;
                }
                let vname = self.expect_id();
                if let Err(m) = sym.declare(&vname, seg, &typ) {
                    self.error(&m);
                }
                if !self.accept_sym(',') {
                    break;
                }
            }
            self.expect_sym(';');
        }
    }

    // ('function' | 'method' | 'constructor') type id '(' params ')' '{' var* stmts '}'
    fn parse_function(&mut self, class: &str, sym: &mut Symbols, sub: Sub) -> String {
        self.expect_kw(sub.keyword());
        self.parse_type();
        let name = self.expect_id();
        sym.begin_fn(sub == Sub::Method);
        self.parse_params(sym);
        self.expect_sym('{');
        self.parse_var_decls(sym);
        self.label_id = 0;
        let mut out = vm::function(&format!("{}.{}", class, name), sym.n_locals);
        match sub {
            Sub::Function => {}
            Sub::Method => {
                out.push_str(&vm::push(Seg::Arg, 0));
                out.push_str(&vm::pop_pointer(0));
            }
            Sub::Ctor => {
                out.push_str(&vm::push_const(sym.n_fields as i64));
                out.push_str(&vm::call("Memory.alloc", 1));
                out.push_str(&vm::pop_pointer(0));
            }
        }
        self.parse_statements(sym, &mut out);
        self.expect_sym('}');
        out
    }

    // params := [ type id { ',' type id } ]
    fn parse_params(&mut self, sym: &mut Symbols) {
        self.expect_sym('(');
        if !self.at_sym(')') {
            loop {
                if self.failed {
                    break;
                }
                let typ = self.parse_type();
                let pname = self.expect_id();
                if let Err(m) = sym.declare(&pname, Seg::Arg, &typ) {
                    self.error(&m);
                }
                if !self.accept_sym(',') {
                    break;
                }
            }
        }
        self.expect_sym(')');
    }

    // var := 'var' type id { ',' id } ';'
    fn parse_var_decls(&mut self, sym: &mut Symbols) {
        while self.at_kw("var") && !self.failed {
            self.expect_kw("var");
            let typ = self.parse_type();
            loop {
                if self.failed {
                    break;
                }
                let vname = self.expect_id();
                if let Err(m) = sym.declare(&vname, Seg::Local, &typ) {
                    self.error(&m);
                }
                if !self.accept_sym(',') {
                    break;
                }
            }
            self.expect_sym(';');
        }
    }

    // stmts := ( let | if | while | do | return )*
    fn parse_statements(&mut self, sym: &Symbols, out: &mut String) {
        loop {
            if self.failed {
                self.synchronize(Level::Stmt);
            }
            if self.at_sym('}') || self.at_eof() {
                break;
            }
            if self.at_kw("let") {
                self.parse_let(sym, out);
            } else if self.at_kw("if") {
                self.parse_if(sym, out);
            } else if self.at_kw("while") {
                self.parse_while(sym, out);
            } else if self.at_kw("do") {
                self.parse_do(sym, out);
            } else if self.at_kw("return") {
                self.parse_return(sym, out);
            } else if self.at_kw("var") {
                self.error("var 宣告必須寫在所有陳述之前");
            } else {
                let d = self.describe();
                self.error(&format!("預期陳述（let/if/while/do/return）但遇到 {}", d));
            }
        }
    }

    // do := 'do' subroutineCall ';'
    fn parse_do(&mut self, sym: &Symbols, out: &mut String) {
        self.expect_kw("do");
        let name = self.expect_id();
        if self.failed {
            return;
        }
        if !self.at_sym('(') && !self.at_sym('.') {
            self.error("do 後面必須是 subroutineCall：name(...) 或 name.sub(...)");
            return;
        }
        self.parse_call(sym, out, &name);
        self.expect_sym(';');
        out.push_str(&vm::pop_temp(0));
    }

    // subroutineCall 的核心。name 已取走，目前位置在 '(' 或 '.'
    fn parse_call(&mut self, sym: &Symbols, out: &mut String, name: &str) {
        let callee;
        let extra;
        if self.accept_sym('.') {
            let sub = self.expect_id();
            match sym.lookup(name) {
                // name 是變數：先推物件，this 參數 +1，以變數型別當類別
                Some((seg, idx, typ)) => {
                    out.push_str(&vm::push(seg, idx));
                    callee = format!("{}.{}", typ, sub);
                    extra = 1;
                }
                // name 是類別名：靜態 / 構構函式，沒有隱藏的 this
                None => {
                    callee = format!("{}.{}", name, sub);
                    extra = 0;
                }
            }
        } else {
            // 裸呼叫 name(...) 在 Jack 裡一律視為 this.name(...)
            out.push_str(&vm::push_pointer(0));
            callee = format!("{}.{}", self.current_class, name);
            extra = 1;
        }
        let n = self.parse_args(sym, out) + extra;
        out.push_str(&vm::call(&callee, n));
    }

    // '(' [ expression { ',' expression } ] ')'
    fn parse_args(&mut self, sym: &Symbols, out: &mut String) -> usize {
        self.expect_sym('(');
        let mut n = 0;
        if !self.at_sym(')') {
            loop {
                if self.failed {
                    break;
                }
                self.parse_expr(sym, out);
                n += 1;
                if !self.accept_sym(',') {
                    break;
                }
            }
        }
        self.expect_sym(')');
        n
    }

    // if := 'if' '(' expression ')' '{' stmts '}' [ 'else' '{' stmts '}' ]
    fn parse_if(&mut self, sym: &Symbols, out: &mut String) {
        self.expect_kw("if");
        let id = self.label_id;
        self.label_id += 1;
        self.expect_sym('(');
        self.parse_expr(sym, out);
        self.expect_sym(')');
        if self.failed {
            return;
        }
        out.push_str(&vm::if_goto(&format!("IF_TRUE{}", id)));
        out.push_str(&vm::goto(&format!("IF_FALSE{}", id)));
        out.push_str(&vm::label(&format!("IF_TRUE{}", id)));
        self.expect_sym('{');
        self.parse_statements(sym, out);
        self.expect_sym('}');
        if self.accept_kw("else") {
            out.push_str(&vm::goto(&format!("IF_END{}", id)));
            out.push_str(&vm::label(&format!("IF_FALSE{}", id)));
            self.expect_sym('{');
            self.parse_statements(sym, out);
            self.expect_sym('}');
            out.push_str(&vm::label(&format!("IF_END{}", id)));
        } else {
            out.push_str(&vm::label(&format!("IF_FALSE{}", id)));
        }
    }

    // while := 'while' '(' expression ')' '{' stmts '}'
    fn parse_while(&mut self, sym: &Symbols, out: &mut String) {
        self.expect_kw("while");
        let id = self.label_id;
        self.label_id += 1;
        out.push_str(&vm::label(&format!("WHILE_EXP{}", id)));
        self.expect_sym('(');
        self.parse_expr(sym, out);
        self.expect_sym(')');
        if self.failed {
            return;
        }
        out.push_str(&vm::arith("not"));
        out.push_str(&vm::if_goto(&format!("WHILE_END{}", id)));
        self.expect_sym('{');
        self.parse_statements(sym, out);
        self.expect_sym('}');
        out.push_str(&vm::goto(&format!("WHILE_EXP{}", id)));
        out.push_str(&vm::label(&format!("WHILE_END{}", id)));
    }

    // let := 'let' name [ '[' expression ']' ] '=' expression ';'
    fn parse_let(&mut self, sym: &Symbols, out: &mut String) {
        self.expect_kw("let");
        let start = self.pos;
        let name = self.expect_id();
        let found = sym.lookup(&name);
        if self.accept_sym('[') {
            let (seg, idx) = match found {
                None => {
                    self.record_at(start, &format!("變數 {} 未宣告", name));
                    (Seg::Local, 0)
                }
                Some((seg, idx, _)) => (seg, idx),
            };
            if self.failed {
                return;
            }
            out.push_str(&vm::push(seg, idx));
            self.parse_expr(sym, out);
            self.expect_sym(']');
            out.push_str(&vm::arith("add"));
            self.expect_sym('=');
            self.parse_expr(sym, out);
            out.push_str(&vm::pop_temp(0));
            out.push_str(&vm::pop_pointer(1));
            out.push_str(&vm::push_temp(0));
            out.push_str(&vm::pop_that(0));
            self.expect_sym(';');
        } else {
            match found {
                None => self.record_at(start, &format!("變數 {} 未宣告", name)),
                Some((Seg::Arg, _, _)) => {
                    self.record_at(start, &format!("參數 {} 不可被賦值", name))
                }
                Some((seg, idx, _)) => {
                    self.expect_sym('=');
                    self.parse_expr(sym, out);
                    self.expect_sym(';');
                    out.push_str(&vm::pop(seg, idx));
                }
            }
        }
    }

    // return := 'return' [ expression ] ';'
    fn parse_return(&mut self, sym: &Symbols, out: &mut String) {
        self.expect_kw("return");
        if self.at_sym(';') {
            out.push_str(&vm::push_const(0));
        } else {
            self.parse_expr(sym, out);
        }
        self.expect_sym(';');
        out.push_str(&vm::ret());
    }

    // expression := term { binaryOp term }   （由左至右，無優先權）
    fn parse_expr(&mut self, sym: &Symbols, out: &mut String) {
        self.parse_term(sym, out);
        loop {
            if self.failed {
                break;
            }
            let op = match self.peek() {
                Kind::Sym('+') => '+',
                Kind::Sym('-') => '-',
                Kind::Sym('*') => '*',
                Kind::Sym('/') => '/',
                Kind::Sym('&') => '&',
                Kind::Sym('|') => '|',
                Kind::Sym('<') => '<',
                Kind::Sym('>') => '>',
                Kind::Sym('=') => '=',
                _ => break,
            };
            self.pos += 1;
            self.parse_term(sym, out);
            out.push_str(&vm::arith(match op {
                '+' => "add",
                '-' => "sub",
                '*' => "mul",
                '/' => "div",
                '&' => "and",
                '|' => "or",
                '<' => "lt",
                '>' => "gt",
                _ => "eq",
            }));
        }
    }

    // term := integer | string | keywordConstant | '-' term | '~' term
    //       | '(' expression ')' | identifier [ '(' | '.' subroutine ]
    fn parse_term(&mut self, sym: &Symbols, out: &mut String) {
        let start = self.pos;
        match self.next() {
            Kind::Int(n) => out.push_str(&vm::push_const(n)),
            Kind::Str(s) => out.push_str(&vm::string(&s)),
            Kind::Kw(k) if k == "true" => {
                out.push_str(&vm::push_const(0));
                out.push_str(&vm::arith("not"));
            }
            Kind::Kw(k) if k == "false" || k == "null" => out.push_str(&vm::push_const(0)),
            Kind::Kw(k) if k == "this" => out.push_str(&vm::push_pointer(0)),
            Kind::Sym('-') => {
                self.parse_term(sym, out);
                out.push_str(&vm::arith("neg"));
            }
            Kind::Sym('~') => {
                self.parse_term(sym, out);
                out.push_str(&vm::arith("not"));
            }
            Kind::Sym('(') => {
                self.parse_expr(sym, out);
                self.expect_sym(')');
            }
            Kind::Id(name) => {
                if self.at_sym('(') || self.at_sym('.') {
                    self.parse_call(sym, out, &name);
                } else if self.at_sym('[') {
                    // a[i]：先推陣列基底、再推索引、相加得到位址
                    match sym.lookup(&name) {
                        Some((seg, idx, _)) => {
                            out.push_str(&vm::push(seg, idx))
                        }
                        None => self.record_at(start, &format!("變數 {} 未宣告", name)),
                    }
                    if self.failed {
                        return;
                    }
                    self.expect_sym('[');
                    self.parse_expr(sym, out);
                    self.expect_sym(']');
                    out.push_str(&vm::arith("add"));
                    out.push_str(&vm::pop_pointer(1));
                    out.push_str(&vm::push_that(0));
                } else {
                    match sym.lookup(&name) {
                        Some((seg, idx, _)) => {
                            out.push_str(&vm::push(seg, idx))
                        }
                        None => self.record_at(start, &format!("變數 {} 未宣告", name)),
                    }
                }
            }
            _ => {
                let desc = self.toks[start].kind.describe();
                self.record_at(start, &format!("預期算式但遇到 {}", desc));
            }
        }
    }
}

/// 把一份 Jack 原始碼編成 VM 碼；有錯誤時印出報告並回傳 None（不輸出 .vm）
pub fn compile(file: &str, src: &str) -> Option<String> {
    let source: Vec<String> = src.lines().map(|s| s.to_string()).collect();
    let (toks, lex_errs) = tokenize(src);
    let mut parser = Parser {
        toks,
        pos: 0,
        label_id: 0,
        current_class: String::new(),
        errors: lex_errs,
        failed: false,
    };
    let vm = parser.parse_class();
    if !parser.at_eof() {
        let (line, col, desc) = {
            let t = &parser.toks[parser.pos];
            (t.line, t.col, t.kind.describe())
        };
        parser.errors.push(Error { line, col, msg: format!("class 之後有多餘的內容: {}", desc) });
    }
    if parser.errors.is_empty() {
        return Some(vm);
    }
    parser.errors.sort_by_key(|e| (e.line, e.col));
    report_errors(file, &source, &parser.errors);
    None
}
