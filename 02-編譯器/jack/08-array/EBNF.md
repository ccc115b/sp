# 08-array 支援的語法（EBNF）

在 07 之上加入**陣列**：讀取 `a[i]` 與寫入 `let a[i] = e;`。
對應 `parse_let()` 開頭的 `[` 分支與 `parse_term()` 的 `[` 分支。

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
               | identifier [ arrayAccess | callTail ] ;

arrayAccess    = '[' expression ']' ;
callTail       = '(' args ')' | '.' identifier '(' args ')' ;
subroutineCall = identifier callTail ;
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

## 陣列的讀寫

* **讀取 `a[i]`**：`push a` → `push i` → `add` → `pop pointer 1` →
  `push that 0`（透過 THAT 指標間接取值）。
* **寫入 `let a[i] = e;`**：先推位址再算值，順序是重點：

  ```
  push a
  push i
  add              ; 位址先留在堆疊上
  <e>              ; 再算值（中途弄壞 THAT 也無妨）
  pop temp 0       ; 值先暫存
  pop pointer 1    ; 此刻才設 THAT = 位址
  push temp 0
  pop that 0       ; RAM[THAT] = 值
  ```

  因為 `pointer 1` 等到值算完才設定，所以值算式裡若含 `b[j]` 也不會
  破壞目標位址。
* `let a[i] = ...` 對**參數**也合法（陣列參數是位址，不是值），
  所以「參數不可賦值」的限制只作用在沒有 `[` 的 `let`。

## 這一版的限制

* 還沒有多檔編譯（→ 09-multi-file）。

## 範例

```jack
class ArrayTest {
    function int sum(Array a, int n) {
        var int i;
        var int s;
        let i = 0;
        let s = 0;
        while (i < n) {
            let s = s + a[i];
            let i = i + 1;
        }
        return s;
    }

    function void fill(Array a, int n, int v) {
        var int i;
        let i = 0;
        while (i < n) {
            let a[i] = v;
            let i = i + 1;
        }
        return;
    }
}
```
