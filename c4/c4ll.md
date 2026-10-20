```sh
(.venv) cccuser@cccimacdeiMac c4 % ./c4ll.sh hello
hello, world!
42 = 42

(.venv) cccuser@cccimacdeiMac c4 % ./ll_examples.sh
=== 1. rustc 編譯 c4ll.rs (c4 前端 -> LLVM IR 後端) ===
  => build/c4_ll (LLVM IR 編譯器)
  => /opt/homebrew/opt/llvm/bin/lli (Homebrew LLVM version 22.1.4)
=== 2. 產生 fileio 測試檔 ===
=== 3. 編譯成 .ll 並用 lli 執行 examples/*.c ===
  [PASS] args (args.ll + lli)
  [PASS] arith (arith.ll + lli)
  [PASS] enum (enum.ll + lli)
  [PASS] fileio (fileio.ll + lli)
  [PASS] fileio copy identical (7000 bytes)
  [PASS] fizzbuzz (fizzbuzz.ll + lli)
  [PASS] hello (hello.ll + lli)
  [PASS] pointers (pointers.ll + lli)
  [PASS] primes (primes.ll + lli)
  [PASS] recursion (recursion.ll + lli)
  [PASS] sort (sort.ll + lli)
  [PASS] strings (strings.ll + lli)

結果: pass=12 fail=0
```
