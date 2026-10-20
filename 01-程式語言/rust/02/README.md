# 02 － 變數、常數與可變性（variables.rs）

## 這課你將學會

- 建立變數，並理解「預設不可變」這個 Rust 最反直覺、也最重要的設計
- 分清楚 `let`、`let mut`、`const` 的差別
- 理解型別推斷，以及什麼是 shadowing（遮蔽）

## 核心觀念

1. **`let` 建立的變數預設不可變（immutable）**：不能重新指定值。要可變必須寫 `let mut`。
   → 意圖不明的資料修改是 bug 的大宗，Rust 逼你明講哪些東西會變。
2. **`const` 是常數**：必須標註型別、必須是常數運算式、命名慣例全大寫，而且不能用 `mut`。
3. **型別可以推斷，也可以標註**：`let x = 5;` 推斷成 `i32`；`let z: i64 = ...` 則明講。
4. **shadowing＝用同名變數蓋掉舊的**：建立的是「全新」變數，所以型別可以不同；`mut` 則是改變同一個變數，型別不能變。

## 編譯與執行

```bash
rustc --edition 2021 02/variables.rs -o variables
./variables
```

或：`./run_all.sh 02`

## 逐步解讀

### 1. 不可變是預設

```rust
let x = 5;
println!("x = {x}");
// x = 6;  // ← 取消註解會編譯錯誤：cannot assign twice to immutable variable
```

請真的把那行註解拿掉，讀一次完整的錯誤訊息。編譯器會告訴你第 8 行的 `x` 是在哪裡宣告的。

### 2. 需要會變時才加 mut

```rust
let mut y = 10;
println!("y 的初始值 = {y}");
y = 20;
println!("y = {y}");
```

`mut` 只代表「值可以被改」，不代表「一定會被改」。

### 3. 底線是分隔符

```rust
let z: i64 = 1_000_000;   // 等於 1000000，只是比較好讀
const MAX_SCORE: u32 = 100;
```

### 4. shadowing 與區塊

```rust
let spaces = "   ";        // &str
let spaces = spaces.len(); // 變成 usize
println!("空白字元數 = {spaces}");

let n = 5;
let n = n + 1;          // 區塊外的 n 是 6
{
    let n = n * 10;     // 區塊內的 n 是 60
    println!("區塊內 n = {n}");
}
println!("區塊外 n = {n}");  // 仍然是 6
```

**大括號 `{}` 開出一個作用域（scope）**，裡面宣告的變數離開作用域就消失了。這和第 07 課「所有權」直接相關，請先記住這條規則。

## 動手試試看

1. 把 `let x = 5;` 改成 `let mut x = 5;`，讓 `x = 6;` 可以編譯，比較兩種寫法。
2. 寫一個 `const`：例如 `const PI: f64 = 3.14159;` 並印出來。
3. 嘗試 `let mut y = 10; y = "十";` → 會發生什麼事？（可變但型別不同）
4. 在 `let spaces = spaces.len();` 之後加 `let spaces = spaces as f64;`，再印一次。

## 故意犯錯

| 寫法 | 結果 |
|------|------|
| `let x = 5; x = 6;` | `cannot assign twice to immutable variable` |
| `const C = 1;`（缺型別） | `missing type for constant` |
| `let mut y = "hi"; y = 1;` | `mismatched types`（mut 不能改型別） |

## 檢查點

- [ ] 想要「可以被重新賦值」的變數怎麼寫？
- [ ] `const` 與 `let` 有什麼不同？（至少說出三點）
- [ ] shadowing 與 `mut` 的關鍵差異是什麼？
- [ ] 區塊裡宣告的變數，離開區塊後還在嗎？

下一課：[03/types.rs － 基本型別與運算](../03/README.md)
