#!/bin/bash
# 依序編譯並執行 03-rust/ 下所有範例
# 流程：Rust 程式 -> .s 組語 -> 執行檔 -> spike 模擬執行
#
# 與 02-c 的差別：
#   - 02-c 用 riscv64-unknown-elf-gcc 編譯 C（含 newlib printf）
#   - 03-rust 用 rustc 編譯 no_std 裸機程式，自己呼叫 pk 的 write/exit
#     系統呼叫輸出，再交給 riscv64-unknown-elf-gcc 組譯／連結

# Homebrew 安裝的 pk 不在預設 PATH 中，先找出來
if ! command -v pk >/dev/null 2>&1; then
    PK_BIN=$(find /opt/homebrew/Cellar/riscv-pk -type f -name pk 2>/dev/null | head -n1)
    if [ -n "$PK_BIN" ]; then
        export PATH="$(dirname "$PK_BIN"):$PATH"
    else
        echo "錯誤：找不到 pk (proxy kernel)，請先安裝 riscv-pk" >&2
        exit 1
    fi
fi

# rustc 需要已安裝 riscv64 裸機目標
TARGET=riscv64gc-unknown-none-elf
if ! rustc --print target-list 2>/dev/null | grep -qx "$TARGET"; then
    echo "錯誤：找不到 Rust 目標 $TARGET" >&2
    echo "請執行：rustup target add $TARGET" >&2
    exit 1
fi

pass=0
fail=0

for dir in [0-9]*/; do
    dir=${dir%/}
    src=$(find "$dir" -maxdepth 1 -name '*.rs' | head -n1)
    [ -z "$src" ] && continue
    base=$(basename "$src" .rs)

    echo "=== $dir ==="

    # 1. Rust -> 組語
    echo "\$ rustc --emit asm --target $TARGET $src -o $dir/$base.s"
    if ! rustc --emit asm -O --cap-lints allow --target "$TARGET" "$src" -o "$dir/$base.s" 2>/dev/null; then
        echo "FAIL: Rust 編譯為組語失敗"
        fail=$((fail + 1))
        echo
        continue
    fi

    # rustc 會在 .s 開頭寫入 .attribute，其中 zaamo/zalrsc 等名稱
    # 這個版本的 GNU as 不認得，先濾掉再交給 gcc 組譯
    sed '/^[[:space:]]*\.attribute/d' "$dir/$base.s" > "$dir/$base.clean.s"

    # 2. 組語 -> 執行檔（-nostdlib：不連結 libc/crt，用我們自己的 _start）
    echo "\$ riscv64-unknown-elf-gcc -nostdlib $dir/$base.clean.s -o $dir/$base"
    if ! riscv64-unknown-elf-gcc -nostdlib "$dir/$base.clean.s" -o "$dir/$base"; then
        echo "FAIL: 組譯／連結失敗"
        fail=$((fail + 1))
        echo
        continue
    fi
    rm -f "$dir/$base.clean.s"

    # 3. spike 執行
    echo "\$ spike pk $dir/$base"
    spike pk "$dir/$base"
    rc=$?
    echo "-> exit code: $rc"

    if [ $rc -eq 0 ]; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi
    echo
done

echo "=============================="
echo "通過: $pass  失敗: $fail"
[ $fail -eq 0 ]
