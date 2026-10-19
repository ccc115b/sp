// 03-ops-branch：加上布林 / 位元運算與分支、迴圈
// 相對 02 新增：& | < > = 運算子、一元 ~、true/false/null、if/else、while
// 標籤編號在每個函式內從 0 開始（VM 的 label 本來就是函式範圍）
use std::collections::HashMap;
use std::env;
use std::fs;
use std::path::Path;
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

fn tokenize(src: &str) -> Vec<Token> {
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
                eprintln!("line {}: 整數常數過大: {}", line, text);
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
        eprintln!("line {}: 無法辨識的字元 '{}'", line, c);
        exit(1);
    }
    toks.push(Token { kind: Kind::Eof, line });
    toks
}

// ---------------------------------------------------------------- symbol table

#[derive(Clone, Copy, PartialEq)]
enum Seg {
    Arg,
    Local,
}

impl Seg {
    fn vm(self) -> &'static str {
        match self {
            Seg::Arg => "argument",
            Seg::Local => "local",
        }
    }
}

struct Symbols {
    map: HashMap<String, (Seg, usize)>,
    n_args: usize,
    n_locals: usize,
}

impl Symbols {
    fn new() -> Symbols {
        Symbols { map: HashMap::new(), n_args: 0, n_locals: 0 }
    }

    fn declare(&mut self, name: &str, seg: Seg) -> Result<usize, String> {
        if self.map.contains_key(name) {
            return Err(format!("變數 {} 重複宣告", name));
        }
        let idx = match seg {
            Seg::Arg => {
                let i = self.n_args;
                self.n_args += 1;
                i
            }
            Seg::Local => {
                let i = self.n_locals;
                self.n_locals += 1;
                i
            }
        };
        self.map.insert(name.to_string(), (seg, idx));
        Ok(idx)
    }

    fn lookup(&self, name: &str) -> Option<(Seg, usize)> {
        self.map.get(name).copied()
    }
}

// ---------------------------------------------------------------------- parser

struct Parser {
    toks: Vec<Token>,
    pos: usize,
    label_id: usize,
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
        eprintln!("line {}: {}", self.line(), msg);
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

    // class := 'class' identifier '{' function* '}'
    fn parse_class(&mut self) -> String {
        self.expect_kw("class");
        let name = self.expect_id();
        self.expect_sym('{');
        let mut out = String::new();
        while !self.at_sym('}') {
            if self.at_kw("function") {
                out += &self.parse_function(&name);
            } else {
                let d = self.describe();
                self.die::<()>(&format!("預期 'function' 但遇到 {}", d));
            }
        }
        self.expect_sym('}');
        out
    }

    // function := 'function' type identifier '(' params ')' '{' var* stmts '}'
    fn parse_function(&mut self, class: &str) -> String {
        self.expect_kw("function");
        self.parse_type();
        let name = self.expect_id();
        let mut sym = Symbols::new();
        self.parse_params(&mut sym);
        self.expect_sym('{');
        self.parse_var_decls(&mut sym);
        self.label_id = 0;
        let mut out = format!("function {}.{} {}\n", class, name, sym.n_locals);
        self.parse_statements(&sym, &mut out);
        self.expect_sym('}');
        out
    }

    // params := [ type id { ',' type id } ]
    fn parse_params(&mut self, sym: &mut Symbols) {
        self.expect_sym('(');
        if !self.at_sym(')') {
            loop {
                self.parse_type();
                let pname = self.expect_id();
                let res = sym.declare(&pname, Seg::Arg);
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
            self.parse_type();
            loop {
                let vname = self.expect_id();
                let res = sym.declare(&vname, Seg::Local);
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
            } else if self.at_kw("return") {
                self.parse_return(sym, out);
            } else {
                let d = self.describe();
                self.die::<()>(&format!(
                    "此版本只支援 let / if / while / return 指述，但遇到 {}",
                    d
                ));
            }
        }
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

    // let := 'let' identifier '=' expression ';'
    fn parse_let(&mut self, sym: &Symbols, out: &mut String) {
        self.expect_kw("let");
        let name = self.expect_id();
        match sym.lookup(&name) {
            None => self.die::<()>(&format!("變數 {} 未宣告", name)),
            Some((Seg::Arg, _)) => {
                self.die::<()>(&format!("參數 {} 不可被賦值（本版本僅支援 let local）", name))
            }
            Some((Seg::Local, idx)) => {
                self.expect_sym('=');
                self.parse_expr(sym, out);
                self.expect_sym(';');
                out.push_str(&format!("pop local {}\n", idx));
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

    // term := integer | keywordConstant | '-' term | '~' term
    //       | '(' expression ')' | identifier
    fn parse_term(&mut self, sym: &Symbols, out: &mut String) {
        match self.next() {
            Kind::Int(n) => out.push_str(&format!("push constant {}\n", n)),
            Kind::Kw(k) if k == "true" => out.push_str("push constant 0\nnot\n"),
            Kind::Kw(k) if k == "false" || k == "null" => out.push_str("push constant 0\n"),
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
            Kind::Id(name) => match sym.lookup(&name) {
                Some((seg, idx)) => out.push_str(&format!("push {} {}\n", seg.vm(), idx)),
                None => self.die::<()>(&format!("變數 {} 未宣告", name)),
            },
            _ => {
                let d = self.describe();
                self.die::<()>(&format!("預期算式但遇到 {}", d));
            }
        }
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 || args.len() > 3 {
        eprintln!("用法: jackc <in.jack> [out.vm]");
        exit(2);
    }
    let input = &args[1];
    let output = match args.get(2) {
        Some(p) => p.clone(),
        None => {
            let stem = Path::new(input)
                .file_stem()
                .map(|s| s.to_string_lossy().to_string())
                .unwrap_or_else(|| "out".to_string());
            format!("{}.vm", stem)
        }
    };
    let src = fs::read_to_string(input).unwrap_or_else(|e| {
        eprintln!("{}: {}", input, e);
        exit(1);
    });
    let toks = tokenize(&src);
    let mut parser = Parser { toks, pos: 0, label_id: 0 };
    let vm = parser.parse_class();
    if !parser.at_eof() {
        let d = parser.describe();
        parser.die::<()>(&format!("class 之後有多餘的內容: {}", d));
    }
    if let Err(e) = fs::write(&output, &vm) {
        eprintln!("{}: {}", output, e);
        exit(1);
    }
}
