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

@.str.1 = private unnamed_addr constant [2 x i8] c" \00"
@.str.2 = private unnamed_addr constant [3 x i8] c"%d\00"
@.str.3 = private unnamed_addr constant [11 x i8] c"\0acount=%d\0a\00"

define i32 @main(i32 %.argc, ptr %.argv) {
entry:
  %s.0 = alloca i64
  %s.1 = alloca i64
  %s.2 = alloca i64
  %s.3 = alloca i64
  %s.4 = alloca i64
  %a1 = ptrtoint ptr %s.1 to i64
  %p2 = inttoptr i64 %a1 to ptr
  %v3 = load i64, ptr %p2
  %p4 = inttoptr i64 %a1 to ptr
  store i64 50, ptr %p4
  %a5 = ptrtoint ptr %s.0 to i64
  %p6 = inttoptr i64 %a5 to ptr
  %v7 = load i64, ptr %p6
  %a8 = ptrtoint ptr %s.1 to i64
  %p9 = inttoptr i64 %a8 to ptr
  %v10 = load i64, ptr %p9
  %r11 = call ptr @malloc(i64 %v10)
  %a12 = ptrtoint ptr %r11 to i64
  %p13 = inttoptr i64 %a5 to ptr
  store i64 %a12, ptr %p13
  %a14 = ptrtoint ptr %s.0 to i64
  %p15 = inttoptr i64 %a14 to ptr
  %v16 = load i64, ptr %p15
  %a17 = ptrtoint ptr %s.1 to i64
  %p18 = inttoptr i64 %a17 to ptr
  %v19 = load i64, ptr %p18
  %p20 = inttoptr i64 %v16 to ptr
  %w21 = trunc i64 1 to i32
  %r22 = call ptr @memset(ptr %p20, i32 %w21, i64 %v19)
  %a23 = ptrtoint ptr %r22 to i64
  %a24 = ptrtoint ptr %s.2 to i64
  %p25 = inttoptr i64 %a24 to ptr
  %v26 = load i64, ptr %p25
  %p27 = inttoptr i64 %a24 to ptr
  store i64 2, ptr %p27
  br label %wh.cond.1
wh.cond.1:
  %a28 = ptrtoint ptr %s.2 to i64
  %p29 = inttoptr i64 %a28 to ptr
  %v30 = load i64, ptr %p29
  %a31 = ptrtoint ptr %s.1 to i64
  %p32 = inttoptr i64 %a31 to ptr
  %v33 = load i64, ptr %p32
  %c34 = icmp slt i64 %v30, %v33
  %b35 = zext i1 %c34 to i64
  %c36 = icmp ne i64 %b35, 0
  br i1 %c36, label %wh.body.2, label %wh.end.3
wh.body.2:
  %a37 = ptrtoint ptr %s.0 to i64
  %p38 = inttoptr i64 %a37 to ptr
  %v39 = load i64, ptr %p38
  %a40 = ptrtoint ptr %s.2 to i64
  %p41 = inttoptr i64 %a40 to ptr
  %v42 = load i64, ptr %p41
  %t43 = add i64 %v39, %v42
  %p44 = inttoptr i64 %t43 to ptr
  %b45 = load i8, ptr %p44
  %c46 = sext i8 %b45 to i64
  %c47 = icmp ne i64 %c46, 0
  br i1 %c47, label %if.then.4, label %if.else.5
if.then.4:
  %a48 = ptrtoint ptr %s.3 to i64
  %p49 = inttoptr i64 %a48 to ptr
  %v50 = load i64, ptr %p49
  %a51 = ptrtoint ptr %s.2 to i64
  %p52 = inttoptr i64 %a51 to ptr
  %v53 = load i64, ptr %p52
  %a54 = ptrtoint ptr %s.2 to i64
  %p55 = inttoptr i64 %a54 to ptr
  %v56 = load i64, ptr %p55
  %t57 = add i64 %v53, %v56
  %p58 = inttoptr i64 %a48 to ptr
  store i64 %t57, ptr %p58
  br label %wh.cond.7
wh.cond.7:
  %a59 = ptrtoint ptr %s.3 to i64
  %p60 = inttoptr i64 %a59 to ptr
  %v61 = load i64, ptr %p60
  %a62 = ptrtoint ptr %s.1 to i64
  %p63 = inttoptr i64 %a62 to ptr
  %v64 = load i64, ptr %p63
  %c65 = icmp slt i64 %v61, %v64
  %b66 = zext i1 %c65 to i64
  %c67 = icmp ne i64 %b66, 0
  br i1 %c67, label %wh.body.8, label %wh.end.9
wh.body.8:
  %a68 = ptrtoint ptr %s.0 to i64
  %p69 = inttoptr i64 %a68 to ptr
  %v70 = load i64, ptr %p69
  %a71 = ptrtoint ptr %s.3 to i64
  %p72 = inttoptr i64 %a71 to ptr
  %v73 = load i64, ptr %p72
  %t74 = add i64 %v70, %v73
  %p75 = inttoptr i64 %t74 to ptr
  %b76 = load i8, ptr %p75
  %c77 = sext i8 %b76 to i64
  %p78 = inttoptr i64 %t74 to ptr
  %b79 = trunc i64 0 to i8
  store i8 %b79, ptr %p78
  %a80 = ptrtoint ptr %s.3 to i64
  %p81 = inttoptr i64 %a80 to ptr
  %v82 = load i64, ptr %p81
  %a83 = ptrtoint ptr %s.3 to i64
  %p84 = inttoptr i64 %a83 to ptr
  %v85 = load i64, ptr %p84
  %a86 = ptrtoint ptr %s.2 to i64
  %p87 = inttoptr i64 %a86 to ptr
  %v88 = load i64, ptr %p87
  %t89 = add i64 %v85, %v88
  %p90 = inttoptr i64 %a80 to ptr
  store i64 %t89, ptr %p90
  br label %wh.cond.7
wh.end.9:
  br label %if.end.6
if.else.5:
  br label %if.end.6
if.end.6:
  %a91 = ptrtoint ptr %s.2 to i64
  %p92 = inttoptr i64 %a91 to ptr
  %v93 = load i64, ptr %p92
  %a94 = ptrtoint ptr %s.2 to i64
  %p95 = inttoptr i64 %a94 to ptr
  %v96 = load i64, ptr %p95
  %t97 = add i64 %v96, 1
  %p98 = inttoptr i64 %a91 to ptr
  store i64 %t97, ptr %p98
  br label %wh.cond.1
wh.end.3:
  %a99 = ptrtoint ptr %s.4 to i64
  %p100 = inttoptr i64 %a99 to ptr
  %v101 = load i64, ptr %p100
  %p102 = inttoptr i64 %a99 to ptr
  store i64 0, ptr %p102
  %a103 = ptrtoint ptr %s.2 to i64
  %p104 = inttoptr i64 %a103 to ptr
  %v105 = load i64, ptr %p104
  %p106 = inttoptr i64 %a103 to ptr
  store i64 2, ptr %p106
  br label %wh.cond.10
wh.cond.10:
  %a107 = ptrtoint ptr %s.2 to i64
  %p108 = inttoptr i64 %a107 to ptr
  %v109 = load i64, ptr %p108
  %a110 = ptrtoint ptr %s.1 to i64
  %p111 = inttoptr i64 %a110 to ptr
  %v112 = load i64, ptr %p111
  %c113 = icmp slt i64 %v109, %v112
  %b114 = zext i1 %c113 to i64
  %c115 = icmp ne i64 %b114, 0
  br i1 %c115, label %wh.body.11, label %wh.end.12
wh.body.11:
  %a116 = ptrtoint ptr %s.0 to i64
  %p117 = inttoptr i64 %a116 to ptr
  %v118 = load i64, ptr %p117
  %a119 = ptrtoint ptr %s.2 to i64
  %p120 = inttoptr i64 %a119 to ptr
  %v121 = load i64, ptr %p120
  %t122 = add i64 %v118, %v121
  %p123 = inttoptr i64 %t122 to ptr
  %b124 = load i8, ptr %p123
  %c125 = sext i8 %b124 to i64
  %c126 = icmp ne i64 %c125, 0
  br i1 %c126, label %if.then.13, label %if.else.14
if.then.13:
  %a127 = ptrtoint ptr %s.4 to i64
  %p128 = inttoptr i64 %a127 to ptr
  %v129 = load i64, ptr %p128
  %c130 = icmp ne i64 %v129, 0
  br i1 %c130, label %if.then.16, label %if.else.17
if.then.16:
  %a131 = ptrtoint ptr @.str.1 to i64
  %p132 = inttoptr i64 %a131 to ptr
  %r133 = call i32 (ptr, ...) @printf(ptr %p132)
  %v134 = sext i32 %r133 to i64
  br label %if.end.18
if.else.17:
  br label %if.end.18
if.end.18:
  %a135 = ptrtoint ptr @.str.2 to i64
  %a136 = ptrtoint ptr %s.2 to i64
  %p137 = inttoptr i64 %a136 to ptr
  %v138 = load i64, ptr %p137
  %p139 = inttoptr i64 %a135 to ptr
  %r140 = call i32 (ptr, ...) @printf(ptr %p139, i64 %v138)
  %v141 = sext i32 %r140 to i64
  %a142 = ptrtoint ptr %s.4 to i64
  %p143 = inttoptr i64 %a142 to ptr
  %v144 = load i64, ptr %p143
  %a145 = ptrtoint ptr %s.4 to i64
  %p146 = inttoptr i64 %a145 to ptr
  %v147 = load i64, ptr %p146
  %t148 = add i64 %v147, 1
  %p149 = inttoptr i64 %a142 to ptr
  store i64 %t148, ptr %p149
  br label %if.end.15
if.else.14:
  br label %if.end.15
if.end.15:
  %a150 = ptrtoint ptr %s.2 to i64
  %p151 = inttoptr i64 %a150 to ptr
  %v152 = load i64, ptr %p151
  %a153 = ptrtoint ptr %s.2 to i64
  %p154 = inttoptr i64 %a153 to ptr
  %v155 = load i64, ptr %p154
  %t156 = add i64 %v155, 1
  %p157 = inttoptr i64 %a150 to ptr
  store i64 %t156, ptr %p157
  br label %wh.cond.10
wh.end.12:
  %a158 = ptrtoint ptr @.str.3 to i64
  %a159 = ptrtoint ptr %s.4 to i64
  %p160 = inttoptr i64 %a159 to ptr
  %v161 = load i64, ptr %p160
  %p162 = inttoptr i64 %a158 to ptr
  %r163 = call i32 (ptr, ...) @printf(ptr %p162, i64 %v161)
  %v164 = sext i32 %r163 to i64
  %a165 = ptrtoint ptr %s.0 to i64
  %p166 = inttoptr i64 %a165 to ptr
  %v167 = load i64, ptr %p166
  %p168 = inttoptr i64 %v167 to ptr
  call void @free(ptr %p168)
  %rv169 = trunc i64 0 to i32
  ret i32 %rv169
}

