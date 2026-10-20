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

## 一鍵組譯並執行
    ./hello.sh                 # examples/hello.S → build/hello → qemu0 執行
    ./hello.sh foo.s -d        # 指定組語檔,-d 等參數傳給 qemu0
需要 RISC-V 交叉編譯器(如 `gcc-riscv64-unknown-elf`)。

## spike0 — 在目前 OS 直接執行 RISC-V 程式(類似 `spike pk`)
`qemu0` 模擬整台裸機;`spike0` 則是 user-mode 模擬:執行靜態連結的 RISC-V Linux ELF,
遇到 `ecall` 就依 RISC-V Linux ABI(a7=編號、a0..a5=參數、回傳值在 a0)代理給主機 OS。

    ./spike.sh examples/hello_linux.s            # .s → ELF → spike0 執行
    ./spike.sh examples/cat.s README.md          # 傳遞程式參數
    SPIKE_FLAGS="-s --stat" ./spike.sh examples/fib.s   # 追蹤 syscall、印出指令數
    ./target/release/spike0 ./a.out arg1 arg2    # 直接執行已編譯好的 ELF

已支援的 syscall:`exit/exit_group`、`openat/close/read/write/writev/lseek/fstat`、`brk`、
`mmap/munmap/mprotect/madvise`、`clock_gettime/gettimeofday`、`uname`、`getrandom`、
`getpid/getuid…`、`ioctl`(回 ENOTTY)、`rt_sigaction/rt_sigprocmask`(空實作)。
其餘回傳 `-ENOSYS`(用 `-s` 可看到哪個 syscall 沒支援)。

限制:只跑靜態連結、`-march=rv64ima -mabi=lp64` 的程式(無 C/F/D 擴充);不支援 fork/exec/thread/signal;
主機需為 Unix(Linux / macOS)。純組語、`-nostdlib` 的 C、musl 等小型 libc 較有機會成功;
一般 glibc 發行版工具鏈預設會產生 C/F/D 指令,無法執行。
