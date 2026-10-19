#!/usr/bin/env bash
# 一次編譯（並執行）所有 Rust 範例，只用 rustc，不需要 cargo。
#
#   ./run_all.sh          編譯 + 執行全部
#   ./run_all.sh 05       只編譯 + 執行 05 課
#   ./run_all.sh build    只編譯，不執行

set -u
cd "$(dirname "$0")"

EDITION=2021
BIN=bin
mkdir -p "$BIN"

# 「課別 直入檔」對照表（18 課是多檔案，入口是 main.rs）
LESSONS=(
  "01:01/hello.rs"
  "02:02/variables.rs"
  "03:03/types.rs"
  "04:04/control_flow.rs"
  "05:05/loops.rs"
  "06:06/functions.rs"
  "07:07/ownership.rs"
  "08:08/references.rs"
  "09:09/slices.rs"
  "10:10/structs.rs"
  "11:11/enums_match.rs"
  "12:12/error_handling.rs"
  "13:13/collections.rs"
  "14:14/iterators.rs"
  "15:15/closures.rs"
  "16:16/generics_traits.rs"
  "17:17/lifetimes.rs"
  "18:18/main.rs"
  "19:19/file_io.rs"
  "20:20/textstats.rs"
)

MODE=run
FILTER=""
case "${1:-}" in
  "") ;;
  build) MODE=build ;;
  *) FILTER="$1" ;;
esac

fail=0
compiled=0

for entry in "${LESSONS[@]}"; do
  num="${entry%%:*}"
  src="${entry#*:}"
  [[ -n "$FILTER" && "$num" != "$FILTER"* ]] && continue

  name="$(basename "$src" .rs)"
  out="$BIN/$num-$name"

  printf '==> 編譯 %s\n' "$src"
  if ! rustc --edition "$EDITION" "$src" -o "$out"; then
    echo "    編譯失敗：$src"
    fail=1
    continue
  fi
  compiled=$((compiled + 1))

  [[ "$MODE" == "build" ]] && continue

  printf '==> 執行 %s\n' "$out"
  if [[ "$num" == "19" ]]; then
    # 第 19 課會等待 stdin，餵一行示範輸入
    echo "小明" | "$out" || fail=1
  elif [[ "$num" == "20" ]]; then
    "$out" "$src" || fail=1
  else
    "$out" || fail=1
  fi
  echo
done

if [[ "$compiled" -eq 0 ]]; then
  echo "找不到符合「$FILTER」的課程（例如：./run_all.sh 05）"
  exit 2
fi

[[ $fail -ne 0 ]] && { echo "有課程失敗了"; exit 1; }
echo "全部完成（共 $compiled 個）。執行檔在 $BIN/ 資料夾。"
