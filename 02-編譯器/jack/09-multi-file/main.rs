// 09-multi-file：編譯整個資料夾（多檔專案）
// 相對 08 新增：
//   jackc <dir>            → 把 dir 底下每個 .jack 編成同名 .vm（放回原處）
//   jackc <dir> <outdir>   → .vm 全部放到 outdir
//   錯誤訊息加上檔名前綴：Shape.jack:12: ...
// 交叉呼叫（Shape 呼叫 Point）不需要任何特別處理：
// 查不到名字就當類別名，型別欄位則用來組出 callee。
use std::collections::HashMap;
use std::env;
use std::fs;
use std::path::{Path, PathBuf};
use std::process::exit;

const KEYWORDS: &[&str] = &[
    "class", "constructor", "function", "method", "field", "static", "var",
    "int", "char", "boolean", "void", "true", "false", "null", "this",
    "let", "do", "if", "else", "while", "return",
];

const SYMBOLS: &[char] = &[
    '{', '}', '(', ')', '[', ']', '.', ',', ';', '+', '-', '*', '/', '&',
    '|', '<', '>', '=', '~',
];

#[derive(Clone)]
enum Kind {
    Kw(String),
    Id(String),
    Int(i64),
    Str(String),
    Sym(char),
    Eof,
}

struct Token {
    kind: Kind,
    line: usize,
}

fn tokenize(src: &str, file: &str) -> Vec<Token> {
    let b: Vec<char> = src.chars().collect();
    let mut toks = Vec::new();
    let mut i = 0;
    let mut line = 1;
    while i < b.len() {
        let c = b[i];
        if c == '\n' {
            line += 1;
            i += 1;
            continue;
        }
        if c.is_whitespace() {
            i += 1;
            continue;
        }
        if c == '/' && i + 1 < b.len() && b[i + 1] == '/' {
            while i < b.len() && b[i] != '\n' {
                i += 1;
            }
            continue;
        }
        if c == '/' && i + 1 < b.len() && b[i + 1] == '*' {
            i += 2;
            while i + 1 < b.len() && !(b[i] == '*' && b[i + 1] == '/') {
                if b[i] == '\n' {
                    line += 1;
                }
                i += 1;
            }
            i += 2;
            continue;
        }
        if c.is_ascii_digit() {
            let start = i;
            while i < b.len() && b[i].is_ascii_digit() {
                i += 1;
            }
            let text: String = b[start..i].iter().collect();
            let n = text.parse().unwrap_or_else(|_| {
                eprintln!("{}:{}: 整數常數過大: {}", file, line, text);
                exit(1);
            });
            toks.push(Token { kind: Kind::Int(n), line });
            continue;
        }
        if c == '"' {
            i += 1;
            let mut s = String::new();
            while i < b.len() && b[i] != '"' {
                if b[i] == '\n' {
                    line += 1;
                }
                s.push(b[i]);
                i += 1;
            }
            i += 1;
            toks.push(Token { kind: Kind::Str(s), line });
            continue;
        }
        if c.is_alphabetic() || c == '_' {
            let start = i;
            while i < b.len() && (b[i].is_alphanumeric() || b[i] == '_') {
                i += 1;
            }
            let word: String = b[start..i].iter().collect();
            let kind = if KEYWORDS.contains(&word.as_str()) {
                Kind::Kw(word)
            } else {
                Kind::Id(word)
            };
            toks.push(Token { kind, line });
            continue;
        }
        if SYMBOLS.contains(&c) {
            toks.push(Token { kind: Kind::Sym(c), line });
            i += 1;
            continue;
        }
        eprintln!("{}:{}: 無法辨識的字元 '{}'", file, line, c);
        exit(1);
    }
    toks.push(Token { kind: Kind::Eof, line });
    toks
}

// ---------------------------------------------------------------- symbol table

#[derive(Clone, Copy, PartialEq)]
enum Seg {
    Static,
    Field,
    Arg,
    Local,
}

impl Seg {
    fn vm(self) -> &'static str {
        match self {
            Seg::Static => "static",
            Seg::Field => "this",
            Seg::Arg => "argument",
            Seg::Local => "local",
        }
    }
}

struct Symbols {
    class_map: HashMap<String, (Seg, usize, String)>,
    fn_map: HashMap<String, (Seg, usize, String)>,
    n_statics: usize,
    n_fields: usize,
    n_args: usize,
    n_locals: usize,
}

impl Symbols {
    fn new_class() -> Symbols {
        Symbols {
            class_map: HashMap::new(),
            fn_map: HashMap::new(),
            n_statics: 0,
            n_fields: 0,
            n_args: 0,
            n_locals: 0,
        }
    }

    // 每個 subroutine 開始時清空 function 層；method 預留 argument 0 給 this
    fn begin_fn(&mut self, is_method: bool) {
        self.fn_map.clear();
        self.n_args = if is_method { 1 } else { 0 };
        self.n_locals = 0;
    }

    fn declare(&mut self, name: &str, seg: Seg, typ: &str) -> Result<usize, String> {
        let (map, counter) = match seg {
            Seg::Static => (&mut self.class_map, &mut self.n_statics),
            Seg::Field => (&mut self.class_map, &mut self.n_fields),
            Seg::Arg => (&mut self.fn_map, &mut self.n_args),
            Seg::Local => (&mut self.fn_map, &mut self.n_locals),
        };
        if map.contains_key(name) {
            return Err(format!("變數 {} 重複宣告", name));
        }
        let idx = *counter;
        *counter += 1;
        map.insert(name.to_string(), (seg, idx, typ.to_string()));
        Ok(idx)
    }

    // function 層優先（可遮蔽 class 層）
    fn lookup(&self, name: &str) -> Option<(Seg, usize, String)> {
        self.fn_map.get(name).or_else(|| self.class_map.get(name)).cloned()
    }
}

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

struct Parser {
    toks: Vec<Token>,
    pos: usize,
    label_id: usize,
    current_class: String,
    file: String,
}

impl Parser {
    fn peek(&self) -> &Kind {
        &self.toks[self.pos].kind
    }

    fn line(&self) -> usize {
        self.toks[self.pos].line
    }

    fn next(&mut self) -> Kind {
        let k = self.toks[self.pos].kind.clone();
        self.pos += 1;
        k
    }

    fn die<T>(&self, msg: &str) -> T {
        eprintln!("{}:{}: {}", self.file, self.line(), msg);
        exit(1);
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
            self.die::<()>(&format!("預期 '{}' 但遇到 {}", c, d));
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
            self.die::<()>(&format!("預期關鍵字 '{}' 但遇到 {}", s, d));
        }
    }

    fn expect_id(&mut self) -> String {
        match self.next() {
            Kind::Id(name) => name,
            _ => self.die("預期識別字"),
        }
    }

    fn describe(&self) -> String {
        match self.peek() {
            Kind::Kw(k) => format!("keyword {}", k),
            Kind::Id(s) => format!("identifier {}", s),
            Kind::Int(n) => format!("integer {}", n),
            Kind::Str(s) => format!("string \"{}\"", s),
            Kind::Sym(c) => format!("'{}'", c),
            Kind::Eof => "檔案結尾".to_string(),
        }
    }

    // type := 'void' | 'int' | 'boolean' | 'char' | identifier
    fn parse_type(&mut self) -> String {
        match self.next() {
            Kind::Kw(k) if k == "void" || k == "int" || k == "boolean" || k == "char" => k,
            Kind::Id(name) => name,
            _ => self.die("預期型別"),
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
        while !self.at_sym('}') {
            if self.at_kw("function") {
                out += &self.parse_function(&name, &mut sym, Sub::Function);
            } else if self.at_kw("method") {
                out += &self.parse_function(&name, &mut sym, Sub::Method);
            } else if self.at_kw("constructor") {
                out += &self.parse_function(&name, &mut sym, Sub::Ctor);
            } else if self.at_kw("static") || self.at_kw("field") {
                self.die::<()>("class 變數（static/field）必須宣告在 subroutine 之前");
            } else {
                let d = self.describe();
                self.die::<()>(&format!(
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
                let vname = self.expect_id();
                let res = sym.declare(&vname, seg, &typ);
                if let Err(m) = res {
                    self.die::<()>(&m);
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
        let mut out = format!("function {}.{} {}\n", class, name, sym.n_locals);
        match sub {
            Sub::Function => {}
            Sub::Method => out.push_str("push argument 0\npop pointer 0\n"),
            Sub::Ctor => {
                out.push_str(&format!("push constant {}\n", sym.n_fields));
                out.push_str("call Memory.alloc 1\npop pointer 0\n");
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
                let typ = self.parse_type();
                let pname = self.expect_id();
                let res = sym.declare(&pname, Seg::Arg, &typ);
                if let Err(m) = res {
                    self.die::<()>(&m);
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
        while self.at_kw("var") {
            self.expect_kw("var");
            let typ = self.parse_type();
            loop {
                let vname = self.expect_id();
                let res = sym.declare(&vname, Seg::Local, &typ);
                if let Err(m) = res {
                    self.die::<()>(&m);
                }
                if !self.accept_sym(',') {
                    break;
                }
            }
            self.expect_sym(';');
        }
    }

    // stmts := ( let | if | while | return )*
    fn parse_statements(&mut self, sym: &Symbols, out: &mut String) {
        while !self.at_sym('}') {
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
            } else {
                let d = self.describe();
                self.die::<()>(&format!(
                    "此版本只支援 let / if / while / do / return 指述，但遇到 {}",
                    d
                ));
            }
        }
    }

    // do := 'do' subroutineCall ';'
    fn parse_do(&mut self, sym: &Symbols, out: &mut String) {
        self.expect_kw("do");
        let name = self.expect_id();
        if !self.at_sym('(') && !self.at_sym('.') {
            self.die::<()>("do 後面必須是 subroutineCall：name(...) 或 name.sub(...)");
        }
        self.parse_call(sym, out, &name);
        self.expect_sym(';');
        out.push_str("pop temp 0\n");
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
                    out.push_str(&format!("push {} {}\n", seg.vm(), idx));
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
            out.push_str("push pointer 0\n");
            callee = format!("{}.{}", self.current_class, name);
            extra = 1;
        }
        let n = self.parse_args(sym, out) + extra;
        out.push_str(&format!("call {} {}\n", callee, n));
    }

    // '(' [ expression { ',' expression } ] ')'
    fn parse_args(&mut self, sym: &Symbols, out: &mut String) -> usize {
        self.expect_sym('(');
        let mut n = 0;
        if !self.at_sym(')') {
            loop {
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
        out.push_str(&format!("if-goto IF_TRUE{}\n", id));
        out.push_str(&format!("goto IF_FALSE{}\n", id));
        out.push_str(&format!("label IF_TRUE{}\n", id));
        self.expect_sym('{');
        self.parse_statements(sym, out);
        self.expect_sym('}');
        if self.accept_kw("else") {
            out.push_str(&format!("goto IF_END{}\n", id));
            out.push_str(&format!("label IF_FALSE{}\n", id));
            self.expect_sym('{');
            self.parse_statements(sym, out);
            self.expect_sym('}');
            out.push_str(&format!("label IF_END{}\n", id));
        } else {
            out.push_str(&format!("label IF_FALSE{}\n", id));
        }
    }

    // while := 'while' '(' expression ')' '{' stmts '}'
    fn parse_while(&mut self, sym: &Symbols, out: &mut String) {
        self.expect_kw("while");
        let id = self.label_id;
        self.label_id += 1;
        out.push_str(&format!("label WHILE_EXP{}\n", id));
        self.expect_sym('(');
        self.parse_expr(sym, out);
        self.expect_sym(')');
        out.push_str("not\n");
        out.push_str(&format!("if-goto WHILE_END{}\n", id));
        self.expect_sym('{');
        self.parse_statements(sym, out);
        self.expect_sym('}');
        out.push_str(&format!("goto WHILE_EXP{}\n", id));
        out.push_str(&format!("label WHILE_END{}\n", id));
    }

    // let := 'let' name [ '[' expression ']' ] '=' expression ';'
    fn parse_let(&mut self, sym: &Symbols, out: &mut String) {
        self.expect_kw("let");
        let name = self.expect_id();
        let found = sym.lookup(&name);
        if self.accept_sym('[') {
            let (seg, idx) = match found {
                None => self.die::<(Seg, usize)>(&format!("變數 {} 未宣告", name)),
                Some((seg, idx, _)) => (seg, idx),
            };
            out.push_str(&format!("push {} {}\n", seg.vm(), idx));
            self.parse_expr(sym, out);
            self.expect_sym(']');
            out.push_str("add\n");
            self.expect_sym('=');
            self.parse_expr(sym, out);
            out.push_str("pop temp 0\n");
            out.push_str("pop pointer 1\n");
            out.push_str("push temp 0\n");
            out.push_str("pop that 0\n");
            self.expect_sym(';');
        } else {
            match found {
                None => self.die::<()>(&format!("變數 {} 未宣告", name)),
                Some((Seg::Arg, _, _)) => {
                    self.die::<()>(&format!("參數 {} 不可被賦值", name))
                }
                Some((seg, idx, _)) => {
                    self.expect_sym('=');
                    self.parse_expr(sym, out);
                    self.expect_sym(';');
                    out.push_str(&format!("pop {} {}\n", seg.vm(), idx));
                }
            }
        }
    }

    // return := 'return' [ expression ] ';'
    fn parse_return(&mut self, sym: &Symbols, out: &mut String) {
        self.expect_kw("return");
        if self.at_sym(';') {
            out.push_str("push constant 0\n");
        } else {
            self.parse_expr(sym, out);
        }
        self.expect_sym(';');
        out.push_str("return\n");
    }

    // expression := term { binaryOp term }   （由左至右，無優先權）
    fn parse_expr(&mut self, sym: &Symbols, out: &mut String) {
        self.parse_term(sym, out);
        loop {
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
            out.push_str(match op {
                '+' => "add\n",
                '-' => "sub\n",
                '*' => "mul\n",
                '/' => "div\n",
                '&' => "and\n",
                '|' => "or\n",
                '<' => "lt\n",
                '>' => "gt\n",
                _ => "eq\n",
            });
        }
    }

    // term := integer | string | keywordConstant | '-' term | '~' term
    //       | '(' expression ')' | identifier [ '(' | '.' subroutine ]
    fn parse_term(&mut self, sym: &Symbols, out: &mut String) {
        match self.next() {
            Kind::Int(n) => out.push_str(&format!("push constant {}\n", n)),
            Kind::Str(s) => self.emit_string(&s, out),
            Kind::Kw(k) if k == "true" => out.push_str("push constant 0\nnot\n"),
            Kind::Kw(k) if k == "false" || k == "null" => out.push_str("push constant 0\n"),
            Kind::Kw(k) if k == "this" => out.push_str("push pointer 0\n"),
            Kind::Sym('-') => {
                self.parse_term(sym, out);
                out.push_str("neg\n");
            }
            Kind::Sym('~') => {
                self.parse_term(sym, out);
                out.push_str("not\n");
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
                            out.push_str(&format!("push {} {}\n", seg.vm(), idx))
                        }
                        None => self.die::<()>(&format!("變數 {} 未宣告", name)),
                    }
                    self.expect_sym('[');
                    self.parse_expr(sym, out);
                    self.expect_sym(']');
                    out.push_str("add\n");
                    out.push_str("pop pointer 1\n");
                    out.push_str("push that 0\n");
                } else {
                    match sym.lookup(&name) {
                        Some((seg, idx, _)) => {
                            out.push_str(&format!("push {} {}\n", seg.vm(), idx))
                        }
                        None => self.die::<()>(&format!("變數 {} 未宣告", name)),
                    }
                }
            }
            _ => {
                let d = self.describe();
                self.die::<()>(&format!("預期算式但遇到 {}", d));
            }
        }
    }

    // "..." → 建立字串物件；appendChar 會回傳字串本身，所以最後位址留在堆疊上
    fn emit_string(&self, s: &str, out: &mut String) {
        out.push_str(&format!("push constant {}\n", s.chars().count()));
        out.push_str("call String.new 1\n");
        for ch in s.chars() {
            out.push_str(&format!("push constant {}\n", ch as u32));
            out.push_str("call String.appendChar 2\n");
        }
    }
}

/// 編譯單一 .jack 檔，回傳 VM 程式碼
fn compile(path: &Path) -> String {
    let file = path.display().to_string();
    let src = fs::read_to_string(path).unwrap_or_else(|e| {
        eprintln!("{}: {}", file, e);
        exit(1);
    });
    let toks = tokenize(&src, &file);
    let mut parser = Parser { toks, pos: 0, label_id: 0, file, current_class: String::new() };
    let vm = parser.parse_class();
    if !parser.at_eof() {
        let d = parser.describe();
        parser.die::<()>(&format!("class 之後有多餘的內容: {}", d));
    }
    vm
}

fn write_vm(vm: &str, out: &Path) {
    if let Some(parent) = out.parent() {
        if !parent.as_os_str().is_empty() {
            if let Err(e) = fs::create_dir_all(parent) {
                eprintln!("{}: {}", parent.display(), e);
                exit(1);
            }
        }
    }
    if let Err(e) = fs::write(out, vm) {
        eprintln!("{}: {}", out.display(), e);
        exit(1);
    }
}

/// jackc <in.jack> [out.vm]
fn compile_one(input: &Path, output: Option<&Path>) {
    let out = match output {
        Some(p) => p.to_path_buf(),
        None => {
            let stem = input
                .file_stem()
                .map(|s| s.to_os_string())
                .unwrap_or_else(|| std::ffi::OsString::from("out"));
            let mut name = stem;
            name.push(".vm");
            PathBuf::from(name)
        }
    };
    write_vm(&compile(input), &out);
}

/// jackc <dir> [outdir]
fn compile_dir(dir: &Path, outdir: Option<&Path>) {
    let mut files: Vec<PathBuf> = Vec::new();
    let entries = fs::read_dir(dir).unwrap_or_else(|e| {
        eprintln!("{}: {}", dir.display(), e);
        exit(1);
    });
    for entry in entries {
        let entry = entry.unwrap_or_else(|e| {
            eprintln!("{}: {}", dir.display(), e);
            exit(1);
        });
        let p = entry.path();
        if p.extension().map_or(false, |e| e.to_string_lossy() == "jack") {
            files.push(p);
        }
    }
    files.sort();
    if files.is_empty() {
        eprintln!("{} 底下沒有 .jack 檔", dir.display());
        exit(1);
    }
    for f in &files {
        let stem = f.file_stem().map(|s| s.to_string_lossy().to_string()).unwrap_or_default();
        let out = match outdir {
            Some(d) => d.join(format!("{}.vm", stem)),
            None => f.with_extension("vm"),
        };
        write_vm(&compile(f), &out);
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 || args.len() > 3 {
        eprintln!("用法: jackc <in.jack|dir> [out.vm|outdir]");
        exit(2);
    }
    let input = Path::new(&args[1]);
    let output = args.get(2).map(|s| PathBuf::from(s));
    if input.is_dir() {
        compile_dir(input, output.as_deref());
    } else {
        compile_one(input, output.as_deref());
    }
}
