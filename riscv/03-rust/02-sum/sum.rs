// 範例 2：計算 1 + 2 + ... + 10
// 展示迴圈與一般函式呼叫
#![no_std]
#![no_main]

#[path = "../rt.rs"]
mod rt;

use rt::*;

fn sum(n: i32) -> i64 {
    let mut s: i64 = 0;
    for i in 1..=n {
        s += i as i64;
    }
    s
}

#[unsafe(no_mangle)]
pub extern "C" fn main() -> i32 {
    print("sum(1..10) = ");
    print_i64(sum(10));
    print("\n");
    0
}
