# 迷你 cat:./spike.sh examples/cat.s README.md
# 示範:argc/argv、openat / read / write / close、結束碼
    .section .bss
buf:    .space 4096

    .section .text
    .globl _start
_start:
    ld   t0, 0(sp)              # argc
    li   t1, 2
    blt  t0, t1, usage
    ld   a1, 16(sp)             # argv[1]
    li   a0, -100               # AT_FDCWD
    li   a2, 0                  # O_RDONLY
    li   a7, 56                 # SYS_openat
    ecall
    bltz a0, fail
    mv   s0, a0                 # fd
1:  mv   a0, s0
    la   a1, buf
    li   a2, 4096
    li   a7, 63                 # SYS_read
    ecall
    blez a0, 2f
    mv   a2, a0
    li   a0, 1
    la   a1, buf
    li   a7, 64                 # SYS_write
    ecall
    j    1b
2:  mv   a0, s0
    li   a7, 57                 # SYS_close
    ecall
    li   a0, 0
    j    exit
usage:
    li   a0, 2
    j    exit
fail:
    li   a0, 1
exit:
    li   a7, 93
    ecall
