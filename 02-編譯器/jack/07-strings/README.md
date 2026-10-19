# 07-strings：字串常數

> 本版支援的語法以 EBNF 記於 [`EBNF.md`](EBNF.md)。

把 `"..."` 編成**字串物件**。Jack 沒有字串型別運算，全靠 OS 提供的
`String.new` / `String.appendChar`。

## 編法

`"Hi!"` →

```
push constant 3          ; 長度
call String.new 1        ; 建立空字串，回傳物件位址
push constant 72         ; 'H'
call String.appendChar 2 ; 回傳「加上一個字元後的字串」
push constant 105        ; 'i'
call String.appendChar 2
push constant 33         ; '!'
call String.appendChar 2 ; 最後一次呼叫的回傳值就是字串位址
```

因為 `appendChar` **回傳字串本身**，呼叫連鎖做完後堆疊頂端正好是
字串物件位址，可直接 `pop local 0` 或當參數推入。

空字串 `""` 只有前兩行（`push constant 0` + `call String.new 1`）。

## 字元編碼

字元用其數值（`'H'` = 72）。實作取 `ch as u32`，對 ASCII 與 Jack 字串相符。

## 執行

```sh
./run.sh
```

## 輸入 / 輸出

輸入 `Greeter.jack`：

```jack
let s = "Hi!";
do Output.printString(s);
```

輸出 `expected/Greeter.vm`：

```
function Greeter.run 1
push constant 3
call String.new 1
push constant 72
call String.appendChar 2
push constant 105
call String.appendChar 2
push constant 33
call String.appendChar 2
pop local 0
push local 0
call Output.printString 1
pop temp 0
push constant 0
return
function Greeter.empty 1
push constant 0
call String.new 1
pop local 0
push constant 0
return
```

## 實作

`tokenize()` 早就會把 `"..."` 切成 `Kind::Str`，此版本只是在 `parse_term()`
加上一個分支呼叫 `emit_string()`。

## 尚未支援

**陣列** `a[i]` → `08-array`。
