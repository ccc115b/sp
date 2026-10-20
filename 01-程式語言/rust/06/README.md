# 06 － 函式（functions.rs）

## 這課你將學會

- 宣告函式、傳參數、拿回傳值
- 理解 Rust 的關鍵規則：**「函式體的最後一式（沒有分號）就是回傳值」**
- 分清楚「表達式（expression）」與「陳述式（statement）」

## 核心觀念

1. **用 `fn` 宣告函式**，可以定義在 `main` 之前或之後（沒有前後宣告的問題）。
2. **參數必須標註型別**：`fn add(a: i32, b: i32) -> i32`。
   這和 02 課的 `let` 不同——`let` 可以推斷，函式參數是介面，編譯器要先知道。
3. **回傳值用 `-> 型別`**；不寫 `->` 就是回傳單元型別 `()`。
4. **最後一式 = 回傳值**：加了分號就變成陳述式，函式會回傳 `()`，通常就會編譯錯誤。
5. **幾乎一切都是表達式**：`if`、`loop`、函式呼叫 `add(1, 2)` 都可以有值。

## 編譯與執行

```bash
rustc --edition 2021 06/functions.rs -o functions
./functions
```

或：`./run_all.sh 06`

## 逐步解讀

### 1. 基本呼叫

```rust
fn main() {
    greet("Alice");
    let sum = add(3, 4);
    println!("3 + 4 = {sum}");
}

fn greet(name: &str) {
    println!("Hello, {name}!");
}
```

`greet` 沒有 `->`，代表它回傳 `()`（什麼都沒有）。

### 2. 回傳值：最後一式

```rust
fn add(a: i32, b: i32) -> i32 {
    a + b            // ← 沒有分號，這是「回傳值」
    // a + b;       // ← 拿掉註解（加上分號）會編譯錯誤
}
```

拿掉註解後的錯誤訊息長這樣：

```
error[E0308]: mismatched types
  expected `i32`, found `()`
```

意思是「你宣告回傳 `i32`，但函式最後變成回傳 `()`」。

### 3. if 也是表達式

```rust
fn abs(n: i32) -> i32 {
    if n < 0 { -n } else { n }
}
```

整個 `if/else` 就是回傳值，不需要寫 `return`。（當然也可以寫 `return n;` 提早返回。）

### 4. 呼叫本身也是表達式

```rust
println!("add(1, 2) + add(3, 4) = {}", add(1, 2) + add(3, 4));   // 10
println!("say_nothing() 回傳值 = {:?}", say_nothing());           // ()
```

`{:?}` 是「除錯格式」，可以印出 `()` 這種沒有 `Display` 的型別。

### 5. 單元型別 ()

```rust
fn say_nothing() {}     // 不寫 -> 就是回傳 ()
```

`()` 是「什麼都沒有」的型別，也是唯一的值。04 課說過「`if` 沒有 else 時回傳 `()`」就是這個。

## 動手試試看

1. 寫一個 `fn is_leap(year: i32) bool`（閏年判斷，04 課練習過條件）。
2. 寫 `fn min(a: i32, b: i32) -> i32`，並用 `if` 表達式實作。
3. 寫 `fn celsius_to_fahrenheit(c: f64) -> f64`，印出 0 到 100 度的對照表（搭配 05 課的 `for`）。
4. 把 `add` 改成回傳元組 `(i32, i32)`（和與差），想想 `-> (i32, i32)` 要怎麼寫，呼叫端怎麼解構。
5. 寫一個沒有任何參數、也沒有回傳值的 `fn hello()`，在 `main` 裡呼叫它。

## 故意犯錯

| 寫法 | 結果 |
|------|------|
| `fn add(a: i32, b: i32) { a + b }` | 錯誤：`an expression that evaluates to a value must have unit () type`（你忘了宣告 `-> i32`） |
| `fn add(a, b) -> i32 { a + b }`（缺型別） | `parameter type is missing` |
| `fn add(a: i32, b: i32) -> i32 { a + b; }` | `mismatched types`（回傳了 `()`） |

## 檢查點

- [ ] 函式參數可以不寫型別嗎？為什麼不行？
- [ ] `-> i32` 的函式如果最後一行是 `a + b;`（有分號）會怎樣？
- [ ] 「表達式」和「陳述式」的差別？舉一個表達式的例子。
- [ ] 不寫回傳型別時，回傳值是什麼型別？

**恭喜你完成 Rust 的基礎語法部分（01–06）！** 接下來三課是 Rust 真正的靈魂：所有權 → 借用 → 切片。

下一課：[07/ownership.rs － 所有權](../07/README.md)
