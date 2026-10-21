.globl _start

.text
_start:
    li t0, 15       # 將常數 15 載入暫存器 t0
    li t1, 27       # 將常數 27 載入暫存器 t1
    add t2, t0, t1  # t2 = t0 + t1 (結果為 42)

    # 結束程式並回傳結果 (a0 = 42)
    mv a0, t2       # 將結果放入 a0 作為離開狀態碼
    li a7, 93       # Linux 系統呼叫編號：exit
    ecall
