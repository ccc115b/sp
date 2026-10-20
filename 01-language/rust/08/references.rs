// 08 - 參照與借用（reference & borrowing）
//
// 編譯：rustc --edition 2021 08/references.rs -o references
// 執行：./references
//
// 借用規則（同一個作用域內）：
// 1. 可以有任意多個「不可變借用」&T，或
// 2. 只能有一個「可變借用」&mut T
// 3. 借用存在期間，擁有者不能被移轉或丟棄

fn main() {
    // ---- 不可變借用：只「看」，不拿走所有權 ----
    let s1 = String::from("hello");
    let len = calculate_length(&s1);
    println!("「{s1}」長度 = {len}（s1 還在！）");

    // ---- 可變借用：可以改內容 ----
    let mut s2 = String::from("hello");
    change(&mut s2);
    println!("修改後：{s2}");

    // 同一時間只能有一個可變借用
    let mut s3 = String::from("hello");
    let r1 = &mut s3;
    // let r2 = &mut s3; // ← 取消註解會編譯錯誤：cannot borrow `s3` as mutable more than once
    r1.push_str("!");
    println!("r1 = {r1}");

    // 但是可以同時有很多個不可變借用
    let r3 = &s3;
    let r4 = &s3;
    println!("r3 = {r3}, r4 = {r4}");

    // 可變借用出現前，不可變借用都必須不再被使用（non-lexical lifetimes）
    let mut s4 = String::from("abc");
    let a = &s4;
    println!("用到不可變借用 a：{a}");
    let b = &mut s4; // a 已經是最後一次使用，所以這裡可以
    b.push('d');
    println!("可變借用 b 之後：{s4}");

    // 綜合練習
    let data = vec![1, 2, 3, 4];
    println!("總和 = {}", sum(&data)); // 傳不可變借用
    println!("data 仍可用：{data:?}");

    let mut data2 = vec![1, 2, 3];
    push_more(&mut data2); // 傳可變借用
    println!("data2 = {data2:?}");

    // 別名規則的實際意義：編譯器能保證「資料競爭」在編譯期就不會發生
}

fn calculate_length(s: &String) -> usize {
    s.len()
} // s 離開作用域，但因為只是借用，原始字串不會被丟棄

// 更慣用的寫法是接受切片型別 &str（可同時接收 String 與 &str）
fn change(s: &mut String) {
    s.push_str(", world");
}

fn sum(v: &Vec<i32>) -> i32 {
    v.iter().sum()
}

// 慣用寫法：fn sum(v: &[i32]) -> i32
fn push_more(v: &mut Vec<i32>) {
    v.push(4);
}
