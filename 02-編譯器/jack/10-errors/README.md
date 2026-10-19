# 10-errors：錯誤處理與錯誤恢復

> 本版支援的語法以 EBNF 記於 [`EBNF.md`](EBNF.md)。

前面九個版本只要遇到第一個錯就 `exit(1)`。編譯器真正上線時不能這樣：
使用者打錯一個字，卻要一改再改、一跑再跑。這一版要做到

* **一次回報多個錯誤**
* **每則錯誤都有 檔名:列:欄**，並指出原始碼的那個字
* **有任何錯誤就不輸出 `.vm`**（避免產生半成品）

## 錯誤報告格式

```
$ ./out/jackc Errors.jack out/Errors.vm
Errors.jack:7:13: error: 變數 missing 未宣告
        let n = missing + 1;
                ^
Errors.jack:8:13: error: 預期算式但遇到 ';'
        let n = ;
                ^
...
共 6 個錯誤
```

格式固定為：

```
<file>:<line>:<col>: error: <msg>
<該行原始碼>
<空白>^                ← 指標對準 col
共 N 個錯誤
```

`Token` 因此多了 `line`、`col` 兩個欄位；`col` 的算法是
`目前索引 - 本行起始索引 + 1`，所以製表字元也算一個字。

## 錯誤恢復（error recovery）

要「繼續編下去」，就得在出錯後猜一個**安全落點**，把中間的 token 丟掉。
安全落點看層級而定：

| 層級 | 從哪裡恢復 | 落點（stop set） |
| --- | --- | --- |
| `ClassVar` | class 變數宣告 | `static` `field` `function` `method` `constructor` `}` |
| `Class` | subroutine 之間 | `function` `method` `constructor` `}` |
| `Stmt` | 陳述之間 | `let` `if` `while` `do` `return` `}` |

```rust
fn synchronize(&mut self, level: Level) {
    self.failed = false;
    if self.at_stop(level) { return; }   // 已經在落點就別亂丟
    self.pos += 1;                        // 至少前進一格，保證收斂
    while !self.at_eof() && !self.at_stop(level) { self.pos += 1; }
}
```

「至少前進一格」是關鍵：否則目前這個 token 剛好不在 stop set 裡時，
會原地打轉變成無窮迴圈。

## 同一段落只記第一個錯誤

錯誤常常連鎖。例如 `let n = missing + 1;` 一旦 `missing` 沒宣告，
後面 `+ 1`、`;` 可能全部跟著抱怨，但全都是同一個原因。

`Parser` 用一個 `failed` 旗標擋掉：`record()` 只在 `failed == false` 時記錄，
記完就設 `true`；直到 `synchronize()` 才清除。

```rust
fn record(&mut self, line: usize, col: usize, msg: &str) {
    if self.failed { return; }
    self.failed = true;
    self.errors.push(Error { line, col, msg: msg.to_string() });
}
```

所以上面那段只有一個錯誤（指向 `missing`），不會連噴四行。

## 詞法錯誤的恢復

詞法錯誤不需要落點，只要**跳過壞字元**繼續切就好，所以可以一次回報多個：

```rust
// 詞法錯誤：記下來，略過這個字元繼續切
errs.push(Error { line: tok_line, col: tok_col, msg: format!("無法辨識的字元 '{}'", c) });
i += 1;
```

同類的還有「整數常數過大」（記錯後當成 `0` 繼續）、
「區塊註解沒結束」、「字串沒結束」。

`tokenize()` 的簽章因此改成回傳一組：

```rust
fn tokenize(src: &str) -> (Vec<Token>, Vec<Error>)
```

## 兩種錯誤合流

詞法錯誤在 `tokenize` 就收集完，語法錯誤在 `Parser` 裡邊解邊收集。
最後把兩邊倒在一起、依 `(line, col)` 排序後一次印出：

```rust
parser.errors.sort_by_key(|e| (e.line, e.col));
report_errors(&file, &source, &parser.errors);
```

`report_errors` 需要原始碼全文，才能印出出錯的那一行與 `^` 指標，
所以 `compile()` 先切好 `Vec<String>` 再交給它。

## 先切字、再解析的妙用

`ClassVar` 這個層級是為了處理「class 變數寫在 subroutine 後面」——
那是文法錯誤，但如果直接報錯就整檔報廢，所以要能跳過該宣告、繼續編下去。

## 執行

```sh
./run.sh
```

`run.sh` 做兩件事：

1. 編 `Sample.jack`，與 `expected/Sample.vm` `diff`（正常路徑）
2. 編 `Errors.jack`，比對 stderr 與 `expected/Errors.err`，
   並確認**沒有**產出 `out/Errors.vm`（錯誤路徑）

## 輸入

`Sample.jack`：沒有錯誤的類別，含 `static`/`field`/constructor/method。

`Errors.jack`：故意放五處錯，每處都能獨立恢復：

| 行 | 內容 | 錯誤 |
| --- | --- | --- |
| 7 | `let n = missing + 1;` | 變數 `missing` 未宣告 |
| 8 | `let n = ;` | 預期算式但遇到 `;` |
| 9 | `let n = 2 @ 3;` | 無法辨識的字元 `@`，後面再補一個缺 `;` |
| 10 | `do Output.printInt(n)` | 缺 `;`（在下一行的 `let` 上報錯） |
| 12 | `var int after;` | `var` 必須在所有陳述之前 |

第 9 行同時展示了詞法錯誤與語法錯誤：`@` 被跳過後，
`2` 和 `3` 之間就沒有運算子，於是在 `3` 上再報一次。

## 輸出

`expected/Sample.vm`（正常路徑）。

`expected/Errors.err`（錯誤路徑），節錄：

```
Errors.jack:9:15: error: 無法辨識的字元 '@'
        let n = 2 @ 3;
                  ^
Errors.jack:9:17: error: 預期 ';' 但遇到 整數 3
        let n = 2 @ 3;
                    ^
```
