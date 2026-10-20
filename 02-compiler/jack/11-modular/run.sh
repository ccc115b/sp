#!/bin/sh
set -e
cd "$(dirname "$0")"
mkdir -p out
rustc --edition 2021 main.rs -o out/jackc
rm -f out/*.vm out/*.err
./out/jackc Sample.jack out/Sample.vm
diff -u expected/Sample.vm out/Sample.vm
if ./out/jackc Errors.jack out/Errors.vm 2> out/Errors.err; then
    echo "Errors.jack 應該要編譯失敗，但成功了" >&2
    exit 1
fi
diff -u expected/Errors.err out/Errors.err
if [ -f out/Errors.vm ]; then
    echo "有錯誤時不應該輸出 Errors.vm" >&2
    exit 1
fi
echo "11-modular OK"
