# 05-calls 支援的語法（EBNF）

在 04 之上加入**呼叫（subroutineCall）**與 **`do` 指述**。
對應 `parse_do()` / `parse_call()` / `parse_args()` 與 `parse_term()` 的新分支。

## 語法

```ebnf
class          = 'class' identifier '{' { classVarDec } { subroutine } '}' ;

classVarDec    = ( 'static' | 'field' ) type identifier { ',' identifier } ';' ;

subroutine     = ( 'function' | 'method' ) type identifier '(' params ')'
                 '{' { varDec } { statement } '}' ;

params         = [ type identifier { ',' type identifier } ] ;
varDec         = 'var' type identifier { ',' identifier } ';' ;

statement      = letStmt | ifStmt | whileStmt | doStmt | returnStmt ;

doStmt         = 'do' subroutineCall ';' ;
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
               | identifier [ '(' args ')' | '.' identifier '(' args ')' ] ;

subroutineCall = identifier ( '(' args ')' | '.' identifier '(' args ')' ) ;
args           = [ expression { ',' expression } ] ;

keywordConstant = 'true' | 'false' | 'null' | 'this' ;
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

## 三種呼叫的判定

`subroutineCall` 的兩個形式看起來一樣，編出來的碼卻不同。判斷關鍵是
**第一個 identifier 在不在符號表裡**：

| 寫法 | 是變數嗎 | 先推 | callee | 參數個數 |
| --- | --- | --- | --- | --- |
| `f(a)` | — | `push pointer 0` | `當前類別.f` | 人寫的 + 1 |
| `Cls.f(a)` | 否（類別名） | 無 | `Cls.f` | 人寫的 |
| `obj.m(a)` | 是 | `push <obj>` | `obj 的型別.m` | 人寫的 + 1 |

* **裸呼叫 `f(a)` 恆為 `this.f(a)`**。要在 method 裡呼叫同類別的 function，
  必須寫 `Cls.f(a)`，否則會多推一個 `this` 造成參數錯位。
* `let r = f(x);` 把呼叫的**回傳值留在堆疊上**；
  `do f();` 則在呼叫後補 `pop temp 0` 把回傳值丟掉。

## 這一版的限制

* 還是沒有 `constructor`（→ 06-classes）。
* 沒有字串常數（→ 07-strings）、沒有陣列（→ 08-array）。

## 範例

```jack
class Math {
    function int square(int n) {
        return n * n;
    }

    method int twice(int n) {
        return double(n);
    }

    method int double(int n) {
        return n + n;
    }

    function int run(int a, int b) {
        var int r;
        let r = square(a) + square(b);
        do print(r);
        return r;
    }

    function void print(int n) {
        do Output.printInt(n);
        return;
    }
}
```
