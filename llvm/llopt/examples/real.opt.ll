; ──── llopt 優化摘要 ────
;   Store→Load 轉送 (Store-to-Load Forwarding): 24 次
;   代數化簡 (Algebraic Simplification): 7 次
;   共同子運算式消除 (CSE): 3 次
;   基本區塊合併 (Block Merging): 2 次
;   強度削減 (Strength Reduction): 5 次
;   死 alloca/store 消除 (Dead Alloca Elimination): 18 次
;   死碼消除 (Dead Code Elimination): 3 次
;   運算元正規化 (Canonicalization): 2 次
; ModuleID = 'examples/real.c'
source_filename = "examples/real.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx26.0.0"

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @gcd(i32 noundef %0, i32 noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, ptr %3, align 4
  store i32 %1, ptr %4, align 4
  br label %5

5:
  %6 = load i32, ptr %4, align 4
  %7 = icmp ne i32 %6, 0
  br i1 %7, label %8, label %12

8:
  %9 = load i32, ptr %3, align 4
  %10 = load i32, ptr %4, align 4
  %11 = srem i32 %9, %10
  store i32 %10, ptr %3, align 4
  store i32 %11, ptr %4, align 4
  br label %5, !llvm.loop !6

12:
  %13 = load i32, ptr %3, align 4
  ret i32 %13
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @fib(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %0, ptr %3, align 4
  %4 = icmp slt i32 %0, 2
  br i1 %4, label %5, label %7

5:
  %6 = load i32, ptr %3, align 4
  store i32 %6, ptr %2, align 4
  br label %14

7:
  %8 = load i32, ptr %3, align 4
  %9 = sub nsw i32 %8, 1
  %10 = call i32 @fib(i32 noundef %9)
  %11 = sub nsw i32 %8, 2
  %12 = call i32 @fib(i32 noundef %11)
  %13 = add nsw i32 %10, %12
  store i32 %13, ptr %2, align 4
  br label %14

14:
  %15 = load i32, ptr %2, align 4
  ret i32 %15
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @collatz(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  store i32 0, ptr %3, align 4
  br label %4

4:
  %5 = load i32, ptr %2, align 4
  %6 = icmp ne i32 %5, 1
  br i1 %6, label %7, label %10

7:
  %8 = load i32, ptr %3, align 4
  %9 = icmp slt i32 %8, 1000
  br label %10

10:
  %11 = phi i1 [ false, %4 ], [ %9, %7 ]
  br i1 %11, label %12, label %26

12:
  %13 = load i32, ptr %2, align 4
  %14 = srem i32 %13, 2
  %15 = icmp eq i32 %14, 0
  br i1 %15, label %16, label %19

16:
  %17 = load i32, ptr %2, align 4
  %18 = sdiv i32 %17, 2
  store i32 %18, ptr %2, align 4
  br label %23

19:
  %20 = load i32, ptr %2, align 4
  %21 = mul nsw i32 %20, 3
  %22 = add nsw i32 %21, 1
  store i32 %22, ptr %2, align 4
  br label %23

23:
  %24 = load i32, ptr %3, align 4
  %25 = add nsw i32 %24, 1
  store i32 %25, ptr %3, align 4
  br label %4, !llvm.loop !8

26:
  %27 = load i32, ptr %3, align 4
  ret i32 %27
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @poly(i32 noundef %0) #0 {
  %2 = shl i32 %0, 2
  %3 = add nsw i32 %2, 3
  %4 = shl i32 %3, 3
  %5 = add nsw i32 %4, 1
  ret i32 %5
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

7:
  %8 = load i32, ptr %4, align 4
  %9 = icmp slt i32 %8, 8
  br i1 %9, label %10, label %17

10:
  %11 = load i32, ptr %4, align 4
  %12 = load i32, ptr %2, align 4
  %13 = mul nsw i32 %11, %12
  %14 = sext i32 %11 to i64
  %15 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 %14
  store i32 %13, ptr %15, align 4
  %16 = add nsw i32 %11, 1
  store i32 %16, ptr %4, align 4
  br label %7, !llvm.loop !9

17:
  store i32 0, ptr %5, align 4
  store i32 0, ptr %6, align 4
  br label %18

18:
  %19 = load i32, ptr %6, align 4
  %20 = icmp slt i32 %19, 8
  br i1 %20, label %21, label %29

21:
  %22 = load i32, ptr %6, align 4
  %23 = sext i32 %22 to i64
  %24 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 %23
  %25 = load i32, ptr %24, align 4
  %26 = load i32, ptr %5, align 4
  %27 = add nsw i32 %26, %25
  store i32 %27, ptr %5, align 4
  %28 = add nsw i32 %22, 1
  store i32 %28, ptr %6, align 4
  br label %18, !llvm.loop !10

29:
  %30 = load i32, ptr %5, align 4
  ret i32 %30
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @sw(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %0, ptr %3, align 4
  switch i32 %0, label %9 [ i32 0, label %4 i32 1, label %5 i32 5, label %6 ]

4:
  store i32 11, ptr %2, align 4
  br label %12

5:
  store i32 22, ptr %2, align 4
  br label %12

6:
  %7 = load i32, ptr %3, align 4
  %8 = mul nsw i32 %7, 3
  store i32 %8, ptr %2, align 4
  br label %12

9:
  %10 = load i32, ptr %3, align 4
  %11 = sub nsw i32 0, %10
  store i32 %11, ptr %2, align 4
  br label %12

12:
  %13 = load i32, ptr %2, align 4
  ret i32 %13
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @mix(i32 noundef %0, i32 noundef %1) #0 {
  %3 = lshr i32 %0, 4
  %4 = and i32 %0, 7
  %5 = add i32 %3, %4
  %6 = shl i32 %1, 3
  %7 = ashr i32 %6, 1
  %8 = add nsw i32 %5, %7
  %9 = zext i1 true to i32
  %10 = add nsw i32 %8, %9
  %11 = add nsw i32 %10, %9
  ret i32 %11
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
