# jackc — Jack → JVM bytecode 編譯器

借用 nand2tetris 的 Jack 語法,直接編譯成 Java class 檔,交給 JVM 執行。
沒有 VM translator、沒有組合語言、沒有 OS;只有一個極小的 Java runtime(`src/jack/`)提供 `Output`、`Math`、`String`、`Array`、`Sys`、`Memory`。

## 建置與使用

    ./build.sh                                   # 產生 jackc.jar(有 javac 用 javac,否則用 jdk.compiler 模組)
    java -jar jackc.jar --run ../examples/oop       # 編譯並直接執行 Main.main()
    java -jar jackc.jar -d out ../examples/oop      # 輸出 .class
    java -cp out:jackc.jar Main                  # 交給 java 執行(需要 jackc.jar 內的 jack.* runtime)

程式入口:`class Main { function void main() { ... } }`(編譯器會另外產生 `public static void main(String[])`)。

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
- Class file 版本 50(Java 6),不需要 StackMapTable;現行 JDK(含 21)仍可載入執行。
- 有簡單的型別檢查(型別不符、參數數量、未定義變數/類別/子程式、在 function 中用 this/field 等),錯誤訊息含檔名與行號。

## 與原版 Jack 的差異 / 限制

- 整數是 32 位元,不是 16 位元。
- `Array` 只能放 int(不能放物件);要放物件請自訂 class 當容器。
- 沒有 `Screen`、`Keyboard`;`Output` 只有 `printString/printInt/println/printChar/backSpace`。
- 沒有繼承、沒有 `char` 字面值(用整數字碼,如 `65`)。
- `dispose()` / `Memory.deAlloc` 不做事,記憶體由 GC 管理。
