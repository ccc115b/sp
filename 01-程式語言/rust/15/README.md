# 15 － 閉包 Closure（closures.rs）

## 這課你將學會

- 寫匿名函式 `|參數| 表達式`
- **閉包會「捕獲」外面的變數**（和一般函式最大的差別）
- 三種捕獲方式：不可變借用、可變借用、`move` 取得所有權
- 把閉包當參數傳、當回傳值傳

## 核心觀念

1. **閉包 = 可以記住環境的匿名函式**。`|x| x * factor` 讀到了外面的 `factor`。
2. **編譯器自動決定怎麼捕獲**（用最「弱」的方式就夠）：
   - `&T`：只要讀 → 不可變借用（預設）
   - `&mut T`：要改 → 可變借用（此時閉包本身要 `let mut`）
   - 所有權：加上 `move`，或閉包必須活得比環境久（例如執行緒）
3. **閉包型別每次都不同**：即使內容一樣，兩個閉包也是兩個不同型別，所以要用泛型 `F: Fn(...)` 接。
4. **三種 trait（先記名稱，之後會熟）**：
   | trait | 可呼叫次數 | 能改捕獲的值 |
   |-------|-----------|-------------|
   | `Fn` | 多次 | 否（不可變借用） |
   | `FnMut` | 多次 | 是（可變借用） |
   | `FnOnce` | 一次 | 可能拿走所有權 |

## 編譯與執行

```bash
rustc --edition 2021 15/closures.rs -o closures
./closures
```

或：`./run_all.sh 15`

## 逐步解讀

### 1. 基本語法

```rust
let add = |a, b| a + b;
add(3, 4);                                     // 7
let shout = |name: &str| -> String { format!("{}!!", name.to_uppercase()) };
```

型別通常可以推斷；要標註時寫法像函式參數。多行的閉包用 `{}` 包起來。

### 2. 捕獲環境

```rust
let factor = 3;
let times = |x| x * factor;    // 讀外面的 factor
times(10);                     // 30
```

### 3. 可變捕獲

```rust
let mut count = 0;
let mut increment = || { count += 1; };   // 閉包要 mut，因為它「改了」count
increment(); increment();
count;      // 2 —— 閉包只是借用，離開後 count 還在
```

### 4. move

```rust
let greeting = String::from("hi");
let say = move || println!("{greeting}");
say();
// println!("{greeting}");   // ← 拿掉註解：value moved into closure
```

**為什麼需要 `move`？** 當閉包要被丟給執行緒、或被回傳時，編譯器無法保證外面的變數還活著，乾脆把資料搬進閉包。

### 5. 當參數傳（本課實用重點）

```rust
fn apply<F, T>(f: F, x: i32) -> T
where F: Fn(i32) -> T,
{ f(x) }

apply(|x| x * 2, 21);          // 42
apply(|x| x.to_string(), 7);   // "7" —— 同一個函式，回傳型別也泛型化了
```

`F: Fn(i32) -> T` 代表「`f` 是一個吃 `i32` 回傳 `T` 的可呼叫物」。
這正是 14 課 `map`/`filter` 接收 `|n| ...` 的原理。

### 6. 當回傳值傳

```rust
fn make_adder(base: i32) -> impl Fn(i32) -> i32 {
    move |x| base + x     // move：base 要跟著閉包走
}
let add_100 = make_adder(100);
add_100(5);   // 105
```

**回傳閉包不能直接寫型別**（編譯器沒有那種「第 7 個匿名型別」的語法），要用 `impl Fn(...)` 或 `Box<dyn Fn(...)>`。

## 動手試試看

1. 把第 38 行 `greeting` 的註解拿掉，讀錯誤訊息，並試著把 `move` 拿掉看會怎樣（少了 `move` 時，閉包因為會活得比 `greeting` 久而出錯）。
2. 寫 `fn apply_twice<F: Fn(i32) -> i32>(f: F, x: i32) -> i32 { f(f(x)) }`，傳入 `|n| n + 1`。
3. 用閉包 + 迭代器重寫 13 課的字詞統計（`text.split_whitespace().for_each(|w| ...)`）。
4. 寫 `fn make_multiplier(factor: i32) -> impl Fn(i32) -> i32`，用法同 `make_adder`。
5. 比較 `let f = |x| x + 1;` 與 `fn f(x: i32) -> i32 { x + 1 }`，想一想為什麼閉包可以拿到外面的變數、函式不行。

## 故意犯錯

| 寫法 | 結果 |
|------|------|
| `let c = \|\| count += 1;`（count 非 mut） | `cannot borrow count as mutable` |
| 回傳 `-> \|\| i32` | 沒有這種型別語法 → 要用 `impl Fn(i32) -> i32` |
| 閉包參數與回傳型別推斷不出來 | `type annotations needed`（像 `\|\| 42` 可能不知道回傳什麼） |

## 檢查點

- [ ] 閉包跟一般函式最大的差別是什麼？
- [ ] 三種捕獲方式分別在什麼情況用到？
- [ ] `Fn`、`FnMut`、`FnOnce` 名稱中的字母各代表什麼意思？
- [ ] 為什麼 `make_adder` 裡一定要加 `move`？
- [ ] 為什麼不能用 `-> closure` 這種回傳型別？

下一課：[16/generics_traits.rs － 泛型與 trait](../16/README.md)
