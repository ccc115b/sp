#!/bin/sh
set -e
cd "$(dirname "$0")"
mkdir -p out
rustc --edition 2021 main.rs -o out/jackc
./out/jackc Greeter.jack out/Greeter.vm
diff -u expected/Greeter.vm out/Greeter.vm
echo "07-strings OK"
