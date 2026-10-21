use crate::error::{CompileError, Result};

#[derive(Clone, Copy, PartialEq, Eq, Debug)]
pub enum TT {
    Keyword,
    Symbol,
    Int,
    Str,
    Ident,
    Eof,
}

#[derive(Clone, Debug)]
pub struct Token {
    pub tt: TT,
    pub text: String,
    pub line: usize,
}

impl Token {
    pub fn is_sym(&self, s: &str) -> bool {
        self.tt == TT::Symbol && self.text == s
    }
    pub fn is_kw(&self, s: &str) -> bool {
        self.tt == TT::Keyword && self.text == s
    }
}

pub const KEYWORDS: &[&str] = &[
    "class", "constructor", "function", "method", "field", "static", "var", "int", "char",
    "boolean", "void", "true", "false", "null", "this", "let", "do", "if", "else", "while",
    "return",
];

const SYMBOLS: &str = "{}()[].,;+-*/&|<>=~";

/// 原始碼 --lex--> Token 序列(最後補一個 Eof)。
pub fn lex(file: &str, src: &str) -> Result<Vec<Token>> {
    let ch: Vec<char> = src.chars().collect();
    let n = ch.len();
    let mut out: Vec<Token> = Vec::new();
    let mut i = 0usize;
    let mut line = 1usize;

    let starts_with = |i: usize, pat: &str| -> bool {
        pat.chars().enumerate().all(|(k, c)| ch.get(i + k).copied() == Some(c))
    };

    while i < n {
        let c = ch[i];
        if c == '\n' {
            line += 1;
            i += 1;
        } else if c.is_whitespace() {
            i += 1;
        } else if starts_with(i, "//") {
            while i < n && ch[i] != '\n' {
                i += 1;
            }
        } else if starts_with(i, "/*") {
            let mut end = None;
            let mut k = i + 2;
            while k + 1 < n {
                if ch[k] == '*' && ch[k + 1] == '/' {
                    end = Some(k);
                    break;
                }
                k += 1;
            }
            let end =
                end.ok_or_else(|| CompileError::new(file, line, "unterminated comment"))?;
            for c in ch.iter().take(end).skip(i) {
                if *c == '\n' {
                    line += 1;
                }
            }
            i = end + 2;
        } else if c == '"' {
            let mut end = None;
            let mut k = i + 1;
            while k < n {
                if ch[k] == '"' {
                    end = Some(k);
                    break;
                }
                if ch[k] == '\n' {
                    break;
                }
                k += 1;
            }
            let end = end
                .ok_or_else(|| CompileError::new(file, line, "unterminated string constant"))?;
            let text: String = ch[i + 1..end].iter().collect();
            out.push(Token { tt: TT::Str, text, line });
            i = end + 1;
        } else if c.is_ascii_digit() {
            let start = i;
            while i < n && ch[i].is_ascii_digit() {
                i += 1;
            }
            out.push(Token { tt: TT::Int, text: ch[start..i].iter().collect(), line });
        } else if c.is_alphabetic() || c == '_' {
            let start = i;
            while i < n && (ch[i].is_alphanumeric() || ch[i] == '_') {
                i += 1;
            }
            let w: String = ch[start..i].iter().collect();
            let tt = if KEYWORDS.contains(&w.as_str()) { TT::Keyword } else { TT::Ident };
            out.push(Token { tt, text: w, line });
        } else if SYMBOLS.contains(c) {
            out.push(Token { tt: TT::Symbol, text: c.to_string(), line });
            i += 1;
        } else {
            return Err(CompileError::new(file, line, format!("illegal character '{c}'")));
        }
    }
    out.push(Token { tt: TT::Eof, text: "<eof>".to_string(), line });
    Ok(out)
}
