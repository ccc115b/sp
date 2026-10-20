#!/usr/bin/env bash
# 一鍵：編譯 → 單元測試 → 優化所有範例 .ll → （若環境允許）用 llvmlite 驗證語意一致
# 用法： ./test.sh            （在專案根目錄或任何位置執行皆可）
set -euo pipefail
cd "$(dirname "$0")"

step() { printf '\n\033[1;36m==> %s\033[0m\n' "$*"; }
ok()   { printf '\033[1;32m✔ %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m! %s\033[0m\n' "$*"; }

command -v cargo >/dev/null || { echo "找不到 cargo，請先安裝 Rust：https://rustup.rs"; exit 1; }

step "1/5 編譯 (cargo build --release)"
rustc llopt.rs
BIN=./llopt

step "2/5 單元測試 (cargo test)"
rustc --test llopt.rs
./llopt
ok "單元測試通過"

rustc llopt.rs

step "3/5 （選用）用 clang 重新產生 real.ll"
if command -v clang >/dev/null; then
  clang -w -S -emit-llvm -O0 -Xclang -disable-O0-optnone examples/real.c -o examples/real.ll
  ok "已由 examples/real.c 重新產生 examples/real.ll"
else
  warn "沒有 clang，沿用現有的 examples/real.ll"
fi

step "4/5 優化所有範例（輸入 .ll → 輸出 .opt.ll）"
for f in examples/*.ll; do
  case "$f" in *.opt.ll) continue ;; esac
  "$BIN" "$f" "${f%.ll}.opt.ll" 2>&1 | sed 's/^/   /'
done

echo
echo "── examples/demo.opt.ll ──"
cat examples/demo.opt.ll

step "5/5 （選用）用 llvmlite 驗證：IR 合法且執行結果與優化前一致"
if command -v python3 >/dev/null && python3 -c "import llvmlite" 2>/dev/null; then
  python3 verify.py
  python3 verify_real.py
  ok "語意驗證通過"
else
  warn "略過：需要 python3 與 llvmlite（pip install llvmlite）"
fi

printf '\n\033[1;32m全部完成。\033[0m 單檔用法：%s input.ll output.ll [-v]\n' "$BIN"