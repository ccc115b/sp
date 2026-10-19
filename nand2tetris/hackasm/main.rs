// hackasm：Hack 組譯器。
// 吃 .asm（Hack 組合語言），吐出 .hack（每行 16 個 0/1 的機器碼）。
//
// 兩趟掃描：
//   第一趟 找出所有 (LABEL) 並記下它在 ROM 的位置
//   第二趟 產生機器碼；A 指令裡的符號查表，查不到就當變數配一個 RAM 位址
use std::collections::HashMap;
use std::env;
use std::fs;
use std::path::Path;
use std::process::exit;

fn die(file: &str, line: usize, msg: &str) -> ! {
    eprintln!("{}:{}: error: {}", file, line, msg);
    exit(1);
}

/// comp 欄位：名字 → (a 位元, c1..c6)
fn comp_table() -> HashMap<&'static str, (u16, u16)> {
    let mut m = HashMap::new();
    // a = 0，運算元用 A
    m.insert("0", (0, 0b101010));
    m.insert("1", (0, 0b111111));
    m.insert("-1", (0, 0b111010));
    m.insert("D", (0, 0b001100));
    m.insert("A", (0, 0b110000));
    m.insert("!D", (0, 0b001101));
    m.insert("!A", (0, 0b110001));
    m.insert("-D", (0, 0b001111));
    m.insert("-A", (0, 0b110011));
    m.insert("D+1", (0, 0b011111));
    m.insert("A+1", (0, 0b110111));
    m.insert("D-1", (0, 0b001110));
    m.insert("A-1", (0, 0b110010));
    m.insert("D+A", (0, 0b000010));
    m.insert("D-A", (0, 0b010011));
    m.insert("A-D", (0, 0b000111));
    m.insert("D&A", (0, 0b000000));
    m.insert("D|A", (0, 0b010101));
    // a = 1，運算元用 M（RAM[A]）
    m.insert("M", (1, 0b110000));
    m.insert("!M", (1, 0b110001));
    m.insert("-M", (1, 0b110011));
    m.insert("M+1", (1, 0b110111));
    m.insert("M-1", (1, 0b110010));
    m.insert("D+M", (1, 0b000010));
    m.insert("D-M", (1, 0b010011));
    m.insert("M-D", (1, 0b000111));
    m.insert("D&M", (1, 0b000000));
    m.insert("D|M", (1, 0b010101));
    m
}

/// dest 欄位：名字 → (d1 d2 d3)，其中 d1=A, d2=D, d3=M
fn dest_bits(name: &str) -> Option<u16> {
    let mut bits = 0;
    for c in name.chars() {
        bits |= match c {
            'A' => 0b100,
            'D' => 0b010,
            'M' => 0b001,
            _ => return None,
        };
    }
    Some(bits)
}

/// jump 欄位：名字 → (j1 j2 j3)
fn jump_bits(name: &str) -> Option<u16> {
    Some(match name {
        "JGT" => 0b001,
        "JEQ" => 0b010,
        "JGE" => 0b011,
        "JLT" => 0b100,
        "JNE" => 0b101,
        "JLE" => 0b110,
        "JMP" => 0b111,
        _ => return None,
    })
}

fn predefined() -> HashMap<String, u16> {
    let mut m = HashMap::new();
    for i in 0..16u16 {
        m.insert(format!("R{}", i), i);
    }
    m.insert("SP".to_string(), 0);
    m.insert("LCL".to_string(), 1);
    m.insert("ARG".to_string(), 2);
    m.insert("THIS".to_string(), 3);
    m.insert("THAT".to_string(), 4);
    m.insert("SCREEN".to_string(), 16384);
    m.insert("KBD".to_string(), 24576);
    m
}

/// 去掉 // 之後的註解
fn strip_comment(line: &str) -> &str {
    match line.find("//") {
        Some(p) => &line[..p],
        None => line,
    }
}

/// 去掉所有空白（Hack 的 C 指令允許寫成 "D = M + 1" 這種好讀的形式）
fn compact(line: &str) -> String {
    line.chars().filter(|c| !c.is_whitespace()).collect()
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 || args.len() > 3 {
        eprintln!("用法: hackasm <in.asm> [out.hack]");
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
            format!("{}.hack", stem)
        }
    };
    let src = fs::read_to_string(input).unwrap_or_else(|e| {
        eprintln!("{}: {}", input, e);
        exit(1);
    });

    let comps = comp_table();
    let mut symbols = predefined();

    // 第一趟：收集 label
    let mut rom: u16 = 0;
    for (idx, raw) in src.lines().enumerate() {
        let lineno = idx + 1;
        let line = strip_comment(raw).trim();
        if line.is_empty() {
            continue;
        }
        if let Some(inner) = line.strip_prefix('(') {
            let name = inner.strip_suffix(')').unwrap_or_else(|| {
                die(input, lineno, "label 少了結尾的 ')'");
            });
            if name.is_empty() || compact(name) != name {
                die(input, lineno, "label 名稱不合法（不可含空白或空字串）");
            }
            if symbols.contains_key(name) {
                die(input, lineno, &format!("重複定義的符號 '{}'", name));
            }
            symbols.insert(name.to_string(), rom);
        } else {
            rom = rom.checked_add(1).unwrap_or_else(|| {
                die(input, lineno, "指令數超過 ROM 大小（32768）");
            });
            if rom > 32768 {
                die(input, lineno, "指令數超過 ROM 大小（32768）");
            }
        }
    }

    // 第二趟：產生機器碼
    let mut out = String::new();
    let mut next_var: u16 = 16;
    for (idx, raw) in src.lines().enumerate() {
        let lineno = idx + 1;
        let line = compact(strip_comment(raw));
        if line.is_empty() || line.starts_with('(') {
            continue;
        }
        let bits = if let Some(sym) = line.strip_prefix('@') {
            // A 指令：@數字 或 @符號
            let value = if let Ok(n) = sym.parse::<i64>() {
                if !(0..=32767).contains(&n) {
                    die(input, lineno, &format!("位址 {} 超出 0..32767", n));
                }
                n as u16
            } else if let Some(v) = symbols.get(sym) {
                if *v > 32767 {
                    die(input, lineno, &format!("符號 '{}' 的位址 {} 超過 32767", sym, v));
                }
                *v
            } else {
                // 新變數：配一個 RAM 位址（從 16 起）
                if next_var > 16383 {
                    die(input, lineno, "變數位址超過 16383");
                }
                let v = next_var;
                next_var += 1;
                symbols.insert(sym.to_string(), v);
                v
            };
            format!("{:016b}", value)
        } else {
            // C 指令：dest=comp;jump（dest 與 jump 可省略）
            let (dest_part, rest) = match line.find('=') {
                Some(i) => (Some(&line[..i]), &line[i + 1..]),
                None => (None, line.as_str()),
            };
            let (comp_part, jump_part) = match rest.find(';') {
                Some(i) => (&rest[..i], Some(&rest[i + 1..])),
                None => (rest, None),
            };
            let (a, c) = match comps.get(comp_part) {
                Some(v) => *v,
                None => die(input, lineno, &format!("不認得的 comp '{}'", comp_part)),
            };
            let d = match dest_part {
                None => 0,
                Some(name) => match dest_bits(name) {
                    Some(v) => v,
                    None => die(input, lineno, &format!("不認得的 dest '{}'", name)),
                },
            };
            let j = match jump_part {
                None => 0,
                Some(name) => match jump_bits(name) {
                    Some(v) => v,
                    None => die(input, lineno, &format!("不認得的 jump '{}'", name)),
                },
            };
            let ins = 0b111_u16 << 13 | (a << 12) | (c << 6) | (d << 3) | j;
            format!("{:016b}", ins)
        };
        out.push_str(&bits);
        out.push('\n');
    }

    fs::write(&output, &out).unwrap_or_else(|e| {
        eprintln!("{}: {}", output, e);
        exit(1);
    });
}
