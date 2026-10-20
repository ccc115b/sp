#!/bin/bash
# 依序編譯並執行 02-c/ 下所有範例
# 流程：C 程式 -> .s 組語 -> 執行檔 -> spike 模擬執行

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

pass=0
fail=0

for dir in [0-9]*/; do
    dir=${dir%/}
    src=$(find "$dir" -name '*.c' | head -n1)
    [ -z "$src" ] && continue
    base=$(basename "$src" .c)

    echo "=== $dir ==="

    # 1. C -> 組語
    echo "\$ riscv64-unknown-elf-gcc -S $src -o $dir/$base.s"
    if ! riscv64-unknown-elf-gcc -S "$src" -o "$dir/$base.s"; then
        echo "FAIL: C 編譯為組語失敗"
        fail=$((fail + 1))
        echo
        continue
    fi

    # 2. 組語 -> 執行檔
    echo "\$ riscv64-unknown-elf-gcc $dir/$base.s -o $dir/$base"
    if ! riscv64-unknown-elf-gcc "$dir/$base.s" -o "$dir/$base"; then
        echo "FAIL: 組譯／連結失敗"
        fail=$((fail + 1))
        echo
        continue
    fi

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
