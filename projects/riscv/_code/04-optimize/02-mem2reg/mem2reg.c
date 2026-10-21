// 範例 2：mem2reg（把堆疊變數提升成暫存器）
//
// 未優化時，區域變數都會配置在堆疊上，每次讀寫都要 load/store。
// opt -O2 的 mem2reg pass 用 SSA 值取代這些 load/store，程式變得精簡。
//
// 觀察重點：
//   -O0 的 .ll 裡會出現 alloca / load / store
//   -O2 之後 alloca 幾乎全部消失，只剩 % 值流
#include "../rt.h"

__attribute__((noinline))
int fib(int n)
{
    int a = 0, b = 1;
    for (int i = 0; i < n; i++) {
        int t = a + b;
        a = b;
        b = t;
    }
    return a;
}

void _start(void)
{
    print("fib(10) = ");
    print_i64(fib(10));
    print("\nfib(20) = ");
    print_i64(fib(20));
    print("\n");
    sys_exit(0);
}
