# 18 － 模組與多檔案專案（main.rs ＋ shapes.rs ＋ utils.rs）

## 這課你將學會

- 把程式拆成多個檔案（**這是本教材唯一多檔的一課**）
- `mod` / `use` / `pub` 三個關鍵字各自在做什麼
- 模組樹（module tree）與路徑（path）
- **可見性**：為什麼沒加 `pub` 的東西外面看不到
- 巢狀模組

## 這個資料夾的結構

```
18/
├── main.rs     ← 入口，宣告 mod shapes; mod utils;
├── shapes.rs   ← 對應 mod shapes;
└── utils.rs    ← 對應 mod utils;（裡面還有 pub mod math { ... }）
```

## 核心觀念

1. **`mod 名稱;` 就是「把另一個檔案當成這個模組的內容引進來」**：
   - `mod shapes;` 會去找同資料夾的 `shapes.rs`
   - 或是 `shapes/mod.rs`（另一種慣用寫法）
2. **`use` 是別名**：`use shapes::Rectangle;` 讓你之後寫 `Rectangle` 而不是 `shapes::Rectangle`。
3. **預設全部私有**：模組裡的項目沒加 `pub`，外面（即使是同一個 crate 的其他模組）都看不到。
   → **可見性預設最小化**，是 Rust 的安全設計之一。
4. **巢狀模組**：`utils` 裡可以再 `pub mod math`，路徑就變成 `utils::math::square(...)`。
5. **`self` / `super` / `crate`**：路徑的起點分別是「目前模組」、「上一層」、「crate 根目錄」。
   `utils.rs` 裡的 `use super::shapes::Rectangle;` 就是「回到根目錄再往下找 shapes」。

## 編譯與執行

**入口是 `main.rs`，只需要編譯它**，rustc 會自動把另外兩個檔案抓進來：

```bash
rustc --edition 2021 18/main.rs -o modules_demo
./modules_demo
```

或：`./run_all.sh 18`

> 請不要直接 `rustc 18/shapes.rs`——它不是入口，會得到 `main function not found`。
> 這也是為什麼本教材一律要加 `--edition 2021`。

## 逐步解讀

### 1. 宣告與引用（main.rs）

```rust
mod shapes;      // 引入 shapes.rs
mod utils;       // 引入 utils.rs

use shapes::Rectangle;
use utils::print_info;

fn main() {
    let r = Rectangle::new(3.0, 4.0);
    print_info("長方形", &r);
}
```

### 2. 可見性（shapes.rs）

```rust
#[derive(Debug)]
pub struct Rectangle {          // pub：其他模組可以用這個型別
    pub width: f64,             // pub：欄位也可以個別開放
    pub height: f64,
}

impl Rectangle {
    pub fn new(...) -> Self { ... }     // pub：建構函式
    pub fn area(&self) -> f64 { ... }
    fn aspect_ratio(&self) -> f64 { ... }   // 沒 pub：只有本模組能用
}

const SECRET_CODE: u32 = 42;            // 沒 pub：外面看不到

pub fn internal_code() -> u32 {         // 但可以「選擇性」曝露它
    SECRET_CODE
}
```

試著把 `main.rs` 第 25 行的註解拿掉：

```rust
// println!("{:?}", shapes::SECRET_CODE);
```

會得到 `error: constant SECRET_CODE is private` —— 這就是模組邊界。

### 3. 巢狀模組（utils.rs）

```rust
pub mod math {
    pub fn square(x: f64) -> f64 { x * x }
    pub fn cube(x: f64) -> f64 { x * x * x }
}
```

呼叫：`utils::math::square(3.0)`。這個模組直接寫在檔案裡，不需要另外建資料夾。

### 4. 使用上一層的東西

```rust
// utils.rs
use super::shapes::Rectangle;
```

`super` 從 `utils` 往上到根目錄，再往下找 `shapes`。

### 5. 私有函式也照樣能用（內部使用不受限制）

```rust
fn clamp(v: f64, min: f64, max: f64) -> f64 { ... }   // 沒 pub

pub fn round(v: f64) -> f64 {
    (clamp(v, 0.0, 10.0) * 100.0).round() / 100.0     // 同模組內可自由呼叫
}
```

`pub` 的意義不是「自己能用」，而是「**開放給模組外面**」。

## 動手試試看

1. 把 `main.rs` 第 25 行的註解拿掉，讀 `is private` 錯誤訊息。
2. 把 `shapes.rs` 的 `pub` 全部拿掉，看會冒出哪些錯誤（順便複習可見性的範圍）。
3. 加一個新模組 `18/text.rs`，裡面放 `pub fn shout(s: &str) -> String`，在 `main` 宣告 `mod text;` 並使用。
4. 在 `main.rs` 寫 `mod math_inline;` 是行不通的（沒有這個檔案）——試試看，確認 rustc 怎麼報錯。
5. 把 `utils.rs` 的 `use super::shapes::Rectangle;` 改成 `use crate::shapes::Rectangle;`，確認兩者等價。

## 檢查點

- [ ] `mod shapes;` 這行會去哪裡找檔案？
- [ ] 沒有 `pub` 的項目，誰能存取？
- [ ] `use` 和 `mod` 的差別？
- [ ] `super`、`self`、`crate` 各代表什麼？
- [ ] 為什麼 `pub fn internal_code()` 可以存取私有的 `SECRET_CODE`？
- [ ] 編譯這個資料夾時，`-o` 後面的檔案名稱應該是根據哪一個 `.rs`？

下一課：[19/file_io.rs － 檔案與輸入輸出](../19/README.md)
