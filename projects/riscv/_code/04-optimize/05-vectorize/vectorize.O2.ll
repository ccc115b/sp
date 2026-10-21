; ModuleID = '05-vectorize/vectorize.c'
source_filename = "05-vectorize/vectorize.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "riscv64-unknown-unknown-elf"

@__const._start.a = private unnamed_addr constant [4 x i32] [i32 1, i32 2, i32 3, i32 4], align 4
@__const._start.b = private unnamed_addr constant [4 x i32] [i32 5, i32 6, i32 7, i32 8], align 4
@.str = private unnamed_addr constant [8 x i8] c"dot4 = \00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"-\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"0\00", align 1

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind willreturn memory(argmem: read)
define dso_local signext i32 @dot4(ptr noundef readonly captures(none) %0, ptr noundef readonly captures(none) %1) local_unnamed_addr #0 {
  %3 = load i32, ptr %0, align 4, !tbaa !6
  %4 = load i32, ptr %1, align 4, !tbaa !6
  %5 = mul nsw i32 %4, %3
  %6 = getelementptr inbounds nuw i8, ptr %0, i64 4
  %7 = load i32, ptr %6, align 4, !tbaa !6
  %8 = getelementptr inbounds nuw i8, ptr %1, i64 4
  %9 = load i32, ptr %8, align 4, !tbaa !6
  %10 = mul nsw i32 %9, %7
  %11 = add nsw i32 %10, %5
  %12 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %13 = load i32, ptr %12, align 4, !tbaa !6
  %14 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %15 = load i32, ptr %14, align 4, !tbaa !6
  %16 = mul nsw i32 %15, %13
  %17 = add nsw i32 %16, %11
  %18 = getelementptr inbounds nuw i8, ptr %0, i64 12
  %19 = load i32, ptr %18, align 4, !tbaa !6
  %20 = getelementptr inbounds nuw i8, ptr %1, i64 12
  %21 = load i32, ptr %20, align 4, !tbaa !6
  %22 = mul nsw i32 %21, %19
  %23 = add nsw i32 %22, %17
  ret i32 %23
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(ptr captures(none)) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(ptr captures(none)) #1

; Function Attrs: noreturn nounwind
define dso_local void @_start() local_unnamed_addr #2 {
  %1 = alloca [20 x i8], align 1
  %2 = tail call i64 asm sideeffect "ecall", "={x10},{x11},{x12},{x17},{x10},~{memory}"(ptr nonnull @.str, i64 7, i64 64, i64 1) #3, !srcloc !10
  %3 = tail call signext i32 @dot4(ptr noundef nonnull @__const._start.a, ptr noundef nonnull @__const._start.b) #4
  %4 = sext i32 %3 to i64
  call void @llvm.lifetime.start.p0(ptr nonnull %1) #3
  %5 = icmp slt i32 %3, 0
  br i1 %5, label %6, label %11

6:                                                ; preds = %0
  %7 = tail call i64 asm sideeffect "ecall", "={x10},{x11},{x12},{x17},{x10},~{memory}"(ptr nonnull @.str.2, i64 1, i64 64, i64 1) #3, !srcloc !10
  %8 = sub nsw i64 0, %4
  br label %9

9:                                                ; preds = %11, %6
  %10 = phi i64 [ %8, %6 ], [ %4, %11 ]
  br label %15

11:                                               ; preds = %0
  %12 = icmp eq i32 %3, 0
  br i1 %12, label %13, label %9

13:                                               ; preds = %11
  %14 = tail call i64 asm sideeffect "ecall", "={x10},{x11},{x12},{x17},{x10},~{memory}"(ptr nonnull @.str.3, i64 1, i64 64, i64 1) #3, !srcloc !10
  br label %33

15:                                               ; preds = %9, %15
  %16 = phi i64 [ %24, %15 ], [ 20, %9 ]
  %17 = phi i64 [ %19, %15 ], [ %10, %9 ]
  %18 = freeze i64 %17
  %19 = udiv i64 %18, 10
  %20 = mul i64 %19, 10
  %21 = sub i64 %18, %20
  %22 = trunc nuw nsw i64 %21 to i8
  %23 = or disjoint i8 %22, 48
  %24 = add nsw i64 %16, -1
  %25 = getelementptr inbounds i8, ptr %1, i64 %24
  store i8 %23, ptr %25, align 1, !tbaa !11
  %26 = icmp samesign ult i64 %17, 10
  br i1 %26, label %27, label %15, !llvm.loop !12

27:                                               ; preds = %15
  %28 = shl i64 %24, 32
  %29 = ashr exact i64 %28, 32
  %30 = getelementptr inbounds i8, ptr %1, i64 %29
  %31 = sub nsw i64 20, %29
  %32 = call i64 asm sideeffect "ecall", "={x10},{x11},{x12},{x17},{x10},~{memory}"(ptr nonnull %30, i64 %31, i64 64, i64 1) #3, !srcloc !10
  br label %33

33:                                               ; preds = %13, %27
  call void @llvm.lifetime.end.p0(ptr nonnull %1) #3
  %34 = call i64 asm sideeffect "ecall", "={x10},{x11},{x12},{x17},{x10},~{memory}"(ptr nonnull @.str.1, i64 1, i64 64, i64 1) #3, !srcloc !10
  call void asm sideeffect "ecall", "{x10},{x17},~{memory}"(i64 0, i64 93) #3, !srcloc !14
  unreachable
}

attributes #0 = { mustprogress nofree noinline norecurse nosync nounwind willreturn memory(argmem: read) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv64" "target-features"="+64bit,+a,+c,+d,+f,+i,+m,+relax,+zaamo,+zalrsc,+zca,+zcd,+zicsr,+zifencei,+zmmul,-b,-e,-experimental-p,-experimental-smpmpmt,-experimental-svukte,-experimental-xrivosvisni,-experimental-xrivosvizip,-experimental-xsfmclic,-experimental-xsfsclic,-experimental-zibi,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvfbfa,-experimental-zvfofp8min,-experimental-zvkgs,-experimental-zvqdotq,-h,-q,-sdext,-sdtrig,-sha,-shcounterenw,-shgatpa,-shlcofideleg,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcntrpmf,-smcsrind,-smctr,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssctr,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xandesbfhcvt,-xandesperf,-xandesvbfhcvt,-xandesvdot,-xandesvpackfph,-xandesvsinth,-xandesvsintload,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xmipscbop,-xmipscmov,-xmipsexectl,-xmipslsp,-xqccmp,-xqci,-xqcia,-xqciac,-xqcibi,-xqcibm,-xqcicli,-xqcicm,-xqcics,-xqcicsr,-xqciint,-xqciio,-xqcilb,-xqcili,-xqcilia,-xqcilo,-xqcilsm,-xqcisim,-xqcisls,-xqcisync,-xsfcease,-xsfmm128t,-xsfmm16t,-xsfmm32a16f,-xsfmm32a32f,-xsfmm32a8f,-xsfmm32a8i,-xsfmm32t,-xsfmm64a64f,-xsfmm64t,-xsfmmbase,-xsfvcp,-xsfvfbfexp16e,-xsfvfexp16e,-xsfvfexp32e,-xsfvfexpa,-xsfvfexpa64e,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xsmtvdot,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zabha,-zacas,-zalasr,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zcb,-zce,-zcf,-zclsd,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zfinx,-zhinx,-zhinxmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccamoc,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zihintntl,-zihintpause,-zihpm,-zilsd,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { noreturn nounwind "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv64" "target-features"="+64bit,+a,+c,+d,+f,+i,+m,+relax,+zaamo,+zalrsc,+zca,+zcd,+zicsr,+zifencei,+zmmul,-b,-e,-experimental-p,-experimental-smpmpmt,-experimental-svukte,-experimental-xrivosvisni,-experimental-xrivosvizip,-experimental-xsfmclic,-experimental-xsfsclic,-experimental-zibi,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvfbfa,-experimental-zvfofp8min,-experimental-zvkgs,-experimental-zvqdotq,-h,-q,-sdext,-sdtrig,-sha,-shcounterenw,-shgatpa,-shlcofideleg,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcntrpmf,-smcsrind,-smctr,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssctr,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xandesbfhcvt,-xandesperf,-xandesvbfhcvt,-xandesvdot,-xandesvpackfph,-xandesvsinth,-xandesvsintload,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xmipscbop,-xmipscmov,-xmipsexectl,-xmipslsp,-xqccmp,-xqci,-xqcia,-xqciac,-xqcibi,-xqcibm,-xqcicli,-xqcicm,-xqcics,-xqcicsr,-xqciint,-xqciio,-xqcilb,-xqcili,-xqcilia,-xqcilo,-xqcilsm,-xqcisim,-xqcisls,-xqcisync,-xsfcease,-xsfmm128t,-xsfmm16t,-xsfmm32a16f,-xsfmm32a32f,-xsfmm32a8f,-xsfmm32a8i,-xsfmm32t,-xsfmm64a64f,-xsfmm64t,-xsfmmbase,-xsfvcp,-xsfvfbfexp16e,-xsfvfexp16e,-xsfvfexp32e,-xsfvfexpa,-xsfvfexpa64e,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xsmtvdot,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zabha,-zacas,-zalasr,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zcb,-zce,-zcf,-zclsd,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zfinx,-zhinx,-zhinxmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccamoc,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zihintntl,-zihintpause,-zihpm,-zilsd,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #3 = { nounwind }
attributes #4 = { nobuiltin "no-builtins" }

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
!10 = !{i64 19327}
!11 = !{!8, !8, i64 0}
!12 = distinct !{!12, !13}
!13 = !{!"llvm.loop.mustprogress"}
!14 = !{i64 19594}
