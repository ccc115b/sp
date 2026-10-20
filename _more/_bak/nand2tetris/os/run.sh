#!/bin/sh
set -e
cd "$(dirname "$0")"
mkdir -p out

# 整個工具鏈：編譯器 jack，以及後端的 vm2asm / hackasm / hackemu
rustc --edition 2021 ../jack/main.rs    -o out/jackc
rustc --edition 2021 ../vm2asm/main.rs  -o out/vm2asm
rustc --edition 2021 ../hackasm/main.rs -o out/hackasm
rustc --edition 2021 ../hackemu/main.rs -o out/hackemu

# 1. 用我們的編譯器把 8 個 OS 類別與 Main 各編成一個 .vm
rm -f out/*.vm
for f in Array Keyboard Math Memory Output Screen String Sys Main; do
    ./out/jackc "$f.jack" "out/$f.vm"
    if [ ! -s "out/$f.vm" ]; then
        echo "$f.jack 沒有產生內容" >&2
        exit 1
    fi
done

# 2. VM → Hack 組合語言 → 機器碼
./out/vm2asm out out/Program.asm
./out/hackasm out/Program.asm out/Program.hack

# 3. 在 Hack 上執行整個 OS + Main，比對螢幕
./out/hackemu out/Program.hack > out/screen.txt 2> out/stderr.txt
diff -u expected/screen.txt out/screen.txt

echo "os OK"
