# 02-let-expr：變數、賦值與算式

> 本版支援的語法以 EBNF 記於 [`EBNF.md`](EBNF.md)。

在 01 的骨架上加入**符號表**，讓函式可以有參數與區域變數，並且用 `let` 賦值、
用算式計算。

## 新增功能

| 項目 | 說明 |
| --- | --- |
| `var int a, b;` | 區域變數宣告，決定 `function` 的 nLocals |
| `let x = 表式;` | 產生 `pop local n` |
| 參數表 `(int w, int h)` | 佔 `argument 0, 1, ...` |
| 算式 `+ - * /` | `add sub mul div` |
| 一元 `-` | `neg` |
| `( ... )` | 括號改寫運算順序 |

**Jack 算式沒有優先權**：`a + b * 2` 就是 `(a + b) * 2`，由左至右計算。
要先乘後加只能自己加括號，見 `Calc.jack` 的 `(a + w) / -h`。

尚不支援：`& | < > =`、`~`、`if/while`（→ 03）、方法與欄位（→ 04）。

## 檔案

| 檔 | 用途 |
| --- | --- |
| `main.rs` | 編譯器（+ `Symbols` 符號表） |
| `Calc.jack` | 測試輸入 |
| `expected/Calc.vm` | 期望輸出 |
| `run.sh` | 編譯 + 執行 + 比對 |

## 符號表

```rust
enum Seg { Arg, Local }          // 對應 VM 的 argument / local 段
struct Symbols {
    map: HashMap<String, (Seg, usize)>,   // 名字 → (段, 編號)
    n_args: usize,                        // 參數計數
    n_locals: usize,                      // 區域變數計數 = nLocals
}
```

每個函式開始時 `Symbols::new()`，先收參數、再收 `var`，最後把 `n_locals`
印在 `function C.f nLocals` 那一行。查不到名字就回報 `變數 x 未宣告`。

## 執行

```sh
./run.sh
```

## 輸入 / 輸出

輸入 `Calc.jack`：

```jack
class Calc {
    function int calc(int w, int h) {
        var int a;
        var int b;
        let a = w * h;
        let b = (a + w) / -h;
        return b - a;
    }
}
```

輸出 `expected/Calc.vm`：

```
function Calc.calc 2
push argument 0
push argument 1
mul
pop local 0
push local 0
push argument 0
add
push argument 1
neg
div
pop local 1
push local 1
push local 0
sub
return
```

## 解析方式

- `parse_expr()`：先 `parse_term()`，若看到 `+ - * /` 就再取下一個 term 並
  立刻印出對應指令 → 天然的**由左至右**語意。
- `parse_term()`：整數、`- term`、`( expr )`、識別字四種。
- `parse_let()`：查符號表得到 `(segment, index)`，算完式子印 `pop local n`。
