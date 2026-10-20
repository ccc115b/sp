# 06-classes 支援的語法（EBNF）

在 05 之上加入 **`constructor`**，於是 Jack 的四種 subroutine
（`function` / `method` / `constructor`）與全部指述都齊了。
對應 `parse_class()` 的分派與 `parse_function()` 裡 `Sub` 的 `match`。

## 語法

```ebnf
class          = 'class' identifier '{' { classVarDec } { subroutine } '}' ;

classVarDec    = ( 'static' | 'field' ) type identifier { ',' identifier } ';' ;

subroutine     = ( 'function' | 'method' | 'constructor' )
                 type identifier '(' params ')' '{' { varDec } { statement } '}' ;

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

## 三種 subroutine 的差異

| | `argument 0` 是 | 顯式參數從 | 開頭自動插入的前言 |
| --- | --- | --- | --- |
| `function` | 第一個參數 | `argument 0` | 無 |
| `method` | **`this`**（呼叫者推入） | `argument 1` | `push argument 0` / `pop pointer 0` |
| `constructor` | 第一個參數 | `argument 0` | `push constant nFields` / `call Memory.alloc 1` / `pop pointer 0` |

* `constructor` 的 `nFields` 是這個類別欄位（`field`）的總數；
  開頭向 `Memory.alloc` 要一塊記憶體並把 `this` 指向它。
* `constructor` 慣例上以 `return this;` 結束，把新物件交回呼叫者。

## 這一版的限制

* 沒有字串常數（→ 07-strings）。
* 沒有陣列 `a[i]`（→ 08-array）。
* 還沒有多檔編譯（→ 09-multi-file）。

## 範例

```jack
class Point {
    field int x;
    field int y;

    constructor Point new(int px, int py) {
        let x = px;
        let y = py;
        return this;
    }

    method int getX() {
        return x;
    }

    method void shift(int dx, int dy) {
        let x = x + dx;
        let y = y + dy;
        return;
    }

    function int test() {
        var Point p;
        let p = Point.new(3, 4);
        do p.shift(1, 2);
        return p.getX() + p.getY();
    }
}
```
