//! jackc — Jack (nand2tetris) → JVM bytecode 編譯器,Rust 版。
//!
//! 流程: 原始碼 --lex--> Token --parse--> AST --codegen--> .class (version 50, 無 StackMapTable)
//! 語意對應與 Java 版相同,見 README.md。

mod ast;
mod classfile;
mod codegen;
mod codegen_ll;
mod error;
mod lexer;
mod parser;

use std::collections::HashMap;
use std::env;
use std::fs;
use std::path::{Path, PathBuf};
use std::process::{exit, Command};

use ast::{ClassDecl, Kind};
use codegen::Gen;
use error::{CompileError, Result};
use lexer::lex;
use parser::Parser;

/// Jack OS 的宣告(只有簽章,實作在 ../java/src/jack 的 jack.* 類別)。
const BUILTINS: &str = r#"
    class Math { function int multiply(int x, int y) {} function int divide(int x, int y) {}
                 function int min(int a, int b) {} function int max(int a, int b) {}
                 function int abs(int x) {} function int sqrt(int x) {} }
    class String { constructor String new(int maxLength) {}
                   method void dispose() {} method int length() {} method char charAt(int j) {}
                   method void setCharAt(int j, char c) {} method String appendChar(char c) {}
                   method void eraseLastChar() {} method int intValue() {} method void setInt(int j) {}
                   function char backSpace() {} function char doubleQuote() {} function char newLine() {} }
    class Output { function void printString(String s) {} function void printInt(int i) {}
                   function void println() {} function void printChar(char c) {}
                   function void backSpace() {} }
    class Sys { function void halt() {} function void error(int errorCode) {} function void wait(int duration) {} }
    class Memory { function Array alloc(int size) {} function void deAlloc(Object o) {} }
    class Array { constructor Array new(int size) {} method void dispose() {} }
    "#;

pub struct Compiled {
    /// (JVM 類別名稱, class 檔位元組),順序 = 原始檔順序。
    pub classes: Vec<(String, Vec<u8>)>,
    /// 是否有 `class Main { function ... main() }` 的橋接入口。
    pub has_main: bool,
}

/// @param sources (檔名, Jack 原始碼) 的清單。
/// 回傳 (全部類別表(含內建), 使用者類別清單)。
pub fn parse_all(sources: &[(String, String)]) -> Result<(HashMap<String, ClassDecl>, Vec<ClassDecl>)> {
    let mut classes: HashMap<String, ClassDecl> = HashMap::new();
    for mut c in Parser::new("<builtin>", lex("<builtin>", BUILTINS)?).parse_file()? {
        c.builtin = true;
        c.jvm_name =
            if c.name == "String" { "jack/JString".to_string() } else { format!("jack/{}", c.name) };
        classes.insert(c.name.clone(), c);
    }

    let mut user: Vec<ClassDecl> = Vec::new();
    for (file, src) in sources {
        for mut c in Parser::new(file.as_str(), lex(file, src)?).parse_file()? {
            if classes.contains_key(&c.name) {
                return Err(CompileError::new(
                    file,
                    1,
                    format!("class '{}' is already defined", c.name),
                ));
            }
            c.jvm_name = c.name.clone();
            classes.insert(c.name.clone(), c.clone());
            user.push(c);
        }
    }
    Ok((classes, user))
}

/// @param sources (檔名, Jack 原始碼) 的清單。
pub fn compile(sources: &[(String, String)]) -> Result<Compiled> {
    let (classes, user) = parse_all(sources)?;

    let mut gen = Gen::new(classes);
    let mut out = Vec::with_capacity(user.len());
    for c in &user {
        out.push((c.jvm_name.clone(), gen.gen_class(c)?));
    }

    let has_main = user.iter().any(|c| {
        c.name == "Main"
            && c.subs
                .iter()
                .any(|s| s.kind == Kind::Function && s.name == "main" && s.params.is_empty())
    });
    Ok(Compiled { classes: out, has_main })
}

/// 編譯成 LLVM IR(每個類別一個 .ll 模組)。
/// @return (類別名稱, IR 內容) 的清單,順序 = 原始檔順序。
pub fn compile_llvm(sources: &[(String, String)]) -> Result<Vec<(String, String)>> {
    let (classes, user) = parse_all(sources)?;
    let mut gen = codegen_ll::Gen::new(classes);
    gen.gen_module(&user)
}

fn usage() -> ! {
    eprint!(
        "Usage: jackc [-d outDir] [--llvm] [--run] <file.jack | dir> ...\n\
         \n\
         \x20 -d outDir   把產生的檔案寫到 outDir\n\
         \x20 --llvm      產生 LLVM IR(.ll)而不是 Java byte code(.class;\n\
         \x20             -d 預設為目前目錄;可用 clang/llc + Jack OS 的 C runtime 連結執行)\n\
         \x20 --run       編譯後用系統的 java 直接執行 Main.main()(不能與 --llvm 併用)\n"
    );
    exit(2);
}

/// 收集輸入: 目錄則取其中所有 .jack(排序),否則視為單一檔案。
fn collect_files(inputs: &[PathBuf]) -> Vec<PathBuf> {
    let mut files = Vec::new();
    for p in inputs {
        if p.is_dir() {
            let mut dir: Vec<PathBuf> = match fs::read_dir(p) {
                Ok(rd) => rd
                    .filter_map(|e| e.ok())
                    .map(|e| e.path())
                    .filter(|f| f.extension().is_some_and(|x| x == "jack"))
                    .collect(),
                Err(e) => {
                    eprintln!("error: cannot read {}: {e}", p.display());
                    exit(2);
                }
            };
            dir.sort();
            files.extend(dir);
        } else {
            files.push(p.clone());
        }
    }
    files
}

/// 尋找 Jack runtime 的相對路徑(以 cwd 與執行檔位置為起點向上找)。
const RUNTIME_RELS: &[&str] = &[
    "runtime",             // cwd = jack/rust
    "rust/runtime",        // cwd = jack 或 workspace 根
    "java/build",          // cwd = jack(build.sh 產出)
    "java/jackc.jar",      // cwd = jack(已打包的 runtime)
    "jack/rust/runtime",   // cwd = workspace 根
    "jack/java/build",
    "jack/java/jackc.jar",
];

/// 找 Jack runtime 的 classpath(需要 jack/JString.class 等,只在 --run 時用得到)。
fn find_runtime() -> Option<String> {
    if let Ok(v) = env::var("JACK_CLASSPATH") {
        if !v.is_empty() {
            return Some(v);
        }
    }
    let mut roots: Vec<PathBuf> = Vec::new();
    if let Ok(exe) = env::current_exe() {
        if let Some(d) = exe.parent() {
            roots.push(d.to_path_buf());
        }
    }
    if let Ok(cwd) = env::current_dir() {
        roots.push(cwd);
    }
    for root in roots {
        let mut dir = Some(root);
        for _ in 0..5 {
            let base = match dir {
                Some(d) => d,
                None => break,
            };
            for rel in RUNTIME_RELS {
                let p = base.join(rel);
                if has_runtime(&p) {
                    return Some(p.to_string_lossy().into_owned());
                }
            }
            dir = base.parent().map(|p| p.to_path_buf());
        }
    }
    None
}

fn has_runtime(p: &Path) -> bool {
    if p.extension().is_some_and(|e| e == "jar") {
        return p.is_file();
    }
    p.join("jack").join("JString.class").is_file()
}

/// 把 class 檔寫到暫存目錄,交給系統的 java 執行 Main.main(),回傳其結束碼。
fn run_with_jvm(classes: &[(String, Vec<u8>)], runtime: &str) -> i32 {
    let tmp = env::temp_dir().join(format!("jackc-run-{}", std::process::id()));
    if let Err(e) = fs::create_dir_all(&tmp) {
        eprintln!("error: cannot create {}: {e}", tmp.display());
        return 1;
    }
    for (name, bytes) in classes {
        if let Err(e) = fs::write(tmp.join(format!("{name}.class")), bytes) {
            eprintln!("error: cannot write {name}.class: {e}");
            let _ = fs::remove_dir_all(&tmp);
            return 1;
        }
    }
    let cp = format!("{}:{}", tmp.display(), runtime);
    let status = Command::new("java").arg("-cp").arg(&cp).arg("Main").status();
    let _ = fs::remove_dir_all(&tmp);
    match status {
        Ok(s) => s.code().unwrap_or(1),
        Err(e) => {
            eprintln!("error: cannot run java: {e}");
            1
        }
    }
}

fn main() {
    let args: Vec<String> = env::args().skip(1).collect();
    let mut out_dir: Option<String> = None;
    let mut run = false;
    let mut llvm = false;
    let mut inputs: Vec<PathBuf> = Vec::new();
    let mut i = 0;
    while i < args.len() {
        match args[i].as_str() {
            "-d" => {
                i += 1;
                if i >= args.len() {
                    usage();
                }
                out_dir = Some(args[i].clone());
            }
            "--llvm" | "--ll" => llvm = true,
            "--run" => run = true,
            "-h" | "--help" => usage(),
            a => inputs.push(PathBuf::from(a)),
        }
        i += 1;
    }
    if inputs.is_empty() {
        usage();
    }

    let files = collect_files(&inputs);
    if files.is_empty() {
        eprintln!("no .jack files found");
        exit(2);
    }

    let mut sources: Vec<(String, String)> = Vec::new();
    for f in &files {
        let name = f.file_name().map(|s| s.to_string_lossy().into_owned())
            .unwrap_or_else(|| f.to_string_lossy().into_owned());
        match fs::read_to_string(f) {
            Ok(s) => sources.push((name, s)),
            Err(e) => {
                eprintln!("error: cannot read {}: {e}", f.display());
                exit(1);
            }
        }
    }

    if llvm && run {
        eprintln!("error: --llvm and --run cannot be used together");
        exit(2);
    }

    if llvm {
        let modules = match compile_llvm(&sources) {
            Ok(m) => m,
            Err(e) => {
                eprintln!("{e}");
                exit(1);
            }
        };
        let dir = out_dir.unwrap_or_else(|| ".".to_string());
        if let Err(e) = fs::create_dir_all(&dir) {
            eprintln!("error: cannot create {dir}: {e}");
            exit(1);
        }
        for (name, text) in &modules {
            if let Err(e) = fs::write(Path::new(&dir).join(format!("{name}.ll")), text) {
                eprintln!("error: cannot write {name}.ll: {e}");
                exit(1);
            }
        }
        eprintln!("wrote {} .ll file(s) to {}", modules.len(), dir);
        exit(0);
    }

    let compiled = match compile(&sources) {
        Ok(c) => c,
        Err(e) => {
            eprintln!("{e}");
            exit(1);
        }
    };

    if let Some(dir) = out_dir {
        if let Err(e) = fs::create_dir_all(&dir) {
            eprintln!("error: cannot create {dir}: {e}");
            exit(1);
        }
        for (name, bytes) in &compiled.classes {
            if let Err(e) = fs::write(Path::new(&dir).join(format!("{name}.class")), bytes) {
                eprintln!("error: cannot write {name}.class: {e}");
                exit(1);
            }
        }
        eprintln!(
            "wrote {} class file(s) to {}",
            compiled.classes.len(),
            dir
        );
    }

    if run {
        if !compiled.classes.iter().any(|(n, _)| n == "Main") {
            eprintln!("error: no class Main");
            exit(1);
        }
        if !compiled.has_main {
            eprintln!("error: Main has no 'function void main()'");
            exit(1);
        }
        let runtime = match find_runtime() {
            Some(r) => r,
            None => {
                eprintln!("error: Jack runtime classes not found (jack/JString.class ...)");
                eprintln!("       run ./build.sh first, or set JACK_CLASSPATH");
                exit(1);
            }
        };
        exit(run_with_jvm(&compiled.classes, &runtime));
    }
}
