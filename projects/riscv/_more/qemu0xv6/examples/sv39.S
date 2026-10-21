# M → S → U 與 Sv39 分頁的端到端範例。執行:./hello.sh examples/sv39.S
#
# 流程:
#   M-mode : 建立頁表、委派例外給 S、設定 satp、mret 進入 S-mode
#   S-mode : 分頁已開啟(恆等映射),設定 stvec,sret 進入 U-mode
#   U-mode : 在 0x40000000 的使用者頁面上跑;用 ecall 請 S 代為輸出;
#            故意寫入未映射的頁 → store page fault,由 S 處理後跳過
#   S-mode : 檢查 SUM 讀取使用者頁、檢查硬體是否設好 A/D 位元,最後 ecall 回 M 結束
    .option norelax
    .equ UART, 0x10000000
    .equ TEST, 0x100000

    .section .text
    .globl _start
_start:
    la   sp, stack_top
    la   t0, m_trap
    csrw mtvec, t0
    la   a0, msg_m
    call puts

    # ---- 頁表 ----
    # root[0] = 1GB 大頁 0x00000000 (RW,A,D):裝置區(UART / 測試裝置)
    la   t0, root
    li   t1, 0xc7                               # V R W . . A D
    sd   t1, 0(t0)
    # root[2] = 1GB 大頁 0x80000000 (RWX,A,D):核心 / DRAM 恆等映射
    li   t1, ((0x80000000 >> 12) << 10) | 0xcf  # V R W X A D
    sd   t1, 16(t0)
    # root[1] → l1 → l0:使用者空間 0x40000000
    la   t1, l1
    srli t1, t1, 12
    slli t1, t1, 10
    ori  t1, t1, 1
    sd   t1, 8(t0)
    la   t1, l0
    srli t1, t1, 12
    slli t1, t1, 10
    ori  t1, t1, 1
    la   t2, l1
    sd   t1, 0(t2)
    # l0[0] = 使用者程式頁   (V R X U A D) → VA 0x40000000
    la   t1, ucode
    srli t1, t1, 12
    slli t1, t1, 10
    ori  t1, t1, 0xdb
    la   t2, l0
    sd   t1, 0(t2)
    # l0[1] = 使用者資料頁   (V R W U A D) → VA 0x40001000
    la   t1, udata
    srli t1, t1, 12
    slli t1, t1, 10
    ori  t1, t1, 0xd7
    sd   t1, 8(t2)
    # l0[3] = 資料頁,A=D=0   (V R W U)     → VA 0x40003000,交給硬體去設 A/D
    la   t1, udata2
    srli t1, t1, 12
    slli t1, t1, 10
    ori  t1, t1, 0x17
    sd   t1, 24(t2)
    # (VA 0x40002000 刻意不映射)

    # ---- 委派 + satp + 進入 S-mode ----
    li   t0, (1 << 8) | (1 << 12) | (1 << 13) | (1 << 15)
    csrw medeleg, t0                            # U ecall 與各種 page fault 交給 S
    la   t0, root
    srli t0, t0, 12
    li   t1, 8 << 60                            # MODE = Sv39
    or   t0, t0, t1
    csrw satp, t0
    sfence.vma
    li   t0, 0x1800
    csrc mstatus, t0
    li   t0, 0x0800                             # MPP = S
    csrs mstatus, t0
    la   t0, s_entry
    csrw mepc, t0
    mret

# ---------------- S-mode ----------------
s_entry:
    la   t0, s_trap
    csrw stvec, t0
    la   a0, msg_s
    call puts
    li   t0, 0x100
    csrc sstatus, t0                            # SPP = U
    li   t0, 0x40000000
    csrw sepc, t0
    sret

    .balign 4                                   # stvec / mtvec 的 BASE 必須 4 位元組對齊(啟用壓縮指令後不再自動成立)
s_trap:
    csrr t0, scause
    li   t1, 8
    beq  t0, t1, s_ecall_u
    li   t1, 15
    beq  t0, t1, s_store_fault
    j    s_fail

s_ecall_u:
    li   t1, 1
    beq  a7, t1, s_putc
    li   t1, 93
    beq  a7, t1, s_exit
    j    s_fail
s_putc:
    call putc
    j    s_resume

s_store_fault:
    csrr t0, stval
    li   t1, 0x40002000
    bne  t0, t1, s_fail
    la   a0, msg_pf
    call puts
s_resume:                                       # 跳過造成 trap 的那條指令
    csrr t0, sepc
    addi t0, t0, 4
    csrw sepc, t0
    sret

s_exit:
    li   t0, 0x40000                            # sstatus.SUM
    csrs sstatus, t0
    li   t0, 0x40001000
    ld   t1, 0(t0)                              # S 讀 U 頁(需要 SUM)
    li   t2, 0x1234
    bne  t1, t2, s_fail
    la   a0, msg_sum
    call puts
    la   t0, l0
    ld   t1, 24(t0)                             # l0[3] 的 PTE
    andi t1, t1, 0xc0
    li   t2, 0xc0
    bne  t1, t2, s_fail
    la   a0, msg_ad
    call puts
    la   a0, msg_done
    call puts
    ecall                                       # S-mode ecall → M-mode(cause 9)

s_fail:
    la   a0, msg_fail
    call puts
    li   t0, TEST
    li   t1, 0x13333
    sw   t1, 0(t0)
1:  j    1b

# ---------------- M-mode ----------------
    .balign 4
m_trap:
    csrr t0, mcause
    li   t1, 9
    bne  t0, t1, 2f
    la   a0, msg_m_end
    call puts
    li   t0, TEST
    li   t1, 0x5555
    sw   t1, 0(t0)
2:  li   t0, TEST
    li   t1, 0x13333
    sw   t1, 0(t0)
3:  j    3b

# ---------------- 輔助函式 ----------------
putc:                                           # a0 = 字元
    li   t3, UART
    sb   a0, 0(t3)
    ret
puts:                                           # a0 = 字串
    li   t3, UART
1:  lbu  t4, 0(a0)
    beqz t4, 2f
    sb   t4, 0(t3)
    addi a0, a0, 1
    j    1b
2:  ret

    .section .rodata
msg_m:    .asciz "M: booting, building Sv39 page tables\n"
msg_s:    .asciz "S: paging enabled, entering user mode\n"
msg_pf:   .asciz "S: caught store page fault at 0x40002000 (delegated from U)\n"
msg_sum:  .asciz "S: SUM read of user page ok\n"
msg_ad:   .asciz "S: hardware set A/D bits on 0x40003000 ok\n"
msg_done: .asciz "S: user exited, asking M to power off\n"
msg_m_end:.asciz "M: S-mode ecall received, PASS\n"
msg_fail: .asciz "FAIL\n"

# ---------------- 使用者程式(位置無關,執行於 VA 0x40000000)----------------
    .section .text
    .balign 4096
ucode:
    li   t0, 0x40001000
    li   t1, 0x1234
    sd   t1, 0(t0)                              # 寫使用者資料頁
    ld   t2, 0(t0)
    bne  t1, t2, ubad
    la   s0, umsg                               # pc 相對:與 ucode 在同一頁
1:  lbu  a0, 0(s0)
    beqz a0, 2f
    li   a7, 1                                  # S 提供的 putchar
    ecall
    addi s0, s0, 1
    j    1b
2:  li   t0, 0x40002000                         # 未映射 → store page fault
    sd   t1, 0(t0)
    li   t0, 0x40003000                         # A=D=0 的頁 → 硬體設 A/D
    sd   t1, 0(t0)
    li   a7, 93                                 # exit
    li   a0, 0
    ecall
ubad:
    li   a7, 94
    ecall
umsg: .asciz "U: hello from user mode through an Sv39 page\n"
    .balign 4096

# ---------------- 資料 ----------------
    .section .bss
    .balign 4096
root:   .space 4096
l1:     .space 4096
l0:     .space 4096
udata:  .space 4096
udata2: .space 4096
        .space 4096
stack_top:
