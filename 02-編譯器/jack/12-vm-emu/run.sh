#!/bin/sh
set -e
cd "$(dirname "$0")"
mkdir -p out

# 編譯器來自 11-modular；rustc 會依 main.rs 的位置去找同名模組
rustc --edition 2021 ../11-modular/main.rs -o out/jackc
rustc --edition 2021 main.rs -o out/jackvm

# Jack → VM，比對產生的 VM 碼
./out/jackc Main.jack out/Main.vm
diff -u expected/Main.vm out/Main.vm

# VM → 執行結果，比對程式輸出
./out/jackvm out/Main.vm > out/out.txt
diff -u expected/out.txt out/out.txt

# 壞掉的 VM 檔應該要報錯並回傳非 0
if ./out/jackvm bad.vm > out/bad.out 2> out/bad.err; then
    echo "bad.vm 應該要執行失敗，但成功了" >&2
    exit 1
fi
diff -u expected/bad.err out/bad.err

echo "12-vm-emu OK"
