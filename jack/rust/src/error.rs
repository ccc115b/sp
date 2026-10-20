use std::fmt;

/// Java 版的 `JackCompiler.CompileError`,訊息格式為 `file:line: error: msg`。
#[derive(Debug, Clone)]
pub struct CompileError {
    pub file: String,
    pub line: usize,
    pub msg: String,
}

impl CompileError {
    pub fn new(file: &str, line: usize, msg: impl Into<String>) -> Self {
        CompileError { file: file.to_string(), line, msg: msg.into() }
    }
}

impl fmt::Display for CompileError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}:{}: error: {}", self.file, self.line, self.msg)
    }
}

impl std::error::Error for CompileError {}

pub type Result<T> = std::result::Result<T, CompileError>;
