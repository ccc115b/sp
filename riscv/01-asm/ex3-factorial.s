.globl _start

.text
_start:
    li t0, 5        # 計算 5 的階乘 (n = 5)
    li t1, 1        # 結果初始化為 1 (result = 1)

fact_loop:
    ble t0, zero, fact_end  # 如果 t0 <= 0，結束迴圈
    mul t1, t1, t0          # result = result * n (需要 M 副指令集支援)
    addi t0, t0, -1         # n = n - 1
    j fact_loop             # 繼續迴圈

fact_end:
    mv a0, t1       # 將最終結果 (120) 放入 a0
    li a7, 93       # 離開系統呼叫
    ecall
