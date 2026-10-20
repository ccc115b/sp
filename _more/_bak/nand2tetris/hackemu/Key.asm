// 有按鍵就把第一列前 16 格塗黑，否則什麼都不畫
@KBD
D=M
@NOKEY
D;JEQ
@16384
M=-1
(NOKEY)
(END)
@END
0;JMP
