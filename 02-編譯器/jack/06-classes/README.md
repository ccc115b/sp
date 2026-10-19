# 06-classes：constructor 與物件建立

> 本版支援的語法以 EBNF 記於 [`EBNF.md`](EBNF.md)。

加上 `constructor`，物件才能被**建立**。到這裡 Jack 的四種 subroutine
（`function` / `method` / `constructor`）與全部指述都齊了。

## 新增功能

| Jack | VM |
| --- | --- |
| `constructor Point new(px, py)` | `function Point.new 0` + 配置物件的前言 |
| `return this;` | `push pointer 0` + `return` |
| `Point.new(3, 4)` | `call Point.new 2` |
| `p.shift(1, 2)` | `push <p>` + `call Point.shift 3` |

## constructor 的前言

```
function Point.new 0        ; nLocals = 0（不是 nFields）
push constant 2             ; 欄位個數
call Memory.alloc 1         ; 向 OS 要 2 個 word
pop pointer 0               ; 設定 this
  ...函式內容...
```

## 三種 subroutine 的差異

| | argument 0 是 | 參數從 | 前言 |
| --- | --- | --- | --- |
| `function` | 第一個參數 | 0 | 無 |
| `method` | **this**（由呼叫者推入） | 1 | `push argument 0` / `pop pointer 0` |
| `constructor` | 第一個參數 | 0 | `push constant nFields` / `call Memory.alloc 1` / `pop pointer 0` |

`Sub` 列舉把這三種差異集中在 `parse_function()` 的一個 `match` 裡。

## 執行

```sh
./run.sh
```

## 輸入 / 輸出

輸入 `Point.jack`：二維座標點，含建構、取值、平移與測試函式。

輸出 `expected/Point.vm`（節錄）：

```
function Point.new 0
push constant 2
call Memory.alloc 1
pop pointer 0
push argument 0
pop this 0
push argument 1
pop this 1
push pointer 0
return
...
function Point.test 1
push constant 3
push constant 4
call Point.new 2
pop local 0
push local 0
push constant 1
push constant 2
call Point.shift 3
pop temp 0
push local 0
call Point.getX 1
push local 0
call Point.getY 1
add
return
```

## 呼叫路徑回顧

`Point.new(3, 4)`：`Point` 不在符號表 → 視為類別名 → 不推物件、
參數個數 2 → `call Point.new 2`。

`p.shift(1, 2)`：`p` 在符號表，型別 `Point` → `push local 0`、
參數個數 2 + 1（this）→ `call Point.shift 3`。

## 尚未支援

- **字串常數**與 `String.new` → `07-strings`
- **陣列** `a[i]` → `08-array`
- 多檔編譯 → `09-multi-file`
