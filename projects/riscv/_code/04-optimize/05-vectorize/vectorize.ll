; ModuleID = 'vectorize.6bcc515def878556-cgu.0'
source_filename = "vectorize.6bcc515def878556-cgu.0"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "riscv64"

module asm ".pushsection .text._start,\22ax\22, @progbits"
module asm ".balign 4"
module asm ".globl _start"
module asm ".type _start, @function"
module asm "_start:"
module asm "la gp, __global_pointer$"
module asm "call main"
module asm "li a7, 93"
module asm "ecall"
module asm ".Lfunc_end__start:"
module asm ".size _start, . - _start"
module asm ".popsection"

@alloc_2e7e8fb95897d700cb0111de21c1fee5 = private unnamed_addr constant [7 x i8] c"panic!\0A", align 1
@alloc_3bb2650aa074fcfb8c10a9c40791bfbc = private unnamed_addr constant [1 x i8] c"-", align 1
@alloc_dda1ee2b88b89b9cdac753eef7988035 = private unnamed_addr constant [1 x i8] c"0", align 1
@alloc_a92a5037fa09d6cacbd422064fbd2480 = private unnamed_addr constant [7 x i8] c"dot4 = ", align 1
@alloc_49a1e817e911805af64bbc7efb390101 = private unnamed_addr constant [1 x i8] c"\0A", align 1

; __rustc::rust_begin_unwind
; Function Attrs: noreturn nounwind
define hidden void @_RNvCseLSQwpavqd5_7___rustc17rust_begin_unwind(ptr noalias noundef readonly align 8 captures(none) dereferenceable(24) %_info) unnamed_addr #0 {
start:
; call vectorize::rt::sys_write
  tail call fastcc void @_RNvNtCs9fO1vKnvLQ8_9vectorize2rt9sys_write(ptr noundef nonnull @alloc_2e7e8fb95897d700cb0111de21c1fee5, i64 noundef 7) #6
  tail call void asm sideeffect alignstack "ecall", "{x10},{x17},~{fflags},~{vtype},~{vl},~{vxsat},~{vxrm},~{memory}"(i32 134, i64 93) #6, !srcloc !3
  br label %bb2

bb2:                                              ; preds = %bb2, %start
  br label %bb2
}

; vectorize::rt::print
; Function Attrs: noinline nounwind
define internal fastcc void @_RNvNtCs9fO1vKnvLQ8_9vectorize2rt5print(ptr noalias noundef nonnull readonly captures(address, read_provenance) %s.0, i64 noundef range(i64 1, 8) %s.1) unnamed_addr #1 {
start:
; call vectorize::rt::sys_write
  tail call fastcc void @_RNvNtCs9fO1vKnvLQ8_9vectorize2rt9sys_write(ptr noundef nonnull %s.0, i64 noundef %s.1) #6
  ret void
}

; vectorize::rt::print_i64
; Function Attrs: noinline nounwind
define internal fastcc void @_RNvNtCs9fO1vKnvLQ8_9vectorize2rt9print_i64(i64 noundef range(i64 -2147483648, 2147483648) %v) unnamed_addr #1 {
start:
  %_2 = icmp slt i64 %v, 0
  br i1 %_2, label %bb1, label %bb6

bb1:                                              ; preds = %start
; call vectorize::rt::print
  tail call fastcc void @_RNvNtCs9fO1vKnvLQ8_9vectorize2rt5print(ptr noalias noundef nonnull readonly captures(address, read_provenance) @alloc_3bb2650aa074fcfb8c10a9c40791bfbc, i64 noundef 1) #6
  %_8 = sub nsw i64 0, %v
  br label %bb6

bb6:                                              ; preds = %start, %bb1
  %_8.sink = phi i64 [ %_8, %bb1 ], [ %v, %start ]
; call vectorize::rt::print_u64
  tail call fastcc void @_RNvNtCs9fO1vKnvLQ8_9vectorize2rt9print_u64(i64 noundef %_8.sink) #6
  ret void
}

; vectorize::rt::print_u64
; Function Attrs: noinline nounwind
define internal fastcc void @_RNvNtCs9fO1vKnvLQ8_9vectorize2rt9print_u64(i64 noundef range(i64 0, -9223372036854775807) %0) unnamed_addr #1 {
start:
  %buf = alloca [20 x i8], align 1
  %1 = icmp eq i64 %0, 0
  %.lcssa11.sroa.gep13 = getelementptr inbounds nuw i8, ptr %buf, i64 18
  %.lcssa11.sroa.gep14 = getelementptr inbounds nuw i8, ptr %buf, i64 17
  %.lcssa11.sroa.gep15 = getelementptr inbounds nuw i8, ptr %buf, i64 16
  %.lcssa11.sroa.gep16 = getelementptr inbounds nuw i8, ptr %buf, i64 15
  %.lcssa11.sroa.gep17 = getelementptr inbounds nuw i8, ptr %buf, i64 14
  %.lcssa11.sroa.gep18 = getelementptr inbounds nuw i8, ptr %buf, i64 13
  %.lcssa11.sroa.gep19 = getelementptr inbounds nuw i8, ptr %buf, i64 12
  %.lcssa11.sroa.gep20 = getelementptr inbounds nuw i8, ptr %buf, i64 11
  %.lcssa11.sroa.gep21 = getelementptr inbounds nuw i8, ptr %buf, i64 10
  %.lcssa11.sroa.gep22 = getelementptr inbounds nuw i8, ptr %buf, i64 9
  %.lcssa11.sroa.gep23 = getelementptr inbounds nuw i8, ptr %buf, i64 8
  %.lcssa11.sroa.gep24 = getelementptr inbounds nuw i8, ptr %buf, i64 7
  %.lcssa11.sroa.gep25 = getelementptr inbounds nuw i8, ptr %buf, i64 6
  %.lcssa11.sroa.gep26 = getelementptr inbounds nuw i8, ptr %buf, i64 5
  %.lcssa11.sroa.gep27 = getelementptr inbounds nuw i8, ptr %buf, i64 4
  %.lcssa11.sroa.gep28 = getelementptr inbounds nuw i8, ptr %buf, i64 3
  %.lcssa11.sroa.gep29 = getelementptr inbounds nuw i8, ptr %buf, i64 2
  %.lcssa11.sroa.gep30 = getelementptr inbounds nuw i8, ptr %buf, i64 1
  br i1 %1, label %bb1, label %bb3

bb1:                                              ; preds = %start
; call vectorize::rt::print
  tail call fastcc void @_RNvNtCs9fO1vKnvLQ8_9vectorize2rt5print(ptr noalias noundef nonnull readonly captures(address, read_provenance) @alloc_dda1ee2b88b89b9cdac753eef7988035, i64 noundef 1) #6
  br label %bb9

bb3:                                              ; preds = %start
  %.lcssa11.sroa.gep = getelementptr inbounds nuw i8, ptr %buf, i64 19
  call void @llvm.lifetime.start.p0(ptr nonnull %buf)
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(20) %buf, i8 0, i64 19, i1 false)
  %2 = udiv i64 %0, 10
  %3 = mul i64 %2, 10
  %_9.decomposed = sub i64 %0, %3
  %_8 = trunc nuw nsw i64 %_9.decomposed to i8
  %4 = or disjoint i8 %_8, 48
  store i8 %4, ptr %.lcssa11.sroa.gep, align 1
  %_6.not = icmp ult i64 %0, 10
  br i1 %_6.not, label %bb11, label %bb5.1

bb9:                                              ; preds = %bb11, %bb1
  ret void

bb11:                                             ; preds = %bb5.18, %bb5.17, %bb5.16, %bb5.15, %bb5.14, %bb5.13, %bb5.12, %bb5.11, %bb5.10, %bb5.9, %bb5.8, %bb5.7, %bb5.6, %bb5.5, %bb5.4, %bb5.3, %bb5.2, %bb5.1, %bb3
  %i.sroa.0.09.lcssa12.neg = phi i64 [ 1, %bb3 ], [ 2, %bb5.1 ], [ 3, %bb5.2 ], [ 4, %bb5.3 ], [ 5, %bb5.4 ], [ 6, %bb5.5 ], [ 7, %bb5.6 ], [ 8, %bb5.7 ], [ 9, %bb5.8 ], [ 10, %bb5.9 ], [ 11, %bb5.10 ], [ 12, %bb5.11 ], [ 13, %bb5.12 ], [ 14, %bb5.13 ], [ 15, %bb5.14 ], [ 16, %bb5.15 ], [ 17, %bb5.16 ], [ 18, %bb5.17 ], [ 19, %bb5.18 ]
  %.lcssa11.sroa.phi = phi ptr [ %.lcssa11.sroa.gep, %bb3 ], [ %.lcssa11.sroa.gep13, %bb5.1 ], [ %.lcssa11.sroa.gep14, %bb5.2 ], [ %.lcssa11.sroa.gep15, %bb5.3 ], [ %.lcssa11.sroa.gep16, %bb5.4 ], [ %.lcssa11.sroa.gep17, %bb5.5 ], [ %.lcssa11.sroa.gep18, %bb5.6 ], [ %.lcssa11.sroa.gep19, %bb5.7 ], [ %.lcssa11.sroa.gep20, %bb5.8 ], [ %.lcssa11.sroa.gep21, %bb5.9 ], [ %.lcssa11.sroa.gep22, %bb5.10 ], [ %.lcssa11.sroa.gep23, %bb5.11 ], [ %.lcssa11.sroa.gep24, %bb5.12 ], [ %.lcssa11.sroa.gep25, %bb5.13 ], [ %.lcssa11.sroa.gep26, %bb5.14 ], [ %.lcssa11.sroa.gep27, %bb5.15 ], [ %.lcssa11.sroa.gep28, %bb5.16 ], [ %.lcssa11.sroa.gep29, %bb5.17 ], [ %.lcssa11.sroa.gep30, %bb5.18 ]
; call vectorize::rt::sys_write
  call fastcc void @_RNvNtCs9fO1vKnvLQ8_9vectorize2rt9sys_write(ptr noundef nonnull %.lcssa11.sroa.phi, i64 noundef %i.sroa.0.09.lcssa12.neg) #6
  call void @llvm.lifetime.end.p0(ptr nonnull %buf)
  br label %bb9

bb5.1:                                            ; preds = %bb3
  %_9.1 = urem i64 %2, 10
  %_8.1 = trunc nuw nsw i64 %_9.1 to i8
  %5 = or disjoint i8 %_8.1, 48
  store i8 %5, ptr %.lcssa11.sroa.gep13, align 1
  %_6.not.1 = icmp ult i64 %0, 100
  br i1 %_6.not.1, label %bb11, label %bb5.2

bb5.2:                                            ; preds = %bb5.1
  %6 = udiv i64 %0, 100
  %_9.2 = urem i64 %6, 10
  %_8.2 = trunc nuw nsw i64 %_9.2 to i8
  %7 = or disjoint i8 %_8.2, 48
  store i8 %7, ptr %.lcssa11.sroa.gep14, align 1
  %_6.not.2 = icmp ult i64 %0, 1000
  br i1 %_6.not.2, label %bb11, label %bb5.3

bb5.3:                                            ; preds = %bb5.2
  %8 = udiv i64 %0, 1000
  %_9.3 = urem i64 %8, 10
  %_8.3 = trunc nuw nsw i64 %_9.3 to i8
  %9 = or disjoint i8 %_8.3, 48
  store i8 %9, ptr %.lcssa11.sroa.gep15, align 1
  %_6.not.3 = icmp ult i64 %0, 10000
  br i1 %_6.not.3, label %bb11, label %bb5.4

bb5.4:                                            ; preds = %bb5.3
  %10 = udiv i64 %0, 10000
  %_9.4 = urem i64 %10, 10
  %_8.4 = trunc nuw nsw i64 %_9.4 to i8
  %11 = or disjoint i8 %_8.4, 48
  store i8 %11, ptr %.lcssa11.sroa.gep16, align 1
  %_6.not.4 = icmp ult i64 %0, 100000
  br i1 %_6.not.4, label %bb11, label %bb5.5

bb5.5:                                            ; preds = %bb5.4
  %12 = udiv i64 %0, 100000
  %_9.5 = urem i64 %12, 10
  %_8.5 = trunc nuw nsw i64 %_9.5 to i8
  %13 = or disjoint i8 %_8.5, 48
  store i8 %13, ptr %.lcssa11.sroa.gep17, align 1
  %_6.not.5 = icmp ult i64 %0, 1000000
  br i1 %_6.not.5, label %bb11, label %bb5.6

bb5.6:                                            ; preds = %bb5.5
  %14 = udiv i64 %0, 1000000
  %_9.6 = urem i64 %14, 10
  %_8.6 = trunc nuw nsw i64 %_9.6 to i8
  %15 = or disjoint i8 %_8.6, 48
  store i8 %15, ptr %.lcssa11.sroa.gep18, align 1
  %_6.not.6 = icmp ult i64 %0, 10000000
  br i1 %_6.not.6, label %bb11, label %bb5.7

bb5.7:                                            ; preds = %bb5.6
  %16 = udiv i64 %0, 10000000
  %_9.7 = urem i64 %16, 10
  %_8.7 = trunc nuw nsw i64 %_9.7 to i8
  %17 = or disjoint i8 %_8.7, 48
  store i8 %17, ptr %.lcssa11.sroa.gep19, align 1
  %_6.not.7 = icmp ult i64 %0, 100000000
  br i1 %_6.not.7, label %bb11, label %bb5.8

bb5.8:                                            ; preds = %bb5.7
  %18 = udiv i64 %0, 100000000
  %_9.8 = urem i64 %18, 10
  %_8.8 = trunc nuw nsw i64 %_9.8 to i8
  %19 = or disjoint i8 %_8.8, 48
  store i8 %19, ptr %.lcssa11.sroa.gep20, align 1
  %_6.not.8 = icmp ult i64 %0, 1000000000
  br i1 %_6.not.8, label %bb11, label %bb5.9

bb5.9:                                            ; preds = %bb5.8
  %20 = udiv i64 %0, 1000000000
  %_9.9 = urem i64 %20, 10
  %_8.9 = trunc nuw nsw i64 %_9.9 to i8
  %21 = or disjoint i8 %_8.9, 48
  store i8 %21, ptr %.lcssa11.sroa.gep21, align 1
  %_6.not.9 = icmp ult i64 %0, 10000000000
  br i1 %_6.not.9, label %bb11, label %bb5.10

bb5.10:                                           ; preds = %bb5.9
  %22 = udiv i64 %0, 10000000000
  %_9.10.lhs.trunc = trunc nuw nsw i64 %22 to i32
  %_9.1033 = urem i32 %_9.10.lhs.trunc, 10
  %_8.10 = trunc nuw nsw i32 %_9.1033 to i8
  %23 = or disjoint i8 %_8.10, 48
  store i8 %23, ptr %.lcssa11.sroa.gep22, align 1
  %_6.not.10 = icmp ult i64 %0, 100000000000
  br i1 %_6.not.10, label %bb11, label %bb5.11

bb5.11:                                           ; preds = %bb5.10
  %24 = udiv i64 %0, 100000000000
  %_9.11.lhs.trunc = trunc nuw nsw i64 %24 to i32
  %_9.1134 = urem i32 %_9.11.lhs.trunc, 10
  %_8.11 = trunc nuw nsw i32 %_9.1134 to i8
  %25 = or disjoint i8 %_8.11, 48
  store i8 %25, ptr %.lcssa11.sroa.gep23, align 1
  %_6.not.11 = icmp ult i64 %0, 1000000000000
  br i1 %_6.not.11, label %bb11, label %bb5.12

bb5.12:                                           ; preds = %bb5.11
  %26 = udiv i64 %0, 1000000000000
  %_9.12.lhs.trunc = trunc nuw nsw i64 %26 to i32
  %_9.1235 = urem i32 %_9.12.lhs.trunc, 10
  %_8.12 = trunc nuw nsw i32 %_9.1235 to i8
  %27 = or disjoint i8 %_8.12, 48
  store i8 %27, ptr %.lcssa11.sroa.gep24, align 1
  %_6.not.12 = icmp ult i64 %0, 10000000000000
  br i1 %_6.not.12, label %bb11, label %bb5.13

bb5.13:                                           ; preds = %bb5.12
  %28 = udiv i64 %0, 10000000000000
  %_9.13.lhs.trunc = trunc nuw nsw i64 %28 to i32
  %_9.1336 = urem i32 %_9.13.lhs.trunc, 10
  %_8.13 = trunc nuw nsw i32 %_9.1336 to i8
  %29 = or disjoint i8 %_8.13, 48
  store i8 %29, ptr %.lcssa11.sroa.gep25, align 1
  %_6.not.13 = icmp ult i64 %0, 100000000000000
  br i1 %_6.not.13, label %bb11, label %bb5.14

bb5.14:                                           ; preds = %bb5.13
  %30 = udiv i64 %0, 100000000000000
  %_9.14.lhs.trunc = trunc nuw nsw i64 %30 to i32
  %_9.1437 = urem i32 %_9.14.lhs.trunc, 10
  %_8.14 = trunc nuw nsw i32 %_9.1437 to i8
  %31 = or disjoint i8 %_8.14, 48
  store i8 %31, ptr %.lcssa11.sroa.gep26, align 1
  %_6.not.14 = icmp ult i64 %0, 1000000000000000
  br i1 %_6.not.14, label %bb11, label %bb5.15

bb5.15:                                           ; preds = %bb5.14
  %32 = udiv i64 %0, 1000000000000000
  %_9.15.lhs.trunc = trunc nuw nsw i64 %32 to i16
  %_9.1538 = urem i16 %_9.15.lhs.trunc, 10
  %_8.15 = trunc nuw nsw i16 %_9.1538 to i8
  %33 = or disjoint i8 %_8.15, 48
  store i8 %33, ptr %.lcssa11.sroa.gep27, align 1
  %_6.not.15 = icmp ult i64 %0, 10000000000000000
  br i1 %_6.not.15, label %bb11, label %bb5.16

bb5.16:                                           ; preds = %bb5.15
  %34 = udiv i64 %0, 10000000000000000
  %_9.16.lhs.trunc = trunc nuw nsw i64 %34 to i16
  %_9.1639 = urem i16 %_9.16.lhs.trunc, 10
  %_8.16 = trunc nuw nsw i16 %_9.1639 to i8
  %35 = or disjoint i8 %_8.16, 48
  store i8 %35, ptr %.lcssa11.sroa.gep28, align 1
  %_6.not.16 = icmp ult i64 %0, 100000000000000000
  br i1 %_6.not.16, label %bb11, label %bb5.17

bb5.17:                                           ; preds = %bb5.16
  %36 = udiv i64 %0, 100000000000000000
  %_9.17.lhs.trunc = trunc nuw i64 %36 to i8
  %_9.1740 = urem i8 %_9.17.lhs.trunc, 10
  %37 = or disjoint i8 %_9.1740, 48
  store i8 %37, ptr %.lcssa11.sroa.gep29, align 1
  %_6.not.17 = icmp ult i64 %0, 1000000000000000000
  br i1 %_6.not.17, label %bb11, label %bb5.18

bb5.18:                                           ; preds = %bb5.17
  %38 = udiv i64 %0, 1000000000000000000
  %_8.18 = trunc nuw nsw i64 %38 to i8
  %39 = or disjoint i8 %_8.18, 48
  store i8 %39, ptr %.lcssa11.sroa.gep30, align 1
  br label %bb11
}

; vectorize::rt::sys_write
; Function Attrs: noinline nounwind
define internal fastcc void @_RNvNtCs9fO1vKnvLQ8_9vectorize2rt9sys_write(ptr noundef %buf, i64 noundef %len) unnamed_addr #1 {
start:
  %0 = tail call i64 asm sideeffect alignstack "ecall", "={x10},{x10},{x11},{x12},{x17},~{fflags},~{vtype},~{vl},~{vxsat},~{vxrm},~{memory}"(i64 1, ptr %buf, i64 %len, i64 64) #6, !srcloc !4
  ret void
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind willreturn memory(argmem: read)
define dso_local noundef i32 @dot4(ptr noalias noundef readonly align 4 captures(none) dereferenceable(16) %a, ptr noalias noundef readonly align 4 captures(none) dereferenceable(16) %b) unnamed_addr #2 {
start:
  %_6 = load i32, ptr %a, align 4, !noundef !5
  %_8 = load i32, ptr %b, align 4, !noundef !5
  %_5 = mul i32 %_8, %_6
  %0 = getelementptr inbounds nuw i8, ptr %a, i64 4
  %_6.1 = load i32, ptr %0, align 4, !noundef !5
  %1 = getelementptr inbounds nuw i8, ptr %b, i64 4
  %_8.1 = load i32, ptr %1, align 4, !noundef !5
  %_5.1 = mul i32 %_8.1, %_6.1
  %2 = add i32 %_5.1, %_5
  %3 = getelementptr inbounds nuw i8, ptr %a, i64 8
  %_6.2 = load i32, ptr %3, align 4, !noundef !5
  %4 = getelementptr inbounds nuw i8, ptr %b, i64 8
  %_8.2 = load i32, ptr %4, align 4, !noundef !5
  %_5.2 = mul i32 %_8.2, %_6.2
  %5 = add i32 %_5.2, %2
  %6 = getelementptr inbounds nuw i8, ptr %a, i64 12
  %_6.3 = load i32, ptr %6, align 4, !noundef !5
  %7 = getelementptr inbounds nuw i8, ptr %b, i64 12
  %_8.3 = load i32, ptr %7, align 4, !noundef !5
  %_5.3 = mul i32 %_8.3, %_6.3
  %8 = add i32 %_5.3, %5
  ret i32 %8
}

; Function Attrs: nounwind
define dso_local noundef signext i32 @main() unnamed_addr #3 {
start:
  %b = alloca [16 x i8], align 4
  %a = alloca [16 x i8], align 4
  call void @llvm.lifetime.start.p0(ptr nonnull %a)
  store i32 1, ptr %a, align 4
  %0 = getelementptr inbounds nuw i8, ptr %a, i64 4
  store i32 2, ptr %0, align 4
  %1 = getelementptr inbounds nuw i8, ptr %a, i64 8
  store i32 3, ptr %1, align 4
  %2 = getelementptr inbounds nuw i8, ptr %a, i64 12
  store i32 4, ptr %2, align 4
  call void @llvm.lifetime.start.p0(ptr nonnull %b)
  store i32 5, ptr %b, align 4
  %3 = getelementptr inbounds nuw i8, ptr %b, i64 4
  store i32 6, ptr %3, align 4
  %4 = getelementptr inbounds nuw i8, ptr %b, i64 8
  store i32 7, ptr %4, align 4
  %5 = getelementptr inbounds nuw i8, ptr %b, i64 12
  store i32 8, ptr %5, align 4
; call vectorize::rt::print
  tail call fastcc void @_RNvNtCs9fO1vKnvLQ8_9vectorize2rt5print(ptr noalias noundef nonnull readonly captures(address, read_provenance) @alloc_a92a5037fa09d6cacbd422064fbd2480, i64 noundef 7) #6
  %_6 = call noundef i32 @dot4(ptr noalias noundef nonnull readonly align 4 captures(address, read_provenance) dereferenceable(16) %a, ptr noalias noundef nonnull readonly align 4 captures(address, read_provenance) dereferenceable(16) %b) #6
  %_5 = sext i32 %_6 to i64
; call vectorize::rt::print_i64
  tail call fastcc void @_RNvNtCs9fO1vKnvLQ8_9vectorize2rt9print_i64(i64 noundef %_5) #6
; call vectorize::rt::print
  tail call fastcc void @_RNvNtCs9fO1vKnvLQ8_9vectorize2rt5print(ptr noalias noundef nonnull readonly captures(address, read_provenance) @alloc_49a1e817e911805af64bbc7efb390101, i64 noundef 1) #6
  call void @llvm.lifetime.end.p0(ptr nonnull %b)
  call void @llvm.lifetime.end.p0(ptr nonnull %a)
  ret i32 0
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(ptr captures(none)) #4

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #5

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(ptr captures(none)) #4

attributes #0 = { noreturn nounwind "target-cpu"="generic-rv64" "target-features"="+m,+a,+zaamo,+zalrsc,+f,+zicsr,+d,+f,+zicsr,+c,+zca,+zicsr,+zifencei" }
attributes #1 = { noinline nounwind "target-cpu"="generic-rv64" "target-features"="+m,+a,+zaamo,+zalrsc,+f,+zicsr,+d,+f,+zicsr,+c,+zca,+zicsr,+zifencei" }
attributes #2 = { mustprogress nofree noinline norecurse nosync nounwind willreturn memory(argmem: read) "target-cpu"="generic-rv64" "target-features"="+m,+a,+zaamo,+zalrsc,+f,+zicsr,+d,+f,+zicsr,+c,+zca,+zicsr,+zifencei" }
attributes #3 = { nounwind "target-cpu"="generic-rv64" "target-features"="+m,+a,+zaamo,+zalrsc,+f,+zicsr,+d,+f,+zicsr,+c,+zca,+zicsr,+zifencei" }
attributes #4 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #5 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #6 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"Code Model", i32 3}
!1 = !{i32 1, !"target-abi", !"lp64d"}
!2 = !{!"rustc version 1.98.0-nightly (23a3312d9 2026-05-23)"}
!3 = !{i64 9290014263406}
!4 = !{i64 5574867551501}
!5 = !{}
