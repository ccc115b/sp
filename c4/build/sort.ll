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

@.str.1 = private unnamed_addr constant [5 x i8] c"asc:\00"
@.str.2 = private unnamed_addr constant [4 x i8] c" %d\00"
@.str.3 = private unnamed_addr constant [2 x i8] c"\0a\00"
@.str.4 = private unnamed_addr constant [6 x i8] c"desc:\00"
@.str.5 = private unnamed_addr constant [4 x i8] c" %d\00"
@.str.6 = private unnamed_addr constant [2 x i8] c"\0a\00"
@.str.7 = private unnamed_addr constant [22 x i8] c"search 7 -> index %d\0a\00"
@.str.8 = private unnamed_addr constant [22 x i8] c"sum=%d min=%d max=%d\0a\00"

define i32 @main(i32 %.argc, ptr %.argv) {
entry:
  %s.0 = alloca i64
  %s.1 = alloca i64
  %s.2 = alloca i64
  %s.3 = alloca i64
  %s.4 = alloca i64
  %s.5 = alloca i64
  %s.6 = alloca i64
  %s.7 = alloca i64
  %s.8 = alloca i64
  %a1 = ptrtoint ptr %s.1 to i64
  %p2 = inttoptr i64 %a1 to ptr
  %v3 = load i64, ptr %p2
  %p4 = inttoptr i64 %a1 to ptr
  store i64 9, ptr %p4
  %a5 = ptrtoint ptr %s.0 to i64
  %p6 = inttoptr i64 %a5 to ptr
  %v7 = load i64, ptr %p6
  %a8 = ptrtoint ptr %s.1 to i64
  %p9 = inttoptr i64 %a8 to ptr
  %v10 = load i64, ptr %p9
  %t11 = mul i64 %v10, 8
  %r12 = call ptr @malloc(i64 %t11)
  %a13 = ptrtoint ptr %r12 to i64
  %p14 = inttoptr i64 %a5 to ptr
  store i64 %a13, ptr %p14
  %a15 = ptrtoint ptr %s.0 to i64
  %p16 = inttoptr i64 %a15 to ptr
  %v17 = load i64, ptr %p16
  %t18 = mul i64 0, 8
  %t19 = add i64 %v17, %t18
  %p20 = inttoptr i64 %t19 to ptr
  %v21 = load i64, ptr %p20
  %p22 = inttoptr i64 %t19 to ptr
  store i64 9, ptr %p22
  %a23 = ptrtoint ptr %s.0 to i64
  %p24 = inttoptr i64 %a23 to ptr
  %v25 = load i64, ptr %p24
  %t26 = mul i64 1, 8
  %t27 = add i64 %v25, %t26
  %p28 = inttoptr i64 %t27 to ptr
  %v29 = load i64, ptr %p28
  %p30 = inttoptr i64 %t27 to ptr
  store i64 3, ptr %p30
  %a31 = ptrtoint ptr %s.0 to i64
  %p32 = inttoptr i64 %a31 to ptr
  %v33 = load i64, ptr %p32
  %t34 = mul i64 2, 8
  %t35 = add i64 %v33, %t34
  %p36 = inttoptr i64 %t35 to ptr
  %v37 = load i64, ptr %p36
  %p38 = inttoptr i64 %t35 to ptr
  store i64 7, ptr %p38
  %a39 = ptrtoint ptr %s.0 to i64
  %p40 = inttoptr i64 %a39 to ptr
  %v41 = load i64, ptr %p40
  %t42 = mul i64 3, 8
  %t43 = add i64 %v41, %t42
  %p44 = inttoptr i64 %t43 to ptr
  %v45 = load i64, ptr %p44
  %p46 = inttoptr i64 %t43 to ptr
  store i64 1, ptr %p46
  %a47 = ptrtoint ptr %s.0 to i64
  %p48 = inttoptr i64 %a47 to ptr
  %v49 = load i64, ptr %p48
  %t50 = mul i64 4, 8
  %t51 = add i64 %v49, %t50
  %p52 = inttoptr i64 %t51 to ptr
  %v53 = load i64, ptr %p52
  %p54 = inttoptr i64 %t51 to ptr
  store i64 5, ptr %p54
  %a55 = ptrtoint ptr %s.0 to i64
  %p56 = inttoptr i64 %a55 to ptr
  %v57 = load i64, ptr %p56
  %t58 = mul i64 5, 8
  %t59 = add i64 %v57, %t58
  %p60 = inttoptr i64 %t59 to ptr
  %v61 = load i64, ptr %p60
  %p62 = inttoptr i64 %t59 to ptr
  store i64 2, ptr %p62
  %a63 = ptrtoint ptr %s.0 to i64
  %p64 = inttoptr i64 %a63 to ptr
  %v65 = load i64, ptr %p64
  %t66 = mul i64 6, 8
  %t67 = add i64 %v65, %t66
  %p68 = inttoptr i64 %t67 to ptr
  %v69 = load i64, ptr %p68
  %p70 = inttoptr i64 %t67 to ptr
  store i64 8, ptr %p70
  %a71 = ptrtoint ptr %s.0 to i64
  %p72 = inttoptr i64 %a71 to ptr
  %v73 = load i64, ptr %p72
  %t74 = mul i64 7, 8
  %t75 = add i64 %v73, %t74
  %p76 = inttoptr i64 %t75 to ptr
  %v77 = load i64, ptr %p76
  %p78 = inttoptr i64 %t75 to ptr
  store i64 4, ptr %p78
  %a79 = ptrtoint ptr %s.0 to i64
  %p80 = inttoptr i64 %a79 to ptr
  %v81 = load i64, ptr %p80
  %t82 = mul i64 8, 8
  %t83 = add i64 %v81, %t82
  %p84 = inttoptr i64 %t83 to ptr
  %v85 = load i64, ptr %p84
  %p86 = inttoptr i64 %t83 to ptr
  store i64 6, ptr %p86
  %a87 = ptrtoint ptr %s.2 to i64
  %p88 = inttoptr i64 %a87 to ptr
  %v89 = load i64, ptr %p88
  %p90 = inttoptr i64 %a87 to ptr
  store i64 1, ptr %p90
  br label %wh.cond.1
wh.cond.1:
  %a91 = ptrtoint ptr %s.2 to i64
  %p92 = inttoptr i64 %a91 to ptr
  %v93 = load i64, ptr %p92
  %a94 = ptrtoint ptr %s.1 to i64
  %p95 = inttoptr i64 %a94 to ptr
  %v96 = load i64, ptr %p95
  %c97 = icmp slt i64 %v93, %v96
  %b98 = zext i1 %c97 to i64
  %c99 = icmp ne i64 %b98, 0
  br i1 %c99, label %wh.body.2, label %wh.end.3
wh.body.2:
  %a100 = ptrtoint ptr %s.4 to i64
  %p101 = inttoptr i64 %a100 to ptr
  %v102 = load i64, ptr %p101
  %a103 = ptrtoint ptr %s.0 to i64
  %p104 = inttoptr i64 %a103 to ptr
  %v105 = load i64, ptr %p104
  %a106 = ptrtoint ptr %s.2 to i64
  %p107 = inttoptr i64 %a106 to ptr
  %v108 = load i64, ptr %p107
  %t109 = mul i64 %v108, 8
  %t110 = add i64 %v105, %t109
  %p111 = inttoptr i64 %t110 to ptr
  %v112 = load i64, ptr %p111
  %p113 = inttoptr i64 %a100 to ptr
  store i64 %v112, ptr %p113
  %a114 = ptrtoint ptr %s.3 to i64
  %p115 = inttoptr i64 %a114 to ptr
  %v116 = load i64, ptr %p115
  %a117 = ptrtoint ptr %s.2 to i64
  %p118 = inttoptr i64 %a117 to ptr
  %v119 = load i64, ptr %p118
  %t120 = sub i64 %v119, 1
  %p121 = inttoptr i64 %a114 to ptr
  store i64 %t120, ptr %p121
  br label %wh.cond.4
wh.cond.4:
  %a122 = ptrtoint ptr %s.3 to i64
  %p123 = inttoptr i64 %a122 to ptr
  %v124 = load i64, ptr %p123
  %c125 = icmp sge i64 %v124, 0
  %b126 = zext i1 %c125 to i64
  %c127 = icmp ne i64 %b126, 0
  br i1 %c127, label %lan.rhs.7, label %lan.end.8
lan.rhs.7:
  %a128 = ptrtoint ptr %s.0 to i64
  %p129 = inttoptr i64 %a128 to ptr
  %v130 = load i64, ptr %p129
  %a131 = ptrtoint ptr %s.3 to i64
  %p132 = inttoptr i64 %a131 to ptr
  %v133 = load i64, ptr %p132
  %t134 = mul i64 %v133, 8
  %t135 = add i64 %v130, %t134
  %p136 = inttoptr i64 %t135 to ptr
  %v137 = load i64, ptr %p136
  %a138 = ptrtoint ptr %s.4 to i64
  %p139 = inttoptr i64 %a138 to ptr
  %v140 = load i64, ptr %p139
  %c141 = icmp sgt i64 %v137, %v140
  %b142 = zext i1 %c141 to i64
  %c143 = icmp ne i64 %b142, 0
  br label %lan.end.8
lan.end.8:
  %b144 = phi i1 [ false, %wh.cond.4 ], [ %c143, %lan.rhs.7 ]
  %b145 = zext i1 %b144 to i64
  %c146 = icmp ne i64 %b145, 0
  br i1 %c146, label %wh.body.5, label %wh.end.6
wh.body.5:
  %a147 = ptrtoint ptr %s.0 to i64
  %p148 = inttoptr i64 %a147 to ptr
  %v149 = load i64, ptr %p148
  %a150 = ptrtoint ptr %s.3 to i64
  %p151 = inttoptr i64 %a150 to ptr
  %v152 = load i64, ptr %p151
  %t153 = add i64 %v152, 1
  %t154 = mul i64 %t153, 8
  %t155 = add i64 %v149, %t154
  %p156 = inttoptr i64 %t155 to ptr
  %v157 = load i64, ptr %p156
  %a158 = ptrtoint ptr %s.0 to i64
  %p159 = inttoptr i64 %a158 to ptr
  %v160 = load i64, ptr %p159
  %a161 = ptrtoint ptr %s.3 to i64
  %p162 = inttoptr i64 %a161 to ptr
  %v163 = load i64, ptr %p162
  %t164 = mul i64 %v163, 8
  %t165 = add i64 %v160, %t164
  %p166 = inttoptr i64 %t165 to ptr
  %v167 = load i64, ptr %p166
  %p168 = inttoptr i64 %t155 to ptr
  store i64 %v167, ptr %p168
  %a169 = ptrtoint ptr %s.3 to i64
  %p170 = inttoptr i64 %a169 to ptr
  %v171 = load i64, ptr %p170
  %a172 = ptrtoint ptr %s.3 to i64
  %p173 = inttoptr i64 %a172 to ptr
  %v174 = load i64, ptr %p173
  %t175 = sub i64 %v174, 1
  %p176 = inttoptr i64 %a169 to ptr
  store i64 %t175, ptr %p176
  br label %wh.cond.4
wh.end.6:
  %a177 = ptrtoint ptr %s.0 to i64
  %p178 = inttoptr i64 %a177 to ptr
  %v179 = load i64, ptr %p178
  %a180 = ptrtoint ptr %s.3 to i64
  %p181 = inttoptr i64 %a180 to ptr
  %v182 = load i64, ptr %p181
  %t183 = add i64 %v182, 1
  %t184 = mul i64 %t183, 8
  %t185 = add i64 %v179, %t184
  %p186 = inttoptr i64 %t185 to ptr
  %v187 = load i64, ptr %p186
  %a188 = ptrtoint ptr %s.4 to i64
  %p189 = inttoptr i64 %a188 to ptr
  %v190 = load i64, ptr %p189
  %p191 = inttoptr i64 %t185 to ptr
  store i64 %v190, ptr %p191
  %a192 = ptrtoint ptr %s.2 to i64
  %p193 = inttoptr i64 %a192 to ptr
  %v194 = load i64, ptr %p193
  %a195 = ptrtoint ptr %s.2 to i64
  %p196 = inttoptr i64 %a195 to ptr
  %v197 = load i64, ptr %p196
  %t198 = add i64 %v197, 1
  %p199 = inttoptr i64 %a192 to ptr
  store i64 %t198, ptr %p199
  br label %wh.cond.1
wh.end.3:
  %a200 = ptrtoint ptr @.str.1 to i64
  %p201 = inttoptr i64 %a200 to ptr
  %r202 = call i32 (ptr, ...) @printf(ptr %p201)
  %v203 = sext i32 %r202 to i64
  %a204 = ptrtoint ptr %s.2 to i64
  %p205 = inttoptr i64 %a204 to ptr
  %v206 = load i64, ptr %p205
  %p207 = inttoptr i64 %a204 to ptr
  store i64 0, ptr %p207
  br label %wh.cond.9
wh.cond.9:
  %a208 = ptrtoint ptr %s.2 to i64
  %p209 = inttoptr i64 %a208 to ptr
  %v210 = load i64, ptr %p209
  %a211 = ptrtoint ptr %s.1 to i64
  %p212 = inttoptr i64 %a211 to ptr
  %v213 = load i64, ptr %p212
  %c214 = icmp slt i64 %v210, %v213
  %b215 = zext i1 %c214 to i64
  %c216 = icmp ne i64 %b215, 0
  br i1 %c216, label %wh.body.10, label %wh.end.11
wh.body.10:
  %a217 = ptrtoint ptr @.str.2 to i64
  %a218 = ptrtoint ptr %s.0 to i64
  %p219 = inttoptr i64 %a218 to ptr
  %v220 = load i64, ptr %p219
  %a221 = ptrtoint ptr %s.2 to i64
  %p222 = inttoptr i64 %a221 to ptr
  %v223 = load i64, ptr %p222
  %t224 = mul i64 %v223, 8
  %t225 = add i64 %v220, %t224
  %p226 = inttoptr i64 %t225 to ptr
  %v227 = load i64, ptr %p226
  %p228 = inttoptr i64 %a217 to ptr
  %r229 = call i32 (ptr, ...) @printf(ptr %p228, i64 %v227)
  %v230 = sext i32 %r229 to i64
  %a231 = ptrtoint ptr %s.2 to i64
  %p232 = inttoptr i64 %a231 to ptr
  %v233 = load i64, ptr %p232
  %a234 = ptrtoint ptr %s.2 to i64
  %p235 = inttoptr i64 %a234 to ptr
  %v236 = load i64, ptr %p235
  %t237 = add i64 %v236, 1
  %p238 = inttoptr i64 %a231 to ptr
  store i64 %t237, ptr %p238
  br label %wh.cond.9
wh.end.11:
  %a239 = ptrtoint ptr @.str.3 to i64
  %p240 = inttoptr i64 %a239 to ptr
  %r241 = call i32 (ptr, ...) @printf(ptr %p240)
  %v242 = sext i32 %r241 to i64
  %a243 = ptrtoint ptr @.str.4 to i64
  %p244 = inttoptr i64 %a243 to ptr
  %r245 = call i32 (ptr, ...) @printf(ptr %p244)
  %v246 = sext i32 %r245 to i64
  %a247 = ptrtoint ptr %s.2 to i64
  %p248 = inttoptr i64 %a247 to ptr
  %v249 = load i64, ptr %p248
  %a250 = ptrtoint ptr %s.1 to i64
  %p251 = inttoptr i64 %a250 to ptr
  %v252 = load i64, ptr %p251
  %t253 = sub i64 %v252, 1
  %p254 = inttoptr i64 %a247 to ptr
  store i64 %t253, ptr %p254
  br label %wh.cond.12
wh.cond.12:
  %a255 = ptrtoint ptr %s.2 to i64
  %p256 = inttoptr i64 %a255 to ptr
  %v257 = load i64, ptr %p256
  %c258 = icmp sge i64 %v257, 0
  %b259 = zext i1 %c258 to i64
  %c260 = icmp ne i64 %b259, 0
  br i1 %c260, label %wh.body.13, label %wh.end.14
wh.body.13:
  %a261 = ptrtoint ptr @.str.5 to i64
  %a262 = ptrtoint ptr %s.0 to i64
  %p263 = inttoptr i64 %a262 to ptr
  %v264 = load i64, ptr %p263
  %a265 = ptrtoint ptr %s.2 to i64
  %p266 = inttoptr i64 %a265 to ptr
  %v267 = load i64, ptr %p266
  %t268 = mul i64 %v267, 8
  %t269 = add i64 %v264, %t268
  %p270 = inttoptr i64 %t269 to ptr
  %v271 = load i64, ptr %p270
  %p272 = inttoptr i64 %a261 to ptr
  %r273 = call i32 (ptr, ...) @printf(ptr %p272, i64 %v271)
  %v274 = sext i32 %r273 to i64
  %a275 = ptrtoint ptr %s.2 to i64
  %p276 = inttoptr i64 %a275 to ptr
  %v277 = load i64, ptr %p276
  %a278 = ptrtoint ptr %s.2 to i64
  %p279 = inttoptr i64 %a278 to ptr
  %v280 = load i64, ptr %p279
  %t281 = sub i64 %v280, 1
  %p282 = inttoptr i64 %a275 to ptr
  store i64 %t281, ptr %p282
  br label %wh.cond.12
wh.end.14:
  %a283 = ptrtoint ptr @.str.6 to i64
  %p284 = inttoptr i64 %a283 to ptr
  %r285 = call i32 (ptr, ...) @printf(ptr %p284)
  %v286 = sext i32 %r285 to i64
  %a287 = ptrtoint ptr %s.8 to i64
  %p288 = inttoptr i64 %a287 to ptr
  %v289 = load i64, ptr %p288
  %p290 = inttoptr i64 %a287 to ptr
  store i64 -1, ptr %p290
  %a291 = ptrtoint ptr %s.2 to i64
  %p292 = inttoptr i64 %a291 to ptr
  %v293 = load i64, ptr %p292
  %p294 = inttoptr i64 %a291 to ptr
  store i64 0, ptr %p294
  br label %wh.cond.15
wh.cond.15:
  %a295 = ptrtoint ptr %s.2 to i64
  %p296 = inttoptr i64 %a295 to ptr
  %v297 = load i64, ptr %p296
  %a298 = ptrtoint ptr %s.1 to i64
  %p299 = inttoptr i64 %a298 to ptr
  %v300 = load i64, ptr %p299
  %c301 = icmp slt i64 %v297, %v300
  %b302 = zext i1 %c301 to i64
  %c303 = icmp ne i64 %b302, 0
  br i1 %c303, label %wh.body.16, label %wh.end.17
wh.body.16:
  %a304 = ptrtoint ptr %s.0 to i64
  %p305 = inttoptr i64 %a304 to ptr
  %v306 = load i64, ptr %p305
  %a307 = ptrtoint ptr %s.2 to i64
  %p308 = inttoptr i64 %a307 to ptr
  %v309 = load i64, ptr %p308
  %t310 = mul i64 %v309, 8
  %t311 = add i64 %v306, %t310
  %p312 = inttoptr i64 %t311 to ptr
  %v313 = load i64, ptr %p312
  %c314 = icmp eq i64 %v313, 7
  %b315 = zext i1 %c314 to i64
  %c316 = icmp ne i64 %b315, 0
  br i1 %c316, label %if.then.18, label %if.else.19
if.then.18:
  %a317 = ptrtoint ptr %s.8 to i64
  %p318 = inttoptr i64 %a317 to ptr
  %v319 = load i64, ptr %p318
  %a320 = ptrtoint ptr %s.2 to i64
  %p321 = inttoptr i64 %a320 to ptr
  %v322 = load i64, ptr %p321
  %p323 = inttoptr i64 %a317 to ptr
  store i64 %v322, ptr %p323
  br label %if.end.20
if.else.19:
  br label %if.end.20
if.end.20:
  %a324 = ptrtoint ptr %s.2 to i64
  %p325 = inttoptr i64 %a324 to ptr
  %v326 = load i64, ptr %p325
  %a327 = ptrtoint ptr %s.2 to i64
  %p328 = inttoptr i64 %a327 to ptr
  %v329 = load i64, ptr %p328
  %t330 = add i64 %v329, 1
  %p331 = inttoptr i64 %a324 to ptr
  store i64 %t330, ptr %p331
  br label %wh.cond.15
wh.end.17:
  %a332 = ptrtoint ptr @.str.7 to i64
  %a333 = ptrtoint ptr %s.8 to i64
  %p334 = inttoptr i64 %a333 to ptr
  %v335 = load i64, ptr %p334
  %p336 = inttoptr i64 %a332 to ptr
  %r337 = call i32 (ptr, ...) @printf(ptr %p336, i64 %v335)
  %v338 = sext i32 %r337 to i64
  %a339 = ptrtoint ptr %s.5 to i64
  %p340 = inttoptr i64 %a339 to ptr
  %v341 = load i64, ptr %p340
  %p342 = inttoptr i64 %a339 to ptr
  store i64 0, ptr %p342
  %a343 = ptrtoint ptr %s.6 to i64
  %p344 = inttoptr i64 %a343 to ptr
  %v345 = load i64, ptr %p344
  %a346 = ptrtoint ptr %s.0 to i64
  %p347 = inttoptr i64 %a346 to ptr
  %v348 = load i64, ptr %p347
  %t349 = mul i64 0, 8
  %t350 = add i64 %v348, %t349
  %p351 = inttoptr i64 %t350 to ptr
  %v352 = load i64, ptr %p351
  %p353 = inttoptr i64 %a343 to ptr
  store i64 %v352, ptr %p353
  %a354 = ptrtoint ptr %s.7 to i64
  %p355 = inttoptr i64 %a354 to ptr
  %v356 = load i64, ptr %p355
  %a357 = ptrtoint ptr %s.0 to i64
  %p358 = inttoptr i64 %a357 to ptr
  %v359 = load i64, ptr %p358
  %t360 = mul i64 0, 8
  %t361 = add i64 %v359, %t360
  %p362 = inttoptr i64 %t361 to ptr
  %v363 = load i64, ptr %p362
  %p364 = inttoptr i64 %a354 to ptr
  store i64 %v363, ptr %p364
  %a365 = ptrtoint ptr %s.2 to i64
  %p366 = inttoptr i64 %a365 to ptr
  %v367 = load i64, ptr %p366
  %p368 = inttoptr i64 %a365 to ptr
  store i64 0, ptr %p368
  br label %wh.cond.21
wh.cond.21:
  %a369 = ptrtoint ptr %s.2 to i64
  %p370 = inttoptr i64 %a369 to ptr
  %v371 = load i64, ptr %p370
  %a372 = ptrtoint ptr %s.1 to i64
  %p373 = inttoptr i64 %a372 to ptr
  %v374 = load i64, ptr %p373
  %c375 = icmp slt i64 %v371, %v374
  %b376 = zext i1 %c375 to i64
  %c377 = icmp ne i64 %b376, 0
  br i1 %c377, label %wh.body.22, label %wh.end.23
wh.body.22:
  %a378 = ptrtoint ptr %s.5 to i64
  %p379 = inttoptr i64 %a378 to ptr
  %v380 = load i64, ptr %p379
  %a381 = ptrtoint ptr %s.5 to i64
  %p382 = inttoptr i64 %a381 to ptr
  %v383 = load i64, ptr %p382
  %a384 = ptrtoint ptr %s.0 to i64
  %p385 = inttoptr i64 %a384 to ptr
  %v386 = load i64, ptr %p385
  %a387 = ptrtoint ptr %s.2 to i64
  %p388 = inttoptr i64 %a387 to ptr
  %v389 = load i64, ptr %p388
  %t390 = mul i64 %v389, 8
  %t391 = add i64 %v386, %t390
  %p392 = inttoptr i64 %t391 to ptr
  %v393 = load i64, ptr %p392
  %t394 = add i64 %v383, %v393
  %p395 = inttoptr i64 %a378 to ptr
  store i64 %t394, ptr %p395
  %a396 = ptrtoint ptr %s.0 to i64
  %p397 = inttoptr i64 %a396 to ptr
  %v398 = load i64, ptr %p397
  %a399 = ptrtoint ptr %s.2 to i64
  %p400 = inttoptr i64 %a399 to ptr
  %v401 = load i64, ptr %p400
  %t402 = mul i64 %v401, 8
  %t403 = add i64 %v398, %t402
  %p404 = inttoptr i64 %t403 to ptr
  %v405 = load i64, ptr %p404
  %a406 = ptrtoint ptr %s.6 to i64
  %p407 = inttoptr i64 %a406 to ptr
  %v408 = load i64, ptr %p407
  %c409 = icmp slt i64 %v405, %v408
  %b410 = zext i1 %c409 to i64
  %c411 = icmp ne i64 %b410, 0
  br i1 %c411, label %if.then.24, label %if.else.25
if.then.24:
  %a412 = ptrtoint ptr %s.6 to i64
  %p413 = inttoptr i64 %a412 to ptr
  %v414 = load i64, ptr %p413
  %a415 = ptrtoint ptr %s.0 to i64
  %p416 = inttoptr i64 %a415 to ptr
  %v417 = load i64, ptr %p416
  %a418 = ptrtoint ptr %s.2 to i64
  %p419 = inttoptr i64 %a418 to ptr
  %v420 = load i64, ptr %p419
  %t421 = mul i64 %v420, 8
  %t422 = add i64 %v417, %t421
  %p423 = inttoptr i64 %t422 to ptr
  %v424 = load i64, ptr %p423
  %p425 = inttoptr i64 %a412 to ptr
  store i64 %v424, ptr %p425
  br label %if.end.26
if.else.25:
  br label %if.end.26
if.end.26:
  %a426 = ptrtoint ptr %s.0 to i64
  %p427 = inttoptr i64 %a426 to ptr
  %v428 = load i64, ptr %p427
  %a429 = ptrtoint ptr %s.2 to i64
  %p430 = inttoptr i64 %a429 to ptr
  %v431 = load i64, ptr %p430
  %t432 = mul i64 %v431, 8
  %t433 = add i64 %v428, %t432
  %p434 = inttoptr i64 %t433 to ptr
  %v435 = load i64, ptr %p434
  %a436 = ptrtoint ptr %s.7 to i64
  %p437 = inttoptr i64 %a436 to ptr
  %v438 = load i64, ptr %p437
  %c439 = icmp sgt i64 %v435, %v438
  %b440 = zext i1 %c439 to i64
  %c441 = icmp ne i64 %b440, 0
  br i1 %c441, label %if.then.27, label %if.else.28
if.then.27:
  %a442 = ptrtoint ptr %s.7 to i64
  %p443 = inttoptr i64 %a442 to ptr
  %v444 = load i64, ptr %p443
  %a445 = ptrtoint ptr %s.0 to i64
  %p446 = inttoptr i64 %a445 to ptr
  %v447 = load i64, ptr %p446
  %a448 = ptrtoint ptr %s.2 to i64
  %p449 = inttoptr i64 %a448 to ptr
  %v450 = load i64, ptr %p449
  %t451 = mul i64 %v450, 8
  %t452 = add i64 %v447, %t451
  %p453 = inttoptr i64 %t452 to ptr
  %v454 = load i64, ptr %p453
  %p455 = inttoptr i64 %a442 to ptr
  store i64 %v454, ptr %p455
  br label %if.end.29
if.else.28:
  br label %if.end.29
if.end.29:
  %a456 = ptrtoint ptr %s.2 to i64
  %p457 = inttoptr i64 %a456 to ptr
  %v458 = load i64, ptr %p457
  %a459 = ptrtoint ptr %s.2 to i64
  %p460 = inttoptr i64 %a459 to ptr
  %v461 = load i64, ptr %p460
  %t462 = add i64 %v461, 1
  %p463 = inttoptr i64 %a456 to ptr
  store i64 %t462, ptr %p463
  br label %wh.cond.21
wh.end.23:
  %a464 = ptrtoint ptr @.str.8 to i64
  %a465 = ptrtoint ptr %s.5 to i64
  %p466 = inttoptr i64 %a465 to ptr
  %v467 = load i64, ptr %p466
  %a468 = ptrtoint ptr %s.6 to i64
  %p469 = inttoptr i64 %a468 to ptr
  %v470 = load i64, ptr %p469
  %a471 = ptrtoint ptr %s.7 to i64
  %p472 = inttoptr i64 %a471 to ptr
  %v473 = load i64, ptr %p472
  %p474 = inttoptr i64 %a464 to ptr
  %r475 = call i32 (ptr, ...) @printf(ptr %p474, i64 %v467, i64 %v470, i64 %v473)
  %v476 = sext i32 %r475 to i64
  %a477 = ptrtoint ptr %s.0 to i64
  %p478 = inttoptr i64 %a477 to ptr
  %v479 = load i64, ptr %p478
  %p480 = inttoptr i64 %v479 to ptr
  call void @free(ptr %p480)
  %rv481 = trunc i64 0 to i32
  ret i32 %rv481
}

