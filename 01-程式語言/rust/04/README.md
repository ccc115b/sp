# 04 － 條件判斷 if / else（control_flow.rs）

## 這課你將學會

- 寫 `if` / `else if` / `else`
- 理解「**if 是表達式**」——這是 Rust 和很多語言最大的不同
- 學會用元組一次宣告多個變數

## 核心觀念

1. **條件不需要小括號，但必須是 `bool`**：不能像 C 寫 `if (x)` 用非 0 當 true。
2. **if 可以有回傳值**：`let g = if 條件 { 值A } else { 值B };`
   各分支的型別必須一致，否則編譯錯誤。
3. **分支的最後一式就是該分支的值**（沒有分號才有值）。
4. **`if` 不加 else 时，回傳的是單元型別 `()`**。
5. **元組解構**：`let (a, b, c) = (10, 25, 17);` 一次宣告三個。

## 編譯與執行

```bash
rustc --edition 2021 04/control_flow.rs -o control_flow
./control_flow
```

或：`./run_all.sh 04`

## 逐步解讀

### 1. 基本分支

```rust
let score = 87;
if score >= 90 {
    println!("A");
} else if score >= 80 {
    println!("B");
} ...
```

輸出 `B`。注意 87 同時滿足 `>= 80`，但 `else if` 是「由上而下，第一個符合就做」。

### 2. if 是表達式

```rust
let grade = if score >= 90 {
    "優"
} else if score >= 80 {
    "良"
} else {
    "加油"
};
println!("評等：{grade}");   // 良
```

三個分支都回傳 `&str`，所以 `grade` 的型別是 `&str`。
把其中一個分支改成 `100`（下面第 31 行有現成的範例）就會編譯失敗：

```
error[E0308]: `if` and `else` have incompatible types
```

### 3. 找最大值的寫法

```rust
let (a, b, c) = (10, 25, 17);
let mut max = a;
if b > max { max = b; }
if c > max { max = c; }
```

這是「可變變數 + 連續判斷」的典型範式。未來在 07/08 課你會學到另一種寫法（用迭代器 `max()`）。

### 4. 三元運算子的替代

C 的 `a > b ? "x" : "y"` 在 Rust 就是：

```rust
let label = if a > b { "a 較大" } else { "b 較大或相等" };
```

## 動手試試看

1. 把 `score` 改成 95、72、59，確認分支正確。
2. 改寫成「輸入分數，印出 A/B/C/D 與對應的文字說明」。
3. 寫一個判斷閏年的函式（能被 4 整除但不能被 100 整除，或能被 400 整除）：
   ```rust
   fn is_leap(year: i32) -> bool {
       (year % 4 == 0 && year % 100 != 0) || year % 400 == 0
   }
   ```
   （這是第 06 課的預告：函式寫法）
4. 把巢狀 `if` 找最大值的版本，改寫成 `if b > max && b > c { ... }` 的單次判斷。

## 故意犯錯

1. 把條件寫成 `if score = 80` → 錯誤：`expected expression, found assignment`（`==` 才是比较）。
2. 把 `let bad = if score >= 90 { "優" } else { 100 };` 的註解拿掉 → 分支型別不一致。
3. 把條件寫成 `if score` → `expected bool, found integer`。

## 檢查點

- [ ] `if` 後面可以加小括號嗎？一定要加嗎？
- [ ] 為什麼 `{ "優" }` 後面不能有分號？（有分號會變成什麼？）
- [ ] `let x = if true { 1 } else { 2 };` 的 `x` 是什麼型別？
- [ ] 用一句話說明「表達式」和「陳述式」的差別。

下一課：[05/loops.rs － 迴圈](../05/README.md)
