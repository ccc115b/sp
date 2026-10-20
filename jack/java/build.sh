#!/bin/sh
# 編譯 jackc 本身(編譯器 + runtime)並打包成 jackc.jar
set -e
cd "$(dirname "$0")"
if command -v javac >/dev/null 2>&1; then JAVAC=javac
else JAVAC="java -m jdk.compiler/com.sun.tools.javac.Main"; fi   # 只有 JRE 沒有 javac 時的替代方式
rm -rf build && mkdir -p build
$JAVAC -d build src/jack/*.java src/jackc/*.java
printf 'Main-Class: jackc.JackCompiler\n' > build/MANIFEST.MF
(cd build && jar cfm ../jackc.jar MANIFEST.MF jack jackc 2>/dev/null) || \
  python3 - <<'PY'
import zipfile, os
with zipfile.ZipFile('jackc.jar','w',zipfile.ZIP_DEFLATED) as z:
    z.writestr('META-INF/MANIFEST.MF','Manifest-Version: 1.0\r\nMain-Class: jackc.JackCompiler\r\n\r\n')
    for root,_,fs in os.walk('build'):
        for f in fs:
            if f.endswith('.class'):
                p=os.path.join(root,f); z.write(p, os.path.relpath(p,'build'))
PY
echo "built jackc.jar"
