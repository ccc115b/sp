# jvm0

用 Rust 寫成的微型 JVM（單檔 ~400 行、零依賴），可直接執行 `javac` 產生的 `.class`。

```sh
cargo build --release
javac examples/Demo.java
./target/release/jvm0 examples/Demo.class      # 加 -t 可追蹤每個 opcode
```

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
