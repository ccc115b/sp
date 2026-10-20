// 16 - 泛型（generics）與特徵（trait）
//
// 編譯：rustc --edition 2021 16/generics_traits.rs -o generics_traits
// 執行：./generics_traits

fn main() {
    // ---- 泛型函式：一個函式處理多種型別 ----
    let ints = [5, 2, 9, 1];
    let floats = [1.5, 0.5, 2.5];
    println!("largest(int) = {}", largest(&ints));
    println!("largest(float) = {}", largest(&floats));

    // ---- 泛型型別 ----
    let p1 = Point { x: 1, y: 2 };
    let p2 = Point { x: 1.0, y: 2.5 };
    println!("p1 = {p1:?}, p2 = {p2:?}");
    p1.describe();

    // ---- trait：定義「型別該有哪些能力」----
    // 想印出 {:?} 就要 derive(Debug)；想用 summarize 就要實作 Summary
    print_summary(&p1);

    // ---- trait object（動態分派）：執行期才知道是哪個具體型別 ----
    let shapes: Vec<Box<dyn Shape>> = vec![
        Box::new(Circle { radius: 1.0 }),
        Box::new(Square { side: 2.0 }),
    ];
    for shape in &shapes {
        println!("面積 = {:.3}", shape.area());
    }

    // 兩種寫法的差異：
    //   fn f(x: impl Shape)      → 編譯期決定（單態化，零成本抽象）
    //   fn f(x: &dyn Shape)      → 執行期決定（透過 vtable 間接呼叫）
}

// T 必須能「比較大小」，所以要加上 PartialOrd
fn largest<T: PartialOrd>(items: &[T]) -> &T {
    let mut biggest = &items[0];
    for item in &items[1..] {
        if item > biggest {
            biggest = item;
        }
    }
    biggest
}

#[derive(Debug)]
struct Point<T> {
    x: T,
    y: T,
}

// 只有實作了 Debug 的 Point 才有 describe 方法
impl<T: std::fmt::Debug> Point<T> {
    fn describe(&self) {
        println!("這個點的座標是 ({:?}, {:?})", self.x, self.y);
    }
}

// ---- 自訂 trait ----
trait Summary {
    // 沒有 body 的方法：實作者必須提供
    fn summarize(&self) -> String;

    // 有 body 的方法：提供預設實作，實作者可選擇覆寫
    fn preview(&self) -> String {
        format!("{}……（預覽）", self.summarize())
    }
}

// 為 Point<i32> 實作 Summary（只針對 i32 版本）
impl Summary for Point<i32> {
    fn summarize(&self) -> String {
        format!("座標點 ({}, {})", self.x, self.y)
    }
}

// 泛型加上 trait 限制（bound）
fn print_summary<T: Summary>(item: &T) {
    println!("{}", item.summarize());
    println!("{}", item.preview());
    // 也可以寫成 fn print_summary(item: &impl Summary)
}

// ---- trait object ----
trait Shape {
    fn area(&self) -> f64;
}

struct Circle {
    radius: f64,
}

impl Shape for Circle {
    fn area(&self) -> f64 {
        std::f64::consts::PI * self.radius * self.radius
    }
}

struct Square {
    side: f64,
}

impl Shape for Square {
    fn area(&self) -> f64 {
        self.side * self.side
    }
}
