; ModuleID = 'c4ll'
source_filename = "c4ll"

declare i32 @printf(ptr, ...)
declare ptr @malloc(i64)
declare void @free(ptr)
declare ptr @memset(ptr, i32, i64)
declare i32 @memcmp(ptr, ptr, i64)
declare i32 @open(ptr, i32, ...)
declare i32 @creat(ptr, i32)
declare i64 @read(i32, ptr, i64)
declare i64 @write(i32, ptr, i64)
declare i32 @close(i32)
declare void @exit(i32) noreturn

@.str.1 = private unnamed_addr constant [9 x i8] c"argc=%d\0a\00"
@.str.2 = private unnamed_addr constant [13 x i8] c"argv[%d]=%s\0a\00"
@.str.3 = private unnamed_addr constant [23 x i8] c"len(%s)=%d len(%s)=%d\0a\00"

define i64 @strlen(i64 %a.0) {
entry:
  %s.0 = alloca i64
  store i64 %a.0, ptr %s.0
  %s.1 = alloca i64
  %a1 = ptrtoint ptr %s.1 to i64
  %p2 = inttoptr i64 %a1 to ptr
  %v3 = load i64, ptr %p2
  %p4 = inttoptr i64 %a1 to ptr
  store i64 0, ptr %p4
  br label %wh.cond.1
wh.cond.1:
  %a5 = ptrtoint ptr %s.0 to i64
  %p6 = inttoptr i64 %a5 to ptr
  %v7 = load i64, ptr %p6
  %p8 = inttoptr i64 %v7 to ptr
  %b9 = load i8, ptr %p8
  %c10 = sext i8 %b9 to i64
  %c11 = icmp ne i64 %c10, 0
  br i1 %c11, label %wh.body.2, label %wh.end.3
wh.body.2:
  %a12 = ptrtoint ptr %s.1 to i64
  %p13 = inttoptr i64 %a12 to ptr
  %v14 = load i64, ptr %p13
  %a15 = ptrtoint ptr %s.1 to i64
  %p16 = inttoptr i64 %a15 to ptr
  %v17 = load i64, ptr %p16
  %t18 = add i64 %v17, 1
  %p19 = inttoptr i64 %a12 to ptr
  store i64 %t18, ptr %p19
  %a20 = ptrtoint ptr %s.0 to i64
  %p21 = inttoptr i64 %a20 to ptr
  %v22 = load i64, ptr %p21
  %a23 = ptrtoint ptr %s.0 to i64
  %p24 = inttoptr i64 %a23 to ptr
  %v25 = load i64, ptr %p24
  %t26 = add i64 %v25, 1
  %p27 = inttoptr i64 %a20 to ptr
  store i64 %t26, ptr %p27
  br label %wh.cond.1
wh.end.3:
  %a28 = ptrtoint ptr %s.1 to i64
  %p29 = inttoptr i64 %a28 to ptr
  %v30 = load i64, ptr %p29
  ret i64 %v30
}

define i32 @main(i32 %.argc, ptr %.argv) {
entry:
  %s.0 = alloca i64
  %ac1 = sext i32 %.argc to i64
  store i64 %ac1, ptr %s.0
  %s.1 = alloca i64
  %av2 = ptrtoint ptr %.argv to i64
  store i64 %av2, ptr %s.1
  %s.2 = alloca i64
  %a3 = ptrtoint ptr @.str.1 to i64
  %a4 = ptrtoint ptr %s.0 to i64
  %p5 = inttoptr i64 %a4 to ptr
  %v6 = load i64, ptr %p5
  %p7 = inttoptr i64 %a3 to ptr
  %r8 = call i32 (ptr, ...) @printf(ptr %p7, i64 %v6)
  %v9 = sext i32 %r8 to i64
  %a10 = ptrtoint ptr %s.2 to i64
  %p11 = inttoptr i64 %a10 to ptr
  %v12 = load i64, ptr %p11
  %p13 = inttoptr i64 %a10 to ptr
  store i64 1, ptr %p13
  br label %wh.cond.1
wh.cond.1:
  %a14 = ptrtoint ptr %s.2 to i64
  %p15 = inttoptr i64 %a14 to ptr
  %v16 = load i64, ptr %p15
  %a17 = ptrtoint ptr %s.0 to i64
  %p18 = inttoptr i64 %a17 to ptr
  %v19 = load i64, ptr %p18
  %c20 = icmp slt i64 %v16, %v19
  %b21 = zext i1 %c20 to i64
  %c22 = icmp ne i64 %b21, 0
  br i1 %c22, label %wh.body.2, label %wh.end.3
wh.body.2:
  %a23 = ptrtoint ptr @.str.2 to i64
  %a24 = ptrtoint ptr %s.2 to i64
  %p25 = inttoptr i64 %a24 to ptr
  %v26 = load i64, ptr %p25
  %a27 = ptrtoint ptr %s.1 to i64
  %p28 = inttoptr i64 %a27 to ptr
  %v29 = load i64, ptr %p28
  %a30 = ptrtoint ptr %s.2 to i64
  %p31 = inttoptr i64 %a30 to ptr
  %v32 = load i64, ptr %p31
  %t33 = mul i64 %v32, 8
  %t34 = add i64 %v29, %t33
  %p35 = inttoptr i64 %t34 to ptr
  %v36 = load i64, ptr %p35
  %p37 = inttoptr i64 %a23 to ptr
  %r38 = call i32 (ptr, ...) @printf(ptr %p37, i64 %v26, i64 %v36)
  %v39 = sext i32 %r38 to i64
  %a40 = ptrtoint ptr %s.2 to i64
  %p41 = inttoptr i64 %a40 to ptr
  %v42 = load i64, ptr %p41
  %a43 = ptrtoint ptr %s.2 to i64
  %p44 = inttoptr i64 %a43 to ptr
  %v45 = load i64, ptr %p44
  %t46 = add i64 %v45, 1
  %p47 = inttoptr i64 %a40 to ptr
  store i64 %t46, ptr %p47
  br label %wh.cond.1
wh.end.3:
  %a48 = ptrtoint ptr @.str.3 to i64
  %a49 = ptrtoint ptr %s.1 to i64
  %p50 = inttoptr i64 %a49 to ptr
  %v51 = load i64, ptr %p50
  %t52 = mul i64 1, 8
  %t53 = add i64 %v51, %t52
  %p54 = inttoptr i64 %t53 to ptr
  %v55 = load i64, ptr %p54
  %a56 = ptrtoint ptr %s.1 to i64
  %p57 = inttoptr i64 %a56 to ptr
  %v58 = load i64, ptr %p57
  %t59 = mul i64 1, 8
  %t60 = add i64 %v58, %t59
  %p61 = inttoptr i64 %t60 to ptr
  %v62 = load i64, ptr %p61
  %r63 = call i64 @strlen(i64 %v62)
  %a64 = ptrtoint ptr %s.1 to i64
  %p65 = inttoptr i64 %a64 to ptr
  %v66 = load i64, ptr %p65
  %t67 = mul i64 2, 8
  %t68 = add i64 %v66, %t67
  %p69 = inttoptr i64 %t68 to ptr
  %v70 = load i64, ptr %p69
  %a71 = ptrtoint ptr %s.1 to i64
  %p72 = inttoptr i64 %a71 to ptr
  %v73 = load i64, ptr %p72
  %t74 = mul i64 2, 8
  %t75 = add i64 %v73, %t74
  %p76 = inttoptr i64 %t75 to ptr
  %v77 = load i64, ptr %p76
  %r78 = call i64 @strlen(i64 %v77)
  %p79 = inttoptr i64 %a48 to ptr
  %r80 = call i32 (ptr, ...) @printf(ptr %p79, i64 %v55, i64 %r63, i64 %v70, i64 %r78)
  %v81 = sext i32 %r80 to i64
  %rv82 = trunc i64 0 to i32
  ret i32 %rv82
}

