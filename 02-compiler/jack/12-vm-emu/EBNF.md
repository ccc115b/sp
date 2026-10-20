# 12-vm-emu 支援的語法（EBNF）

前面 11 版描述的是 **Jack** 的語法；這一版不是編譯器，而是**堆疊機模擬器**，
所以要描述的是它讀得懂的 **VM 指令語言**（`.vm` 檔），
也就是 01–11 編譯出來的東西。對應 `main.rs` 的 `load()`。

## 語法

```ebnf
program     = { instruction } ;

instruction = function | call | label | goto | ifGoto
            | push | pop | arithmetic | return ;

function    = 'function' symbol integer ;
call        = 'call' symbol integer ;
label       = 'label' symbol ;
goto        = 'goto' symbol ;
ifGoto      = 'if-goto' symbol ;
push        = 'push' segment integer ;
pop         = 'pop' segment integer ;
return      = 'return' ;

arithmetic  = 'add' | 'sub' | 'neg' | 'eq' | 'gt' | 'lt'
            | 'and' | 'or' | 'not' | 'mul' | 'div' ;

segment     = 'argument' | 'local' | 'this' | 'that'
            | 'pointer' | 'temp' | 'static' | 'constant' ;
```

## 詞法（token）

```ebnf
symbol      = ( letter | '_' | '.' | digit ) { letter | '_' | '.' | digit } ;
integer     = digit { digit } ;
letter      = ? 字母 ? ;
digit       = '0' | '1' | … | '9' ;

comment     = '//' { ? 到行尾 ? } ;
```

* 一行 = 去掉 `//` 之後的部分，再以空白切開；**空行會被略過**。
* `symbol` 就是函式名或標籤名（例如 `Main.main`、`WHILE_EXP0`）；
  載入時不嚴格檢查字元，但 `label` 會自動加上「目前函式名 + `$`」的前綴。
* `integer` 必須是**非負整數**。

## 九種算術／邏輯運算

| 指令 | 動作（堆疊 `… x y` → `… v`） |
| --- | --- |
| `add` `sub` | `x + y`、`x - y` |
| `mul` `div` | `x * y`、`x / y`（**方言指令**，見下） |
| `and` `or` | 位元 `x & y`、`x | y` |
| `eq` `gt` `lt` | 相等 / 大於 / 小於，成立為 `-1`（true），否則 `0` |
| `neg` `not` | 一元：`-x`、位元取反 `~x` |

**本系列的方言 = 標準 nand2tetris VM + `mul` / `div`。**
標準 VM 沒有乘除，編譯器原本要把它們編成 `call Math.multiply 2` /
`call Math.divide 2`；這裡直接讓 VM 多支援兩道指令，省掉一個 `Math` 類別。
除此之外全部是標準 VM。

## 記憶體區段

| 區段 | 位址 | 說明 |
| --- | --- | --- |
| `argument` | `ram[ARG]` 起 | 參數 |
| `local` | `ram[LCL]` 起 | 區域變數 |
| `this` | `ram[THIS]` 起 | 目前物件欄位 |
| `that` | `ram[THAT]` 起 | 通常當陣列指標 |
| `pointer` | — | 只能是 `0`（`THIS`）或 `1`（`THAT`） |
| `temp` | 5 起 | 暫存，`temp 0`–`temp 7` |
| `static` | 16 起 | 全類別共用 |
| `constant` | — | 沒有位址，`push constant n` 直接就是值 `n` |

`constant` 只能 `push` 不能 `pop`；`pop constant` 會在執行時報錯。

## 執行語意（語法以外的規則）

* **入口**：有 `Sys.init` 就從它開始，否則從檔案裡**第一個 `function`**。
  模擬「有人在位址 0 呼叫入口」，所以 `return` 回到位址 `0` 就代表程式結束。
* **標籤是函式區域的**：`label L` / `goto L` / `if-goto L` 實際比對的是
  `<函式名>$L`；`goto` 到不存在的標籤、`if-goto` 到不存在的標籤都會報錯。
* **`function f n`** 進來時把 `n` 個區域變數清成 0；
  **`call f m`** 會蓋一個 frame（存回傳位址與舊的 `LCL/ARG/THIS/THAT`），
  再把 `ARG` 指到參數、`LCL` 指到 frame 底。
* **呼叫慣例：每個函式都要在堆疊上留一個回傳值**（void 就留 `0`），
  否則呼叫端的 `pop temp 0` 會一輪一輪把堆疊漏掉。

## 內建（native）函式

`call` 的目標若是下列名字，就跳過 VM 碼、直接用 Rust 算：

| 函式 | 動作 |
| --- | --- |
| `Memory.alloc` / `Array.new` | 從堆積配置記憶體，回傳起始位址 |
| `String.new` / `String.appendChar` | 第一格存長度，之後存字元 |
| `Output.printInt` / `printChar` / `printString` / `println` | 印到 stdout |
| `Math.multiply` / `Math.divide` | 乘、除 |
| `Sys.halt` / `Sys.wait` | 停機 / 忽略 |

## 範例

```vm
function Main.main 3
push constant 5
pop local 2
push local 1
push local 1
mul
return
```
