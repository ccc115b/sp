// 01 - 第一個 Rust 程式
//
// 編譯：rustc --edition 2021 01/hello.rs -o hello
// 執行：./hello

// 這是單行註解
/*
   這是多行註解
   可以跨很多行
*/

// 程式從 main 函式開始執行
fn main() {
    // println! 是「巨集」（macro），結尾的驚嘆號是名字的一部分
    println!("Hello, world!");
    println!("你好，Rust！");

    // {} 是格式化的位置參數
    println!("{} + {} = {}", 1, 2, 1 + 2);

    // 可以直接在字串裡寫變數名（Rust 1.58+ 的簡寫）
    let name = "Rust";
    println!("我正在學 {name}");

    // 多個參數、指定順序
    println!("{0} 很棒，{1} 也很棒，再說一次 {0} 很棒", "Rust", "程式設計");

    // 常用的格式化選項
    println!("印不出來的除法：{:.2}", 1.0 / 3.0);
    println!("寬度 10 右對齊：|{:>10}|", 42);
    println!("重複字元：{}", "-".repeat(40));
}
