# hackasm：Hack 組譯器

把 Hack 組合語言 `.asm` 翻成機器碼 `.hack`（每行 16 個 `0`/`1`），
是工具鏈裡「VM 轉譯器 → 硬體」之間的一站。語法見 [EBNF.md](EBNF.md)。

```
Add.asm ──[ hackasm ]──▶ Add.hack
```

## 用法

```sh
rustc --edition 2021 main.rs -o out/hackasm
./out/hackasm Add.asm out/Add.hack      # 省略輸出路徑則輸出 Add.hack
```

## 兩趟掃描

1. **收集標籤**：掃過 `(LABEL)`，記下它在 ROM 的第幾個指令。
2. **產生機器碼**：`@value` 與 `dest=comp;jump` 逐一編碼；`@` 後查不到的
   符號就當變數，從 RAM 16 起配位址。

因為標籤先收集，向前跳躍（先 `@END` 後 `(END)`）才能正確解析。

## 符號

| 種類 | 說明 |
| --- | --- |
| 預定義 | `R0`–`R15`、`SP`、`LCL`、`ARG`、`THIS`、`THAT`、`SCREEN`=16384、`KBD`=24576 |
| 標籤 | `(X)`，佔 ROM 位址但不佔指令空間 |
| 變數 | 未定義的 `@X`，依出現順序配到 RAM 16、17、… |

指令內的空白會被忽略（`D = M + 1` = `D=M+1`）；`//` 到行尾是註解。

## 測試

```sh
./run.sh
```

* `Add.asm`：`@2; D=A; @3; D=D+A; @0; M=D`。
* `Symbols.asm`：變數 `i`、標籤 `LOOP`/`END`、預定義 `SCREEN`/`KBD`，
  附手算過的 golden `.hack`。
* `bad.asm`：含不存在的 `comp`，應該編譯失敗並回傳非 0。

## 檔案

```
hackasm/
├── main.rs
├── Add.asm        簡單四則運算
├── Symbols.asm    變數 / 標籤 / 預定義符號
├── bad.asm        錯誤示範
├── expected/      Add.hack、Symbols.hack、bad.err（golden）
├── EBNF.md
├── README.md
└── run.sh
```
