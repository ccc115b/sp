#!/bin/bash
# 對照測試: Java 版與 Rust 版 jackc 必須產出逐位元組相同的 .class,錯誤訊息也要一致。
set -e
cd "$(dirname "$0")"

echo "=== 1. 建置 Rust 版與 Java 版 ==="
./build.sh
(cd ../java && ./build.sh)

JAR=../java/jackc.jar
RS=./target/release/jackc
EX=../examples
rm -rf test-out

echo "=== 2. 範例的 .class 逐位元組比對 ==="
same=0
for ex in hello oop sort; do
  mkdir -p "test-out/java-$ex" "test-out/rust-$ex"
  java -jar "$JAR" -d "test-out/java-$ex" "$EX/$ex" 2>/dev/null
  "$RS" -d "test-out/rust-$ex" "$EX/$ex" 2>/dev/null
  for f in test-out/java-$ex/*.class; do
    b=$(basename "$f")
    cmp "$f" "test-out/rust-$ex/$b"
    echo "    identical: $ex/$b"
    same=$((same + 1))
  done
done

echo "=== 3. 壓力用例: 常數池 >256 (ldc_w)、非 BMP 字元、單檔多 class ==="
mkdir -p test-out/big
{
  echo 'class Main {'
  echo '  function void main() {'
  for i in $(seq 0 199); do echo "    do Output.printString(\"s$i 中文 $i\");"; done
  echo '    do Output.printString("😀漢字 tail");'
  echo '    return;'
  echo '  }'
  echo '}'
} > test-out/big/Big.jack
printf 'class A {\n  function int get() { return 7; }\n}\nclass B {\n  function void main() {\n    do Output.printInt(A.get());\n    do Output.println();\n    return;\n  }\n}\n' \
  > test-out/big/Multi.jack
mkdir -p test-out/java-big test-out/rust-big
java -jar "$JAR" -d test-out/java-big test-out/big/Big.jack 2>/dev/null
"$RS" -d test-out/rust-big test-out/big/Big.jack 2>/dev/null
java -jar "$JAR" -d test-out/java-big test-out/big/Multi.jack 2>/dev/null
"$RS" -d test-out/rust-big test-out/big/Multi.jack 2>/dev/null
for f in test-out/java-big/*.class; do
  b=$(basename "$f")
  cmp "$f" "test-out/rust-big/$b"
  echo "    identical: $b"
  same=$((same + 1))
done
echo "  => 共 $same 個 class 檔完全相同"

echo "=== 4. 執行 Rust 版編出的 class ==="
for ex in hello oop sort; do
  echo "--- $ex"
  java -cp "test-out/rust-$ex:runtime:../java/build" Main
done

echo "=== 5. 錯誤訊息比對 (java 與 rust 輸出必須一致) ==="
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
pass=0
diffs=0
check_err() {
  local name=$1 src=$2
  printf '%s' "$src" > "$tmp/$name.jack"
  local j r jr=0 rr=0
  j=$(java -jar "$JAR" -d "$tmp/o" "$tmp/$name.jack" 2>&1) || jr=$?
  r=$("$RS" -d "$tmp/o" "$tmp/$name.jack" 2>&1) || rr=$?
  if [ "$j" = "$r" ] && [ "$jr" = "$rr" ]; then
    echo "    match ($jr): $j"
    pass=$((pass + 1))
  else
    echo "    DIFF $name"
    echo "      java($jr): $j"
    echo "      rust($rr): $r"
    diffs=$((diffs + 1))
  fi
}

check_err type    'class Main { function void main() { var int x; let x = "hi"; return; } }'
check_err undefv  'class Main { function void main() { let y = 1; return; } }'
check_err undefc  'class Main { function void main() { do foo(1); return; } }'
check_err syntax  'class Main { function void main() { let = 3; return; } }'
check_err args    'class Main { function int f(int a) { return a; } function void main() { do Main.f(1,2); return; } }'
check_err voidval 'class Main { function void g() { return; } function void main() { var int x; let x = g(); return; } }'
check_err thisfun 'class Main { field int x; function void main() { let x = 1; return; } }'
check_err arr     'class Main { function void main() { var int a; let a[0] = 1; return; } }'
check_err retvoid 'class Main { function void main() { return 3; } }'
check_err dupvar  'class Main { function void main() { var int x, x; return; } }'
check_err cmpstr  'class Main { function void main() { if (1 = "a") { } return; } }'
check_err illegal 'class Main { function void main() { do @oops(); return; } }'
check_err comment 'class Main { /* unterminated'
check_err string  'class Main { function void main() { do Output.printString("abc
'
check_err toolong 'class Main { function void main() { var int x; let x = 99999999999; return; } }'
check_err dupcls  'class Main { function void main() { return; } }
class Main { }'
echo "  => $pass 個錯誤案例完全一致,$diffs 個不同"

echo "=== 6. --run 冒煙測試 ==="
first=$("$RS" --run "$EX/hello" | head -1)
echo "    $first"

if [ "$diffs" -eq 0 ]; then
  echo "ALL OK: $same class 檔位元組相同、$pass 個錯誤訊息一致"
else
  echo "FAILED: $diffs 個錯誤訊息不同"
  exit 1
fi
