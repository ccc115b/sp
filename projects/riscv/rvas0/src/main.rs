mod assembler;
mod elf;
mod expr;
mod insts;
mod isa;
mod lexer;
mod parser;
mod regs;

use isa::{Mabi, parse_isa};

fn usage() -> ! {
    eprintln!("Usage: rvas [options] file.s...");
    eprintln!("Options:");
    eprintln!("  -o FILE            output object file (default: <file>.o)");
    eprintln!("  -march=ISA         rv32i/rv64i[/m/a/f/d/c][_zicsr][_zifencei] (default rv64i)");
    eprintln!("  -mabi=ABI          ilp32/ilp32f/ilp32d/lp64/lp64f/lp64d (default lp64)");
    eprintln!("  -I DIR             add directory to .include search path");
    eprintln!("  -D SYM[=VAL]       define symbol (default 1)");
    eprintln!("  --help             show this help");
    eprintln!("  --version          show version");
    std::process::exit(1);
}

fn main() {
    let args: Vec<String> = std::env::args().skip(1).collect();
    let mut out_path: Option<String> = None;
    let mut march: Option<String> = None;
    let mut mabi_str: Option<String> = None;
    let mut include_dirs: Vec<String> = Vec::new();
    let mut inputs: Vec<String> = Vec::new();
    let mut defsyms: Vec<(String, i128)> = Vec::new();

    let mut i = 0;
    while i < args.len() {
        let a = &args[i];
        match a.as_str() {
            "--help" | "-h" => {
                println!("rvas 0.1.0 - a small RISC-V assembler (RV32/RV64, ELF output)");
                usage();
            }
            "--version" => {
                println!("rvas 0.1.0");
                std::process::exit(0);
            }
            "-o" => {
                i += 1;
                out_path = Some(args.get(i).cloned().unwrap_or_else(|| usage()));
            }
            "-I" => {
                i += 1;
                include_dirs.push(args.get(i).cloned().unwrap_or_else(|| usage()));
            }
            "-march" => {
                i += 1;
                march = Some(args.get(i).cloned().unwrap_or_else(|| usage()));
            }
            "-mabi" => {
                i += 1;
                mabi_str = Some(args.get(i).cloned().unwrap_or_else(|| usage()));
            }
            "-g" | "-w" | "-fPIC" | "-fpic" | "-fno-pic" | "--no-pad-sections" => {}
            "-D" => {
                i += 1;
                let d = args.get(i).cloned().unwrap_or_else(|| usage());
                push_defsym(&mut defsyms, &d);
            }
            _ => {
                if let Some(v) = a.strip_prefix("--defsym=") {
                    push_defsym(&mut defsyms, v);
                } else if let Some(v) = a.strip_prefix("-march=") {
                    march = Some(v.to_string());
                } else if let Some(v) = a.strip_prefix("-mabi=") {
                    mabi_str = Some(v.to_string());
                } else if let Some(v) = a.strip_prefix("-o") {
                    out_path = Some(v.to_string());
                } else if let Some(v) = a.strip_prefix("-I") {
                    include_dirs.push(v.to_string());
                } else if a.starts_with('-') && a.len() > 1 {
                    eprintln!("rvas: warning: ignoring unknown option '{}'", a);
                } else {
                    inputs.push(a.clone());
                }
            }
        }
        i += 1;
    }

    if inputs.is_empty() {
        eprintln!("rvas: error: no input file");
        usage();
    }

    let march = march.unwrap_or_else(|| "rv64i".to_string());
    let spec = match parse_isa(&march) {
        Ok(s) => s,
        Err(e) => {
            eprintln!("rvas: error: {}", e);
            std::process::exit(1);
        }
    };
    let mabi = match mabi_str {
        Some(m) => match isa::parse_mabi(&m, spec.xlen) {
            Ok(m) => m,
            Err(e) => {
                eprintln!("rvas: error: {}", e);
                std::process::exit(1);
            }
        },
        None => if spec.xlen == 64 { Mabi::Soft } else { Mabi::Soft },
    };

    let mut sources: Vec<(String, String)> = Vec::new();
    for f in &inputs {
        let src = match std::fs::read_to_string(f) {
            Ok(s) => s,
            Err(e) => {
                eprintln!("rvas: error: cannot open '{}': {}", f, e);
                std::process::exit(1);
            }
        };
        let name = std::path::Path::new(f)
            .file_name()
            .map(|s| s.to_string_lossy().into_owned())
            .unwrap_or_else(|| f.clone());
        sources.push((src, name));
    }

    let result = assembler::parse_and_assemble(&sources, &include_dirs, spec, mabi, &defsyms);
    let (eflags, secs, syms, first_global, attrs) = match result {
        Ok(x) => x,
        Err(e) => {
            eprintln!("{}", e);
            std::process::exit(1);
        }
    };

    let out = out_path.unwrap_or_else(|| default_out(&inputs[0]));
    let xlen = if march.starts_with("rv32") { 32 } else { 64 };
    if let Err(e) = elf::write_elf(&out, xlen, eflags, &secs, &syms, first_global, attrs) {
        eprintln!("rvas: error: cannot write '{}': {}", out, e);
        std::process::exit(1);
    }
    let _ = defsyms;
}

fn push_defsym(v: &mut Vec<(String, i128)>, s: &str) {
    let (name, val) = match s.split_once('=') {
        Some((n, v)) => (n.to_string(), v.parse::<i128>().unwrap_or(1)),
        None => (s.to_string(), 1),
    };
    v.push((name, val));
}

fn default_out(input: &str) -> String {
    let p = std::path::Path::new(input);
    let stem = p.file_stem().map(|s| s.to_string_lossy().into_owned()).unwrap_or_else(|| "a".into());
    format!("{}.o", stem)
}
