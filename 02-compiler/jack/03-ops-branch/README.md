# 03-ops-branch：比較、位元運算與 if / while

> 本版支援的語法以 EBNF 記於 [`EBNF.md`](EBNF.md)。

補齊 Jack 的運算子，並加上**條件分支**與**迴圈**，引入 VM 的 `label` / `goto` /
`if-goto`。

## 新增功能

| Jack | VM |
| --- | --- |
| `a & b` `a \| b` | `and` `or` |
| `a < b` `a > b` `a = b` | `lt` `gt` `eq` |
| `-x` `~x` | `neg` `not` |
| `true` | `push constant 0` + `not`（= -1，全部位元為 1） |
| `false` / `null` | `push constant 0` |
| `if (c) { } else { }` | `if-goto` + `goto` + 三個 `label` |
| `while (c) { }` | `label WHILE_EXP` + `not` + `if-goto WHILE_END` |

`this` 仍不支援（→ 04-symbols）。

## if 的編法

```
push <c>            ; 條件
if-goto IF_TRUE0
goto    IF_FALSE0
label   IF_TRUE0
  <then>
goto    IF_END0     ; 有 else 才需要
label   IF_FALSE0
  <else>
label   IF_END0
```

沒有 `else` 時只要 `IF_TRUE0` / `IF_FALSE0` 兩個標籤。

## while 的編法

```
label WHILE_EXP0
push   <c>
not                 ; 條件為假才跳離
if-goto WHILE_END0
  <body>
goto   WHILE_EXP0
label  WHILE_END0
```

## 標籤編號

`Parser.label_id` **每個函式歸零**（`parse_function` 開頭設 0）。
VM 的 `label` 本來就限定在函式之內，所以 `max` 與 `isZero` 都可以使用
`IF_TRUE0` 而不衝突。

## 執行

```sh
./run.sh
```

## 輸入 / 輸出

輸入 `Branch.jack`：四個函式，分別示範 if/else、while、位元運算、布林常數。

輸出 `expected/Branch.vm`（節錄）：

```
function Branch.max 1
push argument 0
push argument 1
gt
if-goto IF_TRUE0
goto IF_FALSE0
label IF_TRUE0
push argument 0
pop local 0
goto IF_END0
label IF_FALSE0
push argument 1
pop local 0
label IF_END0
push local 0
return
...
function Branch.sum 2
...
label WHILE_EXP0
push local 0
push argument 0
lt
not
if-goto WHILE_END0
...
```

## 重點

- **無優先權**仍是 Jack 的語意：`(a & ~b) | (a = b)` 要靠括號表達順序。
- `parse_if()` / `parse_while()` 是**巢狀遞迴**：條件是算式，主體又是
  `parse_statements()`，所以 `if` 裡可以再放 `while`。
- `parse_expr()` 的 `match` 從四個運算子加到九個，其餘程式碼完全沒動。
