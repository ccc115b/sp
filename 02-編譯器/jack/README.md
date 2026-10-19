# jack：用 Rust 寫一個 Jack → VM 編譯器

nand2tetris 專題 10、11 要寫一支編譯器：吃 `.jack` 原始碼，吐出 `.vm` 指令檔。
這個資料夾把它拆成 **12 個版本**，從只能編一個 `return 42;` 到整條鏈打通
（還能把自己的產物執行起來）。

每個版本都能單獨編譯、單獨執行、單獨看懂。

## 規則

* **只用 `rustc`，不用 cargo**：`rustc --edition 2021 main.rs -o out/jackc`
* **不用任何外部 crate**：只靠標準函式庫
* **零警告**：每個版本都在 `warning` 全開的預設設定下編得過
* 01–10 是**單檔**（`main.rs`），11 之後才拆模組——這樣才看得出拆的理由

## 版本對照

| 版本 | 主題 | 這版多學會的 Jack | 這版多學會的 VM |
| --- | --- | --- | --- |
| [01-hello-jack](01-hello-jack/) | 最小編譯器 | `class` `function` `return` 常數 | `function` `push constant` `return` |
| [02-let-expr](02-let-expr/) | 變數與算式 | `var` `let` 參數、`+ - * /`、括號 | `local` `argument` `add sub mul div neg` |
| [03-ops-branch](03-ops-branch/) | 分支與迴圈 | `& \| < > =` `~` `true/false/null` `if` `while` | `and or lt gt eq not`、`label goto if-goto` |
| [04-symbols](04-symbols/) | 兩層符號表 | `static` `field` `method` `this` | `static` `this` `pointer 0` |
| [05-calls](05-calls/) | 呼叫 | `do` 三種 subroutineCall | `call` `pop temp 0` |
| [06-classes](06-classes/) | 物件 | `constructor` | `Memory.alloc` |
| [07-strings](07-strings/) | 字串 | `"..."` | `String.new` `String.appendChar` |
| [08-array](08-array/) | 陣列 | `a[i]` 讀寫 | `pointer 1` `that` |
| [09-multi-file](09-multi-file/) | 多檔編譯 | 編譯整個目錄 | 跨類別呼叫（`call Cls.f n`） |
| [10-errors](10-errors/) | 錯誤處理 | 一次報多個錯、附行列與 `^` | — |
| [11-modular](11-modular/) | 拆模組 | 同一個編譯器換成 5 個檔 | — |
| [12-vm-emu](12-vm-emu/) | 堆疊機模擬器 | 把產物真的跑起來 | 全套指令 + 呼叫慣例 |

## 設計：單趟、無 AST

課本上編譯器分「詞法 → 語法（建 AST）→ 產碼」三趟。這裡刻意走另一條路：

```
原始碼 ──tokenize──▶ token 串 ──parser──▶ VM 字串
                              （邊解析邊輸出）
```

沒有 AST，`Parser` 的每個 `parse_xxx` 方法在認出語法的**同時**就把 VM 指令
接到 `out` 上。對 Jack 這種文法簡單、語意幾乎一對一對應 VM 的語言，這樣
少寫一半的程式碼，而且對照表非常清楚。

代價是錯誤處理變難：要「繼續編下去」就得自己訂同步點（10-errors 的主題）。

## 幾個 Jack 的陷阱

這些不是編譯器的 bug，是 Jack 語言本身的規定，實作時一定要照做：

* **算式沒有優先權**：`2 + 3 * 4` 是 `(2 + 3) * 4`。全部由左而右。
* **`true` 是 `push constant 0` + `not`**：也就是 -1，不是 1。
* **`a.b` 一定是呼叫**：Jack 沒有「取欄位」的語法，`a.b` 後面一定接 `(...)`。
* **裸呼叫 `f()` 一律是 `this.f()`**：想呼叫靜態函式要寫 `Cls.f()`。
* **class 變數要先宣告**：`static` / `field` 不能夾在兩個 subroutine 中間。
* **method 的參數從 `argument 1` 起算**：`argument 0` 是隱藏的 `this`。
* **label 是函式區域的**：所以每個函式的 `label_id` 要從 0 重新算。

## 每個版本的結構

```
xx-yyyyy/
├── README.md        這一版加了什麼、怎麼設計
├── EBNF.md          這一版支援的語法（12 是 VM 指令語法）
├── main.rs          編譯器原始碼（11 之後分成多個 .rs）
├── Xxx.jack         輸入範例（檔名 = 類別名）
├── expected/        預期輸出（.vm，或錯誤訊息 .err）
└── run.sh           編譯 + 比對 expected
```

## 執行

```sh
./run_all.sh          # 12 版全部跑一遍
./run_all.sh 07       # 只跑 07-strings
./run_all.sh 1        # 跑 10、11、12
```

每個 `run.sh` 只做三件事：`rustc` 編譯、把 `.jack` 編成 `.vm`、
和 `expected/` 裡的 golden file `diff`。**輸出只要差一個位元組就會失敗**，
所以「改壞了」一定會被抓到。

也可以進到單一資料夾自己玩：

```sh
cd 12-vm-emu
rustc --edition 2021 ../11-modular/main.rs -o out/jackc   # 編譯器
rustc --edition 2021 main.rs -o out/jackvm                # 模擬器
./out/jackc Main.jack out/Main.vm
./out/jackvm out/Main.vm
```

## 需求

* `rustc`（1.56 以上，支援 edition 2021）
* 不需要 cargo、不需要網路、不需要 nand2tetris 官方工具
