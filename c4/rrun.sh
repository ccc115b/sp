#!/bin/bash
set -e

echo "=== 1. 編譯 Rust 版編譯器與虛擬機 ==="
rustc c4.rs -o c4_rs
rustc vm4.rs -o vm4_rs

echo "=== 2. 用 c4_rs 印出 hello.c 組語 (-s) ==="
./c4_rs -s hello.c

echo "=== 3. 用 c4_rs 編譯 hello.c 產出 hello.bc ==="
./c4_rs hello.c hello.bc

echo "=== 4. 用 vm4_rs 執行 hello.bc ==="
./vm4_rs hello.bc

echo "=== 5. 用 vm4_rs 單步追蹤執行 hello.bc (-d) ==="
./vm4_rs -d hello.bc