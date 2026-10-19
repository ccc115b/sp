# Jack 編譯器支援的語法（EBNF）

`jack/` 把 Jack 原始碼編成 VM 碼。下面這份文法是 `parser.rs` 與
`tokenizer.rs` 實際接受的範圍，不多也不少（模組對照見文末）。

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

每個產生式住在不同檔案：

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

## 範圍與限制

* 涵蓋完整 Jack：`class` / `classVarDec` / 四種 subroutine / 全部指述 / 算式。
* 這是**產生 VM 碼**的前端，不含執行（執行見 [`../vm-emu/`](../vm-emu/)）。
* **算式沒有優先權**：`expression` 由左至右，`a + b * 2` 等於 `(a + b) * 2`。
* `true` → `push constant 0` + `not`（= -1）；`false` / `null` → `push constant 0`。
* **`a.b` 恆為 subroutine call**，不是取欄位。

## 範例

見 `Sample.jack`（正常路徑）與 `Errors.jack`（錯誤路徑）。
