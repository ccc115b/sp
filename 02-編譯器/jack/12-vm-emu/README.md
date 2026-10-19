# 12-vm-emu：堆疊機模擬器

> 本版讀得懂的 VM 指令語法以 EBNF 記於 [`EBNF.md`](EBNF.md)。

11 終於編出 `.vm` 了，但那只是一張紙。這一版寫一台 **VM 模擬器**把它跑起來，
於是整條路打通的：`Main.jack` → VM 碼 → 真的印出東西。

```sh
rustc --edition 2021 ../11-modular/main.rs -o out/jackc   # 編譯器
rustc --edition 2021 main.rs -o out/jackvm                # 模擬器
./out/jackc Main.jack out/Main.vm
./out/jackvm out/Main.vm
```

## VM 是什麼

一台**堆疊機**：所有運算都在堆疊頂端進行。

```
push constant 5      堆疊  [5]
push constant 3      堆疊  [5, 3]
sub                  堆疊  [2]      ← 吃掉兩個，吐回一個
```

只有九種算術／邏輯指令（`add sub neg eq gt lt and or not`），
條件判斷也只有「堆疊頂端非 0 就跳」這一種（`if-goto`）。
高階語言的一切——`if`、`while`、函式、物件——都得靠這幾顆積木疊出來。

## 我們的方言：多了 mul / div

標準 nand2tetris VM 沒有乘除，編譯器要把它們編成
`call Math.multiply 2`、`call Math.divide 2`。本系列為了少寫一個 `Math`
類別，直接讓 VM 多支援 `mul` 和 `div` 兩道指令：

```
$ head -3 out/Main.vm
function Main.main 3
push constant 5
pop local 2
...
push local 1
push local 1
mul               ← 標準 VM 沒有這道
```

只有這一處不同，其餘全是標準 VM。

## 記憶體佈局

RAM 只有 32768 格，每格 16 位元有號整數。模擬器沿用 nand2tetris 的規劃：

| 位址 | 用途 |
| --- | --- |
| 0–4 | `SP` `LCL` `ARG` `THIS` `THAT` 五個暫存器 |
| 5–12 | `temp 0`–`temp 7` |
| 16–255 | `static`（單檔從 16 起算） |
| 256 起 | 堆疊（由低往高長） |
| 2048 起 | 堆積（`Memory.alloc` / `Array.new` / `String.new`） |

`pointer 0`/`pointer 1` 不是獨立記憶體，就是 `THIS`/`THAT` 這兩個暫存器位址：

```rust
"pointer" => {
    if idx > 1 { die(at, "pointer 只有 0（this）與 1（that）"); }
    THIS
}
```

所以 `pop pointer 1` 是「把堆疊頂端的值設成新的 THAT」——
8-array 的 `a[i]` 就是這樣做出來的位址運算。

## 函式呼叫慣例

`call` 不是單純跳躍，還要蓋一個 **frame** 把呼叫者的狀態存起來：

```
        ┌──────────────┐
        │ 回傳值        │ ← ARG 指這裡（呼叫者先把參數放好）
        ├──────────────┤
        │ 回傳位址      │ ← LCL-5
        │ 舊 LCL        │ ← LCL-4
        │ 舊 ARG        │ ← LCL-3
        │ 舊 THIS       │ ← LCL-2
        │ 舊 THAT       │ ← LCL-1
        ├──────────────┤
        │ 區域變數 0    │ ← LCL 指這裡
        │ 區域變數 1    │
        └──────────────┘
```

模擬器完整照做：

```rust
let frame = self.ram[SP] as usize;
self.push(ret as i16);            // 回傳位址
self.push(lcl); self.push(arg); self.push(this); self.push(that);
self.ram[ARG] = (frame - args) as i16;   // 參數就在 ARG 之後
self.ram[LCL] = self.ram[SP];            // LCL 指到 frame 底
goto target;                             // 接著執行 function f n，把 n 個區域變數清 0
```

`return` 則是把上面全部反過來。回傳位址 **0 是哨兵值**：程式入口是
「假裝有人在位址 0 呼叫」它，所以 `return` 回到 0 就代表程式結束。

標籤是**函式區域**的，所以載入時會自動接上函式名：

```
label WHILE_EXP0  →  Main.main$WHILE_EXP0
```

11 把每個函式的 label 編號從 0 重新算起，正是因為這個約定。

## 內建 OS 函式

`call` 的目標如果是下列名字，就跳過 VM 碼，直接用 Rust 算：

| 函式 | 動作 |
| --- | --- |
| `Memory.alloc` / `Array.new` | 配置一段記憶體，回傳起始位址 |
| `String.new` / `String.appendChar` | 第一格存長度，後面存字元 |
| `Output.printInt` / `printChar` / `printString` / `println` | 印到 stdout |
| `Math.multiply` / `Math.divide` | 乘除 |
| `Sys.halt` / `Sys.wait` | 停機 / 忽略 |

## 兩個踩過的坑

**一、內建函式也要留回傳值。** VM 的呼叫慣例是「每個函式都在堆疊上留一個值」
（void 就留 0）。一開始 `Output.printInt` 只把參數吃掉，沒補回傳值，結果：

```
do Output.printInt(i);   →   call Output.printInt 1 / pop temp 0
                                                  ^ 堆疊已經少一格了
```

每印一次數字，堆疊就往下漏一格，跑到後面 `return` 讀到的回傳位址變成垃圾，
程式提早結束。修法就是每個 native 都補上 `self.push(0)`：

```rust
"Output.printInt" => {
    let v = self.pop();
    print!("{}", v);
    self.push(0);        // ← void 也要留一個值
}
```

**二、Jack 沒有運算子優先權。** 範例程式原先寫 `while (r < h + 1)`，
編譯出來卻是：

```
push local 0     (r)
push argument 0  (h)
lt
push constant 1
add
```

因為 Jack 的規格是**由左而右、沒有優先權**，`r < h + 1` 等於 `(r < h) + 1`，
於是 `true(-1) + 1 = 0`，迴圈一次都不跑。改成 `while (r < (h + 1))` 才對。
這是 Jack 最常咬人的地方——**括號永遠不嫌多**。

## 執行

```sh
./run.sh
```

`run.sh` 會：用 11 的編譯器把 `Main.jack` 編成 VM 碼 → `diff` 比對
`expected/Main.vm` → 用模擬器跑出結果 → `diff` 比對 `expected/out.txt`
→ 再拿 `bad.vm`（故意 `pop constant`）確認會報錯、回傳非 0。

## 除錯

設 `TRACE=1` 會把每一步的 pc、原始碼行號、指令與五個暫存器印到 stderr：

```sh
TRACE=1 ./out/jackvm out/Main.vm
```

```
pc=0    行=1    Function(3)                  sp=261 lcl=261 arg=256 this=0 that=0
pc=1    行=2    Push("constant", 5)          sp=264 lcl=261 arg=256 this=0 that=0
pc=2    行=3    Pop("local", 2)              sp=265 lcl=261 arg=256 this=0 that=0
```

## 輸入

`Main.jack`：建立一個 5 格陣列、填入平方值、印出來，再呼叫
`Main.triangle(4)` 畫三角形。

`bad.vm`：故意寫錯的 VM 檔。

## 輸出

`expected/Main.vm`：① 編譯器產生的 VM 碼。

`expected/out.txt`：模擬器實際跑出來的程式輸出。

```
0 1 4 9 16
*
**
***
****
```

`expected/bad.err`：

```
bad.vm:4: 不能 pop 到 constant
```
