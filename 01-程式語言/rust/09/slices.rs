// 09 - 切片（slice）：借用集合的一段連續區間
//
// 編譯：rustc --edition 2021 09/slices.rs -o slices
// 執行：./slices

fn main() {
    // ---- 字串切片 &str ----
    let s = String::from("hello world");

    let hello = &s[0..5]; // 半開區間 [0, 5)
    let world = &s[6..11];
    println!("{hello} | {world}");

    // 從頭開始 / 到結尾，可以省略
    let first = &s[..5];
    let rest = &s[6..];
    let whole = &s[..];
    println!("{first} | {rest} | {whole}");

    // 型別對照：
    //   String  -> 可變、攤在堆上  -> 擁有資料
    //   &str    -> 不可變借用      -> 只是「看」
    // 函式參數用 &str 最通用，兩種都能傳進來
    let owned = String::from("a b c");
    println!("word_count(&str) = {}", word_count("x y"));
    println!("word_count(&String) = {}", word_count(&owned));

    // ---- 注意：Rust 的字串索引單位是 byte（UTF-8）----
    let zh = "你好世界";
    println!(
        "「{zh}」= {} bytes，{} 個字元",
        zh.len(),
        zh.chars().count()
    );
    // let bad = &zh[0..2]; // ← 取消註解會「執行期」panic：不是 char 邊界
    // 「你」在 UTF-8 中佔 3 bytes，只能在 0 或 3 切
    println!("可以切：{}/{:?}", &zh[0..3], &zh[0..3].chars().collect::<Vec<_>>());

    // ---- 數值陣列的切片 &[T] ----
    let nums = [10, 20, 30, 40, 50];
    let mid = &nums[1..4]; // 20, 30, 40
    println!("mid = {mid:?}");
    println!("平均 = {:.2}", average(mid));

    // 切片也是「借用」，所以原本的集合還能用
    println!("nums 還在：{nums:?}");
}

// 接受 &str：String 與字面值都能傳進來
fn word_count(s: &str) -> usize {
    s.split_whitespace().count()
}

// 接受 &[i32]：陣列與 Vec 都能傳進來
fn average(slice: &[i32]) -> f64 {
    slice.iter().sum::<i32>() as f64 / slice.len() as f64
}
