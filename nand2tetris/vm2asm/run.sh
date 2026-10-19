#!/bin/sh
set -e
cd "$(dirname "$0")"
mkdir -p out

# 組譯器與模擬器是同一專案的 ../hackasm、../hackemu
rustc --edition 2021 ../hackasm/main.rs -o out/hackasm
rustc --edition 2021 ../hackemu/main.rs -o out/hackemu
rustc --edition 2021 main.rs -o out/vm2asm

# VM → asm → hack → 執行，比對螢幕
./out/vm2asm Draw.vm out/Draw.asm
./out/hackasm out/Draw.asm out/Draw.hack
./out/hackemu out/Draw.hack > out/draw.txt
diff -u expected/draw.txt out/draw.txt

echo "vm2asm OK"
