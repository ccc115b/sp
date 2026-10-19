# 11-modular 支援的語法（EBNF）

這一版**不改語法**，只是把 10-errors 那一千行的編譯器拆成
`main.rs` / `tokenizer.rs` / `symbols.rs` / `vm.rs` / `parser.rs` 五個模組。
支援的語言與 10-errors 完全相同。

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

## 文法對應到哪個模組

語法本身沒變，但每個產生式現在住在不同檔案：

| 產生式 | 負責的模組 / 函式 |
| --- | --- |
| 詞法（`identifier` / `integer` / `string` / `comment`） | `tokenizer.rs` |
| `class` / `classVarDec` / `subroutine` | `parser.rs`（`parse_class` / `parse_function`） |
| `statement` 各條 | `parser.rs`（`parse_statements` 與 `parse_let` / `parse_if` / `parse_while` / `parse_do` / `parse_return`） |
| `expression` / `term` / `subroutineCall` / `args` | `parser.rs`（`parse_expr` / `parse_term` / `parse_call` / `parse_args`） |
| 名字 → 段與編號（`argument` / `local` / `static` / `field`） | `symbols.rs` |
| VM 指令的拼字 | `vm.rs` |

* `parser.rs` 只決定「下哪道指令、先後順序」，指令字面長相由 `vm.rs` 決定。
* 對外只開 `parser::compile(file, src) -> Option<String>`；
  `Parser` / `Sub` / `Level` 都是模組私有。

## 這一版的限制

* 語法與 10-errors 相同，沒有新增或移除任何產生式。
* 本版只負責「產生 VM 碼」，不含執行（→ 12-vm-emu）。

## 範例

見 `Sample.jack`（正常路徑）與 `Errors.jack`（錯誤路徑），
兩者與 10-errors 的測試輸入**完全相同**。
