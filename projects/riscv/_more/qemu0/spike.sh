#!/usr/bin/env bash
# spike.sh — 組譯 foo.s → 連結成 RISC-V 靜態 ELF → 用 spike0 在目前 OS 直接執行
#
# 用法:
#   ./spike.sh foo.s [程式參數...]
#   SPIKE_FLAGS="-s --stat" ./spike.sh foo.s     # 傳選項給 spike0(追蹤 syscall 等)
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="${1:-}"
[[ -n "$SRC" && -f "$SRC" ]] || { echo "用法: $0 foo.s [參數...]" >&2; exit 64; }
shift

CC=""
for p in riscv64-unknown-elf riscv64-elf riscv64-linux-gnu; do
  if command -v "$p-gcc" >/dev/null 2>&1; then CC="$p-gcc"; break; fi
done
[[ -n "$CC" ]] || { echo "找不到 RISC-V 交叉編譯器(例如 sudo apt install gcc-riscv64-unknown-elf)" >&2; exit 1; }

mkdir -p "$ROOT/build"
OUT="$ROOT/build/$(basename "${SRC%.*}")"

echo "[1/3] $CC $(basename "$SRC") -> $(basename "$OUT")" >&2
"$CC" -march=rv64ima -mabi=lp64 -nostdlib -static -no-pie -o "$OUT" "$SRC"

SPIKE0="$ROOT/target/release/spike0"
if [[ ! -x "$SPIKE0" || -n "$(find "$ROOT/src" -newer "$SPIKE0" -name '*.rs' 2>/dev/null)" ]]; then
  echo "[2/3] cargo build --release" >&2
  (cd "$ROOT" && cargo build --release --quiet)
else
  echo "[2/3] spike0 已是最新" >&2
fi

echo "[3/3] spike0 $(basename "$OUT")" >&2
# shellcheck disable=SC2086
exec "$SPIKE0" ${SPIKE_FLAGS:-} "$OUT" "$@"
