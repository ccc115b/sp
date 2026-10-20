# jack：Jack → VM 編譯器

吃 `.jack` 原始碼、吐出 `.vm` 指令檔，是這條工具鏈的**前端**。
編譯策略是**單趟、無 AST**：詞法分析後直接遞迴下降，邊解析邊把 VM 指令
接到字串上。只用標準函式庫，沒有 cargo、沒有外部 crate。

> 支援的語法以 EBNF 記於 [`EBNF.md`](EBNF.md)。

## 用法

```sh
rustc --edition 2021 main.rs -o out/jackc

./out/jackc Hello.jack              # 輸出 Hello.vm
./out/jackc Hello.jack out/Hello.vm # 指定輸出
./out/jackc src/ out/               # 編譯整個目錄
```

失敗時印出 `檔名:列:欄: error: 訊息`、該行原始碼與 `^` 指標，
並以狀態碼 1 結束；**有任何錯誤就不輸出 `.vm`**。一次會盡量回報多個錯誤。

## 模組

Rust 的多檔不需要 cargo：在根模組（`main.rs`）寫 `mod xxx;`，
`rustc` 就會去找同目錄的 `xxx.rs`。

```
mod parser;      →  parser.rs
mod symbols;     →  symbols.rs
mod tokenizer;   →  tokenizer.rs
mod vm;          →  vm.rs
```

| 模組 | 行數 | 內容 | 依賴 |
| --- | --- | --- | --- |
| `main.rs` | 111 | `mod` 宣告、命令列、讀檔寫檔 | parser |
| `tokenizer.rs` | 196 | `Kind` `Token` `Error`、`tokenize`、`report_errors` | 無 |
| `symbols.rs` | 71 | `Seg`、`Symbols`（符號表） | 無 |
| `vm.rs` | 82 | VM 指令的拼字規則 | symbols |
| `parser.rs` | 641 | 遞迴下降解析、產生 VM 碼 | tokenizer, symbols, vm |

```
main ──▶ parser ──▶ tokenizer
               └─▶ symbols ◀── vm
               └─▶ vm
```

依賴是單向的：`tokenizer` 與 `symbols` 誰都不靠，可以單獨拿出去用。

## 為什麼把「拼字」獨立成 vm.rs

指令字串若散落在 parser 各處：

```rust
out.push_str(&format!("push {} {}\n", seg.vm(), idx));
out.push_str("pop pointer 1\n");
```

就難以對照 VM 規格。集中到 `vm.rs` 後：

```rust
pub fn push(seg: Seg, idx: usize) -> String {
    format!("push {} {}\n", seg.vm(), idx)
}

pub fn pop_pointer(n: usize) -> String {
    format!("pop pointer {}\n", n)
}
```

parser 只決定「下哪道指令、先後順序」，字面長相由 `vm` 決定。
好處是改 VM 語法只要動一個檔，而且 `vm.rs` 可以照規格書一條一條核對。

## 錯誤處理

* 錯誤依 `(line, col)` 排序後一次印出；每則都指向原始碼的那個字。
* 出錯後在**安全落點**（`level` 分 `ClassVar` / `Class` / `Stmt`）恢復，
  繼續往下編，所以一次能看到多個錯誤。
* 同一段落只記**第一個**錯誤，避免連鎖抱怨。
* 詞法錯誤（無法辨識的字元、字串沒結束…）跳過壞字元繼續切，同樣能累積。

## 可見性

跨模組要用 `pub` 放行，預設是模組內私有：

* `pub fn tokenize` / `pub struct Token { pub kind, pub line, pub col }`
* `pub fn vm::push` …
* `Symbols::new_class` / `begin_fn` / `declare` / `lookup` 都 `pub`，
  但 `class_map`、`n_statics` 仍是私有。
* `Parser`、`Sub`、`Level` 完全不對外；對外只開
  `parser::compile(file, src) -> Option<String>`。

## 檔案清單

```
main.rs        命令列與 I/O
tokenizer.rs   切字
symbols.rs     符號表
vm.rs          VM 指令拼字
parser.rs      語法分析 + 產生 VM 碼
Sample.jack    正常輸入
Errors.jack    故意出錯的輸入（示範多個錯誤與錯誤恢復）
expected/      預期輸出（Sample.vm / Errors.err）
EBNF.md        本編譯器支援的語法
run.sh         編譯並比對
```

## 測試

```sh
./run.sh
```

`run.sh` 做兩件事：

1. 編 `Sample.jack`，與 `expected/Sample.vm` `diff`（正常路徑）。
2. 編 `Errors.jack`，比對 stderr 與 `expected/Errors.err`，
   並確認**沒有**產出 `out/Errors.vm`（錯誤路徑）。
