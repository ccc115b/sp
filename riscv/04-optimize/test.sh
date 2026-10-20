#!/bin/bash
# 04-optimize：示範 LLVM 優化的完整流程
#
# 每個範例目錄同時有 C 與 Rust 版本，走同一條 LLVM 後端管線：
#
#   C      : clang  -S -emit-llvm -O0  ->  *.c.O0.ll   ─┐
#                       -O2             ->  *.c.O2.ll    ├─ opt -S -O2 -> *.opt.ll
#   Rust   : rustc  --emit llvm-ir -O   ->  *.rs.ll    ─┘
#
#   *.opt.ll --llc--> *.s --gcc--> 執行檔 --spike pk--> 執行結果
#
# 為了觀察差異，會同時產生 -O0 與 -O2 的 IR，並印出兩者的行數對照。
#
# 用法：./test.sh            # 全部範例
#       ./test.sh 01-constfold # 只跑某個目錄
#       VERBOSE=1 ./test.sh    # 另外印出優化後的 .ll / .s 片段

set -u

# ---- 找工具 --------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Homebrew LLVM（clang / opt / llc / llvm-dis）優先使用
LLVM_BIN="${LLVM_BIN:-/opt/homebrew/opt/llvm/bin}"
if [ ! -x "$LLVM_BIN/clang" ]; then
    LLVM_BIN="$(dirname "$(command -v clang)")"
fi
CLANG="$LLVM_BIN/clang"
OPT="$LLVM_BIN/opt"
LLC="$LLVM_BIN/llc"
LLVM_DIS="$LLVM_BIN/llvm-dis"

for t in "$CLANG" "$OPT" "$LLC"; do
    if [ ! -x "$t" ]; then
        echo "錯誤：找不到 $(basename "$t")，請設定 LLVM_BIN 指向 LLVM bin 目錄" >&2
        exit 1
    fi
done

# pk（proxy kernel）不在預設 PATH 中，先找出來
if ! command -v pk >/dev/null 2>&1; then
    PK_BIN=$(find /opt/homebrew/Cellar/riscv-pk -type f -name pk 2>/dev/null | head -n1)
    if [ -n "$PK_BIN" ]; then
        export PATH="$(dirname "$PK_BIN"):$PATH"
    else
        echo "錯誤：找不到 pk (proxy kernel)，請先安裝 riscv-pk" >&2
        exit 1
    fi
fi

TARGET=riscv64-unknown-elf
RUST_TARGET=riscv64gc-unknown-none-elf
# llc 的 -mattr：RV64GC = I M A F D C，對應 clang 的 -march=rv64gc
MATTR=+m,+a,+f,+d,+c

# 過濾掉 GCC 13 的 assembler 不認得的指示（新版 LLVM 才會產生）
clean_asm() {
    grep -v -E '^[[:space:]]*\.(attribute|option)' "$1" > "$2"
}

pass=0
fail=0

# ---- 單一 IR 檔 -> 執行檔 -> 執行 --------------------------------------
# $1 = .ll 檔   $2 = 輸出 base（不含副檔名）
build_and_run() {
    local ll="$1" out="$2"
    # opt：在中介表示上做機器無關優化
    if ! "$OPT" -S -O2 -mtriple="$TARGET" "$ll" -o "$out.opt.ll" 2>/dev/null; then
        echo "FAIL: opt 失敗 ($ll)"
        return 1
    fi
    # llc：機器無關 IR -> RISC-V 組語
    if ! "$LLC" -O2 -mattr="$MATTR" "$out.opt.ll" -o "$out.s" 2>/dev/null; then
        echo "FAIL: llc 失敗 ($ll)"
        return 1
    fi
    clean_asm "$out.s" "$out.clean.s"
    # gcc：組譯 + 連結（-nostdlib，用範例自己的 _start）
    if ! riscv64-unknown-elf-gcc -nostdlib "$out.clean.s" -o "$out" 2>/dev/null; then
        echo "FAIL: 組譯／連結失敗 ($ll)"
        return 1
    fi
    rm -f "$out.clean.s"
    # spike：執行
    spike pk "$out"
    return $?
}

# ---- 決定要處理的目錄 ---------------------------------------------------
# 命令列有給目錄就只跑那些，否則掃描所有數字開頭的目錄
if [ $# -gt 0 ]; then
    DIRS=("$@")
else
    DIRS=()
    for d in [0-9]*/; do
        d=${d%/}
        [ -d "$d" ] && DIRS+=("$d")
    done
fi

# ---- 逐目錄處理 ---------------------------------------------------------
for dir in "${DIRS[@]+"${DIRS[@]}"}"; do
    # 若目錄下沒有 .c 或 .rs，跳過
    has_c=$(find "$dir" -maxdepth 1 -name '*.c' | head -n1)
    has_rs=$(find "$dir" -maxdepth 1 -name '*.rs' | head -n1)
    [ -z "$has_c" ] && [ -z "$has_rs" ] && continue

    echo "==================================================================="
    echo "### $dir"
    echo "==================================================================="

    # ---------- C 版 ----------
    if [ -n "$has_c" ]; then
        csrc="$has_c"
        cbase=$(basename "$csrc" .c)
        out="$dir/$cbase"

        echo "--- [C]  $csrc ---"
        echo "\$ clang --target=$TARGET -march=rv64gc -S -emit-llvm -O0 $csrc -o $dir/$cbase.O0.ll"
        "$CLANG" --target="$TARGET" -march=rv64gc -S -emit-llvm -O0 -ffreestanding -fno-builtin "$csrc" -o "$dir/$cbase.O0.ll" 2>/dev/null
        echo "\$ clang --target=$TARGET -march=rv64gc -S -emit-llvm -O2 $csrc -o $dir/$cbase.O2.ll"
        "$CLANG" --target="$TARGET" -march=rv64gc -S -emit-llvm -O2 -ffreestanding -fno-builtin "$csrc" -o "$dir/$cbase.O2.ll" 2>/dev/null

        o0_lines=$(wc -l < "$dir/$cbase.O0.ll" | tr -d ' ')
        o2_lines=$(wc -l < "$dir/$cbase.O2.ll" | tr -d ' ')
        echo "    IR 行數：-O0 = $o0_lines 行，-O2 = $o2_lines 行"

        if [ "${VERBOSE:-0}" = "1" ]; then
            echo "    ---- -O0 IR（前 40 行）----"
            sed -n '1,40p' "$dir/$cbase.O0.ll"
            echo "    ---- -O2 IR（前 40 行）----"
            sed -n '1,40p' "$dir/$cbase.O2.ll"
        fi

        echo "\$ opt -S -O2 $dir/$cbase.O2.ll -o $dir/$cbase.opt.ll"
        echo "\$ llc -O2 $dir/$cbase.opt.ll -o $dir/$cbase.s"
        echo "\$ riscv64-unknown-elf-gcc -nostdlib $dir/$cbase.s -o $out"
        echo "\$ spike pk $out"
        if build_and_run "$dir/$cbase.O2.ll" "$out"; then
            echo "-> C   exit code: 0"
            pass=$((pass + 1))
        else
            echo "-> C   FAIL"
            fail=$((fail + 1))
        fi
        echo
    fi

    # ---------- Rust 版 ----------
    if [ -n "$has_rs" ]; then
        rsrc="$has_rs"
        rbase=$(basename "$rsrc" .rs)
        out="$dir/$rbase"

        echo "--- [Rust]  $rsrc ---"
        echo "\$ rustc --emit llvm-ir -O --target=$RUST_TARGET $rsrc -o $dir/$rbase.ll"
        if rustc --emit llvm-ir -O --cap-lints allow --target "$RUST_TARGET" "$rsrc" -o "$dir/$rbase.ll" 2>/dev/null; then
            rlines=$(wc -l < "$dir/$rbase.ll" | tr -d ' ')
            echo "    IR 行數（-O）：$rlines 行"

            if [ "${VERBOSE:-0}" = "1" ]; then
                echo "    ---- Rust IR（前 40 行）----"
                sed -n '1,40p' "$dir/$rbase.ll"
            fi

            echo "\$ opt -S -O2 $dir/$rbase.ll -o $dir/$rbase.opt.ll"
            echo "\$ llc -O2 $dir/$rbase.opt.ll -o $dir/$rbase.s"
            echo "\$ riscv64-unknown-elf-gcc -nostdlib $dir/$rbase.s -o $out"
            echo "\$ spike pk $out"
            if build_and_run "$dir/$rbase.ll" "$out"; then
                echo "-> Rust exit code: 0"
                pass=$((pass + 1))
            else
                echo "-> Rust FAIL"
                fail=$((fail + 1))
            fi
        else
            echo "FAIL: rustc 產生 IR 失敗"
            fail=$((fail + 1))
        fi
        echo
    fi
done

echo "==================================================================="
echo "通過: $pass  失敗: $fail"
[ $fail -eq 0 ]
