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

@.str.1 = private unnamed_addr constant [10 x i8] c"FizzBuzz\0a\00"
@.str.2 = private unnamed_addr constant [6 x i8] c"Fizz\0a\00"
@.str.3 = private unnamed_addr constant [6 x i8] c"Buzz\0a\00"
@.str.4 = private unnamed_addr constant [4 x i8] c"%d\0a\00"

define i32 @main(i32 %.argc, ptr %.argv) {
entry:
  %s.0 = alloca i64
  %a1 = ptrtoint ptr %s.0 to i64
  %p2 = inttoptr i64 %a1 to ptr
  %v3 = load i64, ptr %p2
  %p4 = inttoptr i64 %a1 to ptr
  store i64 1, ptr %p4
  br label %wh.cond.1
wh.cond.1:
  %a5 = ptrtoint ptr %s.0 to i64
  %p6 = inttoptr i64 %a5 to ptr
  %v7 = load i64, ptr %p6
  %c8 = icmp sle i64 %v7, 20
  %b9 = zext i1 %c8 to i64
  %c10 = icmp ne i64 %b9, 0
  br i1 %c10, label %wh.body.2, label %wh.end.3
wh.body.2:
  %a11 = ptrtoint ptr %s.0 to i64
  %p12 = inttoptr i64 %a11 to ptr
  %v13 = load i64, ptr %p12
  %t14 = srem i64 %v13, 15
  %c15 = icmp eq i64 %t14, 0
  %b16 = zext i1 %c15 to i64
  %c17 = icmp ne i64 %b16, 0
  br i1 %c17, label %if.then.4, label %if.else.5
if.then.4:
  %a18 = ptrtoint ptr @.str.1 to i64
  %p19 = inttoptr i64 %a18 to ptr
  %r20 = call i32 (ptr, ...) @printf(ptr %p19)
  %v21 = sext i32 %r20 to i64
  br label %if.end.6
if.else.5:
  %a22 = ptrtoint ptr %s.0 to i64
  %p23 = inttoptr i64 %a22 to ptr
  %v24 = load i64, ptr %p23
  %t25 = srem i64 %v24, 3
  %c26 = icmp eq i64 %t25, 0
  %b27 = zext i1 %c26 to i64
  %c28 = icmp ne i64 %b27, 0
  br i1 %c28, label %if.then.7, label %if.else.8
if.then.7:
  %a29 = ptrtoint ptr @.str.2 to i64
  %p30 = inttoptr i64 %a29 to ptr
  %r31 = call i32 (ptr, ...) @printf(ptr %p30)
  %v32 = sext i32 %r31 to i64
  br label %if.end.9
if.else.8:
  %a33 = ptrtoint ptr %s.0 to i64
  %p34 = inttoptr i64 %a33 to ptr
  %v35 = load i64, ptr %p34
  %t36 = srem i64 %v35, 5
  %c37 = icmp eq i64 %t36, 0
  %b38 = zext i1 %c37 to i64
  %c39 = icmp ne i64 %b38, 0
  br i1 %c39, label %if.then.10, label %if.else.11
if.then.10:
  %a40 = ptrtoint ptr @.str.3 to i64
  %p41 = inttoptr i64 %a40 to ptr
  %r42 = call i32 (ptr, ...) @printf(ptr %p41)
  %v43 = sext i32 %r42 to i64
  br label %if.end.12
if.else.11:
  %a44 = ptrtoint ptr @.str.4 to i64
  %a45 = ptrtoint ptr %s.0 to i64
  %p46 = inttoptr i64 %a45 to ptr
  %v47 = load i64, ptr %p46
  %p48 = inttoptr i64 %a44 to ptr
  %r49 = call i32 (ptr, ...) @printf(ptr %p48, i64 %v47)
  %v50 = sext i32 %r49 to i64
  br label %if.end.12
if.end.12:
  br label %if.end.9
if.end.9:
  br label %if.end.6
if.end.6:
  %a51 = ptrtoint ptr %s.0 to i64
  %p52 = inttoptr i64 %a51 to ptr
  %v53 = load i64, ptr %p52
  %a54 = ptrtoint ptr %s.0 to i64
  %p55 = inttoptr i64 %a54 to ptr
  %v56 = load i64, ptr %p55
  %t57 = add i64 %v56, 1
  %p58 = inttoptr i64 %a51 to ptr
  store i64 %t57, ptr %p58
  br label %wh.cond.1
wh.end.3:
  %rv59 = trunc i64 0 to i32
  ret i32 %rv59
}

