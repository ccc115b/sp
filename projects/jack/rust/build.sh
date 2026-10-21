#!/bin/sh
# 建置 Rust 版 jackc,並編譯 Java runtime 類別(只有 --run 用得到)
set -e
cd "$(dirname "$0")"
cargo build --release
if command -v javac >/dev/null 2>&1; then
  rm -rf runtime && mkdir -p runtime
  javac -d runtime ../java/src/jack/*.java
  echo "built runtime classes -> runtime/"
else
  echo "note: javac not found; --run 會改用 ../java/build 或 ../java/jackc.jar"
fi
echo "built target/release/jackc"
