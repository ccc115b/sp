# 19 － 檔案讀寫、命令列參數、標準輸入（file_io.rs）

## 這課你將學會

- 讀取命令列參數
- 寫入、覆寫、追加、逐行讀取檔案
- 從 `stdin` 讀一行
- 把 `main` 的回傳型別改成 `Result`，讓 `?` 一路用到最上面

## 核心觀念

1. **Rust 的檔案 I/O 全在標準庫 `std::fs`、`std::io`**，不需要任何外部套件。
2. **檔案函式回傳 `Result`**，所以本課通篇都在用 `?`（12 課的應用）。
3. **逐行讀取用 `BufReader`**：有緩衝，避免一個 byte 一個 byte 讀。
4. **`main() -> Result<(), Box<dyn Error>>`**：有 `Err` 時 Rust 會自動印出錯誤，並以非 0 狀態碼結束。
5. **`print!` 不會自動 flush**：要在同一行接續輸入時，得手動 `io::stdout().flush()?`。

## 編譯與執行

```bash
rustc --edition 2021 19/file_io.rs -o file_io

./file_io                 # 沒有額外參數
./file_io hello world     # 帶兩個參數
```

或：`./run_all.sh 19`（腳本會自動餵一行輸入給 stdin）

> 執行後會在**目前資料夾**產生 `example_output.txt`，可以 `cat example_output.txt` 看內容。
> （本資料夾的 `.gitignore` 已忽略這個檔案。）
> 這個程式會停下來等你輸入名字，按 Enter 繼續。

## 逐步解讀

### 1. 命令列參數

```rust
let args: Vec<String> = env::args().collect();
println!("程式：{}", args[0]);        // 第 0 個是程式路徑本身
println!("其他參數：{:?}", &args[1..]);
if let Some(first) = args.get(1) { ... }   // get 回傳 Option，安全
```

**`args[0]` 不是第一個使用者參數**——這是和很多語言相同的慣例。

### 2. 寫入檔案（一次覆寫）

```rust
fs::write(path, "第一行\n第二行\n第三行\n")?;
```

`?` 處理 `Result`；失敗的話 `main` 直接回傳錯誤。

### 3. 逐行讀取

```rust
let file = fs::File::open(path)?;
let reader = BufReader::new(file);            // 有緩衝
for (index, line) in reader.lines().enumerate() {
    println!("{}: {}", index + 1, line?);     // 每一行都是 Result<String, _>
}
```

`lines()` 產生 `Result<String, io::Error>`，因為**讀到一半可能失敗**（檔案被拔掉、編碼錯誤）。

### 4. 追加寫入

```rust
let mut file = OpenOptions::new().append(true).open(path)?;
writeln!(file, "第四行")?;      // writeln! 巨集，自動加換行
```

`OpenOptions` 是流介面（builder pattern）：`.append(true)` 回傳自己，可以繼續串。

### 5. 讀使用者輸入

```rust
print!("請輸入你的名字：");
io::stdout().flush()?;                  // 讓提示立刻顯示出來
let mut name = String::new();           // 必須先有空字串
io::stdin().read_line(&mut name)?;      // 以可變借用傳入，讀完會含 "\n"
println!("你好，{}！", name.trim());     // trim 掉換行
```

`read_line` 會**附加**（append）到字串後面，所以字串要先宣告成 `mut` 且不能是空的常數。

### 6. 依錯誤做不同反應

```rust
match fs::read_to_string("不存在的檔案.txt") {
    Ok(text) => println!("意外讀到了：{text}"),
    Err(e) => println!("預期中的錯誤（{}）：{e}", e.kind()),
}
```

`e.kind()` 回傳 `ErrorKind` 枚舉（11 課的觀念），可以區分「不存在」、「沒權限」等。

## 動手試試看

1. 把 `args.get(1)` 改成 `args.get(1).map(|s| s.to_uppercase())`，傳參數進去試。
2. 加一個功能：若第一個參數是 `cat`，就把第二個參數的檔案印出來（迷你 `cat` 指令）。
3. 把覆寫 `fs::write` 改成追加 `OpenOptions::new().append(true)`，跑兩次看結果。
4. 用 `BufReader` 統計 `19/file_io.rs` 自己有幾行（這正是 20 課要做的事）。
5. 把 `main` 改回 `fn main()` 且不用 `?`，改用 `match` 處理每個檔案操作，比較兩種寫法的長度。

## 故意犯錯

| 寫法 | 結果 |
|------|------|
| `File::open("x.txt").unwrap()` 檔案不存在 | 執行期 panic |
| `let s = String::new();` 然後直接 `read_line(&s)` | `cannot borrow as mutable`（要 `mut` 且可變借用） |
| 忘記 `stdout().flush()` 就 `read_line` | 提示訊息不會立刻出現（緩衝未送出） |
| `fs::write(path, data)` 檔案在不存在的資料夾 | `No such file or directory` |

## 檢查點

- [ ] `env::args()` 的第 0 個元素是什麼？
- [ ] `fs::write` 和 `OpenOptions::append` 的差別？
- [ ] 為什麼 `lines()` 的每個元素都是 `Result`？
- [ ] `main` 回傳 `Result` 時，失敗會發生什麼？
- [ ] 讀 stdin 之前為什麼要先 `flush`？

下一課：[20/textstats.rs － 小專案](../20/README.md)
