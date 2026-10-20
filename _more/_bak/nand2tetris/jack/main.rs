// jack：Jack → VM 編譯器（命令列與模組宣告）。
//   tokenizer.rs  切字（Kind / Token / Error / tokenize / report_errors）
//   symbols.rs    符號表（Seg / Symbols）
//   vm.rs         VM 指令的拼字規則
//   parser.rs     語法分析，邊解析邊產生 VM 碼
//
// rustc 只要看到 `mod xxx;` 就會去找同目錄的 `xxx.rs`，不需要 cargo。
mod parser;
mod symbols;
mod tokenizer;
mod vm;

use std::env;
use std::fs;
use std::path::{Path, PathBuf};
use std::process::exit;

/// 讀檔後交給 parser 編譯；有錯誤時回傳 None（不會輸出 .vm）
fn compile(path: &Path) -> Option<String> {
    let file = path.display().to_string();
    let src = fs::read_to_string(path).unwrap_or_else(|e| {
        eprintln!("{}: {}", file, e);
        exit(1);
    });
    parser::compile(&file, &src)
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
    match compile(input) {
        Some(vm) => write_vm(&vm, &out),
        None => exit(1),
    }
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
        match compile(f) {
            Some(vm) => write_vm(&vm, &out),
            None => exit(1),
        }
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
