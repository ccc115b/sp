// tokenizer：把原始碼切成 token，並順手收集詞法錯誤。
// 這一層完全不知道語法，只認得關鍵字、符號、整數、字串。
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
pub enum Kind {
    Kw(String),
    Id(String),
    Int(i64),
    Str(String),
    Sym(char),
    Eof,
}

impl Kind {
    pub fn describe(&self) -> String {
        match self {
            Kind::Kw(k) => format!("關鍵字 '{}'", k),
            Kind::Id(s) => format!("識別字 '{}'", s),
            Kind::Int(n) => format!("整數 {}", n),
            Kind::Str(s) => format!("字串 \"{}\"", s),
            Kind::Sym(c) => format!("'{}'", c),
            Kind::Eof => "檔案結尾".to_string(),
        }
    }
}

pub struct Token {
    pub kind: Kind,
    pub line: usize,
    pub col: usize,
}

/// 一個編譯錯誤：位置 + 訊息
pub struct Error {
    pub line: usize,
    pub col: usize,
    pub msg: String,
}

/// 切字。詞法錯誤在此直接收集並跳過壞字元，所以可以一次回報多個。
pub fn tokenize(src: &str) -> (Vec<Token>, Vec<Error>) {
    let b: Vec<char> = src.chars().collect();
    let mut toks: Vec<Token> = Vec::new();
    let mut errs: Vec<Error> = Vec::new();
    let mut i = 0;
    let mut line = 1;
    let mut line_start = 0;
    while i < b.len() {
        let c = b[i];
        if c == '\n' {
            line += 1;
            i += 1;
            line_start = i;
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
            let mut closed = false;
            while i < b.len() {
                if b[i] == '*' && i + 1 < b.len() && b[i + 1] == '/' {
                    closed = true;
                    i += 2;
                    break;
                }
                if b[i] == '\n' {
                    line += 1;
                    i += 1;
                    line_start = i;
                } else {
                    i += 1;
                }
            }
            if !closed {
                errs.push(Error {
                    line,
                    col: i - line_start + 1,
                    msg: "區塊註解沒有結束的 */".to_string(),
                });
                i = b.len();
            }
            continue;
        }
        let tok_line = line;
        let tok_col = i - line_start + 1;
        if c.is_ascii_digit() {
            let start = i;
            while i < b.len() && b[i].is_ascii_digit() {
                i += 1;
            }
            let text: String = b[start..i].iter().collect();
            let n = match text.parse::<i64>() {
                Ok(n) => n,
                Err(_) => {
                    errs.push(Error {
                        line: tok_line,
                        col: tok_col,
                        msg: format!("整數常數過大：{}", text),
                    });
                    0
                }
            };
            toks.push(Token { kind: Kind::Int(n), line: tok_line, col: tok_col });
            continue;
        }
        if c == '"' {
            i += 1;
            let mut s = String::new();
            let mut closed = false;
            while i < b.len() {
                if b[i] == '"' {
                    closed = true;
                    i += 1;
                    break;
                }
                if b[i] == '\n' {
                    line += 1;
                    i += 1;
                    line_start = i;
                } else {
                    s.push(b[i]);
                    i += 1;
                }
            }
            if !closed {
                errs.push(Error {
                    line: tok_line,
                    col: tok_col,
                    msg: "字串常數沒有結束的引號".to_string(),
                });
                continue;
            }
            toks.push(Token { kind: Kind::Str(s), line: tok_line, col: tok_col });
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
            toks.push(Token { kind, line: tok_line, col: tok_col });
            continue;
        }
        if SYMBOLS.contains(&c) {
            toks.push(Token { kind: Kind::Sym(c), line: tok_line, col: tok_col });
            i += 1;
            continue;
        }
        // 詞法錯誤：記下來，略過這個字元繼續切
        errs.push(Error {
            line: tok_line,
            col: tok_col,
            msg: format!("無法辨識的字元 '{}'", c),
        });
        i += 1;
    }
    toks.push(Token { kind: Kind::Eof, line, col: b.len() - line_start + 1 });
    (toks, errs)
}

/// 把所有錯誤印成「檔:列:欄: error: 訊息」＋原始碼＋指標
pub fn report_errors(file: &str, source: &[String], errors: &[Error]) {
    for e in errors {
        eprintln!("{}:{}:{}: error: {}", file, e.line, e.col, e.msg);
        if let Some(text) = source.get(e.line.saturating_sub(1)) {
            eprintln!("    {}", text);
            eprintln!("    {}^", " ".repeat(e.col.saturating_sub(1)));
        }
    }
    eprintln!("共 {} 個錯誤", errors.len());
}
