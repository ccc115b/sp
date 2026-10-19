# 11-modular：拆成模組

> 本版支援的語法以 EBNF 記於 [`EBNF.md`](EBNF.md)。

10-errors 那支編譯器已經有一千行，全部塞在 `main.rs` 裡。
Rust 的多檔不需要 cargo：只要在**根模組**（`main.rs`）寫 `mod xxx;`，
`rustc` 就會去找同目錄的 `xxx.rs`。

```
mod parser;      →  parser.rs
mod symbols;     →  symbols.rs
mod tokenizer;   →  tokenizer.rs
mod vm;          →  vm.rs
```

編譯指令完全沒變，`rustc` 自己會把五個檔一起編：

```sh
rustc --edition 2021 main.rs -o out/jackc
```

## 模組職責

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

依賴是單向的：`tokenizer` 與 `symbols` 誰都不靠，所以可以單獨拿出去用
（12-vm-emu 就會重複使用 `vm.rs` 的指令集概念）。

## 把「拼字」抽出來：vm.rs

原本指令字串散落在 parser 各處：

```rust
out.push_str(&format!("push {} {}\n", seg.vm(), idx));
out.push_str("pop pointer 1\n");
```

現在集中到 `vm.rs`：

```rust
pub fn push(seg: Seg, idx: usize) -> String {
    format!("push {} {}\n", seg.vm(), idx)
}

pub fn pop_pointer(n: usize) -> String {
    format!("pop pointer {}\n", n)
}
```

parser 只決定「下哪道指令、先後順序」，字面長相由 `vm` 決定：

```rust
out.push_str(&vm::push(seg, idx));
out.push_str(&vm::pop_pointer(1));
```

好處有兩個：改 VM 語法只要動一個檔；`vm.rs` 可以照 VM 規格書的章節
一條一條對，對完就相信它是對的。

## 可見性（pub）

跨模組要用 `pub` 放行，預設是模組內私有：

* `pub fn tokenize` / `pub struct Token { pub kind, pub line, pub col }`
* `pub fn vm::push` …
* `Symbols::new_class` / `begin_fn` / `declare` / `lookup` 都 `pub`，
  但 `class_map`、`n_statics` 仍是私有——外面只看得到該看的。
* `Parser`、`Sub`、`Level` 完全不對外，連 `pub` 都不用寫。

## 重構要怎麼驗證？

**改行為之前先有 golden 檔。** 11 的 `Sample.jack`、`Errors.jack`
與 `expected/` 是從 10 原封不動複製過來的：

```sh
diff -r ../10-errors/expected expected   # 應該沒有任何輸出
```

`run.sh` 用同一組 golden 檢查，所以只要輸出一個位元組不一樣就會失敗：

```sh
./run.sh
```

正常路徑比對 `Sample.vm`，錯誤路徑比對 `Errors.err` 並確認不產生 `.vm`。

## 檔案清單

```
main.rs        命令列與 I/O
tokenizer.rs   切字
symbols.rs     符號表
vm.rs          VM 指令拼字
parser.rs      語法分析 + 產生 VM 碼
Sample.jack    正常輸入
Errors.jack    故意出錯的輸入
expected/      預期輸出（與 10-errors 相同）
run.sh         編譯並比對
```
