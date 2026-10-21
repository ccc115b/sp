```sh
(.venv) cccuser@cccimacdeiMac qemu0 % ./spike.sh examples/hello_linux.s
[1/3] riscv64-unknown-elf-gcc hello_linux.s -> hello_linux
[2/3] spike0 已是最新
[3/3] spike0 hello_linux
Hello from RISC-V, running on spike0!
(.venv) cccuser@cccimacdeiMac qemu0 % ./spike.sh examples/cat.s README.md
[1/3] riscv64-unknown-elf-gcc cat.s -> cat
[2/3] spike0 已是最新
[3/3] spike0 cat
# qemu0

用 Rust 寫成的微型 RISC-V 模擬器,零外部依賴(約 800 行)。

## 功能
- **ISA**:RV64I + M(乘除)+ A(LR/SC、AMO)+ Zicsr,僅 Machine mode,單核心
- **Trap**:ecall / ebreak / 非法指令 / 存取錯誤 / mret;`mtvec` 直接與向量模式
- **中斷**:CLINT 計時器(MTIP)與軟體中斷(MSIP)
...

(.venv) cccuser@cccimacdeiMac qemu0 % SPIKE_FLAGS="-s --stat" ./spike.sh examples/fib.s
[1/3] riscv64-unknown-elf-gcc fib.s -> fib
[2/3] spike0 已是最新
[3/3] spike0 fib
0
[sys] write(0x1, 0x1117e, 0x2) = 2
1
[sys] write(0x1, 0x1117e, 0x2) = 2
1
[sys] write(0x1, 0x1117e, 0x2) = 2
2
[sys] write(0x1, 0x1117e, 0x2) = 2
3
[sys] write(0x1, 0x1117e, 0x2) = 2
5
[sys] write(0x1, 0x1117e, 0x2) = 2
8
[sys] write(0x1, 0x1117e, 0x2) = 2
13
[sys] write(0x1, 0x1117d, 0x3) = 3
21
[sys] write(0x1, 0x1117d, 0x3) = 3
34
[sys] write(0x1, 0x1117d, 0x3) = 3
55
[sys] write(0x1, 0x1117d, 0x3) = 3
89
[sys] write(0x1, 0x1117d, 0x3) = 3
144
[sys] write(0x1, 0x1117c, 0x4) = 4
233
[sys] write(0x1, 0x1117c, 0x4) = 4
377
[sys] write(0x1, 0x1117c, 0x4) = 4
[sys] exit(0)
[spike0] 共執行 432 個指令
(.venv) cccuser@cccimacdeiMac qemu0 % ./target/release/spike0 ./a.out arg1 arg2
spike0: 無法讀取 ./a.out: No such file or directory (os error 2)
```
