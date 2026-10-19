#!/bin/sh
set -e
cd "$(dirname "$0")"
mkdir -p out
rustc --edition 2021 main.rs -o out/jackc
./out/jackc Hello.jack out/Hello.vm
diff -u expected/Hello.vm out/Hello.vm
echo "01-hello-jack OK"
