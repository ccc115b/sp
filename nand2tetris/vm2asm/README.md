# vm2asm：VM → Hack 組合語言轉譯器

把 VM 指令 `.vm`（`jack/` 編譯器的產物）翻成 Hack 組合語言 `.asm`
（`hackasm` 的輸入），是工具鏈的中後段。語法見 [EBNF.md](EBNF.md)。

```
Main.vm ──[ vm2asm ]──▶ Main.asm ──[ hackasm ]──▶ Main.hack ──[ hackemu ]──▶ 螢幕
```

## 用法

```sh
rustc --edition 2021 main.rs -o out/vm2asm
./out/vm2asm Draw.vm out/Draw.asm      # 單檔
./out/vm2asm src/ out/Program.asm      # 整個資料夾（合併所有 .vm）
```

資料夾模式時，每個檔案的 `static` 變數以「檔名.i」區分；輸出路徑可省略，
預設是 `<輸入>.asm`。

## 做了什麼

* **bootstrap**：輸出開頭設 `SP = 256`、`call Sys.init 0`、再進無窮迴圈。
  所以被轉譯的程式必須定義 `Sys.init`。
* **堆疊機 → 暫存器**：`push` / `pop` 八個區段，`add` `sub` `neg` `eq` `gt`
  `lt` `and` `or` `not`，`label` / `goto` / `if-goto`，`function` / `call`
  / `return`。標籤加上「目前函式$」前綴。
* **`mul` / `div`**：標準 VM 沒有乘除。本專案在輸出尾端附上以 VM 寫成的
  `__vm_abs` / `__vm_mul` / `__vm_div`，與主程式一起轉譯；`mul` / `div`
  翻成 `call __vm_mul 2` / `call __vm_div 2`。`__vm_mul` 是 16 步移位相加，
  `__vm_div` 是課本的遞迴長除法（含負數與除以零的處理）。

## 測試

```sh
./run.sh
```

`Draw.vm` 端對端跑完整條鏈：用 `div` 算出 3 列 x 3 word（刻意用負數
`(-9)/(-3)`、`(-96)/(-32)` 測負數除法），再用 `mul` 算 `row*32` 的位址，
把黑塊畫到左上角。轉譯器 → `../hackasm` → `../hackemu`，最後比對螢幕輸出
（3 列 x 48 個 `#`）。這條路徑同時走過 `eq` `gt` `lt` `and` `or` `sub`
`neg` `not` 與 `call`/`return`。

## 檔案

```
vm2asm/
├── main.rs
├── Draw.vm        測試程式（含 Sys.init）
├── expected/      draw.txt（golden 螢幕）
├── EBNF.md
├── README.md
└── run.sh
```
