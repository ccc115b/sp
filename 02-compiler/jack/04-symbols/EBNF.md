# 04-symbols 支援的語法（EBNF）

在 03 之上加入**類別層級變數（`static` / `field`）**與 **`method` / `this`**。
對應 `parse_class()` / `parse_class_var_decls()` / `parse_function()` /
`parse_term()`。

## 語法

```ebnf
class          = 'class' identifier '{' { classVarDec } { subroutine } '}' ;

classVarDec    = ( 'static' | 'field' ) type identifier { ',' identifier } ';' ;

subroutine     = ( 'function' | 'method' ) type identifier '(' params ')'
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

## 語意重點

* **兩層符號表**：`classVarDec` 進 class 層（`static` → `static n`，
  `field` → `this n`），`params` / `varDec` 進 function 層
  （`argument n` / `local n`）。查名字時先查 function 層，再查 class 層，
  所以**區域變數可以遮蔽欄位**。
* **`classVarDec` 必須寫在所有 subroutine 之前**（Jack 文法規定）。
  寫在後面會得到 `class 變數（static/field）必須宣告在 subroutine 之前`。
* `method` 多一個隱藏參數 `this`：`argument 0` 保留給呼叫者推入的物件，
  第一個顯式參數從 `argument 1` 起算；函式開頭會自動插入
  `push argument 0` / `pop pointer 0`。
* `this` 這個運算式求值成 `push pointer 0`，所以 `return this;` 可以回傳自己。

## 這一版的限制

* `constructor` 尚未支援（→ 06-classes）。
* 還沒有 `do` 與任何**呼叫**（→ 05-calls）。
* `this.field` **不是** Jack 的寫法：文法上 `a.b` 恆為 subroutine call。
  在 method 裡直接寫欄位名（例如 `count`）即可。

## 範例

```jack
class Counter {
    static int total;
    field int count;

    method int bump() {
        let count = count + 1;
        let total = total + 1;
        return count;
    }

    method Counter self() {
        return this;
    }

    function int grandTotal() {
        return total;
    }
}
```
