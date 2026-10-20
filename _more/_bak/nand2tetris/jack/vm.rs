// vm：VM 指令的「拼字規則」。
// parser 只決定「要下哪道指令」，實際字串長什麼樣子集中在這裡，
// 之後 ../vm-emu 要反過來讀 VM 碼時，用的就是同一套指令集。

use crate::symbols::Seg;

pub fn function(name: &str, n_locals: usize) -> String {
    format!("function {} {}\n", name, n_locals)
}

pub fn push(seg: Seg, idx: usize) -> String {
    format!("push {} {}\n", seg.vm(), idx)
}

pub fn pop(seg: Seg, idx: usize) -> String {
    format!("pop {} {}\n", seg.vm(), idx)
}

pub fn push_const(n: i64) -> String {
    format!("push constant {}\n", n)
}

pub fn pop_temp(n: usize) -> String {
    format!("pop temp {}\n", n)
}

pub fn push_temp(n: usize) -> String {
    format!("push temp {}\n", n)
}

pub fn push_pointer(n: usize) -> String {
    format!("push pointer {}\n", n)
}

pub fn pop_pointer(n: usize) -> String {
    format!("pop pointer {}\n", n)
}

pub fn push_that(n: usize) -> String {
    format!("push that {}\n", n)
}

pub fn pop_that(n: usize) -> String {
    format!("pop that {}\n", n)
}

pub fn label(name: &str) -> String {
    format!("label {}\n", name)
}

pub fn goto(name: &str) -> String {
    format!("goto {}\n", name)
}

pub fn if_goto(name: &str) -> String {
    format!("if-goto {}\n", name)
}

pub fn call(name: &str, n_args: usize) -> String {
    format!("call {} {}\n", name, n_args)
}

/// 算術／邏輯運算：add sub neg eq gt lt and or not
pub fn arith(op: &str) -> String {
    format!("{}\n", op)
}

pub fn ret() -> String {
    "return\n".to_string()
}

/// "..." → 建立字串物件；appendChar 會回傳字串本身，所以最後位址留在堆疊上
pub fn string(s: &str) -> String {
    let mut out = String::new();
    out.push_str(&push_const(s.chars().count() as i64));
    out.push_str(&call("String.new", 1));
    for ch in s.chars() {
        out.push_str(&push_const(ch as i64));
        out.push_str(&call("String.appendChar", 2));
    }
    out
}
