// 範例 5：向量化（Loop Vectorization）— Rust 版
//
// 對應 vectorize.c。
#![no_std]
#![no_main]

#[path = "../rt.rs"]
mod rt;

use rt::*;

#[inline(never)]
#[unsafe(no_mangle)]
pub fn dot4(a: &[i32; 4], b: &[i32; 4]) -> i32 {
    let mut s = 0i32;
    for i in 0..4 {
        s += a[i] * b[i];
    }
    s
}

#[unsafe(no_mangle)]
pub extern "C" fn main() -> i32 {
    let a = [1i32, 2, 3, 4];
    let b = [5i32, 6, 7, 8];
    print("dot4 = ");
    print_i64(dot4(&a, &b) as i64);
    print("\n");
    0
}
