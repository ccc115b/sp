# 05 － 迴圈：loop / while / for（loops.rs）

## 這課你將學會

- 三種迴圈的使用時機：`loop`、`while`、`for`
- `break` 可以「帶著回傳值」離開 `loop`
- 範圍語法 `0..5` 與 `0..=5` 的差別
- 用標籤控制巢狀迴圈
- 用 `{:>2}` 等格式印出整齊的九九乘法表

## 核心觀念

1. **`loop` = 無限迴圈**，必須靠 `break` 結束；而且 `break` 可以回傳值，讓 `loop` 整個變成一個表達式。
2. **`while` = 條件成立才繼續**，需要自己維護計數變數。
3. **`for` = 迭代一個範圍或集合**，最安全、最常用（不必擔心忘記更新計數）。
4. **範圍是半開區間**：`0..5` 是 0,1,2,3,4；`0..=5` 才包含 5。
5. **標籤 `'label:` 可以指定 break/continue 要作用在哪一層迴圈**。

## 編譯與執行

```bash
rustc --edition 2021 05/loops.rs -o loops
./loops
```

或：`./run_all.sh 05`

## 逐步解讀

### 1. loop 有回傳值

```rust
let mut n = 0;
let result = loop {
    n += 1;
    if n >= 10 {
        break n * 2;
    }
};
println!("loop 結果 = {result}");   // 20
```

這個模式在「等到某條件成立為止」時很好用，例如讀資料讀到 EOF。

### 2. while 倒數

```rust
let mut count = 3;
while count > 0 {
    println!("while 倒數：{count}");
    count -= 1;
}
```

`count -= 1` 是「減 1 並存回去」的複合指定運算子。

### 3. for 與範圍

```rust
for n in 0..5  { ... }   // 0 1 2 3 4
for n in 0..=5 { ... }   // 0 1 2 3 4 5
```

### 4. 迭代陣列與索引

```rust
let langs = ["Rust", "Go", "Python"];
for lang in langs { println!("我學過 {lang}"); }

for (index, lang) in langs.iter().enumerate() {
    println!("{index}: {lang}");
}
```

`iter()` 產生迭代器、`enumerate()` 配上索引，`for` 會把它們解包成 `(index, lang)`。
（第 14 課會深入講迭代器。）

### 5. 標籤控制巢狀迴圈

```rust
'outer: for i in 0..3 {
    for j in 0..3 {
        if i == 1 && j == 1 { break 'outer; }  // 跳出兩層
        if j == 2 { continue; }                // 只跳過內層這次
        println!("({i}, {j})");
    }
}
```

輸出 `(0,0) (0,1) (1,0)`。沒有標籤的話 `break` 只會跳出最內層。

### 6. 九九乘法表

```rust
print!("{:>2}x{:<2}={:>3}", i, j, i * j);
```

- `{:>2}` 寬度 2、右對齊
- `{:<2}` 寬度 2、左對齊
- `{:>3}` 讓結果佔 3 格

## 動手試試看

1. 把九九乘法表改成「倒著印」（9x9 往下）。
2. 用 `loop` + `break` 寫一個猜數字：自己寫死一個答案，用 `std::io` 讀輸入（這是 19 課的預告）。
3. 印出 1~100 中所有 3 的倍數，每行 5 個。
4. 用 `for` 找出 `vec![3, 1, 4, 1, 5, 9]` 的最大值。
5. 把 `continue` 那行的條件改成 `i == 0`，觀察輸出變化。

## 故意犯錯

1. 拿掉 `break` → 編譯警告或執行期停不下來（`loop` 沒有終點，編譯器會提醒你）。
2. 寫成 `for n in 5..0` → 不會執行（空範圍），因為範圍是往上走的；倒過來要用 `.rev()`。
3. 把 `'outer:` 的單引號拿掉 → `break outer` 會被當成變數，找不到就報錯。

## 檢查點

- [ ] 什麼情況你會選 `loop` 而不是 `while`？
- [ ] `0..5` 與 `0..=5` 各包含哪些數？
- [ ] `continue` 和 `break` 的差別？
- [ ] 想印出 `  1x1 =  1`，`{:>2}` 要怎麼寫？

下一課：[06/functions.rs － 函式](../06/README.md)
