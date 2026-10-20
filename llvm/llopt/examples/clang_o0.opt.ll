; ──── llopt 優化摘要 ────
;   Store→Load 轉送 (Store-to-Load Forwarding): 1 次
;   不可達區塊移除 (Unreachable Block Elimination): 1 次
;   代數化簡 (Algebraic Simplification): 5 次
;   分支摺疊 (Branch Folding): 1 次
;   基本區塊合併 (Block Merging): 1 次
;   死碼消除 (Dead Code Elimination): 1 次
; clang -O0 風格：未命名值 %0 %1 ...、數字標籤、多行 switch
define i32 @classify(i32 %0) {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  switch i32 %0, label %8 [ i32 1, label %4 i32 2, label %5 ]

4:
  store i32 10, ptr %3, align 4
  br label %9

5:
  %6 = load i32, ptr %2, align 4
  %7 = mul nsw i32 %6, 100
  store i32 %7, ptr %3, align 4
  br label %9

8:
  store i32 -1, ptr %3, align 4
  br label %9

9:
  %10 = load i32, ptr %3, align 4
  %11 = add nsw i32 %10, 1
  ret i32 %11
}

define i32 @branchy(i32 %0, i32 %1) {
  ret i32 %0
}
