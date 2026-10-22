#!/bin/bash
# build rt.ll from rt.c
cd "$(dirname "$0")"
. ./env.sh
clang -O2 -Wno-unused-parameter $CFLAGS_EXTRA -S -emit-llvm rt.c -o rt.ll
echo "built rt.ll with $(command -v clang)"
