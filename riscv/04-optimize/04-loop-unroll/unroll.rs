// 範例 4：迴圈展開與強度削減 — Rust 版
//
// 對應 unroll.c。
#![no_std]
#![no_main]

#[path = "../rt.rs"]
mod rt;

use rt::*;

#[inline(never)]
#[unsafe(no_mangle)]
pub fn sum_squares(n: i32) -> i32 {
    let mut s = 0i32;
    for i in 1..=n {
        s += i * i;
    }
    s
}

#[inline(never)]
#[unsafe(no_mangle)]
pub fn scale_array(a: &[i32]) -> i32 {
    let mut s = 0i32;
    for &x in a {
        s += x * 4;
    }
    s
}

#[unsafe(no_mangle)]
pub extern "C" fn main() -> i32 {
    let arr = [1i32, 2, 3, 4, 5, 6, 7, 8];
    print("sum_squares(10) = ");
    print_i64(sum_squares(10) as i64);
    print("\nscale_array = ");
    print_i64(scale_array(&arr) as i64);
    print("\n");
    0
}
