// 15 - 閉包（closure）：可以捕獲環境的匿名函式
//
// 編譯：rustc --edition 2021 15/closures.rs -o closures
// 執行：./closures

fn main() {
    // ---- 基本語法：|參數| 運算式 ----
    let add = |a, b| a + b;
    println!("3 + 4 = {}", add(3, 4));

    // 型別通常可推斷；需要時也可以標註
    let shout = |name: &str| -> String { format!("{}!!", name.to_uppercase()) };
    println!("{}", shout("rust"));

    // ---- 捕獲環境變數（closure 的特色）----
    let factor = 3;
    let times = |x| x * factor; // 讀取（借用）外面的 factor
    println!("10 x factor = {}", times(10));

    // ---- 三種捕獲方式（編譯器自動選擇）----
    // 1. &T      不可變借用（預設）
    // 2. &mut T  可變借用（閉包要改被捕獲的變數時）
    // 3. 所有權  加 move（閉包要比環境活得久時，例如丟給執行緒）

    // 可變借用：閉包本身要宣告成 mut
    let mut count = 0;
    let mut increment = || {
        count += 1;
    };
    increment();
    increment();
    println!("count = {count}"); // 離開閉包後還能使用，因為只是借用

    // move：把值搬進閉包（常見於執行緒、或把閉包存起來）
    let greeting = String::from("hi");
    let say = move || println!("{greeting}"); // greeting 的所有權進了閉包
    say();
    // println!("{greeting}"); // ← 取消註解會編譯錯誤：value moved into closure

    // ---- 把閉包當參數傳遞 ----
    println!("apply(乘 2, 21) = {}", apply(|x| x * 2, 21));
    println!("apply(轉字串, 7) = {}", apply(|x| x.to_string(), 7));

    let nums = vec![1, 2, 3];
    println!("transform = {:?}", transform(&nums, |x| x * 10));
    println!("transform = {:?}", transform(&nums, |x| x.to_string()));

    // ---- 傳回閉包 ----
    let add_100 = make_adder(100);
    println!("add_100(5) = {}", add_100(5));

    // ---- 立即執行閉包（IIFE 風格）----
    let square = (|x: i32| x * x)(7);
    println!("7 的平方 = {square}");
}

// F 必須實作 Fn(i32) -> T（可呼叫一次以上、且不奪走參數所有權）
fn apply<F, T>(f: F, x: i32) -> T
where
    F: Fn(i32) -> T,
{
    f(x)
}

// 回傳型別也是泛型：同一個函式可以回傳 Vec<i32> 或 Vec<String>
fn transform<F, U>(v: &[i32], f: F) -> Vec<U>
where
    F: Fn(&i32) -> U,
{
    v.iter().map(f).collect()
}

// 傳回閉包時不能直接寫 -> closure 型別，要用 impl Fn 或 Box<dyn Fn>
fn make_adder(base: i32) -> impl Fn(i32) -> i32 {
    // move：base 必須被搬進閉包，否則函式結束後 base 就不見了
    move |x| base + x
}
