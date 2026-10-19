#!/bin/sh
set -e
cd "$(dirname "$0")"
mkdir -p out
rustc --edition 2021 main.rs -o out/jackc
./out/jackc Branch.jack out/Branch.vm
diff -u expected/Branch.vm out/Branch.vm
echo "03-ops-branch OK"
