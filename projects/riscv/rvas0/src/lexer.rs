use std::fmt;

#[derive(Debug, Clone, PartialEq)]
pub enum Tok {
    Ident(String),
    Num(i128),
    Float(f64),
    Str(String),
    Punct(&'static str),
    Newline,
    Eof,
}

impl Tok {
    #[allow(dead_code)]
    pub fn is_punct(&self, s: &str) -> bool {
        matches!(self, Tok::Punct(p) if *p == s)
    }
}

#[derive(Clone, Debug)]
pub struct SrcLoc {
    pub file: String,
    pub line: usize,
}

impl fmt::Display for SrcLoc {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}:{}", self.file, self.line)
    }
}

pub struct Lexer<'a> {
    src: &'a [u8],
    pos: usize,
    file: String,
    line: usize,
}

pub struct LexError {
    pub loc: SrcLoc,
    pub msg: String,
}

impl<'a> Lexer<'a> {
    pub fn new(src: &'a str, file: &str) -> Self {
        Lexer { src: src.as_bytes(), pos: 0, file: file.to_string(), line: 1 }
    }

    pub fn loc(&self) -> SrcLoc {
        SrcLoc { file: self.file.clone(), line: self.line }
    }

    fn peek(&self) -> Option<u8> {
        self.src.get(self.pos).copied()
    }

    fn peek2(&self) -> Option<u8> {
        self.src.get(self.pos + 1).copied()
    }

    fn bump(&mut self) -> Option<u8> {
        let c = self.peek();
        if c == Some(b'\n') {
            self.line += 1;
        }
        self.pos += 1;
        c
    }

    fn skip_ws_and_comments(&mut self) {
        loop {
            match self.peek() {
                Some(b' ') | Some(b'\t') | Some(b'\r') => {
                    self.pos += 1;
                }
                Some(b'\\') if self.peek2() == Some(b'\n') => {
                    self.pos += 2;
                    self.line += 1;
                }
                Some(b'\\') if self.peek2() == Some(b'\r') => {
                    self.pos += 2;
                    if self.peek() == Some(b'\n') {
                        self.pos += 1;
                    }
                    self.line += 1;
                }
                Some(b'#') => {
                    while let Some(c) = self.peek() {
                        if c == b'\n' {
                            break;
                        }
                        self.pos += 1;
                    }
                }
                Some(b'/') if self.peek2() == Some(b'/') => {
                    while let Some(c) = self.peek() {
                        if c == b'\n' {
                            break;
                        }
                        self.pos += 1;
                    }
                }
                _ => break,
            }
        }
    }

    fn lex_string(&mut self, loc: &SrcLoc) -> Result<Tok, LexError> {
        self.pos += 1;
        let mut out = Vec::new();
        loop {
            let c = match self.bump() {
                Some(c) => c,
                None => return Err(LexError { loc: loc.clone(), msg: "unterminated string".into() }),
            };
            match c {
                b'"' => break,
                b'\\' => {
                    let e = self.bump().ok_or_else(|| LexError {
                        loc: loc.clone(),
                        msg: "unterminated escape".into(),
                    })?;
                    match e {
                        b'n' => out.push(b'\n'),
                        b't' => out.push(b'\t'),
                        b'r' => out.push(b'\r'),
                        b'\\' => out.push(b'\\'),
                        b'"' => out.push(b'"'),
                        b'0' => out.push(0),
                        b'a' => out.push(7),
                        b'b' => out.push(8),
                        b'f' => out.push(12),
                        b'v' => out.push(11),
                        b'x' => {
                            let mut v = 0u32;
                            let mut n = 0;
                            while n < 2 {
                                let d = match self.peek().and_then(|c| (c as char).to_digit(16)) {
                                    Some(d) => d,
                                    None => break,
                                };
                                v = v * 16 + d;
                                self.pos += 1;
                                n += 1;
                            }
                            if n == 0 {
                                return Err(LexError { loc: loc.clone(), msg: "bad \\x escape".into() });
                            }
                            out.push(v as u8);
                        }
                        b'1'..=b'7' => {
                            let mut v = (e - b'0') as u32;
                            let mut n = 1;
                            while n < 3 {
                                match self.peek() {
                                    Some(c) if (b'0'..=b'7').contains(&c) => {
                                        v = v * 8 + (c - b'0') as u32;
                                        self.pos += 1;
                                        n += 1;
                                    }
                                    _ => break,
                                }
                            }
                            out.push(v as u8);
                        }
                        other => {
                            return Err(LexError {
                                loc: loc.clone(),
                                msg: format!("unknown escape \\{}", other as char),
                            })
                        }
                    }
                }
                other => out.push(other),
            }
        }
        Ok(Tok::Str(String::from_utf8_lossy(&out).into_owned()))
    }

    fn lex_char(&mut self, loc: &SrcLoc) -> Result<Tok, LexError> {
        self.pos += 1;
        let c = match self.bump() {
            Some(c) => c,
            None => return Err(LexError { loc: loc.clone(), msg: "unterminated char literal".into() }),
        };
        let v = if c == b'\\' {
            let e = self.bump().ok_or_else(|| LexError {
                loc: loc.clone(),
                msg: "unterminated escape".into(),
            })?;
            match e {
                b'n' => b'\n' as i128,
                b't' => b'\t' as i128,
                b'r' => b'\r' as i128,
                b'\\' => b'\\' as i128,
                b'\'' => b'\'' as i128,
                b'0' => 0,
                b'a' => 7,
                b'b' => 8,
                b'f' => 12,
                b'v' => 11,
                b'x' => {
                    let mut v = 0i128;
                    let mut n = 0;
                    while n < 2 {
                        let d = match self.peek().and_then(|c| (c as char).to_digit(16)) {
                            Some(d) => d,
                            None => break,
                        };
                        v = v * 16 + d as i128;
                        self.pos += 1;
                        n += 1;
                    }
                    v
                }
                _ => return Err(LexError { loc: loc.clone(), msg: "unknown char escape".into() }),
            }
        } else {
            c as i128
        };
        if self.peek() == Some(b'\'') {
            self.pos += 1;
        }
        Ok(Tok::Num(v))
    }

    fn lex_float_tail(&mut self, loc: &SrcLoc, start: usize) -> Result<Tok, LexError> {
        let mut s = String::from_utf8_lossy(&self.src[start..self.pos]).into_owned();
        if s.starts_with('.') {
            s.insert(0, '0');
        }
        if let Some(c) = self.peek() {
            if c == b'e' || c == b'E' {
                let save = self.pos;
                self.pos += 1;
                if matches!(self.peek(), Some(b'+') | Some(b'-')) {
                    self.pos += 1;
                }
                let ds = self.pos;
                while let Some(c) = self.peek() {
                    if c.is_ascii_digit() {
                        self.pos += 1;
                    } else {
                        break;
                    }
                }
                if self.pos == ds {
                    self.pos = save;
                } else {
                    s.push('e');
                    s.push_str(&String::from_utf8_lossy(&self.src[ds..self.pos]));
                }
            }
        }
        s.parse::<f64>()
            .map(Tok::Float)
            .map_err(|_| LexError { loc: loc.clone(), msg: "malformed floating point literal".into() })
    }

    fn lex_number(&mut self, loc: &SrcLoc) -> Result<Tok, LexError> {
        let start = self.pos;
        if self.peek() == Some(b'0') && matches!(self.peek2(), Some(b'x') | Some(b'X')) {
            self.pos += 2;
            let mut v: i128 = 0;
            let mut any = false;
            while let Some(c) = self.peek() {
                let d = match (c as char).to_digit(16) {
                    Some(d) => d as i128,
                    None => break,
                };
                v = v.wrapping_mul(16).wrapping_add(d);
                self.pos += 1;
                any = true;
            }
            if !any {
                return Err(LexError { loc: loc.clone(), msg: "malformed hex number".into() });
            }
            let _ = start;
            return Ok(Tok::Num(v));
        }
        if self.peek() == Some(b'0') && matches!(self.peek2(), Some(b'b') | Some(b'B')) {
            self.pos += 2;
            let mut v: i128 = 0;
            let mut any = false;
            while let Some(c) = self.peek() {
                if c != b'0' && c != b'1' {
                    break;
                }
                v = v.wrapping_mul(2).wrapping_add((c - b'0') as i128);
                self.pos += 1;
                any = true;
            }
            if !any {
                return Err(LexError { loc: loc.clone(), msg: "malformed binary number".into() });
            }
            return Ok(Tok::Num(v));
        }
        let mut is_oct = self.peek() == Some(b'0');
        let mut digits: Vec<u8> = Vec::new();
        while let Some(c) = self.peek() {
            if !c.is_ascii_digit() {
                break;
            }
            digits.push(c);
            self.pos += 1;
        }
        if self.peek() == Some(b'.') && self.peek2().map_or(false, |c| c.is_ascii_digit()) {
            self.pos += 1;
            while let Some(c) = self.peek() {
                if c.is_ascii_digit() {
                    self.pos += 1;
                } else {
                    break;
                }
            }
            return self.lex_float_tail(loc, start);
        }
        if is_oct && digits.len() > 1 {
            let mut v: i128 = 0;
            for d in &digits {
                if *d > b'7' {
                    return Err(LexError { loc: loc.clone(), msg: "bad octal number".into() });
                }
                v = v.wrapping_mul(8).wrapping_add((d - b'0') as i128);
            }
            return Ok(Tok::Num(v));
        }
        is_oct = false;
        let _ = is_oct;
        let mut v: i128 = 0;
        for d in &digits {
            v = v.wrapping_mul(10).wrapping_add((d - b'0') as i128);
        }
        Ok(Tok::Num(v))
    }

    pub fn next_tok(&mut self) -> Result<Tok, LexError> {
        self.skip_ws_and_comments();
        let loc = self.loc();
        let c = match self.peek() {
            Some(c) => c,
            None => return Ok(Tok::Eof),
        };
        match c {
            b'\n' => {
                self.pos += 1;
                self.line += 1;
                Ok(Tok::Newline)
            }
            b'"' => self.lex_string(&loc),
            b'\'' => self.lex_char(&loc),
            b'0'..=b'9' => self.lex_number(&loc),
            b'.' if self.peek2().map_or(false, |c| c.is_ascii_digit()) => {
                let save = self.pos;
                self.pos += 1;
                while let Some(c) = self.peek() {
                    if c.is_ascii_digit() {
                        self.pos += 1;
                    } else {
                        break;
                    }
                }
                if self.peek().map_or(false, |c| {
                    c.is_ascii_alphanumeric() || c == b'_' || c == b'.' || c == b'$'
                }) {
                    self.pos = save;
                    let start = self.pos;
                    while let Some(c) = self.peek() {
                        if c.is_ascii_alphanumeric() || c == b'_' || c == b'.' || c == b'$' {
                            self.pos += 1;
                        } else {
                            break;
                        }
                    }
                    let s = String::from_utf8_lossy(&self.src[start..self.pos]).into_owned();
                    Ok(Tok::Ident(s))
                } else {
                    self.lex_float_tail(&loc, save)
                }
            }
            c if c.is_ascii_alphabetic() || c == b'_' || c == b'.' || c == b'$' => {
                let start = self.pos;
                while let Some(c) = self.peek() {
                    if c.is_ascii_alphanumeric() || c == b'_' || c == b'.' || c == b'$' {
                        self.pos += 1;
                    } else {
                        break;
                    }
                }
                let s = String::from_utf8_lossy(&self.src[start..self.pos]).into_owned();
                Ok(Tok::Ident(s))
            }
            b'=' if self.peek2() != Some(b'=') => {
                self.pos += 1;
                Ok(Tok::Punct("="))
            }
            b'<' | b'>' => {
                let c2 = self.peek2();
                if (c == b'<' && c2 == Some(b'<')) || (c == b'>' && c2 == Some(b'>')) {
                    self.pos += 2;
                    Ok(Tok::Punct(if c == b'<' { "<<" } else { ">>" }))
                } else if c == b'<' && c2 == Some(b'=') {
                    self.pos += 2;
                    Ok(Tok::Punct("<="))
                } else if c == b'>' && c2 == Some(b'=') {
                    self.pos += 2;
                    Ok(Tok::Punct(">="))
                } else {
                    self.pos += 1;
                    Ok(Tok::Punct(if c == b'<' { "<" } else { ">" }))
                }
            }
            b'&' if self.peek2() == Some(b'&') => {
                self.pos += 2;
                Ok(Tok::Punct("&&"))
            }
            b'|' if self.peek2() == Some(b'|') => {
                self.pos += 2;
                Ok(Tok::Punct("||"))
            }
            b'=' | b'+' | b'-' | b'*' | b'/' | b'%' | b'&' | b'|' | b'^' | b'~' | b'!' | b','
            | b'(' | b')' | b':' | b'@' | b'{' | b'}' | b'[' | b']' => {
                self.pos += 1;
                let s: &'static str = match c {
                    b'=' => "=",
                    b'+' => "+",
                    b'-' => "-",
                    b'*' => "*",
                    b'/' => "/",
                    b'%' => "%",
                    b'&' => "&",
                    b'|' => "|",
                    b'^' => "^",
                    b'~' => "~",
                    b'!' => "!",
                    b',' => ",",
                    b'(' => "(",
                    b')' => ")",
                    b':' => ":",
                    b'@' => "@",
                    b'{' => "{",
                    b'}' => "}",
                    b'[' => "[",
                    b']' => "]",
                    _ => unreachable!(),
                };
                Ok(Tok::Punct(s))
            }
            _ => Err(LexError { loc, msg: format!("unexpected character '{}'", c as char) }),
        }
    }

    pub fn tokenize(mut self) -> Result<Vec<(Tok, SrcLoc)>, LexError> {
        let mut out = Vec::new();
        loop {
            let loc = self.loc();
            let t = self.next_tok()?;
            let done = t == Tok::Eof;
            out.push((t, loc));
            if done {
                break;
            }
        }
        Ok(out)
    }
}
