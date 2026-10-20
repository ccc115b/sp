# 02-let-expr 支援的語法（EBNF）

在 01 之上加入**參數、區域變數、`let` 賦值與算式**。
對應 `parse_class()` / `parse_function()` / `parse_params()` /
`parse_var_decls()` / `parse_statements()` / `parse_let()` /
`parse_return()` / `parse_expr()` / `parse_term()`。

## 語法

```ebnf
class          = 'class' identifier '{' { subroutine } '}' ;

subroutine     = 'function' type identifier '(' params ')'
                 '{' { varDec } { statement } '}' ;

params         = [ type identifier { ',' type identifier } ] ;
varDec         = 'var' type identifier { ',' identifier } ';' ;

statement      = letStmt | returnStmt ;

letStmt        = 'let' identifier '=' expression ';' ;
returnStmt     = 'return' [ expression ] ';' ;

expression     = term { ('+' | '-' | '*' | '/') term } ;
term           = integer
               | '-' term
               | '(' expression ')'
               | identifier ;

type           = 'void' | 'int' | 'boolean' | 'char' | identifier ;
```

## 詞法（token）

```ebnf
identifier     = ( letter | '_' ) { letter | digit | '_' } ;
integer        = digit { digit } ;
letter         = ? 字母（Unicode 字母皆可）? ;
digit          = '0' | '1' | … | '9' ;

comment        = '//' { ? 非換行字元 ? }
               | '/*' { ? 任意字元 ? } '*/' ;
```

## 語意重點

* **Jack 的算式沒有優先權**：`expression` 就是「一個 term，後面每看到一個
  運算子就再接一個 term」，一律**由左至右**。
  `a + b * 2` 等於 `(a + b) * 2`；要改變順序只能自己加括號。
* `var` 宣告決定 `function` 那行的 nLocals；`var` 要寫在所有陳述之前。
* 參數依序佔 `argument 0, 1, …`，區域變數依序佔 `local 0, 1, …`。
* `let` 只能寫簡單變數；賦值給參數不合法。

## 這一版的限制

* 只有 `let` 與 `return` 兩種陳述：還沒有 `do` / `if` / `while`。
* 運算子只有 `+ - * /` 與一元 `-`：
  還沒有 `& | < > =`、`~`、`true` / `false` / `null` / `this`。
* 沒有 `method` / `constructor` / `static` / `field` / 呼叫。

## 範例

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
