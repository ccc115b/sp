// 範例 5：向量化（Loop Vectorization, SLP）
//
// 連續且獨立的運算，LLVM 的 vectorizer 可能合成向量指令。
// 注意：pk / spike 的預設 RV64GC 沒有 V 擴充，所以這裡示範的是
// 「優化器把純量迴圈整理得更精簡」，向量化則需 -mattr=+v 才會出現 vadd 等指令。
//
// 觀察重點：
//   用不同優化等級看 .ll / .s 的差異：
//     opt -O1 / -O2 / -O3  以及 llc -mattr=+v（如工具鏈支援 V 才會看到向量指令）
#include "../rt.h"

__attribute__((noinline))
int dot4(int *a, int *b)
{
    int s = 0;
    for (int i = 0; i < 4; i++)
        s += a[i] * b[i];
    return s;
}

void _start(void)
{
    int a[4] = {1, 2, 3, 4};
    int b[4] = {5, 6, 7, 8};
    print("dot4 = ");
    print_i64(dot4(a, b));   // 5 + 12 + 21 + 32 = 70
    print("\n");
    sys_exit(0);
}
