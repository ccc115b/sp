// hackemu：Hack CPU 模擬器。
// 吃 .hack（每行 16 個 0/1 的機器碼），在記憶體映射的 Hack 平台上執行，
// 執行完把「螢幕」（RAM 16384..24575）以文字畫到 stdout。
//
// 環境變數：
//   KEYS   鍵盤輸入（整數 scan code），第一次讀 RAM[24576] 時送出，之後歸 0
//   TRACE  設了就把每個指令印到 stderr
use std::env;
use std::fs;
use std::process::exit;

const RAM_SIZE: usize = 32768;
const SCREEN_BASE: u16 = 16384; // RAM[16384..24576]
const KBD: u16 = 24576;

fn die(msg: &str) -> ! {
    eprintln!("hackemu: error: {}", msg);
    exit(1);
}

/// splitmix64：把位址打散成一個偽隨機 64 位元權重（供記憶體摘要用）
fn splitmix64(seed: u64) -> u64 {
    let mut z = seed.wrapping_add(0x9E37_79B9_7F4A_7C15);
    z = (z ^ (z >> 30)).wrapping_mul(0xBF58_476D_1CE4_E5B9);
    z = (z ^ (z >> 27)).wrapping_mul(0x94D0_49BB_1331_11EB);
    z ^ (z >> 31)
}

/// 標準 Hack ALU：依 c 的 6 個控制位 (zx nx zy ny f no) 計算
fn alu(c: u16, x: u16, y: u16) -> u16 {
    let zx = (c >> 5) & 1 == 1;
    let nx = (c >> 4) & 1 == 1;
    let zy = (c >> 3) & 1 == 1;
    let ny = (c >> 2) & 1 == 1;
    let f = (c >> 1) & 1 == 1;
    let no = c & 1 == 1;

    let mut x = if zx { 0 } else { x };
    let mut y = if zy { 0 } else { y };
    if nx {
        x = !x;
    }
    if ny {
        y = !y;
    }
    let mut out = if f {
        x.wrapping_add(y)
    } else {
        x & y
    };
    if no {
        out = !out;
    }
    out
}

struct Cpu {
    a: u16,
    d: u16,
    pc: usize,
    ram: Vec<u16>,
    key: u16,
    key_delivered: bool,
    trace: bool,
}

impl Cpu {
    fn read(&mut self, addr: u16) -> u16 {
        if addr == KBD {
            // 第一次讀鍵盤時把按鍵送出，之後視為已放開
            if !self.key_delivered {
                self.key_delivered = true;
                return self.key;
            }
            return 0;
        }
        self.ram[addr as usize]
    }

    /// 執行一個指令，回傳 (下一個 PC, 若有寫入則附上 (位址, 舊值, 新值))
    fn step(&mut self, ins: u16) -> (usize, Option<(usize, u16, u16)>) {
        if ins & 0x8000 == 0 {
            // A 指令：把 15 位元常數載入 A
            self.a = ins & 0x7fff;
            return (self.pc + 1, None);
        }
        // C 指令
        let a = (ins >> 12) & 1 == 1;
        let c = (ins >> 6) & 0x3f;
        let d = (ins >> 3) & 0x07;
        let j = ins & 0x07;

        let y = if a { self.read(self.a) } else { self.a };
        let out = alu(c, self.d, y);

        // d1=A d2=D d3=M；M 的位址要用更新前的 A
        let addr = self.a;
        let mut change = None;
        if d & 4 != 0 {
            self.a = out;
        }
        if d & 2 != 0 {
            self.d = out;
        }
        if d & 1 != 0 {
            let i = addr as usize;
            let old = self.ram[i];
            if old != out {
                self.ram[i] = out;
                change = Some((i, old, out)); // 只有值真的變了才算改變
            }
        }

        // 依 out 的正負零決定跳不跳（j1=正 j2=零 j3=負）
        let neg = (out as i16) < 0;
        let zero = out == 0;
        let gt = !neg && !zero;
        let take = (j & 1 != 0 && gt) || (j & 2 != 0 && zero) || (j & 4 != 0 && neg);
        let next = if take {
            self.a as usize
        } else {
            self.pc + 1
        };
        (next, change)
    }
}

fn load(input: &str) -> Vec<u16> {
    let src = fs::read_to_string(input).unwrap_or_else(|e| die(&format!("{}: {}", input, e)));
    let mut rom = Vec::new();
    for (idx, raw) in src.lines().enumerate() {
        let line = match raw.find("//") {
            Some(p) => &raw[..p],
            None => raw,
        }
        .trim();
        if line.is_empty() {
            continue;
        }
        if line.len() != 16 || !line.bytes().all(|b| b == b'0' || b == b'1') {
            die(&format!("{}:{}: 不是 16 位元的機器碼: {:?}", input, idx + 1, raw));
        }
        rom.push(u16::from_str_radix(line, 2).unwrap());
    }
    if rom.is_empty() {
        die(&format!("{}: 沒有指令", input));
    }
    rom
}

/// 把螢幕內容畫成文字，裁到有畫東西的邊界框（bit 0 = 最左像素）
fn render(ram: &[u16]) -> String {
    let (mut min_r, mut max_r) = (256usize, -1i32);
    let (mut min_c, mut max_c) = (512usize, -1i32);
    for r in 0..256usize {
        for c in 0..512usize {
            let word = ram[SCREEN_BASE as usize + r * 32 + c / 16];
            if (word >> (c % 16)) & 1 == 1 {
                if r < min_r {
                    min_r = r;
                }
                if (r as i32) > max_r {
                    max_r = r as i32;
                }
                if c < min_c {
                    min_c = c;
                }
                if (c as i32) > max_c {
                    max_c = c as i32;
                }
            }
        }
    }
    if max_r < 0 {
        return String::new();
    }
    let mut out = String::new();
    for r in min_r..=max_r as usize {
        for c in min_c..=max_c as usize {
            let word = ram[SCREEN_BASE as usize + r * 32 + c / 16];
            out.push(if (word >> (c % 16)) & 1 == 1 { '#' } else { '.' });
        }
        out.push('\n');
    }
    out
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() != 2 {
        eprintln!("用法: hackemu <in.hack>");
        exit(2);
    }
    let rom = load(&args[1]);

    let key: u16 = match env::var("KEYS") {
        Ok(s) => s.trim().parse().unwrap_or_else(|_| die("KEYS 必須是整數")),
        Err(_) => 0,
    };

    let max_steps: u64 = match env::var("MAXSTEPS") {
        Ok(s) => s.trim().parse().unwrap_or_else(|_| die("MAXSTEPS 必須是整數")),
        // 預設上限：夠跑完 OS 初始化，又能擋住不會停的迴圈
        Err(_) => 50_000_000,
    };

    let mut cpu = Cpu {
        a: 0,
        d: 0,
        pc: 0,
        ram: vec![0; RAM_SIZE],
        key,
        key_delivered: false,
        trace: env::var("TRACE").is_ok(),
    };

    // 無限迴圈偵測：對每個 pc 記下上次的 (A, D, 記憶體摘要)。記憶體摘要用
    // 兩個 rolling checksum 增量維護（改一個字只花 O(1)），所以在同一 pc 上
    // (A, D) 與整份記憶體都回到原狀時就代表不會停——連會不斷翻動堆疊的
    // `while(true){}` 也抓得到。MAXSTEPS 只是最後的安全網。
    let mut last: Vec<Option<(u16, u16, u64, u64)>> = vec![None; rom.len()];
    let mut ram_hash1: u64 = 0;
    let mut ram_hash2: u64 = 0;
    let mut steps: u64 = 0;

    // 每個位址各配一個偽隨機權重，讓「任一格改變」幾乎不可能不改變摘要。
    let mut w1 = vec![0u64; RAM_SIZE];
    let mut w2 = vec![0u64; RAM_SIZE];
    for i in 0..RAM_SIZE {
        w1[i] = splitmix64(i as u64);
        w2[i] = splitmix64((i as u64) ^ 0xDEAD_BEEF_CAFE_BABE);
    }

    loop {
        if cpu.pc >= rom.len() {
            die(&format!("PC {} 超出 ROM 範圍（{} 道指令）", cpu.pc, rom.len()));
        }
        if cpu.trace {
            eprintln!(
                "pc={:<4} A={:<5} D={:<5} ins={:016b}",
                cpu.pc, cpu.a, cpu.d, rom[cpu.pc]
            );
        }
        if last[cpu.pc] == Some((cpu.a, cpu.d, ram_hash1, ram_hash2)) {
            eprintln!("hackemu: 已在自迴圈停住（pc={}, 已執行 {} 道指令）", cpu.pc, steps);
            break; // 狀態（含記憶體）完全重複 → 程式已停在預期的結束迴圈
        }
        last[cpu.pc] = Some((cpu.a, cpu.d, ram_hash1, ram_hash2));

        let ins = rom[cpu.pc];
        let (next, change) = cpu.step(ins);
        if let Some((addr, old, new)) = change {
            let du = (new as i64 - old as i64) as u64;
            ram_hash1 = ram_hash1.wrapping_add(du.wrapping_mul(w1[addr]));
            ram_hash2 = ram_hash2.wrapping_add(du.wrapping_mul(w2[addr]));
        }
        cpu.pc = next;

        steps += 1;
        if steps >= max_steps {
            eprintln!(
                "hackemu: 已執行 {} 道指令（到達步數上限），輸出目前螢幕",
                steps
            );
            break;
        }
    }

    if let Ok(spec) = env::var("DUMP") {
        for part in spec.split(',') {
            if let Ok(a) = part.trim().parse::<usize>() {
                if a < RAM_SIZE {
                    eprintln!("RAM[{}]={}", a, cpu.ram[a] as i16);
                }
            }
        }
    }

    print!("{}", render(&cpu.ram));
}
