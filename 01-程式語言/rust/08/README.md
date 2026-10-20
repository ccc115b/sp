# 08 － 參照與借用 References（references.rs）

## 這課你將學會

- 用 `&T` 借用而不奪走所有權
- 用 `&mut T` 修改別人的資料
- **借用規則**：為什麼「任意多個不可變借用」與「恰好一個可變借用」不能同時存在
- 理解 non-lexical lifetimes（編譯器看「最後一次使用」而非「大括號結尾」）

## 核心觀念

1. **`&x` 是參照（reference）＝借用（borrow）**：只是「看」，不拿走所有權，函式結束後原變數還在。
2. **`&mut x` 是可變借用**：可以改內容，但同一時間只能有一個。
3. **借用規則（同一作用域內）**：
   - 要嘛有任意多個 `&T`（大家一起讀）
   - 要嘛有恰好一個 `&mut T`（只有一個人能寫）
   - 這兩者不能同時存在
4. **目的是什麼？** 編譯期排除資料競爭（data race）：資料競爭的三條件是「兩個執行緒同時存取、其中至少一個是寫入、沒有同步」——規則 1+2 正好把中間那條斷掉。

## 編譯與執行

```bash
rustc --edition 2021 08/references.rs -o references
./references
```

或：`./run_all.sh 08`

## 逐步解讀

### 1. 不可變借用：借用不奪走

```rust
let s1 = String::from("hello");
let len = calculate_length(&s1);
println!("「{s1}」長度 = {len}（s1 還在！）");
```

對比 07 課：`takes_ownership(s1)` 之後就不能用 `s1` 了；但 `calculate_length(&s1)` 之後 `s1` 完好如初。

```rust
fn calculate_length(s: &String) -> usize { s.len() }
//   ^^^^ 參數型別 &String，代表「我借用它，但我不擁有它」
```

### 2. 可變借用：真的改到內容

```rust
let mut s2 = String::from("hello");
change(&mut s2);
println!("修改後：{s2}");     // hello, world

fn change(s: &mut String) { s.push_str(", world"); }
```

兩個必要條件：變數本身要 `mut`，而且要傳 `&mut`。

### 3. 同時只能有一個可變借用

```rust
let r1 = &mut s3;
// let r2 = &mut s3;    // ← 拿掉註解：cannot borrow `s3` as mutable more than once
r1.push_str("!");
```

編譯器會明說第二個借用在哪裡發生，並指出第一個借用還活著（`r1` 後面被用了）。

### 4. 可以有很多個不可變借用

```rust
let r3 = &s3;
let r4 = &s3;
println!("r3 = {r3}, r4 = {r4}");   // 讀幾次都不會互相干擾
```

### 5. Non-lexical lifetimes：借用「用完就算了」

```rust
let mut s4 = String::from("abc");
let a = &s4;
println!("用到不可變借用 a：{a}");   // a 最後一次使用
let b = &mut s4;                    // 這裡開始可變借用是合法的！
b.push('d');
```

早期 Rust 要求「可變借用出現前，所有不可變借用必須離開大括號」，現在編譯器看的是**最後一次使用的位置**（這就是 non-lexical lifetimes）。

### 6. 慣用寫法（先記住，16 課會再講）

```rust
fn sum(v: &Vec<i32>) -> i32      // 能用，但不夠通用
fn sum(v: &[i32]) -> i32         // 慣用：陣列與 Vec 都能傳進來（見下一課切片）
fn calculate_length(s: &String)   // 只能收 String
fn calculate_length(s: &str)      // 慣用：String 與 "字面值" 都能收
```

## 動手試試看

1. 把第 25 行 `r2` 的註解拿掉，讀完整錯誤訊息（注意它指出的兩個行號）。
2. 在第 36 行 `let a = &s4;` 後面、`a` 被使用之前插入 `let b = &mut s4;`，比較「a 還沒被用過」與「a 已經被用過」兩種情況。
3. 嘗試同時寫 `let r1 = &s3; let r2 = &mut s3;` → 能編譯嗎？
4. 把 `calculate_length` 改成回傳 `String`（不回傳 `usize`），確認仍然只借用。
5. 思考題：為什麼多個 `&` 是安全的，`&mut` 卻要唯一？（提示：只有「寫入」才會讓讀到的資料變質。）

## 故意犯錯

| 寫法 | 結果 |
|------|------|
| `let r = &mut x;`（x 沒有 `mut`） | `cannot borrow as mutable, as it is not declared as mutable` |
| 兩個 `&mut x` 同時存在 | `cannot borrow ... as mutable more than once` |
| `&x` 與 `&mut x` 同時活著 | `cannot borrow ... as mutable because it is also borrowed as immutable` |

## 檢查點

- [ ] 「借用」和「移轉」的差別？借的人能銷毀原資料嗎？
- [ ] 借用規則兩條，請完整說出來。
- [ ] 為什麼編譯器要擋下兩個同時存在的 `&mut`？
- [ ] `fn f(s: String)` 和 `fn f(s: &String)` 對呼叫端的影響差在哪？
- [ ] 什麼是 non-lexical lifetimes？它讓什麼寫法變合法了？

下一課：[09/slices.rs － 切片](../09/README.md)
