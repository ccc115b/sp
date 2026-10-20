## ccc: 有什麼工具可以將 .ll 檔轉為組合語言？

Claude:

最常用的是 LLVM 自帶的 **`llc`**，它專門把 `.ll` 編成目標平台的組合語言。

## 主要工具

**1. `llc`（LLVM 靜態編譯器）**
```bash
llc input.ll -o output.s                    # 輸出組合語言（.s）
llc -O2 input.ll -o output.s                # 指定優化等級（0~3）
llc -x86-asm-syntax=intel input.ll -o out.s # Intel 語法（預設是 AT&T）
llc -mtriple=aarch64-linux-gnu input.ll     # 交叉編譯到其他架構（如 ARM64）
llc -filetype=obj input.ll -o out.o         # 直接輸出目的檔
```

**2. `clang`（可以直接吃 `.ll`）**
```bash
clang -S input.ll -o output.s
clang -S -masm=intel input.ll -o output.s   # Intel 語法
clang input.ll -o a.out                      # 一路編譯並連結成可執行檔
```
我用這個方式實際編譯了 `demo.opt.ll`，得到 x86 組合語言，其中 `compute` 函式只剩下 5 條指令：

```asm
mov eax, edi
shl eax, 3
add eax, eax
shr eax, 2
add eax, 5
ret
```

## 相關工具

| 工具 | 用途 |
|---|---|
| `lli` | 不產生檔案，直接解譯或 JIT 執行 `.ll` |
| `opt` | 用 LLVM 官方的優化 pass 處理 `.ll`，可拿來和 `llopt` 的結果比較，例如 `opt -O2 -S in.ll -o out.ll` |
| `llvm-as` / `llvm-dis` | `.ll` 與二進位的 bitcode（`.bc`）互轉 |
| [Compiler Explorer (godbolt.org)](https://godbolt.org) | 線上工具，語言選 "LLVM IR"，可即時看到各架構的組合語言 |
| Python `llvmlite` | 在程式中呼叫 LLVM，`target_machine.emit_assembly(module)` 可取得組合語言字串 |

## 安裝

```bash
sudo apt install llvm clang      # Ubuntu / Debian
brew install llvm                # macOS（可執行檔在 $(brew --prefix llvm)/bin）
```

在 Ubuntu 上 `llc` 可能帶版本號（例如 `llc-18`）。要注意 `.ll` 檔和 `llc` 的版本最好接近，否則新版 IR 語法可能無法被舊版解析。

## 搭配 llopt 的完整流程

```bash
./target/release/llopt input.ll optimized.ll   # 先用我們的優化器
llc -O0 optimized.ll -o optimized.s            # -O0 才能看出是 llopt 的效果，不是 llc 又優化了一次
```

`llc` 預設是 `-O2`，它自己的指令選擇與暫存器配置也會再優化一次，所以要觀察 `llopt` 本身的成果，建議加上 `-O0`。