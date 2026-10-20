# 10-errors 支援的語法（EBNF）

這一版**不改語法**，改的是「遇到不合語法時怎麼辦」：一次回報多個錯誤、
每則錯誤都有 `檔名:列:欄`，而且**有任何錯誤就不輸出 `.vm`**。
支援的語言與 09-multi-file 完全相同。

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

## 錯誤回報的格式

只要不合上面的文法（或詞法），就輸出一段固定格式並以狀態碼 1 結束，
**不寫出 `.vm`**：

```
<file>:<line>:<col>: error: <訊息>
<該行原始碼>
<空白>^                        ← 指標對準 col
…
共 N 個錯誤
```

每個 `Token` 因此帶 `line` 與 `col`；`col` = `目前索引 - 本行起始索引 + 1`，
所以製表字元也算一個字。

## 錯誤恢復（error recovery）

為了「繼續編下去、把後面的錯誤也找出來」，出錯後要猜到一個**安全落點**，
把中間的 token 丟掉。落點依層級而定：

| 層級 | 從哪裡恢復 | 落點（stop set） |
| --- | --- | --- |
| `ClassVar` | class 變數宣告 | `static` `field` `function` `method` `constructor` `}` |
| `Class` | subroutine 之間 | `function` `method` `constructor` `}` |
| `Stmt` | 陳述之間 | `let` `if` `while` `do` `return` `}` |

* 恢復時**至少前進一格**再開始找落點，否則目前這個 token 剛好不在
  stop set 裡時會原地打轉。
* 同一段落只記**第一個**錯誤（用 `failed` 旗標擋掉連鎖錯誤），
  直到下次 `synchronize()` 才清除。
* 詞法錯誤不需要落點，跳過壞字元繼續切即可，所以同樣能一次回報多個。
* 詞法錯誤與語法錯誤最後合流，依 `(line, col)` 排序後一起印出。

## 這一版的限制

* 語法本身沒有新增；`10-errors` 加的是**診斷能力**。
* 下一版 `11-modular` 會把同一支編譯器拆成多個模組，語法不變。

## 範例

```jack
class Sample {
    static int total;
    field int count;

    constructor Sample new() {
        let count = 0;
        return this;
    }

    method int bump() {
        let count = count + 1;
        let total = total + 1;
        return count;
    }
}
```
