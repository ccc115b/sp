/// Token --parse--> AST。結構與 Java 版的 record/class 一一對應。

#[derive(Clone, Debug)]
pub struct VarDecl {
    pub name: String,
    pub ty: String,
}

#[derive(Clone, Copy, PartialEq, Eq, Debug, Default)]
pub enum Kind {
    #[default]
    Function,
    Method,
    Constructor,
}

#[derive(Clone, Debug, Default)]
pub struct SubDecl {
    pub kind: Kind,
    pub ret: String,
    pub name: String,
    pub line: usize,
    pub params: Vec<VarDecl>,
    pub locals: Vec<VarDecl>,
    pub body: Vec<Stmt>,
}

impl SubDecl {
    /// constructor 的 JVM 方法名稱前面加 `$`。
    pub fn jvm_name(&self) -> String {
        match self.kind {
            Kind::Constructor => format!("${}", self.name),
            _ => self.name.clone(),
        }
    }
}

#[derive(Clone, Debug, Default)]
pub struct ClassDecl {
    pub name: String,
    pub file: String,
    pub jvm_name: String,
    pub builtin: bool,
    pub statics: Vec<VarDecl>,
    pub fields: Vec<VarDecl>,
    pub subs: Vec<SubDecl>,
}

#[derive(Clone, Debug)]
pub struct CallE {
    pub target: Option<String>,
    pub name: String,
    pub args: Vec<Expr>,
    pub line: usize,
}

#[derive(Clone, Debug)]
pub enum Stmt {
    Let { name: String, index: Option<Box<Expr>>, value: Box<Expr>, line: usize },
    If { cond: Box<Expr>, then: Vec<Stmt>, els: Option<Vec<Stmt>>, line: usize },
    While { cond: Box<Expr>, body: Vec<Stmt>, line: usize },
    Do { call: CallE, line: usize },
    Return { value: Option<Box<Expr>>, line: usize },
}

#[derive(Clone, Debug)]
pub enum Expr {
    IntC(i32),
    StrC(String),
    KwC(String),
    VarE { name: String, line: usize },
    IndexE { name: String, index: Box<Expr>, line: usize },
    Call(CallE),
    Bin { l: Box<Expr>, op: String, r: Box<Expr> },
    Un { op: String, e: Box<Expr> },
}
