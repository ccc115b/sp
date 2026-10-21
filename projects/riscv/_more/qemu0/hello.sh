#!/usr/bin/env bash
# hello.sh — 組譯 hello.s → 連結成 hello (ELF) → 用 qemu0 執行
#
# 用法:
#   ./hello.sh                  # 預設使用 examples/hello.S
#   ./hello.sh path/to/foo.s    # 也可指定其他組語檔
#   ./hello.sh -d               # 額外參數會原樣傳給 qemu0(例如 -d 追蹤指令)
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$ROOT/examples/hello.S"
QEMU_ARGS=()

for a in "$@"; do
  if [[ "$a" != -* && -f "$a" && "${#QEMU_ARGS[@]}" -eq 0 && "$a" =~ \.[sS]$ ]]; then
    SRC="$a"
  else
    QEMU_ARGS+=("$a")
  fi
done
[[ -f "$SRC" ]] || { echo "找不到組語檔: $SRC" >&2; exit 1; }

BUILD="$ROOT/build"
mkdir -p "$BUILD"
OUT="$BUILD/$(basename "${SRC%.*}")"          # hello.s => build/hello

# --- 1. 找 RISC-V 工具鏈 ----------------------------------------------------
CC=""
for p in riscv64-unknown-elf riscv64-elf riscv64-linux-gnu riscv32-unknown-elf; do
  if command -v "$p-gcc" >/dev/null 2>&1; then CC="$p-gcc"; break; fi
done
if [[ -z "$CC" ]]; then
  cat >&2 <<'MSG'
找不到 RISC-V 交叉編譯器,請先安裝其中一種:
  Ubuntu/Debian : sudo apt install gcc-riscv64-unknown-elf
  macOS (brew)  : brew install riscv-gnu-toolchain   (或 brew install riscv64-elf-gcc)
  Arch          : sudo pacman -S riscv64-elf-gcc
MSG
  exit 1
fi

# --- 2. 連結腳本:程式放在 0x80000000(qemu0 的 DRAM 起點)------------------
LD_SCRIPT="$BUILD/qemu0.ld"
cat > "$LD_SCRIPT" <<'LD'
ENTRY(_start)
SECTIONS {
  . = 0x80000000;
  .text   : { *(.text*) }
  .rodata : { *(.rodata*) }
  .data   : { *(.data*) *(.sdata*) }
  .bss    : { *(.bss*) *(.sbss*) *(COMMON) }
  /DISCARD/ : { *(.riscv.attributes) *(.comment) *(.note*) }
}
LD

# --- 3. 組譯 + 連結 ---------------------------------------------------------
echo "[1/3] $CC  $(basename "$SRC") -> $(basename "$OUT")" >&2
"$CC" -march=rv64ima -mabi=lp64 -nostdlib -static -no-pie \
      -T "$LD_SCRIPT" -o "$OUT" "$SRC"

# --- 4. 建置 qemu0(需要時)--------------------------------------------------
QEMU0="$ROOT/target/release/qemu0"
if [[ ! -x "$QEMU0" || -n "$(find "$ROOT/src" -newer "$QEMU0" -name '*.rs' 2>/dev/null)" ]]; then
  echo "[2/3] cargo build --release" >&2
  (cd "$ROOT" && cargo build --release --quiet)
else
  echo "[2/3] qemu0 已是最新" >&2
fi

# --- 5. 執行 ----------------------------------------------------------------
echo "[3/3] qemu0 $(basename "$OUT")" >&2
exec "$QEMU0" "${QEMU_ARGS[@]+"${QEMU_ARGS[@]}"}" "$OUT"
