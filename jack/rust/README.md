# jackc — Jack → JVM bytecode 編譯器(Rust 版)

`../java/` 的 Jack 編譯器(單一檔案 `src/jackc/JackCompiler.java`)用 Rust 重寫,放在這個資料夾。
後端相同:一樣把 Jack 編譯成 version 50(Java 6、無 StackMapTable)的 class 檔,所以兩版的輸出可以逐位元組比對(`./test.sh`)。
Jack OS 的 runtime 仍然是 Java 寫的 `jack.*`(`../java/src/jack/`),Rust 版只負責產生使用者自己的 class。

## 建置與使用

    ./build.sh                                     # cargo build --release,並用 javac 編出 runtime/
    ./target/release/jackc --run ../examples/oop   # 編譯並用 java 直接執行 Main.main()
    ./target/release/jackc -d out ../examples/oop  # 輸出 .class
    java -cp out:runtime Main                      # 交給 java 執行
    ./test.sh                                      # 與 Java 版對照(位元組 + 錯誤訊息)

程式入口同 Java 版:`class Main { function void main() { ... } }`(編譯器另外產生 `public static void main(String[])`)。

## 原始碼結構(與 Java 版章節一一對應)

| Rust | Java `JackCompiler.java` 的章節 |
|---|---|
| `src/error.rs` | `CompileError` |
| `src/lexer.rs` | Lexer / `Token` |
| `src/ast.rs` | AST |
| `src/parser.rs` | `Parser` |
| `src/classfile.rs` | `ConstPool` `ClassFile` `Code` 與 JVM opcodes |
| `src/codegen.rs` | `Gen` / `Var` |
| `src/main.rs` | `main` `compile()` `BUILTINS` |

零第三方相依(只用 std);例外改成回傳 `Result`,錯誤格式仍是 `檔名:行號: error: 訊息`。

## 語意對應

| Jack | JVM |
|---|---|
| `int` `char` `boolean` | `int`(32 位元;`true = -1`、`false = 0`,所以 `~` `&` `\|` 同時適用位元/邏輯) |
| `Array` | `int[]`(`Array.new(n)` → `newarray`) |
| `String` | `jack.JString`(可變字串,字串常數 `"..."` 會 new 一個) |
| 自訂 class | 同名 class,`field`/`static` → public 欄位 |
| `method` / `function` | public 實例方法 / public static 方法 |
| `constructor Foo new(..)` | public static `$new(..)`,內部 `new Foo` 存進 `this` |
| `null` | `aconst_null`(`x = 0` 對物件變數也視為 null 比較) |

- 運算式由左至右求值,沒有優先順序(同 Jack 規格)。
- 有簡單的型別檢查(型別不符、參數數量、未定義變數/類別/子程式、在 function 中用 this/field 等),錯誤訊息含檔名與行號。

## 與原版 Jack 的差異 / 限制

同 `../java/README.md`:整數 32 位元、`Array` 只能放 int、沒有 `Screen`/`Keyboard`、沒有繼承、
沒有 `char` 字面值(用整數字碼)、`dispose()` 不做事(記憶體由 GC 管理)。

## 與 Java 版的差異

- `--run` 沒辦法在行程內載入 class(Rust 裡沒有 JVM),改成把 class 寫到暫存目錄後,
  呼叫系統的 `java -cp <暫存目錄>:<runtime> Main`,再回傳它的結束碼。
- `build.sh` 會用 `javac` 把 `../java/src/jack/*.java` 編到 `runtime/`;若找不到 `javac` 或 `runtime/`,
  `--run` 會自己尋找 `../java/build`、`../java/jackc.jar`,也可以用環境變數 `JACK_CLASSPATH` 指定。
- 其餘行為(輸出的 .class、錯誤訊息、結束碼)都與 Java 版一致,由 `test.sh` 驗證。
