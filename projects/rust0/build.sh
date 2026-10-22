#!/bin/bash
# Build the rust0 toolchain:
#   rt.ll   : runtime compiled by clang (contains main -> r0fn_main)
#   rt0.o   : same runtime without main (linked into the rustc-hosted stage0)
#   r0c     : stage0 compiler = rust0.rs compiled by the host rustc + rt0.o
set -e
cd "$(dirname "$0")"
. ./env.sh

echo "== rt.c -> rt.o (lli) + rt0.o (rustc link)"
clang -O1 -Wno-override-module $CFLAGS_EXTRA -S -emit-llvm rt.c -o rt.ll
clang -O1 -DR0_NO_MAIN $CFLAGS_EXTRA -c rt.c -o rt0.o

echo "== stage0: host rustc compiles rust0.rs + rt0.o"
rustc --edition=2015 -A warnings rust0.rs -C link-arg=rt0.o -o r0c
echo "built $(ls -ld r0c | awk '{print $NF}')"
