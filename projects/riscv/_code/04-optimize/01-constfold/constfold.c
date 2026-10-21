// 範例 1：常數折疊（Constant Folding）
//
// LLVM 會在編譯期就把「輸入全是常數」的運算直接算完。
// 下面 expression() 的引數全是常數，-O2 之後函式會整個消失，直接輸出結果。
//
// 觀察重點：
//   $ clang -O0 -S -emit-llvm  -> 仍看得到一整串 mul/add
//   $ opt -O2                  -> 直接變成 ret i32 140
#include "../rt.h"

__attribute__((noinline))
int expression(void)
{
    int a = 3, b = 4, c = 5;
    int x = a * b * c;       // 60
    int y = (a + b) * (c + 1); // 7 * 6 = 42
    return x + y - 2 * a;    // 60 + 42 - 6 = 96
}

__attribute__((noinline))
int loop_const(void)
{
    int s = 0;
    for (int i = 0; i < 100; i++)
        s += i;
    return s;                // 4950，好的優化器會直接算出來
}

void _start(void)
{
    print("expression() = ");
    print_i64(expression());
    print("\nloop_const() = ");
    print_i64(loop_const());
    print("\n");
    sys_exit(0);
}
