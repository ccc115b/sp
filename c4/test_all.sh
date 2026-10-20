#!/bin/bash
set -e

echo "=== 1. 編譯 C 與 Rust 執行檔 ==="
gcc -Wno-everything c4.c -o c4_c
gcc -Wno-everything vm4.c -o vm4_c
rustc c4.rs -o c4_rs
rustc vm4.rs -o vm4_rs

echo "=== 2. 測試 Rust VM 執行 C 版生成的 Bytecode ==="
./c4_c c4.c c4_gen1.bc
./vm4_rs c4_gen1.bc c4.c c4_gen2.bc
cmp c4_gen1.bc c4_gen2.bc
echo "=> C 編譯器 + Rust VM 自我編譯驗證成功！"

echo "=== 3. 測試 C 語言 VM 執行 Rust 版生成的 Bytecode ==="
./c4_rs c4.c c4_rs1.bc
./vm4_c c4_rs1.bc c4.c c4_rs2.bc
cmp c4_rs1.bc c4_rs2.bc
echo "=> Rust 編譯器 + C VM 自我編譯驗證成功！"

echo "=== 4. 執行 Hello World 測試 ==="
./vm4_rs c4_gen2.bc hello.c hello.bc
./vm4_rs hello.bc