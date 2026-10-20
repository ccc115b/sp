# 14 － 迭代器與延遲求值（iterators.rs）

## 這課你將學會

- 迭代器的本質：一直呼叫 `next()` 直到 `None`
- 常用組合子：`map`、`filter`、`collect`、`sum`、`enumerate`...
- **延遲求值（lazy evaluation）**：不 `collect` 就不會執行
- 自己實作一個 `Iterator`（這會讓你學會 trait，16 課預告）

## 核心觀念

1. **任何實作 `Iterator` trait 的型別都能用 `for`**，而 `for` 迴圈的內部就是反覆呼叫 `next()`。
2. **組合子是延遲的**：`map`/`filter` 只是「設定要做的事」，等到真的取值才執行。這能避免建立中間陣列。
3. **`for n in v` 會拿走 `v`、`for n in &v` 只是借用**；通常用 `&v` 或 `v.iter()`。
4. **`&i32` 與 `i32`**：`.iter()` 產生 `&T`，`.iter().copied()` 產生 `T`（Copy 型別才能這樣寫）。
5. **閉包是迭代器的燃料**：`|n| n % 2 == 0` 這種匿名函式（下一課 15 課詳解）。

## 編譯與執行

```bash
rustc --edition 2021 14/iterators.rs -o iterators
./iterators
```

或：`./run_all.sh 14`

## 逐步解讀

### 1. 迭代器就是 next()

```rust
let mut it = nums.iter();
println!("{:?}", it.next());   // Some(&1)
println!("{:?}", it.next());   // Some(&2)
```

`for` 迴圈等於：

```rust
loop {
    match it.next() { Some(x) => ..., None => break }
}
```

### 2. 組合子鏈

```rust
let evens: Vec<i32> = nums
    .iter()        // 產生 &i32
    .copied()      // &i32 -> i32
    .filter(|n| n % 2 == 0)   // 留下偶數
    .map(|n| n * 10)           // 每個乘 10
    .collect();                // 收集成 Vec
```

閱讀順序由左到右就是資料流：`1..10 → 複製 → 偶數 → 乘 10 → 收集`。

### 3. 延遲求值（本課最重要的一段）

```rust
println!("（準備好囉，下面這行還不會做事）");
let lazy = nums.iter().map(|n| {
    println!("  ← map 執行了：{n}");
    n * 2
});
println!("（上面完全沒印出 map 的內容）");     // ← 真的什麼都沒印！
let doubled: Vec<i32> = lazy.collect();       // 這裡才開始跑
```

**觀察輸出順序**：那十行 `map 執行了` 全部出現在 `collect` 之後。
重點：**迭代器建立時不做事，取值時才做事**。

### 4. 一次性的常用方法

```rust
names.iter().enumerate()   // 配索引
.take(3) / .skip(8)        // 取前幾個 / 跳過前幾個
.rev()                     // 反向（範圍也能用）
.any(|n| *n > 8)           // 有沒有任何一個
.all(|n| *n > 0)           // 是不是全部
.position(|n| *n == 7)     // 在第幾個
left.iter().zip(right.iter())   // 配成一對
.iter().sum::<i32>()       // 總和
```

> 小細節：`filter` 的閉包收到 `&&T`（參照的參照），`any`/`all`/`position` 收到 `&T` 或 `T`。差別時就印出型別或看編譯器訊息。

### 5. 自訂迭代器

```rust
impl Iterator for Counter {
    type Item = u32;                     // 每次吐出的型別
    fn next(&mut self) -> Option<Self::Item> {
        if self.count < 5 { self.count += 1; Some(self.count) }
        else { None }                    // None = 結束
    }
}
```

**只要實作 `next`，所有組合子（`map`/`filter`/`collect`...）自動都有**——這就是 trait 的威力，第 16 課會正式講。

## 動手試試看

1. 把「延遲求值」那段的 `collect()` 拿掉（改成 `let _ = lazy;`），確認什麼都不會印。
2. 寫 `fn odd_sum(v: &[i32]) -> i32`，只用迭代器一行完成。
3. 把 `zip` 的結果改成 `Vec<(i32, &str)>`（用 `.copied()`）。
4. 讓 `Counter` 從 0 數到 100，再做成「只吐偶數」的迭代器。
5. 用迭代器取代 04 課的「巢狀 if 找最大值」：`nums.iter().max().unwrap()`。
6. 挑戰：實作一個 `struct Fibonacci`，迭代出前 20 個費氏數列。

## 故意犯錯

| 寫法 | 結果 |
|------|------|
| `let v = nums.iter().map(f);` 然後印 `v` | 印不出東西（迭代器本身沒有 `Display`/`Debug`），要先 `collect` |
| `Counter::new().sum()` 沒標型別 | `type annotations needed`（加 `::<i32>()` 或宣告變數型別） |
| 忘記 `None` 分支 | `not all trait items implemented` |

## 檢查點

- [ ] `next()` 回傳什麼型別？怎麼表示「結束了」？
- [ ] `map` 和 `filter` 的差別？哪個會改變元素個數？
- [ ] 什麼是延遲求值？在哪一行才真正執行？
- [ ] `.iter()`、`.iter().copied()`、`for n in v` 三者拿到的東西有何不同？
- [ ] 想自己寫迭代器，最少要實作什麼？`type Item` 是什麼？

下一課：[15/closures.rs － 閉包](../15/README.md)
