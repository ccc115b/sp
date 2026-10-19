#!/bin/sh
set -e
cd "$(dirname "$0")"
mkdir -p out
rustc --edition 2021 main.rs -o out/jackc
./out/jackc Math.jack out/Math.vm
diff -u expected/Math.vm out/Math.vm
echo "05-calls OK"
