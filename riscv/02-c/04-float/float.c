// 範例 4：浮點運算
// 展示 RISC-V 的 F/D（單精度／雙精度）浮點指令支援
#include <stdio.h>

int main(void)
{
    double a = 3.14159;
    double b = 2.0;
    printf("pi * 2 = %.5f\n", a * b);

    float f = 1.0f / 3.0f;
    printf("1/3 = %.5f\n", (double)f);
    return 0;
}
