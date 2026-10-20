// 範例 3：遞迴計算階乘
// 展示函式遞迴呼叫與 64 位元整數（long）運算
#include <stdio.h>

long factorial(int n)
{
    if (n <= 1)
        return 1;
    return n * factorial(n - 1);
}

int main(void)
{
    for (int i = 0; i <= 10; i++)
        printf("%d! = %ld\n", i, factorial(i));
    return 0;
}
