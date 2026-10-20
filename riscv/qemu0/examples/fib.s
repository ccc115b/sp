# 印出前 15 個費氏數(每行一個),示範迴圈、乘除與 syscall
#   ./spike.sh examples/fib.s
    .section .bss
buf:    .space 32
bufend:

    .section .text
    .globl _start
_start:
    li   s0, 0                  # a
    li   s1, 1                  # b
    li   s2, 15                 # 剩餘次數
1:  mv   a0, s0
    call print_u64
    add  t0, s0, s1
    mv   s0, s1
    mv   s1, t0
    addi s2, s2, -1
    bnez s2, 1b
    li   a7, 93
    li   a0, 0
    ecall

# print_u64(a0):以十進位印出 a0 並換行
print_u64:
    la   t1, bufend
    li   t2, 10
    addi t1, t1, -1
    sb   t2, 0(t1)              # '\n'
2:  remu t4, a0, t2
    addi t4, t4, '0'
    addi t1, t1, -1
    sb   t4, 0(t1)
    divu a0, a0, t2
    bnez a0, 2b
    la   t5, bufend
    sub  a2, t5, t1             # 長度
    mv   a1, t1
    li   a0, 1
    li   a7, 64
    ecall
    ret
