// 示範：變數 (i)、標籤 (LOOP/END)、預定義符號 (SCREEN/KBD)
@i
M=1            // i = 1
(LOOP)
@i
D=M            // D = i
@SCREEN
M=D            // *SCREEN = i
@KBD
D=M            // D = *KBD
@END
D;JNE          // 有按鍵就跳 END
@i
M=M+1          // i = i + 1
@LOOP
0;JMP
(END)
@END
0;JMP
