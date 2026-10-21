// 範例 2：計算 1 + 2 + ... + 10
// 展示迴圈與一般函式呼叫
#include <stdio.h>

int sum(int n)
{
    int s = 0;
    for (int i = 1; i <= n; i++)
        s += i;
    return s;
}

int main(void)
{
    int result = sum(10);
    printf("sum(1..10) = %d\n", result);
    return 0;
}
