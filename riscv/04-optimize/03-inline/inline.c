// 範例 3：函式內聯（Inlining）
//
// 小函式被 inline 之後，跨函式的最佳化（例如常數傳遞）才能發揮。
// square() / addmul() 都很小，opt -O2 會把它們內聯進 caller。
//
// 觀察重點：
//   -O0 的 .ll 有 call @square、call @addmul
//   -O2 之後這些函式可能被 inline 掉或變成單一運算
#include "../rt.h"

__attribute__((noinline))
static int square(int x)
{
    return x * x;
}

__attribute__((noinline))
static int addmul(int a, int b)
{
    return a + square(b);
}

__attribute__((noinline))
int compute(int n)
{
    int s = 0;
    for (int i = 0; i < n; i++)
        s += addmul(i, i + 1);
    return s;
}

void _start(void)
{
    print("compute(10) = ");
    print_i64(compute(10));
    print("\n");
    sys_exit(0);
}
