; ModuleID = 'rt.c'
source_filename = "rt.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.2.0"

@.str = private unnamed_addr constant [4 x i8] c"%ld\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"\\22\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"\\5C\00", align 1
@__stdoutp = external local_unnamed_addr global ptr, align 8
@KWS = internal unnamed_addr constant [22 x ptr] [ptr @.str.9, ptr @.str.10, ptr @.str.11, ptr @.str.12, ptr @.str.13, ptr @.str.14, ptr @.str.15, ptr @.str.16, ptr @.str.17, ptr @.str.18, ptr @.str.19, ptr @.str.20, ptr @.str.21, ptr @.str.22, ptr @.str.23, ptr @.str.24, ptr @.str.25, ptr @.str.26, ptr @.str.27, ptr @.str.28, ptr @.str.29, ptr @.str.30], align 8
@.str.3 = private unnamed_addr constant [3 x i8] c"rb\00", align 1
@__stderrp = external local_unnamed_addr global ptr, align 8
@.str.4 = private unnamed_addr constant [29 x i8] c"rust0 error: cannot open %s\0A\00", align 1
@SRC = internal unnamed_addr global ptr null, align 8
@SRCN = internal unnamed_addr global i64 0, align 8
@.str.5 = private unnamed_addr constant [3 x i8] c"wb\00", align 1
@.str.6 = private unnamed_addr constant [30 x i8] c"rust0 error: cannot write %s\0A\00", align 1
@OUT = internal unnamed_addr global ptr null, align 8
@OLEN = internal unnamed_addr global i64 0, align 8
@.str.7 = private unnamed_addr constant [28 x i8] c"rust0 error: %s (line %ld)\0A\00", align 1
@.str.8 = private unnamed_addr constant [17 x i8] c"rust0 error: %s\0A\00", align 1
@R0ARGC = internal unnamed_addr global i32 0, align 4
@R0ARGV = internal unnamed_addr global ptr null, align 8
@OCAP = internal unnamed_addr global i64 0, align 8
@.str.9 = private unnamed_addr constant [3 x i8] c"fn\00", align 1
@.str.10 = private unnamed_addr constant [4 x i8] c"let\00", align 1
@.str.11 = private unnamed_addr constant [4 x i8] c"mut\00", align 1
@.str.12 = private unnamed_addr constant [7 x i8] c"return\00", align 1
@.str.13 = private unnamed_addr constant [3 x i8] c"if\00", align 1
@.str.14 = private unnamed_addr constant [5 x i8] c"else\00", align 1
@.str.15 = private unnamed_addr constant [6 x i8] c"while\00", align 1
@.str.16 = private unnamed_addr constant [4 x i8] c"for\00", align 1
@.str.17 = private unnamed_addr constant [3 x i8] c"in\00", align 1
@.str.18 = private unnamed_addr constant [6 x i8] c"break\00", align 1
@.str.19 = private unnamed_addr constant [9 x i8] c"continue\00", align 1
@.str.20 = private unnamed_addr constant [7 x i8] c"struct\00", align 1
@.str.21 = private unnamed_addr constant [6 x i8] c"const\00", align 1
@.str.22 = private unnamed_addr constant [7 x i8] c"extern\00", align 1
@.str.23 = private unnamed_addr constant [5 x i8] c"true\00", align 1
@.str.24 = private unnamed_addr constant [6 x i8] c"false\00", align 1
@.str.25 = private unnamed_addr constant [7 x i8] c"unsafe\00", align 1
@.str.26 = private unnamed_addr constant [4 x i8] c"i64\00", align 1
@.str.27 = private unnamed_addr constant [5 x i8] c"bool\00", align 1
@.str.28 = private unnamed_addr constant [6 x i8] c"usize\00", align 1
@.str.29 = private unnamed_addr constant [3 x i8] c"u8\00", align 1
@.str.30 = private unnamed_addr constant [3 x i8] c"as\00", align 1
@.str.31 = private unnamed_addr constant [7 x i8] c"as_ptr\00", align 1

; Function Attrs: nounwind ssp memory(readwrite, target_mem0: none, target_mem1: none) uwtable(sync)
define void @r0_write(ptr noundef readonly captures(none) %0) local_unnamed_addr #0 {
  tail call fastcc void @oput(ptr noundef %0)
  ret void
}

; Function Attrs: nounwind ssp memory(readwrite, target_mem0: none, target_mem1: none) uwtable(sync)
define internal fastcc void @oput(ptr noundef readonly captures(none) %0) unnamed_addr #0 {
  %2 = tail call i64 @strlen(ptr noundef nonnull dereferenceable(1) %0) #24
  %3 = load ptr, ptr @OUT, align 8, !tbaa !10
  %4 = icmp eq ptr %3, null
  br i1 %4, label %10, label %5

5:                                                ; preds = %1
  %6 = load i64, ptr @OLEN, align 8, !tbaa !13
  %7 = add nsw i64 %6, %2
  %8 = load i64, ptr @OCAP, align 8, !tbaa !13
  %9 = icmp sgt i64 %7, %8
  br i1 %9, label %10, label %22

10:                                               ; preds = %5, %1
  %11 = load i64, ptr @OCAP, align 8, !tbaa !13
  %12 = icmp eq i64 %11, 0
  %13 = select i1 %12, i64 65536, i64 %11
  %14 = load i64, ptr @OLEN, align 8, !tbaa !13
  %15 = add nsw i64 %14, %2
  br label %16

16:                                               ; preds = %16, %10
  %17 = phi i64 [ %13, %10 ], [ %19, %16 ]
  %18 = icmp slt i64 %17, %15
  %19 = shl nsw i64 %17, 1
  br i1 %18, label %16, label %20, !llvm.loop !15

20:                                               ; preds = %16
  %21 = tail call ptr @malloc(i64 noundef %17) #25
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %21, ptr noundef align 1 %3, i64 noundef %14, i1 noundef false) #24
  tail call void @free(ptr noundef %3)
  store ptr %21, ptr @OUT, align 8, !tbaa !10
  store i64 %17, ptr @OCAP, align 8, !tbaa !13
  br label %22

22:                                               ; preds = %5, %20
  %23 = load ptr, ptr @OUT, align 8, !tbaa !10
  %24 = load i64, ptr @OLEN, align 8, !tbaa !13
  %25 = getelementptr inbounds i8, ptr %23, i64 %24
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %25, ptr noundef nonnull align 1 %0, i64 noundef %2, i1 noundef false) #24
  %26 = add nsw i64 %24, %2
  store i64 %26, ptr @OLEN, align 8, !tbaa !13
  ret void
}

; Function Attrs: nounwind ssp memory(readwrite, target_mem0: none, target_mem1: none) uwtable(sync)
define void @r0_wch(i64 noundef %0) local_unnamed_addr #0 {
  %2 = load ptr, ptr @OUT, align 8, !tbaa !10
  %3 = icmp eq ptr %2, null
  br i1 %3, label %8, label %4

4:                                                ; preds = %1
  %5 = load i64, ptr @OLEN, align 8, !tbaa !13
  %6 = load i64, ptr @OCAP, align 8, !tbaa !13
  %7 = icmp slt i64 %5, %6
  br i1 %7, label %19, label %8

8:                                                ; preds = %4, %1
  %9 = load i64, ptr @OCAP, align 8, !tbaa !13
  %10 = icmp eq i64 %9, 0
  %11 = select i1 %10, i64 65536, i64 %9
  %12 = load i64, ptr @OLEN, align 8, !tbaa !13
  br label %13

13:                                               ; preds = %13, %8
  %14 = phi i64 [ %11, %8 ], [ %16, %13 ]
  %15 = icmp sgt i64 %14, %12
  %16 = shl nsw i64 %14, 1
  br i1 %15, label %17, label %13, !llvm.loop !15

17:                                               ; preds = %13
  %18 = tail call ptr @malloc(i64 noundef %14) #25
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %18, ptr noundef align 1 %2, i64 noundef %12, i1 noundef false) #24
  tail call void @free(ptr noundef %2)
  store ptr %18, ptr @OUT, align 8, !tbaa !10
  store i64 %14, ptr @OCAP, align 8, !tbaa !13
  br label %19

19:                                               ; preds = %4, %17
  %20 = trunc i64 %0 to i8
  %21 = load ptr, ptr @OUT, align 8, !tbaa !10
  %22 = load i64, ptr @OLEN, align 8, !tbaa !13
  %23 = getelementptr inbounds i8, ptr %21, i64 %22
  store i8 %20, ptr %23, align 1, !tbaa !18
  %24 = add nsw i64 %22, 1
  store i64 %24, ptr @OLEN, align 8, !tbaa !13
  ret void
}

; Function Attrs: nounwind ssp uwtable(sync)
define void @r0_writeint(i64 noundef %0) local_unnamed_addr #1 {
  %2 = alloca [32 x i8], align 1
  call void @llvm.lifetime.start.p0(ptr nonnull %2) #24
  %3 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr nonnull dereferenceable(1) %2, i64 32, ptr nonnull @.str, i64 %0)
  call fastcc void @oput(ptr noundef nonnull %2)
  call void @llvm.lifetime.end.p0(ptr nonnull %2) #24
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(ptr captures(none)) #2

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(ptr captures(none)) #2

; Function Attrs: nounwind ssp memory(readwrite, target_mem0: none, target_mem1: none) uwtable(sync)
define void @r0_wstrlit(ptr noundef readonly captures(none) %0, i64 noundef %1, i64 noundef %2) local_unnamed_addr #0 {
  %4 = getelementptr inbounds i8, ptr %0, i64 %1
  %5 = icmp sgt i64 %2, 0
  br i1 %5, label %6, label %175

6:                                                ; preds = %3, %172
  %7 = phi i64 [ %173, %172 ], [ 0, %3 ]
  %8 = getelementptr inbounds i8, ptr %4, i64 %7
  %9 = load i8, ptr %8, align 1, !tbaa !18
  %10 = icmp eq i8 %9, 92
  br i1 %10, label %11, label %140

11:                                               ; preds = %6
  %12 = add nsw i64 %7, 1
  %13 = icmp slt i64 %12, %2
  br i1 %13, label %14, label %140

14:                                               ; preds = %11
  %15 = getelementptr inbounds i8, ptr %4, i64 %12
  %16 = load i8, ptr %15, align 1, !tbaa !18
  switch i8 %16, label %137 [
    i8 110, label %17
    i8 116, label %35
    i8 114, label %53
    i8 48, label %71
    i8 92, label %89
    i8 34, label %107
  ]

17:                                               ; preds = %14
  %18 = load ptr, ptr @OUT, align 8, !tbaa !10
  %19 = icmp eq ptr %18, null
  br i1 %19, label %24, label %20

20:                                               ; preds = %17
  %21 = load i64, ptr @OLEN, align 8, !tbaa !13
  %22 = load i64, ptr @OCAP, align 8, !tbaa !13
  %23 = icmp slt i64 %21, %22
  br i1 %23, label %130, label %24, !llvm.loop !19

24:                                               ; preds = %20, %17
  %25 = load i64, ptr @OCAP, align 8, !tbaa !13
  %26 = icmp eq i64 %25, 0
  %27 = select i1 %26, i64 65536, i64 %25
  %28 = load i64, ptr @OLEN, align 8, !tbaa !13
  br label %29

29:                                               ; preds = %29, %24
  %30 = phi i64 [ %27, %24 ], [ %32, %29 ]
  %31 = icmp sgt i64 %30, %28
  %32 = shl nsw i64 %30, 1
  br i1 %31, label %33, label %29, !llvm.loop !15

33:                                               ; preds = %29
  %34 = tail call ptr @malloc(i64 noundef %30) #25
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %34, ptr noundef align 1 %18, i64 noundef %28, i1 noundef false) #24
  br label %125, !llvm.loop !19

35:                                               ; preds = %14
  %36 = load ptr, ptr @OUT, align 8, !tbaa !10
  %37 = icmp eq ptr %36, null
  br i1 %37, label %42, label %38

38:                                               ; preds = %35
  %39 = load i64, ptr @OLEN, align 8, !tbaa !13
  %40 = load i64, ptr @OCAP, align 8, !tbaa !13
  %41 = icmp slt i64 %39, %40
  br i1 %41, label %130, label %42, !llvm.loop !19

42:                                               ; preds = %38, %35
  %43 = load i64, ptr @OCAP, align 8, !tbaa !13
  %44 = icmp eq i64 %43, 0
  %45 = select i1 %44, i64 65536, i64 %43
  %46 = load i64, ptr @OLEN, align 8, !tbaa !13
  br label %47

47:                                               ; preds = %47, %42
  %48 = phi i64 [ %45, %42 ], [ %50, %47 ]
  %49 = icmp sgt i64 %48, %46
  %50 = shl nsw i64 %48, 1
  br i1 %49, label %51, label %47, !llvm.loop !15

51:                                               ; preds = %47
  %52 = tail call ptr @malloc(i64 noundef %48) #25
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %52, ptr noundef align 1 %36, i64 noundef %46, i1 noundef false) #24
  br label %125, !llvm.loop !19

53:                                               ; preds = %14
  %54 = load ptr, ptr @OUT, align 8, !tbaa !10
  %55 = icmp eq ptr %54, null
  br i1 %55, label %60, label %56

56:                                               ; preds = %53
  %57 = load i64, ptr @OLEN, align 8, !tbaa !13
  %58 = load i64, ptr @OCAP, align 8, !tbaa !13
  %59 = icmp slt i64 %57, %58
  br i1 %59, label %130, label %60, !llvm.loop !19

60:                                               ; preds = %56, %53
  %61 = load i64, ptr @OCAP, align 8, !tbaa !13
  %62 = icmp eq i64 %61, 0
  %63 = select i1 %62, i64 65536, i64 %61
  %64 = load i64, ptr @OLEN, align 8, !tbaa !13
  br label %65

65:                                               ; preds = %65, %60
  %66 = phi i64 [ %63, %60 ], [ %68, %65 ]
  %67 = icmp sgt i64 %66, %64
  %68 = shl nsw i64 %66, 1
  br i1 %67, label %69, label %65, !llvm.loop !15

69:                                               ; preds = %65
  %70 = tail call ptr @malloc(i64 noundef %66) #25
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %70, ptr noundef align 1 %54, i64 noundef %64, i1 noundef false) #24
  br label %125, !llvm.loop !19

71:                                               ; preds = %14
  %72 = load ptr, ptr @OUT, align 8, !tbaa !10
  %73 = icmp eq ptr %72, null
  br i1 %73, label %78, label %74

74:                                               ; preds = %71
  %75 = load i64, ptr @OLEN, align 8, !tbaa !13
  %76 = load i64, ptr @OCAP, align 8, !tbaa !13
  %77 = icmp slt i64 %75, %76
  br i1 %77, label %130, label %78, !llvm.loop !19

78:                                               ; preds = %74, %71
  %79 = load i64, ptr @OCAP, align 8, !tbaa !13
  %80 = icmp eq i64 %79, 0
  %81 = select i1 %80, i64 65536, i64 %79
  %82 = load i64, ptr @OLEN, align 8, !tbaa !13
  br label %83

83:                                               ; preds = %83, %78
  %84 = phi i64 [ %81, %78 ], [ %86, %83 ]
  %85 = icmp sgt i64 %84, %82
  %86 = shl nsw i64 %84, 1
  br i1 %85, label %87, label %83, !llvm.loop !15

87:                                               ; preds = %83
  %88 = tail call ptr @malloc(i64 noundef %84) #25
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %88, ptr noundef align 1 %72, i64 noundef %82, i1 noundef false) #24
  br label %125, !llvm.loop !19

89:                                               ; preds = %14
  %90 = load ptr, ptr @OUT, align 8, !tbaa !10
  %91 = icmp eq ptr %90, null
  br i1 %91, label %96, label %92

92:                                               ; preds = %89
  %93 = load i64, ptr @OLEN, align 8, !tbaa !13
  %94 = load i64, ptr @OCAP, align 8, !tbaa !13
  %95 = icmp slt i64 %93, %94
  br i1 %95, label %130, label %96, !llvm.loop !19

96:                                               ; preds = %92, %89
  %97 = load i64, ptr @OCAP, align 8, !tbaa !13
  %98 = icmp eq i64 %97, 0
  %99 = select i1 %98, i64 65536, i64 %97
  %100 = load i64, ptr @OLEN, align 8, !tbaa !13
  br label %101

101:                                              ; preds = %101, %96
  %102 = phi i64 [ %99, %96 ], [ %104, %101 ]
  %103 = icmp sgt i64 %102, %100
  %104 = shl nsw i64 %102, 1
  br i1 %103, label %105, label %101, !llvm.loop !15

105:                                              ; preds = %101
  %106 = tail call ptr @malloc(i64 noundef %102) #25
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %106, ptr noundef align 1 %90, i64 noundef %100, i1 noundef false) #24
  br label %125, !llvm.loop !19

107:                                              ; preds = %14
  %108 = load ptr, ptr @OUT, align 8, !tbaa !10
  %109 = icmp eq ptr %108, null
  br i1 %109, label %114, label %110

110:                                              ; preds = %107
  %111 = load i64, ptr @OLEN, align 8, !tbaa !13
  %112 = load i64, ptr @OCAP, align 8, !tbaa !13
  %113 = icmp slt i64 %111, %112
  br i1 %113, label %130, label %114, !llvm.loop !19

114:                                              ; preds = %110, %107
  %115 = load i64, ptr @OCAP, align 8, !tbaa !13
  %116 = icmp eq i64 %115, 0
  %117 = select i1 %116, i64 65536, i64 %115
  %118 = load i64, ptr @OLEN, align 8, !tbaa !13
  br label %119

119:                                              ; preds = %119, %114
  %120 = phi i64 [ %117, %114 ], [ %122, %119 ]
  %121 = icmp sgt i64 %120, %118
  %122 = shl nsw i64 %120, 1
  br i1 %121, label %123, label %119, !llvm.loop !15

123:                                              ; preds = %119
  %124 = tail call ptr @malloc(i64 noundef %120) #25
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %124, ptr noundef align 1 %108, i64 noundef %118, i1 noundef false) #24
  br label %125, !llvm.loop !19

125:                                              ; preds = %33, %51, %69, %87, %105, %123
  %126 = phi ptr [ %108, %123 ], [ %90, %105 ], [ %72, %87 ], [ %54, %69 ], [ %36, %51 ], [ %18, %33 ]
  %127 = phi ptr [ %124, %123 ], [ %106, %105 ], [ %88, %87 ], [ %70, %69 ], [ %52, %51 ], [ %34, %33 ]
  %128 = phi i64 [ %120, %123 ], [ %102, %105 ], [ %84, %87 ], [ %66, %69 ], [ %48, %51 ], [ %30, %33 ]
  %129 = phi i8 [ 34, %123 ], [ 92, %105 ], [ 0, %87 ], [ 13, %69 ], [ 9, %51 ], [ 10, %33 ]
  tail call void @free(ptr noundef %126)
  store ptr %127, ptr @OUT, align 8, !tbaa !10
  store i64 %128, ptr @OCAP, align 8, !tbaa !13
  br label %130

130:                                              ; preds = %125, %110, %92, %74, %56, %38, %20
  %131 = phi i8 [ 9, %38 ], [ 13, %56 ], [ 0, %74 ], [ 92, %92 ], [ 34, %110 ], [ 10, %20 ], [ %129, %125 ]
  %132 = load ptr, ptr @OUT, align 8, !tbaa !10
  %133 = load i64, ptr @OLEN, align 8, !tbaa !13
  %134 = getelementptr inbounds i8, ptr %132, i64 %133
  store i8 %131, ptr %134, align 1, !tbaa !18
  %135 = add nsw i64 %133, 1
  store i64 %135, ptr @OLEN, align 8, !tbaa !13
  %136 = add nsw i64 %7, 2
  br label %137

137:                                              ; preds = %130, %14
  %138 = phi i64 [ %7, %14 ], [ %136, %130 ]
  %139 = phi i1 [ true, %14 ], [ false, %130 ]
  br i1 %139, label %140, label %172

140:                                              ; preds = %137, %11, %6
  %141 = phi i64 [ %138, %137 ], [ %7, %11 ], [ %7, %6 ]
  %142 = icmp eq i8 %9, 34
  br i1 %142, label %143, label %145

143:                                              ; preds = %140
  tail call fastcc void @oput(ptr noundef nonnull @.str.1)
  %144 = add nsw i64 %141, 1
  br label %172, !llvm.loop !19

145:                                              ; preds = %140
  br i1 %10, label %146, label %148

146:                                              ; preds = %145
  tail call fastcc void @oput(ptr noundef nonnull @.str.2)
  %147 = add nsw i64 %141, 1
  br label %172, !llvm.loop !19

148:                                              ; preds = %145
  %149 = load ptr, ptr @OUT, align 8, !tbaa !10
  %150 = icmp eq ptr %149, null
  br i1 %150, label %155, label %151

151:                                              ; preds = %148
  %152 = load i64, ptr @OLEN, align 8, !tbaa !13
  %153 = load i64, ptr @OCAP, align 8, !tbaa !13
  %154 = icmp slt i64 %152, %153
  br i1 %154, label %166, label %155

155:                                              ; preds = %151, %148
  %156 = load i64, ptr @OCAP, align 8, !tbaa !13
  %157 = icmp eq i64 %156, 0
  %158 = select i1 %157, i64 65536, i64 %156
  %159 = load i64, ptr @OLEN, align 8, !tbaa !13
  br label %160

160:                                              ; preds = %160, %155
  %161 = phi i64 [ %158, %155 ], [ %163, %160 ]
  %162 = icmp sgt i64 %161, %159
  %163 = shl nsw i64 %161, 1
  br i1 %162, label %164, label %160, !llvm.loop !15

164:                                              ; preds = %160
  %165 = tail call ptr @malloc(i64 noundef %161) #25
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %165, ptr noundef align 1 %149, i64 noundef %159, i1 noundef false) #24
  tail call void @free(ptr noundef %149)
  store ptr %165, ptr @OUT, align 8, !tbaa !10
  store i64 %161, ptr @OCAP, align 8, !tbaa !13
  br label %166

166:                                              ; preds = %151, %164
  %167 = load ptr, ptr @OUT, align 8, !tbaa !10
  %168 = load i64, ptr @OLEN, align 8, !tbaa !13
  %169 = getelementptr inbounds i8, ptr %167, i64 %168
  store i8 %9, ptr %169, align 1, !tbaa !18
  %170 = add nsw i64 %168, 1
  store i64 %170, ptr @OLEN, align 8, !tbaa !13
  %171 = add nsw i64 %141, 1
  br label %172

172:                                              ; preds = %137, %166, %146, %143
  %173 = phi i64 [ %144, %143 ], [ %147, %146 ], [ %171, %166 ], [ %138, %137 ]
  %174 = icmp slt i64 %173, %2
  br i1 %174, label %6, label %175

175:                                              ; preds = %172, %3
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind ssp memory(argmem: read) uwtable(sync)
define i64 @r0_strlen2(ptr noundef readonly captures(none) %0, i64 noundef %1, i64 noundef %2) local_unnamed_addr #3 {
  %4 = getelementptr inbounds i8, ptr %0, i64 %1
  %5 = icmp sgt i64 %2, 0
  br i1 %5, label %6, label %19

6:                                                ; preds = %3, %6
  %7 = phi i64 [ %16, %6 ], [ 0, %3 ]
  %8 = phi i64 [ %17, %6 ], [ 0, %3 ]
  %9 = getelementptr inbounds i8, ptr %4, i64 %7
  %10 = load i8, ptr %9, align 1, !tbaa !18
  %11 = icmp eq i8 %10, 92
  %12 = add nsw i64 %7, 1
  %13 = icmp slt i64 %12, %2
  %14 = select i1 %11, i1 %13, i1 false
  %15 = add nsw i64 %7, 2
  %16 = select i1 %14, i64 %15, i64 %12
  %17 = add nuw nsw i64 %8, 1
  %18 = icmp slt i64 %16, %2
  br i1 %18, label %6, label %19, !llvm.loop !20

19:                                               ; preds = %6, %3
  %20 = phi i64 [ 0, %3 ], [ %17, %6 ]
  ret i64 %20
}

; Function Attrs: nounwind ssp uwtable(sync)
define void @r0_print(ptr noundef %0) local_unnamed_addr #1 {
  %2 = load ptr, ptr @__stdoutp, align 8, !tbaa !21
  %3 = tail call i32 @"\01_fputs"(ptr noundef %0, ptr noundef %2) #24
  ret void
}

declare i32 @"\01_fputs"(ptr noundef, ptr noundef) local_unnamed_addr #4

; Function Attrs: nofree nounwind ssp uwtable(sync)
define void @r0_printint(i64 noundef %0) local_unnamed_addr #5 {
  %2 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str, i64 noundef %0)
  ret void
}

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr noundef readonly captures(none), ...) local_unnamed_addr #6

; Function Attrs: mustprogress nofree norecurse nosync nounwind ssp willreturn memory(argmem: read) uwtable(sync)
define range(i64 0, 256) i64 @r0_b(ptr noundef readonly captures(none) %0, i64 noundef %1) local_unnamed_addr #7 {
  %3 = getelementptr inbounds i8, ptr %0, i64 %1
  %4 = load i8, ptr %3, align 1, !tbaa !18
  %5 = zext i8 %4 to i64
  ret i64 %5
}

; Function Attrs: mustprogress nofree norecurse nounwind ssp willreturn memory(argmem: read) uwtable(sync)
define range(i64 0, 2) i64 @r0_sp_eq(ptr noundef readonly captures(none) %0, i64 noundef %1, i64 noundef %2, i64 noundef %3, i64 noundef %4) local_unnamed_addr #8 {
  %6 = icmp eq i64 %2, %4
  br i1 %6, label %7, label %13

7:                                                ; preds = %5
  %8 = getelementptr inbounds i8, ptr %0, i64 %1
  %9 = getelementptr inbounds i8, ptr %0, i64 %3
  %10 = tail call i32 @memcmp(ptr noundef %8, ptr noundef %9, i64 noundef %2)
  %11 = icmp eq i32 %10, 0
  %12 = zext i1 %11 to i64
  br label %13

13:                                               ; preds = %5, %7
  %14 = phi i64 [ %12, %7 ], [ 0, %5 ]
  ret i64 %14
}

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: read)
declare i32 @memcmp(ptr noundef captures(none), ptr noundef captures(none), i64 noundef) local_unnamed_addr #9

; Function Attrs: mustprogress nofree norecurse nounwind ssp willreturn memory(read, inaccessiblemem: none, target_mem0: none, target_mem1: none) uwtable(sync)
define range(i64 0, 2) i64 @r0_kw(ptr noundef readonly captures(none) %0, i64 noundef %1, i64 noundef %2, i64 noundef %3) local_unnamed_addr #10 {
  %5 = icmp ugt i64 %3, 21
  br i1 %5, label %16, label %6

6:                                                ; preds = %4
  %7 = getelementptr inbounds nuw ptr, ptr @KWS, i64 %3
  %8 = load ptr, ptr %7, align 8, !tbaa !10
  %9 = tail call i64 @strlen(ptr noundef nonnull dereferenceable(1) %8) #24
  %10 = icmp eq i64 %9, %2
  br i1 %10, label %11, label %16

11:                                               ; preds = %6
  %12 = getelementptr inbounds i8, ptr %0, i64 %1
  %13 = tail call i32 @memcmp(ptr noundef %12, ptr noundef nonnull %8, i64 noundef %9)
  %14 = icmp eq i32 %13, 0
  %15 = zext i1 %14 to i64
  br label %16

16:                                               ; preds = %11, %6, %4
  %17 = phi i64 [ 0, %4 ], [ %15, %11 ], [ 0, %6 ]
  ret i64 %17
}

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: read)
declare i64 @strlen(ptr noundef captures(none)) local_unnamed_addr #9

; Function Attrs: mustprogress nofree norecurse nounwind ssp willreturn memory(argmem: read) uwtable(sync)
define range(i64 0, 2) i64 @r0_mt(ptr noundef readonly captures(none) %0, i64 noundef %1, i64 noundef %2, i64 noundef %3) local_unnamed_addr #8 {
  %5 = icmp eq i64 %3, 0
  %6 = icmp eq i64 %2, 6
  %7 = and i1 %6, %5
  br i1 %7, label %8, label %13

8:                                                ; preds = %4
  %9 = getelementptr inbounds i8, ptr %0, i64 %1
  %10 = tail call i32 @memcmp(ptr noundef nonnull dereferenceable(6) %9, ptr noundef nonnull dereferenceable(6) @.str.31, i64 noundef 6)
  %11 = icmp eq i32 %10, 0
  %12 = zext i1 %11 to i64
  br label %13

13:                                               ; preds = %8, %4
  %14 = phi i64 [ 0, %4 ], [ %12, %8 ]
  ret i64 %14
}

; Function Attrs: nofree norecurse nounwind ssp uwtable(sync)
define i64 @r0_parseint(ptr noundef readonly captures(none) %0, i64 noundef %1, i64 noundef %2) local_unnamed_addr #11 {
  %4 = alloca [80 x i8], align 1
  call void @llvm.lifetime.start.p0(ptr nonnull %4) #24
  %5 = tail call i64 @llvm.smin.i64(i64 %2, i64 79)
  %6 = getelementptr inbounds i8, ptr %0, i64 %1
  %7 = call ptr @__memcpy_chk(ptr noundef nonnull %4, ptr noundef %6, i64 noundef %5, i64 noundef 80) #24
  %8 = getelementptr inbounds i8, ptr %4, i64 %5
  store i8 0, ptr %8, align 1, !tbaa !18
  %9 = call i64 @strtoll(ptr noundef nonnull captures(none) %4, ptr noundef null, i32 noundef 10)
  call void @llvm.lifetime.end.p0(ptr nonnull %4) #24
  ret i64 %9
}

; Function Attrs: nocallback nofree nounwind memory(argmem: readwrite)
declare ptr @__memcpy_chk(ptr noalias noundef writeonly, ptr noalias noundef readonly captures(none), i64 noundef, i64 noundef) local_unnamed_addr #12

; Function Attrs: mustprogress nocallback nofree nounwind willreturn
declare i64 @strtoll(ptr noundef readonly, ptr noundef captures(none), i32 noundef) local_unnamed_addr #13

; Function Attrs: nofree norecurse nounwind ssp memory(argmem: readwrite) uwtable(sync)
define void @r0_zf(ptr noundef %0, i64 noundef %1) local_unnamed_addr #14 {
  tail call void @llvm.memset.p0.i64(ptr noundef align 1 %0, i8 noundef 0, i64 noundef %1, i1 noundef false) #24
  ret void
}

; Function Attrs: nounwind ssp uwtable(sync)
define void @r0_load(ptr noundef %0) local_unnamed_addr #1 {
  %2 = tail call ptr @"\01_fopen"(ptr noundef %0, ptr noundef nonnull @.str.3) #24
  %3 = icmp eq ptr %2, null
  br i1 %3, label %4, label %7

4:                                                ; preds = %1
  %5 = load ptr, ptr @__stderrp, align 8, !tbaa !21
  %6 = tail call i32 (ptr, ptr, ...) @fprintf(ptr noundef %5, ptr noundef nonnull @.str.4, ptr noundef %0) #24
  tail call void @exit(i32 noundef 1) #26
  unreachable

7:                                                ; preds = %1
  %8 = tail call i32 @fseek(ptr noundef nonnull %2, i64 noundef 0, i32 noundef 2)
  %9 = tail call i64 @ftell(ptr noundef nonnull %2)
  %10 = tail call i32 @fseek(ptr noundef nonnull %2, i64 noundef 0, i32 noundef 0)
  %11 = add i64 %9, 1
  %12 = tail call ptr @malloc(i64 noundef %11) #25
  %13 = tail call i64 @fread(ptr noundef %12, i64 noundef 1, i64 noundef %9, ptr noundef nonnull %2)
  %14 = tail call i32 @fclose(ptr noundef nonnull %2)
  %15 = getelementptr inbounds i8, ptr %12, i64 %13
  store i8 0, ptr %15, align 1, !tbaa !18
  store ptr %12, ptr @SRC, align 8, !tbaa !10
  store i64 %13, ptr @SRCN, align 8, !tbaa !13
  ret void
}

declare ptr @"\01_fopen"(ptr noundef, ptr noundef) local_unnamed_addr #4

; Function Attrs: nofree nounwind
declare noundef i32 @fprintf(ptr noundef captures(none), ptr noundef readonly captures(none), ...) local_unnamed_addr #6

; Function Attrs: nofree noreturn
declare void @exit(i32 noundef) local_unnamed_addr #15

; Function Attrs: nofree nounwind
declare noundef i32 @fseek(ptr noundef captures(none), i64 noundef, i32 noundef) local_unnamed_addr #6

; Function Attrs: nofree nounwind
declare noundef i64 @ftell(ptr noundef captures(none)) local_unnamed_addr #6

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @malloc(i64 noundef) local_unnamed_addr #16

; Function Attrs: nofree nounwind
declare noundef i64 @fread(ptr noundef writeonly captures(none), i64 noundef, i64 noundef, ptr noundef captures(none)) local_unnamed_addr #6

; Function Attrs: nofree nounwind
declare noundef i32 @fclose(ptr noundef captures(none)) local_unnamed_addr #6

; Function Attrs: mustprogress nofree norecurse nosync nounwind ssp willreturn memory(read, argmem: none, inaccessiblemem: none, target_mem0: none, target_mem1: none) uwtable(sync)
define ptr @r0_srcp() local_unnamed_addr #17 {
  %1 = load ptr, ptr @SRC, align 8, !tbaa !10
  ret ptr %1
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind ssp willreturn memory(read, argmem: none, inaccessiblemem: none, target_mem0: none, target_mem1: none) uwtable(sync)
define i64 @r0_srclen() local_unnamed_addr #17 {
  %1 = load i64, ptr @SRCN, align 8, !tbaa !13
  ret i64 %1
}

; Function Attrs: nounwind ssp uwtable(sync)
define void @r0_save(ptr noundef %0) local_unnamed_addr #1 {
  %2 = tail call ptr @"\01_fopen"(ptr noundef %0, ptr noundef nonnull @.str.5) #24
  %3 = icmp eq ptr %2, null
  br i1 %3, label %4, label %7

4:                                                ; preds = %1
  %5 = load ptr, ptr @__stderrp, align 8, !tbaa !21
  %6 = tail call i32 (ptr, ptr, ...) @fprintf(ptr noundef %5, ptr noundef nonnull @.str.6, ptr noundef %0) #24
  tail call void @exit(i32 noundef 1) #26
  unreachable

7:                                                ; preds = %1
  %8 = load ptr, ptr @OUT, align 8, !tbaa !10
  %9 = icmp eq ptr %8, null
  br i1 %9, label %13, label %10

10:                                               ; preds = %7
  %11 = load i64, ptr @OLEN, align 8, !tbaa !13
  %12 = tail call i64 @"\01_fwrite"(ptr noundef nonnull %8, i64 noundef 1, i64 noundef %11, ptr noundef nonnull %2) #24
  br label %13

13:                                               ; preds = %10, %7
  %14 = tail call i32 @fclose(ptr noundef nonnull %2)
  ret void
}

declare i64 @"\01_fwrite"(ptr noundef, i64 noundef, i64 noundef, ptr noundef) local_unnamed_addr #4

; Function Attrs: cold nofree noreturn nounwind ssp uwtable(sync)
define void @r0_pc(ptr noundef %0, i64 noundef %1) local_unnamed_addr #18 {
  %3 = load ptr, ptr @__stderrp, align 8, !tbaa !21
  %4 = tail call i32 (ptr, ptr, ...) @fprintf(ptr noundef %3, ptr noundef nonnull @.str.7, ptr noundef %0, i64 noundef %1) #24
  tail call void @exit(i32 noundef 1) #26
  unreachable
}

; Function Attrs: nofree nounwind ssp uwtable(sync)
define void @r0_wchd(i64 noundef %0) local_unnamed_addr #5 {
  %2 = trunc i64 %0 to i32
  %3 = load ptr, ptr @__stderrp, align 8, !tbaa !21
  %4 = tail call i32 @putc(i32 noundef %2, ptr noundef %3)
  ret void
}

; Function Attrs: nofree nounwind
declare noundef i32 @putc(i32 noundef, ptr noundef captures(none)) local_unnamed_addr #6

; Function Attrs: nofree nounwind ssp uwtable(sync)
define void @r0_wchd2(i64 noundef %0) local_unnamed_addr #5 {
  %2 = load ptr, ptr @__stderrp, align 8, !tbaa !21
  %3 = tail call i32 (ptr, ptr, ...) @fprintf(ptr noundef %2, ptr noundef nonnull @.str, i64 noundef %0) #24
  ret void
}

; Function Attrs: cold nofree noreturn nounwind ssp uwtable(sync)
define void @r0_panic(ptr noundef %0) local_unnamed_addr #18 {
  %2 = load ptr, ptr @__stderrp, align 8, !tbaa !21
  %3 = tail call i32 (ptr, ptr, ...) @fprintf(ptr noundef %2, ptr noundef nonnull @.str.8, ptr noundef %0) #24
  tail call void @exit(i32 noundef 1) #26
  unreachable
}

; Function Attrs: nounwind ssp uwtable(sync)
define range(i64 -2147483648, 2147483648) i64 @r0_argc() local_unnamed_addr #1 {
  %1 = load ptr, ptr @R0ARGV, align 8, !tbaa !23
  %2 = icmp eq ptr %1, null
  br i1 %2, label %3, label %8

3:                                                ; preds = %0
  %4 = tail call ptr @_NSGetArgc() #24
  %5 = load i32, ptr %4, align 4, !tbaa !6
  store i32 %5, ptr @R0ARGC, align 4, !tbaa !6
  %6 = tail call ptr @_NSGetArgv() #24
  %7 = load ptr, ptr %6, align 8, !tbaa !23
  store ptr %7, ptr @R0ARGV, align 8, !tbaa !23
  br label %8

8:                                                ; preds = %0, %3
  %9 = load i32, ptr @R0ARGC, align 4, !tbaa !6
  %10 = sext i32 %9 to i64
  ret i64 %10
}

; Function Attrs: nounwind ssp uwtable(sync)
define ptr @r0_arg(i64 noundef %0) local_unnamed_addr #1 {
  %2 = load ptr, ptr @R0ARGV, align 8, !tbaa !23
  %3 = icmp eq ptr %2, null
  br i1 %3, label %4, label %9

4:                                                ; preds = %1
  %5 = tail call ptr @_NSGetArgc() #24
  %6 = load i32, ptr %5, align 4, !tbaa !6
  store i32 %6, ptr @R0ARGC, align 4, !tbaa !6
  %7 = tail call ptr @_NSGetArgv() #24
  %8 = load ptr, ptr %7, align 8, !tbaa !23
  store ptr %8, ptr @R0ARGV, align 8, !tbaa !23
  br label %9

9:                                                ; preds = %1, %4
  %10 = load ptr, ptr @R0ARGV, align 8, !tbaa !23
  %11 = getelementptr inbounds ptr, ptr %10, i64 %0
  %12 = load ptr, ptr %11, align 8, !tbaa !10
  ret ptr %12
}

; Function Attrs: nounwind ssp uwtable(sync)
define noundef i32 @main(i32 noundef %0, ptr noundef %1) local_unnamed_addr #1 {
  store i32 %0, ptr @R0ARGC, align 4, !tbaa !6
  store ptr %1, ptr @R0ARGV, align 8, !tbaa !23
  tail call void @r0fn_main() #24
  ret i32 0
}

declare void @r0fn_main() local_unnamed_addr #4

; Function Attrs: mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @free(ptr allocptr noundef captures(none)) local_unnamed_addr #19

declare ptr @_NSGetArgc() local_unnamed_addr #4

declare ptr @_NSGetArgv() local_unnamed_addr #4

; Function Attrs: nofree nounwind
declare noundef i32 @snprintf(ptr noalias noundef writeonly captures(none), i64 noundef, ptr noundef readonly captures(none), ...) local_unnamed_addr #20

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.smin.i64(i64, i64) #21

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #22

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #23

attributes #0 = { nounwind ssp memory(readwrite, target_mem0: none, target_mem1: none) uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #1 = { nounwind ssp uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { nofree norecurse nosync nounwind ssp memory(argmem: read) uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #4 = { "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #5 = { nofree nounwind ssp uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #6 = { nofree nounwind "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #7 = { mustprogress nofree norecurse nosync nounwind ssp willreturn memory(argmem: read) uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #8 = { mustprogress nofree norecurse nounwind ssp willreturn memory(argmem: read) uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #9 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: read) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #10 = { mustprogress nofree norecurse nounwind ssp willreturn memory(read, inaccessiblemem: none, target_mem0: none, target_mem1: none) uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #11 = { nofree norecurse nounwind ssp uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #12 = { nocallback nofree nounwind memory(argmem: readwrite) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #13 = { mustprogress nocallback nofree nounwind willreturn "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #14 = { nofree norecurse nounwind ssp memory(argmem: readwrite) uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #15 = { nofree noreturn "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #16 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #17 = { mustprogress nofree norecurse nosync nounwind ssp willreturn memory(read, argmem: none, inaccessiblemem: none, target_mem0: none, target_mem1: none) uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #18 = { cold nofree noreturn nounwind ssp uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #19 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #20 = { nofree nounwind }
attributes #21 = { nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) }
attributes #22 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #23 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #24 = { nounwind }
attributes #25 = { allocsize(0) }
attributes #26 = { cold noreturn nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}
!llvm.errno.tbaa = !{!6}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 15, i32 2]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 4}
!5 = !{!"Homebrew clang version 22.1.4"}
!6 = !{!7, !7, i64 0}
!7 = !{!"int", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = !{!11, !11, i64 0}
!11 = !{!"p1 omnipotent char", !12, i64 0}
!12 = !{!"any pointer", !8, i64 0}
!13 = !{!14, !14, i64 0}
!14 = !{!"long", !8, i64 0}
!15 = distinct !{!15, !16, !17}
!16 = !{!"llvm.loop.mustprogress"}
!17 = !{!"llvm.loop.unroll.disable"}
!18 = !{!8, !8, i64 0}
!19 = distinct !{!19, !16, !17}
!20 = distinct !{!20, !16, !17}
!21 = !{!22, !22, i64 0}
!22 = !{!"p1 _ZTS7__sFILE", !12, i64 0}
!23 = !{!24, !24, i64 0}
!24 = !{!"p2 omnipotent char", !25, i64 0}
!25 = !{!"any p2 pointer", !12, i64 0}
