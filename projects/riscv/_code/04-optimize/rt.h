// 04-optimize 的共用執行環境（freestanding C）
//
// 和 02-c 不同：02-c 有 newlib 的 printf 可用；這裡的目標是觀察
// 「C -> LLVM IR -> 優化 -> 組語」的過程，所以刻意不連結任何 libc，
// 只用 pk（proxy kernel）提供的 write/exit 系統呼叫。
//
// 每個 .c 檔開頭 `#include "../rt.h"`、結尾提供 _start 即可。

#ifndef RT_H
#define RT_H

// ---- 系統呼叫 ----------------------------------------------------------

// write(2)：把 buf 的 len 個位元組寫到 fd（1 = stdout），回傳實際寫入量
static inline long sys_write(int fd, const void *buf, unsigned long len)
{
    register long a0 __asm__("a0") = fd;
    register const void *a1 __asm__("a1") = buf;
    register unsigned long a2 __asm__("a2") = len;
    register long a7 __asm__("a7") = 64;
    __asm__ volatile("ecall" : "+r"(a0) : "r"(a1), "r"(a2), "r"(a7) : "memory");
    return a0;
}

// exit(2)：結束程式並回傳狀態碼
static inline void sys_exit(int code)
{
    register long a0 __asm__("a0") = code;
    register long a7 __asm__("a7") = 93;
    __asm__ volatile("ecall" : : "r"(a0), "r"(a7) : "memory");
    __builtin_unreachable();
}

// ---- 輸出 --------------------------------------------------------------

static inline void print(const char *s)
{
    unsigned long n = 0;
    while (s[n])
        n++;
    sys_write(1, s, n);
}

static inline void print_i64(long v)
{
    char b[20];
    int i = 20;
    if (v < 0) {
        sys_write(1, "-", 1);
        v = -v;
    }
    if (v == 0) {
        sys_write(1, "0", 1);
        return;
    }
    while (v > 0) {
        b[--i] = (char)('0' + (int)(v % 10));
        v /= 10;
    }
    sys_write(1, b + i, 20 - (unsigned long)i);
}

static inline void print_u64(unsigned long v)
{
    print_i64((long)v);
}

#endif
