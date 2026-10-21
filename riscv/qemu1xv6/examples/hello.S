# 最簡單:./hello.sh(會組譯、連結並用 qemu0 執行)
# 手動:riscv64-unknown-elf-gcc -march=rv64ima -mabi=lp64 -nostdlib -static \
#         -T build/qemu0.ld -o hello hello.S  &&  qemu0 hello
    .section .text
    .globl _start
_start:
    li   a0, 0x10000000        # UART
    la   a1, msg
1:  lbu  t0, 0(a1)
    beqz t0, 2f
    sb   t0, 0(a0)
    addi a1, a1, 1
    j    1b
2:  li   a2, 0x100000          # test finisher
    li   t1, 0x5555
    sw   t1, 0(a2)
3:  j    3b

    .section .rodata
msg: .asciz "Hello from hello.S on qemu0!\n"
