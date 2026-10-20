// 範例 1：常數折疊（Constant Folding）— Rust 版
//
// 與 constfold.c 對應。Rust 前端同樣產生 LLVM IR，經過 opt -O2 之後
// 全常數的運算會在編譯期算完。
#![no_std]
#![no_main]

#[path = "../rt.rs"]
mod rt;

use rt::*;

#[inline(never)]
#[unsafe(no_mangle)]
pub fn expression() -> i32 {
    let (a, b, c) = (3i32, 4i32, 5i32);
    let x = a * b * c;
    let y = (a + b) * (c + 1);
    x + y - 2 * a
}

#[inline(never)]
#[unsafe(no_mangle)]
pub fn loop_const() -> i32 {
    let mut s = 0i32;
    for i in 0..100 {
        s += i;
    }
    s
}

#[unsafe(no_mangle)]
pub extern "C" fn main() -> i32 {
    print("expression() = ");
    print_i64(expression() as i64);
    print("\nloop_const() = ");
    print_i64(loop_const() as i64);
    print("\n");
    0
}
