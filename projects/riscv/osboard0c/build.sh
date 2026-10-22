#!/bin/sh
# 需要：gcc、gcc-riscv64-linux-gnu、e2fsprogs（debugfs、resize2fs）
# 用法：./build.sh   （重新編譯範例、寫入 rootfs、切成網頁用的區塊檔）
set -e
cd "$(dirname "$0")"
IMG=build/root.bin; cp build/root-orig.bin $IMG
truncate -s 8M $IMG; e2fsck -fy $IMG >/dev/null 2>&1 || true; resize2fs $IMG >/dev/null 2>&1
for f in src/[0-9]_*.c; do
  n=$(basename $f .c); n=${n#*_}
  riscv64-linux-gnu-gcc -Os -static -s -Isrc -o build/c_$n $f
  debugfs -w -R "write build/c_$n /bin/c_$n" $IMG >/dev/null
  debugfs -w -R "sif /bin/c_$n mode 0100755" $IMG >/dev/null
done
[ -x build/splitimg ] || gcc -O2 -DCONFIG_VERSION='"2019-02-10"' -o build/splitimg build/splitimg.c
rm -rf root-riscv64; mkdir root-riscv64; build/splitimg $IMG root-riscv64 256
echo done
