set -x
# Step 1: 用系統 gcc 編譯出初代編譯器與虛擬機
gcc -Wno-everything c4.c -o c4
gcc -Wno-everything vm4.c -o vm4

# Step 2: 用初代編譯器編譯 c4.c 自己，產生第一代 bytecode c4_gen1.bc
./c4 c4.c c4_gen1.bc

# Step 3: 用 vm4 載入 c4_gen1.bc，再次編譯 c4.c，產生第二代 bytecode c4_gen2.bc
./vm4 c4_gen1.bc c4.c c4_gen2.bc

# Step 4: 比對兩次編譯出來的 bytecode 檔案
cmp c4_gen1.bc c4_gen2.bc && echo "=== 自我編譯 (Self-compilation) 成功！兩次 bytecode 100% 相同 ==="

# Step 5: 用第二代編譯出來的 c4_gen2.bc 編譯 hello.c
./vm4 c4_gen2.bc hello.c hello.bc
./vm4 hello.bc