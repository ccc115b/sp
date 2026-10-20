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

@.str.1 = private unnamed_addr constant [37 x i8] c"a+b=%d a-b=%d a*b=%d a/b=%d a%%b=%d\0a\00"
@.str.2 = private unnamed_addr constant [38 x i8] c"a<<1=%d a>>1=%d a|b=%d a&b=%d a^b=%d\0a\00"
@.str.3 = private unnamed_addr constant [25 x i8] c"-a=%d ~a=%d !a=%d !z=%d\0a\00"
@.str.4 = private unnamed_addr constant [39 x i8] c"a<b=%d a>b=%d a==b=%d a!=b=%d a<=b=%d\0a\00"
@.str.5 = private unnamed_addr constant [22 x i8] c"a>=b=%d cond=%s y=%d\0a\00"
@.str.6 = private unnamed_addr constant [4 x i8] c"yes\00"
@.str.7 = private unnamed_addr constant [3 x i8] c"no\00"
@.str.8 = private unnamed_addr constant [22 x i8] c"post %d %d pre %d %d\0a\00"

define i32 @main(i32 %.argc, ptr %.argv) {
entry:
  %s.0 = alloca i64
  %s.1 = alloca i64
  %s.2 = alloca i64
  %s.3 = alloca i64
  %s.4 = alloca i64
  %a1 = ptrtoint ptr %s.0 to i64
  %p2 = inttoptr i64 %a1 to ptr
  %v3 = load i64, ptr %p2
  %p4 = inttoptr i64 %a1 to ptr
  store i64 6, ptr %p4
  %a5 = ptrtoint ptr %s.1 to i64
  %p6 = inttoptr i64 %a5 to ptr
  %v7 = load i64, ptr %p6
  %p8 = inttoptr i64 %a5 to ptr
  store i64 4, ptr %p8
  %a9 = ptrtoint ptr %s.2 to i64
  %p10 = inttoptr i64 %a9 to ptr
  %v11 = load i64, ptr %p10
  %p12 = inttoptr i64 %a9 to ptr
  store i64 0, ptr %p12
  %a13 = ptrtoint ptr @.str.1 to i64
  %a14 = ptrtoint ptr %s.0 to i64
  %p15 = inttoptr i64 %a14 to ptr
  %v16 = load i64, ptr %p15
  %a17 = ptrtoint ptr %s.1 to i64
  %p18 = inttoptr i64 %a17 to ptr
  %v19 = load i64, ptr %p18
  %t20 = add i64 %v16, %v19
  %a21 = ptrtoint ptr %s.0 to i64
  %p22 = inttoptr i64 %a21 to ptr
  %v23 = load i64, ptr %p22
  %a24 = ptrtoint ptr %s.1 to i64
  %p25 = inttoptr i64 %a24 to ptr
  %v26 = load i64, ptr %p25
  %t27 = sub i64 %v23, %v26
  %a28 = ptrtoint ptr %s.0 to i64
  %p29 = inttoptr i64 %a28 to ptr
  %v30 = load i64, ptr %p29
  %a31 = ptrtoint ptr %s.1 to i64
  %p32 = inttoptr i64 %a31 to ptr
  %v33 = load i64, ptr %p32
  %t34 = mul i64 %v30, %v33
  %a35 = ptrtoint ptr %s.0 to i64
  %p36 = inttoptr i64 %a35 to ptr
  %v37 = load i64, ptr %p36
  %a38 = ptrtoint ptr %s.1 to i64
  %p39 = inttoptr i64 %a38 to ptr
  %v40 = load i64, ptr %p39
  %t41 = sdiv i64 %v37, %v40
  %a42 = ptrtoint ptr %s.0 to i64
  %p43 = inttoptr i64 %a42 to ptr
  %v44 = load i64, ptr %p43
  %a45 = ptrtoint ptr %s.1 to i64
  %p46 = inttoptr i64 %a45 to ptr
  %v47 = load i64, ptr %p46
  %t48 = srem i64 %v44, %v47
  %p49 = inttoptr i64 %a13 to ptr
  %r50 = call i32 (ptr, ...) @printf(ptr %p49, i64 %t20, i64 %t27, i64 %t34, i64 %t41, i64 %t48)
  %v51 = sext i32 %r50 to i64
  %a52 = ptrtoint ptr @.str.2 to i64
  %a53 = ptrtoint ptr %s.0 to i64
  %p54 = inttoptr i64 %a53 to ptr
  %v55 = load i64, ptr %p54
  %t56 = shl i64 %v55, 1
  %a57 = ptrtoint ptr %s.0 to i64
  %p58 = inttoptr i64 %a57 to ptr
  %v59 = load i64, ptr %p58
  %t60 = ashr i64 %v59, 1
  %a61 = ptrtoint ptr %s.0 to i64
  %p62 = inttoptr i64 %a61 to ptr
  %v63 = load i64, ptr %p62
  %a64 = ptrtoint ptr %s.1 to i64
  %p65 = inttoptr i64 %a64 to ptr
  %v66 = load i64, ptr %p65
  %t67 = or i64 %v63, %v66
  %a68 = ptrtoint ptr %s.0 to i64
  %p69 = inttoptr i64 %a68 to ptr
  %v70 = load i64, ptr %p69
  %a71 = ptrtoint ptr %s.1 to i64
  %p72 = inttoptr i64 %a71 to ptr
  %v73 = load i64, ptr %p72
  %t74 = and i64 %v70, %v73
  %a75 = ptrtoint ptr %s.0 to i64
  %p76 = inttoptr i64 %a75 to ptr
  %v77 = load i64, ptr %p76
  %a78 = ptrtoint ptr %s.1 to i64
  %p79 = inttoptr i64 %a78 to ptr
  %v80 = load i64, ptr %p79
  %t81 = xor i64 %v77, %v80
  %p82 = inttoptr i64 %a52 to ptr
  %r83 = call i32 (ptr, ...) @printf(ptr %p82, i64 %t56, i64 %t60, i64 %t67, i64 %t74, i64 %t81)
  %v84 = sext i32 %r83 to i64
  %a85 = ptrtoint ptr @.str.3 to i64
  %a86 = ptrtoint ptr %s.0 to i64
  %p87 = inttoptr i64 %a86 to ptr
  %v88 = load i64, ptr %p87
  %t89 = mul i64 -1, %v88
  %a90 = ptrtoint ptr %s.0 to i64
  %p91 = inttoptr i64 %a90 to ptr
  %v92 = load i64, ptr %p91
  %t93 = xor i64 %v92, -1
  %a94 = ptrtoint ptr %s.0 to i64
  %p95 = inttoptr i64 %a94 to ptr
  %v96 = load i64, ptr %p95
  %c97 = icmp eq i64 %v96, 0
  %b98 = zext i1 %c97 to i64
  %a99 = ptrtoint ptr %s.2 to i64
  %p100 = inttoptr i64 %a99 to ptr
  %v101 = load i64, ptr %p100
  %c102 = icmp eq i64 %v101, 0
  %b103 = zext i1 %c102 to i64
  %p104 = inttoptr i64 %a85 to ptr
  %r105 = call i32 (ptr, ...) @printf(ptr %p104, i64 %t89, i64 %t93, i64 %b98, i64 %b103)
  %v106 = sext i32 %r105 to i64
  %a107 = ptrtoint ptr @.str.4 to i64
  %a108 = ptrtoint ptr %s.0 to i64
  %p109 = inttoptr i64 %a108 to ptr
  %v110 = load i64, ptr %p109
  %a111 = ptrtoint ptr %s.1 to i64
  %p112 = inttoptr i64 %a111 to ptr
  %v113 = load i64, ptr %p112
  %c114 = icmp slt i64 %v110, %v113
  %b115 = zext i1 %c114 to i64
  %a116 = ptrtoint ptr %s.0 to i64
  %p117 = inttoptr i64 %a116 to ptr
  %v118 = load i64, ptr %p117
  %a119 = ptrtoint ptr %s.1 to i64
  %p120 = inttoptr i64 %a119 to ptr
  %v121 = load i64, ptr %p120
  %c122 = icmp sgt i64 %v118, %v121
  %b123 = zext i1 %c122 to i64
  %a124 = ptrtoint ptr %s.0 to i64
  %p125 = inttoptr i64 %a124 to ptr
  %v126 = load i64, ptr %p125
  %a127 = ptrtoint ptr %s.1 to i64
  %p128 = inttoptr i64 %a127 to ptr
  %v129 = load i64, ptr %p128
  %c130 = icmp eq i64 %v126, %v129
  %b131 = zext i1 %c130 to i64
  %a132 = ptrtoint ptr %s.0 to i64
  %p133 = inttoptr i64 %a132 to ptr
  %v134 = load i64, ptr %p133
  %a135 = ptrtoint ptr %s.1 to i64
  %p136 = inttoptr i64 %a135 to ptr
  %v137 = load i64, ptr %p136
  %c138 = icmp ne i64 %v134, %v137
  %b139 = zext i1 %c138 to i64
  %a140 = ptrtoint ptr %s.0 to i64
  %p141 = inttoptr i64 %a140 to ptr
  %v142 = load i64, ptr %p141
  %a143 = ptrtoint ptr %s.1 to i64
  %p144 = inttoptr i64 %a143 to ptr
  %v145 = load i64, ptr %p144
  %c146 = icmp sle i64 %v142, %v145
  %b147 = zext i1 %c146 to i64
  %p148 = inttoptr i64 %a107 to ptr
  %r149 = call i32 (ptr, ...) @printf(ptr %p148, i64 %b115, i64 %b123, i64 %b131, i64 %b139, i64 %b147)
  %v150 = sext i32 %r149 to i64
  %a151 = ptrtoint ptr @.str.5 to i64
  %a152 = ptrtoint ptr %s.0 to i64
  %p153 = inttoptr i64 %a152 to ptr
  %v154 = load i64, ptr %p153
  %a155 = ptrtoint ptr %s.1 to i64
  %p156 = inttoptr i64 %a155 to ptr
  %v157 = load i64, ptr %p156
  %c158 = icmp sge i64 %v154, %v157
  %b159 = zext i1 %c158 to i64
  %a160 = ptrtoint ptr %s.0 to i64
  %p161 = inttoptr i64 %a160 to ptr
  %v162 = load i64, ptr %p161
  %a163 = ptrtoint ptr %s.1 to i64
  %p164 = inttoptr i64 %a163 to ptr
  %v165 = load i64, ptr %p164
  %c166 = icmp sgt i64 %v162, %v165
  %b167 = zext i1 %c166 to i64
  %c168 = icmp ne i64 %b167, 0
  br i1 %c168, label %cond.t.1, label %cond.f.2
cond.t.1:
  %a169 = ptrtoint ptr @.str.6 to i64
  br label %cond.end.3
cond.f.2:
  %a170 = ptrtoint ptr @.str.7 to i64
  br label %cond.end.3
cond.end.3:
  %sel171 = phi i64 [ %a169, %cond.t.1 ], [ %a170, %cond.f.2 ]
  %a172 = ptrtoint ptr %s.0 to i64
  %p173 = inttoptr i64 %a172 to ptr
  %v174 = load i64, ptr %p173
  %a175 = ptrtoint ptr %s.1 to i64
  %p176 = inttoptr i64 %a175 to ptr
  %v177 = load i64, ptr %p176
  %c178 = icmp sgt i64 %v174, %v177
  %b179 = zext i1 %c178 to i64
  %c180 = icmp ne i64 %b179, 0
  br i1 %c180, label %cond.t.4, label %cond.f.5
cond.t.4:
  br label %cond.end.6
cond.f.5:
  br label %cond.end.6
cond.end.6:
  %sel181 = phi i64 [ 100, %cond.t.4 ], [ 200, %cond.f.5 ]
  %p182 = inttoptr i64 %a151 to ptr
  %r183 = call i32 (ptr, ...) @printf(ptr %p182, i64 %b159, i64 %sel171, i64 %sel181)
  %v184 = sext i32 %r183 to i64
  %a185 = ptrtoint ptr %s.3 to i64
  %p186 = inttoptr i64 %a185 to ptr
  %v187 = load i64, ptr %p186
  %p188 = inttoptr i64 %a185 to ptr
  store i64 5, ptr %p188
  %a189 = ptrtoint ptr @.str.8 to i64
  %a190 = ptrtoint ptr %s.3 to i64
  %p191 = inttoptr i64 %a190 to ptr
  %v192 = load i64, ptr %p191
  %t193 = add i64 %v192, 1
  %p194 = inttoptr i64 %a190 to ptr
  store i64 %t193, ptr %p194
  %a195 = ptrtoint ptr %s.3 to i64
  %p196 = inttoptr i64 %a195 to ptr
  %v197 = load i64, ptr %p196
  %t198 = add i64 %v197, 1
  %p199 = inttoptr i64 %a195 to ptr
  store i64 %t198, ptr %p199
  %a200 = ptrtoint ptr %s.3 to i64
  %p201 = inttoptr i64 %a200 to ptr
  %v202 = load i64, ptr %p201
  %t203 = add i64 %v202, 1
  %p204 = inttoptr i64 %a200 to ptr
  store i64 %t203, ptr %p204
  %a205 = ptrtoint ptr %s.3 to i64
  %p206 = inttoptr i64 %a205 to ptr
  %v207 = load i64, ptr %p206
  %t208 = sub i64 %v207, 1
  %p209 = inttoptr i64 %a205 to ptr
  store i64 %t208, ptr %p209
  %p210 = inttoptr i64 %a189 to ptr
  %r211 = call i32 (ptr, ...) @printf(ptr %p210, i64 %v192, i64 %v197, i64 %t203, i64 %t208)
  %v212 = sext i32 %r211 to i64
  %a213 = ptrtoint ptr %s.4 to i64
  %p214 = inttoptr i64 %a213 to ptr
  %v215 = load i64, ptr %p214
  %a216 = ptrtoint ptr %s.0 to i64
  %p217 = inttoptr i64 %a216 to ptr
  %v218 = load i64, ptr %p217
  %a219 = ptrtoint ptr %s.1 to i64
  %p220 = inttoptr i64 %a219 to ptr
  %v221 = load i64, ptr %p220
  %c222 = icmp sgt i64 %v218, %v221
  %b223 = zext i1 %c222 to i64
  %c224 = icmp ne i64 %b223, 0
  br i1 %c224, label %cond.t.7, label %cond.f.8
cond.t.7:
  br label %cond.end.9
cond.f.8:
  br label %cond.end.9
cond.end.9:
  %sel225 = phi i64 [ 100, %cond.t.7 ], [ 200, %cond.f.8 ]
  %p226 = inttoptr i64 %a213 to ptr
  store i64 %sel225, ptr %p226
  %a227 = ptrtoint ptr %s.4 to i64
  %p228 = inttoptr i64 %a227 to ptr
  %v229 = load i64, ptr %p228
  %c230 = icmp ne i64 %v229, 100
  %b231 = zext i1 %c230 to i64
  %c232 = icmp ne i64 %b231, 0
  br i1 %c232, label %if.then.10, label %if.else.11
if.then.10:
  %rv233 = trunc i64 1 to i32
  ret i32 %rv233
if.else.11:
  br label %if.end.12
if.end.12:
  %rv234 = trunc i64 0 to i32
  ret i32 %rv234
}

