#!/bin/sh
set -e
cd "$(dirname "$0")"
mkdir -p out
rustc --edition 2021 main.rs -o out/jackc
rm -f out/*.vm
./out/jackc src out
diff -u expected/Point.vm out/Point.vm
diff -u expected/Shape.vm out/Shape.vm
echo "09-multi-file OK"
