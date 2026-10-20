#!/bin/bash
# c_examples.sh - 用 C 版 c4.c / vm4.c 編譯並執行 examples/*.c，驗證輸出與預期相符
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
C4C=$BUILD/c4_c
VMC=$BUILD/vm4_c
C4R=$BUILD/c4_rs
VMR=$BUILD/vm4_rs

pass=0; fail=0
ok()   { pass=$((pass+1)); printf '  [PASS] %s\n' "$1"; }
bad()  { fail=$((fail+1)); printf '  [FAIL] %s\n' "$1"; }

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

# exec_example <vm> <bc> <src> <name> <tag>
exec_example() {
  local vm=$1 bc=$2 src=$3 name=$4 tag=$5
  local args want out rc
  args=$(get_args "$src")
  want=$(get_exit "$src")
  out=$BUILD/$name$tag.out
  # shellcheck disable=SC2086
  "$vm" "$bc" $args > "$out" 2>&1
  rc=$?
  if [ "$rc" != "$want" ]; then
    bad "$name$tag (exit code $rc, want $want)"
    return 1
  fi
  if diff -u "$BUILD/$name$tag.exp" "$out" > "$BUILD/$name$tag.diff" 2>&1; then
    ok "$name$tag"
  else
    bad "$name$tag (output mismatch)"
    sed 's/^/         /' "$BUILD/$name$tag.diff"
  fi
  if [ "$name" = fileio ]; then
    if cmp -s "$BUILD/fileio-src.txt" "$BUILD/fileio-out.txt"; then
      ok "fileio$tag copy identical (7000 bytes)"
    else
      bad "fileio$tag copied file differs from source"
    fi
  fi
  return 0
}

echo "=== 1. gcc 編譯 c4.c 與 vm4.c ==="
gcc -Wno-everything c4.c -o "$C4C" || exit 1
gcc -Wno-everything vm4.c -o "$VMC" || exit 1
echo "  => $C4C / $VMC"

echo "=== 2. 自我編譯檢查 (c4.c 自己編譯自己，vm4.c 執行後 bytecode 必須一致) ==="
"$C4C" c4.c $BUILD/c4_s1.bc || exit 1
"$VMC" $BUILD/c4_s1.bc c4.c $BUILD/c4_s2.bc || exit 1
if cmp -s $BUILD/c4_s1.bc $BUILD/c4_s2.bc; then
  ok "self-compile: c4_s1.bc == c4_s2.bc"
else
  bad "self-compile bytecode mismatch"
fi

echo "=== 3. 用 C 版編譯器+VM 執行 examples/*.c ==="
# 產生 fileio 測試檔: "hello, c4 VM!\n" (14 bytes) x 500 = 7000 bytes
printf 'hello, c4 VM!\n%.0s' $(seq 1 500) > $BUILD/fileio-src.txt

for src in examples/*.c; do
  name=$(basename "$src" .c)
  get_expect "$src" "$BUILD/$name.exp"
  if ! "$C4C" "$src" "$BUILD/$name.bc" > "$BUILD/$name.log" 2>&1; then
    bad "$name (c4.c compile error)"
    sed 's/^/         /' "$BUILD/$name.log"
    continue
  fi
  exec_example "$VMC" "$BUILD/$name.bc" "$src" "$name" ""
done

echo "=== 4. 交叉驗證 Rust 版 c4.rs / vm4.rs ==="
if command -v rustc > /dev/null 2>&1; then
  rustc c4.rs -o "$C4R" || exit 1
  rustc vm4.rs -o "$VMR" || exit 1

  # 自我編譯：Rust 編譯器編譯 c4.c 的 bytecode 必須與 C 編譯器一致
  "$C4R" c4.c $BUILD/c4_rs1.bc || exit 1
  if cmp -s $BUILD/c4_s1.bc $BUILD/c4_rs1.bc; then
    ok "c4.rs bytecode == c4.c bytecode (c4.c)"
  else
    bad "c4.rs vs c4.c bytecode mismatch (c4.c)"
  fi

  for src in examples/*.c; do
    name=$(basename "$src" .c)
    # Rust 編譯器產出的 bytecode 必須與 C 編譯器逐位元相同
    if ! "$C4R" "$src" "$BUILD/$name.rs.bc" > "$BUILD/$name.rs.log" 2>&1; then
      bad "$name.rs (c4.rs compile error)"
      sed 's/^/         /' "$BUILD/$name.rs.log"
      continue
    fi
    if cmp -s "$BUILD/$name.bc" "$BUILD/$name.rs.bc"; then
      ok "$name bytecode c4.rs == c4.c"
    else
      bad "$name bytecode c4.rs != c4.c"
    fi
    # Rust VM 執行同一份 bytecode，輸出必須與 C VM 一致
    get_expect "$src" "$BUILD/$name.rs.exp"
    exec_example "$VMR" "$BUILD/$name.bc" "$src" "$name" ".rs"
  done
else
  echo "  (找不到 rustc，跳過交叉驗證)"
fi

echo
echo "結果: pass=$pass fail=$fail"
if [ "$fail" -ne 0 ]; then exit 1; fi
exit 0
