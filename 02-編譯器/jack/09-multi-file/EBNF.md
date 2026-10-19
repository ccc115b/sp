# 09-multi-file 支援的語法（EBNF）

這一版**不改語法**，只讓 `jackc` 能一次吃一整個目錄（一個檔一個類別）。
支援的語言與 08-array **完全相同**：

## 語法

```ebnf
class          = 'class' identifier '{' { classVarDec } { subroutine } '}' ;

classVarDec    = ( 'static' | 'field' ) type identifier { ',' identifier } ';' ;

subroutine     = ( 'function' | 'method' | 'constructor' )
                 type identifier '(' params ')' '{' { varDec } { statement } '}' ;

params         = [ type identifier { ',' type identifier } ] ;
varDec         = 'var' type identifier { ',' identifier } ';' ;

statement      = letStmt | ifStmt | whileStmt | doStmt | returnStmt ;

letStmt        = 'let' identifier [ '[' expression ']' ] '=' expression ';' ;
doStmt         = 'do' subroutineCall ';' ;
ifStmt         = 'if' '(' expression ')' '{' { statement } '}'
                 [ 'else' '{' { statement } '}' ] ;
whileStmt      = 'while' '(' expression ')' '{' { statement } '}' ;
returnStmt     = 'return' [ expression ] ';' ;

expression     = term { binaryOp term } ;
binaryOp       = '+' | '-' | '*' | '/' | '&' | '|' | '<' | '>' | '=' ;
term           = integer
               | string
               | keywordConstant
               | '-' term
               | '~' term
               | '(' expression ')'
               | identifier [ '[' expression ']' | '(' args ')' | '.' identifier '(' args ')' ] ;

subroutineCall = identifier ( '(' args ')' | '.' identifier '(' args ')' ) ;
args           = [ expression { ',' expression } ] ;

keywordConstant = 'true' | 'false' | 'null' | 'this' ;
type           = 'void' | 'int' | 'boolean' | 'char' | identifier ;
```

## 詞法（token）

```ebnf
identifier     = ( letter | '_' ) { letter | digit | '_' } ;
integer        = digit { digit } ;
string         = '"' { ? 任意字元（含換行）? } '"' ;
letter         = ? 字母（Unicode 字母皆可）? ;
digit          = '0' | '1' | … | '9' ;

comment        = '//' { ? 非換行字元 ? }
               | '/*' { ? 任意字元 ? } '*/' ;
```

## 檔案層級的規則

```ebnf
program        = class ;          (* 一個檔案恰好一個 class *)
```

* 慣例上**檔名 = 類別名**（`Point.jack` 放 `class Point`），但編譯器不檢查。
* 目錄模式下，`*.jack` 依檔名排序，各自產出同名 `.vm`。
* **跨檔呼叫不需要特殊處理**：編譯 `Shape.jack` 時不知道 `Point` 的內容，
  但 `Point.new(1, 2)` 因為 `Point` 不在符號表而被當成**類別名**，
  直接編成 `call Point.new 2`。類別之間的關係留給 VM 的 linker / runtime。

## 這一版的限制

* 還沒有錯誤恢復（→ 10-errors）。

## 範例（示範跨檔）

`src/Point.jack`：

```jack
class Point {
    field int x;
    field int y;

    constructor Point new(int px, int py) {
        let x = px;
        let y = py;
        return this;
    }

    method int sum() {
        return x + y;
    }
}
```

`src/Shape.jack`：

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
}
```
