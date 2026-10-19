# hackasm 讀得懂的語法（EBNF）

`hackasm/` 讀的是 **Hack 組合語言**（`.asm`），吐出 `.hack`。
下面這份文法是 `main.rs` 實際接受的範圍。

## 語法

```ebnf
program     = { line } ;

line        = instruction | labelDecl | empty ;

instruction = aInstruction | cInstruction ;

aInstruction = '@' value ;
value        = integer | symbol ;

cInstruction = [ dest '=' ] comp [ ';' jump ] ;

dest        = { 'A' | 'M' | 'D' } ;        (* 至少一個，順序不拘 *)
jump        = 'JGT' | 'JEQ' | 'JGE' | 'JLT'
            | 'JNE' | 'JLE' | 'JMP' ;

labelDecl   = '(' symbol ')' ;
```

## 詞法（token）

```ebnf
symbol      = ( letter | '_' | '.' | '$' | ':' )
              { letter | digit | '_' | '.' | '$' | ':' } ;
integer     = digit { digit } ;
letter      = ? 字母 ? ;
digit       = '0' | '1' | … | '9' ;

comment     = '//' { ? 到行尾 ? } ;
empty       = ? 空白、空行或只有註解 ? ;
```

* 一行 = 去掉 `//` 之後的部分；**空行會被略過**。
* 指令內的**空白一律忽略**，所以 `D = M + 1` 和 `D=M+1` 等價。
* `integer` 必須是 `0` 到 `32767`（16 位元裡 bit15 = 0）。

## comp 欄位

`comp` 決定 ALU 的兩路輸入怎麼算；`a` 位元選「第二路是 `A`（0）還是 `M`（1）」。

| a=0（第二路 = A） | a=1（第二路 = M） |
| --- | --- |
| `0` `1` `-1` | |
| `D` `A` `!D` `!A` `-D` `-A` | `M` `!M` `-M` |
| `D+1` `A+1` `D-1` `A-1` | `M+1` `M-1` |
| `D+A` `D-A` `A-D` `D&A` `D\|A` | `D+M` `D-M` `M-D` `D&M` `D\|M` |

## 編碼方式

* **A 指令**：`0` 後面接 15 位元的位址。
* **C 指令**：`111` + `a` + `c1c2c3c4c5c6` + `d1d2d3` + `j1j2j3`，
  其中 `d1=A d2=D d3=M`，`j1..j3` 依 `JGT JEQ JGE JLT JNE JLE JMP` 對應
  `001 010 011 100 101 110 111`。

## 符號

* **預定義符號**：`R0`…`R15`（= 0…15）、`SP`=0、`LCL`=1、`ARG`=2、
  `THIS`=3、`THAT`=4、`SCREEN`=16384、`KBD`=24576。
* **標籤** `(symbol)`：佔 ROM 一個位址，但**本身不是指令**（不佔空間）。
* **變數**：`@` 後面出現、又不在上表也不是標籤的符號，從 **RAM 16** 開始依序配位址。
* 同一程式裡所有符號（含標籤）**不可重複定義**。

## 兩趟掃描

1. **第一趟**：只看 `(label)`，記下每個標籤對應的 ROM 位置。
2. **第二趟**：產生機器碼；`@value` 若查不到就當變數配一個 RAM 位址。
   標籤必須先在第一趟收集完，才能支援**向前跳躍**（先用到、後定義）。
