// 範例 4：浮點運算
// 展示 RISC-V 的 F/D（單精度／雙精度）浮點指令支援
#![no_std]
#![no_main]

#[path = "../rt.rs"]
mod rt;

use rt::*;

#[unsafe(no_mangle)]
pub extern "C" fn main() -> i32 {
    let a: f64 = 3.14159;
    let b: f64 = 2.0;
    print("pi * 2 = ");
    print_f64(a * b, 5);
    print("\n");

    let f: f32 = 1.0f32 / 3.0f32;
    print("1/3 = ");
    print_f64(f as f64, 5);
    print("\n");
    0
}
