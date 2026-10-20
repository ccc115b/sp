# 12 － 錯誤處理：panic 與 Result（error_handling.rs）

## 這課你將學會

- Rust 把錯誤分成「不可恢復」與「可恢復」兩類
- `Result<T, E>` 的用法，以及 `match` 怎麼處理
- `?` 運算子：讓錯誤一路往上傳，不寫巢狀 if-else
- `unwrap` / `expect` / `unwrap_or` 的取捨

## 核心觀念

| | 不可恢復 | 可恢復 |
|---|---|---|
| 型別 | `panic!` | `Result<T, E>` |
| 行為 | 中止程式（或被 catch_unwind 接住） | 回傳給呼叫者決定怎麼辦 |
| 適用 | 程式本身的邏輯錯誤（違反不變式） | 預期中的問題（檔案不存在、網路失敗） |

1. **`Result<T, E>` 是一個 enum**：`Ok(T)` 或 `Err(E)` —— 正好承接 11 課的觀念。
2. **`?` 運算子**：`Ok` 就取出值，`Err` 就**直接把錯誤 return 回呼叫者**，是 Rust 錯誤處理的核心語法。
3. **`unwrap()` 會在 `Err` 時 panic**：原型可用，正式程式要小心。
4. **`main` 也可以回傳 `Result`**（型別要是 `Result<(), E>`），有錯時程式以非 0 狀態碼結束。

## 編譯與執行

```bash
rustc --edition 2021 12/error_handling.rs -o error_handling
./error_handling
```

或：`./run_all.sh 12`

## 逐步解讀

### 1. panic：不可恢復

```rust
// let v = vec![1, 2, 3];
// let _x = v[99];        // ← 拿掉註解：index out of bounds
// panic!("自訂的錯誤訊息");
```

拿掉第一行註解試一次，並用 `RUST_BACKTRACE=1 ./error_handling` 看堆疊。

### 2. 用 match 處理 Result

```rust
match read_first_line("這個檔案一定不存在.txt") {
    Ok(text) => println!("讀到了：{text}"),
    Err(e) => println!("預期中的錯誤：{e}"),
}
```

### 3. 依錯誤種類分支

```rust
Err(e) if e.kind() == ErrorKind::NotFound => {
    println!("檔案不存在 → 可以自動建立");
}
```

`if` 接在模式後面叫做 **match guard**（11 課學過），可以依錯誤種類給不同處理。

### 4. unwrap / expect / unwrap_or

```rust
ok.expect("這應該是 Ok");        // Err 時 panic，並印出這段自訂訊息
missing.clone().unwrap_or(0);    // Err 時用 0，不 panic
missing.unwrap_or_else(|e| { ...; -1 });  // 錯誤本身也能拿來用
```

選法：**確定不會錯用 `expect`（記得寫清楚為什麼不會錯）；可能錯就用 `match` 或 `unwrap_or`。**

### 5. ? 運算子（本課重點）

```rust
fn read_first_line(path: &str) -> Result<String, io::Error> {
    let mut file = File::open(path)?;      // 失敗就把 Err 原本 return 出去
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;   // 同上
    Ok(contents.lines().next().unwrap_or("").to_string())
}
```

**寫法上是「成功路徑」，失敗自然往上冒泡**：

```rust
fn run() -> Result<i32, Box<dyn std::error::Error>> {
    let a = parse_number("10")?;   // 有錯就直接回傳
    let b = parse_number("20")?;
    Ok(a + b)                      // 最後記得用 Ok(...) 包起來
}
```

等價於（但非常囉唆）：

```rust
let a = match parse_number("10") { Ok(v) => v, Err(e) => return Err(e.into()) };
```

> `?` 會自動做型別轉換（需要 `From` trait），所以 `Box<dyn Error>` 能接下各種不同的錯誤型別。

### 6. 給人看的錯誤訊息

```rust
if let Err(e) = do_work() {
    eprintln!("失敗了：{e}");   // eprintln! 印到 stderr，不污染一般輸出
    std::process::exit(1);      // 非 0 狀態碼讓 shell 知道失敗了
}
```

## 動手試試看

1. 拿掉第 12-14 行的註解，用 `RUST_BACKTRACE=1` 執行一次，看堆疊長相。
2. 把 `parse_number("10")` 改成 `parse_number("abc")`，觀察錯誤怎麼傳到 `main`。
3. 把 `main` 改成 `fn main() -> Result<(), Box<dyn std::error::Error>>`，裡面用 `?` 呼叫 `do_work()?;`，比較兩種寫法。
4. 讓 `read_first_line` 在檔案不存在時回傳預設值（用 `unwrap_or_else` 寫在函式裡）。
5. 依 `File::open` 的錯誤種類，分別處理 `PermissionDenied` 與 `NotFound`。

## 故意犯錯

| 寫法 | 結果 |
|------|------|
| `fn f() -> i32 { File::open("x")? }` | `?` 的回傳型別對不上（`i32` 不是 `Result`） |
| `let x = File::open("x").?;` | 語法錯誤，`?` 是運算子不是方法 |
| `bad.unwrap()`（值為 Err） | 執行期 panic |

## 檢查點

- [ ] 什麼情況用 `panic`、什麼情況用 `Result`？
- [ ] `?` 在 `Ok` 與 `Err` 時各做什麼？
- [ ] `expect` 和 `unwrap` 的差別？
- [ ] `unwrap_or` 與 `unwrap_or_else` 的差別（效能上）？
- [ ] 為什麼錯誤訊息要用 `eprintln!` 而不是 `println!`？

下一課：[13/collections.rs － 標準集合](../13/README.md)
