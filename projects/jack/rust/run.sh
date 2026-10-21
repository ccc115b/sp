#!/bin/sh
# Rust 版 jackc 的使用範例(與 java/run.sh 等價)
set -e
cd "$(dirname "$0")"
./build.sh
./target/release/jackc --run ../examples/oop   # 編譯並直接用 java 執行 Main.main()
./target/release/jackc -d out ../examples/oop  # 只輸出 .class
java -cp out:runtime Main                           # 交給 java 執行
