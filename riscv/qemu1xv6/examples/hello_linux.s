# Linux 風格的 RISC-V 組語:用 write / exit 系統呼叫(給 spike0 執行)
#   ./spike.sh examples/hello_linux.s
    .section .rodata
msg:    .ascii "Hello from RISC-V, running on spike0!\n"
msg_len = . - msg

    .section .text
    .globl _start
_start:
    li   a7, 64                 # SYS_write
    li   a0, 1                  # fd = stdout
    la   a1, msg
    li   a2, msg_len
    ecall

    li   a7, 93                 # SYS_exit
    li   a0, 0
    ecall
