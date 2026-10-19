#!/bin/sh
set -e
cd "$(dirname "$0")"
mkdir -p out
rustc --edition 2021 main.rs -o out/jackc
./out/jackc Counter.jack out/Counter.vm
diff -u expected/Counter.vm out/Counter.vm
echo "04-symbols OK"
