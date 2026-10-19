#!/bin/sh
set -e
cd "$(dirname "$0")"
mkdir -p out

# 組譯器是同一專案的 ../hackasm
rustc --edition 2021 ../hackasm/main.rs -o out/hackasm
rustc --edition 2021 main.rs -o out/hackemu

# 畫黑塊：3 列 x 48 個 '#'
./out/hackasm Draw.asm out/Draw.hack
./out/hackemu out/Draw.hack > out/draw.txt
diff -u expected/draw.txt out/draw.txt

# 有按鍵：第一列 16 個 '#'
./out/hackasm Key.asm out/Key.hack
KEYS=65 ./out/hackemu out/Key.hack > out/key.txt
diff -u expected/key.txt out/key.txt

# 沒按鍵：螢幕空白（輸出為空）
./out/hackemu out/Key.hack > out/nokey.txt
diff -u expected/nokey.txt out/nokey.txt

echo "hackemu OK"
