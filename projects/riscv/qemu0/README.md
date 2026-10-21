# qemu0

用 Rust 寫成的微型 RISC-V 模擬器,零外部依賴(約 800 行)。

## 功能
- **ISA**:RV64I + M(乘除)+ A(LR/SC、AMO)+ C(壓縮指令)+ Zicsr,單核心;沒有 F / D 浮點
- **特權模式**:M / S / U,`mret` / `sret` / `sfence.vma` / `wfi`,含 TVM / TSR / TW 檢查
- **CSR**:`mstatus`(SIE MIE SPIE MPIE SPP MPP MPRV SUM MXR TVM TW TSR)、`misa`、`medeleg` / `mideleg`、
  `mie` / `mip`、`mtvec` / `mepc` / `mcause` / `mtval` / `mscratch` / `mcounteren`;
  S-mode:`sstatus` / `sie` / `sip` / `stvec` / `sepc` / `scause` / `stval` / `sscratch` / `scounteren` / `satp`;
  計數器 `cycle` / `time` / `instret`。依位址高位元檢查特權與唯讀。
- **Trap**:例外與中斷可依 `medeleg` / `mideleg` 委派給 S-mode;`mtvec` / `stvec` 直接與向量模式
- **中斷**:CLINT 計時器(MTIP)、軟體中斷(MSIP);SSIP / STIP / SEIP 可由 M-mode 軟體設定(如 xv6 的做法)
- **虛擬記憶體**:Sv39 三層頁表、1GB / 2MB 超級頁(含對齊檢查)、U / R / W / X 權限、SUM、MXR、MPRV、
  硬體更新 A / D 位元、256 項 TLB(`sfence.vma` 與寫 `satp` 時清除)、跨頁存取、page fault
- **裝置**(位址對齊 QEMU `virt`):
  - 16550 UART `0x1000_0000`(IRQ 10):收發、DLAB、FIFO 旗標、IER / ISR 中斷,stdin 可輸入
  - PLIC `0x0c00_0000`:priority / pending / enable / threshold / claim-complete,M 與 S 兩個 context
  - virtio-blk(mmio v2)`0x1000_1000`(IRQ 1):對 DRAM 做 DMA,寫入即時寫回映像檔
  - CLINT `0x0200_0000`、test finisher `0x10_0000`(寫 `0x5555` 正常結束、`(code<<16)|0x3333` 失敗結束)
  - DRAM `0x8000_0000`
- **擴充**:Sstc(`stimecmp`)、Svadu 行為(A/D 位元永遠由硬體更新)、`menvcfg`;PMP CSR 只儲存值、不做保護檢查
- **載入**:ELF64 或 raw binary;內建 Hello World demo

## 使用
    cargo build --release
    ./target/release/qemu0                 # 內建 demo
    ./target/release/qemu0 prog.elf        # 執行 ELF
    ./target/release/qemu0 -d -n 100 prog.bin   # 追蹤前 100 個指令
    ./hello.sh examples/sv39.S             # M→S→U + Sv39 分頁 + 委派的端到端範例
    cargo test                             # 含 MMU / 特權模式單元測試

## 架構
| 檔案 | 說明 |
|---|---|
| `src/cpu.rs` | 取指、解碼、執行、CSR、trap / 中斷 |
| `src/bus.rs` | 位址解碼、DRAM、UART、CLINT、test finisher |
| `src/elf.rs` | ELF64 PT_LOAD 載入器 |
| `src/demo.rs` | 迷你組譯器編碼函式 + Hello World |

## 之後可擴充
F/D 浮點(Linux 需要)、PMP 保護檢查、ASID、更多 virtio 裝置(net / rng)、裝置樹、基本區塊快取 / JIT。

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

限制:只跑靜態連結、`-march=rv64imac -mabi=lp64` 的程式(支援壓縮指令,無 F/D 浮點);不支援 fork/exec/thread/signal;
主機需為 Unix(Linux / macOS)。純組語、`-nostdlib` 的 C、musl 等小型 libc 較有機會成功;
一般 glibc 發行版工具鏈預設會產生 C/F/D 指令,無法執行。

## 在 qemu0 上跑 xv6
    ./xv6.sh                 # 自動 clone → 編譯 → 開機,Ctrl-A x 結束
    ./target/release/qemu0 --disk fs.img kernel/kernel    # 手動

已實測(最新版 xv6-riscv):完整開機進入 shell,`ls`、`echo > file`、`cat`、管線(`cat README | wc`)、
`forktest` 都正常;寫入的檔案在重新開機後仍在;`usertests -q` 前段(copyin/copyout、truncate、exec、
pipe、preempt、fork/wait 等)全數通過。

注意:
- xv6 直接用它預設的 `-march=rv64gc` 編譯即可:qemu0 支援 C 擴充,而 xv6 核心不使用浮點指令(沒有 F/D 也能運作)。
- 速度約 40 MIPS,xv6 開機到 shell 約 10 秒(主要時間花在 `kinit` 清 128MB 記憶體)。
- 互動時請用真正的終端機;`xv6.sh` 會自動把終端機切成逐字輸入模式,結束時還原。
