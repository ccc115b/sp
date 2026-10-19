#!/bin/sh
set -e
cd "$(dirname "$0")"
mkdir -p out
rustc --edition 2021 main.rs -o out/jackc
./out/jackc Calc.jack out/Calc.vm
diff -u expected/Calc.vm out/Calc.vm
echo "02-let-expr OK"
