# xisp

用 `tag ... _tag` 取代括號的 Lisp。`(f a b)` 寫成 `f a b _f`。

## 使用

    node xisp.js examples/factorial.xisp
    npm test

需要 Node.js 14 以上，沒有任何相依套件。

## 語法

- 結束標籤 = `_` + 開始標籤名稱：`fact ... _fact`、`if ... _if`
- 檔案中出現過 `_foo`，`foo` 就是開始標籤；沒有 `_foo` 的詞是一般原子（變數、數字）
- 字串用雙引號，`;` 開頭是註解
- 頂層運算式的值會自動印出

## 特殊形式

| 形式 | 說明 |
|---|---|
| `if 條件 then [else] _if` | 條件式 |
| `cond when 條件 ... _when ... else ... _else _cond` | 多分支 |
| `let 名 值 ... in 本體 _let` | 區域變數，依序綁定 |
| `fn 名稱 參數... 本體 _fn` | 定義函式 |
| `lambda 參數... 本體 _lambda` | 匿名函式 |
| `call f 引數... _call` | 呼叫函式值 |
| `def 名 值 _def` / `set 名 值 _set` | 定義 / 賦值 |
| `for i 起 迄 本體 _for` | 迴圈（含頭含尾） |
| `while 條件 本體 _while` | while 迴圈 |
| `do ... _do`、`and`、`or` | 循序、邏輯 |

## 內建函式

`add sub mul div mod lt gt le ge eq ne not abs min max list cons car cdr nth append length null range map filter reduce str print`

## 注意

- 變數 / 參數名稱不要和檔案中用作標籤的名稱相同（例如參數叫 `list`，但檔案又有 `list ... _list`）。
- 每個有結束標籤的詞都必須寫結束標籤，包含 `def`、`print`、`str` 等。
- 結束標籤配錯時會指出位置，例如：`line 4: 預期 _sub（sub 開在第 4 行），卻看到 _add`

## 專案結構

    xisp.js       直譯器（tokenizer、reader、evaluator、內建函式）
    examples/     範例程式（*.xisp）與預期輸出（*.out）
    test/run.js   執行所有範例並比對輸出
