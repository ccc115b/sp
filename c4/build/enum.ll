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

@.str.1 = private unnamed_addr constant [33 x i8] c"RED=%d GREEN=%d BLUE=%d GOLD=%d\0a\00"
@.str.2 = private unnamed_addr constant [20 x i8] c"isBLUE=%d isRED=%d\0a\00"

define i32 @main(i32 %.argc, ptr %.argv) {
entry:
  %s.0 = alloca i64
  %a1 = ptrtoint ptr @.str.1 to i64
  %p2 = inttoptr i64 %a1 to ptr
  %r3 = call i32 (ptr, ...) @printf(ptr %p2, i64 0, i64 1, i64 10, i64 11)
  %v4 = sext i32 %r3 to i64
  %a5 = ptrtoint ptr %s.0 to i64
  %p6 = inttoptr i64 %a5 to ptr
  %v7 = load i64, ptr %p6
  %p8 = inttoptr i64 %a5 to ptr
  store i64 10, ptr %p8
  %a9 = ptrtoint ptr @.str.2 to i64
  %a10 = ptrtoint ptr %s.0 to i64
  %p11 = inttoptr i64 %a10 to ptr
  %v12 = load i64, ptr %p11
  %c13 = icmp eq i64 %v12, 10
  %b14 = zext i1 %c13 to i64
  %a15 = ptrtoint ptr %s.0 to i64
  %p16 = inttoptr i64 %a15 to ptr
  %v17 = load i64, ptr %p16
  %c18 = icmp eq i64 %v17, 0
  %b19 = zext i1 %c18 to i64
  %p20 = inttoptr i64 %a9 to ptr
  %r21 = call i32 (ptr, ...) @printf(ptr %p20, i64 %b14, i64 %b19)
  %v22 = sext i32 %r21 to i64
  %rv23 = trunc i64 0 to i32
  ret i32 %rv23
}

