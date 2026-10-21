.globl _start

.data
# 定義一個包含 5 個元素的整數陣列 (1, 2, 3, 4, 5)
array: .word 1, 2, 3, 4, 5

.text
_start:
    la t0, array    # 載入陣列的記憶體基底位址到 t0
    li t1, 5        # 迴圈計數器：共 5 個元素
    li t2, 0        # 總和累加器 (sum = 0)

loop:
    beq t1, zero, end_loop  # 如果計數器歸零，跳出迴圈
    lw t3, 0(t0)            # 從 t0 指向的位址讀取一個字組 (word) 到 t3
    add t2, t2, t3          # sum += t3
    addi t0, t0, 4          # 移動到下一個整數位址 (每個 word 佔 4 bytes)
    addi t1, t1, -1         # 計數器減 1
    j loop                  # 迴圈重頭

end_loop:
    mv a0, t2       # 將總和 (15) 放入 a0
    li a7, 93       # 離開系統呼叫
    ecall
