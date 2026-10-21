; clang -O0 風格：未命名值 %0 %1 ...、數字標籤、多行 switch
define i32 @classify(i32 %0) {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  %4 = load i32, ptr %2, align 4
  %5 = mul nsw i32 %4, 1
  %6 = add nsw i32 %5, 0
  switch i32 %6, label %12 [
    i32 1, label %7
    i32 2, label %9
  ]

7:                                                ; preds = %1
  store i32 10, ptr %3, align 4
  br label %13

9:                                                ; preds = %1
  %10 = load i32, ptr %2, align 4
  %11 = mul nsw i32 %10, 100
  store i32 %11, ptr %3, align 4
  br label %13

12:                                               ; preds = %1
  store i32 -1, ptr %3, align 4
  br label %13

13:                                               ; preds = %12, %9, %7
  %14 = load i32, ptr %3, align 4
  %15 = add nsw i32 %14, 1
  ret i32 %15
}

define i32 @branchy(i32 %0, i32 %1) {
  %3 = icmp slt i32 %0, %1
  %4 = select i1 %3, i32 %0, i32 %0
  %5 = icmp ult i32 %1, 0
  br i1 %5, label %6, label %8

6:
  %7 = add i32 %4, 1000
  br label %8

8:
  %9 = phi i32 [ %7, %6 ], [ %4, %2 ]
  %10 = shl i32 %9, 0
  ret i32 %10
}
