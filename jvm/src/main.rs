//! jvm0 — 一個用 Rust 寫成的微型 JVM。
//!
//! 支援範圍（刻意縮小）：
//!   * 單一 .class 檔、`public static void main(String[])` 為入口
//!   * 型別：int / boolean / char / byte / short、String 常數、int[]
//!   * 指令：常數載入、區域變數、算術與位元運算、比較與分支、
//!           靜態方法呼叫（含遞迴）、int 陣列、System.out.print/println
//!   * 也能反組譯 bytecode（`-d`，javap -c 風格）
//!
//! 用法：jvm0 [-t|--trace] Foo.class
//!       jvm0 -d|--disasm Foo.class

use std::io::Write;
use std::rc::Rc;

use jvm0::classfile::ClassFile;
use jvm0::vm::{Value, Vm};
use jvm0::Res;

/// 執行 class 檔的 `main(String[])`。
fn run_file(path: &str, trace: bool) -> Res<()> {
    let data = std::fs::read(path).map_err(|e| format!("cannot read {path}: {e}"))?;
    let class = Rc::new(ClassFile::parse(&data)?);
    let main = class
        .find_method("main", "([Ljava/lang/String;)V")
        .ok_or("no `public static void main(String[])` found")?;
    if class.methods[main].access & 0x0008 == 0 {
        return Err("main is not static".into());
    }
    Vm::new(class, trace).invoke(main, vec![Value::Null])?;
    Ok(())
}

/// 反組譯 class 檔並印出。
fn disasm_file(path: &str) -> Res<()> {
    let data = std::fs::read(path).map_err(|e| format!("cannot read {path}: {e}"))?;
    let class = ClassFile::parse(&data)?;
    print!("{}", jvm0::disasm::disassemble(&class)?);
    Ok(())
}

fn main() {
    let mut trace = false;
    let mut disasm = false;
    let mut file = None;
    for a in std::env::args().skip(1) {
        match a.as_str() {
            "-t" | "--trace" => trace = true,
            "-d" | "--disasm" => disasm = true,
            _ => file = Some(a),
        }
    }
    let Some(file) = file else {
        eprintln!("usage: jvm0 [-t|--trace] <Class.class>");
        eprintln!("       jvm0 -d|--disasm <Class.class>");
        std::process::exit(2);
    };

    // 遞迴深度大時需要較大的 Rust stack
    let h = std::thread::Builder::new()
        .stack_size(256 * 1024 * 1024)
        .spawn(move || {
            if disasm {
                disasm_file(&file)
            } else {
                run_file(&file, trace)
            }
        })
        .unwrap();
    let r = h.join().unwrap();
    std::io::stdout().flush().ok();
    if let Err(e) = r {
        eprintln!("Exception in thread \"main\" {e}");
        std::process::exit(1);
    }
}
