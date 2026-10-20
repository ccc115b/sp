# nand2tetris：Hack 工具鏈

從 Jack 高階語言一路走到 Hack 平台執行的工具鏈，全部用 Rust 寫成：

* **只用 `rustc`，不用 cargo**
* **不用任何外部 crate**，只靠標準函式庫
* 每個元件都能單獨建置、單獨測試

## 工具鏈現況

軟體路徑——直接在自己的 VM 模擬器上跑：

```
Main.jack ──[ jack ]──▶ Main.vm ──[ vm-emu ]──▶ 執行結果
            （編譯器）             （VM 模擬器）
```

硬體路徑——一路編到 Hack 機器碼，在 CPU 模擬器上跑：

```
Main.vm ──[ vm2asm ]──▶ Main.asm ──[ hackasm ]──▶ Main.hack ──[ hackemu ]──▶ 螢幕
```

| 元件 | 狀態 | 說明 |
| --- | --- | --- |
| [jack/](jack/) | 完成 | Jack → VM 編譯器（單趟、無 AST，含錯誤恢復） |
| [vm-emu/](vm-emu/) | 完成 | VM 模擬器（堆疊機，含內建 OS 函式與 `TRACE` 除錯） |
| [vm2asm/](vm2asm/) | 完成 | VM → Hack 組合語言轉譯器（含 `mul`/`div` 輔助函式） |
| [hackasm/](hackasm/) | 完成 | Hack 組譯器（`.asm` → `.hack`） |
| [hackemu/](hackemu/) | 完成 | Hack CPU 模擬器（執行 `.hack`，螢幕印成文字） |
| [os/](os/) | 完成 | Jack 標準函式庫（`Math`、`String`、`Array`、`Output`…），在 `hackemu` 上端對端執行 |

## 目錄結構

```
nand2tetris/
├── jack/        Jack → VM 編譯器
├── vm-emu/      VM 模擬器
├── vm2asm/      VM → Hack 組合語言轉譯器
├── hackasm/     Hack 組譯器
├── hackemu/     Hack CPU 模擬器
├── os/          Jack 標準函式庫（第 12 章）
└── run_all.sh   依序建置並測試每個元件
```

各元件資料夾裡都有 `README.md`（設計說明）與 `EBNF.md`（該元件讀懂的語法）。

## 建置與測試

```sh
./run_all.sh
```

它會依序執行 `jack/run.sh`、`vm-emu/run.sh`、`vm2asm/run.sh`、
`hackasm/run.sh`、`hackemu/run.sh` 與 `os/run.sh`。每個 `run.sh` 都會把輸出
和 `expected/` 的 golden file `diff`（**差一個位元組就會失敗**）；`os` 會把
整條工具鏈跑一遍，在 `hackemu` 上實際執行整個作業系統並比對螢幕。

## 端對端跑一次

```sh
mkdir -p out
rustc --edition 2021 jack/main.rs    -o out/jackc   # 編譯器
rustc --edition 2021 vm-emu/main.rs  -o out/jackvm  # 模擬器

./out/jackc vm-emu/Main.jack out/Main.vm
./out/jackvm out/Main.vm
```

`vm-emu/Main.jack` 會建立一個 5 格陣列、填入平方值並印出，再畫一個三角形：

```
0 1 4 9 16
*
**
***
****
```

## 端對端跑作業系統

`os/run.sh` 會把第 12 章的 Jack 作業系統整條編到 Hack 機器碼並執行：

```sh
./os/run.sh    # jack → vm2asm → hackasm → hackemu，最後比對螢幕
```

詳見 [`os/README.md`](os/README.md)。

## 需求

* `rustc`（1.56 以上，支援 edition 2021）
* 不需要 cargo、不需要網路、不需要 nand2tetris 官方工具
