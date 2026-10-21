// 範例 3：遞迴計算階乘
// 展示函式遞迴呼叫與 64 位元整數運算
#![no_std]
#![no_main]

#[path = "../rt.rs"]
mod rt;

use rt::*;

fn factorial(n: i32) -> u64 {
    if n <= 1 {
        1
    } else {
        (n as u64) * factorial(n - 1)
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn main() -> i32 {
    for i in 0..=10 {
        print_i64(i as i64);
        print("! = ");
        print_u64(factorial(i));
        print("\n");
    }
    0
}
