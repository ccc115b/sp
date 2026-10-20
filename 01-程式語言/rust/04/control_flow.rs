// 04 - 條件判斷 if / else if / else
//
// 編譯：rustc --edition 2021 04/control_flow.rs -o control_flow
// 執行：./control_flow

fn main() {
    let score = 87;

    // 條件不需要括號，但必須是 bool（不會像 C 一樣把非 0 當成 true）
    if score >= 90 {
        println!("A");
    } else if score >= 80 {
        println!("B");
    } else if score >= 70 {
        println!("C");
    } else {
        println!("D");
    }

    // if 是「表達式」，可以有回傳值（每個分支的型別必須一致）
    let grade = if score >= 90 {
        "優"
    } else if score >= 80 {
        "良"
    } else {
        "加油"
    };
    println!("評等：{grade}");

    // 型別不一致就無法編譯
    // let bad = if score >= 90 { "優" } else { 100 };

    // 用 if 是表達式回傳 bool（等價於 let can_pass = score >= 60;）
    let can_pass = if score >= 60 { true } else { false };
    println!("及格了嗎：{can_pass}");

    // 用巢狀 if 找最大值
    let (a, b, c) = (10, 25, 17);
    let mut max = a;
    if b > max {
        max = b;
    }
    if c > max {
        max = c;
    }
    println!("max({a}, {b}, {c}) = {max}");

    // 條件運算子（三元運算子的等價寫法）
    let label = if a > b { "a 較大" } else { "b 較大或相等" };
    println!("{label}");
}
