; 全域陣列、struct、GEP、switch、select、各寬度整數、>8 個參數
%struct.P = type { i8, i32, i64 }
@arr = global [5 x i32] [i32 10, i32 20, i32 30, i32 40, i32 50], align 4
@p = global %struct.P { i8 7, i32 8, i64 9 }, align 8
@cnt = internal global i32 0, align 4
@fmt = private constant [28 x i8] c"%d %d %d %d %d %d %d %d %d\0A\00", align 1
@f2 = private constant [10 x i8] c"%d %d %d\0A\00", align 1
@f3 = private constant [14 x i8] c"%lu %d %d %d\0A\00", align 1

define i32 @sumarr(ptr %a, i32 %n) {
entry:
  %s = alloca i32
  %i = alloca i32
  store i32 0, ptr %s
  store i32 0, ptr %i
  br label %c
c:
  %iv = load i32, ptr %i
  %cmp = icmp slt i32 %iv, %n
  br i1 %cmp, label %b, label %e
b:
  %idx = sext i32 %iv to i64
  %ep = getelementptr inbounds i32, ptr %a, i64 %idx
  %v = load i32, ptr %ep
  %sv = load i32, ptr %s
  %ns = add i32 %sv, %v
  store i32 %ns, ptr %s
  %ni = add i32 %iv, 1
  store i32 %ni, ptr %i
  br label %c
e:
  %r = load i32, ptr %s
  ret i32 %r
}

define i32 @many(i32 %a, i32 %b, i32 %c, i32 %d, i32 %e, i32 %f, i32 %g, i32 %h, i32 %i) {
  %1 = add i32 %a, %i
  %2 = mul i32 %1, %h
  ret i32 %2
}

define i32 @sw(i32 %x) {
entry:
  switch i32 %x, label %def [
    i32 1, label %one
    i32 2, label %two
  ]
one:
  br label %end
two:
  br label %end
def:
  br label %end
end:
  %r = phi i32 [ 100, %one ], [ 200, %two ], [ -1, %def ]
  ret i32 %r
}

define i32 @misc(i32 %x) {
  %t = trunc i32 %x to i8
  %z = zext i8 %t to i32
  %s = sext i8 %t to i32
  %c = icmp ult i8 %t, 100
  %sel = select i1 %c, i32 %z, i32 %s
  %u = udiv i32 -1, 3
  %q = lshr i32 %u, 4
  %bb = icmp ne i32 %q, 0
  %bz = zext i1 %bb to i32
  %o = add i32 %sel, %bz
  ret i32 %o
}

declare i32 @printf(ptr, ...)

define i32 @main() {
  %a = call i32 @sumarr(ptr @arr, i32 5)
  %e3 = getelementptr inbounds [5 x i32], ptr @arr, i64 0, i64 3
  %v3 = load i32, ptr %e3
  %m = call i32 @many(i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9)
  %s1 = call i32 @sw(i32 1)
  %s2 = call i32 @sw(i32 2)
  %s3 = call i32 @sw(i32 3)
  %m1 = call i32 @misc(i32 300)
  %m2 = call i32 @misc(i32 -2)
  %call = call i32 (ptr, ...) @printf(ptr @fmt, i32 %a, i32 %v3, i32 %m, i32 %s1, i32 %s2, i32 %s3, i32 %m1, i32 %m2, i32 5)
  %f1 = getelementptr inbounds %struct.P, ptr @p, i32 0, i32 1
  %fv = load i32, ptr %f1
  %f2 = getelementptr inbounds %struct.P, ptr @p, i32 0, i32 2
  %fv2 = load i64, ptr %f2
  %f0 = getelementptr inbounds %struct.P, ptr @p, i32 0, i32 0
  %fv0 = load i8, ptr %f0
  %fv0e = sext i8 %fv0 to i32
  %cn = load i32, ptr @cnt
  %cn1 = add i32 %cn, 41
  store i32 %cn1, ptr @cnt
  %r = call i32 (ptr, ...) @printf(ptr @f3, i64 %fv2, i32 %fv, i32 %fv0e, i32 %cn1)
  ret i32 0
}
