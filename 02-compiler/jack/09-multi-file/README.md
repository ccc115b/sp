# 09-multi-file：編譯整個資料夾

> 本版支援的語法以 EBNF 記於 [`EBNF.md`](EBNF.md)。

Jack 一個檔一個類別，實際專案一定有很多檔。此版本讓 `jackc` 可以直接吃**目錄**。

## 用法

```sh
jackc <in.jack> [out.vm]     # 單檔（與 01-08 相同）
jackc <dir>                  # 目錄：.vm 寫回原目錄
jackc <dir> <outdir>         # 目錄：.vm 全部放到 outdir
```

## 為什麼「跨檔呼叫」不需要特殊處理

編譯 `Shape.jack` 時，編譯器根本不知道 `Point` 的內容，但輸出仍然正確：

| 情境 | 判斷方式 | 結果 |
| --- | --- | --- |
| `Point.new(1, 2)` | `Point` **不在符號表** | 當成類別名 → `call Point.new 2` |
| `a.sum()` | `a` 在符號表，型別 `Point` | `push this 0` + `call Point.sum 1` |

Jack 的符號表只管「名字在不在」，類別之間的關係全部留給 VM 的
linker/runtime（其實就是 `call <Class>.<func>` 這個名稱）。所以
**單趟、無全域符號表**的設計在多檔下依然成立。

## 交錯規則

輸出檔案依檔名排序逐一處理，順序不影響結果：

```
src/Point.jack  →  out/Point.vm
src/Shape.jack  →  out/Shape.vm
```

## 錯誤訊息加檔名

多檔時光印行號不夠，`Parser` 新增 `file` 欄位：

```
$ ./out/jackc src /tmp/out9
src/Bad.jack:3: 變數 x 未宣告
```

`tokenize()` 也多收一個 `file` 參數，字詞錯誤同樣會帶檔名。

## 執行

```sh
./run.sh
```

`run.sh` 會編譯 `src/` 到 `out/`，並把 `Point.vm`、`Shape.vm` 與
`expected/` 兩份 golden file 逐一 `diff`。

## 輸入

`src/Point.jack`：座標點（constructor + method）。

`src/Shape.jack`：由兩個點組成的形狀，呼叫 `Point.new` 與 `a.sum()`：

```jack
class Shape {
    field Point a;
    field Point b;

    constructor Shape new() {
        let a = Point.new(1, 2);
        let b = Point.new(3, 4);
        return this;
    }

    method int total() {
        return a.sum() + b.sum();
    }

    function int test() {
        var Shape s;
        let s = Shape.new();
        return s.total();
    }
}
```

## 輸出（節錄 `expected/Shape.vm`）

```
function Shape.new 0
push constant 2
call Memory.alloc 1
pop pointer 0
push constant 1
push constant 2
call Point.new 2
pop this 0
...
function Shape.total 0
push argument 0
pop pointer 0
push this 0
call Point.sum 1
push this 1
call Point.sum 1
add
return
```
