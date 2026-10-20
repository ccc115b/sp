; ModuleID = 'demo'
target triple = "x86_64-pc-linux-gnu"

; 綜合示範：常數摺疊、強度削減、CSE、Store→Load 轉送、分支摺疊、區塊合併、DCE
define i32 @compute(i32 %n) {
entry:
  %n.addr = alloca i32, align 4
  %unused = alloca i32, align 4
  store i32 %n, ptr %n.addr, align 4
  store i32 7, ptr %unused, align 4
  %0 = load i32, ptr %n.addr, align 4
  %mul = mul nsw i32 %0, 8
  %k = add nsw i32 2, 3
  %1 = load i32, ptr %n.addr, align 4
  %mul2 = mul nsw i32 8, %1
  %sum = add nsw i32 %mul, %mul2
  %same = sub i32 %sum, %sum
  %cmp = icmp eq i32 1, 1
  br i1 %cmp, label %then, label %else

then:
  %x = add i32 %sum, 0
  %q = udiv i32 %x, 4
  br label %end

else:
  %dead = sdiv i32 %n, 3
  br label %end

end:
  %r = phi i32 [ %q, %then ], [ 99, %else ]
  %s = add i32 %r, %k
  %t = add i32 %s, %same
  ret i32 %t
}

; 迴圈：1 + 2 + ... + n（含恆為 0 的運算與重複計算）
define i32 @sumloop(i32 %n) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
  %acc = phi i32 [ 0, %entry ], [ %acc.next, %loop ]
  %i.next = add i32 %i, 1
  %a = mul i32 %i.next, 2
  %b = mul i32 2, %i.next
  %half = udiv i32 %a, 2
  %c = xor i32 %b, %b
  %acc.t = add i32 %acc, %half
  %acc.next = add i32 %acc.t, %c
  %done = icmp uge i32 %i.next, %n
  br i1 %done, label %exit, label %loop

exit:
  ret i32 %acc.next
}
