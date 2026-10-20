# 09 － 切片 Slices（slices.rs）

## 這課你將學會

- 什麼是切片：**借用集合的一段連續區間**
- `String` 與 `&str` 的關係（擁有 vs 借用）
- 為什麼函式參數該收 `&str` / `&[T]` 而不是 `String` / `Vec<T>`
- 字串索引的單位是 **byte**，不是字元

## 核心觀念

1. **切片沒有自己的資料**，它只記著「從哪裡開始、到哪裡結束」，所以切片也是**借用**，原本的集合還能用。
2. **型別對照**：

   | 型別 | 誰擁有資料 | 可變嗎 | 建立方式 |
   |------|-----------|--------|----------|
   | `String` | 自己擁有（堆上） | 可 `mut` | `String::from(...)` |
   | `&str` | 不擁有，借用 | 不可 | `&s[0..5]` 或字面值 `"hi"` |
   | `[T; N]` / `Vec<T>` | 擁有 | 可 `mut` | 陣列 / `vec![]` |
   | `&[T]` | 不擁有，借用 | 不可 | `&v[1..4]` |

3. **函式要收「切片」**：`fn f(s: &str)` 比 `fn f(s: &String)` 通用得多（字面值與 `String` 都能傳）。
4. **Rust 字串索引單位是 byte**，而且必須切在「字元邊界」上，否則執行期 panic。

## 編譯與執行

```bash
rustc --edition 2021 09/slices.rs -o slices
./slices
```

或：`./run_all.sh 09`

## 逐步解讀

### 1. 基本切片語法

```rust
let s = String::from("hello world");
let hello = &s[0..5];   // 半開區間 [0, 5) → "hello"
let world = &s[6..11];  // "world"
let first = &s[..5];    // 從頭開始，省略 0
let rest  = &s[6..];    // 到最後，省略結尾
let whole = &s[..];     // 整個字串
```

記憶法：Rust 的範圍和數學的區間一樣，**左閉右開**。

### 2. 函式收切片最通用

```rust
let owned = String::from("a b c");
word_count("x y");      // 傳字面值 &str
word_count(&owned);     // 傳 &String，自動解引用成 &str

fn word_count(s: &str) -> usize { s.split_whitespace().count() }
```

兩個都能傳是因為編譯器會做 **deref coercion**（`&String` → `&str`）。16 課講 trait 時會再提。

### 3. UTF-8 索引陷阱

```rust
let zh = "你好世界";
zh.len();               // 12（bytes）
zh.chars().count();     // 4（字元）
// let bad = &zh[0..2]; // ← 拿掉註解會執行期 panic！
&zh[0..3];              // OK，「你」佔 3 bytes
```

中文字在 UTF-8 中佔 3 bytes、表情符號可能佔 4 bytes。**索引 2 不是字元邊界**，所以會：

```
byte index 2 is not a char boundary; it is inside '你' (bytes 0..3)
```

這就是為什麼 Rust 不允許 `s[1]` 直接取單一字元——要取得第 n 個字元得用 `s.chars().nth(n)`。

### 4. 數值切片

```rust
let nums = [10, 20, 30, 40, 50];
let mid = &nums[1..4];              // [20, 30, 40]
average(mid);                       // 傳 &[i32]

fn average(slice: &[i32]) -> f64 {
    slice.iter().sum::<i32>() as f64 / slice.len() as f64
}
```

`sum::<i32>()` 是「泛型方法的型別標註」（turbofish 語法 `::<>`），16 課會正式介紹。

## 動手試試看

1. 把 `&s[6..11]` 改成 `&s[6..12]`，看看會發生什麼（`String` 切片超出範圍會 panic）。
2. 拿掉第 35 行的註解，執行一次，讀完整 panic 訊息。
3. 改寫 `word_count`，回傳「最長的那個字」（提示：`s.split_whitespace().max_by_key(|w| w.len())`）。
4. 寫 `fn first_char(s: &str) -> Option<char>`，回傳第一個字元。
5. 把 `average` 改成接收 `&[f64]`，並用 `vec![1.0, 2.0]` 傳進去。

## 故意犯錯

| 寫法 | 結果 |
|------|------|
| `fn f(s: String)` 然後傳 `"hi"` | `expected String, found &str` |
| `&s[0..5]` 後試著 `s.push('!')` | `cannot borrow as mutable ... also borrowed as immutable`（借用規則） |
| `&zh[0..2]` | 執行期 panic：not a char boundary |

## 檢查點

- [ ] 切片和原本的集合之間是「複製」還是「借用」？
- [ ] `String` 與 `&str` 最關鍵的差別是什麼？
- [ ] 為什麼 `fn f(s: &str)` 比 `fn f(s: &String)` 好？
- [ ] `&s[..]` 代表什麼？`s.len()` 的單位是什麼？
- [ ] 中文「你好」的 `len()` 是多少？為什麼？

**07 → 08 → 09 就是 Rust 所有權系統的完整三部曲，恭喜走完最難的一段。** 接下來開始學「如何把資料組織起來」。

下一課：[10/structs.rs － 結構體](../10/README.md)
