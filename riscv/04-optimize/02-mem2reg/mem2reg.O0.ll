; ModuleID = '02-mem2reg/mem2reg.c'
source_filename = "02-mem2reg/mem2reg.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "riscv64-unknown-unknown-elf"

@.str = private unnamed_addr constant [11 x i8] c"fib(10) = \00", align 1
@.str.1 = private unnamed_addr constant [12 x i8] c"\0Afib(20) = \00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"-\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"0\00", align 1

; Function Attrs: noinline nounwind optnone
define dso_local signext i32 @fib(i32 noundef signext %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  store i32 0, ptr %3, align 4
  store i32 1, ptr %4, align 4
  store i32 0, ptr %5, align 4
  br label %7

7:                                                ; preds = %17, %1
  %8 = load i32, ptr %5, align 4
  %9 = load i32, ptr %2, align 4
  %10 = icmp slt i32 %8, %9
  br i1 %10, label %11, label %20

11:                                               ; preds = %7
  %12 = load i32, ptr %3, align 4
  %13 = load i32, ptr %4, align 4
  %14 = add nsw i32 %12, %13
  store i32 %14, ptr %6, align 4
  %15 = load i32, ptr %4, align 4
  store i32 %15, ptr %3, align 4
  %16 = load i32, ptr %6, align 4
  store i32 %16, ptr %4, align 4
  br label %17

17:                                               ; preds = %11
  %18 = load i32, ptr %5, align 4
  %19 = add nsw i32 %18, 1
  store i32 %19, ptr %5, align 4
  br label %7, !llvm.loop !7

20:                                               ; preds = %7
  %21 = load i32, ptr %3, align 4
  ret i32 %21
}

; Function Attrs: noinline nounwind optnone
define dso_local void @_start() #0 {
  call void @print(ptr noundef @.str) #1
  %1 = call signext i32 @fib(i32 noundef signext 10) #1
  %2 = sext i32 %1 to i64
  call void @print_i64(i64 noundef %2) #1
  call void @print(ptr noundef @.str.1) #1
  %3 = call signext i32 @fib(i32 noundef signext 20) #1
  %4 = sext i32 %3 to i64
  call void @print_i64(i64 noundef %4) #1
  call void @print(ptr noundef @.str.2) #1
  call void @sys_exit(i32 noundef signext 0) #1
  ret void
}

; Function Attrs: noinline nounwind optnone
define internal void @print(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  store ptr %0, ptr %2, align 8
  store i64 0, ptr %3, align 8
  br label %4

4:                                                ; preds = %10, %1
  %5 = load ptr, ptr %2, align 8
  %6 = load i64, ptr %3, align 8
  %7 = getelementptr inbounds nuw i8, ptr %5, i64 %6
  %8 = load i8, ptr %7, align 1
  %9 = icmp ne i8 %8, 0
  br i1 %9, label %10, label %13

10:                                               ; preds = %4
  %11 = load i64, ptr %3, align 8
  %12 = add i64 %11, 1
  store i64 %12, ptr %3, align 8
  br label %4, !llvm.loop !9

13:                                               ; preds = %4
  %14 = load ptr, ptr %2, align 8
  %15 = load i64, ptr %3, align 8
  %16 = call i64 @sys_write(i32 noundef signext 1, ptr noundef %14, i64 noundef %15) #1
  ret void
}

; Function Attrs: noinline nounwind optnone
define internal void @print_i64(i64 noundef %0) #0 {
  %2 = alloca i64, align 8
  %3 = alloca [20 x i8], align 1
  %4 = alloca i32, align 4
  store i64 %0, ptr %2, align 8
  store i32 20, ptr %4, align 4
  %5 = load i64, ptr %2, align 8
  %6 = icmp slt i64 %5, 0
  br i1 %6, label %7, label %11

7:                                                ; preds = %1
  %8 = call i64 @sys_write(i32 noundef signext 1, ptr noundef @.str.3, i64 noundef 1) #1
  %9 = load i64, ptr %2, align 8
  %10 = sub nsw i64 0, %9
  store i64 %10, ptr %2, align 8
  br label %11

11:                                               ; preds = %7, %1
  %12 = load i64, ptr %2, align 8
  %13 = icmp eq i64 %12, 0
  br i1 %13, label %14, label %16

14:                                               ; preds = %11
  %15 = call i64 @sys_write(i32 noundef signext 1, ptr noundef @.str.4, i64 noundef 1) #1
  br label %41

16:                                               ; preds = %11
  br label %17

17:                                               ; preds = %20, %16
  %18 = load i64, ptr %2, align 8
  %19 = icmp sgt i64 %18, 0
  br i1 %19, label %20, label %32

20:                                               ; preds = %17
  %21 = load i64, ptr %2, align 8
  %22 = srem i64 %21, 10
  %23 = trunc i64 %22 to i32
  %24 = add nsw i32 48, %23
  %25 = trunc i32 %24 to i8
  %26 = load i32, ptr %4, align 4
  %27 = add nsw i32 %26, -1
  store i32 %27, ptr %4, align 4
  %28 = sext i32 %27 to i64
  %29 = getelementptr inbounds [20 x i8], ptr %3, i64 0, i64 %28
  store i8 %25, ptr %29, align 1
  %30 = load i64, ptr %2, align 8
  %31 = sdiv i64 %30, 10
  store i64 %31, ptr %2, align 8
  br label %17, !llvm.loop !10

32:                                               ; preds = %17
  %33 = getelementptr inbounds [20 x i8], ptr %3, i64 0, i64 0
  %34 = load i32, ptr %4, align 4
  %35 = sext i32 %34 to i64
  %36 = getelementptr inbounds i8, ptr %33, i64 %35
  %37 = load i32, ptr %4, align 4
  %38 = sext i32 %37 to i64
  %39 = sub i64 20, %38
  %40 = call i64 @sys_write(i32 noundef signext 1, ptr noundef %36, i64 noundef %39) #1
  br label %41

41:                                               ; preds = %32, %14
  ret void
}

; Function Attrs: noinline nounwind optnone
define internal void @sys_exit(i32 noundef signext %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store i32 %0, ptr %2, align 4
  %5 = load i32, ptr %2, align 4
  %6 = sext i32 %5 to i64
  store i64 %6, ptr %3, align 8
  store i64 93, ptr %4, align 8
  %7 = load i64, ptr %3, align 8
  %8 = load i64, ptr %4, align 8
  call void asm sideeffect "ecall", "{x10},{x17},~{memory}"(i64 %7, i64 %8) #2, !srcloc !11
  unreachable
}

; Function Attrs: noinline nounwind optnone
define internal i64 @sys_write(i32 noundef signext %0, ptr noundef %1, i64 noundef %2) #0 {
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  %8 = alloca ptr, align 8
  %9 = alloca i64, align 8
  %10 = alloca i64, align 8
  store i32 %0, ptr %4, align 4
  store ptr %1, ptr %5, align 8
  store i64 %2, ptr %6, align 8
  %11 = load i32, ptr %4, align 4
  %12 = sext i32 %11 to i64
  store i64 %12, ptr %7, align 8
  %13 = load ptr, ptr %5, align 8
  store ptr %13, ptr %8, align 8
  %14 = load i64, ptr %6, align 8
  store i64 %14, ptr %9, align 8
  store i64 64, ptr %10, align 8
  %15 = load i64, ptr %7, align 8
  %16 = load ptr, ptr %8, align 8
  %17 = load i64, ptr %9, align 8
  %18 = load i64, ptr %10, align 8
  %19 = call i64 asm sideeffect "ecall", "={x10},{x11},{x12},{x17},{x10},~{memory}"(ptr %16, i64 %17, i64 %18, i64 %15) #2, !srcloc !12
  store i64 %19, ptr %7, align 8
  %20 = load i64, ptr %7, align 8
  ret i64 %20
}

attributes #0 = { noinline nounwind optnone "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv64" "target-features"="+64bit,+a,+c,+d,+f,+i,+m,+relax,+zaamo,+zalrsc,+zca,+zcd,+zicsr,+zifencei,+zmmul,-b,-e,-experimental-p,-experimental-smpmpmt,-experimental-svukte,-experimental-xrivosvisni,-experimental-xrivosvizip,-experimental-xsfmclic,-experimental-xsfsclic,-experimental-zibi,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvfbfa,-experimental-zvfofp8min,-experimental-zvkgs,-experimental-zvqdotq,-h,-q,-sdext,-sdtrig,-sha,-shcounterenw,-shgatpa,-shlcofideleg,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcntrpmf,-smcsrind,-smctr,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssctr,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xandesbfhcvt,-xandesperf,-xandesvbfhcvt,-xandesvdot,-xandesvpackfph,-xandesvsinth,-xandesvsintload,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xmipscbop,-xmipscmov,-xmipsexectl,-xmipslsp,-xqccmp,-xqci,-xqcia,-xqciac,-xqcibi,-xqcibm,-xqcicli,-xqcicm,-xqcics,-xqcicsr,-xqciint,-xqciio,-xqcilb,-xqcili,-xqcilia,-xqcilo,-xqcilsm,-xqcisim,-xqcisls,-xqcisync,-xsfcease,-xsfmm128t,-xsfmm16t,-xsfmm32a16f,-xsfmm32a32f,-xsfmm32a8f,-xsfmm32a8i,-xsfmm32t,-xsfmm64a64f,-xsfmm64t,-xsfmmbase,-xsfvcp,-xsfvfbfexp16e,-xsfvfexp16e,-xsfvfexp32e,-xsfvfexpa,-xsfvfexpa64e,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xsmtvdot,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zabha,-zacas,-zalasr,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zcb,-zce,-zcf,-zclsd,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zfinx,-zhinx,-zhinxmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccamoc,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zihintntl,-zihintpause,-zihpm,-zilsd,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #1 = { nobuiltin "no-builtins" }
attributes #2 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !4, !5}
!llvm.ident = !{!6}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"target-abi", !"lp64d"}
!2 = !{i32 6, !"riscv-isa", !3}
!3 = !{!"rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{i32 8, !"SmallDataLimit", i32 0}
!6 = !{!"Homebrew clang version 22.1.4"}
!7 = distinct !{!7, !8}
!8 = !{!"llvm.loop.mustprogress"}
!9 = distinct !{!9, !8}
!10 = distinct !{!10, !8}
!11 = !{i64 19466}
!12 = !{i64 19199}
