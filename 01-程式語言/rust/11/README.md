# 11 － 枚舉 enum 與模式匹配 match（enums_match.rs）

## 這課你將學會

- 定義列舉，並讓**變體攜帶資料**
- 用 `match` 做**窮盡**的模式匹配（編譯器會檢查你漏了哪一種）
- 理解 `Option<T>` 是 Rust 的「可能沒有值」
- `if let` / `while let` 簡寫

## 核心觀念

1. **enum 的每個變體都是一個「值」**，而且可以攜帶資料——比 C 的 enum 強得多。
2. **`match` 必須窮盡（exhaustive）**：所有可能都要被處理，否則編譯不過。
   → 「忘了處理某種情況」在 Rust 中是**編譯錯誤**而不是執行期 bug。
3. **模式匹配會「解構」**：把變體內部的資料拆出來直接用（`Message::Write(text)`）。
4. **`Option<T>` = `Some(T)` 或 `None`**：Rust 沒有 null，用 enum 表達「可能沒有值」。
   下一課的 `Result<T, E>` 也是同一種手法。
5. **`match` 是表達式**：每個 `=>` 右邊的值可以被回傳（04 課的「if 是表達式」同理）。

## 編譯與執行

```bash
rustc --edition 2021 11/enums_match.rs -o enums_match
./enums_match
```

或：`./run_all.sh 11`

## 逐步解讀

### 1. 定義與匹配

```rust
#[derive(Debug, Clone, Copy)]
enum Direction { North, South, East, West }

fn turn(dir: Direction) -> Direction {
    match dir {
        Direction::North => Direction::East,
        Direction::East  => Direction::South,
        Direction::South => Direction::West,
        Direction::West  => Direction::North,
    }
}
```

`#[derive(Debug)]` 才能用 `{:?}`；`Copy` 讓 `turn(dir)` 不會移轉 `dir`（07 課的規則）。

### 2. 變體攜帶資料

```rust
enum Message {
    Quit,                       // 沒資料
    Move { x: i32, y: i32 },    // 像 struct
    Write(String),              // 像元組
    ChangeColor(u8, u8, u8),
}

match msg {
    Message::Quit => ...,
    Message::Move { x, y } => ...,              // 解構具名欄位
    Message::Write(text) => ...,                // 解構元組欄位
    Message::ChangeColor(r, g, b) => ...,
}
```

這就是 Rust 版的「sum type / 聯合型別」。

### 3. 窮盡檢查

```rust
fn bad(d: Direction) -> i32 {
    match d { Direction::North => 1, Direction::South => 2 }   // ← 少了兩種
}
```

編譯錯誤：`non-exhaustive patterns: East and West not covered`。
把上面程式碼從註解中拿出來試一次。

### 4. 條件匹配與萬用字元

```rust
match n {
    0 => "零",
    n if n > 0 => "正數",   // if 後面可以接任意條件（guard）
    _ => "負數",            // _ = 其餘所有
}
```

### 5. Option<T>

```rust
fn find(nums: &[i32], target: i32) -> Option<i32> {
    for &n in nums { if n == target { return Some(n); } }
    None
}

let found   = find(&[1,2,3], 2);    // Some(2)
let missing = find(&[1,2,3], 99);   // None

match found { Some(v) => println!("找到 {v}"), None => println!("找不到") }
missing.unwrap_or(-1);              // None 時用預設值，不 panic
```

**強制你面對 `None`** 是 Rust 的核心哲學：`missing.unwrap()` 在 `None` 時會 panic，所以除非確定，否則用 `match` / `unwrap_or`。

### 6. 簡寫

```rust
if let Some(v) = find(&[4,5,6], 5) { ... }   // 只在乎 Some

while let Some(Some(v)) = stack.pop() { ... } // 一直解開直到匹配失敗
// stack: Vec<Option<i32>>，pop() 回傳 Option<Option<i32>>
```

## 動手試試看

1. 把第 30-32 行的 `bad` 函式拿出來編譯，讀 `non-exhaustive` 錯誤訊息。
2. 給 `Message` 加一個變體 `Echo(String)` 並在 `process` 裡處理（記得加到 match）。
3. 寫 `fn area(shape: Shape) -> f64`，`Shape` 是 `Circle(f64)` / `Rect(f64, f64)` 的 enum。
4. 把 `find` 改寫成回傳 `Option<&i32>`（借用而非複製）。
5. 用 `match` 實作一個回傳字串的成績分級，取代 04 課的 `if/else`。

## 故意犯錯

| 寫法 | 結果 |
|------|------|
| match 少一個變體 | `non-exhaustive patterns ... not covered` |
| `missing.unwrap()`（值為 None） | 執行期 panic: called `Option::unwrap()` on a `None` |
| `let x = match n { 0 => "零", _ => 0 };` | 分支型別不一致（match 也是表達式） |

## 檢查點

- [ ] 為什麼 Rust 要求 match「窮盡」？這解決了什麼經典 bug？
- [ ] `Message::Write(text)` 中的 `text` 是怎麼來的？
- [ ] `Option<T>` 有哪兩個變體？`T` 出現在哪裡？
- [ ] `match` 與 `if let` 各適合什麼時機？
- [ ] `None` 和「空字串 `""`」哪個更能表達「沒有資料」？為什麼？

下一課：[12/error_handling.rs － 錯誤處理](../12/README.md)
