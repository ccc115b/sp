#!/bin/bash
# ll_examples.sh - 用 c4ll.rs 把 examples/*.c 編譯成 LLVM IR (.ll)，再用 lli 執行並驗證輸出
#
# 範例檔慣例（寫在 examples/*.c 的註解裡）：
#   // expect: <該行預期輸出>   (可多行；無參數的 "// expect:" 代表輸出空行)
#   // args:   <執行時參數>      (可省略)
#   // exit:   <預期 exit code>  (可省略，預設 0)
# 注意：c4 的 printf 只支援 format + 5 個參數
set -u
cd "$(dirname "$0")"

BUILD=build
mkdir -p "$BUILD"
C4LL=$BUILD/c4_ll

pass=0; fail=0
ok()   { pass=$((pass+1)); printf '  [PASS] %s\n' "$1"; }
bad()  { fail=$((fail+1)); printf '  [FAIL] %s\n' "$1"; }

# 找 lli
LLI=""
for c in "$(command -v lli 2>/dev/null)" /opt/homebrew/opt/llvm/bin/lli /usr/local/opt/llvm/bin/lli /usr/bin/lli; do
  if [ -n "$c" ] && [ -x "$c" ]; then LLI="$c"; break; fi
done
if [ -z "$LLI" ]; then
  echo "error: 找不到 lli (LLVM)，請先安裝 LLVM" >&2
  exit 1
fi

get_expect() {
  local src=$1 out=$2 line
  : > "$out"
  while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in
      "// expect: "*) printf '%s\n' "${line#// expect: }" >> "$out";;
      "// expect:")   printf '\n' >> "$out";;
    esac
  done < "$src"
}

get_args() {
  local src=$1 line
  while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in
      "// args: "*) printf '%s' "${line#// args: }"; return 0;;
    esac
  done < "$src"
  return 0
}

get_exit() {
  local src=$1 line
  while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in
      "// exit: "*) printf '%s' "${line#// exit: }"; return 0;;
    esac
  done < "$src"
  printf '0'
}

echo "=== 1. rustc 編譯 c4ll.rs (c4 前端 -> LLVM IR 後端) ==="
rustc c4ll.rs -o "$C4LL" || exit 1
echo "  => $C4LL (LLVM IR 編譯器)"
echo "  => $LLI ($("$LLI" --version 2>/dev/null | head -1))"

echo "=== 2. 產生 fileio 測試檔 ==="
printf 'hello, c4 VM!\n%.0s' $(seq 1 500) > $BUILD/fileio-src.txt

echo "=== 3. 編譯成 .ll 並用 lli 執行 examples/*.c ==="
for src in examples/*.c; do
  name=$(basename "$src" .c)
  ll=$BUILD/$name.ll
  out=$BUILD/$name.ll.out
  get_expect "$src" "$BUILD/$name.exp"
  args=$(get_args "$src")
  want=$(get_exit "$src")

  if ! "$C4LL" "$src" -o "$ll" > "$BUILD/$name.ll.log" 2>&1; then
    bad "$name (c4ll compile error)"
    sed 's/^/         /' "$BUILD/$name.ll.log"
    continue
  fi

  # shellcheck disable=SC2086
  "$LLI" "$ll" $args > "$out" 2>&1
  rc=$?

  if [ "$rc" != "$want" ]; then
    bad "$name (exit code $rc, want $want)"
    sed 's/^/         /' "$out" | head -5
    continue
  fi
  if diff -u "$BUILD/$name.exp" "$out" > "$BUILD/$name.ll.diff" 2>&1; then
    ok "$name ($name.ll + lli)"
  else
    bad "$name (output mismatch)"
    sed 's/^/         /' "$BUILD/$name.ll.diff"
  fi
  if [ "$name" = fileio ]; then
    if cmp -s "$BUILD/fileio-src.txt" "$BUILD/fileio-out.txt"; then
      ok "fileio copy identical (7000 bytes)"
    else
      bad "fileio copied file differs from source"
    fi
  fi
done

echo
echo "結果: pass=$pass fail=$fail"
if [ "$fail" -ne 0 ]; then exit 1; fi
exit 0
