// 10 - 結構體（struct）
//
// 編譯：rustc --edition 2021 10/structs.rs -o structs
// 執行：./structs

fn main() {
    // 建立實例：每個欄位都要有值
    let mut user = User {
        name: String::from("小明"),
        age: 20,
        active: true,
    };
    println!("{}（{}歲）", user.name, user.age);

    // 整個實例是 mut 才能改欄位
    user.age = 21;
    println!("一年後：{} 歲", user.age);

    // 欄位初始化簡寫（變數名與欄位名相同）
    let name = String::from("小華");
    let age = 18;
    let student = User { name, age, active: true };

    // …更新語法：沿用舊實例的其他欄位
    let guest = User {
        age: 99,
        ..student
    };
    println!("guest = {}歲, active = {}", guest.age, guest.active);

    // ---- 方法（method）：寫在 impl 區塊裡 ----
    let r = Rectangle::new(3.0, 4.0);
    println!("長方形 {r:?}");
    println!("面積 = {}", r.area());
    println!("周長 = {}", r.perimeter());
    println!("對角線 = {:.2}", r.diagonal());

    // ---- 關聯函式（associated function）：沒有 self，用 :: 呼叫 ----
    // 常被拿來當「建構函式」，例如 String::from(...)
    let p = Point::new(3, 4);
    println!("Point = {p:?}");
    println!("直接存取欄位：p.x = {}, p.y = {}", p.x, p.y);

    // ---- 元組結構體：給型別一個名字，欄位用 .0 .1 存取 ----
    struct Color(u8, u8, u8);
    let red = Color(255, 0, 0);
    println!("RGB = ({}, {}, {})", red.0, red.1, red.2);

    // ---- 單位結構體：沒有欄位，常用來實作某個 trait（16 篇介紹）----
    struct Marker;
    let _m = Marker;

    // 結構體與函式的小差異：函式參數要逗號，結構體欄位也要逗號；
    // 但呼叫時不需要 (.., ..)，而是用 名稱: 值
    println!("user 的型別是 User，直接印需要 #[derive(Debug)] → {user:?}");
}

// derive(Debug) 讓我們可以用 {:?} 印出內容
#[derive(Debug)]
struct User {
    name: String,
    age: u8,
    active: bool,
}

#[derive(Debug)]
struct Rectangle {
    width: f64,
    height: f64,
}

impl Rectangle {
    // 關聯函式：第一個參數不是 self，常用來當建構函式
    fn new(width: f64, height: f64) -> Self {
        Self { width, height }
    }

    // 第一個參數是 self（自動借用整個實例）
    fn area(&self) -> f64 {
        self.width * self.height
    }

    fn perimeter(&self) -> f64 {
        2.0 * (self.width + self.height)
    }

    fn diagonal(&self) -> f64 {
        (self.width * self.width + self.height * self.height).sqrt()
    }
}

#[derive(Debug)]
struct Point {
    x: i32,
    y: i32,
}

impl Point {
    // 關聯函式：第一個參數不是 self，通常命名為 new
    fn new(x: i32, y: i32) -> Self {
        // Self 代表 Point 這個型別本身
        Self { x, y }
    }
}
