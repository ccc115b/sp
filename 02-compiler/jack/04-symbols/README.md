# 04-symbols：field / static / this / method

> 本版支援的語法以 EBNF 記於 [`EBNF.md`](EBNF.md)。

把符號表拆成**兩層**，支援類別層級的變數與方法（method），這是物件導向的基礎。

## 新增功能

| Jack | VM |
| --- | --- |
| `static int total;` | `push/pop static n`（整份類別共用） |
| `field int count;` | `push/pop this n`（依物件而異） |
| `method void f()` | 多一個隱藏參數 `this`；函式開頭設 `pointer 0` |
| `return this;` | `push pointer 0` |

## 兩層符號表

```rust
struct Symbols {
    class_map: HashMap<String, (Seg, usize)>,  // static / field
    fn_map:    HashMap<String, (Seg, usize)>,  // argument / local
    ...
}
```

- `begin_fn(is_method)`：清空 `fn_map`；若是 method 則 `n_args = 1`
  （`argument 0` 保留給 `this`，第一個顯式參數才是 `argument 1`）。
- `lookup()`：先查 function 層，再查 class 層 → **區域變數可遮蔽欄位**。
- `declare()`：依段別決定放進哪張表、用哪個計數器。

## method 的開頭

```jack
method int bump() { ... }
```

編成：

```
function Counter.bump 0
push argument 0     ; 取出隱藏的 this
pop pointer 0       ; 設定 this 指標，之後 push this n 才指得到物件
  ...函式內容...
```

`function` 不會有這兩行，所以 `function` 內的 `total` 讀到的是 `static 0`，
而 `method` 內的 `count` 讀到的是 `this 0`。

## 執行

```sh
./run.sh
```

## 輸入 / 輸出

輸入 `Counter.jack`：一個靜態計數器 + 一個物件計數器。

輸出 `expected/Counter.vm`：

```
function Counter.reset 0
push argument 0
pop pointer 0
push constant 0
pop this 0
push constant 0
pop static 0
push constant 0
return
function Counter.bump 0
push argument 0
pop pointer 0
push this 0
push constant 1
add
pop this 0
push static 0
push constant 1
add
pop static 0
push this 0
return
function Counter.self 0
push argument 0
pop pointer 0
push pointer 0
return
function Counter.grandTotal 0
push static 0
return
```

## 語法限制

- `classVarDec` 必須全部寫在 subroutine **之前**（Jack 文法規定），
  寫在後面會得到 `class 變數（static/field）必須宣告在 subroutine 之前`。
- `constructor` 尚未支援 → `06-classes`。
- `this.field` **不是** Jack 的寫法：文法上 `a.b` 恆為 subroutine call。
  在 method 裡直接寫欄位名（例如 `count`）即可。
