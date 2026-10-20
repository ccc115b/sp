// vm4.rs - C4 Virtual Machine in Rust
use std::convert::TryInto;
use std::env;
use std::fs::File;
use std::io::Read;

type Cell = i64;

#[allow(dead_code)]
mod op {
    pub const LEA: i64 = 0;
    pub const IMM: i64 = 1;
    pub const JMP: i64 = 2;
    pub const JSR: i64 = 3;
    pub const BZ: i64 = 4;
    pub const BNZ: i64 = 5;
    pub const ENT: i64 = 6;
    pub const ADJ: i64 = 7;
    pub const LEV: i64 = 8;
    pub const LI: i64 = 9;
    pub const LC: i64 = 10;
    pub const SI: i64 = 11;
    pub const SC: i64 = 12;
    pub const PSH: i64 = 13;
    pub const OR: i64 = 14;
    pub const XOR: i64 = 15;
    pub const AND: i64 = 16;
    pub const EQ: i64 = 17;
    pub const NE: i64 = 18;
    pub const LT: i64 = 19;
    pub const GT: i64 = 20;
    pub const LE: i64 = 21;
    pub const GE: i64 = 22;
    pub const SHL: i64 = 23;
    pub const SHR: i64 = 24;
    pub const ADD: i64 = 25;
    pub const SUB: i64 = 26;
    pub const MUL: i64 = 27;
    pub const DIV: i64 = 28;
    pub const MOD: i64 = 29;
    pub const OPEN: i64 = 30;
    pub const CREA: i64 = 31;
    pub const READ: i64 = 32;
    pub const WRIT: i64 = 33;
    pub const CLOS: i64 = 34;
    pub const PRTF: i64 = 35;
    pub const MALC: i64 = 36;
    pub const FREE: i64 = 37;
    pub const MSET: i64 = 38;
    pub const MCMP: i64 = 39;
    pub const EXIT: i64 = 40;
}

const OP_NAMES: [&str; 41] = [
    "LEA ", "IMM ", "JMP ", "JSR ", "BZ  ", "BNZ ", "ENT ", "ADJ ", "LEV ", "LI  ", "LC  ",
    "SI  ", "SC  ", "PSH ", "OR  ", "XOR ", "AND ", "EQ  ", "NE  ", "LT  ", "GT  ", "LE  ",
    "GE  ", "SHL ", "SHR ", "ADD ", "SUB ", "MUL ", "DIV ", "MOD ", "OPEN", "CREA", "READ",
    "WRIT", "CLOS", "PRTF", "MALC", "FREE", "MSET", "MCMP", "EXIT",
];

// 直接宣告 C libc API，不需要外部 libc crate
extern "C" {
    fn open(path: *const u8, flags: i32, ...) -> i32;
    fn creat(path: *const u8, mode: u32) -> i32;
    fn read(fd: i32, buf: *mut u8, count: usize) -> isize;
    fn write(fd: i32, buf: *const u8, count: usize) -> isize;
    fn close(fd: i32) -> i32;
    fn malloc(size: usize) -> *mut u8;
    fn free(ptr: *mut u8);
    fn memset(s: *mut u8, c: i32, n: usize) -> *mut u8;
    fn memcmp(s1: *const u8, s2: *const u8, n: usize) -> i32;
}

fn dump_asm(text: &[Cell], src: &str, line_info: &[Cell]) {
    let mut pc = 0;
    let lines: Vec<&str> = src.lines().collect();
    let mut cur_line: usize = 1;

    while pc < text.len() {
        let l = line_info[pc] as usize;
        while cur_line <= l && cur_line <= lines.len() {
            println!("{}: {}", cur_line, lines[cur_line - 1]);
            cur_line += 1;
        }

        let op = text[pc];
        print!("{}", OP_NAMES[op as usize]);
        pc += 1;
        if op <= op::ADJ {
            println!(" {}", text[pc]);
            pc += 1;
        } else {
            println!();
        }
    }
}

fn c4_printf(fmt_ptr: *const u8, args: &[Cell]) -> i32 {
    let mut s = String::new();
    let mut arg_idx = 0;
    unsafe {
        let mut p = fmt_ptr;
        while *p != 0 {
            if *p == b'%' {
                p = p.add(1);
                if *p == b'%' {
                    s.push('%');
                } else if *p == b's' {
                    let cstr = args[arg_idx] as *const u8;
                    arg_idx += 1;
                    let mut len = 0;
                    while *cstr.add(len) != 0 { len += 1; }
                    let bytes = std::slice::from_raw_parts(cstr, len);
                    s.push_str(&String::from_utf8_lossy(bytes));
                } else if *p == b'd' || *p == b'i' {
                    s.push_str(&args[arg_idx].to_string());
                    arg_idx += 1;
                } else if *p == b'c' {
                    s.push(args[arg_idx] as u8 as char);
                    arg_idx += 1;
                } else if *p == b'x' || *p == b'X' {
                    s.push_str(&format!("{:x}", args[arg_idx]));
                    arg_idx += 1;
                } else if *p == b'l' && *p.add(1) == b'l' && *p.add(2) == b'd' {
                    p = p.add(2);
                    s.push_str(&args[arg_idx].to_string());
                    arg_idx += 1;
                }
            } else {
                s.push(*p as char);
            }
            p = p.add(1);
        }
    }
    print!("{}", s);
    s.len() as i32
}

fn main() {
    let mut args: Vec<String> = env::args().collect();
    let mut src_flag = false;
    let mut debug_flag = false;

    args.remove(0);
    while !args.is_empty() && args[0].starts_with('-') {
        if args[0] == "-s" {
            src_flag = true;
            args.remove(0);
        } else if args[0] == "-d" {
            debug_flag = true;
            args.remove(0);
        } else {
            break;
        }
    }

    if args.is_empty() {
        eprintln!("usage: vm4 [-s] [-d] binary.c4b [args...]");
        std::process::exit(1);
    }

    let bin_path = &args[0];
    let mut f = File::open(bin_path).expect("could not open binary file");

    let mut header_buf = [0u8; 48];
    f.read_exact(&mut header_buf).expect("bad header");

    let mut header = [0i64; 6];
    for (i, chunk) in header_buf.chunks(8).enumerate() {
        header[i] = i64::from_le_bytes(chunk.try_into().unwrap());
    }

    if header[0] != 0x43344243 {
        eprintln!("invalid c4 bytecode file");
        std::process::exit(1);
    }

    let main_off = header[1] as usize;
    let text_words = header[2] as usize;
    let data_bytes = header[3] as usize;
    let rel_count = header[4] as usize;
    let src_len = header[5] as usize;

    let poolsz = 256 * 1024;
    let mut text: Vec<Cell> = vec![0; poolsz / 8];
    let mut data: Vec<u8> = vec![0; poolsz];
    let mut stack: Vec<Cell> = vec![0; poolsz / 8];
    let mut rel: Vec<Cell> = vec![0; rel_count];
    let mut line_info: Vec<Cell> = vec![0; text_words];
    let mut source_bytes = vec![0u8; src_len];

    let mut text_buf = vec![0u8; text_words * 8];
    f.read_exact(&mut text_buf).unwrap();
    for (i, chunk) in text_buf.chunks(8).enumerate() {
        text[i] = Cell::from_le_bytes(chunk.try_into().unwrap());
    }

    f.read_exact(&mut data[..data_bytes]).unwrap();

    let mut rel_buf = vec![0u8; rel_count * 8];
    f.read_exact(&mut rel_buf).unwrap();
    for (i, chunk) in rel_buf.chunks(8).enumerate() {
        rel[i] = Cell::from_le_bytes(chunk.try_into().unwrap());
    }

    let mut line_buf = vec![0u8; text_words * 8];
    f.read_exact(&mut line_buf).unwrap();
    for (i, chunk) in line_buf.chunks(8).enumerate() {
        line_info[i] = Cell::from_le_bytes(chunk.try_into().unwrap());
    }

    f.read_exact(&mut source_bytes).unwrap();
    let source_str = String::from_utf8_lossy(&source_bytes);

    if src_flag {
        dump_asm(&text[..text_words], &source_str, &line_info);
        return;
    }

    let data_base = data.as_mut_ptr() as Cell;
    let text_base = text.as_mut_ptr() as Cell;

    for r in &rel {
        let idx = (*r - 1) as usize;
        text[idx] = data_base + text[idx];
    }

    let mut p_code = 0;
    while p_code < text_words {
        let op = text[p_code];
        p_code += 1;
        if op <= op::ADJ {
            if op == op::JMP || op == op::JSR || op == op::BZ || op == op::BNZ {
                text[p_code] = text_base + (text[p_code] - 1) * 8;
            }
            p_code += 1;
        }
    }

    let mut pc = (text.as_mut_ptr() as Cell + ((main_off - 1) * 8) as Cell) as *mut Cell;
    let mut sp = (stack.as_mut_ptr() as Cell + poolsz as Cell) as *mut Cell;
    let mut bp = sp;
    let mut a: Cell = 0;
    let mut cycle: Cell = 0;

    let c_strings: Vec<std::ffi::CString> = args.iter()
        .map(|arg| std::ffi::CString::new(arg.as_bytes()).unwrap())
        .collect();
    let mut c_args: Vec<*const std::os::raw::c_char> = c_strings.iter()
        .map(|s| s.as_ptr())
        .collect();
    c_args.push(std::ptr::null());

    unsafe {
        sp = sp.sub(1); *sp = op::EXIT;
        sp = sp.sub(1); *sp = op::PSH;
        let t = sp;
        sp = sp.sub(1); *sp = (c_args.len() - 1) as Cell; // argc
        sp = sp.sub(1); *sp = c_args.as_ptr() as Cell;     // argv
        sp = sp.sub(1); *sp = t as Cell;

        loop {
            let i = *pc;
            pc = pc.add(1);
            cycle += 1;

            if debug_flag {
                print!("{}> {}", cycle, OP_NAMES[i as usize]);
                if i <= op::ADJ {
                    println!(" {}", *pc);
                } else {
                    println!();
                }
            }

            if i == op::LEA { a = bp.add(*pc as usize) as Cell; pc = pc.add(1); }
            else if i == op::IMM { a = *pc; pc = pc.add(1); }
            else if i == op::JMP { pc = *pc as *mut Cell; }
            else if i == op::JSR { sp = sp.sub(1); *sp = pc.add(1) as Cell; pc = *pc as *mut Cell; }
            else if i == op::BZ  { pc = if a != 0 { pc.add(1) } else { *pc as *mut Cell }; }
            else if i == op::BNZ { pc = if a != 0 { *pc as *mut Cell } else { pc.add(1) }; }
            else if i == op::ENT { sp = sp.sub(1); *sp = bp as Cell; bp = sp; sp = sp.sub(*pc as usize); pc = pc.add(1); }
            else if i == op::ADJ { sp = sp.add(*pc as usize); pc = pc.add(1); }
            else if i == op::LEV { sp = bp; bp = *sp as *mut Cell; sp = sp.add(1); pc = *sp as *mut Cell; sp = sp.add(1); }
            else if i == op::LI  { a = *(a as *const Cell); }
            else if i == op::LC  { a = *(a as *const u8) as Cell; }
            else if i == op::SI  { *(*sp as *mut Cell) = a; sp = sp.add(1); }
            else if i == op::SC  { *(*sp as *mut u8) = a as u8; sp = sp.add(1); }
            else if i == op::PSH { sp = sp.sub(1); *sp = a; }

            else if i == op::OR  { a = *sp | a; sp = sp.add(1); }
            else if i == op::XOR { a = *sp ^ a; sp = sp.add(1); }
            else if i == op::AND { a = *sp & a; sp = sp.add(1); }
            else if i == op::EQ  { a = (*sp == a) as Cell; sp = sp.add(1); }
            else if i == op::NE  { a = (*sp != a) as Cell; sp = sp.add(1); }
            else if i == op::LT  { a = (*sp < a) as Cell; sp = sp.add(1); }
            else if i == op::GT  { a = (*sp > a) as Cell; sp = sp.add(1); }
            else if i == op::LE  { a = (*sp <= a) as Cell; sp = sp.add(1); }
            else if i == op::GE  { a = (*sp >= a) as Cell; sp = sp.add(1); }
            else if i == op::SHL { a = *sp << a; sp = sp.add(1); }
            else if i == op::SHR { a = *sp >> a; sp = sp.add(1); }
            else if i == op::ADD { a = sp.read().wrapping_add(a); sp = sp.add(1); }
            else if i == op::SUB { a = sp.read().wrapping_sub(a); sp = sp.add(1); }
            else if i == op::MUL { a = sp.read().wrapping_mul(a); sp = sp.add(1); }
            else if i == op::DIV { a = *sp / a; sp = sp.add(1); }
            else if i == op::MOD { a = *sp % a; sp = sp.add(1); }

            else if i == op::OPEN { a = open(sp.add(1).read() as *const u8, *sp as i32) as Cell; }
            else if i == op::CREA { a = creat(sp.add(1).read() as *const u8, *sp as u32) as Cell; }
            else if i == op::READ { a = read(sp.add(2).read() as i32, sp.add(1).read() as *mut u8, *sp as usize) as Cell; }
            else if i == op::WRIT { a = write(sp.add(2).read() as i32, sp.add(1).read() as *const u8, *sp as usize) as Cell; }
            else if i == op::CLOS { a = close(*sp as i32) as Cell; }
            else if i == op::PRTF {
                let adj_val = *pc.add(1);
                let t = sp.add(adj_val as usize);
                let fmt = *t.sub(1) as *const u8;
                let print_args = [
                    *t.sub(2), *t.sub(3), *t.sub(4), *t.sub(5), *t.sub(6)
                ];
                a = c4_printf(fmt, &print_args) as Cell;
            }
            else if i == op::MALC { a = malloc(*sp as usize) as Cell; }
            else if i == op::FREE { free(*sp as *mut u8); }
            else if i == op::MSET { a = memset(sp.add(2).read() as *mut u8, sp.add(1).read() as i32, *sp as usize) as Cell; }
            else if i == op::MCMP { a = memcmp(sp.add(2).read() as *const u8, sp.add(1).read() as *const u8, *sp as usize) as Cell; }
            else if i == op::EXIT {
                let code = *sp as i32;
                if debug_flag { println!("exit({}) cycle = {}", code, cycle); }
                std::process::exit(code);
            }
            else {
                eprintln!("unknown instruction = {}! cycle = {}", i, cycle);
                std::process::exit(1);
            }
        }
    }
}