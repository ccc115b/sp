# 05-calls：subroutine 呼叫與 do

> 本版支援的語法以 EBNF 記於 [`EBNF.md`](EBNF.md)。

加入**呼叫**（Jack 唯一的跳轉機制）與 `do` 指述，這是 Jack 的最後一塊語法核心。

## 新增功能

| Jack | VM |
| --- | --- |
| `do f();` | 呼叫 + `pop temp 0`（丟棄回傳值） |
| `let r = f(x);` | 呼叫結果直接留在堆疊上 |
| `f(args)` | 同類別的**裸呼叫** |
| `Cls.f(args)` | 靜態 / function 呼叫 |
| `obj.m(args)` | 物件方法呼叫 |

## 三種呼叫規則

| 寫法 | 先推什麼 | callee | 參數個數 |
| --- | --- | --- | --- |
| `f(a)` | `push pointer 0` | `當前類別.f` | 人參 + 1 |
| `Cls.f(a)`（`Cls` 非變數） | 無 | `Cls.f` | 人參 |
| `obj.m(a)`（`obj` 是變數） | `push <obj>` | `obj 的型別.m` | 人參 + 1 |

判斷方式：先查符號表。查得到 → 它是**變數**；查不到 → 它是**類別名**。
這也是符號表在 05 必須開始記住**型別**的原因（`declare(name, seg, typ)`）。

> Jack 規定：`f()` 恆為 `this.f()`。要在 method 裡呼叫同類別的 **function**，
> 必須寫 `Math.square(n)`，否則會多推一個 `this` 而造成參數錯位。

## do

```
do Math.print(r);
→
push local 0
call Math.print 1
pop temp 0        ; void 回傳值丟到 temp 0
```

## 執行

```sh
./run.sh
```

## 輸入 / 輸出

輸入 `Math.jack`：五個 subroutine，涵蓋 function 呼叫、do、裸呼叫。

輸出 `expected/Math.vm`（節錄）：

```
function Math.run 1
push argument 0
call Math.square 1
push argument 1
call Math.square 1
add
pop local 0
push local 0
call Math.print 1
pop temp 0
push local 0
return
function Math.twice 0
push argument 0
pop pointer 0
push pointer 0
push argument 1
call Math.double 2
return
```

`twice` 是 method，所以 `double(n)` 會先推 `pointer 0`（this）再推 `n`，
參數個數 2；而 `n` 在 method 裡是 `argument 1`（`argument 0` 是 this）。

## 程式結構變化

- `Parser` 新增 `current_class`：裸呼叫要拿它組出 `Class.name`。
- `parse_call()` 是 `parse_term` 與 `parse_do` 共用的核心。
- `parse_args()` 回傳參數個數，供 `call X n` 使用。
