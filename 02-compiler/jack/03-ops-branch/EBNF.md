# 03-ops-branch 支援的語法（EBNF）

在 02 之上補齊**運算子**並加入 **`if` / `else` / `while`**。
對應 `parse_if()` / `parse_while()` / `parse_expr()` / `parse_term()`。

## 語法

```ebnf
class          = 'class' identifier '{' { subroutine } '}' ;

subroutine     = 'function' type identifier '(' params ')'
                 '{' { varDec } { statement } '}' ;

params         = [ type identifier { ',' type identifier } ] ;
varDec         = 'var' type identifier { ',' identifier } ';' ;

statement      = letStmt | ifStmt | whileStmt | returnStmt ;

ifStmt         = 'if' '(' expression ')' '{' { statement } '}'
                 [ 'else' '{' { statement } '}' ] ;
whileStmt      = 'while' '(' expression ')' '{' { statement } '}' ;
letStmt        = 'let' identifier '=' expression ';' ;
returnStmt     = 'return' [ expression ] ';' ;

expression     = term { binaryOp term } ;
binaryOp       = '+' | '-' | '*' | '/' | '&' | '|' | '<' | '>' | '=' ;
term           = integer
               | keywordConstant
               | '-' term
               | '~' term
               | '(' expression ')'
               | identifier ;

keywordConstant = 'true' | 'false' | 'null' ;
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

* **仍然沒有優先權**：`binaryOp` 一視同仁、由左至右。
  `(a & ~b) | (a = b)` 這種寫法要靠括號決定順序。
* 布林常數的編法：`true` → `push constant 0` + `not`（= -1，全位元為 1）；
  `false` / `null` → `push constant 0`。
* `if` 的 `else` 是選用的；`if` 與 `while` 的**主體是 `statement`**，
  所以可以任意巢狀（`if` 裡放 `while`、`while` 裡再放 `if` …）。
* `while` 的條件在迴圈頂端重新求值，條件為假才跳離。

## 這一版的限制

* 還沒有 `do` 與任何**呼叫**（→ 05-calls）。
* 還沒有 `method` / `constructor` / `static` / `field` / `this`（→ 04-symbols）。
* 符號表只有 `argument` / `local` 兩段。

## 範例

```jack
class Branch {
    function int max(int a, int b) {
        var int m;
        if (a > b) {
            let m = a;
        } else {
            let m = b;
        }
        return m;
    }

    function int sum(int n) {
        var int i;
        var int s;
        let i = 0;
        let s = 0;
        while (i < n) {
            let s = s + i;
            let i = i + 1;
        }
        return s;
    }
}
```
