; ModuleID = '04-loop-unroll/unroll.c'
source_filename = "04-loop-unroll/unroll.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "riscv64-unknown-unknown-elf"

@__const._start.arr = private unnamed_addr constant [8 x i32] [i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8], align 4
@.str = private unnamed_addr constant [19 x i8] c"sum_squares(10) = \00", align 1
@.str.1 = private unnamed_addr constant [16 x i8] c"\0Ascale_array = \00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"-\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"0\00", align 1

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind willreturn memory(none)
define dso_local signext i32 @sum_squares(i32 noundef signext %0) local_unnamed_addr #0 {
  %2 = icmp slt i32 %0, 1
  br i1 %2, label %22, label %3

3:                                                ; preds = %1
  %4 = add nsw i32 %0, -1
  %5 = zext nneg i32 %4 to i33
  %6 = add nsw i32 %0, -2
  %7 = zext i32 %6 to i33
  %8 = mul i33 %5, %7
  %9 = add nsw i32 %0, -3
  %10 = zext i32 %9 to i33
  %11 = mul i33 %8, %10
  %12 = lshr i33 %11, 1
  %13 = trunc nuw i33 %12 to i32
  %14 = mul i32 %13, 1431655766
  %15 = lshr i33 %8, 1
  %16 = trunc nuw i33 %15 to i32
  %17 = mul i32 %16, 5
  %18 = add i32 %14, %17
  %19 = shl i32 %0, 2
  %20 = add i32 %18, %19
  %21 = add i32 %20, -3
  br label %22

22:                                               ; preds = %3, %1
  %23 = phi i32 [ 0, %1 ], [ %21, %3 ]
  ret i32 %23
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(ptr captures(none)) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(ptr captures(none)) #1

; Function Attrs: nofree noinline norecurse nosync nounwind memory(argmem: read)
define dso_local signext i32 @scale_array(ptr noundef readonly captures(none) %0, i32 noundef signext %1) local_unnamed_addr #2 {
  %3 = icmp sgt i32 %1, 0
  br i1 %3, label %4, label %6

4:                                                ; preds = %2
  %5 = zext nneg i32 %1 to i64
  br label %8

6:                                                ; preds = %8, %2
  %7 = phi i32 [ 0, %2 ], [ %14, %8 ]
  ret i32 %7

8:                                                ; preds = %4, %8
  %9 = phi i64 [ 0, %4 ], [ %15, %8 ]
  %10 = phi i32 [ 0, %4 ], [ %14, %8 ]
  %11 = getelementptr inbounds nuw i32, ptr %0, i64 %9
  %12 = load i32, ptr %11, align 4, !tbaa !6
  %13 = shl nsw i32 %12, 2
  %14 = add nsw i32 %13, %10
  %15 = add nuw nsw i64 %9, 1
  %16 = icmp eq i64 %15, %5
  br i1 %16, label %6, label %8, !llvm.loop !10
}

; Function Attrs: noreturn nounwind
define dso_local void @_start() local_unnamed_addr #3 {
  %1 = alloca [20 x i8], align 1
  %2 = alloca [20 x i8], align 1
  %3 = tail call i64 asm sideeffect "ecall", "={x10},{x11},{x12},{x17},{x10},~{memory}"(ptr nonnull @.str, i64 18, i64 64, i64 1) #4, !srcloc !12
  %4 = tail call signext i32 @sum_squares(i32 noundef signext 10) #5
  %5 = sext i32 %4 to i64
  call void @llvm.lifetime.start.p0(ptr nonnull %2) #4
  %6 = icmp slt i32 %4, 0
  br i1 %6, label %7, label %12

7:                                                ; preds = %0
  %8 = tail call i64 asm sideeffect "ecall", "={x10},{x11},{x12},{x17},{x10},~{memory}"(ptr nonnull @.str.3, i64 1, i64 64, i64 1) #4, !srcloc !12
  %9 = sub nsw i64 0, %5
  br label %10

10:                                               ; preds = %12, %7
  %11 = phi i64 [ %9, %7 ], [ %5, %12 ]
  br label %16

12:                                               ; preds = %0
  %13 = icmp eq i32 %4, 0
  br i1 %13, label %14, label %10

14:                                               ; preds = %12
  %15 = tail call i64 asm sideeffect "ecall", "={x10},{x11},{x12},{x17},{x10},~{memory}"(ptr nonnull @.str.4, i64 1, i64 64, i64 1) #4, !srcloc !12
  br label %34

16:                                               ; preds = %10, %16
  %17 = phi i64 [ %25, %16 ], [ 20, %10 ]
  %18 = phi i64 [ %20, %16 ], [ %11, %10 ]
  %19 = freeze i64 %18
  %20 = udiv i64 %19, 10
  %21 = mul i64 %20, 10
  %22 = sub i64 %19, %21
  %23 = trunc nuw nsw i64 %22 to i8
  %24 = or disjoint i8 %23, 48
  %25 = add nsw i64 %17, -1
  %26 = getelementptr inbounds i8, ptr %2, i64 %25
  store i8 %24, ptr %26, align 1, !tbaa !13
  %27 = icmp samesign ult i64 %18, 10
  br i1 %27, label %28, label %16, !llvm.loop !14

28:                                               ; preds = %16
  %29 = shl i64 %25, 32
  %30 = ashr exact i64 %29, 32
  %31 = getelementptr inbounds i8, ptr %2, i64 %30
  %32 = sub nsw i64 20, %30
  %33 = call i64 asm sideeffect "ecall", "={x10},{x11},{x12},{x17},{x10},~{memory}"(ptr nonnull %31, i64 %32, i64 64, i64 1) #4, !srcloc !12
  br label %34

34:                                               ; preds = %14, %28
  call void @llvm.lifetime.end.p0(ptr nonnull %2) #4
  %35 = call i64 asm sideeffect "ecall", "={x10},{x11},{x12},{x17},{x10},~{memory}"(ptr nonnull @.str.1, i64 15, i64 64, i64 1) #4, !srcloc !12
  %36 = call signext i32 @scale_array(ptr noundef nonnull @__const._start.arr, i32 noundef signext 8) #5
  %37 = sext i32 %36 to i64
  call void @llvm.lifetime.start.p0(ptr nonnull %1) #4
  %38 = icmp slt i32 %36, 0
  br i1 %38, label %39, label %44

39:                                               ; preds = %34
  %40 = call i64 asm sideeffect "ecall", "={x10},{x11},{x12},{x17},{x10},~{memory}"(ptr nonnull @.str.3, i64 1, i64 64, i64 1) #4, !srcloc !12
  %41 = sub nsw i64 0, %37
  br label %42

42:                                               ; preds = %44, %39
  %43 = phi i64 [ %41, %39 ], [ %37, %44 ]
  br label %48

44:                                               ; preds = %34
  %45 = icmp eq i32 %36, 0
  br i1 %45, label %46, label %42

46:                                               ; preds = %44
  %47 = call i64 asm sideeffect "ecall", "={x10},{x11},{x12},{x17},{x10},~{memory}"(ptr nonnull @.str.4, i64 1, i64 64, i64 1) #4, !srcloc !12
  br label %66

48:                                               ; preds = %42, %48
  %49 = phi i64 [ %57, %48 ], [ 20, %42 ]
  %50 = phi i64 [ %52, %48 ], [ %43, %42 ]
  %51 = freeze i64 %50
  %52 = udiv i64 %51, 10
  %53 = mul i64 %52, 10
  %54 = sub i64 %51, %53
  %55 = trunc nuw nsw i64 %54 to i8
  %56 = or disjoint i8 %55, 48
  %57 = add nsw i64 %49, -1
  %58 = getelementptr inbounds i8, ptr %1, i64 %57
  store i8 %56, ptr %58, align 1, !tbaa !13
  %59 = icmp samesign ult i64 %50, 10
  br i1 %59, label %60, label %48, !llvm.loop !14

60:                                               ; preds = %48
  %61 = shl i64 %57, 32
  %62 = ashr exact i64 %61, 32
  %63 = getelementptr inbounds i8, ptr %1, i64 %62
  %64 = sub nsw i64 20, %62
  %65 = call i64 asm sideeffect "ecall", "={x10},{x11},{x12},{x17},{x10},~{memory}"(ptr nonnull %63, i64 %64, i64 64, i64 1) #4, !srcloc !12
  br label %66

66:                                               ; preds = %46, %60
  call void @llvm.lifetime.end.p0(ptr nonnull %1) #4
  %67 = call i64 asm sideeffect "ecall", "={x10},{x11},{x12},{x17},{x10},~{memory}"(ptr nonnull @.str.2, i64 1, i64 64, i64 1) #4, !srcloc !12
  call void asm sideeffect "ecall", "{x10},{x17},~{memory}"(i64 0, i64 93) #4, !srcloc !15
  unreachable
}

attributes #0 = { mustprogress nofree noinline norecurse nosync nounwind willreturn memory(none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv64" "target-features"="+64bit,+a,+c,+d,+f,+i,+m,+relax,+zaamo,+zalrsc,+zca,+zcd,+zicsr,+zifencei,+zmmul,-b,-e,-experimental-p,-experimental-smpmpmt,-experimental-svukte,-experimental-xrivosvisni,-experimental-xrivosvizip,-experimental-xsfmclic,-experimental-xsfsclic,-experimental-zibi,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvfbfa,-experimental-zvfofp8min,-experimental-zvkgs,-experimental-zvqdotq,-h,-q,-sdext,-sdtrig,-sha,-shcounterenw,-shgatpa,-shlcofideleg,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcntrpmf,-smcsrind,-smctr,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssctr,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xandesbfhcvt,-xandesperf,-xandesvbfhcvt,-xandesvdot,-xandesvpackfph,-xandesvsinth,-xandesvsintload,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xmipscbop,-xmipscmov,-xmipsexectl,-xmipslsp,-xqccmp,-xqci,-xqcia,-xqciac,-xqcibi,-xqcibm,-xqcicli,-xqcicm,-xqcics,-xqcicsr,-xqciint,-xqciio,-xqcilb,-xqcili,-xqcilia,-xqcilo,-xqcilsm,-xqcisim,-xqcisls,-xqcisync,-xsfcease,-xsfmm128t,-xsfmm16t,-xsfmm32a16f,-xsfmm32a32f,-xsfmm32a8f,-xsfmm32a8i,-xsfmm32t,-xsfmm64a64f,-xsfmm64t,-xsfmmbase,-xsfvcp,-xsfvfbfexp16e,-xsfvfexp16e,-xsfvfexp32e,-xsfvfexpa,-xsfvfexpa64e,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xsmtvdot,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zabha,-zacas,-zalasr,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zcb,-zce,-zcf,-zclsd,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zfinx,-zhinx,-zhinxmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccamoc,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zihintntl,-zihintpause,-zihpm,-zilsd,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { nofree noinline norecurse nosync nounwind memory(argmem: read) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv64" "target-features"="+64bit,+a,+c,+d,+f,+i,+m,+relax,+zaamo,+zalrsc,+zca,+zcd,+zicsr,+zifencei,+zmmul,-b,-e,-experimental-p,-experimental-smpmpmt,-experimental-svukte,-experimental-xrivosvisni,-experimental-xrivosvizip,-experimental-xsfmclic,-experimental-xsfsclic,-experimental-zibi,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvfbfa,-experimental-zvfofp8min,-experimental-zvkgs,-experimental-zvqdotq,-h,-q,-sdext,-sdtrig,-sha,-shcounterenw,-shgatpa,-shlcofideleg,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcntrpmf,-smcsrind,-smctr,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssctr,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xandesbfhcvt,-xandesperf,-xandesvbfhcvt,-xandesvdot,-xandesvpackfph,-xandesvsinth,-xandesvsintload,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xmipscbop,-xmipscmov,-xmipsexectl,-xmipslsp,-xqccmp,-xqci,-xqcia,-xqciac,-xqcibi,-xqcibm,-xqcicli,-xqcicm,-xqcics,-xqcicsr,-xqciint,-xqciio,-xqcilb,-xqcili,-xqcilia,-xqcilo,-xqcilsm,-xqcisim,-xqcisls,-xqcisync,-xsfcease,-xsfmm128t,-xsfmm16t,-xsfmm32a16f,-xsfmm32a32f,-xsfmm32a8f,-xsfmm32a8i,-xsfmm32t,-xsfmm64a64f,-xsfmm64t,-xsfmmbase,-xsfvcp,-xsfvfbfexp16e,-xsfvfexp16e,-xsfvfexp32e,-xsfvfexpa,-xsfvfexpa64e,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xsmtvdot,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zabha,-zacas,-zalasr,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zcb,-zce,-zcf,-zclsd,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zfinx,-zhinx,-zhinxmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccamoc,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zihintntl,-zihintpause,-zihpm,-zilsd,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #3 = { noreturn nounwind "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv64" "target-features"="+64bit,+a,+c,+d,+f,+i,+m,+relax,+zaamo,+zalrsc,+zca,+zcd,+zicsr,+zifencei,+zmmul,-b,-e,-experimental-p,-experimental-smpmpmt,-experimental-svukte,-experimental-xrivosvisni,-experimental-xrivosvizip,-experimental-xsfmclic,-experimental-xsfsclic,-experimental-zibi,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvfbfa,-experimental-zvfofp8min,-experimental-zvkgs,-experimental-zvqdotq,-h,-q,-sdext,-sdtrig,-sha,-shcounterenw,-shgatpa,-shlcofideleg,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcntrpmf,-smcsrind,-smctr,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssctr,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xandesbfhcvt,-xandesperf,-xandesvbfhcvt,-xandesvdot,-xandesvpackfph,-xandesvsinth,-xandesvsintload,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xmipscbop,-xmipscmov,-xmipsexectl,-xmipslsp,-xqccmp,-xqci,-xqcia,-xqciac,-xqcibi,-xqcibm,-xqcicli,-xqcicm,-xqcics,-xqcicsr,-xqciint,-xqciio,-xqcilb,-xqcili,-xqcilia,-xqcilo,-xqcilsm,-xqcisim,-xqcisls,-xqcisync,-xsfcease,-xsfmm128t,-xsfmm16t,-xsfmm32a16f,-xsfmm32a32f,-xsfmm32a8f,-xsfmm32a8i,-xsfmm32t,-xsfmm64a64f,-xsfmm64t,-xsfmmbase,-xsfvcp,-xsfvfbfexp16e,-xsfvfexp16e,-xsfvfexp32e,-xsfvfexpa,-xsfvfexpa64e,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xsmtvdot,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zabha,-zacas,-zalasr,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zcb,-zce,-zcf,-zclsd,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zfinx,-zhinx,-zhinxmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccamoc,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zihintntl,-zihintpause,-zihpm,-zilsd,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #4 = { nounwind }
attributes #5 = { nobuiltin "no-builtins" }

!llvm.module.flags = !{!0, !1, !2, !4}
!llvm.ident = !{!5}
!llvm.errno.tbaa = !{!6}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"target-abi", !"lp64d"}
!2 = !{i32 6, !"riscv-isa", !3}
!3 = !{!"rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"}
!4 = !{i32 8, !"SmallDataLimit", i32 0}
!5 = !{!"Homebrew clang version 22.1.4"}
!6 = !{!7, !7, i64 0}
!7 = !{!"int", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = distinct !{!10, !11}
!11 = !{!"llvm.loop.mustprogress"}
!12 = !{i64 19368}
!13 = !{!8, !8, i64 0}
!14 = distinct !{!14, !11}
!15 = !{i64 19635}
