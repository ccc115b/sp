; ──── llopt 優化摘要 ────
;   Store→Load 轉送 (Store-to-Load Forwarding): 2 次
;   不可達區塊移除 (Unreachable Block Elimination): 1 次
;   代數化簡 (Algebraic Simplification): 5 次
;   共同子運算式消除 (CSE): 1 次
;   分支摺疊 (Branch Folding): 1 次
;   基本區塊合併 (Block Merging): 2 次
;   常數摺疊 (Constant Folding): 2 次
;   強度削減 (Strength Reduction): 5 次
;   死 alloca/store 消除 (Dead Alloca Elimination): 4 次
;   死碼消除 (Dead Code Elimination): 1 次
;   運算元正規化 (Canonicalization): 2 次
; ModuleID = 'demo'
target triple = "x86_64-pc-linux-gnu"

; 綜合示範：常數摺疊、強度削減、CSE、Store→Load 轉送、分支摺疊、區塊合併、DCE
define i32 @compute(i32 %n) {
entry:
  %mul = shl i32 %n, 3
  %sum = add nsw i32 %mul, %mul
  %q = lshr i32 %sum, 2
  %s = add i32 %q, 5
  ret i32 %s
}

; 迴圈：1 + 2 + ... + n（含恆為 0 的運算與重複計算）
define i32 @sumloop(i32 %n) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
  %acc = phi i32 [ 0, %entry ], [ %acc.t, %loop ]
  %i.next = add i32 %i, 1
  %a = shl i32 %i.next, 1
  %half = lshr i32 %a, 1
  %acc.t = add i32 %acc, %half
  %done = icmp uge i32 %i.next, %n
  br i1 %done, label %exit, label %loop

exit:
  ret i32 %acc.t
}
