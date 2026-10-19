# hackemu 讀得懂的語法（EBNF）

`hackemu/` 讀的是 **Hack 機器碼**（`.hack`）——`hackasm` 的產物，
每行一道 16 位元指令。下面這份文法是 `main.rs` 的 `load()` 實際接受的範圍。

## 語法

```ebnf
program     = { word } ;

word        = bit bit bit bit bit bit bit bit
              bit bit bit bit bit bit bit bit ;
bit         = '0' | '1' ;

comment     = '//' { ? 到行尾 ? } ;
empty       = ? 空白或空行 ? ;
```

* 一行必須剛好 16 個 `0`/`1`；**空行略過**。
* 不做符號解析——`.hack` 裡沒有符號，`hackasm` 已經把標籤與變數解掉了。

## 指令解碼

* **A 指令**（bit15 = `0`）：`0` + 15 位元常數 → 載入 `A`。
* **C 指令**（bit15 = `1`）：`111` + `a` + `c1c2c3c4c5c6` + `d1d2d3` + `j1j2j3`

```
  1 1 1 a c c c c c c d d d j j j
```

* `a`：ALU 的第二路輸入是 `A`（0）還是 `M`（1，即 `RAM[A]`）。
* `d1=A d2=D d3=M`：哪些暫存器／記憶體寫入 ALU 的輸出。
* `c1c2c3c4c5c6`：ALU 的六個控制位 `zx nx zy ny f no`（見下）。
* `j1=正 j2=零 j3=負`：依 ALU 輸出決定是否跳到 `A`。

## ALU

```
x = (zx ? 0 : D)   nx ? x = ~x
y = (zy ? 0 : M)   ny ? y = ~y      （M 依 a 位元取 A 或 RAM[A]）
out = f ? x + y : x & y             no ? out = ~out
```

## 記憶體映射

| 位址 | 用途 |
| --- | --- |
| 0–16383 | 一般 RAM（`SP`、`LCL`…、變數、heap） |
| 16384–24575 | **螢幕**，8K word |
| 24576 | **鍵盤**（唯讀） |
| 24577–32767 | 未使用 |

**螢幕**：512 x 256，每一列 32 個 word。像素 (row `r`, col `c`) 是
`Screen[r*32 + c/16]` 這個 word 的 **第 `c%16` 個位元（由 LSB 數起）**，
所以 **bit 0 = 最左邊的像素**，1 = 黑、0 = 白。

**鍵盤**：`RAM[24576]` 讀到的是目前按下的鍵（scan code），沒按時為 0。
`hackemu` 用環境變數 `KEYS` 模擬：第一次讀 `24576` 時送出，之後歸 0。

## 停止條件

Hack 沒有 halt 指令。本模擬器在兩種情況停下來並把螢幕印出：

1. **狀態重複**：固定記憶體時，若 `(pc, A, D)` 再度出現，代表程式進入
   不會停的迴圈（例如慣用的 `(END) @END 0;JMP`）。任何一次寫入記憶體都會
   清掉「看過的狀態」，所以有在改記憶體的迴圈不會被誤判。
2. **PC 超出 ROM**：視為錯誤，回傳非 0。
