# 1. 編譯 c4ll.rs 成 IR 編譯器
rustc c4ll.rs -o build/c4_ll

# 2. .c → .ll
./build/c4_ll examples/$1.c -o build/$1.ll
#    語法: c4ll [-o out.ll] in.c

# 2.1 產生組合語言
llc build/$1.ll -o build/$1.s

# 3. 用 lli 執行
lli build/$1.ll
#    若 PATH 有 LLVM，直接 `lli build/hello.ll` 即可
#    帶參數: lli build/args.ll alpha 42
