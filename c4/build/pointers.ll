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

@g_g = global i64 0
@g_gc = global i8 0
@.str.1 = private unnamed_addr constant [30 x i8] c"sizeof int=%d char=%d ptr=%d\0a\00"
@.str.2 = private unnamed_addr constant [23 x i8] c"*p=%d p[1]=%d p[2]=%d\0a\00"
@.str.3 = private unnamed_addr constant [14 x i8] c"q-p=%d *q=%d\0a\00"
@.str.4 = private unnamed_addr constant [22 x i8] c"*c=%c c[1]=%c chr=%c\0a\00"
@.str.5 = private unnamed_addr constant [8 x i8] c"d-c=%d\0a\00"
@.str.6 = private unnamed_addr constant [12 x i8] c"g=%d gc=%c\0a\00"

define i32 @main(i32 %.argc, ptr %.argv) {
entry:
  %s.0 = alloca i64
  %s.1 = alloca i64
  %s.2 = alloca i64
  %s.3 = alloca i64
  %a1 = ptrtoint ptr @.str.1 to i64
  %p2 = inttoptr i64 %a1 to ptr
  %r3 = call i32 (ptr, ...) @printf(ptr %p2, i64 8, i64 1, i64 8)
  %v4 = sext i32 %r3 to i64
  %a5 = ptrtoint ptr %s.0 to i64
  %p6 = inttoptr i64 %a5 to ptr
  %v7 = load i64, ptr %p6
  %t8 = mul i64 3, 8
  %r9 = call ptr @malloc(i64 %t8)
  %a10 = ptrtoint ptr %r9 to i64
  %p11 = inttoptr i64 %a5 to ptr
  store i64 %a10, ptr %p11
  %a12 = ptrtoint ptr %s.0 to i64
  %p13 = inttoptr i64 %a12 to ptr
  %v14 = load i64, ptr %p13
  %p15 = inttoptr i64 %v14 to ptr
  %v16 = load i64, ptr %p15
  %p17 = inttoptr i64 %v14 to ptr
  store i64 10, ptr %p17
  %a18 = ptrtoint ptr %s.0 to i64
  %p19 = inttoptr i64 %a18 to ptr
  %v20 = load i64, ptr %p19
  %t21 = mul i64 1, 8
  %t22 = add i64 %v20, %t21
  %p23 = inttoptr i64 %t22 to ptr
  %v24 = load i64, ptr %p23
  %p25 = inttoptr i64 %t22 to ptr
  store i64 20, ptr %p25
  %a26 = ptrtoint ptr %s.0 to i64
  %p27 = inttoptr i64 %a26 to ptr
  %v28 = load i64, ptr %p27
  %t29 = mul i64 2, 8
  %t30 = add i64 %v28, %t29
  %p31 = inttoptr i64 %t30 to ptr
  %v32 = load i64, ptr %p31
  %p33 = inttoptr i64 %t30 to ptr
  store i64 30, ptr %p33
  %a34 = ptrtoint ptr @.str.2 to i64
  %a35 = ptrtoint ptr %s.0 to i64
  %p36 = inttoptr i64 %a35 to ptr
  %v37 = load i64, ptr %p36
  %p38 = inttoptr i64 %v37 to ptr
  %v39 = load i64, ptr %p38
  %a40 = ptrtoint ptr %s.0 to i64
  %p41 = inttoptr i64 %a40 to ptr
  %v42 = load i64, ptr %p41
  %t43 = mul i64 1, 8
  %t44 = add i64 %v42, %t43
  %p45 = inttoptr i64 %t44 to ptr
  %v46 = load i64, ptr %p45
  %a47 = ptrtoint ptr %s.0 to i64
  %p48 = inttoptr i64 %a47 to ptr
  %v49 = load i64, ptr %p48
  %t50 = mul i64 2, 8
  %t51 = add i64 %v49, %t50
  %p52 = inttoptr i64 %t51 to ptr
  %v53 = load i64, ptr %p52
  %p54 = inttoptr i64 %a34 to ptr
  %r55 = call i32 (ptr, ...) @printf(ptr %p54, i64 %v39, i64 %v46, i64 %v53)
  %v56 = sext i32 %r55 to i64
  %a57 = ptrtoint ptr %s.1 to i64
  %p58 = inttoptr i64 %a57 to ptr
  %v59 = load i64, ptr %p58
  %a60 = ptrtoint ptr %s.0 to i64
  %p61 = inttoptr i64 %a60 to ptr
  %v62 = load i64, ptr %p61
  %p63 = inttoptr i64 %a57 to ptr
  store i64 %v62, ptr %p63
  %a64 = ptrtoint ptr %s.1 to i64
  %p65 = inttoptr i64 %a64 to ptr
  %v66 = load i64, ptr %p65
  %a67 = ptrtoint ptr %s.1 to i64
  %p68 = inttoptr i64 %a67 to ptr
  %v69 = load i64, ptr %p68
  %t70 = mul i64 2, 8
  %t71 = add i64 %v69, %t70
  %p72 = inttoptr i64 %a64 to ptr
  store i64 %t71, ptr %p72
  %a73 = ptrtoint ptr @.str.3 to i64
  %a74 = ptrtoint ptr %s.1 to i64
  %p75 = inttoptr i64 %a74 to ptr
  %v76 = load i64, ptr %p75
  %a77 = ptrtoint ptr %s.0 to i64
  %p78 = inttoptr i64 %a77 to ptr
  %v79 = load i64, ptr %p78
  %t80 = sub i64 %v76, %v79
  %t81 = sdiv i64 %t80, 8
  %a82 = ptrtoint ptr %s.1 to i64
  %p83 = inttoptr i64 %a82 to ptr
  %v84 = load i64, ptr %p83
  %p85 = inttoptr i64 %v84 to ptr
  %v86 = load i64, ptr %p85
  %p87 = inttoptr i64 %a73 to ptr
  %r88 = call i32 (ptr, ...) @printf(ptr %p87, i64 %t81, i64 %v86)
  %v89 = sext i32 %r88 to i64
  %a90 = ptrtoint ptr %s.0 to i64
  %p91 = inttoptr i64 %a90 to ptr
  %v92 = load i64, ptr %p91
  %p93 = inttoptr i64 %v92 to ptr
  call void @free(ptr %p93)
  %a94 = ptrtoint ptr %s.2 to i64
  %p95 = inttoptr i64 %a94 to ptr
  %v96 = load i64, ptr %p95
  %r97 = call ptr @malloc(i64 4)
  %a98 = ptrtoint ptr %r97 to i64
  %p99 = inttoptr i64 %a94 to ptr
  store i64 %a98, ptr %p99
  %a100 = ptrtoint ptr %s.2 to i64
  %p101 = inttoptr i64 %a100 to ptr
  %v102 = load i64, ptr %p101
  %t103 = add i64 %v102, 0
  %p104 = inttoptr i64 %t103 to ptr
  %b105 = load i8, ptr %p104
  %c106 = sext i8 %b105 to i64
  %p107 = inttoptr i64 %t103 to ptr
  %b108 = trunc i64 120 to i8
  store i8 %b108, ptr %p107
  %a109 = ptrtoint ptr %s.2 to i64
  %p110 = inttoptr i64 %a109 to ptr
  %v111 = load i64, ptr %p110
  %t112 = add i64 %v111, 1
  %p113 = inttoptr i64 %t112 to ptr
  %b114 = load i8, ptr %p113
  %c115 = sext i8 %b114 to i64
  %p116 = inttoptr i64 %t112 to ptr
  %b117 = trunc i64 121 to i8
  store i8 %b117, ptr %p116
  %a118 = ptrtoint ptr %s.2 to i64
  %p119 = inttoptr i64 %a118 to ptr
  %v120 = load i64, ptr %p119
  %t121 = add i64 %v120, 2
  %p122 = inttoptr i64 %t121 to ptr
  %b123 = load i8, ptr %p122
  %c124 = sext i8 %b123 to i64
  %p125 = inttoptr i64 %t121 to ptr
  %b126 = trunc i64 122 to i8
  store i8 %b126, ptr %p125
  %a127 = ptrtoint ptr %s.2 to i64
  %p128 = inttoptr i64 %a127 to ptr
  %v129 = load i64, ptr %p128
  %t130 = add i64 %v129, 3
  %p131 = inttoptr i64 %t130 to ptr
  %b132 = load i8, ptr %p131
  %c133 = sext i8 %b132 to i64
  %p134 = inttoptr i64 %t130 to ptr
  %b135 = trunc i64 0 to i8
  store i8 %b135, ptr %p134
  %a136 = ptrtoint ptr %s.3 to i64
  %p137 = inttoptr i64 %a136 to ptr
  %v138 = load i64, ptr %p137
  %a139 = ptrtoint ptr %s.2 to i64
  %p140 = inttoptr i64 %a139 to ptr
  %v141 = load i64, ptr %p140
  %t142 = add i64 %v141, 2
  %p143 = inttoptr i64 %a136 to ptr
  store i64 %t142, ptr %p143
  %a144 = ptrtoint ptr @.str.4 to i64
  %a145 = ptrtoint ptr %s.2 to i64
  %p146 = inttoptr i64 %a145 to ptr
  %v147 = load i64, ptr %p146
  %p148 = inttoptr i64 %v147 to ptr
  %b149 = load i8, ptr %p148
  %c150 = sext i8 %b149 to i64
  %a151 = ptrtoint ptr %s.2 to i64
  %p152 = inttoptr i64 %a151 to ptr
  %v153 = load i64, ptr %p152
  %t154 = add i64 %v153, 1
  %p155 = inttoptr i64 %t154 to ptr
  %b156 = load i8, ptr %p155
  %c157 = sext i8 %b156 to i64
  %a158 = ptrtoint ptr %s.3 to i64
  %p159 = inttoptr i64 %a158 to ptr
  %v160 = load i64, ptr %p159
  %p161 = inttoptr i64 %v160 to ptr
  %b162 = load i8, ptr %p161
  %c163 = sext i8 %b162 to i64
  %p164 = inttoptr i64 %a144 to ptr
  %r165 = call i32 (ptr, ...) @printf(ptr %p164, i64 %c150, i64 %c157, i64 %c163)
  %v166 = sext i32 %r165 to i64
  %a167 = ptrtoint ptr @.str.5 to i64
  %a168 = ptrtoint ptr %s.3 to i64
  %p169 = inttoptr i64 %a168 to ptr
  %v170 = load i64, ptr %p169
  %a171 = ptrtoint ptr %s.2 to i64
  %p172 = inttoptr i64 %a171 to ptr
  %v173 = load i64, ptr %p172
  %t174 = sub i64 %v170, %v173
  %p175 = inttoptr i64 %a167 to ptr
  %r176 = call i32 (ptr, ...) @printf(ptr %p175, i64 %t174)
  %v177 = sext i32 %r176 to i64
  %a178 = ptrtoint ptr %s.2 to i64
  %p179 = inttoptr i64 %a178 to ptr
  %v180 = load i64, ptr %p179
  %p181 = inttoptr i64 %v180 to ptr
  call void @free(ptr %p181)
  %a182 = ptrtoint ptr @g_g to i64
  %p183 = inttoptr i64 %a182 to ptr
  %v184 = load i64, ptr %p183
  %p185 = inttoptr i64 %a182 to ptr
  store i64 100, ptr %p185
  %a186 = ptrtoint ptr @g_gc to i64
  %p187 = inttoptr i64 %a186 to ptr
  %b188 = load i8, ptr %p187
  %c189 = sext i8 %b188 to i64
  %p190 = inttoptr i64 %a186 to ptr
  %b191 = trunc i64 90 to i8
  store i8 %b191, ptr %p190
  %a192 = ptrtoint ptr @.str.6 to i64
  %a193 = ptrtoint ptr @g_g to i64
  %p194 = inttoptr i64 %a193 to ptr
  %v195 = load i64, ptr %p194
  %a196 = ptrtoint ptr @g_gc to i64
  %p197 = inttoptr i64 %a196 to ptr
  %b198 = load i8, ptr %p197
  %c199 = sext i8 %b198 to i64
  %p200 = inttoptr i64 %a192 to ptr
  %r201 = call i32 (ptr, ...) @printf(ptr %p200, i64 %v195, i64 %c199)
  %v202 = sext i32 %r201 to i64
  %rv203 = trunc i64 0 to i32
  ret i32 %rv203
}

