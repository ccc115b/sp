#!/bin/sh
set -e
cd "$(dirname "$0")"
mkdir -p out
rustc --edition 2021 main.rs -o out/jackc
./out/jackc ArrayTest.jack out/ArrayTest.vm
diff -u expected/ArrayTest.vm out/ArrayTest.vm
echo "08-array OK"
