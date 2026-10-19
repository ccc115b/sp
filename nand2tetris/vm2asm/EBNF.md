# vm2asm 讀得懂的語法（EBNF）

`vm2asm/` 讀的是 **VM 指令**（`.vm`，`jack/` 編譯器的產物，
單檔或整個資料夾），吐出 **Hack 組合語言**（`.asm`，餵給 `hackasm`）。
語法與 [`vm-emu`](../vm-emu/EBNF.md) 相同：**標準 nand2tetris VM + `mul` / `div`**。

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

* 每行去掉 `//` 之後以空白切開；空行略過。
* `integer` 為非負整數；`pop constant` 不合法。

## 各指令的翻譯

| VM | Hack 組合語言 |
| --- | --- |
| `push constant n` | `@n; D=A` 後壓堆疊 |
| `push local i` | `@i; D=A; @LCL; A=D+M; D=M` 後壓堆疊 |
| `pop local i` | 算 `LCL+i` 存到 `R13`，彈出堆疊值再寫回 |
| `add` `sub` `and` `or` | 彈兩值合併寫回 |
| `neg` `not` | 堆疊頂端取負 / 取反 |
| `eq` `gt` `lt` | 兩值相減後條件跳躍，成立寫 `-1` 否則 `0` |
| `mul` `div` | `call __vm_mul 2` / `call __vm_div 2`（見下） |
| `label L` | `(目前函式$L)` |
| `goto L` | `@目前函式$L; 0;JMP` |
| `if-goto L` | 彈出堆疊值，非 0 才 `@目前函式$L; D;JNE` |
| `function f k` | `(f)` 後把 k 個區域清為 0 |
| `call f n` | 標準呼叫約定（存返回位址、存 4 個區段指標、重設 `ARG`/`LCL`、跳躍） |
| `return` | 標準返回約定（用 `R13` 當 frame、`R14` 存返回位址） |

## 記憶體區段對應

| VM 區段 | 對應 |
| --- | --- |
| `local` `argument` `this` `that` | `LCL` `ARG` `THIS` `THAT` 指向的區塊 |
| `pointer 0` / `pointer 1` | `THIS`(3) / `THAT`(4) |
| `temp i` | `RAM[5 + i]` |
| `static i` | `檔名.i`（`hackasm` 會配一個 RAM 位址） |
| `constant n` | 立即值 |

## 標籤作用域

VM 的 `label` / `goto` / `if-goto` 是**函式區域性**的，所以轉譯時會加上
「目前函式名 + `$`」的前綴，不同函式能用同名標籤。

## bootstrap 與 mul / div

* 輸出開頭固定是 bootstrap：`SP = 256`、`call Sys.init 0`、然後無窮迴圈。
  因此被轉譯的程式**必須定義 `Sys.init`**。
* 標準 VM 沒有 `mul` / `div`。本轉譯器在輸出尾端附上以 **VM 寫成**的
  `__vm_abs` / `__vm_mul` / `__vm_div`，再一起轉成組合語言；
  `mul` / `div` 就翻成對它們的 `call`。
  `__vm_mul` 是 16 步移位相加，`__vm_div` 是課本的遞迴長除法。
