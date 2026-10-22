#!/bin/bash
# Full bootstrap + regression test for py2ll.
#   stage0: CPython runs py2ll.py            -> compiles py2ll.py  => stage1.ll
#   stage1: lli runs stage1.ll (the compiler) -> compiles py2ll.py  => stage2.ll
#   stage2: lli runs stage2.ll               -> compiles py2ll.py  => stage3.ll
# Success = stage1.ll == stage2.ll == stage3.ll (fixed point) and every test
# program compiled by the lli-hosted compiler prints exactly what CPython prints.
set -e
cd "$(dirname "$0")"
. ./env.sh
W=${TMPDIR:-/tmp}/py2ll_build; mkdir -p $W

echo "== build runtime (rt.c -> rt.ll)"; ./build.sh
LLI="lli -O0 -extra-module=rt.ll"

echo "== stage0: CPython -> stage1.ll"
python3 py2ll.py py2ll.py -o $W/stage1.ll
llvm-as $W/stage1.ll -o /dev/null && echo "   stage1.ll passes the LLVM verifier ($(wc -l < $W/stage1.ll) lines)"

echo "== stage1: lli(stage1.ll) compiles py2ll.py -> stage2.ll"
$LLI $W/stage1.ll py2ll.py -o $W/stage2.ll
echo "== stage2: lli(stage2.ll) compiles py2ll.py -> stage3.ll"
$LLI $W/stage2.ll py2ll.py -o $W/stage3.ll
cmp $W/stage1.ll $W/stage2.ll && cmp $W/stage2.ll $W/stage3.ll && echo "   FIXED POINT: stage1 == stage2 == stage3"

echo "== regression tests (compiler hosted by lli)"
fail=0
for t in tests/t*.py; do
  n=$(basename $t .py)
  python3 $t > $W/$n.exp 2>/dev/null || true
  $LLI $W/stage2.ll $t -o $W/$n.ll
  lli -extra-module=rt.ll $W/$n.ll > $W/$n.out 2>/dev/null || true
  if cmp -s $W/$n.exp $W/$n.out; then echo "   PASS $n"; else echo "   FAIL $n"; fail=1; fi
done
exit $fail
