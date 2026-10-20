# jvm0

用 Rust 寫成的微型 JVM（零依賴），可直接執行或反組譯 `javac` 產生的 `.class`。

```sh
cargo build --release
javac examples/Demo.java
./target/release/jvm0 examples/Demo.class      # 執行（加 -t 可追蹤每個 opcode）
./target/release/jvm0 -d examples/Demo.class   # 反組譯（javap -c 風格）
```

## 模組
- `src/classfile.rs`：`.class` 檔解析（constant pool、欄位、方法、Code attribute）
- `src/vm.rs`：bytecode 直譯器（執行）
- `src/disasm.rs`：bytecode 反組譯器（列出 opcode、operands 與 constant pool 註解）
- `src/main.rs`：命令列進入點

## 反組譯
`-d`／`--disasm` 以 `javap -c -p` 風格輸出類別、欄位與每個方法的 bytecode，
涵蓋完整標準 opcode 表（含尚未支援執行的 long/double、物件、`switch`、例外等）：

```
static int gcd(int, int);
  Code:
    0: iload_1                 
    1: ifeq 15                 
    4: iload_0                 
    ...
   84: iinc 2, 1               
```

分支、`tableswitch`／`lookupswitch` 顯示絕對目標位址，constant pool 運算元附
`// Method Demo.fib:(I)I` 之類的註解。

## 已支援
- 型別：int / boolean / char / byte / short、String 常數、`int[]`
- 指令：常數載入（iconst/bipush/sipush/ldc）、load/store、`iinc`、算術與位元運算、
  `if*`/`if_icmp*`/`if_acmp*`/`ifnull`/`goto`、`newarray(int)`/`iaload`/`iastore`/`arraylength`、
  `dup`/`pop`/`swap`、`invokestatic`（同類別，含遞迴）、`ireturn`/`areturn`/`return`
- `System.out.print/println`（int、char、boolean、String）
- 例外：除以零、陣列越界、StackOverflowError 會以 `Exception in thread "main" ...` 結束（不可被 catch）

## 尚未支援（可作為練習）
long/float/double、`tableswitch`/`lookupswitch`、物件與 `new`/`invokespecial`/實例欄位、
`invokedynamic`（字串 `+` 串接、lambda）、try/catch 例外表、多個類別與 classpath、GC。
