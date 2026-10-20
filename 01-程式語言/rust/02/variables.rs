// 02 - 變數、常數、可變性、型別推斷、shadowing
//
// 編譯：rustc --edition 2021 02/variables.rs -o variables
// 執行：./variables

fn main() {
    // let 建立變數，預設是「不可變」的（immutable）
    let x = 5;
    println!("x = {x}");
    // x = 6;  // ← 取消註解會編譯錯誤：cannot assign twice to immutable variable

    // 要能重新指定，必須加 mut（mutable）
    let mut y = 10;
    println!("y 的初始值 = {y}");
    y = 20;
    println!("y = {y}");

    // 型別可以推斷，也可以明確標註
    let z: i64 = 1_000_000; // 底線只是分隔符，方便閱讀，值不變
    println!("z = {z}");

    // 常數用 const，必須標註型別，且只能是常數運算式
    const MAX_SCORE: u32 = 100;
    println!("MAX_SCORE = {MAX_SCORE}");

    // shadowing（遮蔽）：用同名變數「蓋掉」前一個
    let spaces = "   ";            // 型別是 &str
    let spaces = spaces.len();     // 同名但是新變數，型別是 usize
    println!("空白字元數 = {spaces}");

    // mut 與 shadowing 的差異：
    // - mut 會改變「同一個」變數，所以型別不能變
    // - shadowing 建立全新變數，型別可以不同
    let n = 5;
    let n = n + 1; // 新的 n
    {
        let n = n * 10; // 只在這個區塊內有效
        println!("區塊內 n = {n}");
    }
    println!("區塊外 n = {n}");
}
