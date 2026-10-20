// 03 - 基本型別與運算
//
// 編譯：rustc --edition 2021 03/types.rs -o types
// 執行：./types

fn main() {
    // ---- 整數 ----
    // 有號：i8 i16 i32 i64 i128 isize（預設 i32）
    // 無號：u8 u16 u32 u64 u128 usize（usize = 位元組平台的指標大小）
    let small: u8 = 255;
    println!("u8 最大值 = {small}");
    // let too_big: u8 = 256; // ← 常數溢位，編譯期就會報錯

    // 執行期溢位：debug 模式 panic，release 模式回繞（wrap）
    // let overflow = small + 1; // ← 取消註解後用 rustc 預設（debug）編譯會 panic

    // ---- 浮點數 ----
    let pi = 3.14_f32;   // 明確指定 f32
    let e = 2.718;       // 預設 f64
    println!("pi = {pi}, e = {e}");

    // ---- 布林 ----
    let is_fun = true;
    let n: i8 = -1;
    let is_negative = n < 0;
    println!("is_fun = {is_fun}, is_negative = {is_negative}");

    // ---- 字元 ----
    // char 是 Unicode 字元，固定佔 4 bytes（不是 1 byte）
    let heart = '❤';
    let cjk = '語';
    println!(
        "{heart} {cjk}，每個 char 佔 {} bytes",
        std::mem::size_of::<char>()
    );

    // ---- 型別轉換：用 as（Rust 不會自動做數值轉換）----
    let a: i32 = 42;
    let b = a as f64; // i32 -> f64
    let c: u8 = 100;
    let d = a + c as i32; // u8 -> i32 後相加
    println!("b = {b}, d = {d}");

    // ---- 算術運算 ----
    println!("7 / 2 = {}, 7 % 2 = {}", 7 / 2, 7 % 2); // 整數除法會捨去小數
    println!("7.0 / 2.0 = {}", 7.0_f64 / 2.0);
    println!("1.0 / 0.0 = {}", 1.0_f64 / 0.0); // 不會 panic，得到 inf

    // ---- 比較與邏輯運算 ----
    let (p, q) = (3, 4);
    println!("p == q: {}, p != q: {}, p < q: {}", p == q, p != q, p < q);
    println!("true && false = {}, !true = {}", true && false, !true);

    // 複合指定：+= -= *= /= %=
    let mut acc = 10;
    acc += 5;
    acc *= 2;
    println!("acc = {acc}");
}
