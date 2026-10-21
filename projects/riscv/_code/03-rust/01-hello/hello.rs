// 範例 1：Hello World
// Rust 的 no_std 程式沒有 printf，直接用 write 系統呼叫輸出字串
#![no_std]
#![no_main]

#[path = "../rt.rs"]
mod rt;

use rt::*;

#[unsafe(no_mangle)]
pub extern "C" fn main() -> i32 {
    print("Hello, RISC-V!\n");
    0
}
