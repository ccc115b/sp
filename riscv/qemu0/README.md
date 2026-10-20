# qemu0

用 Rust 寫成的微型 RISC-V 模擬器,零外部依賴(約 800 行)。

## 功能
- **ISA**:RV64I + M(乘除)+ A(LR/SC、AMO)+ Zicsr,僅 Machine mode,單核心
- **Trap**:ecall / ebreak / 非法指令 / 存取錯誤 / mret;`mtvec` 直接與向量模式
- **中斷**:CLINT 計時器(MTIP)與軟體中斷(MSIP)
- **裝置**(位址對齊 QEMU `virt`):UART `0x1000_0000`、CLINT `0x0200_0000`、
  test finisher `0x10_0000`(寫 `0x5555` 正常結束、`(code<<16)|0x3333` 失敗結束)、DRAM `0x8000_0000`
- **載入**:ELF64 或 raw binary;內建 Hello World demo

## 使用
    cargo build --release
    ./target/release/qemu0                 # 內建 demo
    ./target/release/qemu0 prog.elf        # 執行 ELF
    ./target/release/qemu0 -d -n 100 prog.bin   # 追蹤前 100 個指令
    cargo test

## 架構
| 檔案 | 說明 |
|---|---|
| `src/cpu.rs` | 取指、解碼、執行、CSR、trap / 中斷 |
| `src/bus.rs` | 位址解碼、DRAM、UART、CLINT、test finisher |
| `src/elf.rs` | ELF64 PT_LOAD 載入器 |
| `src/demo.rs` | 迷你組譯器編碼函式 + Hello World |

## 之後可擴充
C 擴充(壓縮指令)、S/U mode 與 Sv39 MMU、PLIC、UART 輸入、virtio、F/D 浮點、基本區塊快取 / JIT。
