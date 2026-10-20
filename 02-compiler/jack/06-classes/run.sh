#!/bin/sh
set -e
cd "$(dirname "$0")"
mkdir -p out
rustc --edition 2021 main.rs -o out/jackc
./out/jackc Point.jack out/Point.vm
diff -u expected/Point.vm out/Point.vm
echo "06-classes OK"
