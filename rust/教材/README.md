# Rust 初學範例（20 課）

這裡是給 Rust 初學者的教材，每一課一個資料夾，**只用 `rustc` 就能編譯執行，不需要 Cargo、也不需要任何外部套件**（全部只用標準庫）。

**每個資料夾都有一份 `README.md`**，說明那一課要學會什麼、核心觀念是什麼、怎麼編譯執行，以及「動手試試看／故意犯錯／自我檢查」三個練習區塊。建議**先讀該課的 README，再開 `.rs` 程式碼對照**。

## 環境

```bash
rustc --version     # 需要 Rust 1.65 以上（本教材在 1.98 驗證過）
```

若尚未安裝，可到 <https://rustup.rs> 安裝。

## 編譯與執行

每一課都是「一個（或少數幾個）`.rs` 檔」，例如：

```bash
rustc --edition 2021 01/hello.rs -o hello
./hello
```

`--edition 2021` 表示使用 2021 版語言標準（**第 18 課的多檔案模組一定要加這個參數**，其他課程也建議一律加上）。

也可以一次編譯並執行所有範例：

```bash
./run_all.sh          # 編譯 + 執行全部
./run_all.sh 05       # 只做第 05 課
```

> 編譯產生的執行檔都放在 `bin/`，`19` 課執行後會在目前目錄產生 `example_output.txt`，這些都已列入 `.gitignore`。

## 課程列表（點連結可看該課的詳細 README）

| 課 | 主題 | 檔案 | 重點 |
|----|------|------|------|
| [01](01/README.md) | 第一個程式 | `01/hello.rs` | `main`、`println!`、巨集與註解、格式化輸出 |
| [02](02/README.md) | 變數 | `02/variables.rs` | `let` / `mut`、型別推斷、`const`、shadowing、作用域 |
| [03](03/README.md) | 基本型別 | `03/types.rs` | 整數、浮點、布林、`char`、溢位、`as` 型別轉換、運算子 |
| [04](04/README.md) | 條件判斷 | `04/control_flow.rs` | `if / else if / else`、if 是表達式 |
| [05](05/README.md) | 迴圈 | `05/loops.rs` | `loop`（可回傳值）、`while`、`for`、`break/continue`、標籤 |
| [06](06/README.md) | 函式 | `06/functions.rs` | 定義、參數型別、回傳值、陳述式 vs 表達式 |
| [07](07/README.md) | 所有權 | `07/ownership.rs` | move、Copy、作用域結束自動 drop |
| [08](08/README.md) | 參照與借用 | `08/references.rs` | `&` / `&mut`、借用規則、為何能避免資料競爭 |
| [09](09/README.md) | 切片 | `09/slices.rs` | `&str` / `&[T]`、UTF-8 索引陷阱、通用函式介面 |
| [10](10/README.md) | 結構體 | `10/structs.rs` | struct、`impl` 方法、關聯函式、`#[derive(Debug)]` |
| [11](11/README.md) | 枚舉與匹配 | `11/enums_match.rs` | `enum`、`match` 窮盡檢查、`Option<T>`、`if let` |
| [12](12/README.md) | 錯誤處理 | `12/error_handling.rs` | `panic`、`Result`、`?` 運算子、`unwrap/expect` |
| [13](13/README.md) | 集合 | `13/collections.rs` | `Vec`、`String`、`HashMap`、迭代與修改 |
| [14](14/README.md) | 迭代器 | `14/iterators.rs` | `map/filter/collect`、延遲求值、自訂 `Iterator` |
| [15](15/README.md) | 閉包 | `15/closures.rs` | 捕獲環境、`Fn/FnMut/FnOnce` 概念、`move`、傳遞閉包 |
| [16](16/README.md) | 泛型與 trait | `16/generics_traits.rs` | 泛型函式/型別、自訂 trait、`impl Trait` vs `dyn Trait` |
| [17](17/README.md) | 生命週期 | `17/lifetimes.rs` | `'a` 標註、省略規則、結構體內的參照、`'static` |
| [18](18/README.md) | 模組與多檔 | `18/main.rs`（＋`shapes.rs`、`utils.rs`） | `mod` / `use` / `pub`、可見性、巢狀模組 |
| [19](19/README.md) | 檔案與輸入輸出 | `19/file_io.rs` | 命令列參數、讀寫檔案、逐行讀取、`stdin` |
| [20](20/README.md) | 小專案 | `20/textstats.rs` | 文字統計工具：綜合 struct、HashMap、迭代器、錯誤處理 |

## 每一課的 README 長什麼樣

固定分成這幾個區塊，照順序讀即可：

| 區塊 | 用途 |
|------|------|
| 這課你將學會 | 3～5 個具體目標，讀完應該都能回答 |
| 核心觀念 | 這一課背後的設計理由與規則（不只是語法） |
| 編譯與執行 | 可以直接複製貼上的指令 |
| 逐步解讀 | 對照程式碼逐段講解，說明每段為什麼這樣寫 |
| 動手試試看 | 改程式的小任務，用來驗證自己真的懂 |
| 故意犯錯 | 列出常見錯誤寫法與對應的編譯訊息 |
| 檢查點 | 自我評量題，會答就是學會了 |

## 學習建議

1. **照順序看**：後面的課會用到前面的觀念（尤其 07 所有權 → 08 借用 → 09 切片是 Rust 的核心三部曲）。
2. **先讀 README、再開程式碼**，最後自己打一遍（不要複製貼上）。
3. **程式碼裡的註解就是講義**：每一支程式都從頭到尾寫滿註解，建議先自己讀、猜輸出，再編譯驗證。
4. **故意把註解拿掉試錯**：很多行註解寫著「← 取消註解會編譯錯誤」，把它們打開看看編譯器怎麼說，再試著照著錯誤訊息修。**讀懂 Rust 的錯誤訊息是最重要的技能。**
5. **自己改程式**：例如把 05 的九九乘法表改倒著印、把 20 加上「找最長的單字」等功能。

## 常用指令速查

```bash
rustc --edition 2021 XX/xxx.rs -o bin/xxx   # 編譯
./bin/xxx                                    # 執行
RUST_BACKTRACE=1 ./bin/xxx                   # panic 時印堆疊
rustc --edition 2021 --emit=mir XX/xxx.rs    # 看編譯器內部表示（進階）
rustfmt XX/xxx.rs                            # 格式化程式碼
```
