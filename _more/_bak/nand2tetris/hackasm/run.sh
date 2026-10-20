#!/bin/sh
set -e
cd "$(dirname "$0")"
mkdir -p out
rustc --edition 2021 main.rs -o out/hackasm
rm -f out/*.hack out/*.err

# 簡單四則運算
./out/hackasm Add.asm out/Add.hack
diff -u expected/Add.hack out/Add.hack

# 變數、標籤、預定義符號
./out/hackasm Symbols.asm out/Symbols.hack
diff -u expected/Symbols.hack out/Symbols.hack

# 壞掉的指令應該要報錯並回傳非 0
if ./out/hackasm bad.asm out/bad.hack 2> out/bad.err; then
    echo "bad.asm 應該要組譯失敗，但成功了" >&2
    exit 1
fi
diff -u expected/bad.err out/bad.err

echo "hackasm OK"
