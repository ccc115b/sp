# os：Jack 標準函式庫

nand2tetris 第 12 章的作業系統，用 Jack 寫成，由本專案的整條工具鏈
編譯、轉譯、組譯，最後在 [`hackemu`](../hackemu/) 上真正執行。

原始碼取自 nand2tetris 官方參考解答，複製進本專案時已轉成 UTF-8（原
`Output.jack` 內含一個 CP1252 的 `’` 位元組）。

## 對參考解答的修正

`Sys.init()` 的初始化順序**有改**。參考解答原本是：

```
Math.init → Output.init → Screen.init → Keyboard.init → Memory.init → Main.main
```

但 `Math.init()` 與 `Output.init()` 都會用 `Array.new()`（即
`Memory.alloc()`）配置記憶體，`Memory.init()` 卻排在最後。堆積尚未初始化
時，`Memory.alloc()` 會回傳錯誤位址（`1`），整個 OS 立刻崩潰。因此改成：

```
Memory.init → Math.init → Screen.init → Output.init → Keyboard.init → Main.main
```

這與多數可用的解答一致（參考解答附帶的 `Sys.jack.md` 對這個順序的描述本身
就自相矛盾）。其餘 7 個類別未改寫。編譯器另已放寬「參數可重新賦值」（標準
Jack 允許，參考解答會用到，例如 `Math.abs`）。

## `Main.jack`

`Sys.init` 最後會呼叫 `Main.main`。本目錄附一個示範 `Main.main`：把螢幕最
上面 16 列填滿。

## 模組

| 類別 | 職責 | 關鍵函式 |
| --- | --- | --- |
| `Array` | 動態陣列 | `new`、`dispose` |
| `Keyboard` | 鍵盤 | `keyPressed`、`readChar`、`readLine`、`readInt` |
| `Math` | 數學 | `multiply`、`divide`、`mod`、`sqrt`、`abs`、`min`、`max` |
| `Memory` | 堆積配置器（best-fit，含合併） | `peek`、`poke`、`alloc`、`deAlloc` |
| `Output` | 螢幕文字輸出 | `printChar`、`printString`、`printInt`、`moveCursor` |
| `Screen` | 螢幕繪圖 | `drawPixel`、`drawLine`、`drawRectangle`、`drawCircle` |
| `String` | 字串 | `new`、`charAt`、`appendChar`、`setInt`、`intValue` |
| `Sys` | 系統 | `init`、`halt`、`wait`、`error` |

每個類別都有 `function void init()`，由 `Sys.init` 依序啟動。

## 與本專案方言的關係

本專案的編譯器把 `*`、`/` 直接編成 VM 的 `mul`、`div` 指令（見
[`jack/EBNF.md`](../jack/EBNF.md)），而**不是**標準的
`call Math.multiply 2` / `call Math.divide 2`。因此：

* `Math.multiply` / `Math.divide` 仍會被編出來，但上層的 `*`、`/` 不會呼叫
  它們，而是走 `mul` / `div`。
* `vm2asm` 會把 `mul` / `div` 翻成對 `__vm_mul` / `__vm_div` 的呼叫。

## 螢幕位元方向（重要）

`hackemu` 依官方規格：每個字組的 **bit 0 是最左邊的像素**。但參考解答的
`Screen.drawPixel` 用 `15 - (x & 15)` 定址，位元方向與規格相反，因此**逐像素
的圖形會以 16 像素為一組左右鏡射**。實心的 `drawRectangle` 不受影響，所以
示範用矩形。若要完全符合規格，需把 `Screen.jack` 的位元方向改回 `x & 15`。

## 建置與測試

```sh
./run.sh
```

`run.sh` 跑整條工具鏈：`../jack` 編譯 8 個類別 + `Main` → `../vm2asm` 把整個
目錄轉成組合語言（含 `mul` / `div` 輔助函式與 bootstrap）→ `../hackasm` 組譯
→ `../hackemu` 執行，最後與 `expected/screen.txt` 比對。

整個 OS + Main 約 31190 道指令（Hack ROM 上限 32768），在 `hackemu` 上約
477 萬步後停在 `Sys.halt` 的無窮迴圈。

## 檔案

```
os/
├── Array.jack   Keyboard.jack   Math.jack     Memory.jack
├── Output.jack  Screen.jack     String.jack   Sys.jack
├── Main.jack
├── expected/screen.txt
├── README.md
└── run.sh
```
