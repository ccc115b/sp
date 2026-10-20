// 範例 3：函式內聯（Inlining）— Rust 版
//
// 對應 inline.c。#[inline(never)] 擋住前端內聯，讓 LLVM 的 inline pass
// 來處理，方便觀察 .ll 的變化。
#![no_std]
#![no_main]

#[path = "../rt.rs"]
mod rt;

use rt::*;

#[inline(never)]
fn square(x: i32) -> i32 {
    x * x
}

#[inline(never)]
fn addmul(a: i32, b: i32) -> i32 {
    a + square(b)
}

#[inline(never)]
#[unsafe(no_mangle)]
pub fn compute(n: i32) -> i32 {
    let mut s = 0i32;
    for i in 0..n {
        s += addmul(i, i + 1);
    }
    s
}

#[unsafe(no_mangle)]
pub extern "C" fn main() -> i32 {
    print("compute(10) = ");
    print_i64(compute(10) as i64);
    print("\n");
    0
}
