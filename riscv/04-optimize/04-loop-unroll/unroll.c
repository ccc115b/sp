// 範例 4：迴圈展開與強度削減（Loop Unrolling / Strength Reduction）
//
// 計數固定的迴圈，LLVM 會展開（unroll）並把乘 4 換成位移等便宜運算。
//
// 觀察重點：
//   -O0 的 .ll 有 phi 節點 + 每次疊代一次 add
//   -O2 之後可能整段展開成數個常數加法
#include "../rt.h"

__attribute__((noinline))
int sum_squares(int n)
{
    int s = 0;
    for (int i = 1; i <= n; i++)
        s += i * i;
    return s;
}

__attribute__((noinline))
int scale_array(int *a, int n)
{
    int s = 0;
    for (int i = 0; i < n; i++)
        s += a[i] * 4;   // 乘 4 -> 左移 2（strength reduction）
    return s;
}

void _start(void)
{
    int arr[8] = {1, 2, 3, 4, 5, 6, 7, 8};
    print("sum_squares(10) = ");
    print_i64(sum_squares(10));
    print("\nscale_array = ");
    print_i64(scale_array(arr, 8));
    print("\n");
    sys_exit(0);
}
