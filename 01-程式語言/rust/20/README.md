# 20 － 小專案：文字統計工具（textstats.rs）

這是本教材的**結業專案**，把 01–19 課的觀念全部串起來。

## 這課你將學會

- 讀一個實際的專案，理解它是怎麼被**拆成「資料結構 → 方法 → 主流程」**三層
- 看出每個語法背後對應的是哪一課
- 知道一個小程式該如何處理錯誤、回傳有意義的結束狀態碼

## 程式在做什麼

輸入一個或多個文字檔案，對每個檔案輸出：

- 行數、字數、字元數、位元組數
- 最常出現的 5 個字詞

多個檔案時另外印「全部合計」。

## 編譯與執行

```bash
rustc --edition 2021 20/textstats.rs -o textstats

./textstats 20/textstats.rs                      # 分析一個檔案
./textstats README.md 20/textstats.rs            # 多個檔案，最後加總
./textstats                                       # 沒給參數 → 印用法，exit 2
./textstats 不存在的檔案.txt                      # 讀取失敗 → 印錯誤，exit 1
```

或：`./run_all.sh 20`

試試 `./textstats 14/iterators.rs` 和 `./textstats 13/collections.rs`，比較兩課的常用字詞。

## 程式結構（讀程式碼前先看這張圖）

```
main()
 ├─ env::args() 取得參數          ← 19 課
 ├─ Stats::default()              ← 10 課 struct、#[derive(Default)]
 ├─ for 每個檔案:
 │    ├─ analyze(path)            ← 12 課 Result + ?
 │    │    ├─ fs::read_to_string  ← 19 課
 │    │    ├─ lines/split_whitespace/chars().count()  ← 14 課 迭代器
 │    │    └─ entry().or_insert() ← 13 課 HashMap 計數
 │    ├─ stats.table()            ← 10 課方法、01 課格式化
 │    └─ total.merge(&stats)      ← 08 課 借用 &mut / &
 ├─ 失敗時 exit(1)                ← 12 課 錯誤處理
 └─ 參數不對時 exit(2)
```

## 逐段解讀

### 1. 資料結構與方法（第 10、16 課）

```rust
#[derive(Default, Debug)]
struct Stats {
    lines: usize,
    words: usize,
    chars: usize,
    bytes: usize,
    top_words: HashMap<String, usize>,
}
```

`#[derive(Default)]` 讓 `Stats::default()` 自動把所有欄位設成 0 / 空集合。
方法區塊裡有三個函式：`merge`（併入）、`top`（取前 n 名）、`table`（排版）。

### 2. 錯誤處理（第 12 課）

```rust
fn analyze(path: &str) -> Result<Stats, std::io::Error> {
    let text = fs::read_to_string(path)?;   // 讀不到就直接回傳 Err
    ...
    Ok(stats)                                // 成功要記得用 Ok 包起來
}
```

`main` 裡用 `match` 分別處理 `Ok` / `Err`，失敗**不中止整個程式**，而是繼續處理其他檔案，最後統一 `exit(1)`。

### 3. 排序取前 n 名（第 14 課迭代器 + 閉包）

```rust
let mut list: Vec<(String, usize)> = self.top_words.iter()
    .map(|(w, c)| (w.clone(), *c))       // 開放值的所有權
    .collect();
list.sort_by(|a, b| b.1.cmp(&a.1)        // 次數由大到小
                  .then(a.0.cmp(&b.0))); // 次數相同就依字母
list.truncate(n);
```

`b.1.cmp(&a.1)` 是**倒序**（故意把 a、b 對調）；`.then(...)` 是次要排序鍵。

### 4. 統計字詞（第 13 課 HashMap）

```rust
for raw in text.split(|c: char| !c.is_alphanumeric()) {
    if raw.is_empty() { continue; }
    let word = raw.to_lowercase();
    if word.chars().count() > 1 {
        *stats.top_words.entry(word).or_insert(0) += 1;
    }
}
```

拆解：以「非字母數字」為分隔符切字 → 轉小寫 → 篩掉單一字元 → 計數。
`text.split(閉包)` 接收的正是 15 課的閉包。

### 5. 退出狀態碼的慣例

| 狀態碼 | 意義 |
|--------|------|
| `0` | 成功 |
| `1` | 執行時錯誤（檔案讀不到） |
| `2` | 用法錯誤（忘了給參數） |

命令列工具普遍遵守這個慣例，shell 腳本才能用 `$?` 判斷結果。

## 動手試試看（由易到難）

1. **倒著印**：把 `table()` 改成「最少出現的 5 個字」。
2. **調整篩選**：把 `word.chars().count() > 1` 改成 `>= 3`，比較結果變化。
3. **加欄位**：統計「最長的那個字是什麼」（用 `split_whitespace().max_by_key(|w| w.len())`）。
4. **加欄位**：句子數（以 `.`、`。`、`!`、`?` 結尾算一句）。
5. **輸出格式**：把 `table()` 改成 CSV 輸出（`lines,words,chars,bytes`）。
6. **讀 stdin**：若沒給參數就從 `stdin` 讀文字（改用 19 課的 `read_line` 或讀整個 stdin）。
7. **進階**：加 `--top N` 參數，讓使用者指定要列幾名（練習參數解析）。
8. **挑戰**：把程式改成 18 課的多檔案結構（`main.rs` + `stats.rs` + `cli.rs`），練習模組拆分。

## 檢查點（結業自評）

能回答以下問題，就代表 01–20 都學會了：

- [ ] `?` 運算子在 `Ok` 與 `Err` 時各做什麼？為什麼 `analyze` 最後要寫 `Ok(stats)`？
- [ ] `#[derive(Default)]` 替我們省了什麼事？
- [ ] `*stats.top_words.entry(word).or_insert(0) += 1` 每個符號的作用？
- [ ] `merge(&mut self, other: &Stats)` 的 `&mut` 與 `&` 各為什麼必要？
- [ ] 為什麼「讀取失敗」不直接 `panic!`，而要記在 `failed` 最後才 `exit(1)`？
- [ ] 這支程式用到了哪幾課的觀念？（至少說出 6 課）

---

## 走完 20 課之後

- 回頭重讀 [07 所有權](../07/README.md)、[08 借用](../08/README.md)、[17 生命週期](../17/README.md)，你會發現理解完全不同了。
- 接下來建議學 **Cargo**：`cargo new myproject`、依賴管理、`cargo test`（本教材刻意不用 Cargo，是為了先專注在語言本身）。
- 然後依序接觸：`enum` 建模、`trait` 設計、錯誤處理慣例（`thiserror`/`anyhow` 的概念）、測試、並行（`std::thread` 與 `Arc`/`Mutex`）。

回總目錄：[README.md](../README.md)
