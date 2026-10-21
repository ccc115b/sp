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

@.str.1 = private unnamed_addr constant [15 x i8] c"hello, world!\0a\00"
@.str.2 = private unnamed_addr constant [9 x i8] c"%d = %d\0a\00"

define i32 @main(i32 %.argc, ptr %.argv) {
entry:
  %a1 = ptrtoint ptr @.str.1 to i64
  %p2 = inttoptr i64 %a1 to ptr
  %r3 = call i32 (ptr, ...) @printf(ptr %p2)
  %v4 = sext i32 %r3 to i64
  %a5 = ptrtoint ptr @.str.2 to i64
  %p6 = inttoptr i64 %a5 to ptr
  %r7 = call i32 (ptr, ...) @printf(ptr %p6, i64 42, i64 42)
  %v8 = sext i32 %r7 to i64
  %rv9 = trunc i64 0 to i32
  ret i32 %rv9
}

