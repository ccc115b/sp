// 01-hello-jack：最小的 Jack → VM 編譯器
// 流程：tokenize(字串→Token) → parse(遞迴下降) → emit(直接輸出 VM 指令)
// 只支援：class { function ... { return; } } 與 return <整數>;
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

struct Parser {
    toks: Vec<Token>,
    pos: usize,
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

    fn accept_kw(&mut self, s: &str) -> bool {
        if self.at_kw(s) {
            self.pos += 1;
            true
        } else {
            false
        }
    }

    fn expect_sym(&mut self, c: char) {
        if !self.accept_sym(c) {
            self.die::<()>(&format!("預期 '{}' 但遇到 {:?}", c, self.describe()));
        }
    }

    fn expect_kw(&mut self, s: &str) {
        if !self.accept_kw(s) {
            self.die::<()>(&format!("預期關鍵字 '{}' 但遇到 {:?}", s, self.describe()));
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
                self.die::<()>(&format!("預期 'function' 但遇到 {:?}", self.describe()));
            }
        }
        self.expect_sym('}');
        out
    }

    // function := 'function' type identifier '(' ')' '{' return* '}'
    fn parse_function(&mut self, class: &str) -> String {
        self.expect_kw("function");
        self.skip_type();
        let name = self.expect_id();
        self.expect_sym('(');
        self.expect_sym(')');
        self.expect_sym('{');
        let mut out = format!("function {}.{} 0\n", class, name);
        while !self.at_sym('}') {
            if self.at_kw("return") {
                out += &self.parse_return();
            } else {
                self.die::<()>(&format!("預期 'return' 但遇到 {:?}", self.describe()));
            }
        }
        self.expect_sym('}');
        out
    }

    // type := 'void' | 'int' | 'boolean' | 'char' | identifier
    fn skip_type(&mut self) {
        match self.next() {
            Kind::Kw(k) if k == "void" || k == "int" || k == "boolean" || k == "char" => {}
            Kind::Id(_) => {}
            _ => self.die("預期回傳型別"),
        }
    }

    // return := 'return' [ integer ] ';'   →  void 缺省補 push constant 0
    fn parse_return(&mut self) -> String {
        self.expect_kw("return");
        let mut out = String::from("push constant 0\n");
        if !self.at_sym(';') {
            let n = match self.next() {
                Kind::Int(n) => n,
                _ => self.die("此版本的算式只支援整數常數"),
            };
            out = format!("push constant {}\n", n);
        }
        self.expect_sym(';');
        out.push_str("return\n");
        out
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
    let mut parser = Parser { toks, pos: 0 };
    let vm = parser.parse_class();
    if !parser.at_eof() {
        parser.die::<()>(&format!("class 之後有多餘的內容: {:?}", parser.describe()));
    }
    if let Err(e) = fs::write(&output, &vm) {
        eprintln!("{}: {}", output, e);
        exit(1);
    }
}
