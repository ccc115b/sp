# Shared environment detection for build.sh / selftest.sh (Linux + macOS).
# Override with:  LLVM_BIN=/path/to/llvm/bin  SDK=/path/to/MacOSX.sdk
if [ -z "$LLVM_BIN" ]; then
  for d in "$(command -v brew >/dev/null 2>&1 && brew --prefix llvm 2>/dev/null)/bin" \
           /opt/homebrew/opt/llvm/bin /usr/local/opt/llvm/bin \
           /usr/lib/llvm-18/bin /usr/lib/llvm-17/bin /usr/lib/llvm-16/bin; do
    if [ -x "$d/lli" ]; then LLVM_BIN="$d"; break; fi
  done
fi
[ -n "$LLVM_BIN" ] && export PATH="$LLVM_BIN:$PATH"
command -v lli >/dev/null 2>&1 || { echo "error: lli not found. macOS: brew install llvm   Ubuntu: apt install llvm-18 clang-18" >&2; exit 1; }

# On macOS, find a usable SDK (the default one may point at a missing directory).
CFLAGS_EXTRA=""
if [ "$(uname)" = "Darwin" ]; then
  if [ -z "$SDK" ]; then
    for c in "$(env -u SDKROOT xcrun --show-sdk-path 2>/dev/null)" \
             /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk \
             $(ls -d /Library/Developer/CommandLineTools/SDKs/MacOSX*.sdk 2>/dev/null | sort -r) \
             /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk; do
      if [ -n "$c" ] && [ -f "$c/usr/include/stdio.h" ]; then SDK="$c"; break; fi
    done
  fi
  if [ -z "$SDK" ]; then
    echo "error: no usable macOS SDK found (stdio.h missing)." >&2
    echo "  fix: xcode-select --install   (or reinstall: sudo rm -rf /Library/Developer/CommandLineTools && xcode-select --install)" >&2
    exit 1
  fi
  unset SDKROOT
  CFLAGS_EXTRA="-isysroot $SDK"
fi
