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

@.str.1 = private unnamed_addr constant [23 x i8] c"fib(10)=%d fib(20)=%d\0a\00"
@.str.2 = private unnamed_addr constant [32 x i8] c"gcd(1071,462)=%d gcd(48,18)=%d\0a\00"
@.str.3 = private unnamed_addr constant [26 x i8] c"pow(2,10)=%d pow(3,0)=%d\0a\00"

define i64 @fib(i64 %a.0) {
entry:
  %s.0 = alloca i64
  store i64 %a.0, ptr %s.0
  %a1 = ptrtoint ptr %s.0 to i64
  %p2 = inttoptr i64 %a1 to ptr
  %v3 = load i64, ptr %p2
  %c4 = icmp slt i64 %v3, 2
  %b5 = zext i1 %c4 to i64
  %c6 = icmp ne i64 %b5, 0
  br i1 %c6, label %if.then.1, label %if.else.2
if.then.1:
  %a7 = ptrtoint ptr %s.0 to i64
  %p8 = inttoptr i64 %a7 to ptr
  %v9 = load i64, ptr %p8
  ret i64 %v9
if.else.2:
  br label %if.end.3
if.end.3:
  %a10 = ptrtoint ptr %s.0 to i64
  %p11 = inttoptr i64 %a10 to ptr
  %v12 = load i64, ptr %p11
  %t13 = sub i64 %v12, 1
  %r14 = call i64 @fib(i64 %t13)
  %a15 = ptrtoint ptr %s.0 to i64
  %p16 = inttoptr i64 %a15 to ptr
  %v17 = load i64, ptr %p16
  %t18 = sub i64 %v17, 2
  %r19 = call i64 @fib(i64 %t18)
  %t20 = add i64 %r14, %r19
  ret i64 %t20
}

define i64 @gcd(i64 %a.0, i64 %a.1) {
entry:
  %s.0 = alloca i64
  store i64 %a.0, ptr %s.0
  %s.1 = alloca i64
  store i64 %a.1, ptr %s.1
  %a1 = ptrtoint ptr %s.1 to i64
  %p2 = inttoptr i64 %a1 to ptr
  %v3 = load i64, ptr %p2
  %c4 = icmp eq i64 %v3, 0
  %b5 = zext i1 %c4 to i64
  %c6 = icmp ne i64 %b5, 0
  br i1 %c6, label %if.then.1, label %if.else.2
if.then.1:
  %a7 = ptrtoint ptr %s.0 to i64
  %p8 = inttoptr i64 %a7 to ptr
  %v9 = load i64, ptr %p8
  ret i64 %v9
if.else.2:
  br label %if.end.3
if.end.3:
  %a10 = ptrtoint ptr %s.1 to i64
  %p11 = inttoptr i64 %a10 to ptr
  %v12 = load i64, ptr %p11
  %a13 = ptrtoint ptr %s.0 to i64
  %p14 = inttoptr i64 %a13 to ptr
  %v15 = load i64, ptr %p14
  %a16 = ptrtoint ptr %s.1 to i64
  %p17 = inttoptr i64 %a16 to ptr
  %v18 = load i64, ptr %p17
  %t19 = srem i64 %v15, %v18
  %r20 = call i64 @gcd(i64 %v12, i64 %t19)
  ret i64 %r20
}

define i64 @ipow(i64 %a.0, i64 %a.1) {
entry:
  %s.0 = alloca i64
  store i64 %a.0, ptr %s.0
  %s.1 = alloca i64
  store i64 %a.1, ptr %s.1
  %s.2 = alloca i64
  %a1 = ptrtoint ptr %s.2 to i64
  %p2 = inttoptr i64 %a1 to ptr
  %v3 = load i64, ptr %p2
  %p4 = inttoptr i64 %a1 to ptr
  store i64 1, ptr %p4
  br label %wh.cond.1
wh.cond.1:
  %a5 = ptrtoint ptr %s.1 to i64
  %p6 = inttoptr i64 %a5 to ptr
  %v7 = load i64, ptr %p6
  %c8 = icmp sgt i64 %v7, 0
  %b9 = zext i1 %c8 to i64
  %c10 = icmp ne i64 %b9, 0
  br i1 %c10, label %wh.body.2, label %wh.end.3
wh.body.2:
  %a11 = ptrtoint ptr %s.1 to i64
  %p12 = inttoptr i64 %a11 to ptr
  %v13 = load i64, ptr %p12
  %t14 = srem i64 %v13, 2
  %c15 = icmp ne i64 %t14, 0
  br i1 %c15, label %if.then.4, label %if.else.5
if.then.4:
  %a16 = ptrtoint ptr %s.2 to i64
  %p17 = inttoptr i64 %a16 to ptr
  %v18 = load i64, ptr %p17
  %a19 = ptrtoint ptr %s.2 to i64
  %p20 = inttoptr i64 %a19 to ptr
  %v21 = load i64, ptr %p20
  %a22 = ptrtoint ptr %s.0 to i64
  %p23 = inttoptr i64 %a22 to ptr
  %v24 = load i64, ptr %p23
  %t25 = mul i64 %v21, %v24
  %p26 = inttoptr i64 %a16 to ptr
  store i64 %t25, ptr %p26
  br label %if.end.6
if.else.5:
  br label %if.end.6
if.end.6:
  %a27 = ptrtoint ptr %s.0 to i64
  %p28 = inttoptr i64 %a27 to ptr
  %v29 = load i64, ptr %p28
  %a30 = ptrtoint ptr %s.0 to i64
  %p31 = inttoptr i64 %a30 to ptr
  %v32 = load i64, ptr %p31
  %a33 = ptrtoint ptr %s.0 to i64
  %p34 = inttoptr i64 %a33 to ptr
  %v35 = load i64, ptr %p34
  %t36 = mul i64 %v32, %v35
  %p37 = inttoptr i64 %a27 to ptr
  store i64 %t36, ptr %p37
  %a38 = ptrtoint ptr %s.1 to i64
  %p39 = inttoptr i64 %a38 to ptr
  %v40 = load i64, ptr %p39
  %a41 = ptrtoint ptr %s.1 to i64
  %p42 = inttoptr i64 %a41 to ptr
  %v43 = load i64, ptr %p42
  %t44 = sdiv i64 %v43, 2
  %p45 = inttoptr i64 %a38 to ptr
  store i64 %t44, ptr %p45
  br label %wh.cond.1
wh.end.3:
  %a46 = ptrtoint ptr %s.2 to i64
  %p47 = inttoptr i64 %a46 to ptr
  %v48 = load i64, ptr %p47
  ret i64 %v48
}

define i32 @main(i32 %.argc, ptr %.argv) {
entry:
  %a1 = ptrtoint ptr @.str.1 to i64
  %r2 = call i64 @fib(i64 10)
  %r3 = call i64 @fib(i64 20)
  %p4 = inttoptr i64 %a1 to ptr
  %r5 = call i32 (ptr, ...) @printf(ptr %p4, i64 %r2, i64 %r3)
  %v6 = sext i32 %r5 to i64
  %a7 = ptrtoint ptr @.str.2 to i64
  %r8 = call i64 @gcd(i64 1071, i64 462)
  %r9 = call i64 @gcd(i64 48, i64 18)
  %p10 = inttoptr i64 %a7 to ptr
  %r11 = call i32 (ptr, ...) @printf(ptr %p10, i64 %r8, i64 %r9)
  %v12 = sext i32 %r11 to i64
  %a13 = ptrtoint ptr @.str.3 to i64
  %r14 = call i64 @ipow(i64 2, i64 10)
  %r15 = call i64 @ipow(i64 3, i64 0)
  %p16 = inttoptr i64 %a13 to ptr
  %r17 = call i32 (ptr, ...) @printf(ptr %p16, i64 %r14, i64 %r15)
  %v18 = sext i32 %r17 to i64
  %rv19 = trunc i64 0 to i32
  ret i32 %rv19
}

