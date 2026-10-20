# 10 － 結構體 Struct（structs.rs）

## 這課你將學會

- 定義自己的資料型別，把相關的資料打包在一起
- 寫方法（method）與關聯函式（associated function）
- `impl` 區塊、`self`、`Self` 各是什麼
- `#[derive(Debug)]` 與 `{:?}`
- 元組結構體與單位結構體

## 核心觀念

1. **struct = 命名的資料集合**，欄位可以是不同型別。
2. **`impl` 區塊定義方法**：
   - 第一個參數是 `self`（借用 `&self`、可變 `&mut self`、拿走 `self`）→ 用 `.` 呼叫
   - 第一個參數不是 `self` → 關聯函式，用 `::` 呼叫（常用來當建構函式 `new`）
3. **`Self` 代表「這個型別自己」**，`self` 代表「這個實例」。
4. **想要用 `{:?}` 印出來，要加 `#[derive(Debug)]`**。
5. 可見性：**沒有 `pub` 的欄位在模組外看不到**（第 18 課詳解）。

## 編譯與執行

```bash
rustc --edition 2021 10/structs.rs -o structs
./structs
```

或：`./run_all.sh 10`

## 逐步解讀

### 1. 定義與建立

```rust
struct User {
    name: String,    // 用 String 而不是 &str，因為實例要能活得比字面值久
    age: u8,
    active: bool,
}

let mut user = User { name: String::from("小明"), age: 20, active: true };
user.age = 21;       // 整個實例是 mut 才能改
```

### 2. 兩個語法糖

```rust
// 欄位初始化簡寫：變數 name/age 剛好同名
let student = User { name, age, active: true };

// 更新語法：其餘欄位沿用 student（name 會被 move 進來）
let guest = User { age: 99, ..student };
```

### 3. 方法 vs 關聯函式

```rust
impl Rectangle {
    fn new(width: f64, height: f64) -> Self {   // 沒有 self → 關聯函式
        Self { width, height }
    }
    fn area(&self) -> f64 {                      // 有 &self → 方法
        self.width * self.height
    }
}

let r = Rectangle::new(3.0, 4.0);   // 用 :: 呼叫
r.area();                           // 用 . 呼叫
```

`&self` 是 `self: &Self` 的簡寫。三種接收方式：

| 寫法 | 意義 |
|------|------|
| `&self` | 借用，只讀（最常用） |
| `&mut self` | 借用，可改 |
| `self` | 拿走所有權（方法結束後實例就不能用了） |

想試 `&mut self`，可以把 `Rectangle` 加一個 `fn scale(&mut self, k: f64)`。

### 4. 三種 struct

```rust
struct User { name: String, age: u8 }   // 具名欄位
struct Color(u8, u8, u8);               // 元組結構體：red.0 取值
struct Marker;                          // 單位結構體：常用來實作 trait（16 課）
```

### 5. 一個 struct 可以有多个 impl

```rust
impl Point { fn new(...) -> Self {...} }   // 建構
// 也可以再寫另一個 impl 區塊放其他方法（例如不同 feature）
```

## 動手試試看

1. 給 `Rectangle` 加方法 `fn is_square(&self) -> bool`（寬高等於高）。
2. 加一個 `fn scale(&mut self, factor: f64)`，印出縮放後的面積。
3. 加 `fn perimeter(&self)` 的另一種寫法：用元組解構 `let (w, h) = (self.width, self.height);`。
4. 自己設計一個 `struct Student { name: String, scores: Vec<u8> }`，寫方法 `fn average(&self) -> f64`。
5. 嘗試直接印 `Rectangle`（不加 `derive(Debug)`）→ 錯誤訊息會告訴你缺什麼 trait。

## 故意犯錯

| 寫法 | 結果 |
|------|------|
| `Rectangle::area(&r)` | 可以，但很囉唆——慣用是 `r.area()` |
| `fn area(self) -> f64 { ... }` 然後呼叫兩次 | 第二次 `r.area()` 會 error: use of moved value |
| 建立實例時漏欄位 | `missing field ... in initializer` |
| 沒有 `derive(Debug)` 就 `println!("{r:?}")` | `Rectangle doesn't implement Debug` |

## 檢查點

- [ ] `self`、`&self`、`&mut self`、`Self` 各代表什麼？
- [ ] 方法與關聯函式怎麼分辨？呼叫語法差在哪？（`.` vs `::`）
- [ ] `..student` 這段語法在做什麼？會不會影響 student？
- [ ] 想印出 `{:?}` 要加什麼？
- [ ] 為什麼 `name` 欄位用 `String` 而不是 `&str`？

下一課：[11/enums_match.rs － 枚舉與模式匹配](../11/README.md)
