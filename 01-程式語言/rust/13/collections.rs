// 13 - 標準集合：Vec、String、HashMap
//
// 編譯：rustc --edition 2021 13/collections.rs -o collections
// 執行：./collections

use std::collections::HashMap;

fn main() {
    // ================= Vec<T>：可變長度的串列 =================
    let mut v: Vec<i32> = Vec::new();
    v.push(1);
    v.push(2);
    v.push(3);

    // 用巨集建立（較常見）
    let mut v2 = vec![4, 5, 6];
    v2.extend([7, 8, 9]);

    // 存取元素的兩種方式
    println!("v[0] = {}", v[0]); // 直接索引：越界會 panic
    println!("v.get(1) = {:?}", v.get(1)); // 回傳 Option：安全
    println!("v.get(99) = {:?}", v.get(99)); // None
    // println!("{}", v[99]); // ← 取消註解會 panic

    println!("v = {v:?}, len = {}", v.len());

    // 迭代：借用每個元素 / 可變地修改每個元素
    for n in &v {
        print!("{n} ");
    }
    println!();
    for n in &mut v {
        *n *= 2; // *n 是解引用，取得實際的值
    }
    println!("全部加倍 = {v:?}");

    // ================= String：UTF-8 文字 =================
    let mut s = String::new();
    s.push_str("Hello");
    s.push(' '); // 單一字元用 push
    s.push_str("Rust");
    println!("s = {s}");

    let s2 = String::from("世界");
    // String + &String 會「吃掉」左邊的 String，所以要先建立可變變數
    s.push('&');
    s.push_str(&s2);
    println!("s = {s}");

    // String 不能用 == 比較內容以外的東西，也不能直接加兩個 String
    // let bad = s + s2; // ← s2 也會被移轉；而且 String + String 是允許的
    println!("長度 {} bytes，{} 個字元", s.len(), s.chars().count());

    // 常用操作
    for word in s.split(|c: char| c.is_whitespace() || c == '&') {
        if !word.is_empty() {
            println!("分割：{word}");
        }
    }
    println!("大寫：{}", s.to_uppercase());

    // ================= HashMap<K, V>：鍵值對應 =================
    let mut scores: HashMap<String, i32> = HashMap::new();
    scores.insert(String::from("Blue"), 10);
    scores.insert(String::from("Yellow"), 50);

    // 讀取回傳 Option
    println!("Blue = {:?}", scores.get("Blue"));
    println!("Red = {:?}", scores.get("Red"));

    // 同一個 key 再次 insert 會覆寫
    scores.insert(String::from("Blue"), 60);

    // entry().or_insert()：key 不存在才插入（存在就維持原值）
    scores.entry(String::from("Blue")).or_insert(0);
    scores.entry(String::from("Green")).or_insert(99);
    println!("{scores:?}");

    // 以值來統計次數（非常常見的寫法）
    let text = "apple banana apple orange banana apple";
    let mut count: HashMap<&str, i32> = HashMap::new();
    for word in text.split_whitespace() {
        // entry 取得「可變借用」，or_insert 回傳 &mut，* 解引用後 +1
        *count.entry(word).or_insert(0) += 1;
    }
    println!("字詞統計：{count:?}");

    // 迭代 HashMap（順序不保證）
    for (k, v) in &scores {
        println!("{k}: {v}");
    }
}
