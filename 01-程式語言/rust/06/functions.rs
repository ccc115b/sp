// 06 - 函式
//
// 編譯：rustc --edition 2021 06/functions.rs -o functions
// 執行：./functions

fn main() {
    greet("Alice");
    greet("Bob");

    let sum = add(3, 4);
    println!("3 + 4 = {sum}");

    println!("abs(-7) = {}", abs(-7));
    println!("double(21) = {}", double(21));

    // 函式呼叫本身是表達式，所以可以放在式子裡
    println!("add(1, 2) + add(3, 4) = {}", add(1, 2) + add(3, 4));

    // 沒有宣告回傳型別的函式，回傳的是「單元型別」()
    say_nothing();
    println!("say_nothing() 回傳值 = {:?}", say_nothing());
}

// 參數必須標註型別，函式可以定義在 main 之前或之後
fn greet(name: &str) {
    println!("Hello, {name}!");
}

// 最後一式（沒有分號）就是回傳值
fn add(a: i32, b: i32) -> i32 {
    a + b
    // a + b;  // ← 加了分號就變成「陳述式」，函式會回傳 ()，編譯錯誤
}

fn double(n: i32) -> i32 {
    n * 2
}

fn abs(n: i32) -> i32 {
    if n < 0 {
        -n
    } else {
        n
    }
}

// 不寫 -> 就是回傳 ()
fn say_nothing() {}
