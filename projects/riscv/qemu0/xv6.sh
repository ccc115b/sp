#!/usr/bin/env bash
# xv6.sh — 取得 xv6-riscv、編譯,並在 qemu0 上開機
#
# 用法:
#   ./xv6.sh                 # 互動式 shell(按 Ctrl-A 再按 x 結束)
#   ./xv6.sh --build-only    # 只編譯不執行
#   XV6_DIR=~/xv6-riscv ./xv6.sh     # 使用既有的 xv6 原始碼目錄
#   XV6_KEEP_DISK=1 ./xv6.sh         # 保留上次對磁碟映像的修改(預設每次都用乾淨的 fs.img)
#
# 需要:git、make、主機 gcc(編 mkfs)、RISC-V 交叉編譯器、cargo。
# xv6 以它預設的 -march=rv64gc 直接編譯即可:qemu0 支援 C(壓縮指令);
# xv6 核心不使用浮點指令,所以沒有 F/D 也能運作。
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
XV6="${XV6_DIR:-$ROOT/build/xv6-riscv}"
BUILD="$ROOT/build"
mkdir -p "$BUILD"

PFX=""
for p in riscv64-unknown-elf- riscv64-elf- riscv64-linux-gnu-; do
  if command -v "${p}gcc" >/dev/null 2>&1; then PFX="$p"; break; fi
done
[[ -n "$PFX" ]] || { echo "找不到 RISC-V 交叉編譯器(例如 sudo apt install gcc-riscv64-unknown-elf)" >&2; exit 1; }

if [[ ! -d "$XV6" ]]; then
  echo "[1/4] git clone xv6-riscv" >&2
  git clone --depth 1 https://github.com/mit-pdos/xv6-riscv "$XV6" >&2
else
  echo "[1/4] 使用 $XV6" >&2
fi

echo "[2/4] 編譯 xv6(預設 rv64gc)" >&2
make -C "$XV6" TOOLPREFIX="$PFX" kernel/kernel fs.img >/dev/null 2> >(grep -v "qemu-system" >&2)

QEMU0="$ROOT/target/release/qemu0"
if [[ ! -x "$QEMU0" || -n "$(find "$ROOT/src" -newer "$QEMU0" -name '*.rs' 2>/dev/null)" ]]; then
  echo "[3/4] cargo build --release" >&2
  (cd "$ROOT" && cargo build --release --quiet)
else
  echo "[3/4] qemu0 已是最新" >&2
fi
[[ "${1:-}" == "--build-only" ]] && exit 0

DISK="$BUILD/xv6-fs.img"
if [[ ! -f "$DISK" || -z "${XV6_KEEP_DISK:-}" ]]; then
  cp "$XV6/fs.img" "$DISK"
fi

echo "[4/4] 開機(約 10 秒;Ctrl-A x 結束)" >&2
if [[ -t 0 ]]; then
  # 讓按鍵逐字送進 xv6:關閉行緩衝、本機回顯與訊號鍵
  saved="$(stty -g)"
  trap 'stty "$saved"' EXIT
  stty -icanon -echo -isig
fi
"$QEMU0" --disk "$DISK" "$XV6/kernel/kernel"
