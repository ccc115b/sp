# 08-array：陣列的讀取與寫入

> 本版支援的語法以 EBNF 記於 [`EBNF.md`](EBNF.md)。

Jack 的陣列是「物件」（`Array`），`a[i]` 透過 VM 的 **THAT 指標**間接存取。

## 讀取 a[i]

```
push <a>          ; 陣列基底位址
push <i>          ; 索引
add               ; = 位址
pop pointer 1     ; THAT = 位址
push that 0       ; RAM[THAT]
```

## 寫入 let a[i] = e

```
push <a>
push <i>
add               ; 位址先留在堆疊上
<e>               ; 再算值（可能弄壞 THAT，無妨）
pop temp 0        ; 暫存值
pop pointer 1     ; 此刻才設 THAT = 位址
push temp 0
pop that 0        ; RAM[THAT] = 值
```

**順序是重點**：位址在算值之前就壓好了，但 `pointer 1` 必須等到值算完才設定，
所以值算式裡若含 `b[j]` 也不會破壞目標位址。

## 執行

```sh
./run.sh
```

## 輸入 / 輸出

輸入 `ArrayTest.jack`：加總陣列、填入陣列，各用一次 `while`。

輸出 `expected/ArrayTest.vm`（節錄）：

```
function ArrayTest.sum 2
push constant 0
pop local 0
push constant 0
pop local 1
label WHILE_EXP0
push local 0
push argument 1
lt
not
if-goto WHILE_END0
push local 1
push argument 0
push local 0
add
pop pointer 1
push that 0
add
pop local 1
...
function ArrayTest.fill 1
...
push argument 0
push local 0
add
push argument 2
pop temp 0
pop pointer 1
push temp 0
pop that 0
...
```

## 實作位置

- `parse_term()` 的 `Kind::Id` 分支多一個 `at_sym('[')` 判斷 → 讀取。
- `parse_let()` 開頭 `if self.accept_sym('[')` → 寫入。
- `let a[i] = ...` 對**參數**也合法（陣列參數是位址，不是值），
  所以 `Seg::Arg` 的「不可賦值」檢查只留在沒有 `[` 的分支。
