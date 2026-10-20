// 範例 2：mem2reg — Rust 版
//
// 對應 mem2reg.c。Rust 前端的區域變數在未優化 IR 中也常是 alloca，
// opt -O2 會做同樣的提升。
#![no_std]
#![no_main]

#[path = "../rt.rs"]
mod rt;

use rt::*;

#[inline(never)]
#[unsafe(no_mangle)]
pub fn fib(n: i32) -> i32 {
    let (mut a, mut b) = (0i32, 1i32);
    for _ in 0..n {
        let t = a + b;
        a = b;
        b = t;
    }
    a
}

#[unsafe(no_mangle)]
pub extern "C" fn main() -> i32 {
    print("fib(10) = ");
    print_i64(fib(10) as i64);
    print("\nfib(20) = ");
    print_i64(fib(20) as i64);
    print("\n");
    0
}
