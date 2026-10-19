// vm2asm：VM → Hack 組合語言轉譯器。
// 吃 .vm（單檔或一整個資料夾），吐 .asm（可直接餵給 hackasm）。
//
// 本專案的 VM 方言 = 標準 nand2tetris VM + mul / div 兩道指令
// （編譯器把 *、/ 直接編成 mul、div）。標準 VM 沒有這兩道，所以轉譯器
// 會在輸出尾端附上 __vm_mul / __vm_div 兩個以 VM 寫成、再一起轉譯的
// 輔助函式，把 mul / div 翻成 `call __vm_mul 2` / `call __vm_div 2`。
//
// 輸出開頭是 bootstrap：SP=256，call Sys.init 0，然後無窮迴圈。
// 所以被轉譯的程式必須定義 Sys.init。
use std::env;
use std::fs;
use std::path::Path;
use std::process::exit;

/// 以 VM 寫成的 helper，會被同一套轉譯器一起轉成組合語言。
const HELPERS: &str = "\
function __vm_abs 0
push argument 0
push constant 0
lt
if-goto ABS_NEG
push argument 0
return
label ABS_NEG
push argument 0
neg
return
function __vm_mul 4
push constant 0
pop local 0
push argument 0
pop local 1
push constant 0
pop local 2
push constant 1
pop local 3
label MUL_LOOP
push local 2
push constant 16
lt
if-goto MUL_BODY
goto MUL_END
label MUL_BODY
push argument 1
push local 3
and
if-goto MUL_ADD
goto MUL_SKIP
label MUL_ADD
push local 0
push local 1
add
pop local 0
label MUL_SKIP
push local 1
push local 1
add
pop local 1
push local 3
push local 3
add
pop local 3
push local 2
push constant 1
add
pop local 2
goto MUL_LOOP
label MUL_END
push local 0
return
function __vm_div 5
push argument 0
call __vm_abs 1
pop local 0
push argument 1
call __vm_abs 1
pop local 1
push argument 0
push constant 0
lt
push argument 1
push constant 0
lt
eq
not
pop local 2
push local 1
push constant 0
eq
if-goto DIV_ZERO
push local 1
push local 0
gt
if-goto DIV_ZERO
goto DIV_GO
label DIV_ZERO
push constant 0
return
label DIV_GO
push local 0
push local 1
push local 1
add
call __vm_div 2
pop local 3
push local 3
push local 3
add
pop local 4
push local 0
push constant 2
push local 3
call __vm_mul 2
push local 1
call __vm_mul 2
sub
push local 1
lt
if-goto DIV_DONE
push local 4
push constant 1
add
pop local 4
label DIV_DONE
push local 2
if-goto DIV_NEG
push local 4
return
label DIV_NEG
push local 4
neg
return
";

struct T {
    out: String,
    cmp: usize,
    ret: usize,
    func: String,
    prefix: String,
}

impl T {
    fn new() -> T {
        T {
            out: String::new(),
            cmp: 0,
            ret: 0,
            func: String::new(),
            prefix: String::new(),
        }
    }

    fn line(&mut self, s: &str) {
        self.out.push_str(s);
        self.out.push('\n');
    }

    // 把 D 推上堆疊（4 道指令：SP 先加一，A 退回原位置再寫入）
    fn push_d(&mut self) {
        self.line("@SP");
        self.line("AM=M+1");
        self.line("A=A-1");
        self.line("M=D");
    }

    fn push_const(&mut self, n: u16) {
        // 0 / 1 太常見了，不必先載入 D
        if n <= 1 {
            self.line("@SP");
            self.line("AM=M+1");
            self.line("A=A-1");
            self.line(&format!("M={}", n));
            return;
        }
        self.line(&format!("@{}", n));
        self.line("D=A");
        self.push_d();
    }

    fn push_abs(&mut self, addr: &str) {
        self.line(&format!("@{}", addr));
        self.line("D=M");
        self.push_d();
    }

    fn pop_abs(&mut self, addr: &str) {
        self.line("@SP");
        self.line("AM=M-1");
        self.line("D=M");
        self.line(&format!("@{}", addr));
        self.line("M=D");
    }

    // 從 base+idx 推上堆疊（base 是 LCL/ARG/THIS/THAT）
    fn push_seg(&mut self, base: &str, idx: u16) {
        if idx == 0 {
            // 位址 = *base（base 存的是基底位址）
            self.line(&format!("@{}", base));
            self.line("A=M");
            self.line("D=M");
        } else {
            self.line(&format!("@{}", idx));
            self.line("D=A");
            self.line(&format!("@{}", base));
            self.line("A=D+M");
            self.line("D=M");
        }
        self.push_d();
    }

    fn pop_seg(&mut self, base: &str, idx: u16) {
        if idx == 0 {
            self.line(&format!("@{}", base));
            self.line("D=M");
        } else {
            self.line(&format!("@{}", idx));
            self.line("D=A");
            self.line(&format!("@{}", base));
            self.line("D=D+M");
        }
        self.line("@R13");
        self.line("M=D");
        self.line("@SP");
        self.line("AM=M-1");
        self.line("D=M");
        self.line("@R13");
        self.line("A=M");
        self.line("M=D");
    }

    fn push_cmd(&mut self, seg: &str, idx: u16) {
        match seg {
            "constant" => self.push_const(idx),
            "local" => self.push_seg("LCL", idx),
            "argument" => self.push_seg("ARG", idx),
            "this" => self.push_seg("THIS", idx),
            "that" => self.push_seg("THAT", idx),
            "temp" => self.push_abs(&(5 + idx).to_string()),
            "pointer" => self.push_abs(&(3 + idx).to_string()),
            "static" => self.push_abs(&format!("{}.{}", self.prefix, idx)),
            _ => die(&format!("push 不認得的區段 '{}'", seg)),
        }
    }

    fn pop_cmd(&mut self, seg: &str, idx: u16) {
        match seg {
            "constant" => die("pop constant 不合法"),
            "local" => self.pop_seg("LCL", idx),
            "argument" => self.pop_seg("ARG", idx),
            "this" => self.pop_seg("THIS", idx),
            "that" => self.pop_seg("THAT", idx),
            "temp" => self.pop_abs(&(5 + idx).to_string()),
            "pointer" => self.pop_abs(&(3 + idx).to_string()),
            "static" => self.pop_abs(&format!("{}.{}", self.prefix, idx)),
            _ => die(&format!("pop 不認得的區段 '{}'", seg)),
        }
    }

    // 二元運算：堆疊 … x y → … (x op y)
    fn bin(&mut self, comp: &str) {
        self.line("@SP");
        self.line("AM=M-1");
        self.line("D=M");
        self.line("A=A-1");
        self.line(&format!("M={}", comp));
    }

    // 比較：成立寫 -1、否則 0
    fn cmp(&mut self, jump: &str) {
        let k = self.cmp;
        self.cmp += 1;
        self.line("@SP");
        self.line("AM=M-1");
        self.line("D=M");
        self.line("A=A-1");
        self.line("D=M-D");
        self.line(&format!("@__CMP_TRUE_{}", k));
        self.line(&format!("D;{}", jump));
        self.line("@SP");
        self.line("A=M-1");
        self.line("M=0");
        self.line(&format!("@__CMP_CONT_{}", k));
        self.line("0;JMP");
        self.line(&format!("(__CMP_TRUE_{})", k));
        self.line("@SP");
        self.line("A=M-1");
        self.line("M=-1");
        self.line(&format!("(__CMP_CONT_{})", k));
    }

    fn call(&mut self, f: &str, n: u16) {
        let k = self.ret;
        self.ret += 1;
        self.line(&format!("@__RET_{}", k));
        self.line("D=A");
        self.push_d();
        for base in ["LCL", "ARG", "THIS", "THAT"] {
            self.line(&format!("@{}", base));
            self.line("D=M");
            self.push_d();
        }
        // ARG = SP - 5 - n
        self.line("@SP");
        self.line("D=M");
        self.line("@5");
        self.line("D=D-A");
        if n != 0 {
            self.line(&format!("@{}", n));
            self.line("D=D-A");
        }
        self.line("@ARG");
        self.line("M=D");
        // LCL = SP
        self.line("@SP");
        self.line("D=M");
        self.line("@LCL");
        self.line("M=D");
        self.line(&format!("@{}", f));
        self.line("0;JMP");
        self.line(&format!("(__RET_{})", k));
    }

    fn ret(&mut self) {
        self.line("@LCL");
        self.line("D=M");
        self.line("@R13");
        self.line("M=D");
        self.line("@5");
        self.line("A=D-A");
        self.line("D=M");
        self.line("@R14");
        self.line("M=D");
        self.line("@SP");
        self.line("AM=M-1");
        self.line("D=M");
        self.line("@ARG");
        self.line("A=M");
        self.line("M=D");
        self.line("@ARG");
        self.line("D=M+1");
        self.line("@SP");
        self.line("M=D");
        for base in ["THAT", "THIS", "ARG", "LCL"] {
            self.line("@R13");
            self.line("AM=M-1");
            self.line("D=M");
            self.line(&format!("@{}", base));
            self.line("M=D");
        }
        self.line("@R14");
        self.line("A=M");
        self.line("0;JMP");
    }

    fn label_name(&self, name: &str) -> String {
        let f = if self.func.is_empty() { "global" } else { &self.func };
        format!("{}${}", f, name)
    }

    fn bootstrap(&mut self) {
        self.line("@256");
        self.line("D=A");
        self.line("@SP");
        self.line("M=D");
        self.call("Sys.init", 0);
        self.line("(__BOOT_HALT)");
        self.line("@__BOOT_HALT");
        self.line("0;JMP");
    }

    fn translate(&mut self, text: &str) {
        for (idx, raw) in text.lines().enumerate() {
            let line = match raw.find("//") {
                Some(p) => &raw[..p],
                None => raw,
            };
            let mut it = line.split_whitespace();
            let cmd = match it.next() {
                Some(c) => c,
                None => continue,
            };
            self.line(&format!("// {}", raw.trim()));
            match cmd {
                "push" => {
                    let seg = take(&mut it, idx + 1, cmd).to_string();
                    let i: u16 = take(&mut it, idx + 1, cmd)
                        .parse()
                        .unwrap_or_else(|_| die(&format!("第 {} 行: push 的索引不是數字", idx + 1)));
                    self.push_cmd(&seg, i);
                }
                "pop" => {
                    let seg = take(&mut it, idx + 1, cmd).to_string();
                    let i: u16 = take(&mut it, idx + 1, cmd)
                        .parse()
                        .unwrap_or_else(|_| die(&format!("第 {} 行: pop 的索引不是數字", idx + 1)));
                    self.pop_cmd(&seg, i);
                }
                "add" => self.bin("D+M"),
                "sub" => self.bin("M-D"),
                "and" => self.bin("D&M"),
                "or" => self.bin("D|M"),
                "neg" => {
                    self.line("@SP");
                    self.line("A=M-1");
                    self.line("M=-M");
                }
                "not" => {
                    self.line("@SP");
                    self.line("A=M-1");
                    self.line("M=!M");
                }
                "eq" => self.cmp("JEQ"),
                "gt" => self.cmp("JGT"),
                "lt" => self.cmp("JLT"),
                "mul" => self.call("__vm_mul", 2),
                "div" => self.call("__vm_div", 2),
                "label" => {
                    let name = take(&mut it, idx + 1, cmd).to_string();
                    let l = self.label_name(&name);
                    self.line(&format!("({})", l));
                }
                "goto" => {
                    let name = take(&mut it, idx + 1, cmd).to_string();
                    let l = self.label_name(&name);
                    self.line(&format!("@{}", l));
                    self.line("0;JMP");
                }
                "if-goto" => {
                    let name = take(&mut it, idx + 1, cmd).to_string();
                    let l = self.label_name(&name);
                    self.line("@SP");
                    self.line("AM=M-1");
                    self.line("D=M");
                    self.line(&format!("@{}", l));
                    self.line("D;JNE");
                }
                "function" => {
                    let name = take(&mut it, idx + 1, cmd).to_string();
                    let k: u16 = take(&mut it, idx + 1, cmd)
                        .parse()
                        .unwrap_or_else(|_| die(&format!("第 {} 行: function 的區域數不是數字", idx + 1)));
                    self.func = name.clone();
                    self.line(&format!("({})", name));
                    for _ in 0..k {
                        self.push_const(0);
                    }
                }
                "call" => {
                    let name = take(&mut it, idx + 1, cmd).to_string();
                    let n: u16 = take(&mut it, idx + 1, cmd)
                        .parse()
                        .unwrap_or_else(|_| die(&format!("第 {} 行: call 的參數數不是數字", idx + 1)));
                    self.call(&name, n);
                }
                "return" => self.ret(),
                other => die(&format!("第 {} 行: 不認得的指令 '{}'", idx + 1, other)),
            }
        }
    }
}

fn die(msg: &str) -> ! {
    eprintln!("vm2asm: error: {}", msg);
    exit(1);
}

fn take<'a>(it: &mut std::str::SplitWhitespace<'a>, line_no: usize, cmd: &str) -> &'a str {
    it.next()
        .unwrap_or_else(|| die(&format!("第 {} 行: {} 少了參數", line_no, cmd)))
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 || args.len() > 3 {
        eprintln!("用法: vm2asm <in.vm | 資料夾> [out.asm]");
        exit(2);
    }
    let input = &args[1];
    let p = Path::new(input);

    // 收集 (static 前置字串, VM 內容)
    let mut files: Vec<(String, String)> = Vec::new();
    if p.is_dir() {
        let mut entries: Vec<_> = fs::read_dir(p)
            .unwrap_or_else(|e| die(&format!("{}: {}", input, e)))
            .filter_map(|e| e.ok())
            .map(|e| e.path())
            .filter(|q| q.extension().map(|x| x == "vm").unwrap_or(false))
            .collect();
        entries.sort();
        if entries.is_empty() {
            die(&format!("{}: 資料夾裡沒有 .vm", input));
        }
        for q in entries {
            let stem = q.file_stem().unwrap().to_string_lossy().to_string();
            let text = fs::read_to_string(&q).unwrap_or_else(|e| die(&format!("{:?}: {}", q, e)));
            files.push((stem, text));
        }
    } else {
        let stem = p
            .file_stem()
            .map(|s| s.to_string_lossy().to_string())
            .unwrap_or_else(|| "out".to_string());
        let text = fs::read_to_string(p).unwrap_or_else(|e| die(&format!("{}: {}", input, e)));
        files.push((stem, text));
    }

    let output = match args.get(2) {
        Some(o) => o.clone(),
        None => {
            if p.is_dir() {
                format!("{}.asm", input.trim_end_matches('/'))
            } else {
                p.with_extension("asm").to_string_lossy().to_string()
            }
        }
    };

    let mut t = T::new();
    t.bootstrap();
    for (stem, text) in &files {
        t.prefix = stem.clone();
        t.func.clear();
        t.translate(text);
    }
    t.prefix = "__vm".to_string();
    t.func.clear();
    t.translate(HELPERS);

    fs::write(&output, &t.out).unwrap_or_else(|e| die(&format!("{}: {}", output, e)));
}
