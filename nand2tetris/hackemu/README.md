# hackemu：Hack CPU 模擬器

在記憶體映射的 Hack 平台上執行機器碼 `.hack`，是工具鏈的最後一站。
讀得懂的語法見 [EBNF.md](EBNF.md)。

```
Draw.asm ──[ hackasm ]──▶ Draw.hack ──[ hackemu ]──▶ 螢幕（文字）
```

## 用法

```sh
rustc --edition 2021 main.rs -o out/hackemu
./out/hackemu Draw.hack

KEYS=65 ./out/hackemu Key.hack     # 模擬按下 scan code 65
TRACE=1 ./out/hackemu Draw.hack    # 逐指令印到 stderr
```

## 實作了什麼

* **CPU**：`A`、`D`、`PC` 三個暫存器；標準 ALU（`zx nx zy ny f no`）。
* **ROM**：載入 `.hack`，`PC` 逐道取指。
* **RAM**：32768 個 word，含記憶體映射 I/O。
* **螢幕**：`RAM[16384..24576]`，執行完裁到「有畫東西的邊界框」，
  用 `#`（黑）與 `.`（白）印到 stdout；整片空白就不印。
  像素映射採官方定義：bit 0 = 最左像素。
* **鍵盤**：`RAM[24576]`，由 `KEYS` 環境變數餵入。

## 停止

Hack 沒有 halt。`hackemu` 在 `(pc, A, D)` 重複且記憶體沒變時判定為
無限迴圈並停下（慣用結尾 `(END) @END 0;JMP` 就是這種）；`PC` 跑出 ROM
範圍則視為錯誤。詳見 [EBNF.md](EBNF.md) 的「停止條件」。

## 測試

```sh
./run.sh
```

`run.sh` 用 `../hackasm` 組譯後端對端跑：

| 程式 | 內容 | 預期 |
| --- | --- | --- |
| `Draw.asm` | 左上角塗黑 3 列 x 3 word | 3 列 x 48 個 `#` |
| `Key.asm` + `KEYS=65` | 有按鍵就塗黑第一列前 16 格 | 1 列 x 16 個 `#` |
| `Key.asm`（無按鍵） | 什麼都不畫 | 空輸出 |

## 檔案

```
hackemu/
├── main.rs
├── Draw.asm       畫黑塊
├── Key.asm        讀鍵盤
├── expected/      draw.txt、key.txt、nokey.txt（golden）
├── EBNF.md
├── README.md
└── run.sh
```
