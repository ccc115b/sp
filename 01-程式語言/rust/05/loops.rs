// 05 - 迴圈：loop / while / for
//
// 編譯：rustc --edition 2021 05/loops.rs -o loops
// 執行：./loops

fn main() {
    // ---- loop：無限迴圈，靠 break 結束，而且可以「回傳值」----
    let mut n = 0;
    let result = loop {
        n += 1;
        if n >= 10 {
            break n * 2; // break 可以帶著回傳值離開
        }
    };
    println!("loop 結果 = {result}");

    // ---- while：條件成立時持續執行 ----
    let mut count = 3;
    while count > 0 {
        println!("while 倒數：{count}");
        count -= 1;
    }
    println!("發射！");

    // ---- for：走過一個範圍或集合（最常用）----
    for n in 0..5 {
        print!("{n} "); // 0..5 不含 5
    }
    println!();

    for n in 0..=5 {
        print!("{n} "); // 0..=5 含 5
    }
    println!();

    // 迭代陣列
    let langs = ["Rust", "Go", "Python"];
    for lang in langs {
        println!("我學過 {lang}");
    }

    // 帶索引 + 借用每個元素
    for (index, lang) in langs.iter().enumerate() {
        println!("{index}: {lang}");
    }

    // 反向
    for n in (1..=3).rev() {
        print!("{n} ");
    }
    println!();

    // ---- break / continue 與標籤：控制巢狀迴圈 ----
    'outer: for i in 0..3 {
        for j in 0..3 {
            if i == 1 && j == 1 {
                break 'outer; // 直接跳出外層迴圈
            }
            if j == 2 {
                continue; // 跳過這次內層迭代
            }
            println!("({i}, {j})");
        }
    }

    // 經典練習：九九乘法表
    println!("--- 九九乘法表 ---");
    for i in 1..=9 {
        for j in 1..=9 {
            print!("{:>2}x{:<2}={:>3}", i, j, i * j);
            if j == 9 {
                println!();
            } else {
                print!("  ");
            }
        }
    }
}
