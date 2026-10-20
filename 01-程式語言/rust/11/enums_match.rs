// 11 - 枚舉（enum）與模式匹配（match）
//
// 編譯：rustc --edition 2021 11/enums_match.rs -o enums_match
// 執行：./enums_match

fn main() {
    // ---- 基本用法：每個變體都是一個可能的值 ----
    let dir = Direction::North;
    println!("{dir:?} → 轉彎後 {:?}", turn(dir));
    println!("走三步後 {:?}", walk(Direction::East, 3));

    // ---- 變體可以攜帶資料（比 C 的 enum 強很多）----
    let msgs = vec![
        Message::Quit,
        Message::Move { x: 10, y: 20 },
        Message::Write(String::from("你好")),
        Message::ChangeColor(0, 255, 0),
    ];
    for m in msgs {
        process(&m);
    }

    // ---- match：必須「窮盡」所有可能，編譯器會檢查 ----
    println!("classify(0) = {}", classify(0));
    println!("classify(7) = {}", classify(7));
    println!("classify(-1) = {}", classify(-1));
    // let _ = classify(100); // 其實也能窮盡，因為有 _ 兜底

    // 不完整會編譯錯誤：match on `Direction` is non-exhaustive
    // fn bad(d: Direction) -> i32 {
    //     match d { Direction::North => 1, Direction::South => 2 }
    // }

    // ---- Option<T>：標準函式庫用 enum 表示「可能沒有值」----
    let found = find(&[1, 2, 3], 2);
    let missing = find(&[1, 2, 3], 99);
    println!("find = {found:?}, {missing:?}");

    match found {
        Some(v) => println!("找到 {v}"),
        None => println!("找不到"),
    }

    // 常用的快捷方法
    println!("unwrap_or = {}", missing.unwrap_or(-1));
    // println!("{}", missing.unwrap()); // ← None 時會 panic！原型階段才用

    // if let：只在乎其中一種情況時更簡潔
    if let Some(v) = find(&[4, 5, 6], 5) {
        println!("if let 找到 {v}");
    }

    // while let：不斷解開 Some
    let mut stack = vec![Some(1), Some(2), None, Some(3)];
    while let Some(Some(v)) = stack.pop() {
        println!("pop = {v}");
    }
}

#[derive(Debug, Clone, Copy)] // Copy：複製而非移轉，方便示範
enum Direction {
    North,
    South,
    East,
    West,
}

fn turn(dir: Direction) -> Direction {
    // 用引用來匹配，避免移轉 dir；最後回傳新的方向
    match dir {
        Direction::North => Direction::East,
        Direction::East => Direction::South,
        Direction::South => Direction::West,
        Direction::West => Direction::North,
    }
}

fn walk(dir: Direction, steps: u32) -> Direction {
    println!("朝 {dir:?} 走 {steps} 步");
    dir
}

#[derive(Debug)]
enum Message {
    Quit,                       // 沒有任何資料
    Move { x: i32, y: i32 },    // 具名欄位（像 struct）
    Write(String),              // 攜帶一個 String
    ChangeColor(u8, u8, u8),    // 攜帶三個 u8（像元組）
}

fn process(msg: &Message) {
    // 模式可以解構出內部資料
    match msg {
        Message::Quit => println!("收到：Quit"),
        Message::Move { x, y } => println!("收到：Move 到 ({x}, {y})"),
        Message::Write(text) => println!("收到：Write「{text}」"),
        Message::ChangeColor(r, g, b) => println!("收到：ChangeColor({r}, {g}, {b})"),
    }
}

fn classify(n: i32) -> &'static str {
    match n {
        0 => "零",
        n if n > 0 => "正數", // 有條件的匹配
        _ => "負數",          // _ 代表「其餘所有」
    }
}

// find 可能找得到、也可能找不到 → 用 Option 明確表達
fn find(nums: &[i32], target: i32) -> Option<i32> {
    for &n in nums {
        if n == target {
            return Some(n);
        }
    }
    None
}
