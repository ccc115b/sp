; ModuleID = '04-loop-unroll/unroll.ll'
source_filename = "unroll.7c82aba3242b202e-cgu.0"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "riscv64-unknown-unknown-elf"

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
@alloc_29d78056cfe802458b95f77e2827b831 = private unnamed_addr constant [18 x i8] c"sum_squares(10) = ", align 1
@alloc_6dee07d88b55a8eb1972920b03a2e53b = private unnamed_addr constant [15 x i8] c"\0Ascale_array = ", align 1
@alloc_49a1e817e911805af64bbc7efb390101 = private unnamed_addr constant [1 x i8] c"\0A", align 1

; Function Attrs: noreturn nounwind
define hidden void @_RNvCseLSQwpavqd5_7___rustc17rust_begin_unwind(ptr noalias noundef readonly align 8 captures(none) dereferenceable(24) %_info) unnamed_addr #0 {
start:
  tail call fastcc void @_RNvNtCsaGLuUiz9WQ4_6unroll2rt9sys_write(ptr noundef nonnull @alloc_2e7e8fb95897d700cb0111de21c1fee5, i64 noundef 7) #7
  tail call void asm sideeffect alignstack "ecall", "{x10},{x17},~{fflags},~{vtype},~{vl},~{vxsat},~{vxrm},~{memory}"(i32 134, i64 93) #7, !srcloc !3
  br label %bb2

bb2:                                              ; preds = %bb2, %start
  br label %bb2
}

; Function Attrs: noinline nounwind
define internal fastcc void @_RNvNtCsaGLuUiz9WQ4_6unroll2rt5print(ptr noalias noundef nonnull readonly captures(address, read_provenance) %s.0, i64 noundef range(i64 1, 19) %s.1) unnamed_addr #1 {
start:
  tail call fastcc void @_RNvNtCsaGLuUiz9WQ4_6unroll2rt9sys_write(ptr noundef nonnull %s.0, i64 noundef %s.1) #7
  ret void
}

; Function Attrs: noinline nounwind
define internal fastcc void @_RNvNtCsaGLuUiz9WQ4_6unroll2rt9print_i64(i64 noundef range(i64 -2147483648, 2147483648) %v) unnamed_addr #1 {
start:
  %_2 = icmp slt i64 %v, 0
  br i1 %_2, label %bb1, label %bb6

bb1:                                              ; preds = %start
  tail call fastcc void @_RNvNtCsaGLuUiz9WQ4_6unroll2rt5print(ptr noalias noundef nonnull readonly captures(address, read_provenance) @alloc_3bb2650aa074fcfb8c10a9c40791bfbc, i64 noundef 1) #7
  %_8 = sub nsw i64 0, %v
  br label %bb6

bb6:                                              ; preds = %bb1, %start
  %_8.sink = phi i64 [ %_8, %bb1 ], [ %v, %start ]
  tail call fastcc void @_RNvNtCsaGLuUiz9WQ4_6unroll2rt9print_u64(i64 noundef %_8.sink) #7
  ret void
}

; Function Attrs: noinline nounwind
define internal fastcc void @_RNvNtCsaGLuUiz9WQ4_6unroll2rt9print_u64(i64 noundef range(i64 0, 2147483649) %0) unnamed_addr #1 {
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
  br i1 %1, label %bb1, label %bb3

bb1:                                              ; preds = %start
  tail call fastcc void @_RNvNtCsaGLuUiz9WQ4_6unroll2rt5print(ptr noalias noundef nonnull readonly captures(address, read_provenance) @alloc_dda1ee2b88b89b9cdac753eef7988035, i64 noundef 1) #7
  br label %bb9

bb3:                                              ; preds = %start
  %.lcssa11.sroa.gep = getelementptr inbounds nuw i8, ptr %buf, i64 19
  call void @llvm.lifetime.start.p0(ptr nonnull %buf)
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(20) %buf, i8 0, i64 19, i1 false)
  %_9.lhs.trunc = trunc nuw i64 %0 to i32
  %2 = udiv i32 %_9.lhs.trunc, 10
  %3 = mul i32 %2, 10
  %_933.decomposed = sub i32 %_9.lhs.trunc, %3
  %_8 = trunc nuw nsw i32 %_933.decomposed to i8
  %4 = or disjoint i8 %_8, 48
  store i8 %4, ptr %.lcssa11.sroa.gep, align 1
  %_6.not = icmp samesign ult i64 %0, 10
  br i1 %_6.not, label %bb11, label %bb5.1

bb9:                                              ; preds = %bb11, %bb1
  ret void

bb11:                                             ; preds = %bb5.9, %bb5.8, %bb5.7, %bb5.6, %bb5.5, %bb5.4, %bb5.3, %bb5.2, %bb5.1, %bb3
  %i.sroa.0.09.lcssa12.neg = phi i64 [ 1, %bb3 ], [ 2, %bb5.1 ], [ 3, %bb5.2 ], [ 4, %bb5.3 ], [ 5, %bb5.4 ], [ 6, %bb5.5 ], [ 7, %bb5.6 ], [ 8, %bb5.7 ], [ 9, %bb5.8 ], [ 10, %bb5.9 ]
  %.lcssa11.sroa.phi = phi ptr [ %.lcssa11.sroa.gep, %bb3 ], [ %.lcssa11.sroa.gep13, %bb5.1 ], [ %.lcssa11.sroa.gep14, %bb5.2 ], [ %.lcssa11.sroa.gep15, %bb5.3 ], [ %.lcssa11.sroa.gep16, %bb5.4 ], [ %.lcssa11.sroa.gep17, %bb5.5 ], [ %.lcssa11.sroa.gep18, %bb5.6 ], [ %.lcssa11.sroa.gep19, %bb5.7 ], [ %.lcssa11.sroa.gep20, %bb5.8 ], [ %.lcssa11.sroa.gep21, %bb5.9 ]
  call fastcc void @_RNvNtCsaGLuUiz9WQ4_6unroll2rt9sys_write(ptr noundef nonnull %.lcssa11.sroa.phi, i64 noundef %i.sroa.0.09.lcssa12.neg) #7
  call void @llvm.lifetime.end.p0(ptr nonnull %buf)
  br label %bb9

bb5.1:                                            ; preds = %bb3
  %_9.134 = urem i32 %2, 10
  %_8.1 = trunc nuw nsw i32 %_9.134 to i8
  %5 = or disjoint i8 %_8.1, 48
  store i8 %5, ptr %.lcssa11.sroa.gep13, align 1
  %_6.not.1 = icmp samesign ult i64 %0, 100
  br i1 %_6.not.1, label %bb11, label %bb5.2

bb5.2:                                            ; preds = %bb5.1
  %6 = udiv i32 %_9.lhs.trunc, 100
  %_9.237 = urem i32 %6, 10
  %_8.2 = trunc nuw nsw i32 %_9.237 to i8
  %7 = or disjoint i8 %_8.2, 48
  store i8 %7, ptr %.lcssa11.sroa.gep14, align 1
  %_6.not.2 = icmp samesign ult i64 %0, 1000
  br i1 %_6.not.2, label %bb11, label %bb5.3

bb5.3:                                            ; preds = %bb5.2
  %8 = udiv i32 %_9.lhs.trunc, 1000
  %_9.340 = urem i32 %8, 10
  %_8.3 = trunc nuw nsw i32 %_9.340 to i8
  %9 = or disjoint i8 %_8.3, 48
  store i8 %9, ptr %.lcssa11.sroa.gep15, align 1
  %_6.not.3 = icmp samesign ult i64 %0, 10000
  br i1 %_6.not.3, label %bb11, label %bb5.4

bb5.4:                                            ; preds = %bb5.3
  %10 = udiv i32 %_9.lhs.trunc, 10000
  %_9.443 = urem i32 %10, 10
  %_8.4 = trunc nuw nsw i32 %_9.443 to i8
  %11 = or disjoint i8 %_8.4, 48
  store i8 %11, ptr %.lcssa11.sroa.gep16, align 1
  %_6.not.4 = icmp samesign ult i64 %0, 100000
  br i1 %_6.not.4, label %bb11, label %bb5.5

bb5.5:                                            ; preds = %bb5.4
  %12 = udiv i32 %_9.lhs.trunc, 100000
  %_9.5.lhs.trunc = trunc nuw nsw i32 %12 to i16
  %_9.546 = urem i16 %_9.5.lhs.trunc, 10
  %_8.5 = trunc nuw nsw i16 %_9.546 to i8
  %13 = or disjoint i8 %_8.5, 48
  store i8 %13, ptr %.lcssa11.sroa.gep17, align 1
  %_6.not.5 = icmp samesign ult i64 %0, 1000000
  br i1 %_6.not.5, label %bb11, label %bb5.6

bb5.6:                                            ; preds = %bb5.5
  %14 = udiv i32 %_9.lhs.trunc, 1000000
  %_9.6.lhs.trunc = trunc nuw nsw i32 %14 to i16
  %_9.649 = urem i16 %_9.6.lhs.trunc, 10
  %_8.6 = trunc nuw nsw i16 %_9.649 to i8
  %15 = or disjoint i8 %_8.6, 48
  store i8 %15, ptr %.lcssa11.sroa.gep18, align 1
  %_6.not.6 = icmp samesign ult i64 %0, 10000000
  br i1 %_6.not.6, label %bb11, label %bb5.7

bb5.7:                                            ; preds = %bb5.6
  %16 = udiv i32 %_9.lhs.trunc, 10000000
  %_9.7.lhs.trunc = trunc nuw i32 %16 to i8
  %_9.752 = urem i8 %_9.7.lhs.trunc, 10
  %17 = or disjoint i8 %_9.752, 48
  store i8 %17, ptr %.lcssa11.sroa.gep19, align 1
  %_6.not.7 = icmp samesign ult i64 %0, 100000000
  br i1 %_6.not.7, label %bb11, label %bb5.8

bb5.8:                                            ; preds = %bb5.7
  %18 = udiv i32 %_9.lhs.trunc, 100000000
  %_9.8.lhs.trunc = trunc nuw nsw i32 %18 to i8
  %_9.855 = urem i8 %_9.8.lhs.trunc, 10
  %19 = or disjoint i8 %_9.855, 48
  store i8 %19, ptr %.lcssa11.sroa.gep20, align 1
  %_6.not.8 = icmp samesign ult i64 %0, 1000000000
  br i1 %_6.not.8, label %bb11, label %bb5.9

bb5.9:                                            ; preds = %bb5.8
  %20 = udiv i32 %_9.lhs.trunc, 1000000000
  %_8.9 = trunc nuw nsw i32 %20 to i8
  %21 = or disjoint i8 %_8.9, 48
  store i8 %21, ptr %.lcssa11.sroa.gep21, align 1
  br label %bb11
}

; Function Attrs: noinline nounwind
define internal fastcc void @_RNvNtCsaGLuUiz9WQ4_6unroll2rt9sys_write(ptr noundef %buf, i64 noundef %len) unnamed_addr #1 {
start:
  %0 = tail call i64 asm sideeffect alignstack "ecall", "={x10},{x10},{x11},{x12},{x17},~{fflags},~{vtype},~{vl},~{vxsat},~{vxrm},~{memory}"(i64 1, ptr %buf, i64 %len, i64 64) #7, !srcloc !4
  ret void
}

; Function Attrs: nounwind
define dso_local noundef signext i32 @main() unnamed_addr #2 {
start:
  %arr = alloca [32 x i8], align 4
  call void @llvm.lifetime.start.p0(ptr nonnull %arr)
  store i32 1, ptr %arr, align 4
  %0 = getelementptr inbounds nuw i8, ptr %arr, i64 4
  store i32 2, ptr %0, align 4
  %1 = getelementptr inbounds nuw i8, ptr %arr, i64 8
  store i32 3, ptr %1, align 4
  %2 = getelementptr inbounds nuw i8, ptr %arr, i64 12
  store i32 4, ptr %2, align 4
  %3 = getelementptr inbounds nuw i8, ptr %arr, i64 16
  store i32 5, ptr %3, align 4
  %4 = getelementptr inbounds nuw i8, ptr %arr, i64 20
  store i32 6, ptr %4, align 4
  %5 = getelementptr inbounds nuw i8, ptr %arr, i64 24
  store i32 7, ptr %5, align 4
  %6 = getelementptr inbounds nuw i8, ptr %arr, i64 28
  store i32 8, ptr %6, align 4
  tail call fastcc void @_RNvNtCsaGLuUiz9WQ4_6unroll2rt5print(ptr noalias noundef nonnull readonly captures(address, read_provenance) @alloc_29d78056cfe802458b95f77e2827b831, i64 noundef 18) #7
  %_5 = tail call noundef i32 @sum_squares(i32 noundef signext 10) #7
  %_4 = sext i32 %_5 to i64
  tail call fastcc void @_RNvNtCsaGLuUiz9WQ4_6unroll2rt9print_i64(i64 noundef %_4) #7
  tail call fastcc void @_RNvNtCsaGLuUiz9WQ4_6unroll2rt5print(ptr noalias noundef nonnull readonly captures(address, read_provenance) @alloc_6dee07d88b55a8eb1972920b03a2e53b, i64 noundef 15) #7
  %_9 = call noundef i32 @scale_array(ptr noalias noundef nonnull readonly align 4 captures(address, read_provenance) %arr, i64 noundef 8) #7
  %_8 = sext i32 %_9 to i64
  call fastcc void @_RNvNtCsaGLuUiz9WQ4_6unroll2rt9print_i64(i64 noundef %_8) #7
  call fastcc void @_RNvNtCsaGLuUiz9WQ4_6unroll2rt5print(ptr noalias noundef nonnull readonly captures(address, read_provenance) @alloc_49a1e817e911805af64bbc7efb390101, i64 noundef 1) #7
  call void @llvm.lifetime.end.p0(ptr nonnull %arr)
  ret i32 0
}

; Function Attrs: nofree noinline norecurse nosync nounwind memory(argmem: read)
define dso_local noundef i32 @scale_array(ptr noalias noundef nonnull readonly align 4 captures(address) %a.0, i64 noundef range(i64 0, 2305843009213693952) %a.1) unnamed_addr #3 {
start:
  %_11.idx = shl nuw nsw i64 %a.1, 2
  %_11 = getelementptr inbounds nuw i8, ptr %a.0, i64 %_11.idx
  %_182 = icmp eq i64 %a.1, 0
  br i1 %_182, label %bb2, label %bb3

bb3:                                              ; preds = %start, %bb3
  %s.sroa.0.04 = phi i32 [ %0, %bb3 ], [ 0, %start ]
  %iter.sroa.0.03 = phi ptr [ %_24, %bb3 ], [ %a.0, %start ]
  %_24 = getelementptr inbounds nuw i8, ptr %iter.sroa.0.03, i64 4
  %x = load i32, ptr %iter.sroa.0.03, align 4, !noundef !5
  %_5 = shl i32 %x, 2
  %0 = add i32 %_5, %s.sroa.0.04
  %_18 = icmp eq ptr %_24, %_11
  br i1 %_18, label %bb2, label %bb3

bb2:                                              ; preds = %bb3, %start
  %s.sroa.0.0.lcssa = phi i32 [ 0, %start ], [ %0, %bb3 ]
  ret i32 %s.sroa.0.0.lcssa
}

; Function Attrs: nofree noinline norecurse nosync nounwind memory(none)
define dso_local noundef i32 @sum_squares(i32 noundef signext %n) unnamed_addr #4 {
start:
  %_0.i.not.i11 = icmp slt i32 %n, 1
  br i1 %_0.i.not.i11, label %bb4, label %bb2.i

bb2.i:                                            ; preds = %start, %bb2.i
  %s.sroa.0.013 = phi i32 [ %1, %bb2.i ], [ 0, %start ]
  %iter.sroa.0.012 = phi i32 [ %spec.select10, %bb2.i ], [ 1, %start ]
  %_0.i3.i = icmp sge i32 %iter.sroa.0.012, %n
  %not._0.i3.i = xor i1 %_0.i3.i, true
  %0 = zext i1 %not._0.i3.i to i32
  %spec.select10 = add nuw nsw i32 %iter.sroa.0.012, %0
  %_8 = mul i32 %iter.sroa.0.012, %iter.sroa.0.012
  %1 = add i32 %_8, %s.sroa.0.013
  %_0.i.not.i = icmp sgt i32 %spec.select10, %n
  %or.cond = select i1 %_0.i3.i, i1 true, i1 %_0.i.not.i
  br i1 %or.cond, label %bb4, label %bb2.i

bb4:                                              ; preds = %bb2.i, %start
  %s.sroa.0.0.lcssa = phi i32 [ 0, %start ], [ %1, %bb2.i ]
  ret i32 %s.sroa.0.0.lcssa
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(ptr captures(none)) #5

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #6

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(ptr captures(none)) #5

attributes #0 = { noreturn nounwind "target-cpu"="generic-rv64" "target-features"="+m,+a,+zaamo,+zalrsc,+f,+zicsr,+d,+f,+zicsr,+c,+zca,+zicsr,+zifencei" }
attributes #1 = { noinline nounwind "target-cpu"="generic-rv64" "target-features"="+m,+a,+zaamo,+zalrsc,+f,+zicsr,+d,+f,+zicsr,+c,+zca,+zicsr,+zifencei" }
attributes #2 = { nounwind "target-cpu"="generic-rv64" "target-features"="+m,+a,+zaamo,+zalrsc,+f,+zicsr,+d,+f,+zicsr,+c,+zca,+zicsr,+zifencei" }
attributes #3 = { nofree noinline norecurse nosync nounwind memory(argmem: read) "target-cpu"="generic-rv64" "target-features"="+m,+a,+zaamo,+zalrsc,+f,+zicsr,+d,+f,+zicsr,+c,+zca,+zicsr,+zifencei" }
attributes #4 = { nofree noinline norecurse nosync nounwind memory(none) "target-cpu"="generic-rv64" "target-features"="+m,+a,+zaamo,+zalrsc,+f,+zicsr,+d,+f,+zicsr,+c,+zca,+zicsr,+zifencei" }
attributes #5 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #6 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #7 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"Code Model", i32 3}
!1 = !{i32 1, !"target-abi", !"lp64d"}
!2 = !{!"rustc version 1.98.0-nightly (23a3312d9 2026-05-23)"}
!3 = !{i64 10136122820915}
!4 = !{i64 6420976109010}
!5 = !{}
