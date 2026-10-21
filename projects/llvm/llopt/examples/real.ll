; ModuleID = 'examples/real.c'
source_filename = "examples/real.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx26.0.0"

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @gcd(i32 noundef %0, i32 noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store i32 %0, ptr %3, align 4
  store i32 %1, ptr %4, align 4
  br label %6

6:                                                ; preds = %9, %2
  %7 = load i32, ptr %4, align 4
  %8 = icmp ne i32 %7, 0
  br i1 %8, label %9, label %15

9:                                                ; preds = %6
  %10 = load i32, ptr %3, align 4
  %11 = load i32, ptr %4, align 4
  %12 = srem i32 %10, %11
  store i32 %12, ptr %5, align 4
  %13 = load i32, ptr %4, align 4
  store i32 %13, ptr %3, align 4
  %14 = load i32, ptr %5, align 4
  store i32 %14, ptr %4, align 4
  br label %6, !llvm.loop !6

15:                                               ; preds = %6
  %16 = load i32, ptr %3, align 4
  ret i32 %16
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @fib(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %0, ptr %3, align 4
  %4 = load i32, ptr %3, align 4
  %5 = icmp slt i32 %4, 2
  br i1 %5, label %6, label %8

6:                                                ; preds = %1
  %7 = load i32, ptr %3, align 4
  store i32 %7, ptr %2, align 4
  br label %16

8:                                                ; preds = %1
  %9 = load i32, ptr %3, align 4
  %10 = sub nsw i32 %9, 1
  %11 = call i32 @fib(i32 noundef %10)
  %12 = load i32, ptr %3, align 4
  %13 = sub nsw i32 %12, 2
  %14 = call i32 @fib(i32 noundef %13)
  %15 = add nsw i32 %11, %14
  store i32 %15, ptr %2, align 4
  br label %16

16:                                               ; preds = %8, %6
  %17 = load i32, ptr %2, align 4
  ret i32 %17
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @collatz(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  store i32 0, ptr %3, align 4
  br label %4

4:                                                ; preds = %23, %1
  %5 = load i32, ptr %2, align 4
  %6 = icmp ne i32 %5, 1
  br i1 %6, label %7, label %10

7:                                                ; preds = %4
  %8 = load i32, ptr %3, align 4
  %9 = icmp slt i32 %8, 1000
  br label %10

10:                                               ; preds = %7, %4
  %11 = phi i1 [ false, %4 ], [ %9, %7 ]
  br i1 %11, label %12, label %26

12:                                               ; preds = %10
  %13 = load i32, ptr %2, align 4
  %14 = srem i32 %13, 2
  %15 = icmp eq i32 %14, 0
  br i1 %15, label %16, label %19

16:                                               ; preds = %12
  %17 = load i32, ptr %2, align 4
  %18 = sdiv i32 %17, 2
  store i32 %18, ptr %2, align 4
  br label %23

19:                                               ; preds = %12
  %20 = load i32, ptr %2, align 4
  %21 = mul nsw i32 3, %20
  %22 = add nsw i32 %21, 1
  store i32 %22, ptr %2, align 4
  br label %23

23:                                               ; preds = %19, %16
  %24 = load i32, ptr %3, align 4
  %25 = add nsw i32 %24, 1
  store i32 %25, ptr %3, align 4
  br label %4, !llvm.loop !8

26:                                               ; preds = %10
  %27 = load i32, ptr %3, align 4
  ret i32 %27
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @poly(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  %6 = load i32, ptr %2, align 4
  %7 = mul nsw i32 %6, 4
  %8 = add nsw i32 %7, 3
  store i32 %8, ptr %3, align 4
  %9 = load i32, ptr %2, align 4
  %10 = mul nsw i32 %9, 4
  %11 = add nsw i32 %10, 3
  store i32 %11, ptr %4, align 4
  %12 = load i32, ptr %3, align 4
  %13 = load i32, ptr %4, align 4
  %14 = add nsw i32 %12, %13
  %15 = mul nsw i32 %14, 1
  %16 = add nsw i32 %15, 0
  store i32 %16, ptr %5, align 4
  %17 = load i32, ptr %5, align 4
  %18 = load i32, ptr %5, align 4
  %19 = sub nsw i32 %17, %18
  %20 = load i32, ptr %3, align 4
  %21 = mul nsw i32 %20, 8
  %22 = add nsw i32 %19, %21
  %23 = load i32, ptr %2, align 4
  %24 = icmp ne i32 %23, 0
  %25 = zext i1 %24 to i64
  %26 = select i1 %24, i32 1, i32 1
  %27 = add nsw i32 %22, %26
  ret i32 %27
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @arr(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca [8 x i32], align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  store i32 0, ptr %4, align 4
  br label %7

7:                                                ; preds = %17, %1
  %8 = load i32, ptr %4, align 4
  %9 = icmp slt i32 %8, 8
  br i1 %9, label %10, label %20

10:                                               ; preds = %7
  %11 = load i32, ptr %4, align 4
  %12 = load i32, ptr %2, align 4
  %13 = mul nsw i32 %11, %12
  %14 = load i32, ptr %4, align 4
  %15 = sext i32 %14 to i64
  %16 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 %15
  store i32 %13, ptr %16, align 4
  br label %17

17:                                               ; preds = %10
  %18 = load i32, ptr %4, align 4
  %19 = add nsw i32 %18, 1
  store i32 %19, ptr %4, align 4
  br label %7, !llvm.loop !9

20:                                               ; preds = %7
  store i32 0, ptr %5, align 4
  store i32 0, ptr %6, align 4
  br label %21

21:                                               ; preds = %31, %20
  %22 = load i32, ptr %6, align 4
  %23 = icmp slt i32 %22, 8
  br i1 %23, label %24, label %34

24:                                               ; preds = %21
  %25 = load i32, ptr %6, align 4
  %26 = sext i32 %25 to i64
  %27 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 %26
  %28 = load i32, ptr %27, align 4
  %29 = load i32, ptr %5, align 4
  %30 = add nsw i32 %29, %28
  store i32 %30, ptr %5, align 4
  br label %31

31:                                               ; preds = %24
  %32 = load i32, ptr %6, align 4
  %33 = add nsw i32 %32, 1
  store i32 %33, ptr %6, align 4
  br label %21, !llvm.loop !10

34:                                               ; preds = %21
  %35 = load i32, ptr %5, align 4
  ret i32 %35
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @sw(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %0, ptr %3, align 4
  %4 = load i32, ptr %3, align 4
  switch i32 %4, label %10 [
    i32 0, label %5
    i32 1, label %6
    i32 5, label %7
  ]

5:                                                ; preds = %1
  store i32 11, ptr %2, align 4
  br label %13

6:                                                ; preds = %1
  store i32 22, ptr %2, align 4
  br label %13

7:                                                ; preds = %1
  %8 = load i32, ptr %3, align 4
  %9 = mul nsw i32 %8, 3
  store i32 %9, ptr %2, align 4
  br label %13

10:                                               ; preds = %1
  %11 = load i32, ptr %3, align 4
  %12 = sub nsw i32 0, %11
  store i32 %12, ptr %2, align 4
  br label %13

13:                                               ; preds = %10, %7, %6, %5
  %14 = load i32, ptr %2, align 4
  ret i32 %14
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @mix(i32 noundef %0, i32 noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 %0, ptr %3, align 4
  store i32 %1, ptr %4, align 4
  %7 = load i32, ptr %3, align 4
  %8 = udiv i32 %7, 16
  %9 = load i32, ptr %3, align 4
  %10 = urem i32 %9, 8
  %11 = add i32 %8, %10
  store i32 %11, ptr %5, align 4
  %12 = load i32, ptr %4, align 4
  %13 = shl i32 %12, 3
  %14 = ashr i32 %13, 1
  store i32 %14, ptr %6, align 4
  %15 = load i32, ptr %5, align 4
  %16 = load i32, ptr %6, align 4
  %17 = add nsw i32 %15, %16
  %18 = load i32, ptr %4, align 4
  %19 = load i32, ptr %4, align 4
  %20 = icmp eq i32 %18, %19
  %21 = zext i1 %20 to i32
  %22 = add nsw i32 %17, %21
  %23 = load i32, ptr %3, align 4
  %24 = icmp uge i32 %23, 0
  %25 = zext i1 %24 to i32
  %26 = add nsw i32 %22, %25
  ret i32 %26
}

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 2, !"SDK Version", [1 x i32] [i32 26]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 4}
!5 = !{!"Homebrew clang version 22.1.4"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = distinct !{!8, !7}
!9 = distinct !{!9, !7}
!10 = distinct !{!10, !7}
