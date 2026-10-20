// vm-emu：堆疊機模擬器，把 ../jack 編譯器產生的 .vm 檔直接跑起來。
//
// 只管執行，不管編譯：讀 .vm → 逐指令執行 → Output.* 的動作印到 stdout。
// 因為 stdout 就是程式輸出，所以可以直接和 expected/out.txt 比對，
// 驗證「編譯器產生的 VM 碼」和「程式設計者想要的結果」一致。
//
// 我們的 VM 方言 = nand2tetris 標準 VM + mul / div 兩道指令。
// （標準 VM 沒有乘除，編譯器會把 * 和 / 編成 call Math.multiply / Math.divide；
//   本專案為了少寫一個 Math 類別，直接讓 VM 支援 mul/div。）
use std::collections::HashMap;
use std::env;
use std::fs;
use std::process::exit;

const RAM_SIZE: usize = 32768;
const HEAP_START: usize = 2048;
const STATIC_BASE: usize = 16;

const SP: usize = 0;
const LCL: usize = 1;
const ARG: usize = 2;
const THIS: usize = 3;
const THAT: usize = 4;

const TRUE: i16 = -1;
const MAX_STEPS: u64 = 10_000_000;

#[derive(Clone, Debug)]
enum Cmd {
    Push(String, usize),
    Pop(String, usize),
    Arith(String),
    /// label 在執行期是空指令，位置已在載入時記進 labels
    Label,
    Goto(String),
    IfGoto(String),
    Function(usize),
    Call(String, usize),
    Return,
}

/// 一道指令連同它的原始碼行號，出錯時才報得出正確的行
#[derive(Clone)]
struct Instr {
    line: usize,
    cmd: Cmd,
}

struct Program {
    file: String,
    cmds: Vec<Instr>,
    /// 函式名稱 → 該 function 指令的 index
    funcs: HashMap<String, usize>,
    /// "函式$標籤" → 該 label 指令的 index
    labels: HashMap<String, usize>,
    /// 檔案裡第一個定義的函式，當作入口
    entry: String,
}

fn die(at: &str, msg: &str) -> ! {
    eprintln!("{}: {}", at, msg);
    exit(1);
}

/// 載入 .vm：第一趟把 function / label 的位置記下來，第二趟才執行
fn load(file: &str, src: &str) -> Program {
    let mut cmds: Vec<Instr> = Vec::new();
    let mut funcs: HashMap<String, usize> = HashMap::new();
    let mut labels: HashMap<String, usize> = HashMap::new();
    let mut entry = String::new();
    let mut cur = String::new();
    for (lineno, raw) in src.lines().enumerate() {
        let at = format!("{}:{}", file, lineno + 1);
        let line = match raw.find("//") {
            Some(p) => &raw[..p],
            None => raw,
        };
        let t: Vec<&str> = line.split_whitespace().collect();
        if t.is_empty() {
            continue;
        }
        let pc = cmds.len();
        let arg = |i: usize| -> usize {
            match t.get(i).and_then(|s| s.parse::<usize>().ok()) {
                Some(n) => n,
                None => die(&at, &format!("{} 需要一個非負整數參數", t[0])),
            }
        };
        let cmd = match t[0] {
            "function" => {
                if t.len() != 3 {
                    die(&at, "function 的格式是 <名稱> <區域變數個數>");
                }
                cur = t[1].to_string();
                if entry.is_empty() {
                    entry = cur.clone();
                }
                funcs.insert(cur.clone(), pc);
                Cmd::Function(arg(2))
            }
            "call" => {
                if t.len() != 3 {
                    die(&at, "call 的格式是 <名稱> <參數個數>");
                }
                Cmd::Call(t[1].to_string(), arg(2))
            }
            "label" => {
                labels.insert(format!("{}${}", cur, t[1]), pc);
                Cmd::Label
            }
            "goto" => Cmd::Goto(format!("{}${}", cur, t[1])),
            "if-goto" => Cmd::IfGoto(format!("{}${}", cur, t[1])),
            "push" => Cmd::Push(t[1].to_string(), arg(2)),
            "pop" => Cmd::Pop(t[1].to_string(), arg(2)),
            "return" => Cmd::Return,
            op @ ("add" | "sub" | "neg" | "eq" | "gt" | "lt" | "and" | "or" | "not"
            | "mul" | "div") => Cmd::Arith(op.to_string()),
            other => die(&at, &format!("不認得的 VM 指令 '{}'", other)),
        };
        cmds.push(Instr { line: lineno + 1, cmd });
    }
    if entry.is_empty() {
        die(file, "檔案裡沒有任何 function，無法決定執行入口");
    }
    Program { file: file.to_string(), cmds, funcs, labels, entry }
}

struct Machine {
    ram: Vec<i16>,
    heap: usize,
    prog: Program,
    halted: bool,
    /// 設環境變數 TRACE=1 會把每一步印到 stderr，方便追程式
    trace: bool,
}

impl Machine {
    fn push(&mut self, v: i16) {
        let sp = self.ram[SP] as usize;
        if sp + 1 >= RAM_SIZE {
            die(&self.prog.file, "堆疊爆了（SP 超出 RAM）");
        }
        self.ram[sp] = v;
        self.ram[SP] = (sp + 1) as i16;
    }

    fn pop(&mut self) -> i16 {
        let sp = self.ram[SP] as usize;
        if sp == 0 {
            die(&self.prog.file, "堆疊空了（SP 已是 0）");
        }
        self.ram[SP] = (sp - 1) as i16;
        self.ram[sp - 1]
    }

    /// 堆積：只配置不回收的 bump allocator
    fn alloc(&mut self, n: usize) -> usize {
        let base = self.heap;
        self.heap += n;
        if self.heap >= RAM_SIZE {
            die(&self.prog.file, "堆積不足（heap 撞到 RAM 頂端）");
        }
        base
    }

    /// 各區段的基底位址。constant 沒有位址（直接就是值）
    fn addr(&self, seg: &str, idx: usize, at: &str) -> usize {
        let base = match seg {
            "argument" => self.ram[ARG] as usize,
            "local" => self.ram[LCL] as usize,
            "this" => self.ram[THIS] as usize,
            "that" => self.ram[THAT] as usize,
            "pointer" => {
                if idx > 1 {
                    die(at, "pointer 只有 0（this）與 1（that）");
                }
                THIS
            }
            "temp" => 5,
            "static" => STATIC_BASE,
            other => die(at, &format!("不認得的記憶體區段 '{}'", other)),
        };
        let a = base + idx;
        if a >= RAM_SIZE {
            die(at, &format!("位址 {} 超出 RAM", a));
        }
        a
    }

    fn arith(&mut self, op: &str) {
        if op == "neg" {
            let x = self.pop();
            self.push(x.wrapping_neg());
            return;
        }
        if op == "not" {
            let x = self.pop();
            self.push(!x);
            return;
        }
        let y = self.pop();
        let x = self.pop();
        let v = match op {
            "add" => x.wrapping_add(y),
            "sub" => x.wrapping_sub(y),
            "mul" => (x as i32 * y as i32) as i16,
            "div" => {
                if y == 0 {
                    die(&self.prog.file, "除以零");
                }
                (x as i32 / y as i32) as i16
            }
            "and" => x & y,
            "or" => x | y,
            "eq" => if x == y { TRUE } else { 0 },
            "gt" => if x > y { TRUE } else { 0 },
            "lt" => if x < y { TRUE } else { 0 },
            _ => die(&self.prog.file, &format!("不認得的運算 '{}'", op)),
        };
        self.push(v);
    }

    /// 內建 OS 函式：直接以 Rust 實作，回傳 true 表示已處理。
    ///
    /// 注意：**每個函式都要照呼叫慣例留一個回傳值在堆疊上**。
    /// 就算是 void 也要 push 0，因為呼叫端緊接著會 `pop temp 0` 丟掉它；
    /// 少 push 一次，堆疊就會一輪一輪往下漏。
    fn native(&mut self, name: &str, _args: usize) -> bool {
        match name {
            // 物件與陣列都只是「一塊連續記憶體」，指標就是起始位址
            "Memory.alloc" | "Array.new" => {
                let size = self.pop();
                let n = if size < 1 { 1 } else { size as usize };
                let base = self.alloc(n);
                self.push(base as i16);
            }
            // 記憶體配置第一格放長度，字元接在後面
            "String.new" => {
                let max_len = self.pop();
                let n = if max_len < 1 { 1 } else { max_len as usize };
                let base = self.alloc(n + 1);
                self.ram[base] = 0;
                self.push(base as i16);
            }
            // 回傳字串本身，所以 "abc" 可以一直 appendChar 下去
            "String.appendChar" => {
                let c = self.pop();
                let s = self.pop() as usize;
                let len = self.ram[s] as usize;
                if s + 1 + len >= RAM_SIZE {
                    die(&self.prog.file, "字串超出 RAM");
                }
                self.ram[s + 1 + len] = c;
                self.ram[s] = (len + 1) as i16;
                self.push(s as i16);
            }
            "Output.printInt" => {
                let v = self.pop();
                print!("{}", v);
                self.push(0);
            }
            "Output.printChar" => {
                let c = self.pop() as u8;
                print!("{}", c as char);
                self.push(0);
            }
            "Output.printString" => {
                let s = self.pop() as usize;
                let len = self.ram[s] as usize;
                for i in 0..len {
                    let c = self.ram[s + 1 + i] as u8;
                    print!("{}", c as char);
                }
                self.push(0);
            }
            "Output.println" => {
                println!();
                self.push(0);
            }
            "Math.multiply" => {
                let b = self.pop() as i32;
                let a = self.pop() as i32;
                self.push((a * b) as i16);
            }
            "Math.divide" => {
                let b = self.pop() as i32;
                let a = self.pop() as i32;
                self.push(if b == 0 { 0 } else { (a / b) as i16 });
            }
            "Sys.halt" => {
                self.push(0);
                self.halted = true;
            }
            "Sys.wait" => {
                self.pop();
                self.push(0);
            }
            _ => return false,
        }
        true
    }

    fn label_pc(&self, label: &str, at: &str) -> usize {
        match self.prog.labels.get(label) {
            Some(pc) => *pc,
            None => die(at, &format!("找不到標籤 '{}'", label)),
        }
    }

    fn step(&mut self, instr: Instr, pc: usize) -> usize {
        let at = format!("{}:{}", self.prog.file, instr.line);
        let cmd = instr.cmd;
        if self.trace {
            eprintln!(
                "pc={:<4} 行={:<4} {:<28} sp={} lcl={} arg={} this={} that={}",
                pc, instr.line, format!("{:?}", cmd), self.ram[SP], self.ram[LCL],
                self.ram[ARG], self.ram[THIS], self.ram[THAT]
            );
        }
        match cmd {
            Cmd::Push(seg, idx) => {
                let v = if seg == "constant" {
                    idx as i16
                } else {
                    let a = self.addr(&seg, idx, &at);
                    self.ram[a]
                };
                self.push(v);
                pc + 1
            }
            Cmd::Pop(seg, idx) => {
                if seg == "constant" {
                    die(&at, "不能 pop 到 constant");
                }
                let v = self.pop();
                let a = self.addr(&seg, idx, &at);
                self.ram[a] = v;
                pc + 1
            }
            Cmd::Arith(op) => {
                self.arith(&op);
                pc + 1
            }
            Cmd::Label => pc + 1,
            Cmd::Goto(l) => self.label_pc(&l, &at),
            Cmd::IfGoto(l) => {
                if self.pop() != 0 {
                    self.label_pc(&l, &at)
                } else {
                    pc + 1
                }
            }
            // function f n：進來時把 n 個區域變數清成 0
            Cmd::Function(n) => {
                for _ in 0..n {
                    self.push(0);
                }
                pc + 1
            }
            Cmd::Call(name, args) => {
                let ret = pc + 1;
                if self.native(&name, args) {
                    return ret;
                }
                let target = match self.prog.funcs.get(&name) {
                    Some(t) => *t,
                    None => die(&at, &format!("找不到函式 '{}'", name)),
                };
                // 標準 call 前置動作：存回傳位址與四個暫存器，再重設 ARG / LCL
                let frame = self.ram[SP] as usize;
                if frame < args {
                    die(&at, "堆疊上沒有足夠的參數");
                }
                self.push(ret as i16);
                let lcl = self.ram[LCL];
                let arg = self.ram[ARG];
                let this = self.ram[THIS];
                let that = self.ram[THAT];
                self.push(lcl);
                self.push(arg);
                self.push(this);
                self.push(that);
                self.ram[ARG] = (frame - args) as i16;
                self.ram[LCL] = self.ram[SP];
                target
            }
            Cmd::Return => {
                let frame = self.ram[LCL] as usize;
                if frame < 5 {
                    die(&at, "LCL 指到 frame 之外，return 找不到呼叫者");
                }
                let ret = self.ram[frame - 5];
                let v = self.pop();
                let arg = self.ram[ARG] as usize;
                self.ram[arg] = v;
                self.ram[SP] = (arg + 1) as i16;
                self.ram[THAT] = self.ram[frame - 1];
                self.ram[THIS] = self.ram[frame - 2];
                self.ram[ARG] = self.ram[frame - 3];
                self.ram[LCL] = self.ram[frame - 4];
                // 回傳位址 0 是入口的哨兵值：代表程式結束
                if ret == 0 {
                    self.halted = true;
                    return pc;
                }
                ret as usize
            }
        }
    }

    fn run(&mut self) {
        // 有 Sys.init 就用它當入口，否則用檔案裡第一個函式
        let entry = if self.prog.funcs.contains_key("Sys.init") {
            "Sys.init".to_string()
        } else {
            self.prog.entry.clone()
        };
        let target = self.prog.funcs[&entry];

        self.ram[SP] = 256;
        // 假裝有人在位址 0 呼叫入口函式；回傳到 0 就結束
        let frame = self.ram[SP] as usize;
        self.push(0);
        self.push(0);
        self.push(0);
        self.push(0);
        self.push(0);
        self.ram[ARG] = frame as i16;
        self.ram[LCL] = self.ram[SP];

        let mut pc = target;
        let mut steps: u64 = 0;
        while pc < self.prog.cmds.len() && !self.halted {
            steps += 1;
            if steps > MAX_STEPS {
                die(&self.prog.file, "執行步數過多，可能是無窮迴圈");
            }
            let instr = self.prog.cmds[pc].clone();
            pc = self.step(instr, pc);
        }
        if !self.halted && pc >= self.prog.cmds.len() {
            die(&self.prog.file, "指令跑到檔案尾端（缺少 return？）");
        }
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() != 2 {
        eprintln!("用法: jackvm <in.vm>");
        exit(2);
    }
    let file = &args[1];
    let src = fs::read_to_string(file).unwrap_or_else(|e| {
        eprintln!("{}: {}", file, e);
        exit(1);
    });
    let prog = load(file, &src);
    let mut m = Machine {
        ram: vec![0; RAM_SIZE],
        heap: HEAP_START,
        prog,
        halted: false,
        trace: env::var_os("TRACE").is_some(),
    };
    m.run();
}
