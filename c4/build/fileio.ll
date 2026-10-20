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

@.str.1 = private unnamed_addr constant [23 x i8] c"usage: fileio src dst\0a\00"
@.str.2 = private unnamed_addr constant [17 x i8] c"open failed: %s\0a\00"
@.str.3 = private unnamed_addr constant [18 x i8] c"creat failed: %s\0a\00"
@.str.4 = private unnamed_addr constant [17 x i8] c"copied %d bytes\0a\00"

define i32 @main(i32 %.argc, ptr %.argv) {
entry:
  %s.0 = alloca i64
  %ac1 = sext i32 %.argc to i64
  store i64 %ac1, ptr %s.0
  %s.1 = alloca i64
  %av2 = ptrtoint ptr %.argv to i64
  store i64 %av2, ptr %s.1
  %s.2 = alloca i64
  %s.3 = alloca i64
  %s.4 = alloca i64
  %s.5 = alloca i64
  %s.6 = alloca i64
  %a3 = ptrtoint ptr %s.0 to i64
  %p4 = inttoptr i64 %a3 to ptr
  %v5 = load i64, ptr %p4
  %c6 = icmp slt i64 %v5, 3
  %b7 = zext i1 %c6 to i64
  %c8 = icmp ne i64 %b7, 0
  br i1 %c8, label %if.then.1, label %if.else.2
if.then.1:
  %a9 = ptrtoint ptr @.str.1 to i64
  %p10 = inttoptr i64 %a9 to ptr
  %r11 = call i32 (ptr, ...) @printf(ptr %p10)
  %v12 = sext i32 %r11 to i64
  %rv13 = trunc i64 1 to i32
  ret i32 %rv13
if.else.2:
  br label %if.end.3
if.end.3:
  %a14 = ptrtoint ptr %s.2 to i64
  %p15 = inttoptr i64 %a14 to ptr
  %v16 = load i64, ptr %p15
  %a17 = ptrtoint ptr %s.1 to i64
  %p18 = inttoptr i64 %a17 to ptr
  %v19 = load i64, ptr %p18
  %t20 = mul i64 1, 8
  %t21 = add i64 %v19, %t20
  %p22 = inttoptr i64 %t21 to ptr
  %v23 = load i64, ptr %p22
  %p24 = inttoptr i64 %v23 to ptr
  %w25 = trunc i64 0 to i32
  %r26 = call i32 @open(ptr %p24, i32 %w25)
  %v27 = sext i32 %r26 to i64
  %p28 = inttoptr i64 %a14 to ptr
  store i64 %v27, ptr %p28
  %a29 = ptrtoint ptr %s.2 to i64
  %p30 = inttoptr i64 %a29 to ptr
  %v31 = load i64, ptr %p30
  %c32 = icmp slt i64 %v31, 0
  %b33 = zext i1 %c32 to i64
  %c34 = icmp ne i64 %b33, 0
  br i1 %c34, label %if.then.4, label %if.else.5
if.then.4:
  %a35 = ptrtoint ptr @.str.2 to i64
  %a36 = ptrtoint ptr %s.1 to i64
  %p37 = inttoptr i64 %a36 to ptr
  %v38 = load i64, ptr %p37
  %t39 = mul i64 1, 8
  %t40 = add i64 %v38, %t39
  %p41 = inttoptr i64 %t40 to ptr
  %v42 = load i64, ptr %p41
  %p43 = inttoptr i64 %a35 to ptr
  %r44 = call i32 (ptr, ...) @printf(ptr %p43, i64 %v42)
  %v45 = sext i32 %r44 to i64
  %rv46 = trunc i64 2 to i32
  ret i32 %rv46
if.else.5:
  br label %if.end.6
if.end.6:
  %a47 = ptrtoint ptr %s.3 to i64
  %p48 = inttoptr i64 %a47 to ptr
  %v49 = load i64, ptr %p48
  %a50 = ptrtoint ptr %s.1 to i64
  %p51 = inttoptr i64 %a50 to ptr
  %v52 = load i64, ptr %p51
  %t53 = mul i64 2, 8
  %t54 = add i64 %v52, %t53
  %p55 = inttoptr i64 %t54 to ptr
  %v56 = load i64, ptr %p55
  %p57 = inttoptr i64 %v56 to ptr
  %w58 = trunc i64 438 to i32
  %r59 = call i32 @creat(ptr %p57, i32 %w58)
  %v60 = sext i32 %r59 to i64
  %p61 = inttoptr i64 %a47 to ptr
  store i64 %v60, ptr %p61
  %a62 = ptrtoint ptr %s.3 to i64
  %p63 = inttoptr i64 %a62 to ptr
  %v64 = load i64, ptr %p63
  %c65 = icmp slt i64 %v64, 0
  %b66 = zext i1 %c65 to i64
  %c67 = icmp ne i64 %b66, 0
  br i1 %c67, label %if.then.7, label %if.else.8
if.then.7:
  %a68 = ptrtoint ptr @.str.3 to i64
  %a69 = ptrtoint ptr %s.1 to i64
  %p70 = inttoptr i64 %a69 to ptr
  %v71 = load i64, ptr %p70
  %t72 = mul i64 2, 8
  %t73 = add i64 %v71, %t72
  %p74 = inttoptr i64 %t73 to ptr
  %v75 = load i64, ptr %p74
  %p76 = inttoptr i64 %a68 to ptr
  %r77 = call i32 (ptr, ...) @printf(ptr %p76, i64 %v75)
  %v78 = sext i32 %r77 to i64
  %rv79 = trunc i64 3 to i32
  ret i32 %rv79
if.else.8:
  br label %if.end.9
if.end.9:
  %a80 = ptrtoint ptr %s.4 to i64
  %p81 = inttoptr i64 %a80 to ptr
  %v82 = load i64, ptr %p81
  %r83 = call ptr @malloc(i64 4096)
  %a84 = ptrtoint ptr %r83 to i64
  %p85 = inttoptr i64 %a80 to ptr
  store i64 %a84, ptr %p85
  %a86 = ptrtoint ptr %s.6 to i64
  %p87 = inttoptr i64 %a86 to ptr
  %v88 = load i64, ptr %p87
  %p89 = inttoptr i64 %a86 to ptr
  store i64 0, ptr %p89
  %a90 = ptrtoint ptr %s.5 to i64
  %p91 = inttoptr i64 %a90 to ptr
  %v92 = load i64, ptr %p91
  %a93 = ptrtoint ptr %s.2 to i64
  %p94 = inttoptr i64 %a93 to ptr
  %v95 = load i64, ptr %p94
  %a96 = ptrtoint ptr %s.4 to i64
  %p97 = inttoptr i64 %a96 to ptr
  %v98 = load i64, ptr %p97
  %w99 = trunc i64 %v95 to i32
  %p100 = inttoptr i64 %v98 to ptr
  %r101 = call i64 @read(i32 %w99, ptr %p100, i64 4096)
  %p102 = inttoptr i64 %a90 to ptr
  store i64 %r101, ptr %p102
  br label %wh.cond.10
wh.cond.10:
  %a103 = ptrtoint ptr %s.5 to i64
  %p104 = inttoptr i64 %a103 to ptr
  %v105 = load i64, ptr %p104
  %c106 = icmp sgt i64 %v105, 0
  %b107 = zext i1 %c106 to i64
  %c108 = icmp ne i64 %b107, 0
  br i1 %c108, label %wh.body.11, label %wh.end.12
wh.body.11:
  %a109 = ptrtoint ptr %s.3 to i64
  %p110 = inttoptr i64 %a109 to ptr
  %v111 = load i64, ptr %p110
  %a112 = ptrtoint ptr %s.4 to i64
  %p113 = inttoptr i64 %a112 to ptr
  %v114 = load i64, ptr %p113
  %a115 = ptrtoint ptr %s.5 to i64
  %p116 = inttoptr i64 %a115 to ptr
  %v117 = load i64, ptr %p116
  %w118 = trunc i64 %v111 to i32
  %p119 = inttoptr i64 %v114 to ptr
  %r120 = call i64 @write(i32 %w118, ptr %p119, i64 %v117)
  %a121 = ptrtoint ptr %s.6 to i64
  %p122 = inttoptr i64 %a121 to ptr
  %v123 = load i64, ptr %p122
  %a124 = ptrtoint ptr %s.6 to i64
  %p125 = inttoptr i64 %a124 to ptr
  %v126 = load i64, ptr %p125
  %a127 = ptrtoint ptr %s.5 to i64
  %p128 = inttoptr i64 %a127 to ptr
  %v129 = load i64, ptr %p128
  %t130 = add i64 %v126, %v129
  %p131 = inttoptr i64 %a121 to ptr
  store i64 %t130, ptr %p131
  %a132 = ptrtoint ptr %s.5 to i64
  %p133 = inttoptr i64 %a132 to ptr
  %v134 = load i64, ptr %p133
  %a135 = ptrtoint ptr %s.2 to i64
  %p136 = inttoptr i64 %a135 to ptr
  %v137 = load i64, ptr %p136
  %a138 = ptrtoint ptr %s.4 to i64
  %p139 = inttoptr i64 %a138 to ptr
  %v140 = load i64, ptr %p139
  %w141 = trunc i64 %v137 to i32
  %p142 = inttoptr i64 %v140 to ptr
  %r143 = call i64 @read(i32 %w141, ptr %p142, i64 4096)
  %p144 = inttoptr i64 %a132 to ptr
  store i64 %r143, ptr %p144
  br label %wh.cond.10
wh.end.12:
  %a145 = ptrtoint ptr %s.2 to i64
  %p146 = inttoptr i64 %a145 to ptr
  %v147 = load i64, ptr %p146
  %w148 = trunc i64 %v147 to i32
  %r149 = call i32 @close(i32 %w148)
  %v150 = sext i32 %r149 to i64
  %a151 = ptrtoint ptr %s.3 to i64
  %p152 = inttoptr i64 %a151 to ptr
  %v153 = load i64, ptr %p152
  %w154 = trunc i64 %v153 to i32
  %r155 = call i32 @close(i32 %w154)
  %v156 = sext i32 %r155 to i64
  %a157 = ptrtoint ptr %s.4 to i64
  %p158 = inttoptr i64 %a157 to ptr
  %v159 = load i64, ptr %p158
  %p160 = inttoptr i64 %v159 to ptr
  call void @free(ptr %p160)
  %a161 = ptrtoint ptr @.str.4 to i64
  %a162 = ptrtoint ptr %s.6 to i64
  %p163 = inttoptr i64 %a162 to ptr
  %v164 = load i64, ptr %p163
  %p165 = inttoptr i64 %a161 to ptr
  %r166 = call i32 (ptr, ...) @printf(ptr %p165, i64 %v164)
  %v167 = sext i32 %r166 to i64
  %rv168 = trunc i64 0 to i32
  ret i32 %rv168
}

