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

@.str.1 = private unnamed_addr constant [6 x i8] c"hello\00"
@.str.2 = private unnamed_addr constant [11 x i8] c"len=%d %s\0a\00"
@.str.3 = private unnamed_addr constant [23 x i8] c"cmp eq=%d lt=%d gt=%d\0a\00"
@.str.4 = private unnamed_addr constant [6 x i8] c"hello\00"
@.str.5 = private unnamed_addr constant [6 x i8] c"hellp\00"
@.str.6 = private unnamed_addr constant [5 x i8] c"hell\00"
@.str.7 = private unnamed_addr constant [8 x i8] c"abcdefg\00"
@.str.8 = private unnamed_addr constant [15 x i8] c"rev=%s len=%d\0a\00"
@.str.9 = private unnamed_addr constant [6 x i8] c"hello\00"
@.str.10 = private unnamed_addr constant [8 x i8] c", world\00"
@.str.11 = private unnamed_addr constant [8 x i8] c"cat=%s\0a\00"
@.str.12 = private unnamed_addr constant [10 x i8] c"upper=%s\0a\00"

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

define i64 @strcmp(i64 %a.0, i64 %a.1) {
entry:
  %s.0 = alloca i64
  store i64 %a.0, ptr %s.0
  %s.1 = alloca i64
  store i64 %a.1, ptr %s.1
  br label %wh.cond.1
wh.cond.1:
  %a1 = ptrtoint ptr %s.0 to i64
  %p2 = inttoptr i64 %a1 to ptr
  %v3 = load i64, ptr %p2
  %p4 = inttoptr i64 %v3 to ptr
  %b5 = load i8, ptr %p4
  %c6 = sext i8 %b5 to i64
  %c7 = icmp ne i64 %c6, 0
  br i1 %c7, label %lan.rhs.4, label %lan.end.5
lan.rhs.4:
  %a8 = ptrtoint ptr %s.0 to i64
  %p9 = inttoptr i64 %a8 to ptr
  %v10 = load i64, ptr %p9
  %p11 = inttoptr i64 %v10 to ptr
  %b12 = load i8, ptr %p11
  %c13 = sext i8 %b12 to i64
  %a14 = ptrtoint ptr %s.1 to i64
  %p15 = inttoptr i64 %a14 to ptr
  %v16 = load i64, ptr %p15
  %p17 = inttoptr i64 %v16 to ptr
  %b18 = load i8, ptr %p17
  %c19 = sext i8 %b18 to i64
  %c20 = icmp eq i64 %c13, %c19
  %b21 = zext i1 %c20 to i64
  %c22 = icmp ne i64 %b21, 0
  br label %lan.end.5
lan.end.5:
  %b23 = phi i1 [ false, %wh.cond.1 ], [ %c22, %lan.rhs.4 ]
  %b24 = zext i1 %b23 to i64
  %c25 = icmp ne i64 %b24, 0
  br i1 %c25, label %wh.body.2, label %wh.end.3
wh.body.2:
  %a26 = ptrtoint ptr %s.0 to i64
  %p27 = inttoptr i64 %a26 to ptr
  %v28 = load i64, ptr %p27
  %a29 = ptrtoint ptr %s.0 to i64
  %p30 = inttoptr i64 %a29 to ptr
  %v31 = load i64, ptr %p30
  %t32 = add i64 %v31, 1
  %p33 = inttoptr i64 %a26 to ptr
  store i64 %t32, ptr %p33
  %a34 = ptrtoint ptr %s.1 to i64
  %p35 = inttoptr i64 %a34 to ptr
  %v36 = load i64, ptr %p35
  %a37 = ptrtoint ptr %s.1 to i64
  %p38 = inttoptr i64 %a37 to ptr
  %v39 = load i64, ptr %p38
  %t40 = add i64 %v39, 1
  %p41 = inttoptr i64 %a34 to ptr
  store i64 %t40, ptr %p41
  br label %wh.cond.1
wh.end.3:
  %a42 = ptrtoint ptr %s.0 to i64
  %p43 = inttoptr i64 %a42 to ptr
  %v44 = load i64, ptr %p43
  %p45 = inttoptr i64 %v44 to ptr
  %b46 = load i8, ptr %p45
  %c47 = sext i8 %b46 to i64
  %a48 = ptrtoint ptr %s.1 to i64
  %p49 = inttoptr i64 %a48 to ptr
  %v50 = load i64, ptr %p49
  %p51 = inttoptr i64 %v50 to ptr
  %b52 = load i8, ptr %p51
  %c53 = sext i8 %b52 to i64
  %t54 = sub i64 %c47, %c53
  ret i64 %t54
}

define i64 @strcpy(i64 %a.0, i64 %a.1) {
entry:
  %s.0 = alloca i64
  store i64 %a.0, ptr %s.0
  %s.1 = alloca i64
  store i64 %a.1, ptr %s.1
  %s.2 = alloca i64
  %a1 = ptrtoint ptr %s.2 to i64
  %p2 = inttoptr i64 %a1 to ptr
  %v3 = load i64, ptr %p2
  %a4 = ptrtoint ptr %s.0 to i64
  %p5 = inttoptr i64 %a4 to ptr
  %v6 = load i64, ptr %p5
  %p7 = inttoptr i64 %a1 to ptr
  store i64 %v6, ptr %p7
  br label %wh.cond.1
wh.cond.1:
  %a8 = ptrtoint ptr %s.1 to i64
  %p9 = inttoptr i64 %a8 to ptr
  %v10 = load i64, ptr %p9
  %p11 = inttoptr i64 %v10 to ptr
  %b12 = load i8, ptr %p11
  %c13 = sext i8 %b12 to i64
  %c14 = icmp ne i64 %c13, 0
  br i1 %c14, label %wh.body.2, label %wh.end.3
wh.body.2:
  %a15 = ptrtoint ptr %s.0 to i64
  %p16 = inttoptr i64 %a15 to ptr
  %v17 = load i64, ptr %p16
  %p18 = inttoptr i64 %v17 to ptr
  %b19 = load i8, ptr %p18
  %c20 = sext i8 %b19 to i64
  %a21 = ptrtoint ptr %s.1 to i64
  %p22 = inttoptr i64 %a21 to ptr
  %v23 = load i64, ptr %p22
  %p24 = inttoptr i64 %v23 to ptr
  %b25 = load i8, ptr %p24
  %c26 = sext i8 %b25 to i64
  %p27 = inttoptr i64 %v17 to ptr
  %b28 = trunc i64 %c26 to i8
  store i8 %b28, ptr %p27
  %a29 = ptrtoint ptr %s.0 to i64
  %p30 = inttoptr i64 %a29 to ptr
  %v31 = load i64, ptr %p30
  %a32 = ptrtoint ptr %s.0 to i64
  %p33 = inttoptr i64 %a32 to ptr
  %v34 = load i64, ptr %p33
  %t35 = add i64 %v34, 1
  %p36 = inttoptr i64 %a29 to ptr
  store i64 %t35, ptr %p36
  %a37 = ptrtoint ptr %s.1 to i64
  %p38 = inttoptr i64 %a37 to ptr
  %v39 = load i64, ptr %p38
  %a40 = ptrtoint ptr %s.1 to i64
  %p41 = inttoptr i64 %a40 to ptr
  %v42 = load i64, ptr %p41
  %t43 = add i64 %v42, 1
  %p44 = inttoptr i64 %a37 to ptr
  store i64 %t43, ptr %p44
  br label %wh.cond.1
wh.end.3:
  %a45 = ptrtoint ptr %s.0 to i64
  %p46 = inttoptr i64 %a45 to ptr
  %v47 = load i64, ptr %p46
  %p48 = inttoptr i64 %v47 to ptr
  %b49 = load i8, ptr %p48
  %c50 = sext i8 %b49 to i64
  %p51 = inttoptr i64 %v47 to ptr
  %b52 = trunc i64 0 to i8
  store i8 %b52, ptr %p51
  %a53 = ptrtoint ptr %s.2 to i64
  %p54 = inttoptr i64 %a53 to ptr
  %v55 = load i64, ptr %p54
  ret i64 %v55
}

define i64 @strcat(i64 %a.0, i64 %a.1) {
entry:
  %s.0 = alloca i64
  store i64 %a.0, ptr %s.0
  %s.1 = alloca i64
  store i64 %a.1, ptr %s.1
  %a1 = ptrtoint ptr %s.0 to i64
  %p2 = inttoptr i64 %a1 to ptr
  %v3 = load i64, ptr %p2
  %a4 = ptrtoint ptr %s.0 to i64
  %p5 = inttoptr i64 %a4 to ptr
  %v6 = load i64, ptr %p5
  %a7 = ptrtoint ptr %s.0 to i64
  %p8 = inttoptr i64 %a7 to ptr
  %v9 = load i64, ptr %p8
  %r10 = call i64 @strlen(i64 %v9)
  %t11 = add i64 %v6, %r10
  %p12 = inttoptr i64 %a1 to ptr
  store i64 %t11, ptr %p12
  %a13 = ptrtoint ptr %s.0 to i64
  %p14 = inttoptr i64 %a13 to ptr
  %v15 = load i64, ptr %p14
  %a16 = ptrtoint ptr %s.1 to i64
  %p17 = inttoptr i64 %a16 to ptr
  %v18 = load i64, ptr %p17
  %r19 = call i64 @strcpy(i64 %v15, i64 %v18)
  %a20 = ptrtoint ptr %s.0 to i64
  %p21 = inttoptr i64 %a20 to ptr
  %v22 = load i64, ptr %p21
  ret i64 %v22
}

define i64 @upper(i64 %a.0) {
entry:
  %s.0 = alloca i64
  store i64 %a.0, ptr %s.0
  %s.1 = alloca i64
  %s.2 = alloca i64
  %a1 = ptrtoint ptr %s.1 to i64
  %p2 = inttoptr i64 %a1 to ptr
  %v3 = load i64, ptr %p2
  %a4 = ptrtoint ptr %s.0 to i64
  %p5 = inttoptr i64 %a4 to ptr
  %v6 = load i64, ptr %p5
  %p7 = inttoptr i64 %a1 to ptr
  store i64 %v6, ptr %p7
  br label %wh.cond.1
wh.cond.1:
  %a8 = ptrtoint ptr %s.0 to i64
  %p9 = inttoptr i64 %a8 to ptr
  %v10 = load i64, ptr %p9
  %p11 = inttoptr i64 %v10 to ptr
  %b12 = load i8, ptr %p11
  %c13 = sext i8 %b12 to i64
  %c14 = icmp ne i64 %c13, 0
  br i1 %c14, label %wh.body.2, label %wh.end.3
wh.body.2:
  %a15 = ptrtoint ptr %s.2 to i64
  %p16 = inttoptr i64 %a15 to ptr
  %b17 = load i8, ptr %p16
  %c18 = sext i8 %b17 to i64
  %a19 = ptrtoint ptr %s.0 to i64
  %p20 = inttoptr i64 %a19 to ptr
  %v21 = load i64, ptr %p20
  %p22 = inttoptr i64 %v21 to ptr
  %b23 = load i8, ptr %p22
  %c24 = sext i8 %b23 to i64
  %p25 = inttoptr i64 %a15 to ptr
  %b26 = trunc i64 %c24 to i8
  store i8 %b26, ptr %p25
  %a27 = ptrtoint ptr %s.2 to i64
  %p28 = inttoptr i64 %a27 to ptr
  %b29 = load i8, ptr %p28
  %c30 = sext i8 %b29 to i64
  %c31 = icmp sge i64 %c30, 97
  %b32 = zext i1 %c31 to i64
  %c33 = icmp ne i64 %b32, 0
  br i1 %c33, label %lan.rhs.4, label %lan.end.5
lan.rhs.4:
  %a34 = ptrtoint ptr %s.2 to i64
  %p35 = inttoptr i64 %a34 to ptr
  %b36 = load i8, ptr %p35
  %c37 = sext i8 %b36 to i64
  %c38 = icmp sle i64 %c37, 122
  %b39 = zext i1 %c38 to i64
  %c40 = icmp ne i64 %b39, 0
  br label %lan.end.5
lan.end.5:
  %b41 = phi i1 [ false, %wh.body.2 ], [ %c40, %lan.rhs.4 ]
  %b42 = zext i1 %b41 to i64
  %c43 = icmp ne i64 %b42, 0
  br i1 %c43, label %if.then.6, label %if.else.7
if.then.6:
  %a44 = ptrtoint ptr %s.0 to i64
  %p45 = inttoptr i64 %a44 to ptr
  %v46 = load i64, ptr %p45
  %p47 = inttoptr i64 %v46 to ptr
  %b48 = load i8, ptr %p47
  %c49 = sext i8 %b48 to i64
  %a50 = ptrtoint ptr %s.2 to i64
  %p51 = inttoptr i64 %a50 to ptr
  %b52 = load i8, ptr %p51
  %c53 = sext i8 %b52 to i64
  %t54 = sub i64 %c53, 97
  %t55 = add i64 %t54, 65
  %p56 = inttoptr i64 %v46 to ptr
  %b57 = trunc i64 %t55 to i8
  store i8 %b57, ptr %p56
  br label %if.end.8
if.else.7:
  br label %if.end.8
if.end.8:
  %a58 = ptrtoint ptr %s.0 to i64
  %p59 = inttoptr i64 %a58 to ptr
  %v60 = load i64, ptr %p59
  %a61 = ptrtoint ptr %s.0 to i64
  %p62 = inttoptr i64 %a61 to ptr
  %v63 = load i64, ptr %p62
  %t64 = add i64 %v63, 1
  %p65 = inttoptr i64 %a58 to ptr
  store i64 %t64, ptr %p65
  br label %wh.cond.1
wh.end.3:
  %a66 = ptrtoint ptr %s.1 to i64
  %p67 = inttoptr i64 %a66 to ptr
  %v68 = load i64, ptr %p67
  ret i64 %v68
}

define i32 @main(i32 %.argc, ptr %.argv) {
entry:
  %s.0 = alloca i64
  %s.1 = alloca i64
  %s.2 = alloca i64
  %s.3 = alloca i64
  %s.4 = alloca i64
  %a1 = ptrtoint ptr %s.0 to i64
  %p2 = inttoptr i64 %a1 to ptr
  %v3 = load i64, ptr %p2
  %a4 = ptrtoint ptr @.str.1 to i64
  %p5 = inttoptr i64 %a1 to ptr
  store i64 %a4, ptr %p5
  %a6 = ptrtoint ptr @.str.2 to i64
  %a7 = ptrtoint ptr %s.0 to i64
  %p8 = inttoptr i64 %a7 to ptr
  %v9 = load i64, ptr %p8
  %r10 = call i64 @strlen(i64 %v9)
  %a11 = ptrtoint ptr %s.0 to i64
  %p12 = inttoptr i64 %a11 to ptr
  %v13 = load i64, ptr %p12
  %p14 = inttoptr i64 %a6 to ptr
  %r15 = call i32 (ptr, ...) @printf(ptr %p14, i64 %r10, i64 %v13)
  %v16 = sext i32 %r15 to i64
  %a17 = ptrtoint ptr @.str.3 to i64
  %a18 = ptrtoint ptr %s.0 to i64
  %p19 = inttoptr i64 %a18 to ptr
  %v20 = load i64, ptr %p19
  %a21 = ptrtoint ptr @.str.4 to i64
  %r22 = call i64 @strcmp(i64 %v20, i64 %a21)
  %a23 = ptrtoint ptr %s.0 to i64
  %p24 = inttoptr i64 %a23 to ptr
  %v25 = load i64, ptr %p24
  %a26 = ptrtoint ptr @.str.5 to i64
  %r27 = call i64 @strcmp(i64 %v25, i64 %a26)
  %a28 = ptrtoint ptr %s.0 to i64
  %p29 = inttoptr i64 %a28 to ptr
  %v30 = load i64, ptr %p29
  %a31 = ptrtoint ptr @.str.6 to i64
  %r32 = call i64 @strcmp(i64 %v30, i64 %a31)
  %p33 = inttoptr i64 %a17 to ptr
  %r34 = call i32 (ptr, ...) @printf(ptr %p33, i64 %r22, i64 %r27, i64 %r32)
  %v35 = sext i32 %r34 to i64
  %a36 = ptrtoint ptr %s.1 to i64
  %p37 = inttoptr i64 %a36 to ptr
  %v38 = load i64, ptr %p37
  %r39 = call ptr @malloc(i64 32)
  %a40 = ptrtoint ptr %r39 to i64
  %p41 = inttoptr i64 %a36 to ptr
  store i64 %a40, ptr %p41
  %a42 = ptrtoint ptr %s.1 to i64
  %p43 = inttoptr i64 %a42 to ptr
  %v44 = load i64, ptr %p43
  %a45 = ptrtoint ptr @.str.7 to i64
  %r46 = call i64 @strcpy(i64 %v44, i64 %a45)
  %a47 = ptrtoint ptr %s.2 to i64
  %p48 = inttoptr i64 %a47 to ptr
  %v49 = load i64, ptr %p48
  %p50 = inttoptr i64 %a47 to ptr
  store i64 0, ptr %p50
  %a51 = ptrtoint ptr %s.3 to i64
  %p52 = inttoptr i64 %a51 to ptr
  %v53 = load i64, ptr %p52
  %a54 = ptrtoint ptr %s.1 to i64
  %p55 = inttoptr i64 %a54 to ptr
  %v56 = load i64, ptr %p55
  %r57 = call i64 @strlen(i64 %v56)
  %t58 = sub i64 %r57, 1
  %p59 = inttoptr i64 %a51 to ptr
  store i64 %t58, ptr %p59
  br label %wh.cond.1
wh.cond.1:
  %a60 = ptrtoint ptr %s.2 to i64
  %p61 = inttoptr i64 %a60 to ptr
  %v62 = load i64, ptr %p61
  %a63 = ptrtoint ptr %s.3 to i64
  %p64 = inttoptr i64 %a63 to ptr
  %v65 = load i64, ptr %p64
  %c66 = icmp slt i64 %v62, %v65
  %b67 = zext i1 %c66 to i64
  %c68 = icmp ne i64 %b67, 0
  br i1 %c68, label %wh.body.2, label %wh.end.3
wh.body.2:
  %a69 = ptrtoint ptr %s.4 to i64
  %p70 = inttoptr i64 %a69 to ptr
  %b71 = load i8, ptr %p70
  %c72 = sext i8 %b71 to i64
  %a73 = ptrtoint ptr %s.1 to i64
  %p74 = inttoptr i64 %a73 to ptr
  %v75 = load i64, ptr %p74
  %a76 = ptrtoint ptr %s.2 to i64
  %p77 = inttoptr i64 %a76 to ptr
  %v78 = load i64, ptr %p77
  %t79 = add i64 %v75, %v78
  %p80 = inttoptr i64 %t79 to ptr
  %b81 = load i8, ptr %p80
  %c82 = sext i8 %b81 to i64
  %p83 = inttoptr i64 %a69 to ptr
  %b84 = trunc i64 %c82 to i8
  store i8 %b84, ptr %p83
  %a85 = ptrtoint ptr %s.1 to i64
  %p86 = inttoptr i64 %a85 to ptr
  %v87 = load i64, ptr %p86
  %a88 = ptrtoint ptr %s.2 to i64
  %p89 = inttoptr i64 %a88 to ptr
  %v90 = load i64, ptr %p89
  %t91 = add i64 %v87, %v90
  %p92 = inttoptr i64 %t91 to ptr
  %b93 = load i8, ptr %p92
  %c94 = sext i8 %b93 to i64
  %a95 = ptrtoint ptr %s.1 to i64
  %p96 = inttoptr i64 %a95 to ptr
  %v97 = load i64, ptr %p96
  %a98 = ptrtoint ptr %s.3 to i64
  %p99 = inttoptr i64 %a98 to ptr
  %v100 = load i64, ptr %p99
  %t101 = add i64 %v97, %v100
  %p102 = inttoptr i64 %t101 to ptr
  %b103 = load i8, ptr %p102
  %c104 = sext i8 %b103 to i64
  %p105 = inttoptr i64 %t91 to ptr
  %b106 = trunc i64 %c104 to i8
  store i8 %b106, ptr %p105
  %a107 = ptrtoint ptr %s.1 to i64
  %p108 = inttoptr i64 %a107 to ptr
  %v109 = load i64, ptr %p108
  %a110 = ptrtoint ptr %s.3 to i64
  %p111 = inttoptr i64 %a110 to ptr
  %v112 = load i64, ptr %p111
  %t113 = add i64 %v109, %v112
  %p114 = inttoptr i64 %t113 to ptr
  %b115 = load i8, ptr %p114
  %c116 = sext i8 %b115 to i64
  %a117 = ptrtoint ptr %s.4 to i64
  %p118 = inttoptr i64 %a117 to ptr
  %b119 = load i8, ptr %p118
  %c120 = sext i8 %b119 to i64
  %p121 = inttoptr i64 %t113 to ptr
  %b122 = trunc i64 %c120 to i8
  store i8 %b122, ptr %p121
  %a123 = ptrtoint ptr %s.2 to i64
  %p124 = inttoptr i64 %a123 to ptr
  %v125 = load i64, ptr %p124
  %a126 = ptrtoint ptr %s.2 to i64
  %p127 = inttoptr i64 %a126 to ptr
  %v128 = load i64, ptr %p127
  %t129 = add i64 %v128, 1
  %p130 = inttoptr i64 %a123 to ptr
  store i64 %t129, ptr %p130
  %a131 = ptrtoint ptr %s.3 to i64
  %p132 = inttoptr i64 %a131 to ptr
  %v133 = load i64, ptr %p132
  %a134 = ptrtoint ptr %s.3 to i64
  %p135 = inttoptr i64 %a134 to ptr
  %v136 = load i64, ptr %p135
  %t137 = sub i64 %v136, 1
  %p138 = inttoptr i64 %a131 to ptr
  store i64 %t137, ptr %p138
  br label %wh.cond.1
wh.end.3:
  %a139 = ptrtoint ptr @.str.8 to i64
  %a140 = ptrtoint ptr %s.1 to i64
  %p141 = inttoptr i64 %a140 to ptr
  %v142 = load i64, ptr %p141
  %a143 = ptrtoint ptr %s.1 to i64
  %p144 = inttoptr i64 %a143 to ptr
  %v145 = load i64, ptr %p144
  %r146 = call i64 @strlen(i64 %v145)
  %p147 = inttoptr i64 %a139 to ptr
  %r148 = call i32 (ptr, ...) @printf(ptr %p147, i64 %v142, i64 %r146)
  %v149 = sext i32 %r148 to i64
  %a150 = ptrtoint ptr %s.1 to i64
  %p151 = inttoptr i64 %a150 to ptr
  %v152 = load i64, ptr %p151
  %a153 = ptrtoint ptr @.str.9 to i64
  %r154 = call i64 @strcpy(i64 %v152, i64 %a153)
  %a155 = ptrtoint ptr %s.1 to i64
  %p156 = inttoptr i64 %a155 to ptr
  %v157 = load i64, ptr %p156
  %a158 = ptrtoint ptr @.str.10 to i64
  %r159 = call i64 @strcat(i64 %v157, i64 %a158)
  %a160 = ptrtoint ptr @.str.11 to i64
  %a161 = ptrtoint ptr %s.1 to i64
  %p162 = inttoptr i64 %a161 to ptr
  %v163 = load i64, ptr %p162
  %p164 = inttoptr i64 %a160 to ptr
  %r165 = call i32 (ptr, ...) @printf(ptr %p164, i64 %v163)
  %v166 = sext i32 %r165 to i64
  %a167 = ptrtoint ptr %s.1 to i64
  %p168 = inttoptr i64 %a167 to ptr
  %v169 = load i64, ptr %p168
  %r170 = call i64 @upper(i64 %v169)
  %a171 = ptrtoint ptr @.str.12 to i64
  %a172 = ptrtoint ptr %s.1 to i64
  %p173 = inttoptr i64 %a172 to ptr
  %v174 = load i64, ptr %p173
  %p175 = inttoptr i64 %a171 to ptr
  %r176 = call i32 (ptr, ...) @printf(ptr %p175, i64 %v174)
  %v177 = sext i32 %r176 to i64
  %a178 = ptrtoint ptr %s.1 to i64
  %p179 = inttoptr i64 %a178 to ptr
  %v180 = load i64, ptr %p179
  %p181 = inttoptr i64 %v180 to ptr
  call void @free(ptr %p181)
  %rv182 = trunc i64 0 to i32
  ret i32 %rv182
}

