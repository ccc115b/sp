# 01-hello-jack 支援的語法（EBNF）

這一版只收「一個類別 + 一個以上的 function + `return`」。
下面這份文法是 `main.rs` 的 `parse_class()` / `parse_function()` /
`parse_return()` 逐條對應出來的，不多也不少。

## 語法

```ebnf
class          = 'class' identifier '{' { subroutine } '}' ;

subroutine     = 'function' type identifier '(' ')' '{' { returnStmt } '}' ;

returnStmt     = 'return' [ integer ] ';' ;

type           = 'void' | 'int' | 'boolean' | 'char' | identifier ;
```

## 詞法（token）

```ebnf
identifier     = ( letter | '_' ) { letter | digit | '_' } ;
integer        = digit { digit } ;
letter         = ? 字母（實作用 Rust 的 Unicode 字母判斷，不限 ASCII）? ;
digit          = '0' | '1' | … | '9' ;

comment        = '//' { ? 非換行字元 ? }
               | '/*' { ? 任意字元 ? } '*/' ;
```

* 空白、換行與註解會在切字階段全部丟掉。
* 運算子與標點：`{ } ( ) [ ] . , ; + - * / & | < > = ~`（此版只用到其中幾個）。
* 關鍵字：`class` `constructor` `function` `method` `field` `static` `var`
  `int` `char` `boolean` `void` `true` `false` `null` `this`
  `let` `do` `if` `else` `while` `return`。

## 這一版的限制

* **只能有 function**：沒有 `method`、`constructor`、`static` / `field`。
* **不能有參數、不能有區域變數**：`function t f()` 的括號必須是空的。
* **`return` 之後只能是整數常數**（或什麼都不接）。
  `return x;`、`return a + 1;` 都會得到 `此版本的算式只支援整數常數`。
* `return;`（void）會被補成 `push constant 0` 再 `return`。
* 回傳型別可寫 `void` / `int` / `boolean` / `char` / 類別名，但此版不檢查。

## 範例

```jack
class Hello {
    function void main() {
        return;
    }

    function int answer() {
        return 42;
    }
}
```
