#!/usr/bin/env bash
# 依序跑 01 ~ 12 的 run.sh（各自 rustc 編譯並和 expected/ 比對）。
#
#   ./run_all.sh          跑全部
#   ./run_all.sh 07       只跑 07-strings
#   ./run_all.sh 1        跑 10 / 11 / 12

set -u
cd "$(dirname "$0")"

FILTER="${1:-}"
fail=0
count=0

for dir in [0-9][0-9]-*/; do
  dir="${dir%/}"
  [[ -n "$FILTER" && "$dir" != "$FILTER"* ]] && continue

  printf '==> %s\n' "$dir"
  if ! "./$dir/run.sh"; then
    echo "    $dir 失敗"
    fail=1
  fi
  count=$((count + 1))
done

if [[ "$count" -eq 0 ]]; then
  echo "找不到符合「$FILTER」的版本（例如：./run_all.sh 07）"
  exit 2
fi

[[ $fail -ne 0 ]] && { echo "有版本失敗"; exit 1; }
echo "全部通過（共 $count 版）。"
