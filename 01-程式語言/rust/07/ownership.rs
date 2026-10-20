// 07 - 所有權（ownership）：Rust 最核心的觀念
//
// 編譯：rustc --edition 2021 07/ownership.rs -o ownership
// 執行：./ownership
//
// 三條規則：
// 1. Rust 中每個值都有一個「擁有者」（owner）
// 2. 同一時間只能有一個擁有者
// 3. 擁有者離開作用域（scope）時，值會被自動丟棄（drop）

fn main() {
    // ---- 堆積資料（String）會被「移轉」（move）----
    let s1 = String::from("hello");
    let s2 = s1; // 所有權從 s1 移轉到 s2

    // println!("s1 = {s1}"); // ← 取消註解會編譯錯誤：borrow of moved value
    println!("s2 = {s2}");

    // ---- 標量型別（i32 等）實作了 Copy，所以是「複製」不是移轉 ----
    let a = 42;
    let b = a; // 複製
    println!("a = {a}, b = {b}"); // 兩個都還能用

    // ---- 傳進函式也會移轉所有權 ----
    let s = String::from("hi");
    takes_ownership(s);
    // println!("{s}"); // ← s 的所有權已經交給函式了

    let n = 5;
    makes_copy(n);
    println!("n 還在：{n}"); // i32 是 Copy，所以不受影響

    // ---- 函式回傳值也可以「交還」所有權 ----
    let s3 = gives_ownership();
    println!("s3 = {s3}");

    let s4 = take_and_give_back(s3);
    // println!("{s3}"); // ← s3 已經移轉出去
    println!("s4 = {s4}");

    // 這種「移來移去」很麻煩 → 下一個範例介紹「借用」（reference）

    // 作用域結束：這裡的 String 會被自動釋放，不需要手動 free
}

fn takes_ownership(s: String) {
    println!("函式得到了「{s}」");
} // s 離開作用域，String 被丟棄

fn makes_copy(n: i32) {
    println!("函式得到副本：{n}");
} // n 離開作用域，但只是 i32，沒什麼特別的

fn gives_ownership() -> String {
    String::from("我是被回傳的所有權")
}

fn take_and_give_back(s: String) -> String {
    s // 交還所有權
}
