# 07-strings 支援的語法（EBNF）

在 06 之上加入**字串常數**。語法上只多了 `term` 的一個分支
（`Kind::Str` → `emit_string()`），其餘完全不變。

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
               | string
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
string         = '"' { ? 任意字元（含換行），但雙引號要先結束 ? } '"' ;
letter         = ? 字母（Unicode 字母皆可）? ;
digit          = '0' | '1' | … | '9' ;

comment        = '//' { ? 非換行字元 ? }
               | '/*' { ? 任意字元 ? } '*/' ;
```

## 字串的編法

`"Hi!"` 會被編成 `String.new` + 一連串 `String.appendChar`：

```
push constant 3          ; 長度
call String.new 1        ; 建立空字串
push constant 72         ; 'H'
call String.appendChar 2
push constant 105        ; 'i'
call String.appendChar 2
push constant 33         ; '!'
call String.appendChar 2 ; 回傳字串本身，位址留在堆疊上
```

* 因為 `appendChar` **回傳字串本身**，整串呼叫做完後堆疊頂端正好是字串物件，
  可以直接 `pop local 0` 或當參數推入。
* 空字串 `""` 只編出 `push constant 0` + `call String.new 1`。
* 字元以數值表示（`'H'` = 72）；此版取 `ch as u32`，對 ASCII 與 UTF-16
  前段相符。
* **字串不能有轉義序列**：`"` 一律代表字串結束，沒有 `\"`。

## 這一版的限制

* 沒有陣列 `a[i]`（→ 08-array）。

## 範例

```jack
class Greeter {
    function void run() {
        var String s;
        let s = "Hi!";
        do Output.printString(s);
        return;
    }

    function void empty() {
        var String s;
        let s = "";
        do Output.printString(s);
        return;
    }
}
```
