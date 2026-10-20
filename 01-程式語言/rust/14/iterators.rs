// 14 - 迭代器（iterator）與延遲求值
//
// 編譯：rustc --edition 2021 14/iterators.rs -o iterators
// 執行：./iterators

fn main() {
    let nums = vec![1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    // ---- 基本：iter() 產生迭代器，next() 逐個取出 ----
    let mut it = nums.iter();
    println!("next() = {:?}", it.next()); // Some(&1)
    println!("next() = {:?}", it.next()); // Some(&2)
    // next() 回傳 Option<T>：沒有東西時是 None，for 迴圈就是一直呼叫 next()

    // ---- 常用組合子：filter / map / collect ----
    let evens: Vec<i32> = nums
        .iter() // 產生 &i32
        .copied() // &i32 -> i32（複製）
        .filter(|n| n % 2 == 0) // 保留偶數
        .map(|n| n * 10) // 每個值乘 10
        .collect(); // 收集成 Vec
    println!("偶數 *10 = {evens:?}");

    let sum: i32 = nums.iter().copied().filter(|n| *n > 5).sum();
    println!("大於 5 的總和 = {sum}");

    // ---- 關鍵：組合子是「延遲求值」，不 collect 就不會執行 ----
    println!("（準備好囉，下面這行還不會做事）");
    let lazy = nums.iter().map(|n| {
        println!("  ← map 執行了：{n}");
        n * 2
    });
    println!("（上面完全沒印出 map 的內容）");
    let doubled: Vec<i32> = lazy.collect(); // 這裡才真正開始迭代
    println!("doubled = {doubled:?}");

    // ---- 其他常用方法 ----
    let names = ["Alice", "Bob", "Cindy"];
    for (i, name) in names.iter().enumerate() {
        println!("{i}. {name}");
    }

    println!("take(3) = {:?}", nums.iter().copied().take(3).collect::<Vec<_>>());
    println!("skip(8) = {:?}", nums.iter().copied().skip(8).collect::<Vec<_>>());
    println!("rev = {:?}", (1..=3).rev().collect::<Vec<_>>());
    println!("any(>8) = {}", nums.iter().any(|n| *n > 8));
    println!("all(>0) = {}", nums.iter().all(|n| *n > 0));
    // position / any / all 的閉包收到的是「元素本身」（不是參照）
    println!("position(==7) = {:?}", nums.iter().position(|n| *n == 7));

    // zip：把兩個迭代器配成一對
    let left = [1, 2, 3];
    let right = ["a", "b", "c"];
    let pairs: Vec<(&i32, &&str)> = left.iter().zip(right.iter()).collect();
    println!("zip = {pairs:?}");

    // ---- 自訂迭代器：實作 Iterator trait ----
    let mut counter = Counter::new();
    println!(
        "Counter: {:?} {:?} {:?} {:?} {:?} {:?}",
        counter.next(),
        counter.next(),
        counter.next(),
        counter.next(),
        counter.next(),
        counter.next() // 第六次是 None
    );

    // 自訂迭代器也能用所有組合子
    let all: Vec<u32> = Counter::new().collect();
    println!("collect = {all:?}");
    let even: Vec<u32> = Counter::new().filter(|x| x % 2 == 0).collect();
    println!("filter = {even:?}");
}

// 一個從 1 數到 5 的迭代器
struct Counter {
    count: u32,
}

impl Counter {
    fn new() -> Self {
        Counter { count: 0 }
    }
}

impl Iterator for Counter {
    type Item = u32; // 每次 next() 產生的型別

    fn next(&mut self) -> Option<Self::Item> {
        if self.count < 5 {
            self.count += 1;
            Some(self.count)
        } else {
            None
        }
    }
}
