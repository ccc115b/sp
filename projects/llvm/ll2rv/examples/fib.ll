; 遞迴 fib + 迴圈 phi + printf
@.str = private unnamed_addr constant [12 x i8] c"fib(%d)=%d\0A\00", align 1
@.str2 = private unnamed_addr constant [11 x i8] c"sum=%d %d\0A\00", align 1

define dso_local i32 @fib(i32 noundef %0) {
  %2 = icmp slt i32 %0, 2
  br i1 %2, label %3, label %4
3:
  ret i32 %0
4:
  %5 = sub nsw i32 %0, 1
  %6 = call i32 @fib(i32 noundef %5)
  %7 = sub nsw i32 %0, 2
  %8 = call i32 @fib(i32 noundef %7)
  %9 = add nsw i32 %6, %8
  ret i32 %9
}

; 含 phi 的迴圈，並同時測 swap：a,b = b,a
define i32 @loop(i32 %n) {
entry:
  br label %cond
cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %body ]
  %s = phi i32 [ 0, %entry ], [ %s.next, %body ]
  %c = icmp slt i32 %i, %n
  br i1 %c, label %body, label %exit
body:
  %s.next = add i32 %s, %i
  %i.next = add i32 %i, 1
  br label %cond
exit:
  ret i32 %s
}

define i32 @swap(i32 %x, i32 %y) {
entry:
  br label %l
l:
  %a = phi i32 [ %x, %entry ], [ %b, %l ]
  %b = phi i32 [ %y, %entry ], [ %a, %l ]
  %k = phi i32 [ 0, %entry ], [ %k1, %l ]
  %k1 = add i32 %k, 1
  %d = icmp slt i32 %k1, 3
  br i1 %d, label %l, label %out
out:
  %r = mul i32 %a, 10
  %r2 = add i32 %r, %b
  ret i32 %r2
}

declare i32 @printf(ptr noundef, ...)

define dso_local i32 @main() {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  %2 = call i32 @fib(i32 noundef 10)
  %3 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef 10, i32 noundef %2)
  %4 = call i32 @loop(i32 100)
  %5 = call i32 @swap(i32 1, i32 2)
  %6 = call i32 (ptr, ...) @printf(ptr noundef @.str2, i32 noundef %4, i32 noundef %5)
  ret i32 0
}
