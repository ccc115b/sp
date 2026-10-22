; ModuleID = 'rt.c'
source_filename = "rt.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.2.0"

%struct.BEnt = type { ptr, ptr }
%struct.Obj = type { i64 }
%struct.BoolO = type { i64, i64 }
%struct._RuneLocale = type { [8 x i8], [32 x i8], ptr, ptr, i32, [256 x i32], [256 x i32], [256 x i32], %struct._RuneRange, %struct._RuneRange, %struct._RuneRange, ptr, i32, i32, ptr }
%struct._RuneRange = type { i32, ptr }
%struct.Ent = type { i64, i64, i64 }
%struct.SB = type { ptr, i64, i64 }

@rt_eq_i.k_eq = internal unnamed_addr global i64 0, align 8
@.str = private unnamed_addr constant [7 x i8] c"__eq__\00", align 1
@__stdoutp = external local_unnamed_addr global ptr, align 8
@__stderrp = external local_unnamed_addr global ptr, align 8
@.str.1 = private unnamed_addr constant [50 x i8] c"TypeError: exceptions must derive from Exception\0A\00", align 1
@cur_exc = internal unnamed_addr global i64 0, align 8
@nh = internal unnamed_addr global i64 0, align 8
@jbs = internal global [1024 x [48 x i32]] zeroinitializer, align 4
@.str.2 = private unnamed_addr constant [54 x i8] c"Traceback (most recent call last):\0A  <compiled code>\0A\00", align 1
@.str.3 = private unnamed_addr constant [8 x i8] c"%s: %s\0A\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.5 = private unnamed_addr constant [28 x i8] c"too many nested try blocks\0A\00", align 1
@.str.6 = private unnamed_addr constant [15 x i8] c"AssertionError\00", align 1
@rt_none_v = local_unnamed_addr global i64 0, align 8
@K_args = internal unnamed_addr global i64 0, align 8
@K_len = internal unnamed_addr global i64 0, align 8
@.str.7 = private unnamed_addr constant [14 x i8] c"OverflowError\00", align 1
@.str.8 = private unnamed_addr constant [17 x i8] c"integer overflow\00", align 1
@.str.9 = private unnamed_addr constant [2 x i8] c"+\00", align 1
@.str.10 = private unnamed_addr constant [2 x i8] c"-\00", align 1
@.str.11 = private unnamed_addr constant [2 x i8] c"*\00", align 1
@.str.12 = private unnamed_addr constant [2 x i8] c"/\00", align 1
@.str.13 = private unnamed_addr constant [18 x i8] c"ZeroDivisionError\00", align 1
@.str.14 = private unnamed_addr constant [17 x i8] c"division by zero\00", align 1
@.str.15 = private unnamed_addr constant [3 x i8] c"//\00", align 1
@.str.16 = private unnamed_addr constant [35 x i8] c"integer division or modulo by zero\00", align 1
@.str.17 = private unnamed_addr constant [29 x i8] c"float floor division by zero\00", align 1
@.str.18 = private unnamed_addr constant [2 x i8] c"%\00", align 1
@.str.19 = private unnamed_addr constant [13 x i8] c"float modulo\00", align 1
@.str.20 = private unnamed_addr constant [3 x i8] c"**\00", align 1
@.str.21 = private unnamed_addr constant [2 x i8] c"&\00", align 1
@.str.22 = private unnamed_addr constant [2 x i8] c"|\00", align 1
@.str.23 = private unnamed_addr constant [2 x i8] c"^\00", align 1
@.str.24 = private unnamed_addr constant [3 x i8] c"<<\00", align 1
@.str.25 = private unnamed_addr constant [11 x i8] c"ValueError\00", align 1
@.str.26 = private unnamed_addr constant [21 x i8] c"negative shift count\00", align 1
@.str.27 = private unnamed_addr constant [3 x i8] c">>\00", align 1
@.str.28 = private unnamed_addr constant [10 x i8] c"TypeError\00", align 1
@.str.29 = private unnamed_addr constant [35 x i8] c"bad operand type for unary -: '%s'\00", align 1
@.str.30 = private unnamed_addr constant [29 x i8] c"bad operand type for unary ~\00", align 1
@.str.31 = private unnamed_addr constant [50 x i8] c"%s() missing %lld required positional argument(s)\00", align 1
@.str.32 = private unnamed_addr constant [59 x i8] c"%s() takes %lld positional argument(s) but %lld were given\00", align 1
@K_init = internal unnamed_addr global i64 0, align 8
@.str.33 = private unnamed_addr constant [24 x i8] c"%s() takes no arguments\00", align 1
@.str.34 = private unnamed_addr constant [28 x i8] c"'%s' object is not callable\00", align 1
@.str.35 = private unnamed_addr constant [54 x i8] c"not enough values to unpack (expected %lld, got %lld)\00", align 1
@.str.36 = private unnamed_addr constant [42 x i8] c"too many values to unpack (expected %lld)\00", align 1
@.str.37 = private unnamed_addr constant [33 x i8] c"'%s' object is not subscriptable\00", align 1
@.str.38 = private unnamed_addr constant [5 x i8] c"list\00", align 1
@.str.39 = private unnamed_addr constant [6 x i8] c"tuple\00", align 1
@.str.40 = private unnamed_addr constant [7 x i8] c"string\00", align 1
@.str.41 = private unnamed_addr constant [9 x i8] c"KeyError\00", align 1
@.str.42 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@K_getitem = internal unnamed_addr global i64 0, align 8
@.str.43 = private unnamed_addr constant [16 x i8] c"list assignment\00", align 1
@K_setitem = internal unnamed_addr global i64 0, align 8
@.str.44 = private unnamed_addr constant [45 x i8] c"'%s' object does not support item assignment\00", align 1
@.str.45 = private unnamed_addr constant [42 x i8] c"'%s' object doesn't support item deletion\00", align 1
@.str.46 = private unnamed_addr constant [18 x i8] c"math domain error\00", align 1
@.str.47 = private unnamed_addr constant [4 x i8] c"sys\00", align 1
@.str.48 = private unnamed_addr constant [5 x i8] c"math\00", align 1
@.str.50 = private unnamed_addr constant [12 x i8] c"ImportError\00", align 1
@.str.51 = private unnamed_addr constant [21 x i8] c"No module named '%s'\00", align 1
@.str.52 = private unnamed_addr constant [10 x i8] c"__class__\00", align 1
@.str.53 = private unnamed_addr constant [9 x i8] c"__name__\00", align 1
@.str.54 = private unnamed_addr constant [15 x i8] c"AttributeError\00", align 1
@.str.55 = private unnamed_addr constant [34 x i8] c"'%s' object has no attribute '%s'\00", align 1
@.str.56 = private unnamed_addr constant [5 x i8] c"<>^=\00", align 1
@.str.58 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.59 = private unnamed_addr constant [5 x i8] c"%llx\00", align 1
@.str.60 = private unnamed_addr constant [5 x i8] c"%llX\00", align 1
@.str.61 = private unnamed_addr constant [5 x i8] c"%llo\00", align 1
@.str.62 = private unnamed_addr constant [8 x i8] c"fFeEgG%\00", align 1
@.str.63 = private unnamed_addr constant [7 x i8] c"%.*f%%\00", align 1
@.str.64 = private unnamed_addr constant [7 x i8] c"%%.*%c\00", align 1
@.str.65 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.66 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.67 = private unnamed_addr constant [2 x i8] c"r\00", align 1
@.str.68 = private unnamed_addr constant [18 x i8] c"FileNotFoundError\00", align 1
@.str.69 = private unnamed_addr constant [42 x i8] c"[Errno 2] No such file or directory: '%s'\00", align 1
@__stdinp = external local_unnamed_addr global ptr, align 8
@.str.70 = private unnamed_addr constant [9 x i8] c"EOFError\00", align 1
@.str.71 = private unnamed_addr constant [24 x i8] c"EOF when reading a line\00", align 1
@.str.72 = private unnamed_addr constant [33 x i8] c"object of type '%s' has no len()\00", align 1
@.str.73 = private unnamed_addr constant [31 x i8] c"range() arg 3 must not be zero\00", align 1
@.str.74 = private unnamed_addr constant [32 x i8] c"cannot convert float to integer\00", align 1
@.str.75 = private unnamed_addr constant [43 x i8] c"invalid literal for int() with base %d: %s\00", align 1
@.str.76 = private unnamed_addr constant [54 x i8] c"int() argument must be a string or a number, not '%s'\00", align 1
@.str.77 = private unnamed_addr constant [38 x i8] c"could not convert string to float: %s\00", align 1
@.str.78 = private unnamed_addr constant [46 x i8] c"float() argument must be a string or a number\00", align 1
@.str.79 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@rt_false_v = local_unnamed_addr global i64 0, align 8
@.str.80 = private unnamed_addr constant [52 x i8] c"dictionary update sequence element has wrong length\00", align 1
@.str.81 = private unnamed_addr constant [27 x i8] c"bad operand type for abs()\00", align 1
@.str.82 = private unnamed_addr constant [5 x i8] c"%.*f\00", align 1
@rt_true_v = local_unnamed_addr global i64 0, align 8
@.str.83 = private unnamed_addr constant [27 x i8] c"ord() expected a character\00", align 1
@.str.87 = private unnamed_addr constant [6 x i8] c"close\00", align 1
@btab = internal unnamed_addr constant [42 x %struct.BEnt] [%struct.BEnt { ptr @.str.263, ptr @b_len }, %struct.BEnt { ptr @.str.264, ptr @b_range }, %struct.BEnt { ptr @.str.133, ptr @b_int }, %struct.BEnt { ptr @.str.136, ptr @b_float }, %struct.BEnt { ptr @.str.137, ptr @b_str }, %struct.BEnt { ptr @.str.135, ptr @b_bool }, %struct.BEnt { ptr @.str.38, ptr @b_list }, %struct.BEnt { ptr @.str.39, ptr @b_tuple }, %struct.BEnt { ptr @.str.138, ptr @b_dict }, %struct.BEnt { ptr @.str.139, ptr @b_set }, %struct.BEnt { ptr @.str.265, ptr @b_isinstance }, %struct.BEnt { ptr @.str.266, ptr @b_abs }, %struct.BEnt { ptr @.str.267, ptr @b_min }, %struct.BEnt { ptr @.str.268, ptr @b_max }, %struct.BEnt { ptr @.str.269, ptr @b_sum }, %struct.BEnt { ptr @.str.270, ptr @b_round }, %struct.BEnt { ptr @.str.271, ptr @b_sorted }, %struct.BEnt { ptr @.str.272, ptr @b_reversed }, %struct.BEnt { ptr @.str.273, ptr @b_enumerate }, %struct.BEnt { ptr @.str.274, ptr @b_zip }, %struct.BEnt { ptr @.str.275, ptr @b_map }, %struct.BEnt { ptr @.str.276, ptr @b_filter }, %struct.BEnt { ptr @.str.277, ptr @b_any }, %struct.BEnt { ptr @.str.278, ptr @b_all }, %struct.BEnt { ptr @.str.279, ptr @b_chr }, %struct.BEnt { ptr @.str.280, ptr @b_ord }, %struct.BEnt { ptr @.str.281, ptr @b_hex }, %struct.BEnt { ptr @.str.282, ptr @b_bin }, %struct.BEnt { ptr @.str.283, ptr @b_oct }, %struct.BEnt { ptr @.str.284, ptr @b_repr }, %struct.BEnt { ptr @.str.285, ptr @b_open }, %struct.BEnt { ptr @.str.286, ptr @b_input }, %struct.BEnt { ptr @.str.158, ptr @b_exit }, %struct.BEnt { ptr @.str.287, ptr @b_exit }, %struct.BEnt { ptr @.str.288, ptr @b_divmod }, %struct.BEnt { ptr @.str.289, ptr @b_pow }, %struct.BEnt { ptr @.str.290, ptr @b_hasattr }, %struct.BEnt { ptr @.str.291, ptr @b_getattr }, %struct.BEnt { ptr @.str.292, ptr @b_setattr }, %struct.BEnt { ptr @.str.293, ptr @b_callable }, %struct.BEnt { ptr @.str.294, ptr @b_print }, %struct.BEnt zeroinitializer], align 8
@nexc = internal unnamed_addr global i32 0, align 4
@exc_nm = internal unnamed_addr global [40 x ptr] zeroinitializer, align 8
@exc_cls = internal unnamed_addr global [40 x i64] zeroinitializer, align 8
@.str.88 = private unnamed_addr constant [10 x i8] c"NameError\00", align 1
@.str.89 = private unnamed_addr constant [25 x i8] c"name '%s' is not defined\00", align 1
@none_o = internal global %struct.Obj { i64 1 }, align 8
@true_o = internal global %struct.BoolO { i64 2, i64 1 }, align 8
@false_o = internal global %struct.BoolO { i64 2, i64 0 }, align 8
@.str.90 = private unnamed_addr constant [5 x i8] c"args\00", align 1
@.str.91 = private unnamed_addr constant [9 x i8] c"__init__\00", align 1
@.str.92 = private unnamed_addr constant [8 x i8] c"__str__\00", align 1
@K_str = internal unnamed_addr global i64 0, align 8
@.str.93 = private unnamed_addr constant [9 x i8] c"__repr__\00", align 1
@K_repr = internal unnamed_addr global i64 0, align 8
@.str.94 = private unnamed_addr constant [8 x i8] c"__len__\00", align 1
@.str.95 = private unnamed_addr constant [12 x i8] c"__getitem__\00", align 1
@.str.96 = private unnamed_addr constant [12 x i8] c"__setitem__\00", align 1
@.str.97 = private unnamed_addr constant [10 x i8] c"Exception\00", align 1
@.str.98 = private unnamed_addr constant [13 x i8] c"RuntimeError\00", align 1
@.str.99 = private unnamed_addr constant [14 x i8] c"StopIteration\00", align 1
@.str.100 = private unnamed_addr constant [8 x i8] c"OSError\00", align 1
@.str.101 = private unnamed_addr constant [16 x i8] c"ArithmeticError\00", align 1
@.str.102 = private unnamed_addr constant [12 x i8] c"LookupError\00", align 1
@.str.103 = private unnamed_addr constant [11 x i8] c"IndexError\00", align 1
@.str.104 = private unnamed_addr constant [20 x i8] c"NotImplementedError\00", align 1
@.str.105 = private unnamed_addr constant [8 x i8] c"IOError\00", align 1
@sys_stdout = internal unnamed_addr global i64 0, align 8
@sys_stderr = internal unnamed_addr global i64 0, align 8
@sys_stdin = internal unnamed_addr global i64 0, align 8
@sys_argv = internal unnamed_addr global i64 0, align 8
@char_cache = internal unnamed_addr global [256 x i64] zeroinitializer, align 8
@.str.106 = private unnamed_addr constant [15 x i8] c"out of memory\0A\00", align 1
@.str.107 = private unnamed_addr constant [23 x i8] c"an integer is required\00", align 1
@.str.108 = private unnamed_addr constant [21 x i8] c"a number is required\00", align 1
@.str.109 = private unnamed_addr constant [32 x i8] c"internal: unknown exception %s\0A\00", align 1
@.str.110 = private unnamed_addr constant [16 x i8] c"unhashable type\00", align 1
@.str.112 = private unnamed_addr constant [5 x i8] c"True\00", align 1
@.str.113 = private unnamed_addr constant [6 x i8] c"False\00", align 1
@.str.116 = private unnamed_addr constant [6 x i8] c"set()\00", align 1
@.str.117 = private unnamed_addr constant [11 x i8] c"<function \00", align 1
@.str.118 = private unnamed_addr constant [20 x i8] c"<built-in function \00", align 1
@.str.121 = private unnamed_addr constant [28 x i8] c"__str__ returned non-string\00", align 1
@.str.122 = private unnamed_addr constant [9 x i8] c" object>\00", align 1
@.str.123 = private unnamed_addr constant [15 x i8] c"<bound method>\00", align 1
@.str.124 = private unnamed_addr constant [7 x i8] c"<file>\00", align 1
@.str.130 = private unnamed_addr constant [7 x i8] c"\\x%02x\00", align 1
@.str.131 = private unnamed_addr constant [43 x i8] c"integer overflow (runtime ints are 63-bit)\00", align 1
@.str.132 = private unnamed_addr constant [50 x i8] c"unsupported operand type(s) for %s: '%s' and '%s'\00", align 1
@.str.133 = private unnamed_addr constant [4 x i8] c"int\00", align 1
@.str.134 = private unnamed_addr constant [9 x i8] c"NoneType\00", align 1
@.str.135 = private unnamed_addr constant [5 x i8] c"bool\00", align 1
@.str.136 = private unnamed_addr constant [6 x i8] c"float\00", align 1
@.str.137 = private unnamed_addr constant [4 x i8] c"str\00", align 1
@.str.138 = private unnamed_addr constant [5 x i8] c"dict\00", align 1
@.str.139 = private unnamed_addr constant [4 x i8] c"set\00", align 1
@.str.140 = private unnamed_addr constant [9 x i8] c"function\00", align 1
@.str.141 = private unnamed_addr constant [27 x i8] c"builtin_function_or_method\00", align 1
@.str.142 = private unnamed_addr constant [5 x i8] c"type\00", align 1
@.str.143 = private unnamed_addr constant [7 x i8] c"method\00", align 1
@.str.144 = private unnamed_addr constant [5 x i8] c"file\00", align 1
@.str.145 = private unnamed_addr constant [7 x i8] c"module\00", align 1
@.str.146 = private unnamed_addr constant [7 x i8] c"object\00", align 1
@cmp_v.k_lt = internal unnamed_addr global i64 0, align 8
@.str.147 = private unnamed_addr constant [7 x i8] c"__lt__\00", align 1
@.str.148 = private unnamed_addr constant [58 x i8] c"'<' not supported between instances of incompatible types\00", align 1
@.str.149 = private unnamed_addr constant [46 x i8] c"'in <string>' requires string as left operand\00", align 1
@.str.150 = private unnamed_addr constant [38 x i8] c"argument of type '%s' is not iterable\00", align 1
@.str.151 = private unnamed_addr constant [28 x i8] c"'%s' object is not iterable\00", align 1
@.str.152 = private unnamed_addr constant [26 x i8] c"slice step cannot be zero\00", align 1
@.str.153 = private unnamed_addr constant [22 x i8] c"%s index out of range\00", align 1
@.str.154 = private unnamed_addr constant [5 x i8] c"argv\00", align 1
@.str.155 = private unnamed_addr constant [7 x i8] c"stdout\00", align 1
@.str.156 = private unnamed_addr constant [7 x i8] c"stderr\00", align 1
@.str.157 = private unnamed_addr constant [6 x i8] c"stdin\00", align 1
@.str.158 = private unnamed_addr constant [5 x i8] c"exit\00", align 1
@.str.159 = private unnamed_addr constant [8 x i8] c"maxsize\00", align 1
@.str.162 = private unnamed_addr constant [5 x i8] c"sqrt\00", align 1
@.str.163 = private unnamed_addr constant [6 x i8] c"floor\00", align 1
@.str.164 = private unnamed_addr constant [5 x i8] c"ceil\00", align 1
@.str.165 = private unnamed_addr constant [4 x i8] c"sin\00", align 1
@.str.166 = private unnamed_addr constant [4 x i8] c"cos\00", align 1
@.str.167 = private unnamed_addr constant [4 x i8] c"tan\00", align 1
@.str.168 = private unnamed_addr constant [4 x i8] c"exp\00", align 1
@.str.169 = private unnamed_addr constant [5 x i8] c"fabs\00", align 1
@.str.170 = private unnamed_addr constant [4 x i8] c"log\00", align 1
@.str.171 = private unnamed_addr constant [29 x i8] c"module has no attribute '%s'\00", align 1
@.str.172 = private unnamed_addr constant [18 x i8] c"incomplete format\00", align 1
@.str.174 = private unnamed_addr constant [39 x i8] c"not enough arguments for format string\00", align 1
@.str.175 = private unnamed_addr constant [42 x i8] c"%%%c format: a number is required, not %s\00", align 1
@.str.176 = private unnamed_addr constant [16 x i8] c"%%%s%s%s%s%slld\00", align 1
@.str.177 = private unnamed_addr constant [12 x i8] c"%%%s%s ll%c\00", align 1
@.str.178 = private unnamed_addr constant [7 x i8] c"fFeEgG\00", align 1
@.str.179 = private unnamed_addr constant [11 x i8] c"%%%s%s%s%c\00", align 1
@.str.180 = private unnamed_addr constant [3 x i8] c".*\00", align 1
@.str.181 = private unnamed_addr constant [34 x i8] c"unsupported format character '%c'\00", align 1
@_DefaultRuneLocale = external local_unnamed_addr global %struct._RuneLocale, align 8
@.str.182 = private unnamed_addr constant [4 x i8] c"nan\00", align 1
@.str.183 = private unnamed_addr constant [5 x i8] c"-inf\00", align 1
@.str.184 = private unnamed_addr constant [4 x i8] c"inf\00", align 1
@.str.185 = private unnamed_addr constant [5 x i8] c"-0.0\00", align 1
@.str.186 = private unnamed_addr constant [4 x i8] c"0.0\00", align 1
@.str.187 = private unnamed_addr constant [5 x i8] c"%.*e\00", align 1
@.str.188 = private unnamed_addr constant [3 x i8] c".0\00", align 1
@.str.189 = private unnamed_addr constant [29 x i8] c"file argument must be a file\00", align 1
@.str.190 = private unnamed_addr constant [37 x i8] c"min()/max() arg is an empty sequence\00", align 1
@.str.191 = private unnamed_addr constant [5 x i8] c"join\00", align 1
@.str.192 = private unnamed_addr constant [52 x i8] c"sequence item %lld: expected str instance, %s found\00", align 1
@.str.193 = private unnamed_addr constant [6 x i8] c"split\00", align 1
@.str.194 = private unnamed_addr constant [16 x i8] c"empty separator\00", align 1
@.str.195 = private unnamed_addr constant [6 x i8] c"strip\00", align 1
@.str.196 = private unnamed_addr constant [7 x i8] c"lstrip\00", align 1
@.str.197 = private unnamed_addr constant [7 x i8] c"rstrip\00", align 1
@.str.198 = private unnamed_addr constant [7 x i8] c" \09\0A\0D\0B\0C\00", align 1
@.str.199 = private unnamed_addr constant [11 x i8] c"startswith\00", align 1
@.str.200 = private unnamed_addr constant [9 x i8] c"endswith\00", align 1
@.str.201 = private unnamed_addr constant [5 x i8] c"find\00", align 1
@.str.202 = private unnamed_addr constant [6 x i8] c"rfind\00", align 1
@.str.203 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.str.204 = private unnamed_addr constant [20 x i8] c"substring not found\00", align 1
@.str.205 = private unnamed_addr constant [6 x i8] c"count\00", align 1
@.str.206 = private unnamed_addr constant [8 x i8] c"replace\00", align 1
@.str.207 = private unnamed_addr constant [39 x i8] c"empty pattern in replace not supported\00", align 1
@.str.208 = private unnamed_addr constant [6 x i8] c"upper\00", align 1
@.str.209 = private unnamed_addr constant [6 x i8] c"lower\00", align 1
@.str.210 = private unnamed_addr constant [11 x i8] c"capitalize\00", align 1
@.str.211 = private unnamed_addr constant [8 x i8] c"isdigit\00", align 1
@.str.212 = private unnamed_addr constant [8 x i8] c"isalpha\00", align 1
@.str.213 = private unnamed_addr constant [8 x i8] c"isalnum\00", align 1
@.str.214 = private unnamed_addr constant [8 x i8] c"isspace\00", align 1
@.str.215 = private unnamed_addr constant [8 x i8] c"isupper\00", align 1
@.str.216 = private unnamed_addr constant [8 x i8] c"islower\00", align 1
@.str.217 = private unnamed_addr constant [6 x i8] c"ljust\00", align 1
@.str.218 = private unnamed_addr constant [6 x i8] c"rjust\00", align 1
@.str.219 = private unnamed_addr constant [7 x i8] c"center\00", align 1
@.str.220 = private unnamed_addr constant [6 x i8] c"zfill\00", align 1
@.str.221 = private unnamed_addr constant [11 x i8] c"splitlines\00", align 1
@.str.222 = private unnamed_addr constant [7 x i8] c"encode\00", align 1
@.str.223 = private unnamed_addr constant [7 x i8] c"decode\00", align 1
@.str.224 = private unnamed_addr constant [7 x i8] c"format\00", align 1
@.str.225 = private unnamed_addr constant [35 x i8] c"'str' object has no attribute '%s'\00", align 1
@.str.226 = private unnamed_addr constant [40 x i8] c"Single '{' encountered in format string\00", align 1
@.str.227 = private unnamed_addr constant [36 x i8] c"Replacement index %lld out of range\00", align 1
@.str.228 = private unnamed_addr constant [7 x i8] c"append\00", align 1
@.str.229 = private unnamed_addr constant [7 x i8] c"extend\00", align 1
@.str.230 = private unnamed_addr constant [4 x i8] c"pop\00", align 1
@.str.231 = private unnamed_addr constant [20 x i8] c"pop from empty list\00", align 1
@.str.232 = private unnamed_addr constant [7 x i8] c"insert\00", align 1
@.str.233 = private unnamed_addr constant [7 x i8] c"remove\00", align 1
@.str.234 = private unnamed_addr constant [30 x i8] c"list.remove(x): x not in list\00", align 1
@.str.235 = private unnamed_addr constant [21 x i8] c"value is not in list\00", align 1
@.str.236 = private unnamed_addr constant [8 x i8] c"reverse\00", align 1
@.str.237 = private unnamed_addr constant [5 x i8] c"sort\00", align 1
@.str.238 = private unnamed_addr constant [5 x i8] c"copy\00", align 1
@.str.239 = private unnamed_addr constant [6 x i8] c"clear\00", align 1
@.str.240 = private unnamed_addr constant [36 x i8] c"'list' object has no attribute '%s'\00", align 1
@.str.241 = private unnamed_addr constant [31 x i8] c"tuple.index(x): x not in tuple\00", align 1
@.str.242 = private unnamed_addr constant [37 x i8] c"'tuple' object has no attribute '%s'\00", align 1
@.str.243 = private unnamed_addr constant [4 x i8] c"get\00", align 1
@.str.244 = private unnamed_addr constant [5 x i8] c"keys\00", align 1
@.str.245 = private unnamed_addr constant [7 x i8] c"values\00", align 1
@.str.246 = private unnamed_addr constant [6 x i8] c"items\00", align 1
@.str.247 = private unnamed_addr constant [11 x i8] c"setdefault\00", align 1
@.str.248 = private unnamed_addr constant [7 x i8] c"update\00", align 1
@.str.249 = private unnamed_addr constant [36 x i8] c"'dict' object has no attribute '%s'\00", align 1
@.str.250 = private unnamed_addr constant [4 x i8] c"add\00", align 1
@.str.251 = private unnamed_addr constant [8 x i8] c"discard\00", align 1
@.str.252 = private unnamed_addr constant [6 x i8] c"union\00", align 1
@.str.253 = private unnamed_addr constant [13 x i8] c"intersection\00", align 1
@.str.254 = private unnamed_addr constant [11 x i8] c"difference\00", align 1
@.str.255 = private unnamed_addr constant [35 x i8] c"'set' object has no attribute '%s'\00", align 1
@.str.256 = private unnamed_addr constant [5 x i8] c"read\00", align 1
@.str.257 = private unnamed_addr constant [9 x i8] c"readline\00", align 1
@.str.258 = private unnamed_addr constant [10 x i8] c"readlines\00", align 1
@.str.259 = private unnamed_addr constant [6 x i8] c"write\00", align 1
@.str.260 = private unnamed_addr constant [29 x i8] c"write() argument must be str\00", align 1
@.str.261 = private unnamed_addr constant [6 x i8] c"flush\00", align 1
@.str.262 = private unnamed_addr constant [36 x i8] c"'file' object has no attribute '%s'\00", align 1
@.str.263 = private unnamed_addr constant [4 x i8] c"len\00", align 1
@.str.264 = private unnamed_addr constant [6 x i8] c"range\00", align 1
@.str.265 = private unnamed_addr constant [11 x i8] c"isinstance\00", align 1
@.str.266 = private unnamed_addr constant [4 x i8] c"abs\00", align 1
@.str.267 = private unnamed_addr constant [4 x i8] c"min\00", align 1
@.str.268 = private unnamed_addr constant [4 x i8] c"max\00", align 1
@.str.269 = private unnamed_addr constant [4 x i8] c"sum\00", align 1
@.str.270 = private unnamed_addr constant [6 x i8] c"round\00", align 1
@.str.271 = private unnamed_addr constant [7 x i8] c"sorted\00", align 1
@.str.272 = private unnamed_addr constant [9 x i8] c"reversed\00", align 1
@.str.273 = private unnamed_addr constant [10 x i8] c"enumerate\00", align 1
@.str.274 = private unnamed_addr constant [4 x i8] c"zip\00", align 1
@.str.275 = private unnamed_addr constant [4 x i8] c"map\00", align 1
@.str.276 = private unnamed_addr constant [7 x i8] c"filter\00", align 1
@.str.277 = private unnamed_addr constant [4 x i8] c"any\00", align 1
@.str.278 = private unnamed_addr constant [4 x i8] c"all\00", align 1
@.str.279 = private unnamed_addr constant [4 x i8] c"chr\00", align 1
@.str.280 = private unnamed_addr constant [4 x i8] c"ord\00", align 1
@.str.281 = private unnamed_addr constant [4 x i8] c"hex\00", align 1
@.str.282 = private unnamed_addr constant [4 x i8] c"bin\00", align 1
@.str.283 = private unnamed_addr constant [4 x i8] c"oct\00", align 1
@.str.284 = private unnamed_addr constant [5 x i8] c"repr\00", align 1
@.str.285 = private unnamed_addr constant [5 x i8] c"open\00", align 1
@.str.286 = private unnamed_addr constant [6 x i8] c"input\00", align 1
@.str.287 = private unnamed_addr constant [5 x i8] c"quit\00", align 1
@.str.288 = private unnamed_addr constant [7 x i8] c"divmod\00", align 1
@.str.289 = private unnamed_addr constant [4 x i8] c"pow\00", align 1
@.str.290 = private unnamed_addr constant [8 x i8] c"hasattr\00", align 1
@.str.291 = private unnamed_addr constant [8 x i8] c"getattr\00", align 1
@.str.292 = private unnamed_addr constant [8 x i8] c"setattr\00", align 1
@.str.293 = private unnamed_addr constant [9 x i8] c"callable\00", align 1
@.str.294 = private unnamed_addr constant [6 x i8] c"print\00", align 1

; Function Attrs: nofree nounwind ssp uwtable(sync)
define i64 @rt_mkstr(ptr noundef readonly captures(none) %0, i64 noundef %1) local_unnamed_addr #0 {
  %3 = tail call fastcc i64 @mkstr(ptr noundef %0, i64 noundef %1)
  ret i64 %3
}

; Function Attrs: nofree nounwind ssp uwtable(sync)
define internal fastcc i64 @mkstr(ptr noundef readonly captures(none) %0, i64 noundef %1) unnamed_addr #0 {
  %3 = icmp eq i64 %1, 1
  br i1 %3, label %4, label %10

4:                                                ; preds = %2
  %5 = load i8, ptr %0, align 1, !tbaa !10
  %6 = zext i8 %5 to i64
  %7 = getelementptr inbounds nuw i64, ptr @char_cache, i64 %6
  %8 = load i64, ptr %7, align 8, !tbaa !11
  %9 = icmp eq i64 %8, 0
  br i1 %9, label %10, label %27

10:                                               ; preds = %4, %2
  %11 = add i64 %1, 25
  %12 = tail call i64 @llvm.umax.i64(i64 %11, i64 1)
  %13 = tail call ptr @calloc(i64 noundef 1, i64 noundef %12) #33
  %14 = icmp eq ptr %13, null
  br i1 %14, label %15, label %18

15:                                               ; preds = %10
  %16 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %17 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %16)
  tail call void @exit(i32 noundef 1) #34
  unreachable

18:                                               ; preds = %10
  store i64 4, ptr %13, align 8, !tbaa !16
  %19 = getelementptr inbounds nuw i8, ptr %13, i64 8
  store i64 %1, ptr %19, align 8, !tbaa !18
  %20 = getelementptr inbounds nuw i8, ptr %13, i64 16
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 %20, ptr noundef align 1 %0, i64 noundef %1, i1 noundef false) #35
  %21 = getelementptr inbounds i8, ptr %20, i64 %1
  store i8 0, ptr %21, align 1, !tbaa !10
  %22 = ptrtoint ptr %13 to i64
  br i1 %3, label %23, label %27

23:                                               ; preds = %18
  %24 = load i8, ptr %0, align 1, !tbaa !10
  %25 = zext i8 %24 to i64
  %26 = getelementptr inbounds nuw i64, ptr @char_cache, i64 %25
  store i64 %22, ptr %26, align 8, !tbaa !11
  br label %27

27:                                               ; preds = %18, %23, %4
  %28 = phi i64 [ %8, %4 ], [ %22, %23 ], [ %22, %18 ]
  ret i64 %28
}

; Function Attrs: nofree nounwind ssp uwtable(sync)
define noundef i64 @rt_mkfloat(double noundef %0) local_unnamed_addr #0 {
  %2 = tail call dereferenceable_or_null(16) ptr @calloc(i64 noundef 1, i64 noundef 16) #33
  %3 = icmp eq ptr %2, null
  br i1 %3, label %4, label %7

4:                                                ; preds = %1
  %5 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %6 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %5)
  tail call void @exit(i32 noundef 1) #34
  unreachable

7:                                                ; preds = %1
  store i64 3, ptr %2, align 8, !tbaa !19
  %8 = getelementptr inbounds nuw i8, ptr %2, i64 8
  store double %0, ptr %8, align 8, !tbaa !22
  %9 = ptrtoint ptr %2 to i64
  ret i64 %9
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(ptr captures(none)) #1

; Function Attrs: nofree nounwind ssp uwtable(sync)
define internal fastcc noalias nonnull ptr @xmalloc(i64 noundef %0) unnamed_addr #0 {
  %2 = tail call i64 @llvm.umax.i64(i64 %0, i64 1)
  %3 = tail call ptr @calloc(i64 noundef 1, i64 noundef %2) #33
  %4 = icmp eq ptr %3, null
  br i1 %4, label %5, label %8

5:                                                ; preds = %1
  %6 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %7 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %6)
  tail call void @exit(i32 noundef 1) #34
  unreachable

8:                                                ; preds = %1
  ret ptr %3
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(ptr captures(none)) #1

; Function Attrs: nounwind ssp uwtable(sync)
define noundef i64 @rt_mkfloat_cstr(ptr noundef %0) local_unnamed_addr #2 {
  %2 = tail call double @"\01_strtod"(ptr noundef %0, ptr noundef null) #35
  %3 = tail call dereferenceable_or_null(16) ptr @calloc(i64 noundef 1, i64 noundef 16) #33
  %4 = icmp eq ptr %3, null
  br i1 %4, label %5, label %8

5:                                                ; preds = %1
  %6 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %7 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %6)
  tail call void @exit(i32 noundef 1) #34
  unreachable

8:                                                ; preds = %1
  store i64 3, ptr %3, align 8, !tbaa !19
  %9 = getelementptr inbounds nuw i8, ptr %3, i64 8
  store double %2, ptr %9, align 8, !tbaa !22
  %10 = ptrtoint ptr %3 to i64
  ret i64 %10
}

declare double @"\01_strtod"(ptr noundef, ptr noundef) local_unnamed_addr #3

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_eq_i(i64 noundef %0, i64 noundef %1) local_unnamed_addr #2 {
  %3 = alloca [2 x i64], align 8
  %4 = icmp eq i64 %0, %1
  br i1 %4, label %330, label %5

5:                                                ; preds = %2
  %6 = and i64 %0, 1
  %7 = icmp eq i64 %6, 0
  br i1 %7, label %8, label %13

8:                                                ; preds = %5
  %9 = icmp eq i64 %0, 0
  br i1 %9, label %13, label %10

10:                                               ; preds = %8
  %11 = inttoptr i64 %0 to ptr
  %12 = load i64, ptr %11, align 8, !tbaa !23
  br label %13

13:                                               ; preds = %5, %8, %10
  %14 = phi i64 [ 0, %5 ], [ %12, %10 ], [ -1, %8 ]
  %15 = and i64 %1, 1
  %16 = icmp eq i64 %15, 0
  br i1 %16, label %17, label %22

17:                                               ; preds = %13
  %18 = icmp eq i64 %1, 0
  br i1 %18, label %22, label %19

19:                                               ; preds = %17
  %20 = inttoptr i64 %1 to ptr
  %21 = load i64, ptr %20, align 8, !tbaa !23
  br label %22

22:                                               ; preds = %13, %17, %19
  %23 = phi i64 [ 0, %13 ], [ %21, %19 ], [ -1, %17 ]
  br i1 %7, label %24, label %29

24:                                               ; preds = %22
  %25 = icmp eq i64 %0, 0
  br i1 %25, label %125, label %26

26:                                               ; preds = %24
  %27 = inttoptr i64 %0 to ptr
  %28 = load i64, ptr %27, align 8, !tbaa !23
  switch i64 %28, label %125 [
    i64 2, label %29
    i64 3, label %70
  ]

29:                                               ; preds = %26, %22
  br i1 %16, label %30, label %36

30:                                               ; preds = %29
  %31 = icmp eq i64 %1, 0
  br i1 %31, label %63, label %32

32:                                               ; preds = %30
  %33 = inttoptr i64 %1 to ptr
  %34 = load i64, ptr %33, align 8, !tbaa !23
  %35 = icmp eq i64 %34, 2
  br i1 %35, label %36, label %63

36:                                               ; preds = %29, %32
  br i1 %7, label %39, label %37

37:                                               ; preds = %36
  %38 = ashr i64 %0, 1
  br label %47

39:                                               ; preds = %36
  %40 = inttoptr i64 %0 to ptr
  %41 = load i64, ptr %40, align 8, !tbaa !23
  %42 = icmp eq i64 %41, 2
  br i1 %42, label %43, label %46

43:                                               ; preds = %39
  %44 = getelementptr inbounds nuw i8, ptr %40, i64 8
  %45 = load i64, ptr %44, align 8, !tbaa !25
  br label %47

46:                                               ; preds = %39
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

47:                                               ; preds = %37, %43
  %48 = phi i64 [ %38, %37 ], [ %45, %43 ]
  br i1 %16, label %51, label %49

49:                                               ; preds = %47
  %50 = ashr i64 %1, 1
  br label %59

51:                                               ; preds = %47
  %52 = inttoptr i64 %1 to ptr
  %53 = load i64, ptr %52, align 8, !tbaa !23
  %54 = icmp eq i64 %53, 2
  br i1 %54, label %55, label %58

55:                                               ; preds = %51
  %56 = getelementptr inbounds nuw i8, ptr %52, i64 8
  %57 = load i64, ptr %56, align 8, !tbaa !25
  br label %59

58:                                               ; preds = %51
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

59:                                               ; preds = %49, %55
  %60 = phi i64 [ %50, %49 ], [ %57, %55 ]
  %61 = icmp eq i64 %48, %60
  %62 = zext i1 %61 to i64
  br label %330

63:                                               ; preds = %30, %32
  br i1 %7, label %64, label %71

64:                                               ; preds = %63
  %65 = inttoptr i64 %0 to ptr
  %66 = load i64, ptr %65, align 8, !tbaa !23
  %67 = and i64 %66, -2
  %68 = icmp ne i64 %67, 2
  %69 = or i1 %31, %68
  br i1 %69, label %125, label %78

70:                                               ; preds = %26
  br i1 %16, label %71, label %103

71:                                               ; preds = %63, %70
  %72 = icmp eq i64 %1, 0
  br i1 %72, label %125, label %73

73:                                               ; preds = %71
  %74 = inttoptr i64 %1 to ptr
  %75 = load i64, ptr %74, align 8, !tbaa !23
  %76 = and i64 %75, -2
  %77 = icmp eq i64 %76, 2
  br i1 %77, label %83, label %125

78:                                               ; preds = %64
  %79 = inttoptr i64 %1 to ptr
  %80 = load i64, ptr %79, align 8, !tbaa !23
  %81 = and i64 %80, -2
  %82 = icmp eq i64 %81, 2
  br i1 %82, label %89, label %125

83:                                               ; preds = %73
  br i1 %7, label %84, label %86

84:                                               ; preds = %83
  %85 = inttoptr i64 %0 to ptr
  br label %89

86:                                               ; preds = %83
  %87 = ashr i64 %0, 1
  %88 = sitofp i64 %87 to double
  br label %108

89:                                               ; preds = %78, %84
  %90 = phi ptr [ %65, %78 ], [ %85, %84 ]
  %91 = load i64, ptr %90, align 8, !tbaa !23
  switch i64 %91, label %99 [
    i64 2, label %95
    i64 3, label %92
  ]

92:                                               ; preds = %89
  %93 = getelementptr inbounds nuw i8, ptr %90, i64 8
  %94 = load double, ptr %93, align 8, !tbaa !22
  br label %100

95:                                               ; preds = %89
  %96 = getelementptr inbounds nuw i8, ptr %90, i64 8
  %97 = load i64, ptr %96, align 8, !tbaa !25
  %98 = sitofp i64 %97 to double
  br label %100

99:                                               ; preds = %89
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.108) #36
  unreachable

100:                                              ; preds = %92, %95
  %101 = phi double [ %98, %95 ], [ %94, %92 ]
  %102 = inttoptr i64 %1 to ptr
  br label %108

103:                                              ; preds = %70
  %104 = getelementptr inbounds nuw i8, ptr %27, i64 8
  %105 = load double, ptr %104, align 8, !tbaa !22
  %106 = ashr i64 %1, 1
  %107 = sitofp i64 %106 to double
  br label %120

108:                                              ; preds = %100, %86
  %109 = phi ptr [ %102, %100 ], [ %74, %86 ]
  %110 = phi double [ %101, %100 ], [ %88, %86 ]
  %111 = load i64, ptr %109, align 8, !tbaa !23
  switch i64 %111, label %119 [
    i64 2, label %112
    i64 3, label %116
  ]

112:                                              ; preds = %108
  %113 = getelementptr inbounds nuw i8, ptr %109, i64 8
  %114 = load i64, ptr %113, align 8, !tbaa !25
  %115 = sitofp i64 %114 to double
  br label %120

116:                                              ; preds = %108
  %117 = getelementptr inbounds nuw i8, ptr %109, i64 8
  %118 = load double, ptr %117, align 8, !tbaa !22
  br label %120

119:                                              ; preds = %108
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.108) #36
  unreachable

120:                                              ; preds = %103, %112, %116
  %121 = phi double [ %105, %103 ], [ %110, %112 ], [ %110, %116 ]
  %122 = phi double [ %107, %103 ], [ %115, %112 ], [ %118, %116 ]
  %123 = fcmp oeq double %121, %122
  %124 = zext i1 %123 to i64
  br label %330

125:                                              ; preds = %26, %78, %64, %73, %71, %24
  %126 = icmp eq i64 %14, %23
  br i1 %126, label %129, label %127

127:                                              ; preds = %125
  %128 = icmp eq i64 %14, 12
  br i1 %128, label %245, label %330

129:                                              ; preds = %125
  switch i64 %14, label %330 [
    i64 4, label %130
    i64 5, label %144
    i64 6, label %144
    i64 7, label %171
    i64 8, label %171
    i64 12, label %245
  ]

130:                                              ; preds = %129
  %131 = inttoptr i64 %0 to ptr
  %132 = getelementptr inbounds nuw i8, ptr %131, i64 8
  %133 = load i64, ptr %132, align 8, !tbaa !18
  %134 = inttoptr i64 %1 to ptr
  %135 = getelementptr inbounds nuw i8, ptr %134, i64 8
  %136 = load i64, ptr %135, align 8, !tbaa !18
  %137 = icmp eq i64 %133, %136
  br i1 %137, label %138, label %330

138:                                              ; preds = %130
  %139 = getelementptr inbounds nuw i8, ptr %131, i64 16
  %140 = getelementptr inbounds nuw i8, ptr %134, i64 16
  %141 = tail call i32 @memcmp(ptr noundef nonnull %139, ptr noundef nonnull %140, i64 noundef %133)
  %142 = icmp eq i32 %141, 0
  %143 = zext i1 %142 to i64
  br label %330

144:                                              ; preds = %129, %129
  %145 = inttoptr i64 %0 to ptr
  %146 = getelementptr inbounds nuw i8, ptr %145, i64 8
  %147 = load i64, ptr %146, align 8, !tbaa !27
  %148 = inttoptr i64 %1 to ptr
  %149 = getelementptr inbounds nuw i8, ptr %148, i64 8
  %150 = load i64, ptr %149, align 8, !tbaa !27
  %151 = icmp eq i64 %147, %150
  br i1 %151, label %152, label %330

152:                                              ; preds = %144
  %153 = getelementptr inbounds nuw i8, ptr %145, i64 24
  %154 = icmp slt i64 %147, 1
  br i1 %154, label %330, label %155

155:                                              ; preds = %152
  %156 = getelementptr inbounds nuw i8, ptr %148, i64 24
  br label %161

157:                                              ; preds = %161
  %158 = add nuw nsw i64 %162, 1
  %159 = load i64, ptr %146, align 8, !tbaa !27
  %160 = icmp slt i64 %158, %159
  br i1 %160, label %161, label %330, !llvm.loop !30

161:                                              ; preds = %155, %157
  %162 = phi i64 [ 0, %155 ], [ %158, %157 ]
  %163 = load ptr, ptr %153, align 8, !tbaa !32
  %164 = getelementptr inbounds nuw i64, ptr %163, i64 %162
  %165 = load i64, ptr %164, align 8, !tbaa !11
  %166 = load ptr, ptr %156, align 8, !tbaa !32
  %167 = getelementptr inbounds nuw i64, ptr %166, i64 %162
  %168 = load i64, ptr %167, align 8, !tbaa !11
  %169 = tail call i64 @rt_eq_i(i64 noundef %165, i64 noundef %168)
  %170 = icmp eq i64 %169, 0
  br i1 %170, label %330, label %157

171:                                              ; preds = %129, %129
  %172 = inttoptr i64 %0 to ptr
  %173 = getelementptr inbounds nuw i8, ptr %172, i64 8
  %174 = load i64, ptr %173, align 8, !tbaa !33
  %175 = inttoptr i64 %1 to ptr
  %176 = getelementptr inbounds nuw i8, ptr %175, i64 8
  %177 = load i64, ptr %176, align 8, !tbaa !33
  %178 = icmp eq i64 %174, %177
  br i1 %178, label %179, label %330

179:                                              ; preds = %171
  %180 = getelementptr inbounds nuw i8, ptr %172, i64 16
  %181 = load i64, ptr %180, align 8, !tbaa !35
  %182 = icmp slt i64 %181, 1
  br i1 %182, label %330, label %183

183:                                              ; preds = %179
  %184 = getelementptr inbounds nuw i8, ptr %172, i64 32
  %185 = getelementptr inbounds nuw i8, ptr %175, i64 40
  %186 = getelementptr inbounds nuw i8, ptr %175, i64 48
  %187 = getelementptr inbounds nuw i8, ptr %175, i64 32
  %188 = icmp eq i64 %14, 7
  br label %189

189:                                              ; preds = %183, %241
  %190 = phi i64 [ 0, %183 ], [ %242, %241 ]
  %191 = load ptr, ptr %184, align 8, !tbaa !36
  %192 = getelementptr inbounds nuw %struct.Ent, ptr %191, i64 %190
  %193 = load i64, ptr %192, align 8, !tbaa !37
  %194 = icmp eq i64 %193, 0
  br i1 %194, label %241, label %195

195:                                              ; preds = %189
  %196 = getelementptr inbounds nuw i8, ptr %192, i64 16
  %197 = load i64, ptr %196, align 8, !tbaa !39
  %198 = load i64, ptr %185, align 8, !tbaa !40
  %199 = icmp eq i64 %198, 0
  br i1 %199, label %330, label %200

200:                                              ; preds = %195
  %201 = add nsw i64 %198, -1
  %202 = and i64 %201, %197
  %203 = load ptr, ptr %186, align 8, !tbaa !41
  %204 = getelementptr inbounds i64, ptr %203, i64 %202
  %205 = load i64, ptr %204, align 8, !tbaa !11
  %206 = icmp slt i64 %205, 0
  br i1 %206, label %330, label %207

207:                                              ; preds = %200, %226
  %208 = phi ptr [ %227, %226 ], [ %203, %200 ]
  %209 = phi i64 [ %231, %226 ], [ %205, %200 ]
  %210 = phi i64 [ %229, %226 ], [ %202, %200 ]
  %211 = load ptr, ptr %187, align 8, !tbaa !36
  %212 = getelementptr inbounds nuw %struct.Ent, ptr %211, i64 %209
  %213 = load i64, ptr %212, align 8, !tbaa !37
  %214 = icmp eq i64 %213, 0
  br i1 %214, label %226, label %215

215:                                              ; preds = %207
  %216 = getelementptr inbounds nuw i8, ptr %212, i64 16
  %217 = load i64, ptr %216, align 8, !tbaa !39
  %218 = icmp eq i64 %217, %197
  br i1 %218, label %219, label %226

219:                                              ; preds = %215
  %220 = icmp eq i64 %213, %193
  br i1 %220, label %233, label %221

221:                                              ; preds = %219
  %222 = tail call i64 @rt_eq_i(i64 noundef %213, i64 noundef %193)
  %223 = icmp eq i64 %222, 0
  br i1 %223, label %224, label %233

224:                                              ; preds = %221
  %225 = load ptr, ptr %186, align 8, !tbaa !41
  br label %226

226:                                              ; preds = %224, %207, %215
  %227 = phi ptr [ %225, %224 ], [ %208, %207 ], [ %208, %215 ]
  %228 = add nuw nsw i64 %210, 1
  %229 = and i64 %228, %201
  %230 = getelementptr inbounds i64, ptr %227, i64 %229
  %231 = load i64, ptr %230, align 8, !tbaa !11
  %232 = icmp slt i64 %231, 0
  br i1 %232, label %330, label %207

233:                                              ; preds = %219, %221
  br i1 %188, label %234, label %241

234:                                              ; preds = %233
  %235 = getelementptr inbounds nuw i8, ptr %192, i64 8
  %236 = load i64, ptr %235, align 8, !tbaa !42
  %237 = getelementptr inbounds nuw i8, ptr %212, i64 8
  %238 = load i64, ptr %237, align 8, !tbaa !42
  %239 = tail call i64 @rt_eq_i(i64 noundef %236, i64 noundef %238)
  %240 = icmp eq i64 %239, 0
  br i1 %240, label %330, label %241

241:                                              ; preds = %233, %234, %189
  %242 = add nuw nsw i64 %190, 1
  %243 = load i64, ptr %180, align 8, !tbaa !35
  %244 = icmp slt i64 %242, %243
  br i1 %244, label %189, label %330, !llvm.loop !43

245:                                              ; preds = %129, %127
  %246 = load i64, ptr @rt_eq_i.k_eq, align 8, !tbaa !11
  %247 = icmp eq i64 %246, 0
  br i1 %247, label %248, label %257

248:                                              ; preds = %245
  %249 = tail call dereferenceable_or_null(31) ptr @calloc(i64 noundef 1, i64 noundef 31) #33
  %250 = icmp eq ptr %249, null
  br i1 %250, label %251, label %254

251:                                              ; preds = %248
  %252 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %253 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %252)
  tail call void @exit(i32 noundef 1) #34
  unreachable

254:                                              ; preds = %248
  store <2 x i64> <i64 4, i64 6>, ptr %249, align 8, !tbaa !11
  %255 = getelementptr inbounds nuw i8, ptr %249, i64 16
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %255, ptr noundef nonnull align 1 dereferenceable(6) @.str, i64 noundef 6, i1 noundef false) #35
  %256 = ptrtoint ptr %249 to i64
  store i64 %256, ptr @rt_eq_i.k_eq, align 8, !tbaa !11
  br label %257

257:                                              ; preds = %254, %245
  %258 = phi i64 [ %256, %254 ], [ %246, %245 ]
  %259 = inttoptr i64 %0 to ptr
  %260 = getelementptr inbounds nuw i8, ptr %259, i64 8
  %261 = load i64, ptr %260, align 8, !tbaa !11
  %262 = icmp ne i64 %261, 0
  %263 = and i64 %261, 1
  %264 = icmp eq i64 %263, 0
  %265 = and i1 %262, %264
  br i1 %265, label %266, label %330

266:                                              ; preds = %257, %315
  %267 = phi i64 [ %317, %315 ], [ %261, %257 ]
  %268 = inttoptr i64 %267 to ptr
  %269 = load i64, ptr %268, align 8, !tbaa !23
  %270 = icmp eq i64 %269, 11
  br i1 %270, label %271, label %330

271:                                              ; preds = %266
  %272 = getelementptr inbounds nuw i8, ptr %268, i64 24
  %273 = load i64, ptr %272, align 8, !tbaa !44
  %274 = inttoptr i64 %273 to ptr
  %275 = tail call fastcc i64 @hash_v(i64 noundef %258)
  %276 = getelementptr inbounds nuw i8, ptr %274, i64 40
  %277 = load i64, ptr %276, align 8, !tbaa !40
  %278 = icmp eq i64 %277, 0
  br i1 %278, label %315, label %279

279:                                              ; preds = %271
  %280 = add nsw i64 %277, -1
  %281 = getelementptr inbounds nuw i8, ptr %274, i64 48
  %282 = and i64 %280, %275
  %283 = load ptr, ptr %281, align 8, !tbaa !41
  %284 = getelementptr inbounds i64, ptr %283, i64 %282
  %285 = load i64, ptr %284, align 8, !tbaa !11
  %286 = icmp slt i64 %285, 0
  br i1 %286, label %315, label %287

287:                                              ; preds = %279
  %288 = getelementptr inbounds nuw i8, ptr %274, i64 32
  br label %289

289:                                              ; preds = %287, %308
  %290 = phi ptr [ %283, %287 ], [ %309, %308 ]
  %291 = phi i64 [ %285, %287 ], [ %313, %308 ]
  %292 = phi i64 [ %282, %287 ], [ %311, %308 ]
  %293 = load ptr, ptr %288, align 8, !tbaa !36
  %294 = getelementptr inbounds nuw %struct.Ent, ptr %293, i64 %291
  %295 = load i64, ptr %294, align 8, !tbaa !37
  %296 = icmp eq i64 %295, 0
  br i1 %296, label %308, label %297

297:                                              ; preds = %289
  %298 = getelementptr inbounds nuw i8, ptr %294, i64 16
  %299 = load i64, ptr %298, align 8, !tbaa !39
  %300 = icmp eq i64 %299, %275
  br i1 %300, label %301, label %308

301:                                              ; preds = %297
  %302 = icmp eq i64 %295, %258
  br i1 %302, label %322, label %303

303:                                              ; preds = %301
  %304 = tail call i64 @rt_eq_i(i64 noundef %295, i64 noundef %258)
  %305 = icmp eq i64 %304, 0
  br i1 %305, label %306, label %322

306:                                              ; preds = %303
  %307 = load ptr, ptr %281, align 8, !tbaa !41
  br label %308

308:                                              ; preds = %306, %289, %297
  %309 = phi ptr [ %307, %306 ], [ %290, %289 ], [ %290, %297 ]
  %310 = add nuw nsw i64 %292, 1
  %311 = and i64 %310, %280
  %312 = getelementptr inbounds i64, ptr %309, i64 %311
  %313 = load i64, ptr %312, align 8, !tbaa !11
  %314 = icmp slt i64 %313, 0
  br i1 %314, label %315, label %289

315:                                              ; preds = %308, %271, %279
  %316 = getelementptr inbounds nuw i8, ptr %268, i64 16
  %317 = load i64, ptr %316, align 8, !tbaa !11
  %318 = icmp ne i64 %317, 0
  %319 = and i64 %317, 1
  %320 = icmp eq i64 %319, 0
  %321 = and i1 %318, %320
  br i1 %321, label %266, label %330

322:                                              ; preds = %303, %301
  %323 = getelementptr inbounds nuw i8, ptr %294, i64 8
  %324 = load i64, ptr %323, align 8, !tbaa !42
  %325 = icmp eq i64 %324, 0
  br i1 %325, label %330, label %326

326:                                              ; preds = %322
  call void @llvm.lifetime.start.p0(ptr nonnull %3) #35
  store i64 %0, ptr %3, align 8, !tbaa !11
  %327 = getelementptr inbounds nuw i8, ptr %3, i64 8
  store i64 %1, ptr %327, align 8, !tbaa !11
  %328 = call i64 @rt_call(i64 noundef %324, i64 noundef 2, ptr noundef nonnull %3)
  %329 = call i64 @rt_truthy(i64 noundef %328)
  call void @llvm.lifetime.end.p0(ptr nonnull %3) #35
  br label %330

330:                                              ; preds = %315, %266, %200, %195, %234, %241, %226, %161, %157, %257, %179, %152, %59, %120, %127, %138, %130, %144, %171, %322, %326, %129, %2
  %331 = phi i64 [ 1, %2 ], [ %62, %59 ], [ %124, %120 ], [ %329, %326 ], [ 0, %161 ], [ 0, %322 ], [ 0, %127 ], [ %143, %138 ], [ 0, %144 ], [ 0, %129 ], [ 0, %195 ], [ 0, %171 ], [ 0, %130 ], [ 1, %152 ], [ 0, %226 ], [ 1, %179 ], [ 0, %257 ], [ 1, %157 ], [ 0, %234 ], [ 1, %241 ], [ 0, %200 ], [ 0, %266 ], [ 0, %315 ]
  ret i64 %331
}

; Function Attrs: nounwind ssp uwtable(sync)
define internal fastcc i64 @toi(i64 noundef %0) unnamed_addr #2 {
  %2 = and i64 %0, 1
  %3 = icmp eq i64 %2, 0
  br i1 %3, label %6, label %4

4:                                                ; preds = %1
  %5 = ashr i64 %0, 1
  br label %16

6:                                                ; preds = %1
  %7 = icmp eq i64 %0, 0
  br i1 %7, label %15, label %8

8:                                                ; preds = %6
  %9 = inttoptr i64 %0 to ptr
  %10 = load i64, ptr %9, align 8, !tbaa !23
  %11 = icmp eq i64 %10, 2
  br i1 %11, label %12, label %15

12:                                               ; preds = %8
  %13 = getelementptr inbounds nuw i8, ptr %9, i64 8
  %14 = load i64, ptr %13, align 8, !tbaa !25
  br label %16

15:                                               ; preds = %6, %8
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

16:                                               ; preds = %12, %4
  %17 = phi i64 [ %5, %4 ], [ %14, %12 ]
  ret i64 %17
}

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: read)
declare i32 @memcmp(ptr noundef captures(none), ptr noundef captures(none), i64 noundef) local_unnamed_addr #4

; Function Attrs: nounwind ssp uwtable(sync)
define internal fastcc noundef ptr @dict_find(ptr noundef readonly captures(none) %0, i64 noundef %1, i64 noundef %2) unnamed_addr #2 {
  %4 = getelementptr inbounds nuw i8, ptr %0, i64 40
  %5 = load i64, ptr %4, align 8, !tbaa !40
  %6 = icmp eq i64 %5, 0
  br i1 %6, label %43, label %7

7:                                                ; preds = %3
  %8 = add nsw i64 %5, -1
  %9 = getelementptr inbounds nuw i8, ptr %0, i64 48
  %10 = and i64 %2, %8
  %11 = load ptr, ptr %9, align 8, !tbaa !41
  %12 = getelementptr inbounds i64, ptr %11, i64 %10
  %13 = load i64, ptr %12, align 8, !tbaa !11
  %14 = icmp slt i64 %13, 0
  br i1 %14, label %43, label %15

15:                                               ; preds = %7
  %16 = getelementptr inbounds nuw i8, ptr %0, i64 32
  br label %17

17:                                               ; preds = %15, %36
  %18 = phi ptr [ %11, %15 ], [ %37, %36 ]
  %19 = phi i64 [ %13, %15 ], [ %41, %36 ]
  %20 = phi i64 [ %10, %15 ], [ %39, %36 ]
  %21 = load ptr, ptr %16, align 8, !tbaa !36
  %22 = getelementptr inbounds nuw %struct.Ent, ptr %21, i64 %19
  %23 = load i64, ptr %22, align 8, !tbaa !37
  %24 = icmp eq i64 %23, 0
  br i1 %24, label %36, label %25

25:                                               ; preds = %17
  %26 = getelementptr inbounds nuw i8, ptr %22, i64 16
  %27 = load i64, ptr %26, align 8, !tbaa !39
  %28 = icmp eq i64 %27, %2
  br i1 %28, label %29, label %36

29:                                               ; preds = %25
  %30 = icmp eq i64 %23, %1
  br i1 %30, label %43, label %31

31:                                               ; preds = %29
  %32 = tail call i64 @rt_eq_i(i64 noundef %23, i64 noundef %1)
  %33 = icmp eq i64 %32, 0
  br i1 %33, label %34, label %43

34:                                               ; preds = %31
  %35 = load ptr, ptr %9, align 8, !tbaa !41
  br label %36

36:                                               ; preds = %34, %17, %25
  %37 = phi ptr [ %35, %34 ], [ %18, %17 ], [ %18, %25 ]
  %38 = add nuw nsw i64 %20, 1
  %39 = and i64 %38, %8
  %40 = getelementptr inbounds i64, ptr %37, i64 %39
  %41 = load i64, ptr %40, align 8, !tbaa !11
  %42 = icmp slt i64 %41, 0
  br i1 %42, label %43, label %17

43:                                               ; preds = %36, %31, %29, %7, %3
  %44 = phi ptr [ null, %3 ], [ null, %7 ], [ null, %36 ], [ %22, %31 ], [ %22, %29 ]
  ret ptr %44
}

; Function Attrs: nounwind ssp uwtable(sync)
define internal fastcc i64 @class_lookup(i64 noundef %0, i64 noundef %1) unnamed_addr #2 {
  %3 = icmp ne i64 %0, 0
  %4 = and i64 %0, 1
  %5 = icmp eq i64 %4, 0
  %6 = and i1 %3, %5
  br i1 %6, label %7, label %29

7:                                                ; preds = %2, %22
  %8 = phi i64 [ %24, %22 ], [ %0, %2 ]
  %9 = inttoptr i64 %8 to ptr
  %10 = load i64, ptr %9, align 8, !tbaa !23
  %11 = icmp eq i64 %10, 11
  br i1 %11, label %12, label %29

12:                                               ; preds = %7
  %13 = getelementptr inbounds nuw i8, ptr %9, i64 24
  %14 = load i64, ptr %13, align 8, !tbaa !44
  %15 = inttoptr i64 %14 to ptr
  %16 = tail call fastcc i64 @hash_v(i64 noundef %1)
  %17 = tail call fastcc ptr @dict_find(ptr noundef %15, i64 noundef %1, i64 noundef %16)
  %18 = icmp eq ptr %17, null
  br i1 %18, label %22, label %19

19:                                               ; preds = %12
  %20 = getelementptr inbounds nuw i8, ptr %17, i64 8
  %21 = load i64, ptr %20, align 8, !tbaa !42
  br label %29

22:                                               ; preds = %12
  %23 = getelementptr inbounds nuw i8, ptr %9, i64 16
  %24 = load i64, ptr %23, align 8, !tbaa !46
  %25 = icmp ne i64 %24, 0
  %26 = and i64 %24, 1
  %27 = icmp eq i64 %26, 0
  %28 = and i1 %25, %27
  br i1 %28, label %7, label %29

29:                                               ; preds = %22, %7, %2, %19
  %30 = phi i64 [ %21, %19 ], [ 0, %2 ], [ 0, %7 ], [ 0, %22 ]
  ret i64 %30
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_truthy(i64 noundef %0) local_unnamed_addr #2 {
  %2 = alloca [1 x i64], align 8
  %3 = and i64 %0, 1
  %4 = icmp eq i64 %3, 0
  br i1 %4, label %8, label %5

5:                                                ; preds = %1
  %6 = icmp ne i64 %0, 1
  %7 = zext i1 %6 to i64
  br label %108

8:                                                ; preds = %1
  %9 = icmp eq i64 %0, 0
  br i1 %9, label %107, label %10

10:                                               ; preds = %8
  %11 = inttoptr i64 %0 to ptr
  %12 = load i64, ptr %11, align 8, !tbaa !23
  switch i64 %12, label %107 [
    i64 1, label %108
    i64 2, label %13
    i64 3, label %16
    i64 4, label %21
    i64 5, label %26
    i64 6, label %26
    i64 7, label %31
    i64 8, label %31
    i64 12, label %36
  ]

13:                                               ; preds = %10
  %14 = getelementptr inbounds nuw i8, ptr %11, i64 8
  %15 = load i64, ptr %14, align 8, !tbaa !25
  br label %108

16:                                               ; preds = %10
  %17 = getelementptr inbounds nuw i8, ptr %11, i64 8
  %18 = load double, ptr %17, align 8, !tbaa !22
  %19 = fcmp une double %18, 0.000000e+00
  %20 = zext i1 %19 to i64
  br label %108

21:                                               ; preds = %10
  %22 = getelementptr inbounds nuw i8, ptr %11, i64 8
  %23 = load i64, ptr %22, align 8, !tbaa !18
  %24 = icmp sgt i64 %23, 0
  %25 = zext i1 %24 to i64
  br label %108

26:                                               ; preds = %10, %10
  %27 = getelementptr inbounds nuw i8, ptr %11, i64 8
  %28 = load i64, ptr %27, align 8, !tbaa !27
  %29 = icmp sgt i64 %28, 0
  %30 = zext i1 %29 to i64
  br label %108

31:                                               ; preds = %10, %10
  %32 = getelementptr inbounds nuw i8, ptr %11, i64 8
  %33 = load i64, ptr %32, align 8, !tbaa !33
  %34 = icmp sgt i64 %33, 0
  %35 = zext i1 %34 to i64
  br label %108

36:                                               ; preds = %10
  %37 = getelementptr inbounds nuw i8, ptr %11, i64 8
  %38 = load i64, ptr @K_len, align 8, !tbaa !11
  %39 = load i64, ptr %37, align 8, !tbaa !11
  %40 = icmp ne i64 %39, 0
  %41 = and i64 %39, 1
  %42 = icmp eq i64 %41, 0
  %43 = and i1 %40, %42
  br i1 %43, label %44, label %108

44:                                               ; preds = %36, %93
  %45 = phi i64 [ %95, %93 ], [ %39, %36 ]
  %46 = inttoptr i64 %45 to ptr
  %47 = load i64, ptr %46, align 8, !tbaa !23
  %48 = icmp eq i64 %47, 11
  br i1 %48, label %49, label %108

49:                                               ; preds = %44
  %50 = getelementptr inbounds nuw i8, ptr %46, i64 24
  %51 = load i64, ptr %50, align 8, !tbaa !44
  %52 = inttoptr i64 %51 to ptr
  %53 = tail call fastcc i64 @hash_v(i64 noundef %38)
  %54 = getelementptr inbounds nuw i8, ptr %52, i64 40
  %55 = load i64, ptr %54, align 8, !tbaa !40
  %56 = icmp eq i64 %55, 0
  br i1 %56, label %93, label %57

57:                                               ; preds = %49
  %58 = add nsw i64 %55, -1
  %59 = getelementptr inbounds nuw i8, ptr %52, i64 48
  %60 = and i64 %53, %58
  %61 = load ptr, ptr %59, align 8, !tbaa !41
  %62 = getelementptr inbounds i64, ptr %61, i64 %60
  %63 = load i64, ptr %62, align 8, !tbaa !11
  %64 = icmp slt i64 %63, 0
  br i1 %64, label %93, label %65

65:                                               ; preds = %57
  %66 = getelementptr inbounds nuw i8, ptr %52, i64 32
  br label %67

67:                                               ; preds = %65, %86
  %68 = phi ptr [ %61, %65 ], [ %87, %86 ]
  %69 = phi i64 [ %63, %65 ], [ %91, %86 ]
  %70 = phi i64 [ %60, %65 ], [ %89, %86 ]
  %71 = load ptr, ptr %66, align 8, !tbaa !36
  %72 = getelementptr inbounds nuw %struct.Ent, ptr %71, i64 %69
  %73 = load i64, ptr %72, align 8, !tbaa !37
  %74 = icmp eq i64 %73, 0
  br i1 %74, label %86, label %75

75:                                               ; preds = %67
  %76 = getelementptr inbounds nuw i8, ptr %72, i64 16
  %77 = load i64, ptr %76, align 8, !tbaa !39
  %78 = icmp eq i64 %77, %53
  br i1 %78, label %79, label %86

79:                                               ; preds = %75
  %80 = icmp eq i64 %73, %38
  br i1 %80, label %100, label %81

81:                                               ; preds = %79
  %82 = tail call i64 @rt_eq_i(i64 noundef %73, i64 noundef %38)
  %83 = icmp eq i64 %82, 0
  br i1 %83, label %84, label %100

84:                                               ; preds = %81
  %85 = load ptr, ptr %59, align 8, !tbaa !41
  br label %86

86:                                               ; preds = %84, %67, %75
  %87 = phi ptr [ %85, %84 ], [ %68, %67 ], [ %68, %75 ]
  %88 = add nuw nsw i64 %70, 1
  %89 = and i64 %88, %58
  %90 = getelementptr inbounds i64, ptr %87, i64 %89
  %91 = load i64, ptr %90, align 8, !tbaa !11
  %92 = icmp slt i64 %91, 0
  br i1 %92, label %93, label %67

93:                                               ; preds = %86, %49, %57
  %94 = getelementptr inbounds nuw i8, ptr %46, i64 16
  %95 = load i64, ptr %94, align 8, !tbaa !11
  %96 = icmp ne i64 %95, 0
  %97 = and i64 %95, 1
  %98 = icmp eq i64 %97, 0
  %99 = and i1 %96, %98
  br i1 %99, label %44, label %108

100:                                              ; preds = %81, %79
  %101 = getelementptr inbounds nuw i8, ptr %72, i64 8
  %102 = load i64, ptr %101, align 8, !tbaa !42
  %103 = icmp eq i64 %102, 0
  br i1 %103, label %108, label %104

104:                                              ; preds = %100
  call void @llvm.lifetime.start.p0(ptr nonnull %2) #35
  store i64 %0, ptr %2, align 8, !tbaa !11
  %105 = call i64 @rt_call(i64 noundef %102, i64 noundef 1, ptr noundef nonnull %2)
  %106 = call i64 @rt_truthy(i64 noundef %105)
  call void @llvm.lifetime.end.p0(ptr nonnull %2) #35
  br label %108

107:                                              ; preds = %8, %10
  br label %108

108:                                              ; preds = %93, %44, %36, %104, %100, %10, %107, %31, %26, %21, %16, %13, %5
  %109 = phi i64 [ %7, %5 ], [ 1, %107 ], [ 0, %10 ], [ %15, %13 ], [ %20, %16 ], [ %25, %21 ], [ %30, %26 ], [ %35, %31 ], [ %106, %104 ], [ 1, %100 ], [ 1, %36 ], [ 1, %44 ], [ 1, %93 ]
  ret i64 %109
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_call(i64 noundef %0, i64 noundef %1, ptr noundef %2) local_unnamed_addr #2 {
  %4 = and i64 %0, 1
  %5 = icmp ne i64 %4, 0
  %6 = icmp eq i64 %0, 0
  %7 = or i1 %6, %5
  br i1 %7, label %158, label %8

8:                                                ; preds = %3
  %9 = inttoptr i64 %0 to ptr
  %10 = load i64, ptr %9, align 8, !tbaa !23
  switch i64 %10, label %158 [
    i64 9, label %11
    i64 10, label %98
    i64 13, label %102
    i64 11, label %116
  ]

11:                                               ; preds = %8
  %12 = getelementptr inbounds nuw i8, ptr %9, i64 16
  %13 = load i64, ptr %12, align 8, !tbaa !47
  %14 = icmp slt i64 %1, %13
  br i1 %14, label %15, label %87

15:                                               ; preds = %11
  %16 = sub nsw i64 %13, %1
  %17 = getelementptr inbounds nuw i8, ptr %9, i64 24
  %18 = load i64, ptr %17, align 8, !tbaa !49
  %19 = icmp sgt i64 %16, %18
  br i1 %19, label %20, label %26

20:                                               ; preds = %15
  %21 = getelementptr inbounds nuw i8, ptr %9, i64 40
  %22 = load i64, ptr %21, align 8, !tbaa !50
  %23 = inttoptr i64 %22 to ptr
  %24 = getelementptr inbounds nuw i8, ptr %23, i64 16
  %25 = sub nsw i64 %16, %18
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.31, ptr noundef nonnull %24, i64 noundef %25) #36
  unreachable

26:                                               ; preds = %15
  %27 = tail call ptr @llvm.stacksave.p0()
  %28 = alloca i64, i64 %13, align 8
  %29 = ptrtoint ptr %28 to i64
  %30 = icmp sgt i64 %1, 0
  br i1 %30, label %31, label %33

31:                                               ; preds = %26
  %32 = shl nuw i64 %1, 3
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %28, ptr align 8 %2, i64 %32, i1 false), !tbaa !11
  br label %33

33:                                               ; preds = %31, %26
  %34 = load i64, ptr %12, align 8, !tbaa !47
  %35 = icmp slt i64 %1, %34
  br i1 %35, label %36, label %76

36:                                               ; preds = %33
  %37 = getelementptr inbounds nuw i8, ptr %9, i64 32
  %38 = load ptr, ptr %37, align 8, !tbaa !51
  %39 = load i64, ptr %17, align 8, !tbaa !49
  %40 = sub i64 %39, %34
  %41 = getelementptr i64, ptr %38, i64 %40
  %42 = sub i64 %34, %1
  %43 = icmp ult i64 %42, 10
  br i1 %43, label %74, label %44

44:                                               ; preds = %36
  %45 = ptrtoint ptr %38 to i64
  %46 = shl i64 %34, 3
  %47 = add i64 %46, %29
  %48 = shl i64 %39, 3
  %49 = add i64 %48, %45
  %50 = sub i64 %47, %49
  %51 = icmp ult i64 %50, 64
  br i1 %51, label %74, label %52

52:                                               ; preds = %44
  %53 = and i64 %42, -8
  %54 = add i64 %1, %53
  br label %55

55:                                               ; preds = %55, %52
  %56 = phi i64 [ 0, %52 ], [ %70, %55 ]
  %57 = add i64 %1, %56
  %58 = getelementptr i64, ptr %41, i64 %57
  %59 = getelementptr i8, ptr %58, i64 16
  %60 = getelementptr i8, ptr %58, i64 32
  %61 = getelementptr i8, ptr %58, i64 48
  %62 = load <2 x i64>, ptr %58, align 8, !tbaa !11
  %63 = load <2 x i64>, ptr %59, align 8, !tbaa !11
  %64 = load <2 x i64>, ptr %60, align 8, !tbaa !11
  %65 = load <2 x i64>, ptr %61, align 8, !tbaa !11
  %66 = getelementptr inbounds i64, ptr %28, i64 %57
  %67 = getelementptr inbounds nuw i8, ptr %66, i64 16
  %68 = getelementptr inbounds nuw i8, ptr %66, i64 32
  %69 = getelementptr inbounds nuw i8, ptr %66, i64 48
  store <2 x i64> %62, ptr %66, align 8, !tbaa !11
  store <2 x i64> %63, ptr %67, align 8, !tbaa !11
  store <2 x i64> %64, ptr %68, align 8, !tbaa !11
  store <2 x i64> %65, ptr %69, align 8, !tbaa !11
  %70 = add nuw i64 %56, 8
  %71 = icmp eq i64 %70, %53
  br i1 %71, label %72, label %55, !llvm.loop !52

72:                                               ; preds = %55
  %73 = icmp eq i64 %42, %53
  br i1 %73, label %76, label %74

74:                                               ; preds = %44, %36, %72
  %75 = phi i64 [ %1, %44 ], [ %1, %36 ], [ %54, %72 ]
  br label %80

76:                                               ; preds = %80, %72, %33
  %77 = getelementptr inbounds nuw i8, ptr %9, i64 8
  %78 = load ptr, ptr %77, align 8, !tbaa !55
  %79 = call i64 %78(i64 noundef %34, ptr noundef nonnull %28) #35
  call void @llvm.stackrestore.p0(ptr %27)
  br label %160

80:                                               ; preds = %74, %80
  %81 = phi i64 [ %85, %80 ], [ %75, %74 ]
  %82 = getelementptr i64, ptr %41, i64 %81
  %83 = load i64, ptr %82, align 8, !tbaa !11
  %84 = getelementptr inbounds i64, ptr %28, i64 %81
  store i64 %83, ptr %84, align 8, !tbaa !11
  %85 = add nsw i64 %81, 1
  %86 = icmp slt i64 %85, %34
  br i1 %86, label %80, label %76, !llvm.loop !56

87:                                               ; preds = %11
  %88 = icmp sgt i64 %1, %13
  br i1 %88, label %89, label %94

89:                                               ; preds = %87
  %90 = getelementptr inbounds nuw i8, ptr %9, i64 40
  %91 = load i64, ptr %90, align 8, !tbaa !50
  %92 = inttoptr i64 %91 to ptr
  %93 = getelementptr inbounds nuw i8, ptr %92, i64 16
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.32, ptr noundef nonnull %93, i64 noundef %13, i64 noundef %1) #36
  unreachable

94:                                               ; preds = %87
  %95 = getelementptr inbounds nuw i8, ptr %9, i64 8
  %96 = load ptr, ptr %95, align 8, !tbaa !55
  %97 = tail call i64 %96(i64 noundef %1, ptr noundef %2) #35
  br label %160

98:                                               ; preds = %8
  %99 = getelementptr inbounds nuw i8, ptr %9, i64 8
  %100 = load ptr, ptr %99, align 8, !tbaa !57
  %101 = tail call i64 %100(i64 noundef %1, ptr noundef %2) #35
  br label %160

102:                                              ; preds = %8
  %103 = add nsw i64 %1, 1
  %104 = tail call ptr @llvm.stacksave.p0()
  %105 = alloca i64, i64 %103, align 8
  %106 = getelementptr inbounds nuw i8, ptr %9, i64 8
  %107 = load i64, ptr %106, align 8, !tbaa !42
  store i64 %107, ptr %105, align 8, !tbaa !11
  %108 = icmp sgt i64 %1, 0
  br i1 %108, label %109, label %112

109:                                              ; preds = %102
  %110 = getelementptr i8, ptr %105, i64 8
  %111 = shl nuw i64 %1, 3
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %110, ptr align 8 %2, i64 %111, i1 false), !tbaa !11
  br label %112

112:                                              ; preds = %109, %102
  %113 = getelementptr inbounds nuw i8, ptr %9, i64 16
  %114 = load i64, ptr %113, align 8, !tbaa !39
  %115 = call i64 @rt_call(i64 noundef %114, i64 noundef %103, ptr noundef nonnull %105)
  call void @llvm.stackrestore.p0(ptr %104)
  br label %160

116:                                              ; preds = %8
  %117 = tail call fastcc i64 @new_inst(i64 noundef %0)
  %118 = load i64, ptr @K_init, align 8, !tbaa !11
  br label %119

119:                                              ; preds = %116, %130
  %120 = phi i64 [ %132, %130 ], [ %0, %116 ]
  %121 = inttoptr i64 %120 to ptr
  %122 = load i64, ptr %121, align 8, !tbaa !23
  %123 = icmp eq i64 %122, 11
  br i1 %123, label %124, label %151

124:                                              ; preds = %119
  %125 = getelementptr inbounds nuw i8, ptr %121, i64 24
  %126 = load i64, ptr %125, align 8, !tbaa !44
  %127 = inttoptr i64 %126 to ptr
  %128 = tail call fastcc ptr @dict_get_e(ptr noundef %127, i64 noundef %118)
  %129 = icmp eq ptr %128, null
  br i1 %129, label %130, label %137

130:                                              ; preds = %124
  %131 = getelementptr inbounds nuw i8, ptr %121, i64 16
  %132 = load i64, ptr %131, align 8, !tbaa !46
  %133 = icmp ne i64 %132, 0
  %134 = and i64 %132, 1
  %135 = icmp eq i64 %134, 0
  %136 = and i1 %133, %135
  br i1 %136, label %119, label %151

137:                                              ; preds = %124
  %138 = getelementptr inbounds nuw i8, ptr %128, i64 8
  %139 = load i64, ptr %138, align 8, !tbaa !42
  %140 = icmp eq i64 %139, 0
  br i1 %140, label %151, label %141

141:                                              ; preds = %137
  %142 = add nsw i64 %1, 1
  %143 = tail call ptr @llvm.stacksave.p0()
  %144 = alloca i64, i64 %142, align 8
  store i64 %117, ptr %144, align 8, !tbaa !11
  %145 = icmp sgt i64 %1, 0
  br i1 %145, label %146, label %149

146:                                              ; preds = %141
  %147 = getelementptr i8, ptr %144, i64 8
  %148 = shl nuw i64 %1, 3
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %147, ptr align 8 %2, i64 %148, i1 false), !tbaa !11
  br label %149

149:                                              ; preds = %146, %141
  %150 = call i64 @rt_call(i64 noundef %139, i64 noundef %142, ptr noundef nonnull %144)
  call void @llvm.stackrestore.p0(ptr %143)
  br label %160

151:                                              ; preds = %130, %119, %137
  %152 = icmp sgt i64 %1, 0
  br i1 %152, label %153, label %160

153:                                              ; preds = %151
  %154 = getelementptr inbounds nuw i8, ptr %9, i64 8
  %155 = load i64, ptr %154, align 8, !tbaa !60
  %156 = inttoptr i64 %155 to ptr
  %157 = getelementptr inbounds nuw i8, ptr %156, i64 16
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.33, ptr noundef nonnull %157) #36
  unreachable

158:                                              ; preds = %3, %8
  %159 = tail call fastcc ptr @tname(i64 noundef %0)
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.34, ptr noundef nonnull %159) #36
  unreachable

160:                                              ; preds = %149, %151, %76, %94, %112, %98
  %161 = phi i64 [ %97, %94 ], [ %101, %98 ], [ %115, %112 ], [ %79, %76 ], [ %117, %151 ], [ %117, %149 ]
  ret i64 %161
}

; Function Attrs: noreturn nounwind ssp uwtable(sync)
define noundef i64 @rt_raise(i64 noundef %0) local_unnamed_addr #5 {
  %2 = alloca %struct.SB, align 8
  %3 = and i64 %0, 1
  %4 = icmp eq i64 %3, 0
  br i1 %4, label %5, label %13

5:                                                ; preds = %1
  %6 = icmp eq i64 %0, 0
  br i1 %6, label %23, label %7

7:                                                ; preds = %5
  %8 = inttoptr i64 %0 to ptr
  %9 = load i64, ptr %8, align 8, !tbaa !23
  %10 = icmp eq i64 %9, 11
  br i1 %10, label %11, label %13

11:                                               ; preds = %7
  %12 = tail call i64 @rt_call(i64 noundef %0, i64 noundef 0, ptr noundef null)
  br label %13

13:                                               ; preds = %1, %11, %7
  %14 = phi i64 [ %12, %11 ], [ %0, %7 ], [ %0, %1 ]
  %15 = and i64 %14, 1
  %16 = icmp ne i64 %15, 0
  %17 = icmp eq i64 %14, 0
  %18 = or i1 %17, %16
  br i1 %18, label %23, label %19

19:                                               ; preds = %13
  %20 = inttoptr i64 %14 to ptr
  %21 = load i64, ptr %20, align 8, !tbaa !23
  %22 = icmp eq i64 %21, 12
  br i1 %22, label %28, label %23

23:                                               ; preds = %5, %13, %19
  %24 = load ptr, ptr @__stdoutp, align 8, !tbaa !13
  %25 = tail call i32 @fflush(ptr noundef %24)
  %26 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %27 = tail call i64 @fwrite(ptr nonnull @.str.1, i64 49, i64 1, ptr %26)
  tail call void @exit(i32 noundef 1) #34
  unreachable

28:                                               ; preds = %19
  store i64 %14, ptr @cur_exc, align 8, !tbaa !11
  %29 = load i64, ptr @nh, align 8, !tbaa !11
  %30 = icmp sgt i64 %29, 0
  br i1 %30, label %31, label %34

31:                                               ; preds = %28
  %32 = add nsw i64 %29, -1
  store i64 %32, ptr @nh, align 8, !tbaa !11
  %33 = getelementptr inbounds nuw [48 x i32], ptr @jbs, i64 %32
  tail call void @longjmp(ptr noundef nonnull %33, i32 noundef 1) #37
  unreachable

34:                                               ; preds = %28
  %35 = load ptr, ptr @__stdoutp, align 8, !tbaa !13
  %36 = tail call i32 @fflush(ptr noundef %35)
  %37 = load i64, ptr %20, align 8, !tbaa !23
  %38 = icmp eq i64 %37, 4
  br i1 %38, label %51, label %39

39:                                               ; preds = %34
  call void @llvm.lifetime.start.p0(ptr nonnull %2) #35
  %40 = getelementptr inbounds nuw i8, ptr %2, i64 8
  store <2 x i64> <i64 0, i64 64>, ptr %40, align 8, !tbaa !11
  %41 = tail call dereferenceable_or_null(64) ptr @calloc(i64 noundef 1, i64 noundef 64) #33
  %42 = icmp eq ptr %41, null
  br i1 %42, label %43, label %46

43:                                               ; preds = %39
  %44 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %45 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %44)
  tail call void @exit(i32 noundef 1) #34
  unreachable

46:                                               ; preds = %39
  store ptr %41, ptr %2, align 8, !tbaa !61
  call fastcc void @to_sb(ptr noundef %2, i64 noundef %14, i32 noundef 0)
  %47 = load ptr, ptr %2, align 8, !tbaa !61
  %48 = load i64, ptr %40, align 8, !tbaa !63
  %49 = call fastcc i64 @mkstr(ptr noundef %47, i64 noundef %48)
  call void @llvm.lifetime.end.p0(ptr nonnull %2) #35
  %50 = inttoptr i64 %49 to ptr
  br label %51

51:                                               ; preds = %34, %46
  %52 = phi ptr [ %20, %34 ], [ %50, %46 ]
  %53 = getelementptr inbounds nuw i8, ptr %20, i64 8
  %54 = load i64, ptr %53, align 8, !tbaa !42
  %55 = inttoptr i64 %54 to ptr
  %56 = getelementptr inbounds nuw i8, ptr %55, i64 8
  %57 = load i64, ptr %56, align 8, !tbaa !60
  %58 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %59 = call i64 @fwrite(ptr nonnull @.str.2, i64 53, i64 1, ptr %58)
  %60 = getelementptr inbounds nuw i8, ptr %52, i64 8
  %61 = load i64, ptr %60, align 8, !tbaa !18
  %62 = icmp eq i64 %61, 0
  %63 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %64 = inttoptr i64 %57 to ptr
  %65 = getelementptr inbounds nuw i8, ptr %64, i64 16
  br i1 %62, label %69, label %66

66:                                               ; preds = %51
  %67 = getelementptr inbounds nuw i8, ptr %52, i64 16
  %68 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %63, ptr noundef nonnull @.str.3, ptr noundef nonnull %65, ptr noundef nonnull %67) #35
  br label %71

69:                                               ; preds = %51
  %70 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %63, ptr noundef nonnull @.str.4, ptr noundef nonnull %65) #35
  br label %71

71:                                               ; preds = %69, %66
  call void @exit(i32 noundef 1) #34
  unreachable
}

; Function Attrs: nofree nounwind
declare noundef i32 @fflush(ptr noundef captures(none)) local_unnamed_addr #6

; Function Attrs: nofree nounwind
declare noundef i32 @fprintf(ptr noundef captures(none), ptr noundef readonly captures(none), ...) local_unnamed_addr #6

; Function Attrs: nofree noreturn
declare void @exit(i32 noundef) local_unnamed_addr #7

; Function Attrs: noreturn
declare void @longjmp(ptr noundef, i32 noundef) local_unnamed_addr #8

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_str(i64 noundef %0) local_unnamed_addr #2 {
  %2 = alloca %struct.SB, align 8
  %3 = and i64 %0, 1
  %4 = icmp ne i64 %3, 0
  %5 = icmp eq i64 %0, 0
  %6 = or i1 %5, %4
  br i1 %6, label %11, label %7

7:                                                ; preds = %1
  %8 = inttoptr i64 %0 to ptr
  %9 = load i64, ptr %8, align 8, !tbaa !23
  %10 = icmp eq i64 %9, 4
  br i1 %10, label %22, label %11

11:                                               ; preds = %1, %7
  call void @llvm.lifetime.start.p0(ptr nonnull %2) #35
  %12 = getelementptr inbounds nuw i8, ptr %2, i64 8
  store <2 x i64> <i64 0, i64 64>, ptr %12, align 8, !tbaa !11
  %13 = tail call dereferenceable_or_null(64) ptr @calloc(i64 noundef 1, i64 noundef 64) #33
  %14 = icmp eq ptr %13, null
  br i1 %14, label %15, label %18

15:                                               ; preds = %11
  %16 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %17 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %16)
  tail call void @exit(i32 noundef 1) #34
  unreachable

18:                                               ; preds = %11
  store ptr %13, ptr %2, align 8, !tbaa !61
  call fastcc void @to_sb(ptr noundef %2, i64 noundef %0, i32 noundef 0)
  %19 = load ptr, ptr %2, align 8, !tbaa !61
  %20 = load i64, ptr %12, align 8, !tbaa !63
  %21 = call fastcc i64 @mkstr(ptr noundef %19, i64 noundef %20)
  call void @llvm.lifetime.end.p0(ptr nonnull %2) #35
  br label %22

22:                                               ; preds = %7, %18
  %23 = phi i64 [ %21, %18 ], [ %0, %7 ]
  ret i64 %23
}

; Function Attrs: nofree nounwind ssp uwtable(sync)
define nonnull ptr @rt_try_push() local_unnamed_addr #0 {
  %1 = load i64, ptr @nh, align 8, !tbaa !11
  %2 = icmp sgt i64 %1, 1023
  br i1 %2, label %3, label %6

3:                                                ; preds = %0
  %4 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %5 = tail call i64 @fwrite(ptr nonnull @.str.5, i64 27, i64 1, ptr %4)
  tail call void @exit(i32 noundef 1) #34
  unreachable

6:                                                ; preds = %0
  %7 = add nsw i64 %1, 1
  store i64 %7, ptr @nh, align 8, !tbaa !11
  %8 = getelementptr inbounds [48 x i32], ptr @jbs, i64 %1
  ret ptr %8
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind ssp willreturn memory(readwrite, argmem: none, inaccessiblemem: none, target_mem0: none, target_mem1: none) uwtable(sync)
define void @rt_try_pop() local_unnamed_addr #9 {
  %1 = load i64, ptr @nh, align 8, !tbaa !11
  %2 = icmp sgt i64 %1, 0
  br i1 %2, label %3, label %5

3:                                                ; preds = %0
  %4 = add nsw i64 %1, -1
  store i64 %4, ptr @nh, align 8, !tbaa !11
  br label %5

5:                                                ; preds = %3, %0
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind ssp willreturn memory(read, argmem: none, inaccessiblemem: none, target_mem0: none, target_mem1: none) uwtable(sync)
define i64 @rt_exc_cur() local_unnamed_addr #10 {
  %1 = load i64, ptr @cur_exc, align 8, !tbaa !11
  ret i64 %1
}

; Function Attrs: nofree nosync nounwind ssp memory(read, inaccessiblemem: none, target_mem0: none, target_mem1: none) uwtable(sync)
define range(i64 0, 2) i64 @rt_exc_match(i64 noundef %0, i64 noundef %1) local_unnamed_addr #11 {
  %3 = and i64 %1, 1
  %4 = icmp ne i64 %3, 0
  %5 = icmp eq i64 %1, 0
  %6 = or i1 %5, %4
  br i1 %6, label %27, label %7

7:                                                ; preds = %2
  %8 = inttoptr i64 %1 to ptr
  %9 = load i64, ptr %8, align 8, !tbaa !23
  %10 = icmp eq i64 %9, 6
  br i1 %10, label %11, label %27

11:                                               ; preds = %7
  %12 = getelementptr inbounds nuw i8, ptr %8, i64 8
  %13 = load i64, ptr %12, align 8, !tbaa !27
  %14 = icmp sgt i64 %13, 0
  br i1 %14, label %15, label %57

15:                                               ; preds = %11
  %16 = getelementptr inbounds nuw i8, ptr %8, i64 24
  %17 = load ptr, ptr %16, align 8, !tbaa !32
  br label %21

18:                                               ; preds = %21
  %19 = add nuw nsw i64 %22, 1
  %20 = icmp eq i64 %19, %13
  br i1 %20, label %57, label %21, !llvm.loop !64

21:                                               ; preds = %15, %18
  %22 = phi i64 [ 0, %15 ], [ %19, %18 ]
  %23 = getelementptr inbounds nuw i64, ptr %17, i64 %22
  %24 = load i64, ptr %23, align 8, !tbaa !11
  %25 = tail call i64 @rt_exc_match(i64 noundef %0, i64 noundef %24)
  %26 = icmp eq i64 %25, 0
  br i1 %26, label %18, label %57

27:                                               ; preds = %2, %7
  %28 = and i64 %0, 1
  %29 = icmp ne i64 %28, 0
  %30 = icmp eq i64 %0, 0
  %31 = or i1 %30, %29
  br i1 %31, label %57, label %32

32:                                               ; preds = %27
  %33 = inttoptr i64 %0 to ptr
  %34 = load i64, ptr %33, align 8, !tbaa !23
  %35 = icmp eq i64 %34, 12
  br i1 %35, label %36, label %57

36:                                               ; preds = %32
  %37 = getelementptr inbounds nuw i8, ptr %33, i64 8
  %38 = load i64, ptr %37, align 8, !tbaa !11
  %39 = icmp ne i64 %38, 0
  %40 = and i64 %38, 1
  %41 = icmp eq i64 %40, 0
  %42 = and i1 %39, %41
  br i1 %42, label %43, label %57

43:                                               ; preds = %36, %50
  %44 = phi i64 [ %52, %50 ], [ %38, %36 ]
  %45 = inttoptr i64 %44 to ptr
  %46 = load i64, ptr %45, align 8, !tbaa !23
  %47 = icmp eq i64 %46, 11
  br i1 %47, label %48, label %57

48:                                               ; preds = %43
  %49 = icmp eq i64 %44, %1
  br i1 %49, label %57, label %50

50:                                               ; preds = %48
  %51 = getelementptr inbounds nuw i8, ptr %45, i64 16
  %52 = load i64, ptr %51, align 8, !tbaa !11
  %53 = icmp ne i64 %52, 0
  %54 = and i64 %52, 1
  %55 = icmp eq i64 %54, 0
  %56 = and i1 %53, %55
  br i1 %56, label %43, label %57, !llvm.loop !65

57:                                               ; preds = %18, %21, %50, %48, %43, %11, %36, %32, %27
  %58 = phi i64 [ 0, %36 ], [ 0, %43 ], [ 0, %32 ], [ 0, %27 ], [ 0, %11 ], [ 1, %48 ], [ 0, %50 ], [ 1, %21 ], [ 0, %18 ]
  ret i64 %58
}

; Function Attrs: nofree norecurse nosync nounwind ssp memory(read, inaccessiblemem: none, target_mem0: none, target_mem1: none) uwtable(sync)
define internal fastcc range(i64 0, 2) i64 @inst_of(i64 noundef %0, i64 noundef %1) unnamed_addr #12 {
  %3 = and i64 %0, 1
  %4 = icmp ne i64 %3, 0
  %5 = icmp eq i64 %0, 0
  %6 = or i1 %5, %4
  br i1 %6, label %32, label %7

7:                                                ; preds = %2
  %8 = inttoptr i64 %0 to ptr
  %9 = load i64, ptr %8, align 8, !tbaa !23
  %10 = icmp eq i64 %9, 12
  br i1 %10, label %11, label %32

11:                                               ; preds = %7
  %12 = getelementptr inbounds nuw i8, ptr %8, i64 8
  %13 = load i64, ptr %12, align 8, !tbaa !11
  %14 = icmp ne i64 %13, 0
  %15 = and i64 %13, 1
  %16 = icmp eq i64 %15, 0
  %17 = and i1 %14, %16
  br i1 %17, label %18, label %32

18:                                               ; preds = %11, %25
  %19 = phi i64 [ %27, %25 ], [ %13, %11 ]
  %20 = inttoptr i64 %19 to ptr
  %21 = load i64, ptr %20, align 8, !tbaa !23
  %22 = icmp eq i64 %21, 11
  br i1 %22, label %23, label %32

23:                                               ; preds = %18
  %24 = icmp eq i64 %19, %1
  br i1 %24, label %32, label %25

25:                                               ; preds = %23
  %26 = getelementptr inbounds nuw i8, ptr %20, i64 16
  %27 = load i64, ptr %26, align 8, !tbaa !11
  %28 = icmp ne i64 %27, 0
  %29 = and i64 %27, 1
  %30 = icmp eq i64 %29, 0
  %31 = and i1 %28, %30
  br i1 %31, label %18, label %32, !llvm.loop !65

32:                                               ; preds = %18, %25, %23, %11, %2, %7
  %33 = phi i64 [ 0, %7 ], [ 0, %2 ], [ 0, %11 ], [ 0, %18 ], [ 0, %25 ], [ 1, %23 ]
  ret i64 %33
}

; Function Attrs: noreturn nounwind ssp uwtable(sync)
define noundef i64 @rt_assert_fail(i64 noundef %0) local_unnamed_addr #5 {
  %2 = load i32, ptr @nexc, align 4, !tbaa !6
  %3 = icmp sgt i32 %2, 0
  br i1 %3, label %4, label %15

4:                                                ; preds = %1
  %5 = zext nneg i32 %2 to i64
  br label %9

6:                                                ; preds = %9
  %7 = add nuw nsw i64 %10, 1
  %8 = icmp eq i64 %7, %5
  br i1 %8, label %15, label %9, !llvm.loop !66

9:                                                ; preds = %6, %4
  %10 = phi i64 [ 0, %4 ], [ %7, %6 ]
  %11 = getelementptr inbounds nuw ptr, ptr @exc_nm, i64 %10
  %12 = load ptr, ptr %11, align 8, !tbaa !67
  %13 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %12, ptr noundef nonnull dereferenceable(15) @.str.6) #35
  %14 = icmp eq i32 %13, 0
  br i1 %14, label %18, label %6

15:                                               ; preds = %6, %1
  %16 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %17 = tail call i32 (ptr, ptr, ...) @fprintf(ptr noundef %16, ptr noundef nonnull @.str.109, ptr noundef nonnull @.str.6) #35
  tail call void @exit(i32 noundef 2) #34
  unreachable

18:                                               ; preds = %9
  %19 = getelementptr inbounds nuw i64, ptr @exc_cls, i64 %10
  %20 = load i64, ptr %19, align 8, !tbaa !11
  %21 = tail call fastcc i64 @new_inst(i64 noundef %20)
  %22 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  %23 = icmp ne i64 %0, %22
  %24 = zext i1 %23 to i64
  %25 = tail call fastcc i64 @mktuple(i64 noundef %24)
  %26 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  %27 = icmp eq i64 %0, %26
  br i1 %27, label %32, label %28

28:                                               ; preds = %18
  %29 = inttoptr i64 %25 to ptr
  %30 = getelementptr inbounds nuw i8, ptr %29, i64 24
  %31 = load ptr, ptr %30, align 8, !tbaa !32
  store i64 %0, ptr %31, align 8, !tbaa !11
  br label %32

32:                                               ; preds = %28, %18
  %33 = inttoptr i64 %21 to ptr
  %34 = getelementptr inbounds nuw i8, ptr %33, i64 16
  %35 = load i64, ptr %34, align 8, !tbaa !39
  %36 = inttoptr i64 %35 to ptr
  %37 = load i64, ptr @K_args, align 8, !tbaa !11
  tail call fastcc void @dict_set(ptr noundef %36, i64 noundef %37, i64 noundef %25)
  %38 = tail call i64 @rt_raise(i64 noundef %21)
  unreachable
}

; Function Attrs: nofree nounwind ssp uwtable(sync)
define internal fastcc noundef i64 @new_inst(i64 noundef %0) unnamed_addr #0 {
  %2 = tail call dereferenceable_or_null(24) ptr @calloc(i64 noundef 1, i64 noundef 24) #33
  %3 = icmp eq ptr %2, null
  br i1 %3, label %4, label %7

4:                                                ; preds = %1
  %5 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %6 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %5)
  tail call void @exit(i32 noundef 1) #34
  unreachable

7:                                                ; preds = %1
  store i64 12, ptr %2, align 8, !tbaa !37
  %8 = getelementptr inbounds nuw i8, ptr %2, i64 8
  store i64 %0, ptr %8, align 8, !tbaa !42
  %9 = tail call dereferenceable_or_null(56) ptr @calloc(i64 noundef 1, i64 noundef 56) #33
  %10 = icmp eq ptr %9, null
  br i1 %10, label %11, label %14

11:                                               ; preds = %7
  %12 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %13 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %12)
  tail call void @exit(i32 noundef 1) #34
  unreachable

14:                                               ; preds = %7
  store i64 7, ptr %9, align 8, !tbaa !68
  %15 = ptrtoint ptr %9 to i64
  %16 = getelementptr inbounds nuw i8, ptr %2, i64 16
  store i64 %15, ptr %16, align 8, !tbaa !39
  %17 = ptrtoint ptr %2 to i64
  ret i64 %17
}

; Function Attrs: nofree nounwind ssp uwtable(sync)
define internal fastcc i64 @exc_by_name(ptr noundef %0) unnamed_addr #0 {
  %2 = load i32, ptr @nexc, align 4, !tbaa !6
  %3 = icmp sgt i32 %2, 0
  br i1 %3, label %4, label %15

4:                                                ; preds = %1
  %5 = zext nneg i32 %2 to i64
  br label %9

6:                                                ; preds = %9
  %7 = add nuw nsw i64 %10, 1
  %8 = icmp eq i64 %7, %5
  br i1 %8, label %15, label %9, !llvm.loop !66

9:                                                ; preds = %4, %6
  %10 = phi i64 [ 0, %4 ], [ %7, %6 ]
  %11 = getelementptr inbounds nuw ptr, ptr @exc_nm, i64 %10
  %12 = load ptr, ptr %11, align 8, !tbaa !67
  %13 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %12, ptr noundef nonnull dereferenceable(1) %0) #35
  %14 = icmp eq i32 %13, 0
  br i1 %14, label %18, label %6

15:                                               ; preds = %6, %1
  %16 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %17 = tail call i32 (ptr, ptr, ...) @fprintf(ptr noundef %16, ptr noundef nonnull @.str.109, ptr noundef %0) #35
  tail call void @exit(i32 noundef 2) #34
  unreachable

18:                                               ; preds = %9
  %19 = getelementptr inbounds nuw i64, ptr @exc_cls, i64 %10
  %20 = load i64, ptr %19, align 8, !tbaa !11
  ret i64 %20
}

; Function Attrs: nofree nounwind ssp uwtable(sync)
define internal fastcc noundef i64 @mktuple(i64 noundef %0) unnamed_addr #0 {
  %2 = tail call dereferenceable_or_null(32) ptr @calloc(i64 noundef 1, i64 noundef 32) #33
  %3 = icmp eq ptr %2, null
  br i1 %3, label %4, label %7

4:                                                ; preds = %1
  %5 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %6 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %5)
  tail call void @exit(i32 noundef 1) #34
  unreachable

7:                                                ; preds = %1
  store i64 6, ptr %2, align 8, !tbaa !69
  %8 = getelementptr inbounds nuw i8, ptr %2, i64 8
  store i64 %0, ptr %8, align 8, !tbaa !27
  %9 = getelementptr inbounds nuw i8, ptr %2, i64 16
  store i64 %0, ptr %9, align 8, !tbaa !70
  %10 = tail call i64 @llvm.umax.i64(i64 %0, i64 1)
  %11 = shl i64 %10, 3
  %12 = tail call i64 @llvm.umax.i64(i64 %11, i64 1)
  %13 = tail call ptr @calloc(i64 noundef 1, i64 noundef %12) #33
  %14 = icmp eq ptr %13, null
  br i1 %14, label %15, label %18

15:                                               ; preds = %7
  %16 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %17 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %16)
  tail call void @exit(i32 noundef 1) #34
  unreachable

18:                                               ; preds = %7
  %19 = getelementptr inbounds nuw i8, ptr %2, i64 24
  store ptr %13, ptr %19, align 8, !tbaa !32
  %20 = ptrtoint ptr %2 to i64
  ret i64 %20
}

; Function Attrs: nounwind ssp uwtable(sync)
define internal fastcc void @dict_set(ptr noundef captures(none) %0, i64 noundef %1, i64 noundef %2) unnamed_addr #2 {
  %4 = tail call fastcc i64 @hash_v(i64 noundef %1)
  %5 = getelementptr inbounds nuw i8, ptr %0, i64 40
  %6 = load i64, ptr %5, align 8, !tbaa !40
  %7 = icmp eq i64 %6, 0
  br i1 %7, label %46, label %8

8:                                                ; preds = %3
  %9 = add nsw i64 %6, -1
  %10 = getelementptr inbounds nuw i8, ptr %0, i64 48
  %11 = and i64 %4, %9
  %12 = load ptr, ptr %10, align 8, !tbaa !41
  %13 = getelementptr inbounds i64, ptr %12, i64 %11
  %14 = load i64, ptr %13, align 8, !tbaa !11
  %15 = icmp slt i64 %14, 0
  br i1 %15, label %46, label %16

16:                                               ; preds = %8
  %17 = getelementptr inbounds nuw i8, ptr %0, i64 32
  br label %18

18:                                               ; preds = %16, %37
  %19 = phi ptr [ %12, %16 ], [ %38, %37 ]
  %20 = phi i64 [ %14, %16 ], [ %42, %37 ]
  %21 = phi i64 [ %11, %16 ], [ %40, %37 ]
  %22 = load ptr, ptr %17, align 8, !tbaa !36
  %23 = getelementptr inbounds nuw %struct.Ent, ptr %22, i64 %20
  %24 = load i64, ptr %23, align 8, !tbaa !37
  %25 = icmp eq i64 %24, 0
  br i1 %25, label %37, label %26

26:                                               ; preds = %18
  %27 = getelementptr inbounds nuw i8, ptr %23, i64 16
  %28 = load i64, ptr %27, align 8, !tbaa !39
  %29 = icmp eq i64 %28, %4
  br i1 %29, label %30, label %37

30:                                               ; preds = %26
  %31 = icmp eq i64 %24, %1
  br i1 %31, label %44, label %32

32:                                               ; preds = %30
  %33 = tail call i64 @rt_eq_i(i64 noundef %24, i64 noundef %1)
  %34 = icmp eq i64 %33, 0
  br i1 %34, label %35, label %44

35:                                               ; preds = %32
  %36 = load ptr, ptr %10, align 8, !tbaa !41
  br label %37

37:                                               ; preds = %35, %18, %26
  %38 = phi ptr [ %36, %35 ], [ %19, %18 ], [ %19, %26 ]
  %39 = add nuw nsw i64 %21, 1
  %40 = and i64 %39, %9
  %41 = getelementptr inbounds i64, ptr %38, i64 %40
  %42 = load i64, ptr %41, align 8, !tbaa !11
  %43 = icmp slt i64 %42, 0
  br i1 %43, label %46, label %18

44:                                               ; preds = %30, %32
  %45 = getelementptr inbounds nuw i8, ptr %23, i64 8
  store i64 %2, ptr %45, align 8, !tbaa !42
  br label %240

46:                                               ; preds = %37, %8, %3
  %47 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %48 = load i64, ptr %47, align 8, !tbaa !35
  %49 = getelementptr inbounds nuw i8, ptr %0, i64 24
  %50 = load i64, ptr %49, align 8, !tbaa !71
  %51 = icmp slt i64 %48, %50
  br i1 %51, label %52, label %60

52:                                               ; preds = %46
  %53 = getelementptr inbounds nuw i8, ptr %0, i64 32
  %54 = load ptr, ptr %53, align 8, !tbaa !36
  %55 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %56 = load i64, ptr %55, align 8, !tbaa !33
  %57 = load i64, ptr %5, align 8, !tbaa !40
  %58 = getelementptr inbounds nuw i8, ptr %0, i64 48
  %59 = load ptr, ptr %58, align 8, !tbaa !41
  br label %218

60:                                               ; preds = %46
  %61 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %62 = load i64, ptr %61, align 8, !tbaa !33
  %63 = tail call i64 @llvm.smax.i64(i64 %62, i64 4)
  %64 = shl nuw i64 %63, 1
  %65 = mul i64 %63, 48
  %66 = tail call i64 @llvm.umax.i64(i64 %65, i64 1)
  %67 = tail call ptr @calloc(i64 noundef 1, i64 noundef %66) #33
  %68 = icmp eq ptr %67, null
  br i1 %68, label %78, label %69

69:                                               ; preds = %60
  %70 = icmp sgt i64 %48, 0
  br i1 %70, label %71, label %102

71:                                               ; preds = %69
  %72 = getelementptr inbounds nuw i8, ptr %0, i64 32
  %73 = load ptr, ptr %72, align 8, !tbaa !36
  %74 = and i64 %48, 7
  %75 = icmp ult i64 %48, 8
  br i1 %75, label %83, label %76

76:                                               ; preds = %71
  %77 = and i64 %48, 9223372036854775800
  br label %105

78:                                               ; preds = %60
  %79 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %80 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %79)
  tail call void @exit(i32 noundef 1) #34
  unreachable

81:                                               ; preds = %178
  %82 = icmp eq i64 %74, 0
  br i1 %82, label %102, label %83

83:                                               ; preds = %81, %71
  %84 = phi i64 [ 0, %71 ], [ %179, %81 ]
  %85 = phi i64 [ 0, %71 ], [ %180, %81 ]
  %86 = icmp ne i64 %74, 0
  tail call void @llvm.assume(i1 %86)
  br label %87

87:                                               ; preds = %97, %83
  %88 = phi i64 [ %84, %83 ], [ %98, %97 ]
  %89 = phi i64 [ %85, %83 ], [ %99, %97 ]
  %90 = phi i64 [ 0, %83 ], [ %100, %97 ]
  %91 = getelementptr inbounds nuw %struct.Ent, ptr %73, i64 %89
  %92 = load i64, ptr %91, align 8, !tbaa !37
  %93 = icmp eq i64 %92, 0
  br i1 %93, label %97, label %94

94:                                               ; preds = %87
  %95 = add nsw i64 %88, 1
  %96 = getelementptr inbounds %struct.Ent, ptr %67, i64 %88
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %96, ptr noundef nonnull align 8 dereferenceable(24) %91, i64 24, i1 false), !tbaa.struct !72
  br label %97

97:                                               ; preds = %94, %87
  %98 = phi i64 [ %95, %94 ], [ %88, %87 ]
  %99 = add nuw nsw i64 %89, 1
  %100 = add i64 %90, 1
  %101 = icmp eq i64 %100, %74
  br i1 %101, label %102, label %87, !llvm.loop !73

102:                                              ; preds = %81, %97, %69
  %103 = phi i64 [ 0, %69 ], [ %179, %81 ], [ %98, %97 ]
  %104 = shl nuw i64 %63, 2
  br label %183

105:                                              ; preds = %178, %76
  %106 = phi i64 [ 0, %76 ], [ %179, %178 ]
  %107 = phi i64 [ 0, %76 ], [ %180, %178 ]
  %108 = phi i64 [ 0, %76 ], [ %181, %178 ]
  %109 = getelementptr inbounds nuw %struct.Ent, ptr %73, i64 %107
  %110 = load i64, ptr %109, align 8, !tbaa !37
  %111 = icmp eq i64 %110, 0
  br i1 %111, label %115, label %112

112:                                              ; preds = %105
  %113 = add nsw i64 %106, 1
  %114 = getelementptr inbounds %struct.Ent, ptr %67, i64 %106
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %114, ptr noundef nonnull align 8 dereferenceable(24) %109, i64 24, i1 false), !tbaa.struct !72
  br label %115

115:                                              ; preds = %112, %105
  %116 = phi i64 [ %113, %112 ], [ %106, %105 ]
  %117 = getelementptr inbounds nuw %struct.Ent, ptr %73, i64 %107
  %118 = getelementptr inbounds nuw i8, ptr %117, i64 24
  %119 = load i64, ptr %118, align 8, !tbaa !37
  %120 = icmp eq i64 %119, 0
  br i1 %120, label %124, label %121

121:                                              ; preds = %115
  %122 = add nsw i64 %116, 1
  %123 = getelementptr inbounds %struct.Ent, ptr %67, i64 %116
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %123, ptr noundef nonnull align 8 dereferenceable(24) %118, i64 24, i1 false), !tbaa.struct !72
  br label %124

124:                                              ; preds = %121, %115
  %125 = phi i64 [ %122, %121 ], [ %116, %115 ]
  %126 = getelementptr inbounds nuw %struct.Ent, ptr %73, i64 %107
  %127 = getelementptr inbounds nuw i8, ptr %126, i64 48
  %128 = load i64, ptr %127, align 8, !tbaa !37
  %129 = icmp eq i64 %128, 0
  br i1 %129, label %133, label %130

130:                                              ; preds = %124
  %131 = add nsw i64 %125, 1
  %132 = getelementptr inbounds %struct.Ent, ptr %67, i64 %125
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %132, ptr noundef nonnull align 8 dereferenceable(24) %127, i64 24, i1 false), !tbaa.struct !72
  br label %133

133:                                              ; preds = %130, %124
  %134 = phi i64 [ %131, %130 ], [ %125, %124 ]
  %135 = getelementptr inbounds nuw %struct.Ent, ptr %73, i64 %107
  %136 = getelementptr inbounds nuw i8, ptr %135, i64 72
  %137 = load i64, ptr %136, align 8, !tbaa !37
  %138 = icmp eq i64 %137, 0
  br i1 %138, label %142, label %139

139:                                              ; preds = %133
  %140 = add nsw i64 %134, 1
  %141 = getelementptr inbounds %struct.Ent, ptr %67, i64 %134
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %141, ptr noundef nonnull align 8 dereferenceable(24) %136, i64 24, i1 false), !tbaa.struct !72
  br label %142

142:                                              ; preds = %139, %133
  %143 = phi i64 [ %140, %139 ], [ %134, %133 ]
  %144 = getelementptr inbounds nuw %struct.Ent, ptr %73, i64 %107
  %145 = getelementptr inbounds nuw i8, ptr %144, i64 96
  %146 = load i64, ptr %145, align 8, !tbaa !37
  %147 = icmp eq i64 %146, 0
  br i1 %147, label %151, label %148

148:                                              ; preds = %142
  %149 = add nsw i64 %143, 1
  %150 = getelementptr inbounds %struct.Ent, ptr %67, i64 %143
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %150, ptr noundef nonnull align 8 dereferenceable(24) %145, i64 24, i1 false), !tbaa.struct !72
  br label %151

151:                                              ; preds = %148, %142
  %152 = phi i64 [ %149, %148 ], [ %143, %142 ]
  %153 = getelementptr inbounds nuw %struct.Ent, ptr %73, i64 %107
  %154 = getelementptr inbounds nuw i8, ptr %153, i64 120
  %155 = load i64, ptr %154, align 8, !tbaa !37
  %156 = icmp eq i64 %155, 0
  br i1 %156, label %160, label %157

157:                                              ; preds = %151
  %158 = add nsw i64 %152, 1
  %159 = getelementptr inbounds %struct.Ent, ptr %67, i64 %152
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %159, ptr noundef nonnull align 8 dereferenceable(24) %154, i64 24, i1 false), !tbaa.struct !72
  br label %160

160:                                              ; preds = %157, %151
  %161 = phi i64 [ %158, %157 ], [ %152, %151 ]
  %162 = getelementptr inbounds nuw %struct.Ent, ptr %73, i64 %107
  %163 = getelementptr inbounds nuw i8, ptr %162, i64 144
  %164 = load i64, ptr %163, align 8, !tbaa !37
  %165 = icmp eq i64 %164, 0
  br i1 %165, label %169, label %166

166:                                              ; preds = %160
  %167 = add nsw i64 %161, 1
  %168 = getelementptr inbounds %struct.Ent, ptr %67, i64 %161
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %168, ptr noundef nonnull align 8 dereferenceable(24) %163, i64 24, i1 false), !tbaa.struct !72
  br label %169

169:                                              ; preds = %166, %160
  %170 = phi i64 [ %167, %166 ], [ %161, %160 ]
  %171 = getelementptr inbounds nuw %struct.Ent, ptr %73, i64 %107
  %172 = getelementptr inbounds nuw i8, ptr %171, i64 168
  %173 = load i64, ptr %172, align 8, !tbaa !37
  %174 = icmp eq i64 %173, 0
  br i1 %174, label %178, label %175

175:                                              ; preds = %169
  %176 = add nsw i64 %170, 1
  %177 = getelementptr inbounds %struct.Ent, ptr %67, i64 %170
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %177, ptr noundef nonnull align 8 dereferenceable(24) %172, i64 24, i1 false), !tbaa.struct !72
  br label %178

178:                                              ; preds = %175, %169
  %179 = phi i64 [ %176, %175 ], [ %170, %169 ]
  %180 = add nuw nsw i64 %107, 8
  %181 = add i64 %108, 8
  %182 = icmp eq i64 %181, %77
  br i1 %182, label %81, label %105, !llvm.loop !75

183:                                              ; preds = %183, %102
  %184 = phi i64 [ %186, %183 ], [ 8, %102 ]
  %185 = icmp slt i64 %184, %104
  %186 = shl i64 %184, 1
  br i1 %185, label %183, label %187, !llvm.loop !76

187:                                              ; preds = %183
  %188 = shl i64 %184, 3
  %189 = tail call i64 @llvm.umax.i64(i64 %188, i64 1)
  %190 = tail call ptr @calloc(i64 noundef 1, i64 noundef %189) #33
  %191 = icmp eq ptr %190, null
  br i1 %191, label %192, label %195

192:                                              ; preds = %187
  %193 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %194 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %193)
  tail call void @exit(i32 noundef 1) #34
  unreachable

195:                                              ; preds = %187
  tail call void @llvm.memset.p0.i64(ptr nonnull align 8 %190, i8 -1, i64 %188, i1 false), !tbaa !11
  %196 = icmp sgt i64 %103, 0
  br i1 %196, label %197, label %215

197:                                              ; preds = %195
  %198 = add nsw i64 %184, -1
  br label %199

199:                                              ; preds = %211, %197
  %200 = phi i64 [ 0, %197 ], [ %213, %211 ]
  %201 = getelementptr inbounds nuw %struct.Ent, ptr %67, i64 %200
  %202 = getelementptr inbounds nuw i8, ptr %201, i64 16
  %203 = load i64, ptr %202, align 8, !tbaa !39
  br label %204

204:                                              ; preds = %204, %199
  %205 = phi i64 [ %203, %199 ], [ %210, %204 ]
  %206 = and i64 %205, %198
  %207 = getelementptr inbounds nuw i64, ptr %190, i64 %206
  %208 = load i64, ptr %207, align 8, !tbaa !11
  %209 = icmp eq i64 %208, -1
  %210 = add nuw nsw i64 %206, 1
  br i1 %209, label %211, label %204, !llvm.loop !77

211:                                              ; preds = %204
  %212 = getelementptr inbounds nuw i64, ptr %190, i64 %206
  store i64 %200, ptr %212, align 8, !tbaa !11
  %213 = add nuw nsw i64 %200, 1
  %214 = icmp eq i64 %213, %103
  br i1 %214, label %215, label %199, !llvm.loop !78

215:                                              ; preds = %211, %195
  %216 = getelementptr inbounds nuw i8, ptr %0, i64 32
  store ptr %67, ptr %216, align 8, !tbaa !36
  store i64 %64, ptr %49, align 8, !tbaa !71
  %217 = getelementptr inbounds nuw i8, ptr %0, i64 48
  store ptr %190, ptr %217, align 8, !tbaa !41
  store i64 %184, ptr %5, align 8, !tbaa !40
  br label %218

218:                                              ; preds = %52, %215
  %219 = phi ptr [ %190, %215 ], [ %59, %52 ]
  %220 = phi i64 [ %184, %215 ], [ %57, %52 ]
  %221 = phi i64 [ %62, %215 ], [ %56, %52 ]
  %222 = phi ptr [ %67, %215 ], [ %54, %52 ]
  %223 = phi i64 [ %103, %215 ], [ %48, %52 ]
  %224 = add nsw i64 %223, 1
  store i64 %224, ptr %47, align 8, !tbaa !35
  %225 = getelementptr inbounds %struct.Ent, ptr %222, i64 %223
  store i64 %1, ptr %225, align 8, !tbaa !37
  %226 = getelementptr inbounds nuw i8, ptr %225, i64 8
  store i64 %2, ptr %226, align 8, !tbaa !42
  %227 = getelementptr inbounds nuw i8, ptr %225, i64 16
  store i64 %4, ptr %227, align 8, !tbaa !39
  %228 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %229 = add nsw i64 %221, 1
  store i64 %229, ptr %228, align 8, !tbaa !33
  %230 = add nsw i64 %220, -1
  br label %231

231:                                              ; preds = %231, %218
  %232 = phi i64 [ %4, %218 ], [ %237, %231 ]
  %233 = and i64 %232, %230
  %234 = getelementptr inbounds i64, ptr %219, i64 %233
  %235 = load i64, ptr %234, align 8, !tbaa !11
  %236 = icmp eq i64 %235, -1
  %237 = add nsw i64 %233, 1
  br i1 %236, label %238, label %231, !llvm.loop !79

238:                                              ; preds = %231
  %239 = getelementptr inbounds i64, ptr %219, i64 %233
  store i64 %223, ptr %239, align 8, !tbaa !11
  br label %240

240:                                              ; preds = %238, %44
  ret void
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @b_exc_init(i64 noundef %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = ptrtoint ptr %1 to i64
  %4 = add nsw i64 %0, -1
  %5 = tail call fastcc i64 @mktuple(i64 noundef %4)
  %6 = icmp sgt i64 %0, 1
  br i1 %6, label %7, label %43

7:                                                ; preds = %2
  %8 = inttoptr i64 %5 to ptr
  %9 = getelementptr inbounds nuw i8, ptr %8, i64 24
  %10 = load ptr, ptr %9, align 8, !tbaa !32
  %11 = add nsw i64 %0, -1
  %12 = icmp ult i64 %0, 9
  br i1 %12, label %41, label %13

13:                                               ; preds = %7
  %14 = ptrtoint ptr %10 to i64
  %15 = add i64 %14, -8
  %16 = sub i64 %15, %3
  %17 = icmp ult i64 %16, 64
  br i1 %17, label %41, label %18

18:                                               ; preds = %13
  %19 = and i64 %11, -8
  %20 = or disjoint i64 %19, 1
  br label %21

21:                                               ; preds = %21, %18
  %22 = phi i64 [ 0, %18 ], [ %37, %21 ]
  %23 = or disjoint i64 %22, 1
  %24 = getelementptr inbounds nuw i64, ptr %1, i64 %23
  %25 = getelementptr inbounds nuw i8, ptr %24, i64 16
  %26 = getelementptr inbounds nuw i8, ptr %24, i64 32
  %27 = getelementptr inbounds nuw i8, ptr %24, i64 48
  %28 = load <2 x i64>, ptr %24, align 8, !tbaa !11
  %29 = load <2 x i64>, ptr %25, align 8, !tbaa !11
  %30 = load <2 x i64>, ptr %26, align 8, !tbaa !11
  %31 = load <2 x i64>, ptr %27, align 8, !tbaa !11
  %32 = getelementptr i64, ptr %10, i64 %23
  %33 = getelementptr i8, ptr %32, i64 -8
  %34 = getelementptr i8, ptr %32, i64 8
  %35 = getelementptr i8, ptr %32, i64 24
  %36 = getelementptr i8, ptr %32, i64 40
  store <2 x i64> %28, ptr %33, align 8, !tbaa !11
  store <2 x i64> %29, ptr %34, align 8, !tbaa !11
  store <2 x i64> %30, ptr %35, align 8, !tbaa !11
  store <2 x i64> %31, ptr %36, align 8, !tbaa !11
  %37 = add nuw i64 %22, 8
  %38 = icmp eq i64 %37, %19
  br i1 %38, label %39, label %21, !llvm.loop !80

39:                                               ; preds = %21
  %40 = icmp eq i64 %11, %19
  br i1 %40, label %43, label %41

41:                                               ; preds = %13, %7, %39
  %42 = phi i64 [ 1, %13 ], [ 1, %7 ], [ %20, %39 ]
  br label %51

43:                                               ; preds = %51, %39, %2
  %44 = load i64, ptr %1, align 8, !tbaa !11
  %45 = inttoptr i64 %44 to ptr
  %46 = getelementptr inbounds nuw i8, ptr %45, i64 16
  %47 = load i64, ptr %46, align 8, !tbaa !39
  %48 = inttoptr i64 %47 to ptr
  %49 = load i64, ptr @K_args, align 8, !tbaa !11
  tail call fastcc void @dict_set(ptr noundef %48, i64 noundef %49, i64 noundef %5)
  %50 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  ret i64 %50

51:                                               ; preds = %41, %51
  %52 = phi i64 [ %57, %51 ], [ %42, %41 ]
  %53 = getelementptr inbounds nuw i64, ptr %1, i64 %52
  %54 = load i64, ptr %53, align 8, !tbaa !11
  %55 = getelementptr i64, ptr %10, i64 %52
  %56 = getelementptr i8, ptr %55, i64 -8
  store i64 %54, ptr %56, align 8, !tbaa !11
  %57 = add nuw nsw i64 %52, 1
  %58 = icmp eq i64 %57, %0
  br i1 %58, label %43, label %51, !llvm.loop !81
}

; Function Attrs: nofree nounwind ssp uwtable(sync)
define internal fastcc void @sb_init(ptr noundef nonnull writeonly captures(none) initializes((8, 24)) %0) unnamed_addr #0 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store <2 x i64> <i64 0, i64 64>, ptr %2, align 8, !tbaa !11
  %3 = tail call dereferenceable_or_null(64) ptr @calloc(i64 noundef 1, i64 noundef 64) #33
  %4 = icmp eq ptr %3, null
  br i1 %4, label %5, label %8

5:                                                ; preds = %1
  %6 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %7 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %6)
  tail call void @exit(i32 noundef 1) #34
  unreachable

8:                                                ; preds = %1
  store ptr %3, ptr %0, align 8, !tbaa !61
  ret void
}

; Function Attrs: nounwind ssp uwtable(sync)
define internal fastcc void @to_sb(ptr noundef nonnull %0, i64 noundef %1, i32 noundef range(i32 0, 2) %2) unnamed_addr #2 {
  %4 = alloca [64 x i8], align 1
  %5 = alloca [1 x i64], align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %4) #35
  %6 = and i64 %1, 1
  %7 = icmp eq i64 %6, 0
  br i1 %7, label %36, label %8

8:                                                ; preds = %3
  %9 = ashr i64 %1, 1
  %10 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr nonnull dereferenceable(1) %4, i64 64, ptr nonnull @.str.58, i64 %9)
  %11 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %4) #35
  %12 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %13 = load i64, ptr %12, align 8, !tbaa !63
  %14 = add nsw i64 %13, %11
  %15 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %16 = load i64, ptr %15, align 8, !tbaa !82
  %17 = icmp slt i64 %14, %16
  br i1 %17, label %18, label %20

18:                                               ; preds = %8
  %19 = load ptr, ptr %0, align 8, !tbaa !61
  br label %28

20:                                               ; preds = %8, %20
  %21 = phi i64 [ %22, %20 ], [ %16, %8 ]
  %22 = shl nsw i64 %21, 1
  %23 = icmp sgt i64 %22, %14
  br i1 %23, label %24, label %20, !llvm.loop !83

24:                                               ; preds = %20
  %25 = load ptr, ptr %0, align 8, !tbaa !61
  %26 = tail call ptr @realloc(ptr noundef %25, i64 noundef %22) #38
  store ptr %26, ptr %0, align 8, !tbaa !61
  store i64 %22, ptr %15, align 8, !tbaa !82
  %27 = load i64, ptr %12, align 8, !tbaa !63
  br label %28

28:                                               ; preds = %18, %24
  %29 = phi i64 [ %13, %18 ], [ %27, %24 ]
  %30 = phi ptr [ %19, %18 ], [ %26, %24 ]
  %31 = getelementptr inbounds i8, ptr %30, i64 %29
  call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %31, ptr noundef nonnull readonly align 1 %4, i64 noundef %11, i1 noundef false) #35
  %32 = load i64, ptr %12, align 8, !tbaa !63
  %33 = add nsw i64 %32, %11
  store i64 %33, ptr %12, align 8, !tbaa !63
  %34 = load ptr, ptr %0, align 8, !tbaa !61
  %35 = getelementptr inbounds i8, ptr %34, i64 %33
  store i8 0, ptr %35, align 1, !tbaa !10
  br label %775

36:                                               ; preds = %3
  %37 = icmp eq i64 %1, 0
  br i1 %37, label %750, label %38

38:                                               ; preds = %36
  %39 = inttoptr i64 %1 to ptr
  %40 = load i64, ptr %39, align 8, !tbaa !23
  switch i64 %40, label %750 [
    i64 1, label %41
    i64 2, label %66
    i64 3, label %96
    i64 4, label %99
    i64 5, label %106
    i64 6, label %106
    i64 7, label %202
    i64 8, label %321
    i64 9, label %377
    i64 10, label %451
    i64 11, label %523
    i64 12, label %597
    i64 13, label %675
    i64 14, label %700
    i64 15, label %725
  ]

41:                                               ; preds = %38
  %42 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %43 = load i64, ptr %42, align 8, !tbaa !63
  %44 = add nsw i64 %43, 4
  %45 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %46 = load i64, ptr %45, align 8, !tbaa !82
  %47 = icmp slt i64 %44, %46
  br i1 %47, label %48, label %50

48:                                               ; preds = %41
  %49 = load ptr, ptr %0, align 8, !tbaa !61
  br label %58

50:                                               ; preds = %41, %50
  %51 = phi i64 [ %52, %50 ], [ %46, %41 ]
  %52 = shl nsw i64 %51, 1
  %53 = icmp sgt i64 %52, %44
  br i1 %53, label %54, label %50, !llvm.loop !83

54:                                               ; preds = %50
  %55 = load ptr, ptr %0, align 8, !tbaa !61
  %56 = tail call ptr @realloc(ptr noundef %55, i64 noundef %52) #38
  store ptr %56, ptr %0, align 8, !tbaa !61
  store i64 %52, ptr %45, align 8, !tbaa !82
  %57 = load i64, ptr %42, align 8, !tbaa !63
  br label %58

58:                                               ; preds = %48, %54
  %59 = phi i64 [ %43, %48 ], [ %57, %54 ]
  %60 = phi ptr [ %49, %48 ], [ %56, %54 ]
  %61 = getelementptr inbounds i8, ptr %60, i64 %59
  store i32 1701736270, ptr %61, align 1
  %62 = load i64, ptr %42, align 8, !tbaa !63
  %63 = add nsw i64 %62, 4
  store i64 %63, ptr %42, align 8, !tbaa !63
  %64 = load ptr, ptr %0, align 8, !tbaa !61
  %65 = getelementptr inbounds i8, ptr %64, i64 %63
  store i8 0, ptr %65, align 1, !tbaa !10
  br label %775

66:                                               ; preds = %38
  %67 = getelementptr inbounds nuw i8, ptr %39, i64 8
  %68 = load i64, ptr %67, align 8, !tbaa !25
  %69 = icmp eq i64 %68, 0
  %70 = select i1 %69, ptr @.str.113, ptr @.str.112
  %71 = select i1 %69, i64 5, i64 4
  %72 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %73 = load i64, ptr %72, align 8, !tbaa !63
  %74 = add nsw i64 %71, %73
  %75 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %76 = load i64, ptr %75, align 8, !tbaa !82
  %77 = icmp slt i64 %74, %76
  br i1 %77, label %78, label %80

78:                                               ; preds = %66
  %79 = load ptr, ptr %0, align 8, !tbaa !61
  br label %88

80:                                               ; preds = %66, %80
  %81 = phi i64 [ %82, %80 ], [ %76, %66 ]
  %82 = shl nsw i64 %81, 1
  %83 = icmp sgt i64 %82, %74
  br i1 %83, label %84, label %80, !llvm.loop !83

84:                                               ; preds = %80
  %85 = load ptr, ptr %0, align 8, !tbaa !61
  %86 = tail call ptr @realloc(ptr noundef %85, i64 noundef %82) #38
  store ptr %86, ptr %0, align 8, !tbaa !61
  store i64 %82, ptr %75, align 8, !tbaa !82
  %87 = load i64, ptr %72, align 8, !tbaa !63
  br label %88

88:                                               ; preds = %78, %84
  %89 = phi i64 [ %73, %78 ], [ %87, %84 ]
  %90 = phi ptr [ %79, %78 ], [ %86, %84 ]
  %91 = getelementptr inbounds i8, ptr %90, i64 %89
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(4) %91, ptr noundef nonnull readonly align 1 dereferenceable(4) %70, i64 noundef %71, i1 noundef false) #35
  %92 = load i64, ptr %72, align 8, !tbaa !63
  %93 = add nsw i64 %92, %71
  store i64 %93, ptr %72, align 8, !tbaa !63
  %94 = load ptr, ptr %0, align 8, !tbaa !61
  %95 = getelementptr inbounds i8, ptr %94, i64 %93
  store i8 0, ptr %95, align 1, !tbaa !10
  br label %775

96:                                               ; preds = %38
  %97 = getelementptr inbounds nuw i8, ptr %39, i64 8
  %98 = load double, ptr %97, align 8, !tbaa !22
  tail call fastcc void @fmt_float(ptr noundef %0, double noundef %98)
  br label %775

99:                                               ; preds = %38
  %100 = icmp eq i32 %2, 0
  br i1 %100, label %102, label %101

101:                                              ; preds = %99
  tail call fastcc void @repr_str(ptr noundef %0, ptr noundef nonnull %39)
  br label %775

102:                                              ; preds = %99
  %103 = getelementptr inbounds nuw i8, ptr %39, i64 16
  %104 = getelementptr inbounds nuw i8, ptr %39, i64 8
  %105 = load i64, ptr %104, align 8, !tbaa !18
  tail call fastcc void @sb_add(ptr noundef %0, ptr noundef nonnull %103, i64 noundef %105)
  br label %775

106:                                              ; preds = %38, %38
  %107 = icmp ne i64 %40, 6
  %108 = select i1 %107, i8 91, i8 40
  %109 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %110 = load i64, ptr %109, align 8, !tbaa !63
  %111 = add nsw i64 %110, 1
  %112 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %113 = load i64, ptr %112, align 8, !tbaa !82
  %114 = icmp slt i64 %111, %113
  br i1 %114, label %115, label %117

115:                                              ; preds = %106
  %116 = load ptr, ptr %0, align 8, !tbaa !61
  br label %125

117:                                              ; preds = %106, %117
  %118 = phi i64 [ %119, %117 ], [ %113, %106 ]
  %119 = shl nsw i64 %118, 1
  %120 = icmp sgt i64 %119, %111
  br i1 %120, label %121, label %117, !llvm.loop !83

121:                                              ; preds = %117
  %122 = load ptr, ptr %0, align 8, !tbaa !61
  %123 = tail call ptr @realloc(ptr noundef %122, i64 noundef %119) #38
  store ptr %123, ptr %0, align 8, !tbaa !61
  store i64 %119, ptr %112, align 8, !tbaa !82
  %124 = load i64, ptr %109, align 8, !tbaa !63
  br label %125

125:                                              ; preds = %115, %121
  %126 = phi i64 [ %110, %115 ], [ %124, %121 ]
  %127 = phi ptr [ %116, %115 ], [ %123, %121 ]
  %128 = getelementptr inbounds i8, ptr %127, i64 %126
  store i8 %108, ptr %128, align 1
  %129 = load i64, ptr %109, align 8, !tbaa !63
  %130 = add nsw i64 %129, 1
  store i64 %130, ptr %109, align 8, !tbaa !63
  %131 = load ptr, ptr %0, align 8, !tbaa !61
  %132 = getelementptr inbounds i8, ptr %131, i64 %130
  store i8 0, ptr %132, align 1, !tbaa !10
  %133 = getelementptr inbounds nuw i8, ptr %39, i64 8
  %134 = load i64, ptr %133, align 8, !tbaa !27
  %135 = icmp sgt i64 %134, 0
  br i1 %135, label %136, label %142

136:                                              ; preds = %125
  %137 = getelementptr inbounds nuw i8, ptr %39, i64 24
  br label %144

138:                                              ; preds = %170
  %139 = icmp ne i64 %175, 1
  %140 = or i1 %107, %139
  %141 = select i1 %107, i8 93, i8 41
  br i1 %140, label %178, label %177

142:                                              ; preds = %125
  %143 = select i1 %107, i8 93, i8 41
  br label %178

144:                                              ; preds = %136, %170
  %145 = phi i64 [ 0, %136 ], [ %174, %170 ]
  %146 = icmp eq i64 %145, 0
  br i1 %146, label %170, label %147

147:                                              ; preds = %144
  %148 = load i64, ptr %109, align 8, !tbaa !63
  %149 = add nsw i64 %148, 2
  %150 = load i64, ptr %112, align 8, !tbaa !82
  %151 = icmp slt i64 %149, %150
  br i1 %151, label %152, label %154

152:                                              ; preds = %147
  %153 = load ptr, ptr %0, align 8, !tbaa !61
  br label %162

154:                                              ; preds = %147, %154
  %155 = phi i64 [ %156, %154 ], [ %150, %147 ]
  %156 = shl nsw i64 %155, 1
  %157 = icmp sgt i64 %156, %149
  br i1 %157, label %158, label %154, !llvm.loop !83

158:                                              ; preds = %154
  %159 = load ptr, ptr %0, align 8, !tbaa !61
  %160 = tail call ptr @realloc(ptr noundef %159, i64 noundef %156) #38
  store ptr %160, ptr %0, align 8, !tbaa !61
  store i64 %156, ptr %112, align 8, !tbaa !82
  %161 = load i64, ptr %109, align 8, !tbaa !63
  br label %162

162:                                              ; preds = %152, %158
  %163 = phi i64 [ %148, %152 ], [ %161, %158 ]
  %164 = phi ptr [ %153, %152 ], [ %160, %158 ]
  %165 = getelementptr inbounds i8, ptr %164, i64 %163
  store i16 8236, ptr %165, align 1
  %166 = load i64, ptr %109, align 8, !tbaa !63
  %167 = add nsw i64 %166, 2
  store i64 %167, ptr %109, align 8, !tbaa !63
  %168 = load ptr, ptr %0, align 8, !tbaa !61
  %169 = getelementptr inbounds i8, ptr %168, i64 %167
  store i8 0, ptr %169, align 1, !tbaa !10
  br label %170

170:                                              ; preds = %162, %144
  %171 = load ptr, ptr %137, align 8, !tbaa !32
  %172 = getelementptr inbounds nuw i64, ptr %171, i64 %145
  %173 = load i64, ptr %172, align 8, !tbaa !11
  tail call fastcc void @to_sb(ptr noundef %0, i64 noundef %173, i32 noundef 1)
  %174 = add nuw nsw i64 %145, 1
  %175 = load i64, ptr %133, align 8, !tbaa !27
  %176 = icmp slt i64 %174, %175
  br i1 %176, label %144, label %138, !llvm.loop !84

177:                                              ; preds = %138
  tail call fastcc void @sb_putc(ptr noundef %0, i8 noundef signext 44)
  br label %178

178:                                              ; preds = %142, %138, %177
  %179 = phi i8 [ 41, %177 ], [ %143, %142 ], [ %141, %138 ]
  %180 = load i64, ptr %109, align 8, !tbaa !63
  %181 = add nsw i64 %180, 1
  %182 = load i64, ptr %112, align 8, !tbaa !82
  %183 = icmp slt i64 %181, %182
  br i1 %183, label %184, label %186

184:                                              ; preds = %178
  %185 = load ptr, ptr %0, align 8, !tbaa !61
  br label %194

186:                                              ; preds = %178, %186
  %187 = phi i64 [ %188, %186 ], [ %182, %178 ]
  %188 = shl nsw i64 %187, 1
  %189 = icmp sgt i64 %188, %181
  br i1 %189, label %190, label %186, !llvm.loop !83

190:                                              ; preds = %186
  %191 = load ptr, ptr %0, align 8, !tbaa !61
  %192 = tail call ptr @realloc(ptr noundef %191, i64 noundef %188) #38
  store ptr %192, ptr %0, align 8, !tbaa !61
  store i64 %188, ptr %112, align 8, !tbaa !82
  %193 = load i64, ptr %109, align 8, !tbaa !63
  br label %194

194:                                              ; preds = %184, %190
  %195 = phi i64 [ %180, %184 ], [ %193, %190 ]
  %196 = phi ptr [ %185, %184 ], [ %192, %190 ]
  %197 = getelementptr inbounds i8, ptr %196, i64 %195
  store i8 %179, ptr %197, align 1
  %198 = load i64, ptr %109, align 8, !tbaa !63
  %199 = add nsw i64 %198, 1
  store i64 %199, ptr %109, align 8, !tbaa !63
  %200 = load ptr, ptr %0, align 8, !tbaa !61
  %201 = getelementptr inbounds i8, ptr %200, i64 %199
  store i8 0, ptr %201, align 1, !tbaa !10
  br label %775

202:                                              ; preds = %38
  %203 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %204 = load i64, ptr %203, align 8, !tbaa !63
  %205 = add nsw i64 %204, 1
  %206 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %207 = load i64, ptr %206, align 8, !tbaa !82
  %208 = icmp slt i64 %205, %207
  br i1 %208, label %209, label %211

209:                                              ; preds = %202
  %210 = load ptr, ptr %0, align 8, !tbaa !61
  br label %219

211:                                              ; preds = %202, %211
  %212 = phi i64 [ %213, %211 ], [ %207, %202 ]
  %213 = shl nsw i64 %212, 1
  %214 = icmp sgt i64 %213, %205
  br i1 %214, label %215, label %211, !llvm.loop !83

215:                                              ; preds = %211
  %216 = load ptr, ptr %0, align 8, !tbaa !61
  %217 = tail call ptr @realloc(ptr noundef %216, i64 noundef %213) #38
  store ptr %217, ptr %0, align 8, !tbaa !61
  store i64 %213, ptr %206, align 8, !tbaa !82
  %218 = load i64, ptr %203, align 8, !tbaa !63
  br label %219

219:                                              ; preds = %209, %215
  %220 = phi i64 [ %204, %209 ], [ %218, %215 ]
  %221 = phi ptr [ %210, %209 ], [ %217, %215 ]
  %222 = getelementptr inbounds i8, ptr %221, i64 %220
  store i8 123, ptr %222, align 1
  %223 = load i64, ptr %203, align 8, !tbaa !63
  %224 = add nsw i64 %223, 1
  store i64 %224, ptr %203, align 8, !tbaa !63
  %225 = load ptr, ptr %0, align 8, !tbaa !61
  %226 = getelementptr inbounds i8, ptr %225, i64 %224
  store i8 0, ptr %226, align 1, !tbaa !10
  %227 = getelementptr inbounds nuw i8, ptr %39, i64 16
  %228 = load i64, ptr %227, align 8, !tbaa !35
  %229 = icmp sgt i64 %228, 0
  br i1 %229, label %230, label %232

230:                                              ; preds = %219
  %231 = getelementptr inbounds nuw i8, ptr %39, i64 32
  br label %255

232:                                              ; preds = %316, %219
  %233 = load i64, ptr %203, align 8, !tbaa !63
  %234 = add nsw i64 %233, 1
  %235 = load i64, ptr %206, align 8, !tbaa !82
  %236 = icmp slt i64 %234, %235
  br i1 %236, label %237, label %239

237:                                              ; preds = %232
  %238 = load ptr, ptr %0, align 8, !tbaa !61
  br label %247

239:                                              ; preds = %232, %239
  %240 = phi i64 [ %241, %239 ], [ %235, %232 ]
  %241 = shl nsw i64 %240, 1
  %242 = icmp sgt i64 %241, %234
  br i1 %242, label %243, label %239, !llvm.loop !83

243:                                              ; preds = %239
  %244 = load ptr, ptr %0, align 8, !tbaa !61
  %245 = tail call ptr @realloc(ptr noundef %244, i64 noundef %241) #38
  store ptr %245, ptr %0, align 8, !tbaa !61
  store i64 %241, ptr %206, align 8, !tbaa !82
  %246 = load i64, ptr %203, align 8, !tbaa !63
  br label %247

247:                                              ; preds = %237, %243
  %248 = phi i64 [ %233, %237 ], [ %246, %243 ]
  %249 = phi ptr [ %238, %237 ], [ %245, %243 ]
  %250 = getelementptr inbounds i8, ptr %249, i64 %248
  store i8 125, ptr %250, align 1
  %251 = load i64, ptr %203, align 8, !tbaa !63
  %252 = add nsw i64 %251, 1
  store i64 %252, ptr %203, align 8, !tbaa !63
  %253 = load ptr, ptr %0, align 8, !tbaa !61
  %254 = getelementptr inbounds i8, ptr %253, i64 %252
  store i8 0, ptr %254, align 1, !tbaa !10
  br label %775

255:                                              ; preds = %230, %316
  %256 = phi i64 [ %228, %230 ], [ %317, %316 ]
  %257 = phi i32 [ 1, %230 ], [ %318, %316 ]
  %258 = phi i64 [ 0, %230 ], [ %319, %316 ]
  %259 = load ptr, ptr %231, align 8, !tbaa !36
  %260 = getelementptr inbounds nuw %struct.Ent, ptr %259, i64 %258
  %261 = load i64, ptr %260, align 8, !tbaa !37
  %262 = icmp eq i64 %261, 0
  br i1 %262, label %316, label %263

263:                                              ; preds = %255
  %264 = icmp eq i32 %257, 0
  br i1 %264, label %265, label %289

265:                                              ; preds = %263
  %266 = load i64, ptr %203, align 8, !tbaa !63
  %267 = add nsw i64 %266, 2
  %268 = load i64, ptr %206, align 8, !tbaa !82
  %269 = icmp slt i64 %267, %268
  br i1 %269, label %270, label %272

270:                                              ; preds = %265
  %271 = load ptr, ptr %0, align 8, !tbaa !61
  br label %280

272:                                              ; preds = %265, %272
  %273 = phi i64 [ %274, %272 ], [ %268, %265 ]
  %274 = shl nsw i64 %273, 1
  %275 = icmp sgt i64 %274, %267
  br i1 %275, label %276, label %272, !llvm.loop !83

276:                                              ; preds = %272
  %277 = load ptr, ptr %0, align 8, !tbaa !61
  %278 = tail call ptr @realloc(ptr noundef %277, i64 noundef %274) #38
  store ptr %278, ptr %0, align 8, !tbaa !61
  store i64 %274, ptr %206, align 8, !tbaa !82
  %279 = load i64, ptr %203, align 8, !tbaa !63
  br label %280

280:                                              ; preds = %270, %276
  %281 = phi i64 [ %266, %270 ], [ %279, %276 ]
  %282 = phi ptr [ %271, %270 ], [ %278, %276 ]
  %283 = getelementptr inbounds i8, ptr %282, i64 %281
  store i16 8236, ptr %283, align 1
  %284 = load i64, ptr %203, align 8, !tbaa !63
  %285 = add nsw i64 %284, 2
  store i64 %285, ptr %203, align 8, !tbaa !63
  %286 = load ptr, ptr %0, align 8, !tbaa !61
  %287 = getelementptr inbounds i8, ptr %286, i64 %285
  store i8 0, ptr %287, align 1, !tbaa !10
  %288 = load i64, ptr %260, align 8, !tbaa !37
  br label %289

289:                                              ; preds = %280, %263
  %290 = phi i64 [ %288, %280 ], [ %261, %263 ]
  tail call fastcc void @to_sb(ptr noundef %0, i64 noundef %290, i32 noundef 1)
  %291 = load i64, ptr %203, align 8, !tbaa !63
  %292 = add nsw i64 %291, 2
  %293 = load i64, ptr %206, align 8, !tbaa !82
  %294 = icmp slt i64 %292, %293
  br i1 %294, label %295, label %297

295:                                              ; preds = %289
  %296 = load ptr, ptr %0, align 8, !tbaa !61
  br label %305

297:                                              ; preds = %289, %297
  %298 = phi i64 [ %299, %297 ], [ %293, %289 ]
  %299 = shl nsw i64 %298, 1
  %300 = icmp sgt i64 %299, %292
  br i1 %300, label %301, label %297, !llvm.loop !83

301:                                              ; preds = %297
  %302 = load ptr, ptr %0, align 8, !tbaa !61
  %303 = tail call ptr @realloc(ptr noundef %302, i64 noundef %299) #38
  store ptr %303, ptr %0, align 8, !tbaa !61
  store i64 %299, ptr %206, align 8, !tbaa !82
  %304 = load i64, ptr %203, align 8, !tbaa !63
  br label %305

305:                                              ; preds = %295, %301
  %306 = phi i64 [ %291, %295 ], [ %304, %301 ]
  %307 = phi ptr [ %296, %295 ], [ %303, %301 ]
  %308 = getelementptr inbounds i8, ptr %307, i64 %306
  store i16 8250, ptr %308, align 1
  %309 = load i64, ptr %203, align 8, !tbaa !63
  %310 = add nsw i64 %309, 2
  store i64 %310, ptr %203, align 8, !tbaa !63
  %311 = load ptr, ptr %0, align 8, !tbaa !61
  %312 = getelementptr inbounds i8, ptr %311, i64 %310
  store i8 0, ptr %312, align 1, !tbaa !10
  %313 = getelementptr inbounds nuw i8, ptr %260, i64 8
  %314 = load i64, ptr %313, align 8, !tbaa !42
  tail call fastcc void @to_sb(ptr noundef %0, i64 noundef %314, i32 noundef 1)
  %315 = load i64, ptr %227, align 8, !tbaa !35
  br label %316

316:                                              ; preds = %255, %305
  %317 = phi i64 [ %315, %305 ], [ %256, %255 ]
  %318 = phi i32 [ 0, %305 ], [ %257, %255 ]
  %319 = add nuw nsw i64 %258, 1
  %320 = icmp slt i64 %319, %317
  br i1 %320, label %255, label %232, !llvm.loop !85

321:                                              ; preds = %38
  %322 = getelementptr inbounds nuw i8, ptr %39, i64 8
  %323 = load i64, ptr %322, align 8, !tbaa !33
  %324 = icmp eq i64 %323, 0
  br i1 %324, label %325, label %326

325:                                              ; preds = %321
  tail call fastcc void @sb_adds(ptr noundef %0, ptr noundef nonnull @.str.116)
  br label %775

326:                                              ; preds = %321
  tail call fastcc void @sb_putc(ptr noundef %0, i8 noundef signext 123)
  %327 = getelementptr inbounds nuw i8, ptr %39, i64 16
  %328 = load i64, ptr %327, align 8, !tbaa !35
  %329 = icmp sgt i64 %328, 0
  br i1 %329, label %330, label %334

330:                                              ; preds = %326
  %331 = getelementptr inbounds nuw i8, ptr %39, i64 32
  %332 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %333 = getelementptr inbounds nuw i8, ptr %0, i64 16
  br label %335

334:                                              ; preds = %372, %326
  tail call fastcc void @sb_putc(ptr noundef %0, i8 noundef signext 125)
  br label %775

335:                                              ; preds = %330, %372
  %336 = phi i64 [ %328, %330 ], [ %373, %372 ]
  %337 = phi i32 [ 1, %330 ], [ %374, %372 ]
  %338 = phi i64 [ 0, %330 ], [ %375, %372 ]
  %339 = load ptr, ptr %331, align 8, !tbaa !36
  %340 = getelementptr inbounds nuw %struct.Ent, ptr %339, i64 %338
  %341 = load i64, ptr %340, align 8, !tbaa !37
  %342 = icmp eq i64 %341, 0
  br i1 %342, label %372, label %343

343:                                              ; preds = %335
  %344 = icmp eq i32 %337, 0
  br i1 %344, label %345, label %369

345:                                              ; preds = %343
  %346 = load i64, ptr %332, align 8, !tbaa !63
  %347 = add nsw i64 %346, 2
  %348 = load i64, ptr %333, align 8, !tbaa !82
  %349 = icmp slt i64 %347, %348
  br i1 %349, label %350, label %352

350:                                              ; preds = %345
  %351 = load ptr, ptr %0, align 8, !tbaa !61
  br label %360

352:                                              ; preds = %345, %352
  %353 = phi i64 [ %354, %352 ], [ %348, %345 ]
  %354 = shl nsw i64 %353, 1
  %355 = icmp sgt i64 %354, %347
  br i1 %355, label %356, label %352, !llvm.loop !83

356:                                              ; preds = %352
  %357 = load ptr, ptr %0, align 8, !tbaa !61
  %358 = tail call ptr @realloc(ptr noundef %357, i64 noundef %354) #38
  store ptr %358, ptr %0, align 8, !tbaa !61
  store i64 %354, ptr %333, align 8, !tbaa !82
  %359 = load i64, ptr %332, align 8, !tbaa !63
  br label %360

360:                                              ; preds = %350, %356
  %361 = phi i64 [ %346, %350 ], [ %359, %356 ]
  %362 = phi ptr [ %351, %350 ], [ %358, %356 ]
  %363 = getelementptr inbounds i8, ptr %362, i64 %361
  store i16 8236, ptr %363, align 1
  %364 = load i64, ptr %332, align 8, !tbaa !63
  %365 = add nsw i64 %364, 2
  store i64 %365, ptr %332, align 8, !tbaa !63
  %366 = load ptr, ptr %0, align 8, !tbaa !61
  %367 = getelementptr inbounds i8, ptr %366, i64 %365
  store i8 0, ptr %367, align 1, !tbaa !10
  %368 = load i64, ptr %340, align 8, !tbaa !37
  br label %369

369:                                              ; preds = %360, %343
  %370 = phi i64 [ %368, %360 ], [ %341, %343 ]
  tail call fastcc void @to_sb(ptr noundef %0, i64 noundef %370, i32 noundef 1)
  %371 = load i64, ptr %327, align 8, !tbaa !35
  br label %372

372:                                              ; preds = %335, %369
  %373 = phi i64 [ %371, %369 ], [ %336, %335 ]
  %374 = phi i32 [ 0, %369 ], [ %337, %335 ]
  %375 = add nuw nsw i64 %338, 1
  %376 = icmp slt i64 %375, %373
  br i1 %376, label %335, label %334, !llvm.loop !86

377:                                              ; preds = %38
  %378 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %379 = load i64, ptr %378, align 8, !tbaa !63
  %380 = add nsw i64 %379, 10
  %381 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %382 = load i64, ptr %381, align 8, !tbaa !82
  %383 = icmp slt i64 %380, %382
  br i1 %383, label %384, label %386

384:                                              ; preds = %377
  %385 = load ptr, ptr %0, align 8, !tbaa !61
  br label %394

386:                                              ; preds = %377, %386
  %387 = phi i64 [ %388, %386 ], [ %382, %377 ]
  %388 = shl nsw i64 %387, 1
  %389 = icmp sgt i64 %388, %380
  br i1 %389, label %390, label %386, !llvm.loop !83

390:                                              ; preds = %386
  %391 = load ptr, ptr %0, align 8, !tbaa !61
  %392 = tail call ptr @realloc(ptr noundef %391, i64 noundef %388) #38
  store ptr %392, ptr %0, align 8, !tbaa !61
  store i64 %388, ptr %381, align 8, !tbaa !82
  %393 = load i64, ptr %378, align 8, !tbaa !63
  br label %394

394:                                              ; preds = %384, %390
  %395 = phi i64 [ %379, %384 ], [ %393, %390 ]
  %396 = phi ptr [ %385, %384 ], [ %392, %390 ]
  %397 = getelementptr inbounds i8, ptr %396, i64 %395
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(10) %397, ptr noundef nonnull readonly align 1 dereferenceable(10) @.str.117, i64 noundef 10, i1 noundef false) #35
  %398 = load i64, ptr %378, align 8, !tbaa !63
  %399 = add nsw i64 %398, 10
  store i64 %399, ptr %378, align 8, !tbaa !63
  %400 = load ptr, ptr %0, align 8, !tbaa !61
  %401 = getelementptr inbounds i8, ptr %400, i64 %399
  store i8 0, ptr %401, align 1, !tbaa !10
  %402 = getelementptr inbounds nuw i8, ptr %39, i64 40
  %403 = load i64, ptr %402, align 8, !tbaa !50
  %404 = inttoptr i64 %403 to ptr
  %405 = getelementptr inbounds nuw i8, ptr %404, i64 16
  %406 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %405) #35
  %407 = load i64, ptr %378, align 8, !tbaa !63
  %408 = add nsw i64 %407, %406
  %409 = load i64, ptr %381, align 8, !tbaa !82
  %410 = icmp slt i64 %408, %409
  br i1 %410, label %411, label %413

411:                                              ; preds = %394
  %412 = load ptr, ptr %0, align 8, !tbaa !61
  br label %421

413:                                              ; preds = %394, %413
  %414 = phi i64 [ %415, %413 ], [ %409, %394 ]
  %415 = shl nsw i64 %414, 1
  %416 = icmp sgt i64 %415, %408
  br i1 %416, label %417, label %413, !llvm.loop !83

417:                                              ; preds = %413
  %418 = load ptr, ptr %0, align 8, !tbaa !61
  %419 = tail call ptr @realloc(ptr noundef %418, i64 noundef %415) #38
  store ptr %419, ptr %0, align 8, !tbaa !61
  store i64 %415, ptr %381, align 8, !tbaa !82
  %420 = load i64, ptr %378, align 8, !tbaa !63
  br label %421

421:                                              ; preds = %411, %417
  %422 = phi i64 [ %407, %411 ], [ %420, %417 ]
  %423 = phi ptr [ %412, %411 ], [ %419, %417 ]
  %424 = getelementptr inbounds i8, ptr %423, i64 %422
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %424, ptr noundef nonnull readonly align 1 %405, i64 noundef %406, i1 noundef false) #35
  %425 = load i64, ptr %378, align 8, !tbaa !63
  %426 = add nsw i64 %425, %406
  store i64 %426, ptr %378, align 8, !tbaa !63
  %427 = load ptr, ptr %0, align 8, !tbaa !61
  %428 = getelementptr inbounds i8, ptr %427, i64 %426
  store i8 0, ptr %428, align 1, !tbaa !10
  %429 = load i64, ptr %378, align 8, !tbaa !63
  %430 = add nsw i64 %429, 1
  %431 = load i64, ptr %381, align 8, !tbaa !82
  %432 = icmp slt i64 %430, %431
  br i1 %432, label %433, label %435

433:                                              ; preds = %421
  %434 = load ptr, ptr %0, align 8, !tbaa !61
  br label %443

435:                                              ; preds = %421, %435
  %436 = phi i64 [ %437, %435 ], [ %431, %421 ]
  %437 = shl nsw i64 %436, 1
  %438 = icmp sgt i64 %437, %430
  br i1 %438, label %439, label %435, !llvm.loop !83

439:                                              ; preds = %435
  %440 = load ptr, ptr %0, align 8, !tbaa !61
  %441 = tail call ptr @realloc(ptr noundef %440, i64 noundef %437) #38
  store ptr %441, ptr %0, align 8, !tbaa !61
  store i64 %437, ptr %381, align 8, !tbaa !82
  %442 = load i64, ptr %378, align 8, !tbaa !63
  br label %443

443:                                              ; preds = %433, %439
  %444 = phi i64 [ %429, %433 ], [ %442, %439 ]
  %445 = phi ptr [ %434, %433 ], [ %441, %439 ]
  %446 = getelementptr inbounds i8, ptr %445, i64 %444
  store i8 62, ptr %446, align 1
  %447 = load i64, ptr %378, align 8, !tbaa !63
  %448 = add nsw i64 %447, 1
  store i64 %448, ptr %378, align 8, !tbaa !63
  %449 = load ptr, ptr %0, align 8, !tbaa !61
  %450 = getelementptr inbounds i8, ptr %449, i64 %448
  store i8 0, ptr %450, align 1, !tbaa !10
  br label %775

451:                                              ; preds = %38
  %452 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %453 = load i64, ptr %452, align 8, !tbaa !63
  %454 = add nsw i64 %453, 19
  %455 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %456 = load i64, ptr %455, align 8, !tbaa !82
  %457 = icmp slt i64 %454, %456
  br i1 %457, label %458, label %460

458:                                              ; preds = %451
  %459 = load ptr, ptr %0, align 8, !tbaa !61
  br label %468

460:                                              ; preds = %451, %460
  %461 = phi i64 [ %462, %460 ], [ %456, %451 ]
  %462 = shl nsw i64 %461, 1
  %463 = icmp sgt i64 %462, %454
  br i1 %463, label %464, label %460, !llvm.loop !83

464:                                              ; preds = %460
  %465 = load ptr, ptr %0, align 8, !tbaa !61
  %466 = tail call ptr @realloc(ptr noundef %465, i64 noundef %462) #38
  store ptr %466, ptr %0, align 8, !tbaa !61
  store i64 %462, ptr %455, align 8, !tbaa !82
  %467 = load i64, ptr %452, align 8, !tbaa !63
  br label %468

468:                                              ; preds = %458, %464
  %469 = phi i64 [ %453, %458 ], [ %467, %464 ]
  %470 = phi ptr [ %459, %458 ], [ %466, %464 ]
  %471 = getelementptr inbounds i8, ptr %470, i64 %469
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(19) %471, ptr noundef nonnull readonly align 1 dereferenceable(19) @.str.118, i64 noundef 19, i1 noundef false) #35
  %472 = load i64, ptr %452, align 8, !tbaa !63
  %473 = add nsw i64 %472, 19
  store i64 %473, ptr %452, align 8, !tbaa !63
  %474 = load ptr, ptr %0, align 8, !tbaa !61
  %475 = getelementptr inbounds i8, ptr %474, i64 %473
  store i8 0, ptr %475, align 1, !tbaa !10
  %476 = getelementptr inbounds nuw i8, ptr %39, i64 16
  %477 = load ptr, ptr %476, align 8, !tbaa !87
  %478 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %477) #35
  %479 = load i64, ptr %452, align 8, !tbaa !63
  %480 = add nsw i64 %479, %478
  %481 = load i64, ptr %455, align 8, !tbaa !82
  %482 = icmp slt i64 %480, %481
  br i1 %482, label %483, label %485

483:                                              ; preds = %468
  %484 = load ptr, ptr %0, align 8, !tbaa !61
  br label %493

485:                                              ; preds = %468, %485
  %486 = phi i64 [ %487, %485 ], [ %481, %468 ]
  %487 = shl nsw i64 %486, 1
  %488 = icmp sgt i64 %487, %480
  br i1 %488, label %489, label %485, !llvm.loop !83

489:                                              ; preds = %485
  %490 = load ptr, ptr %0, align 8, !tbaa !61
  %491 = tail call ptr @realloc(ptr noundef %490, i64 noundef %487) #38
  store ptr %491, ptr %0, align 8, !tbaa !61
  store i64 %487, ptr %455, align 8, !tbaa !82
  %492 = load i64, ptr %452, align 8, !tbaa !63
  br label %493

493:                                              ; preds = %483, %489
  %494 = phi i64 [ %479, %483 ], [ %492, %489 ]
  %495 = phi ptr [ %484, %483 ], [ %491, %489 ]
  %496 = getelementptr inbounds i8, ptr %495, i64 %494
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %496, ptr noundef nonnull readonly align 1 %477, i64 noundef %478, i1 noundef false) #35
  %497 = load i64, ptr %452, align 8, !tbaa !63
  %498 = add nsw i64 %497, %478
  store i64 %498, ptr %452, align 8, !tbaa !63
  %499 = load ptr, ptr %0, align 8, !tbaa !61
  %500 = getelementptr inbounds i8, ptr %499, i64 %498
  store i8 0, ptr %500, align 1, !tbaa !10
  %501 = load i64, ptr %452, align 8, !tbaa !63
  %502 = add nsw i64 %501, 1
  %503 = load i64, ptr %455, align 8, !tbaa !82
  %504 = icmp slt i64 %502, %503
  br i1 %504, label %505, label %507

505:                                              ; preds = %493
  %506 = load ptr, ptr %0, align 8, !tbaa !61
  br label %515

507:                                              ; preds = %493, %507
  %508 = phi i64 [ %509, %507 ], [ %503, %493 ]
  %509 = shl nsw i64 %508, 1
  %510 = icmp sgt i64 %509, %502
  br i1 %510, label %511, label %507, !llvm.loop !83

511:                                              ; preds = %507
  %512 = load ptr, ptr %0, align 8, !tbaa !61
  %513 = tail call ptr @realloc(ptr noundef %512, i64 noundef %509) #38
  store ptr %513, ptr %0, align 8, !tbaa !61
  store i64 %509, ptr %455, align 8, !tbaa !82
  %514 = load i64, ptr %452, align 8, !tbaa !63
  br label %515

515:                                              ; preds = %505, %511
  %516 = phi i64 [ %501, %505 ], [ %514, %511 ]
  %517 = phi ptr [ %506, %505 ], [ %513, %511 ]
  %518 = getelementptr inbounds i8, ptr %517, i64 %516
  store i8 62, ptr %518, align 1
  %519 = load i64, ptr %452, align 8, !tbaa !63
  %520 = add nsw i64 %519, 1
  store i64 %520, ptr %452, align 8, !tbaa !63
  %521 = load ptr, ptr %0, align 8, !tbaa !61
  %522 = getelementptr inbounds i8, ptr %521, i64 %520
  store i8 0, ptr %522, align 1, !tbaa !10
  br label %775

523:                                              ; preds = %38
  %524 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %525 = load i64, ptr %524, align 8, !tbaa !63
  %526 = add nsw i64 %525, 8
  %527 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %528 = load i64, ptr %527, align 8, !tbaa !82
  %529 = icmp slt i64 %526, %528
  br i1 %529, label %530, label %532

530:                                              ; preds = %523
  %531 = load ptr, ptr %0, align 8, !tbaa !61
  br label %540

532:                                              ; preds = %523, %532
  %533 = phi i64 [ %534, %532 ], [ %528, %523 ]
  %534 = shl nsw i64 %533, 1
  %535 = icmp sgt i64 %534, %526
  br i1 %535, label %536, label %532, !llvm.loop !83

536:                                              ; preds = %532
  %537 = load ptr, ptr %0, align 8, !tbaa !61
  %538 = tail call ptr @realloc(ptr noundef %537, i64 noundef %534) #38
  store ptr %538, ptr %0, align 8, !tbaa !61
  store i64 %534, ptr %527, align 8, !tbaa !82
  %539 = load i64, ptr %524, align 8, !tbaa !63
  br label %540

540:                                              ; preds = %530, %536
  %541 = phi i64 [ %525, %530 ], [ %539, %536 ]
  %542 = phi ptr [ %531, %530 ], [ %538, %536 ]
  %543 = getelementptr inbounds i8, ptr %542, i64 %541
  store i64 2819380306126857020, ptr %543, align 1
  %544 = load i64, ptr %524, align 8, !tbaa !63
  %545 = add nsw i64 %544, 8
  store i64 %545, ptr %524, align 8, !tbaa !63
  %546 = load ptr, ptr %0, align 8, !tbaa !61
  %547 = getelementptr inbounds i8, ptr %546, i64 %545
  store i8 0, ptr %547, align 1, !tbaa !10
  %548 = getelementptr inbounds nuw i8, ptr %39, i64 8
  %549 = load i64, ptr %548, align 8, !tbaa !60
  %550 = inttoptr i64 %549 to ptr
  %551 = getelementptr inbounds nuw i8, ptr %550, i64 16
  %552 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %551) #35
  %553 = load i64, ptr %524, align 8, !tbaa !63
  %554 = add nsw i64 %553, %552
  %555 = load i64, ptr %527, align 8, !tbaa !82
  %556 = icmp slt i64 %554, %555
  br i1 %556, label %557, label %559

557:                                              ; preds = %540
  %558 = load ptr, ptr %0, align 8, !tbaa !61
  br label %567

559:                                              ; preds = %540, %559
  %560 = phi i64 [ %561, %559 ], [ %555, %540 ]
  %561 = shl nsw i64 %560, 1
  %562 = icmp sgt i64 %561, %554
  br i1 %562, label %563, label %559, !llvm.loop !83

563:                                              ; preds = %559
  %564 = load ptr, ptr %0, align 8, !tbaa !61
  %565 = tail call ptr @realloc(ptr noundef %564, i64 noundef %561) #38
  store ptr %565, ptr %0, align 8, !tbaa !61
  store i64 %561, ptr %527, align 8, !tbaa !82
  %566 = load i64, ptr %524, align 8, !tbaa !63
  br label %567

567:                                              ; preds = %557, %563
  %568 = phi i64 [ %553, %557 ], [ %566, %563 ]
  %569 = phi ptr [ %558, %557 ], [ %565, %563 ]
  %570 = getelementptr inbounds i8, ptr %569, i64 %568
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %570, ptr noundef nonnull readonly align 1 %551, i64 noundef %552, i1 noundef false) #35
  %571 = load i64, ptr %524, align 8, !tbaa !63
  %572 = add nsw i64 %571, %552
  store i64 %572, ptr %524, align 8, !tbaa !63
  %573 = load ptr, ptr %0, align 8, !tbaa !61
  %574 = getelementptr inbounds i8, ptr %573, i64 %572
  store i8 0, ptr %574, align 1, !tbaa !10
  %575 = load i64, ptr %524, align 8, !tbaa !63
  %576 = add nsw i64 %575, 2
  %577 = load i64, ptr %527, align 8, !tbaa !82
  %578 = icmp slt i64 %576, %577
  br i1 %578, label %579, label %581

579:                                              ; preds = %567
  %580 = load ptr, ptr %0, align 8, !tbaa !61
  br label %589

581:                                              ; preds = %567, %581
  %582 = phi i64 [ %583, %581 ], [ %577, %567 ]
  %583 = shl nsw i64 %582, 1
  %584 = icmp sgt i64 %583, %576
  br i1 %584, label %585, label %581, !llvm.loop !83

585:                                              ; preds = %581
  %586 = load ptr, ptr %0, align 8, !tbaa !61
  %587 = tail call ptr @realloc(ptr noundef %586, i64 noundef %583) #38
  store ptr %587, ptr %0, align 8, !tbaa !61
  store i64 %583, ptr %527, align 8, !tbaa !82
  %588 = load i64, ptr %524, align 8, !tbaa !63
  br label %589

589:                                              ; preds = %579, %585
  %590 = phi i64 [ %575, %579 ], [ %588, %585 ]
  %591 = phi ptr [ %580, %579 ], [ %587, %585 ]
  %592 = getelementptr inbounds i8, ptr %591, i64 %590
  store i16 15911, ptr %592, align 1
  %593 = load i64, ptr %524, align 8, !tbaa !63
  %594 = add nsw i64 %593, 2
  store i64 %594, ptr %524, align 8, !tbaa !63
  %595 = load ptr, ptr %0, align 8, !tbaa !61
  %596 = getelementptr inbounds i8, ptr %595, i64 %594
  store i8 0, ptr %596, align 1, !tbaa !10
  br label %775

597:                                              ; preds = %38
  %598 = icmp ne i32 %2, 0
  br i1 %598, label %605, label %599

599:                                              ; preds = %597
  %600 = getelementptr inbounds nuw i8, ptr %39, i64 8
  %601 = load i64, ptr %600, align 8, !tbaa !42
  %602 = load i64, ptr @K_str, align 8, !tbaa !11
  %603 = tail call fastcc i64 @class_lookup(i64 noundef %601, i64 noundef %602)
  %604 = icmp eq i64 %603, 0
  br i1 %604, label %605, label %611

605:                                              ; preds = %597, %599
  %606 = getelementptr inbounds nuw i8, ptr %39, i64 8
  %607 = load i64, ptr %606, align 8, !tbaa !42
  %608 = load i64, ptr @K_repr, align 8, !tbaa !11
  %609 = tail call fastcc i64 @class_lookup(i64 noundef %607, i64 noundef %608)
  %610 = icmp eq i64 %609, 0
  br i1 %610, label %627, label %611

611:                                              ; preds = %599, %605
  %612 = phi i64 [ %609, %605 ], [ %603, %599 ]
  call void @llvm.lifetime.start.p0(ptr nonnull %5) #35
  store i64 %1, ptr %5, align 8, !tbaa !11
  %613 = call i64 @rt_call(i64 noundef %612, i64 noundef 1, ptr noundef nonnull %5)
  %614 = and i64 %613, 1
  %615 = icmp ne i64 %614, 0
  %616 = icmp eq i64 %613, 0
  %617 = or i1 %616, %615
  br i1 %617, label %622, label %618

618:                                              ; preds = %611
  %619 = inttoptr i64 %613 to ptr
  %620 = load i64, ptr %619, align 8, !tbaa !23
  %621 = icmp eq i64 %620, 4
  br i1 %621, label %623, label %622

622:                                              ; preds = %611, %618
  call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.121) #36
  unreachable

623:                                              ; preds = %618
  %624 = getelementptr inbounds nuw i8, ptr %619, i64 16
  %625 = getelementptr inbounds nuw i8, ptr %619, i64 8
  %626 = load i64, ptr %625, align 8, !tbaa !18
  call fastcc void @sb_add(ptr noundef %0, ptr noundef nonnull %624, i64 noundef %626)
  call void @llvm.lifetime.end.p0(ptr nonnull %5) #35
  br label %775

627:                                              ; preds = %605
  %628 = getelementptr inbounds nuw i8, ptr %39, i64 16
  %629 = load i64, ptr %628, align 8, !tbaa !39
  %630 = inttoptr i64 %629 to ptr
  %631 = load i64, ptr @K_args, align 8, !tbaa !11
  %632 = tail call fastcc i64 @hash_v(i64 noundef %631)
  %633 = tail call fastcc ptr @dict_find(ptr noundef %630, i64 noundef %631, i64 noundef %632)
  %634 = icmp eq ptr %633, null
  %635 = or i1 %598, %634
  br i1 %635, label %654, label %636

636:                                              ; preds = %627
  %637 = tail call fastcc i64 @exc_by_name(ptr noundef nonnull @.str.97)
  %638 = tail call fastcc i64 @inst_of(i64 noundef %1, i64 noundef %637)
  %639 = icmp eq i64 %638, 0
  br i1 %639, label %655, label %640

640:                                              ; preds = %636
  %641 = getelementptr inbounds nuw i8, ptr %633, i64 8
  %642 = load i64, ptr %641, align 8, !tbaa !42
  %643 = inttoptr i64 %642 to ptr
  %644 = getelementptr inbounds nuw i8, ptr %643, i64 8
  %645 = load i64, ptr %644, align 8, !tbaa !27
  %646 = icmp eq i64 %645, 1
  br i1 %646, label %647, label %651

647:                                              ; preds = %640
  %648 = getelementptr inbounds nuw i8, ptr %643, i64 24
  %649 = load ptr, ptr %648, align 8, !tbaa !32
  %650 = load i64, ptr %649, align 8, !tbaa !11
  tail call fastcc void @to_sb(ptr noundef %0, i64 noundef %650, i32 noundef 0)
  br label %775

651:                                              ; preds = %640
  %652 = icmp sgt i64 %645, 1
  br i1 %652, label %653, label %775

653:                                              ; preds = %651
  tail call fastcc void @to_sb(ptr noundef %0, i64 noundef %642, i32 noundef 1)
  br label %775

654:                                              ; preds = %627
  br i1 %634, label %668, label %655

655:                                              ; preds = %636, %654
  %656 = tail call fastcc i64 @exc_by_name(ptr noundef nonnull @.str.97)
  %657 = tail call fastcc i64 @inst_of(i64 noundef %1, i64 noundef %656)
  %658 = icmp eq i64 %657, 0
  br i1 %658, label %668, label %659

659:                                              ; preds = %655
  %660 = load i64, ptr %606, align 8, !tbaa !42
  %661 = inttoptr i64 %660 to ptr
  %662 = getelementptr inbounds nuw i8, ptr %661, i64 8
  %663 = load i64, ptr %662, align 8, !tbaa !60
  %664 = inttoptr i64 %663 to ptr
  %665 = getelementptr inbounds nuw i8, ptr %664, i64 16
  tail call fastcc void @sb_adds(ptr noundef %0, ptr noundef nonnull %665)
  %666 = getelementptr inbounds nuw i8, ptr %633, i64 8
  %667 = load i64, ptr %666, align 8, !tbaa !42
  tail call fastcc void @to_sb(ptr noundef %0, i64 noundef %667, i32 noundef 1)
  br label %775

668:                                              ; preds = %655, %654
  tail call fastcc void @sb_putc(ptr noundef %0, i8 noundef signext 60)
  %669 = load i64, ptr %606, align 8, !tbaa !42
  %670 = inttoptr i64 %669 to ptr
  %671 = getelementptr inbounds nuw i8, ptr %670, i64 8
  %672 = load i64, ptr %671, align 8, !tbaa !60
  %673 = inttoptr i64 %672 to ptr
  %674 = getelementptr inbounds nuw i8, ptr %673, i64 16
  tail call fastcc void @sb_adds(ptr noundef %0, ptr noundef nonnull %674)
  tail call fastcc void @sb_adds(ptr noundef %0, ptr noundef nonnull @.str.122)
  br label %775

675:                                              ; preds = %38
  %676 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %677 = load i64, ptr %676, align 8, !tbaa !63
  %678 = add nsw i64 %677, 14
  %679 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %680 = load i64, ptr %679, align 8, !tbaa !82
  %681 = icmp slt i64 %678, %680
  br i1 %681, label %682, label %684

682:                                              ; preds = %675
  %683 = load ptr, ptr %0, align 8, !tbaa !61
  br label %692

684:                                              ; preds = %675, %684
  %685 = phi i64 [ %686, %684 ], [ %680, %675 ]
  %686 = shl nsw i64 %685, 1
  %687 = icmp sgt i64 %686, %678
  br i1 %687, label %688, label %684, !llvm.loop !83

688:                                              ; preds = %684
  %689 = load ptr, ptr %0, align 8, !tbaa !61
  %690 = tail call ptr @realloc(ptr noundef %689, i64 noundef %686) #38
  store ptr %690, ptr %0, align 8, !tbaa !61
  store i64 %686, ptr %679, align 8, !tbaa !82
  %691 = load i64, ptr %676, align 8, !tbaa !63
  br label %692

692:                                              ; preds = %682, %688
  %693 = phi i64 [ %677, %682 ], [ %691, %688 ]
  %694 = phi ptr [ %683, %682 ], [ %690, %688 ]
  %695 = getelementptr inbounds i8, ptr %694, i64 %693
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(14) %695, ptr noundef nonnull readonly align 1 dereferenceable(14) @.str.123, i64 noundef 14, i1 noundef false) #35
  %696 = load i64, ptr %676, align 8, !tbaa !63
  %697 = add nsw i64 %696, 14
  store i64 %697, ptr %676, align 8, !tbaa !63
  %698 = load ptr, ptr %0, align 8, !tbaa !61
  %699 = getelementptr inbounds i8, ptr %698, i64 %697
  store i8 0, ptr %699, align 1, !tbaa !10
  br label %775

700:                                              ; preds = %38
  %701 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %702 = load i64, ptr %701, align 8, !tbaa !63
  %703 = add nsw i64 %702, 6
  %704 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %705 = load i64, ptr %704, align 8, !tbaa !82
  %706 = icmp slt i64 %703, %705
  br i1 %706, label %707, label %709

707:                                              ; preds = %700
  %708 = load ptr, ptr %0, align 8, !tbaa !61
  br label %717

709:                                              ; preds = %700, %709
  %710 = phi i64 [ %711, %709 ], [ %705, %700 ]
  %711 = shl nsw i64 %710, 1
  %712 = icmp sgt i64 %711, %703
  br i1 %712, label %713, label %709, !llvm.loop !83

713:                                              ; preds = %709
  %714 = load ptr, ptr %0, align 8, !tbaa !61
  %715 = tail call ptr @realloc(ptr noundef %714, i64 noundef %711) #38
  store ptr %715, ptr %0, align 8, !tbaa !61
  store i64 %711, ptr %704, align 8, !tbaa !82
  %716 = load i64, ptr %701, align 8, !tbaa !63
  br label %717

717:                                              ; preds = %707, %713
  %718 = phi i64 [ %702, %707 ], [ %716, %713 ]
  %719 = phi ptr [ %708, %707 ], [ %715, %713 ]
  %720 = getelementptr inbounds i8, ptr %719, i64 %718
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %720, ptr noundef nonnull readonly align 1 dereferenceable(6) @.str.124, i64 noundef 6, i1 noundef false) #35
  %721 = load i64, ptr %701, align 8, !tbaa !63
  %722 = add nsw i64 %721, 6
  store i64 %722, ptr %701, align 8, !tbaa !63
  %723 = load ptr, ptr %0, align 8, !tbaa !61
  %724 = getelementptr inbounds i8, ptr %723, i64 %722
  store i8 0, ptr %724, align 1, !tbaa !10
  br label %775

725:                                              ; preds = %38
  %726 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %727 = load i64, ptr %726, align 8, !tbaa !63
  %728 = add nsw i64 %727, 8
  %729 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %730 = load i64, ptr %729, align 8, !tbaa !82
  %731 = icmp slt i64 %728, %730
  br i1 %731, label %732, label %734

732:                                              ; preds = %725
  %733 = load ptr, ptr %0, align 8, !tbaa !61
  br label %742

734:                                              ; preds = %725, %734
  %735 = phi i64 [ %736, %734 ], [ %730, %725 ]
  %736 = shl nsw i64 %735, 1
  %737 = icmp sgt i64 %736, %728
  br i1 %737, label %738, label %734, !llvm.loop !83

738:                                              ; preds = %734
  %739 = load ptr, ptr %0, align 8, !tbaa !61
  %740 = tail call ptr @realloc(ptr noundef %739, i64 noundef %736) #38
  store ptr %740, ptr %0, align 8, !tbaa !61
  store i64 %736, ptr %729, align 8, !tbaa !82
  %741 = load i64, ptr %726, align 8, !tbaa !63
  br label %742

742:                                              ; preds = %732, %738
  %743 = phi i64 [ %727, %732 ], [ %741, %738 ]
  %744 = phi ptr [ %733, %732 ], [ %740, %738 ]
  %745 = getelementptr inbounds i8, ptr %744, i64 %743
  store i64 4496119054451305788, ptr %745, align 1
  %746 = load i64, ptr %726, align 8, !tbaa !63
  %747 = add nsw i64 %746, 8
  store i64 %747, ptr %726, align 8, !tbaa !63
  %748 = load ptr, ptr %0, align 8, !tbaa !61
  %749 = getelementptr inbounds i8, ptr %748, i64 %747
  store i8 0, ptr %749, align 1, !tbaa !10
  br label %775

750:                                              ; preds = %36, %38
  %751 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %752 = load i64, ptr %751, align 8, !tbaa !63
  %753 = add nsw i64 %752, 8
  %754 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %755 = load i64, ptr %754, align 8, !tbaa !82
  %756 = icmp slt i64 %753, %755
  br i1 %756, label %757, label %759

757:                                              ; preds = %750
  %758 = load ptr, ptr %0, align 8, !tbaa !61
  br label %767

759:                                              ; preds = %750, %759
  %760 = phi i64 [ %761, %759 ], [ %755, %750 ]
  %761 = shl nsw i64 %760, 1
  %762 = icmp sgt i64 %761, %753
  br i1 %762, label %763, label %759, !llvm.loop !83

763:                                              ; preds = %759
  %764 = load ptr, ptr %0, align 8, !tbaa !61
  %765 = tail call ptr @realloc(ptr noundef %764, i64 noundef %761) #38
  store ptr %765, ptr %0, align 8, !tbaa !61
  store i64 %761, ptr %754, align 8, !tbaa !82
  %766 = load i64, ptr %751, align 8, !tbaa !63
  br label %767

767:                                              ; preds = %757, %763
  %768 = phi i64 [ %752, %757 ], [ %766, %763 ]
  %769 = phi ptr [ %758, %757 ], [ %765, %763 ]
  %770 = getelementptr inbounds i8, ptr %769, i64 %768
  store i64 4500331214877650748, ptr %770, align 1
  %771 = load i64, ptr %751, align 8, !tbaa !63
  %772 = add nsw i64 %771, 8
  store i64 %772, ptr %751, align 8, !tbaa !63
  %773 = load ptr, ptr %0, align 8, !tbaa !61
  %774 = getelementptr inbounds i8, ptr %773, i64 %772
  store i8 0, ptr %774, align 1, !tbaa !10
  br label %775

775:                                              ; preds = %623, %647, %653, %651, %668, %659, %101, %102, %767, %742, %717, %692, %589, %515, %443, %334, %325, %247, %194, %96, %88, %58, %28
  call void @llvm.lifetime.end.p0(ptr nonnull %4) #35
  ret void
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_repr(i64 noundef %0) local_unnamed_addr #2 {
  %2 = alloca %struct.SB, align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %2) #35
  %3 = getelementptr inbounds nuw i8, ptr %2, i64 8
  store <2 x i64> <i64 0, i64 64>, ptr %3, align 8, !tbaa !11
  %4 = tail call dereferenceable_or_null(64) ptr @calloc(i64 noundef 1, i64 noundef 64) #33
  %5 = icmp eq ptr %4, null
  br i1 %5, label %6, label %9

6:                                                ; preds = %1
  %7 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %8 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %7)
  tail call void @exit(i32 noundef 1) #34
  unreachable

9:                                                ; preds = %1
  store ptr %4, ptr %2, align 8, !tbaa !61
  call fastcc void @to_sb(ptr noundef %2, i64 noundef %0, i32 noundef 1)
  %10 = load ptr, ptr %2, align 8, !tbaa !61
  %11 = load i64, ptr %3, align 8, !tbaa !63
  %12 = call fastcc i64 @mkstr(ptr noundef %10, i64 noundef %11)
  call void @llvm.lifetime.end.p0(ptr nonnull %2) #35
  ret i64 %12
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_add(i64 noundef %0, i64 noundef %1) local_unnamed_addr #2 {
  %3 = and i64 %0, 1
  %4 = icmp eq i64 %3, 0
  %5 = and i64 %1, 1
  %6 = icmp eq i64 %5, 0
  %7 = and i64 %3, %1
  %8 = icmp eq i64 %7, 0
  br i1 %8, label %16, label %9

9:                                                ; preds = %2
  %10 = add nsw i64 %1, -1
  %11 = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %0, i64 %10)
  %12 = extractvalue { i64, i1 } %11, 1
  br i1 %12, label %15, label %13

13:                                               ; preds = %9
  %14 = extractvalue { i64, i1 } %11, 0
  br label %211

15:                                               ; preds = %9
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.7, ptr noundef nonnull @.str.8) #36
  unreachable

16:                                               ; preds = %2
  br i1 %4, label %17, label %24

17:                                               ; preds = %16
  %18 = icmp eq i64 %0, 0
  br i1 %18, label %128, label %19

19:                                               ; preds = %17
  %20 = inttoptr i64 %0 to ptr
  %21 = load i64, ptr %20, align 8, !tbaa !23
  %22 = and i64 %21, -2
  %23 = icmp eq i64 %22, 2
  br i1 %23, label %24, label %125

24:                                               ; preds = %19, %16
  br i1 %6, label %25, label %32

25:                                               ; preds = %24
  %26 = icmp eq i64 %1, 0
  br i1 %26, label %122, label %27

27:                                               ; preds = %25
  %28 = inttoptr i64 %1 to ptr
  %29 = load i64, ptr %28, align 8, !tbaa !23
  %30 = and i64 %29, -2
  %31 = icmp eq i64 %30, 2
  br i1 %31, label %32, label %122

32:                                               ; preds = %27, %24
  br i1 %4, label %33, label %37

33:                                               ; preds = %32
  %34 = inttoptr i64 %0 to ptr
  %35 = load i64, ptr %34, align 8, !tbaa !23
  %36 = icmp eq i64 %35, 3
  br i1 %36, label %57, label %37

37:                                               ; preds = %32, %33
  br i1 %6, label %38, label %90

38:                                               ; preds = %37
  %39 = inttoptr i64 %1 to ptr
  %40 = load i64, ptr %39, align 8, !tbaa !23
  %41 = icmp eq i64 %40, 3
  br i1 %41, label %42, label %90

42:                                               ; preds = %38
  br i1 %4, label %46, label %43

43:                                               ; preds = %42
  %44 = ashr i64 %0, 1
  %45 = sitofp i64 %44 to double
  br label %66

46:                                               ; preds = %42
  %47 = inttoptr i64 %0 to ptr
  %48 = load i64, ptr %47, align 8, !tbaa !23
  switch i64 %48, label %56 [
    i64 2, label %52
    i64 3, label %49
  ]

49:                                               ; preds = %46
  %50 = getelementptr inbounds nuw i8, ptr %47, i64 8
  %51 = load double, ptr %50, align 8, !tbaa !22
  br label %60

52:                                               ; preds = %46
  %53 = getelementptr inbounds nuw i8, ptr %47, i64 8
  %54 = load i64, ptr %53, align 8, !tbaa !25
  %55 = sitofp i64 %54 to double
  br label %60

56:                                               ; preds = %46
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.108) #36
  unreachable

57:                                               ; preds = %33
  %58 = getelementptr inbounds nuw i8, ptr %34, i64 8
  %59 = load double, ptr %58, align 8, !tbaa !22
  br i1 %6, label %60, label %63

60:                                               ; preds = %49, %52, %57
  %61 = phi double [ %55, %52 ], [ %59, %57 ], [ %51, %49 ]
  %62 = inttoptr i64 %1 to ptr
  br label %66

63:                                               ; preds = %57
  %64 = ashr i64 %1, 1
  %65 = sitofp i64 %64 to double
  br label %78

66:                                               ; preds = %60, %43
  %67 = phi ptr [ %62, %60 ], [ %39, %43 ]
  %68 = phi double [ %61, %60 ], [ %45, %43 ]
  %69 = load i64, ptr %67, align 8, !tbaa !23
  switch i64 %69, label %77 [
    i64 2, label %70
    i64 3, label %74
  ]

70:                                               ; preds = %66
  %71 = getelementptr inbounds nuw i8, ptr %67, i64 8
  %72 = load i64, ptr %71, align 8, !tbaa !25
  %73 = sitofp i64 %72 to double
  br label %78

74:                                               ; preds = %66
  %75 = getelementptr inbounds nuw i8, ptr %67, i64 8
  %76 = load double, ptr %75, align 8, !tbaa !22
  br label %78

77:                                               ; preds = %66
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.108) #36
  unreachable

78:                                               ; preds = %63, %70, %74
  %79 = phi double [ %59, %63 ], [ %68, %70 ], [ %68, %74 ]
  %80 = phi double [ %65, %63 ], [ %73, %70 ], [ %76, %74 ]
  %81 = tail call dereferenceable_or_null(16) ptr @calloc(i64 noundef 1, i64 noundef 16) #33
  %82 = icmp eq ptr %81, null
  br i1 %82, label %83, label %86

83:                                               ; preds = %78
  %84 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %85 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %84)
  tail call void @exit(i32 noundef 1) #34
  unreachable

86:                                               ; preds = %78
  %87 = fadd double %79, %80
  store i64 3, ptr %81, align 8, !tbaa !19
  %88 = getelementptr inbounds nuw i8, ptr %81, i64 8
  store double %87, ptr %88, align 8, !tbaa !22
  %89 = ptrtoint ptr %81 to i64
  br label %211

90:                                               ; preds = %37, %38
  br i1 %4, label %93, label %91

91:                                               ; preds = %90
  %92 = ashr i64 %0, 1
  br label %101

93:                                               ; preds = %90
  %94 = inttoptr i64 %0 to ptr
  %95 = load i64, ptr %94, align 8, !tbaa !23
  %96 = icmp eq i64 %95, 2
  br i1 %96, label %97, label %100

97:                                               ; preds = %93
  %98 = getelementptr inbounds nuw i8, ptr %94, i64 8
  %99 = load i64, ptr %98, align 8, !tbaa !25
  br label %101

100:                                              ; preds = %93
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

101:                                              ; preds = %91, %97
  %102 = phi i64 [ %92, %91 ], [ %99, %97 ]
  br i1 %6, label %105, label %103

103:                                              ; preds = %101
  %104 = ashr i64 %1, 1
  br label %113

105:                                              ; preds = %101
  %106 = inttoptr i64 %1 to ptr
  %107 = load i64, ptr %106, align 8, !tbaa !23
  %108 = icmp eq i64 %107, 2
  br i1 %108, label %109, label %112

109:                                              ; preds = %105
  %110 = getelementptr inbounds nuw i8, ptr %106, i64 8
  %111 = load i64, ptr %110, align 8, !tbaa !25
  br label %113

112:                                              ; preds = %105
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

113:                                              ; preds = %103, %109
  %114 = phi i64 [ %104, %103 ], [ %111, %109 ]
  %115 = add nsw i64 %114, %102
  %116 = add i64 %115, -4611686018427387904
  %117 = icmp sgt i64 %116, -1
  br i1 %117, label %118, label %119

118:                                              ; preds = %113
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.7, ptr noundef nonnull @.str.131) #36
  unreachable

119:                                              ; preds = %113
  %120 = shl nsw i64 %115, 1
  %121 = or disjoint i64 %120, 1
  br label %211

122:                                              ; preds = %27, %25
  br i1 %4, label %123, label %130

123:                                              ; preds = %122
  %124 = inttoptr i64 %0 to ptr
  br label %125

125:                                              ; preds = %123, %19
  %126 = phi ptr [ %124, %123 ], [ %20, %19 ]
  %127 = load i64, ptr %126, align 8, !tbaa !23
  br label %128

128:                                              ; preds = %17, %125
  %129 = phi i64 [ %127, %125 ], [ -1, %17 ]
  br i1 %6, label %130, label %208

130:                                              ; preds = %122, %128
  %131 = phi i64 [ %129, %128 ], [ 0, %122 ]
  %132 = icmp eq i64 %1, 0
  br i1 %132, label %208, label %133

133:                                              ; preds = %130
  %134 = inttoptr i64 %1 to ptr
  %135 = load i64, ptr %134, align 8, !tbaa !23
  %136 = icmp eq i64 %131, 4
  %137 = icmp eq i64 %135, 4
  %138 = select i1 %136, i1 %137, i1 false
  br i1 %138, label %139, label %162

139:                                              ; preds = %133
  %140 = inttoptr i64 %0 to ptr
  %141 = getelementptr inbounds nuw i8, ptr %140, i64 8
  %142 = load i64, ptr %141, align 8, !tbaa !18
  %143 = getelementptr inbounds nuw i8, ptr %134, i64 8
  %144 = load i64, ptr %143, align 8, !tbaa !18
  %145 = add i64 %144, %142
  %146 = add i64 %145, 25
  %147 = tail call i64 @llvm.umax.i64(i64 %146, i64 1)
  %148 = tail call ptr @calloc(i64 noundef 1, i64 noundef %147) #33
  %149 = icmp eq ptr %148, null
  br i1 %149, label %150, label %153

150:                                              ; preds = %139
  %151 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %152 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %151)
  tail call void @exit(i32 noundef 1) #34
  unreachable

153:                                              ; preds = %139
  store i64 4, ptr %148, align 8, !tbaa !16
  %154 = getelementptr inbounds nuw i8, ptr %148, i64 8
  store i64 %145, ptr %154, align 8, !tbaa !18
  %155 = getelementptr inbounds nuw i8, ptr %148, i64 16
  %156 = getelementptr inbounds nuw i8, ptr %140, i64 16
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 %155, ptr noundef nonnull align 1 %156, i64 noundef %142, i1 noundef false) #35
  %157 = getelementptr inbounds i8, ptr %155, i64 %142
  %158 = getelementptr inbounds nuw i8, ptr %134, i64 16
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 %157, ptr noundef nonnull align 1 %158, i64 noundef %144, i1 noundef false) #35
  %159 = load i64, ptr %154, align 8, !tbaa !18
  %160 = getelementptr inbounds i8, ptr %155, i64 %159
  store i8 0, ptr %160, align 1, !tbaa !10
  %161 = ptrtoint ptr %148 to i64
  br label %211

162:                                              ; preds = %133
  %163 = icmp eq i64 %131, 5
  %164 = icmp eq i64 %135, 5
  %165 = select i1 %163, i1 %164, i1 false
  br i1 %165, label %179, label %166

166:                                              ; preds = %162
  %167 = icmp eq i64 %131, 6
  %168 = icmp eq i64 %135, 6
  %169 = select i1 %167, i1 %168, i1 false
  br i1 %169, label %170, label %208

170:                                              ; preds = %166
  %171 = inttoptr i64 %0 to ptr
  %172 = getelementptr inbounds nuw i8, ptr %171, i64 8
  %173 = load i64, ptr %172, align 8, !tbaa !27
  %174 = getelementptr inbounds nuw i8, ptr %134, i64 8
  %175 = load i64, ptr %174, align 8, !tbaa !27
  %176 = add nsw i64 %175, %173
  %177 = tail call fastcc i64 @mktuple(i64 noundef %176)
  %178 = inttoptr i64 %177 to ptr
  br label %189

179:                                              ; preds = %162
  %180 = inttoptr i64 %0 to ptr
  %181 = getelementptr inbounds nuw i8, ptr %180, i64 8
  %182 = load i64, ptr %181, align 8, !tbaa !27
  %183 = getelementptr inbounds nuw i8, ptr %134, i64 8
  %184 = load i64, ptr %183, align 8, !tbaa !27
  %185 = add nsw i64 %184, %182
  %186 = tail call fastcc i64 @mklist(i64 noundef %185)
  %187 = inttoptr i64 %186 to ptr
  %188 = getelementptr inbounds nuw i8, ptr %187, i64 8
  store i64 %185, ptr %188, align 8, !tbaa !27
  br label %189

189:                                              ; preds = %170, %179
  %190 = phi ptr [ %174, %170 ], [ %183, %179 ]
  %191 = phi ptr [ %172, %170 ], [ %181, %179 ]
  %192 = phi ptr [ %171, %170 ], [ %180, %179 ]
  %193 = phi ptr [ %178, %170 ], [ %187, %179 ]
  %194 = phi i64 [ %177, %170 ], [ %186, %179 ]
  %195 = getelementptr inbounds nuw i8, ptr %193, i64 24
  %196 = load ptr, ptr %195, align 8, !tbaa !32
  %197 = getelementptr inbounds nuw i8, ptr %192, i64 24
  %198 = load ptr, ptr %197, align 8, !tbaa !32
  %199 = load i64, ptr %191, align 8, !tbaa !27
  %200 = shl i64 %199, 3
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %196, ptr noundef align 1 %198, i64 noundef %200, i1 noundef false) #35
  %201 = load ptr, ptr %195, align 8, !tbaa !32
  %202 = load i64, ptr %191, align 8, !tbaa !27
  %203 = getelementptr inbounds i64, ptr %201, i64 %202
  %204 = getelementptr inbounds nuw i8, ptr %134, i64 24
  %205 = load ptr, ptr %204, align 8, !tbaa !32
  %206 = load i64, ptr %190, align 8, !tbaa !27
  %207 = shl i64 %206, 3
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %203, ptr noundef align 1 %205, i64 noundef %207, i1 noundef false) #35
  br label %211

208:                                              ; preds = %130, %128, %166
  %209 = tail call fastcc ptr @tname(i64 noundef %0)
  %210 = tail call fastcc ptr @tname(i64 noundef %1)
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.132, ptr noundef nonnull @.str.9, ptr noundef nonnull %209, ptr noundef nonnull %210) #36
  unreachable

211:                                              ; preds = %153, %189, %119, %86, %13
  %212 = phi i64 [ %14, %13 ], [ %89, %86 ], [ %121, %119 ], [ %161, %153 ], [ %194, %189 ]
  ret i64 %212
}

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare { i64, i1 } @llvm.sadd.with.overflow.i64(i64, i64) #13

; Function Attrs: noreturn nounwind ssp uwtable(sync)
define internal void @thr(ptr noundef %0, ptr noundef readonly captures(none) %1, ...) unnamed_addr #5 {
  %3 = alloca [1024 x i8], align 1
  %4 = alloca ptr, align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %3) #35
  call void @llvm.lifetime.start.p0(ptr nonnull %4) #35
  call void @llvm.va_start.p0(ptr nonnull %4)
  %5 = load ptr, ptr %4, align 8, !tbaa !67
  %6 = call i32 @vsnprintf(ptr nonnull %3, i64 1024, ptr %1, ptr %5)
  call void @llvm.va_end.p0(ptr nonnull %4)
  %7 = call fastcc i64 @exc_by_name(ptr noundef %0)
  %8 = call fastcc i64 @new_inst(i64 noundef %7)
  %9 = call fastcc i64 @mktuple(i64 noundef 1)
  %10 = call i64 @strlen(ptr noundef nonnull dereferenceable(1) %3) #35
  %11 = call fastcc i64 @mkstr(ptr noundef nonnull %3, i64 noundef %10)
  %12 = inttoptr i64 %9 to ptr
  %13 = getelementptr inbounds nuw i8, ptr %12, i64 24
  %14 = load ptr, ptr %13, align 8, !tbaa !32
  store i64 %11, ptr %14, align 8, !tbaa !11
  %15 = inttoptr i64 %8 to ptr
  %16 = getelementptr inbounds nuw i8, ptr %15, i64 16
  %17 = load i64, ptr %16, align 8, !tbaa !39
  %18 = inttoptr i64 %17 to ptr
  %19 = load i64, ptr @K_args, align 8, !tbaa !11
  call fastcc void @dict_set(ptr noundef %18, i64 noundef %19, i64 noundef %9)
  %20 = call i64 @rt_raise(i64 noundef %8)
  unreachable
}

; Function Attrs: nocallback nofree nounwind memory(argmem: readwrite)
declare ptr @__memcpy_chk(ptr noalias noundef writeonly, ptr noalias noundef readonly captures(none), i64 noundef, i64 noundef) local_unnamed_addr #14

; Function Attrs: nofree nounwind ssp uwtable(sync)
define internal fastcc noundef i64 @mklist(i64 noundef %0) unnamed_addr #0 {
  %2 = tail call dereferenceable_or_null(32) ptr @calloc(i64 noundef 1, i64 noundef 32) #33
  %3 = icmp eq ptr %2, null
  br i1 %3, label %4, label %7

4:                                                ; preds = %1
  %5 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %6 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %5)
  tail call void @exit(i32 noundef 1) #34
  unreachable

7:                                                ; preds = %1
  store i64 5, ptr %2, align 8, !tbaa !69
  %8 = tail call i64 @llvm.smax.i64(i64 %0, i64 4)
  %9 = getelementptr inbounds nuw i8, ptr %2, i64 16
  store i64 %8, ptr %9, align 8, !tbaa !70
  %10 = shl i64 %8, 3
  %11 = tail call i64 @llvm.umax.i64(i64 %10, i64 1)
  %12 = tail call ptr @calloc(i64 noundef 1, i64 noundef %11) #33
  %13 = icmp eq ptr %12, null
  br i1 %13, label %14, label %17

14:                                               ; preds = %7
  %15 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %16 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %15)
  tail call void @exit(i32 noundef 1) #34
  unreachable

17:                                               ; preds = %7
  %18 = getelementptr inbounds nuw i8, ptr %2, i64 24
  store ptr %12, ptr %18, align 8, !tbaa !32
  %19 = ptrtoint ptr %2 to i64
  ret i64 %19
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_sub(i64 noundef %0, i64 noundef %1) local_unnamed_addr #2 {
  %3 = and i64 %0, 1
  %4 = icmp eq i64 %3, 0
  %5 = and i64 %1, 1
  %6 = icmp ne i64 %5, 0
  %7 = and i64 %3, %1
  %8 = icmp eq i64 %7, 0
  br i1 %8, label %16, label %9

9:                                                ; preds = %2
  %10 = add nsw i64 %1, -1
  %11 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %0, i64 %10)
  %12 = extractvalue { i64, i1 } %11, 1
  br i1 %12, label %15, label %13

13:                                               ; preds = %9
  %14 = extractvalue { i64, i1 } %11, 0
  br label %210

15:                                               ; preds = %9
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.7, ptr noundef nonnull @.str.8) #36
  unreachable

16:                                               ; preds = %2
  br i1 %4, label %17, label %24

17:                                               ; preds = %16
  %18 = icmp eq i64 %0, 0
  br i1 %18, label %207, label %19

19:                                               ; preds = %17
  %20 = inttoptr i64 %0 to ptr
  %21 = load i64, ptr %20, align 8, !tbaa !23
  %22 = and i64 %21, -2
  %23 = icmp eq i64 %22, 2
  br i1 %23, label %24, label %123

24:                                               ; preds = %19, %16
  br i1 %6, label %32, label %25

25:                                               ; preds = %24
  %26 = icmp eq i64 %1, 0
  br i1 %26, label %122, label %27

27:                                               ; preds = %25
  %28 = inttoptr i64 %1 to ptr
  %29 = load i64, ptr %28, align 8, !tbaa !23
  %30 = and i64 %29, -2
  %31 = icmp eq i64 %30, 2
  br i1 %31, label %32, label %122

32:                                               ; preds = %27, %24
  br i1 %4, label %33, label %37

33:                                               ; preds = %32
  %34 = inttoptr i64 %0 to ptr
  %35 = load i64, ptr %34, align 8, !tbaa !23
  %36 = icmp eq i64 %35, 3
  br i1 %36, label %57, label %37

37:                                               ; preds = %32, %33
  br i1 %6, label %90, label %38

38:                                               ; preds = %37
  %39 = inttoptr i64 %1 to ptr
  %40 = load i64, ptr %39, align 8, !tbaa !23
  %41 = icmp eq i64 %40, 3
  br i1 %41, label %42, label %90

42:                                               ; preds = %38
  br i1 %4, label %46, label %43

43:                                               ; preds = %42
  %44 = ashr i64 %0, 1
  %45 = sitofp i64 %44 to double
  br label %66

46:                                               ; preds = %42
  %47 = inttoptr i64 %0 to ptr
  %48 = load i64, ptr %47, align 8, !tbaa !23
  switch i64 %48, label %56 [
    i64 2, label %52
    i64 3, label %49
  ]

49:                                               ; preds = %46
  %50 = getelementptr inbounds nuw i8, ptr %47, i64 8
  %51 = load double, ptr %50, align 8, !tbaa !22
  br label %60

52:                                               ; preds = %46
  %53 = getelementptr inbounds nuw i8, ptr %47, i64 8
  %54 = load i64, ptr %53, align 8, !tbaa !25
  %55 = sitofp i64 %54 to double
  br label %60

56:                                               ; preds = %46
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.108) #36
  unreachable

57:                                               ; preds = %33
  %58 = getelementptr inbounds nuw i8, ptr %34, i64 8
  %59 = load double, ptr %58, align 8, !tbaa !22
  br i1 %6, label %63, label %60

60:                                               ; preds = %49, %52, %57
  %61 = phi double [ %55, %52 ], [ %59, %57 ], [ %51, %49 ]
  %62 = inttoptr i64 %1 to ptr
  br label %66

63:                                               ; preds = %57
  %64 = ashr i64 %1, 1
  %65 = sitofp i64 %64 to double
  br label %78

66:                                               ; preds = %60, %43
  %67 = phi ptr [ %62, %60 ], [ %39, %43 ]
  %68 = phi double [ %61, %60 ], [ %45, %43 ]
  %69 = load i64, ptr %67, align 8, !tbaa !23
  switch i64 %69, label %77 [
    i64 2, label %70
    i64 3, label %74
  ]

70:                                               ; preds = %66
  %71 = getelementptr inbounds nuw i8, ptr %67, i64 8
  %72 = load i64, ptr %71, align 8, !tbaa !25
  %73 = sitofp i64 %72 to double
  br label %78

74:                                               ; preds = %66
  %75 = getelementptr inbounds nuw i8, ptr %67, i64 8
  %76 = load double, ptr %75, align 8, !tbaa !22
  br label %78

77:                                               ; preds = %66
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.108) #36
  unreachable

78:                                               ; preds = %63, %70, %74
  %79 = phi double [ %59, %63 ], [ %68, %70 ], [ %68, %74 ]
  %80 = phi double [ %65, %63 ], [ %73, %70 ], [ %76, %74 ]
  %81 = tail call dereferenceable_or_null(16) ptr @calloc(i64 noundef 1, i64 noundef 16) #33
  %82 = icmp eq ptr %81, null
  br i1 %82, label %83, label %86

83:                                               ; preds = %78
  %84 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %85 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %84)
  tail call void @exit(i32 noundef 1) #34
  unreachable

86:                                               ; preds = %78
  %87 = fsub double %79, %80
  store i64 3, ptr %81, align 8, !tbaa !19
  %88 = getelementptr inbounds nuw i8, ptr %81, i64 8
  store double %87, ptr %88, align 8, !tbaa !22
  %89 = ptrtoint ptr %81 to i64
  br label %210

90:                                               ; preds = %37, %38
  br i1 %4, label %93, label %91

91:                                               ; preds = %90
  %92 = ashr i64 %0, 1
  br label %101

93:                                               ; preds = %90
  %94 = inttoptr i64 %0 to ptr
  %95 = load i64, ptr %94, align 8, !tbaa !23
  %96 = icmp eq i64 %95, 2
  br i1 %96, label %97, label %100

97:                                               ; preds = %93
  %98 = getelementptr inbounds nuw i8, ptr %94, i64 8
  %99 = load i64, ptr %98, align 8, !tbaa !25
  br label %101

100:                                              ; preds = %93
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

101:                                              ; preds = %91, %97
  %102 = phi i64 [ %92, %91 ], [ %99, %97 ]
  br i1 %6, label %103, label %105

103:                                              ; preds = %101
  %104 = ashr i64 %1, 1
  br label %113

105:                                              ; preds = %101
  %106 = inttoptr i64 %1 to ptr
  %107 = load i64, ptr %106, align 8, !tbaa !23
  %108 = icmp eq i64 %107, 2
  br i1 %108, label %109, label %112

109:                                              ; preds = %105
  %110 = getelementptr inbounds nuw i8, ptr %106, i64 8
  %111 = load i64, ptr %110, align 8, !tbaa !25
  br label %113

112:                                              ; preds = %105
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

113:                                              ; preds = %103, %109
  %114 = phi i64 [ %104, %103 ], [ %111, %109 ]
  %115 = sub nsw i64 %102, %114
  %116 = add i64 %115, -4611686018427387904
  %117 = icmp sgt i64 %116, -1
  br i1 %117, label %118, label %119

118:                                              ; preds = %113
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.7, ptr noundef nonnull @.str.131) #36
  unreachable

119:                                              ; preds = %113
  %120 = shl nsw i64 %115, 1
  %121 = or disjoint i64 %120, 1
  br label %210

122:                                              ; preds = %27, %25
  br i1 %4, label %128, label %207

123:                                              ; preds = %19
  %124 = icmp ne i64 %21, 8
  %125 = icmp eq i64 %1, 0
  %126 = or i1 %125, %124
  %127 = or i1 %6, %126
  br i1 %127, label %207, label %133

128:                                              ; preds = %122
  %129 = inttoptr i64 %0 to ptr
  %130 = load i64, ptr %129, align 8, !tbaa !23
  %131 = icmp ne i64 %130, 8
  %132 = or i1 %26, %131
  br i1 %132, label %207, label %133

133:                                              ; preds = %128, %123
  %134 = inttoptr i64 %1 to ptr
  %135 = load i64, ptr %134, align 8, !tbaa !23
  %136 = icmp eq i64 %135, 8
  br i1 %136, label %137, label %207

137:                                              ; preds = %133
  %138 = tail call dereferenceable_or_null(56) ptr @calloc(i64 noundef 1, i64 noundef 56) #33
  %139 = icmp eq ptr %138, null
  br i1 %139, label %140, label %143

140:                                              ; preds = %137
  %141 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %142 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %141)
  tail call void @exit(i32 noundef 1) #34
  unreachable

143:                                              ; preds = %137
  store i64 8, ptr %138, align 8, !tbaa !68
  %144 = ptrtoint ptr %138 to i64
  %145 = inttoptr i64 %0 to ptr
  %146 = getelementptr inbounds nuw i8, ptr %145, i64 16
  %147 = load i64, ptr %146, align 8, !tbaa !35
  %148 = icmp sgt i64 %147, 0
  br i1 %148, label %149, label %210

149:                                              ; preds = %143
  %150 = getelementptr inbounds nuw i8, ptr %145, i64 32
  %151 = getelementptr inbounds nuw i8, ptr %134, i64 40
  %152 = getelementptr inbounds nuw i8, ptr %134, i64 48
  %153 = getelementptr inbounds nuw i8, ptr %134, i64 32
  br label %154

154:                                              ; preds = %149, %203
  %155 = phi i64 [ 0, %149 ], [ %204, %203 ]
  %156 = load ptr, ptr %150, align 8, !tbaa !36
  %157 = getelementptr inbounds nuw %struct.Ent, ptr %156, i64 %155
  %158 = load i64, ptr %157, align 8, !tbaa !37
  %159 = icmp eq i64 %158, 0
  br i1 %159, label %203, label %160

160:                                              ; preds = %154
  %161 = getelementptr inbounds nuw i8, ptr %157, i64 16
  %162 = load i64, ptr %161, align 8, !tbaa !39
  %163 = load i64, ptr %151, align 8, !tbaa !40
  %164 = icmp eq i64 %163, 0
  br i1 %164, label %200, label %165

165:                                              ; preds = %160
  %166 = add nsw i64 %163, -1
  %167 = and i64 %166, %162
  %168 = load ptr, ptr %152, align 8, !tbaa !41
  %169 = getelementptr inbounds i64, ptr %168, i64 %167
  %170 = load i64, ptr %169, align 8, !tbaa !11
  %171 = icmp slt i64 %170, 0
  br i1 %171, label %200, label %172

172:                                              ; preds = %165, %191
  %173 = phi ptr [ %192, %191 ], [ %168, %165 ]
  %174 = phi i64 [ %196, %191 ], [ %170, %165 ]
  %175 = phi i64 [ %194, %191 ], [ %167, %165 ]
  %176 = load ptr, ptr %153, align 8, !tbaa !36
  %177 = getelementptr inbounds nuw %struct.Ent, ptr %176, i64 %174
  %178 = load i64, ptr %177, align 8, !tbaa !37
  %179 = icmp eq i64 %178, 0
  br i1 %179, label %191, label %180

180:                                              ; preds = %172
  %181 = getelementptr inbounds nuw i8, ptr %177, i64 16
  %182 = load i64, ptr %181, align 8, !tbaa !39
  %183 = icmp eq i64 %182, %162
  br i1 %183, label %184, label %191

184:                                              ; preds = %180
  %185 = icmp eq i64 %178, %158
  br i1 %185, label %203, label %186

186:                                              ; preds = %184
  %187 = tail call i64 @rt_eq_i(i64 noundef %178, i64 noundef %158) #39
  %188 = icmp eq i64 %187, 0
  br i1 %188, label %189, label %203

189:                                              ; preds = %186
  %190 = load ptr, ptr %152, align 8, !tbaa !41
  br label %191

191:                                              ; preds = %189, %180, %172
  %192 = phi ptr [ %190, %189 ], [ %173, %172 ], [ %173, %180 ]
  %193 = add nuw nsw i64 %175, 1
  %194 = and i64 %193, %166
  %195 = getelementptr inbounds i64, ptr %192, i64 %194
  %196 = load i64, ptr %195, align 8, !tbaa !11
  %197 = icmp slt i64 %196, 0
  br i1 %197, label %198, label %172

198:                                              ; preds = %191
  %199 = load i64, ptr %157, align 8, !tbaa !37
  br label %200

200:                                              ; preds = %198, %160, %165
  %201 = phi i64 [ %199, %198 ], [ %158, %160 ], [ %158, %165 ]
  %202 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  tail call fastcc void @dict_set(ptr noundef nonnull %138, i64 noundef %201, i64 noundef %202)
  br label %203

203:                                              ; preds = %186, %184, %200, %154
  %204 = add nuw nsw i64 %155, 1
  %205 = load i64, ptr %146, align 8, !tbaa !35
  %206 = icmp slt i64 %204, %205
  br i1 %206, label %154, label %210, !llvm.loop !88

207:                                              ; preds = %123, %17, %122, %128, %133
  %208 = tail call fastcc ptr @tname(i64 noundef %0)
  %209 = tail call fastcc ptr @tname(i64 noundef %1)
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.132, ptr noundef nonnull @.str.10, ptr noundef nonnull %208, ptr noundef nonnull %209) #36
  unreachable

210:                                              ; preds = %203, %143, %119, %86, %13
  %211 = phi i64 [ %14, %13 ], [ %89, %86 ], [ %121, %119 ], [ %144, %143 ], [ %144, %203 ]
  ret i64 %211
}

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare { i64, i1 } @llvm.ssub.with.overflow.i64(i64, i64) #13

; Function Attrs: nofree nounwind ssp uwtable(sync)
define internal fastcc noundef i64 @dict_new(i64 noundef range(i64 7, 9) %0) unnamed_addr #0 {
  %2 = tail call dereferenceable_or_null(56) ptr @calloc(i64 noundef 1, i64 noundef 56) #33
  %3 = icmp eq ptr %2, null
  br i1 %3, label %4, label %7

4:                                                ; preds = %1
  %5 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %6 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %5)
  tail call void @exit(i32 noundef 1) #34
  unreachable

7:                                                ; preds = %1
  store i64 %0, ptr %2, align 8, !tbaa !68
  %8 = ptrtoint ptr %2 to i64
  ret i64 %8
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_mul(i64 noundef %0, i64 noundef %1) local_unnamed_addr #2 {
  %3 = and i64 %0, 1
  %4 = icmp eq i64 %3, 0
  %5 = and i64 %1, 1
  %6 = icmp eq i64 %5, 0
  %7 = and i64 %3, %1
  %8 = icmp eq i64 %7, 0
  br i1 %8, label %18, label %9

9:                                                ; preds = %2
  %10 = add nsw i64 %0, -1
  %11 = ashr i64 %1, 1
  %12 = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %10, i64 %11)
  %13 = extractvalue { i64, i1 } %12, 1
  br i1 %13, label %17, label %14

14:                                               ; preds = %9
  %15 = extractvalue { i64, i1 } %12, 0
  %16 = or disjoint i64 %15, 1
  br label %180

17:                                               ; preds = %9
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.7, ptr noundef nonnull @.str.8) #36
  unreachable

18:                                               ; preds = %2
  br i1 %4, label %19, label %26

19:                                               ; preds = %18
  %20 = icmp eq i64 %0, 0
  br i1 %20, label %134, label %21

21:                                               ; preds = %19
  %22 = inttoptr i64 %0 to ptr
  %23 = load i64, ptr %22, align 8, !tbaa !23
  %24 = and i64 %23, -2
  %25 = icmp eq i64 %24, 2
  br i1 %25, label %26, label %131

26:                                               ; preds = %21, %18
  br i1 %6, label %27, label %34

27:                                               ; preds = %26
  %28 = icmp eq i64 %1, 0
  br i1 %28, label %128, label %29

29:                                               ; preds = %27
  %30 = inttoptr i64 %1 to ptr
  %31 = load i64, ptr %30, align 8, !tbaa !23
  %32 = and i64 %31, -2
  %33 = icmp eq i64 %32, 2
  br i1 %33, label %34, label %128

34:                                               ; preds = %29, %26
  br i1 %4, label %35, label %39

35:                                               ; preds = %34
  %36 = inttoptr i64 %0 to ptr
  %37 = load i64, ptr %36, align 8, !tbaa !23
  %38 = icmp eq i64 %37, 3
  br i1 %38, label %59, label %39

39:                                               ; preds = %34, %35
  br i1 %6, label %40, label %92

40:                                               ; preds = %39
  %41 = inttoptr i64 %1 to ptr
  %42 = load i64, ptr %41, align 8, !tbaa !23
  %43 = icmp eq i64 %42, 3
  br i1 %43, label %44, label %92

44:                                               ; preds = %40
  br i1 %4, label %48, label %45

45:                                               ; preds = %44
  %46 = ashr i64 %0, 1
  %47 = sitofp i64 %46 to double
  br label %68

48:                                               ; preds = %44
  %49 = inttoptr i64 %0 to ptr
  %50 = load i64, ptr %49, align 8, !tbaa !23
  switch i64 %50, label %58 [
    i64 2, label %54
    i64 3, label %51
  ]

51:                                               ; preds = %48
  %52 = getelementptr inbounds nuw i8, ptr %49, i64 8
  %53 = load double, ptr %52, align 8, !tbaa !22
  br label %62

54:                                               ; preds = %48
  %55 = getelementptr inbounds nuw i8, ptr %49, i64 8
  %56 = load i64, ptr %55, align 8, !tbaa !25
  %57 = sitofp i64 %56 to double
  br label %62

58:                                               ; preds = %48
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.108) #36
  unreachable

59:                                               ; preds = %35
  %60 = getelementptr inbounds nuw i8, ptr %36, i64 8
  %61 = load double, ptr %60, align 8, !tbaa !22
  br i1 %6, label %62, label %65

62:                                               ; preds = %51, %54, %59
  %63 = phi double [ %57, %54 ], [ %61, %59 ], [ %53, %51 ]
  %64 = inttoptr i64 %1 to ptr
  br label %68

65:                                               ; preds = %59
  %66 = ashr i64 %1, 1
  %67 = sitofp i64 %66 to double
  br label %80

68:                                               ; preds = %62, %45
  %69 = phi ptr [ %64, %62 ], [ %41, %45 ]
  %70 = phi double [ %63, %62 ], [ %47, %45 ]
  %71 = load i64, ptr %69, align 8, !tbaa !23
  switch i64 %71, label %79 [
    i64 2, label %72
    i64 3, label %76
  ]

72:                                               ; preds = %68
  %73 = getelementptr inbounds nuw i8, ptr %69, i64 8
  %74 = load i64, ptr %73, align 8, !tbaa !25
  %75 = sitofp i64 %74 to double
  br label %80

76:                                               ; preds = %68
  %77 = getelementptr inbounds nuw i8, ptr %69, i64 8
  %78 = load double, ptr %77, align 8, !tbaa !22
  br label %80

79:                                               ; preds = %68
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.108) #36
  unreachable

80:                                               ; preds = %65, %72, %76
  %81 = phi double [ %61, %65 ], [ %70, %72 ], [ %70, %76 ]
  %82 = phi double [ %67, %65 ], [ %75, %72 ], [ %78, %76 ]
  %83 = tail call dereferenceable_or_null(16) ptr @calloc(i64 noundef 1, i64 noundef 16) #33
  %84 = icmp eq ptr %83, null
  br i1 %84, label %85, label %88

85:                                               ; preds = %80
  %86 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %87 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %86)
  tail call void @exit(i32 noundef 1) #34
  unreachable

88:                                               ; preds = %80
  %89 = fmul double %81, %82
  store i64 3, ptr %83, align 8, !tbaa !19
  %90 = getelementptr inbounds nuw i8, ptr %83, i64 8
  store double %89, ptr %90, align 8, !tbaa !22
  %91 = ptrtoint ptr %83 to i64
  br label %180

92:                                               ; preds = %39, %40
  br i1 %4, label %95, label %93

93:                                               ; preds = %92
  %94 = ashr i64 %0, 1
  br label %103

95:                                               ; preds = %92
  %96 = inttoptr i64 %0 to ptr
  %97 = load i64, ptr %96, align 8, !tbaa !23
  %98 = icmp eq i64 %97, 2
  br i1 %98, label %99, label %102

99:                                               ; preds = %95
  %100 = getelementptr inbounds nuw i8, ptr %96, i64 8
  %101 = load i64, ptr %100, align 8, !tbaa !25
  br label %103

102:                                              ; preds = %95
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

103:                                              ; preds = %93, %99
  %104 = phi i64 [ %94, %93 ], [ %101, %99 ]
  br i1 %6, label %107, label %105

105:                                              ; preds = %103
  %106 = ashr i64 %1, 1
  br label %115

107:                                              ; preds = %103
  %108 = inttoptr i64 %1 to ptr
  %109 = load i64, ptr %108, align 8, !tbaa !23
  %110 = icmp eq i64 %109, 2
  br i1 %110, label %111, label %114

111:                                              ; preds = %107
  %112 = getelementptr inbounds nuw i8, ptr %108, i64 8
  %113 = load i64, ptr %112, align 8, !tbaa !25
  br label %115

114:                                              ; preds = %107
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

115:                                              ; preds = %105, %111
  %116 = phi i64 [ %106, %105 ], [ %113, %111 ]
  %117 = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %104, i64 %116)
  %118 = extractvalue { i64, i1 } %117, 1
  br i1 %118, label %119, label %120

119:                                              ; preds = %115
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.7, ptr noundef nonnull @.str.8) #36
  unreachable

120:                                              ; preds = %115
  %121 = extractvalue { i64, i1 } %117, 0
  %122 = add i64 %121, -4611686018427387904
  %123 = icmp sgt i64 %122, -1
  br i1 %123, label %124, label %125

124:                                              ; preds = %120
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.7, ptr noundef nonnull @.str.131) #36
  unreachable

125:                                              ; preds = %120
  %126 = shl nsw i64 %121, 1
  %127 = or disjoint i64 %126, 1
  br label %180

128:                                              ; preds = %29, %27
  br i1 %4, label %129, label %136

129:                                              ; preds = %128
  %130 = inttoptr i64 %0 to ptr
  br label %131

131:                                              ; preds = %129, %21
  %132 = phi ptr [ %130, %129 ], [ %22, %21 ]
  %133 = load i64, ptr %132, align 8, !tbaa !23
  br label %134

134:                                              ; preds = %19, %131
  %135 = phi i64 [ %133, %131 ], [ -1, %19 ]
  br i1 %6, label %136, label %146

136:                                              ; preds = %128, %134
  %137 = phi i64 [ %135, %134 ], [ 0, %128 ]
  %138 = icmp eq i64 %1, 0
  br i1 %138, label %177, label %139

139:                                              ; preds = %136
  %140 = inttoptr i64 %1 to ptr
  %141 = load i64, ptr %140, align 8, !tbaa !23
  %142 = add i64 %141, -4
  %143 = icmp ult i64 %142, 3
  %144 = add i64 %137, -4
  %145 = icmp ult i64 %144, 3
  br i1 %145, label %149, label %161

146:                                              ; preds = %134
  %147 = add i64 %135, -4
  %148 = icmp ult i64 %147, 3
  br i1 %148, label %153, label %177

149:                                              ; preds = %139
  %150 = inttoptr i64 %1 to ptr
  %151 = load i64, ptr %150, align 8, !tbaa !23
  %152 = icmp eq i64 %151, 2
  br i1 %152, label %155, label %161

153:                                              ; preds = %146
  %154 = ashr i64 %1, 1
  br label %158

155:                                              ; preds = %149
  %156 = getelementptr inbounds nuw i8, ptr %150, i64 8
  %157 = load i64, ptr %156, align 8, !tbaa !25
  br label %158

158:                                              ; preds = %153, %155
  %159 = phi i64 [ %154, %153 ], [ %157, %155 ]
  %160 = tail call fastcc i64 @repeat_seq(i64 noundef %0, i64 noundef %159)
  br label %180

161:                                              ; preds = %139, %149
  br i1 %143, label %162, label %177

162:                                              ; preds = %161
  br i1 %4, label %163, label %169

163:                                              ; preds = %162
  %164 = icmp eq i64 %0, 0
  br i1 %164, label %177, label %165

165:                                              ; preds = %163
  %166 = inttoptr i64 %0 to ptr
  %167 = load i64, ptr %166, align 8, !tbaa !23
  %168 = icmp eq i64 %167, 2
  br i1 %168, label %171, label %177

169:                                              ; preds = %162
  %170 = ashr i64 %0, 1
  br label %174

171:                                              ; preds = %165
  %172 = getelementptr inbounds nuw i8, ptr %166, i64 8
  %173 = load i64, ptr %172, align 8, !tbaa !25
  br label %174

174:                                              ; preds = %169, %171
  %175 = phi i64 [ %170, %169 ], [ %173, %171 ]
  %176 = tail call fastcc i64 @repeat_seq(i64 noundef %1, i64 noundef %175)
  br label %180

177:                                              ; preds = %136, %163, %146, %161, %165
  %178 = tail call fastcc ptr @tname(i64 noundef %0)
  %179 = tail call fastcc ptr @tname(i64 noundef %1)
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.132, ptr noundef nonnull @.str.11, ptr noundef nonnull %178, ptr noundef nonnull %179) #36
  unreachable

180:                                              ; preds = %158, %174, %125, %88, %14
  %181 = phi i64 [ %16, %14 ], [ %91, %88 ], [ %127, %125 ], [ %160, %158 ], [ %176, %174 ]
  ret i64 %181
}

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64) #13

; Function Attrs: nounwind ssp uwtable(sync)
define internal fastcc i64 @repeat_seq(i64 noundef %0, i64 noundef %1) unnamed_addr #2 {
  %3 = tail call i64 @llvm.smax.i64(i64 %1, i64 0)
  %4 = and i64 %0, 1
  %5 = icmp ne i64 %4, 0
  %6 = icmp eq i64 %0, 0
  %7 = or i1 %6, %5
  %8 = inttoptr i64 %0 to ptr
  br i1 %7, label %9, label %12

9:                                                ; preds = %2
  %10 = getelementptr inbounds nuw i8, ptr %8, i64 8
  %11 = load i64, ptr %10, align 8, !tbaa !27
  br label %55

12:                                               ; preds = %2
  %13 = load i64, ptr %8, align 8, !tbaa !23
  %14 = icmp eq i64 %13, 4
  br i1 %14, label %15, label %51

15:                                               ; preds = %12
  %16 = tail call dereferenceable_or_null(64) ptr @calloc(i64 noundef 1, i64 noundef 64) #33
  %17 = icmp eq ptr %16, null
  br i1 %17, label %23, label %18

18:                                               ; preds = %15
  %19 = icmp sgt i64 %1, 0
  br i1 %19, label %20, label %26

20:                                               ; preds = %18
  %21 = getelementptr inbounds nuw i8, ptr %8, i64 16
  %22 = getelementptr inbounds nuw i8, ptr %8, i64 8
  br label %30

23:                                               ; preds = %15
  %24 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %25 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %24)
  tail call void @exit(i32 noundef 1) #34
  unreachable

26:                                               ; preds = %44, %18
  %27 = phi i64 [ 0, %18 ], [ %36, %44 ]
  %28 = phi ptr [ %16, %18 ], [ %46, %44 ]
  %29 = tail call fastcc i64 @mkstr(ptr noundef nonnull %28, i64 noundef %27)
  br label %81

30:                                               ; preds = %20, %44
  %31 = phi i64 [ 0, %20 ], [ %49, %44 ]
  %32 = phi ptr [ %16, %20 ], [ %46, %44 ]
  %33 = phi i64 [ 0, %20 ], [ %36, %44 ]
  %34 = phi i64 [ 64, %20 ], [ %45, %44 ]
  %35 = load i64, ptr %22, align 8, !tbaa !18
  %36 = add nsw i64 %35, %33
  %37 = icmp slt i64 %36, %34
  br i1 %37, label %44, label %38

38:                                               ; preds = %30, %38
  %39 = phi i64 [ %40, %38 ], [ %34, %30 ]
  %40 = shl nsw i64 %39, 1
  %41 = icmp sgt i64 %40, %36
  br i1 %41, label %42, label %38, !llvm.loop !83

42:                                               ; preds = %38
  %43 = tail call ptr @realloc(ptr noundef nonnull %32, i64 noundef %40) #38
  br label %44

44:                                               ; preds = %30, %42
  %45 = phi i64 [ %40, %42 ], [ %34, %30 ]
  %46 = phi ptr [ %43, %42 ], [ %32, %30 ]
  %47 = getelementptr inbounds i8, ptr %46, i64 %33
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %47, ptr noundef nonnull readonly align 1 %21, i64 noundef %35, i1 noundef false) #35
  %48 = getelementptr inbounds i8, ptr %46, i64 %36
  store i8 0, ptr %48, align 1, !tbaa !10
  %49 = add nuw nsw i64 %31, 1
  %50 = icmp eq i64 %49, %1
  br i1 %50, label %26, label %30, !llvm.loop !89

51:                                               ; preds = %12
  %52 = getelementptr inbounds nuw i8, ptr %8, i64 8
  %53 = load i64, ptr %52, align 8, !tbaa !27
  %54 = icmp eq i64 %13, 5
  br i1 %54, label %59, label %55

55:                                               ; preds = %51, %9
  %56 = phi i64 [ %11, %9 ], [ %53, %51 ]
  %57 = mul nsw i64 %56, %3
  %58 = tail call fastcc i64 @mktuple(i64 noundef %57)
  br label %64

59:                                               ; preds = %51
  %60 = mul nsw i64 %53, %3
  %61 = tail call fastcc i64 @mklist(i64 noundef %60)
  %62 = inttoptr i64 %61 to ptr
  %63 = getelementptr inbounds nuw i8, ptr %62, i64 8
  store i64 %60, ptr %63, align 8, !tbaa !27
  br label %64

64:                                               ; preds = %55, %59
  %65 = phi i64 [ %61, %59 ], [ %58, %55 ]
  %66 = phi i64 [ %53, %59 ], [ %56, %55 ]
  %67 = icmp sgt i64 %1, 0
  br i1 %67, label %68, label %81

68:                                               ; preds = %64
  %69 = inttoptr i64 %65 to ptr
  %70 = getelementptr inbounds nuw i8, ptr %69, i64 24
  %71 = getelementptr inbounds nuw i8, ptr %8, i64 24
  %72 = shl i64 %66, 3
  br label %73

73:                                               ; preds = %68, %73
  %74 = phi i64 [ 0, %68 ], [ %79, %73 ]
  %75 = load ptr, ptr %70, align 8, !tbaa !32
  %76 = mul nsw i64 %74, %66
  %77 = getelementptr inbounds i64, ptr %75, i64 %76
  %78 = load ptr, ptr %71, align 8, !tbaa !32
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %77, ptr noundef align 1 %78, i64 noundef %72, i1 noundef false) #35
  %79 = add nuw nsw i64 %74, 1
  %80 = icmp eq i64 %79, %1
  br i1 %80, label %81, label %73, !llvm.loop !90

81:                                               ; preds = %73, %64, %26
  %82 = phi i64 [ %29, %26 ], [ %65, %64 ], [ %65, %73 ]
  ret i64 %82
}

; Function Attrs: nounwind ssp uwtable(sync)
define noundef i64 @rt_truediv(i64 noundef %0, i64 noundef %1) local_unnamed_addr #2 {
  %3 = and i64 %0, 1
  %4 = icmp eq i64 %3, 0
  br i1 %4, label %5, label %12

5:                                                ; preds = %2
  %6 = icmp eq i64 %0, 0
  br i1 %6, label %22, label %7

7:                                                ; preds = %5
  %8 = inttoptr i64 %0 to ptr
  %9 = load i64, ptr %8, align 8, !tbaa !23
  %10 = and i64 %9, -2
  %11 = icmp eq i64 %10, 2
  br i1 %11, label %12, label %22

12:                                               ; preds = %7, %2
  %13 = and i64 %1, 1
  %14 = icmp eq i64 %13, 0
  br i1 %14, label %15, label %25

15:                                               ; preds = %12
  %16 = icmp eq i64 %1, 0
  br i1 %16, label %22, label %17

17:                                               ; preds = %15
  %18 = inttoptr i64 %1 to ptr
  %19 = load i64, ptr %18, align 8, !tbaa !23
  %20 = and i64 %19, -2
  %21 = icmp eq i64 %20, 2
  br i1 %21, label %28, label %22

22:                                               ; preds = %17, %7, %15, %5
  %23 = tail call fastcc ptr @tname(i64 noundef %0)
  %24 = tail call fastcc ptr @tname(i64 noundef %1)
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.132, ptr noundef nonnull @.str.12, ptr noundef nonnull %23, ptr noundef nonnull %24) #36
  unreachable

25:                                               ; preds = %12
  %26 = ashr i64 %1, 1
  %27 = sitofp i64 %26 to double
  br label %36

28:                                               ; preds = %17
  %29 = icmp eq i64 %19, 2
  %30 = getelementptr inbounds nuw i8, ptr %18, i64 8
  br i1 %29, label %31, label %34

31:                                               ; preds = %28
  %32 = load i64, ptr %30, align 8, !tbaa !25
  %33 = sitofp i64 %32 to double
  br label %36

34:                                               ; preds = %28
  %35 = load double, ptr %30, align 8, !tbaa !22
  br label %36

36:                                               ; preds = %25, %31, %34
  %37 = phi double [ %27, %25 ], [ %33, %31 ], [ %35, %34 ]
  %38 = fcmp oeq double %37, 0.000000e+00
  br i1 %38, label %39, label %40

39:                                               ; preds = %36
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.13, ptr noundef nonnull @.str.14) #36
  unreachable

40:                                               ; preds = %36
  br i1 %4, label %44, label %41

41:                                               ; preds = %40
  %42 = ashr i64 %0, 1
  %43 = sitofp i64 %42 to double
  br label %55

44:                                               ; preds = %40
  %45 = inttoptr i64 %0 to ptr
  %46 = load i64, ptr %45, align 8, !tbaa !23
  switch i64 %46, label %54 [
    i64 2, label %47
    i64 3, label %51
  ]

47:                                               ; preds = %44
  %48 = getelementptr inbounds nuw i8, ptr %45, i64 8
  %49 = load i64, ptr %48, align 8, !tbaa !25
  %50 = sitofp i64 %49 to double
  br label %55

51:                                               ; preds = %44
  %52 = getelementptr inbounds nuw i8, ptr %45, i64 8
  %53 = load double, ptr %52, align 8, !tbaa !22
  br label %55

54:                                               ; preds = %44
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.108) #36
  unreachable

55:                                               ; preds = %41, %47, %51
  %56 = phi double [ %43, %41 ], [ %50, %47 ], [ %53, %51 ]
  %57 = tail call dereferenceable_or_null(16) ptr @calloc(i64 noundef 1, i64 noundef 16) #33
  %58 = icmp eq ptr %57, null
  br i1 %58, label %59, label %62

59:                                               ; preds = %55
  %60 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %61 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %60)
  tail call void @exit(i32 noundef 1) #34
  unreachable

62:                                               ; preds = %55
  %63 = fdiv double %56, %37
  store i64 3, ptr %57, align 8, !tbaa !19
  %64 = getelementptr inbounds nuw i8, ptr %57, i64 8
  store double %63, ptr %64, align 8, !tbaa !22
  %65 = ptrtoint ptr %57 to i64
  ret i64 %65
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_floordiv(i64 noundef %0, i64 noundef %1) local_unnamed_addr #2 {
  %3 = and i64 %0, 1
  %4 = icmp eq i64 %3, 0
  br i1 %4, label %5, label %12

5:                                                ; preds = %2
  %6 = icmp eq i64 %0, 0
  br i1 %6, label %22, label %7

7:                                                ; preds = %5
  %8 = inttoptr i64 %0 to ptr
  %9 = load i64, ptr %8, align 8, !tbaa !23
  %10 = and i64 %9, -2
  %11 = icmp eq i64 %10, 2
  br i1 %11, label %12, label %22

12:                                               ; preds = %7, %2
  %13 = and i64 %1, 1
  %14 = icmp eq i64 %13, 0
  br i1 %14, label %15, label %25

15:                                               ; preds = %12
  %16 = icmp eq i64 %1, 0
  br i1 %16, label %22, label %17

17:                                               ; preds = %15
  %18 = inttoptr i64 %1 to ptr
  %19 = load i64, ptr %18, align 8, !tbaa !23
  %20 = and i64 %19, -2
  %21 = icmp eq i64 %20, 2
  br i1 %21, label %25, label %22

22:                                               ; preds = %17, %7, %15, %5
  %23 = tail call fastcc ptr @tname(i64 noundef %0)
  %24 = tail call fastcc ptr @tname(i64 noundef %1)
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.132, ptr noundef nonnull @.str.15, ptr noundef nonnull %23, ptr noundef nonnull %24) #36
  unreachable

25:                                               ; preds = %17, %12
  br i1 %4, label %26, label %30

26:                                               ; preds = %25
  %27 = inttoptr i64 %0 to ptr
  %28 = load i64, ptr %27, align 8, !tbaa !23
  %29 = icmp eq i64 %28, 2
  br i1 %29, label %30, label %80

30:                                               ; preds = %25, %26
  br i1 %14, label %31, label %35

31:                                               ; preds = %30
  %32 = inttoptr i64 %1 to ptr
  %33 = load i64, ptr %32, align 8, !tbaa !23
  %34 = icmp eq i64 %33, 2
  br i1 %34, label %35, label %84

35:                                               ; preds = %30, %31
  br i1 %4, label %38, label %36

36:                                               ; preds = %35
  %37 = ashr i64 %0, 1
  br label %46

38:                                               ; preds = %35
  %39 = inttoptr i64 %0 to ptr
  %40 = load i64, ptr %39, align 8, !tbaa !23
  %41 = icmp eq i64 %40, 2
  br i1 %41, label %42, label %45

42:                                               ; preds = %38
  %43 = getelementptr inbounds nuw i8, ptr %39, i64 8
  %44 = load i64, ptr %43, align 8, !tbaa !25
  br label %46

45:                                               ; preds = %38
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

46:                                               ; preds = %36, %42
  %47 = phi i64 [ %37, %36 ], [ %44, %42 ]
  br i1 %14, label %50, label %48

48:                                               ; preds = %46
  %49 = ashr i64 %1, 1
  br label %58

50:                                               ; preds = %46
  %51 = inttoptr i64 %1 to ptr
  %52 = load i64, ptr %51, align 8, !tbaa !23
  %53 = icmp eq i64 %52, 2
  br i1 %53, label %54, label %57

54:                                               ; preds = %50
  %55 = getelementptr inbounds nuw i8, ptr %51, i64 8
  %56 = load i64, ptr %55, align 8, !tbaa !25
  br label %58

57:                                               ; preds = %50
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

58:                                               ; preds = %48, %54
  %59 = phi i64 [ %49, %48 ], [ %56, %54 ]
  %60 = icmp eq i64 %59, 0
  br i1 %60, label %61, label %62

61:                                               ; preds = %58
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.13, ptr noundef nonnull @.str.16) #36
  unreachable

62:                                               ; preds = %58
  %63 = freeze i64 %47
  %64 = freeze i64 %59
  %65 = sdiv i64 %63, %64
  %66 = mul i64 %65, %64
  %67 = sub i64 %63, %66
  %68 = icmp ne i64 %67, 0
  %69 = xor i64 %59, %47
  %70 = icmp slt i64 %69, 0
  %71 = and i1 %70, %68
  %72 = sext i1 %71 to i64
  %73 = add nsw i64 %65, %72
  %74 = add i64 %73, -4611686018427387904
  %75 = icmp sgt i64 %74, -1
  br i1 %75, label %76, label %77

76:                                               ; preds = %62
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.7, ptr noundef nonnull @.str.131) #36
  unreachable

77:                                               ; preds = %62
  %78 = shl nsw i64 %73, 1
  %79 = or disjoint i64 %78, 1
  br label %134

80:                                               ; preds = %26
  br i1 %14, label %81, label %98

81:                                               ; preds = %80
  %82 = inttoptr i64 %1 to ptr
  %83 = load i64, ptr %82, align 8, !tbaa !23
  br label %84

84:                                               ; preds = %81, %31
  %85 = phi i64 [ %83, %81 ], [ %33, %31 ]
  %86 = phi ptr [ %82, %81 ], [ %32, %31 ]
  switch i64 %85, label %94 [
    i64 2, label %87
    i64 3, label %91
  ]

87:                                               ; preds = %84
  %88 = getelementptr inbounds nuw i8, ptr %86, i64 8
  %89 = load i64, ptr %88, align 8, !tbaa !25
  %90 = sitofp i64 %89 to double
  br label %95

91:                                               ; preds = %84
  %92 = getelementptr inbounds nuw i8, ptr %86, i64 8
  %93 = load double, ptr %92, align 8, !tbaa !22
  br label %95

94:                                               ; preds = %84
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.108) #36
  unreachable

95:                                               ; preds = %87, %91
  %96 = phi double [ %93, %91 ], [ %90, %87 ]
  %97 = fcmp oeq double %96, 0.000000e+00
  br i1 %97, label %102, label %103

98:                                               ; preds = %80
  %99 = ashr i64 %1, 1
  %100 = sitofp i64 %99 to double
  %101 = icmp eq i64 %99, 0
  br i1 %101, label %102, label %109

102:                                              ; preds = %98, %95
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.13, ptr noundef nonnull @.str.17) #36
  unreachable

103:                                              ; preds = %95
  br i1 %4, label %104, label %106

104:                                              ; preds = %103
  %105 = inttoptr i64 %0 to ptr
  br label %109

106:                                              ; preds = %103
  %107 = ashr i64 %0, 1
  %108 = sitofp i64 %107 to double
  br label %121

109:                                              ; preds = %104, %98
  %110 = phi ptr [ %105, %104 ], [ %27, %98 ]
  %111 = phi double [ %96, %104 ], [ %100, %98 ]
  %112 = load i64, ptr %110, align 8, !tbaa !23
  switch i64 %112, label %120 [
    i64 2, label %113
    i64 3, label %117
  ]

113:                                              ; preds = %109
  %114 = getelementptr inbounds nuw i8, ptr %110, i64 8
  %115 = load i64, ptr %114, align 8, !tbaa !25
  %116 = sitofp i64 %115 to double
  br label %121

117:                                              ; preds = %109
  %118 = getelementptr inbounds nuw i8, ptr %110, i64 8
  %119 = load double, ptr %118, align 8, !tbaa !22
  br label %121

120:                                              ; preds = %109
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.108) #36
  unreachable

121:                                              ; preds = %106, %113, %117
  %122 = phi double [ %96, %106 ], [ %111, %113 ], [ %111, %117 ]
  %123 = phi double [ %108, %106 ], [ %116, %113 ], [ %119, %117 ]
  %124 = tail call dereferenceable_or_null(16) ptr @calloc(i64 noundef 1, i64 noundef 16) #33
  %125 = icmp eq ptr %124, null
  br i1 %125, label %126, label %129

126:                                              ; preds = %121
  %127 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %128 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %127)
  tail call void @exit(i32 noundef 1) #34
  unreachable

129:                                              ; preds = %121
  %130 = fdiv double %123, %122
  %131 = tail call double @llvm.floor.f64(double %130)
  store i64 3, ptr %124, align 8, !tbaa !19
  %132 = getelementptr inbounds nuw i8, ptr %124, i64 8
  store double %131, ptr %132, align 8, !tbaa !22
  %133 = ptrtoint ptr %124 to i64
  br label %134

134:                                              ; preds = %129, %77
  %135 = phi i64 [ %79, %77 ], [ %133, %129 ]
  ret i64 %135
}

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.floor.f64(double) #13

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_mod(i64 noundef %0, i64 noundef %1) local_unnamed_addr #2 {
  %3 = alloca %struct.SB, align 8
  %4 = alloca [1 x i64], align 8
  %5 = alloca %struct.SB, align 8
  %6 = alloca [8 x i8], align 1
  %7 = alloca [32 x i8], align 1
  %8 = alloca [96 x i8], align 1
  %9 = alloca [32 x i8], align 1
  %10 = alloca [512 x i8], align 1
  %11 = alloca i8, align 1
  %12 = and i64 %0, 1
  %13 = icmp eq i64 %12, 0
  br i1 %13, label %14, label %398

14:                                               ; preds = %2
  %15 = icmp eq i64 %0, 0
  br i1 %15, label %408, label %16

16:                                               ; preds = %14
  %17 = inttoptr i64 %0 to ptr
  %18 = load i64, ptr %17, align 8, !tbaa !23
  %19 = icmp eq i64 %18, 4
  br i1 %19, label %20, label %395

20:                                               ; preds = %16
  call void @llvm.lifetime.start.p0(ptr nonnull %4) #35
  %21 = and i64 %1, 1
  %22 = icmp ne i64 %21, 0
  %23 = icmp eq i64 %1, 0
  %24 = or i1 %23, %22
  br i1 %24, label %34, label %25

25:                                               ; preds = %20
  %26 = inttoptr i64 %1 to ptr
  %27 = load i64, ptr %26, align 8, !tbaa !23
  %28 = icmp eq i64 %27, 6
  br i1 %28, label %29, label %34

29:                                               ; preds = %25
  %30 = getelementptr inbounds nuw i8, ptr %26, i64 24
  %31 = load ptr, ptr %30, align 8, !tbaa !32
  %32 = getelementptr inbounds nuw i8, ptr %26, i64 8
  %33 = load i64, ptr %32, align 8, !tbaa !27
  br label %35

34:                                               ; preds = %25, %20
  store i64 %1, ptr %4, align 8, !tbaa !11
  br label %35

35:                                               ; preds = %34, %29
  %36 = phi i64 [ %33, %29 ], [ 1, %34 ]
  %37 = phi ptr [ %31, %29 ], [ %4, %34 ]
  call void @llvm.lifetime.start.p0(ptr nonnull %5) #35
  %38 = getelementptr inbounds nuw i8, ptr %5, i64 16
  %39 = getelementptr inbounds nuw i8, ptr %5, i64 8
  store <2 x i64> <i64 0, i64 64>, ptr %39, align 8, !tbaa !11
  %40 = tail call dereferenceable_or_null(64) ptr @calloc(i64 noundef 1, i64 noundef 64) #33
  %41 = icmp eq ptr %40, null
  br i1 %41, label %42, label %45

42:                                               ; preds = %35
  %43 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %44 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %43)
  tail call void @exit(i32 noundef 1) #34
  unreachable

45:                                               ; preds = %35
  store ptr %40, ptr %5, align 8, !tbaa !61
  %46 = getelementptr inbounds nuw i8, ptr %17, i64 8
  %47 = load i64, ptr %46, align 8, !tbaa !18
  %48 = icmp sgt i64 %47, 0
  br i1 %48, label %49, label %391

49:                                               ; preds = %45
  %50 = getelementptr inbounds nuw i8, ptr %17, i64 16
  %51 = getelementptr inbounds nuw i8, ptr %3, i64 8
  br label %55

52:                                               ; preds = %385
  %53 = load ptr, ptr %5, align 8, !tbaa !61
  %54 = load i64, ptr %39, align 8, !tbaa !63
  br label %391

55:                                               ; preds = %385, %49
  %56 = phi i64 [ %47, %49 ], [ %389, %385 ]
  %57 = phi i64 [ 0, %49 ], [ %387, %385 ]
  %58 = phi i64 [ 0, %49 ], [ %388, %385 ]
  %59 = getelementptr inbounds i8, ptr %50, i64 %58
  %60 = load i8, ptr %59, align 1, !tbaa !10
  %61 = icmp eq i8 %60, 37
  br i1 %61, label %80, label %62

62:                                               ; preds = %55
  %63 = load i64, ptr %39, align 8, !tbaa !63
  %64 = add nsw i64 %63, 1
  %65 = load i64, ptr %38, align 8, !tbaa !82
  %66 = icmp slt i64 %64, %65
  br i1 %66, label %67, label %69

67:                                               ; preds = %62
  %68 = load ptr, ptr %5, align 8, !tbaa !61
  br label %76

69:                                               ; preds = %62, %69
  %70 = phi i64 [ %71, %69 ], [ %65, %62 ]
  %71 = shl nsw i64 %70, 1
  %72 = icmp sgt i64 %71, %64
  br i1 %72, label %73, label %69, !llvm.loop !83

73:                                               ; preds = %69
  %74 = load ptr, ptr %5, align 8, !tbaa !61
  %75 = call ptr @realloc(ptr noundef %74, i64 noundef %71) #38
  store ptr %75, ptr %5, align 8, !tbaa !61
  store i64 %71, ptr %38, align 8, !tbaa !82
  br label %76

76:                                               ; preds = %73, %67
  %77 = phi ptr [ %68, %67 ], [ %75, %73 ]
  %78 = getelementptr inbounds i8, ptr %77, i64 %63
  store i8 %60, ptr %78, align 1
  store i64 %64, ptr %39, align 8, !tbaa !63
  %79 = getelementptr inbounds i8, ptr %77, i64 %64
  store i8 0, ptr %79, align 1, !tbaa !10
  br label %385

80:                                               ; preds = %55
  %81 = add nsw i64 %58, 1
  %82 = icmp slt i64 %81, %56
  br i1 %82, label %84, label %83

83:                                               ; preds = %80
  call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.25, ptr noundef nonnull @.str.172) #36
  unreachable

84:                                               ; preds = %80
  call void @llvm.lifetime.start.p0(ptr nonnull %6) #35
  %85 = getelementptr inbounds i8, ptr %50, i64 %81
  %86 = load i8, ptr %85, align 1, !tbaa !10
  %87 = icmp eq i8 %86, 0
  br i1 %87, label %88, label %89

88:                                               ; preds = %84
  store i8 0, ptr %6, align 1, !tbaa !10
  br label %156

89:                                               ; preds = %84, %105
  %90 = phi i8 [ %109, %105 ], [ %86, %84 ]
  %91 = phi i64 [ %107, %105 ], [ %81, %84 ]
  %92 = phi i32 [ %106, %105 ], [ 0, %84 ]
  %93 = zext nneg i8 %90 to i64
  %94 = icmp ugt i8 %90, 63
  %95 = shl nuw i64 1, %93
  %96 = and i64 %95, 325494096527361
  %97 = icmp eq i64 %96, 0
  %98 = select i1 %94, i1 true, i1 %97
  br i1 %98, label %114, label %99

99:                                               ; preds = %89
  %100 = icmp slt i32 %92, 7
  br i1 %100, label %101, label %105

101:                                              ; preds = %99
  %102 = add nsw i32 %92, 1
  %103 = sext i32 %92 to i64
  %104 = getelementptr inbounds i8, ptr %6, i64 %103
  store i8 %90, ptr %104, align 1, !tbaa !10
  br label %105

105:                                              ; preds = %101, %99
  %106 = phi i32 [ %102, %101 ], [ %92, %99 ]
  %107 = add nsw i64 %91, 1
  %108 = getelementptr inbounds i8, ptr %50, i64 %107
  %109 = load i8, ptr %108, align 1, !tbaa !10
  %110 = icmp eq i8 %109, 0
  br i1 %110, label %111, label %89, !llvm.loop !91

111:                                              ; preds = %105
  %112 = sext i32 %106 to i64
  %113 = getelementptr inbounds i8, ptr %6, i64 %112
  store i8 0, ptr %113, align 1, !tbaa !10
  br label %156

114:                                              ; preds = %89
  %115 = sext i32 %92 to i64
  %116 = getelementptr inbounds i8, ptr %6, i64 %115
  store i8 0, ptr %116, align 1, !tbaa !10
  %117 = icmp eq i8 %90, 42
  br i1 %117, label %118, label %140

118:                                              ; preds = %114
  %119 = add nsw i64 %57, 1
  %120 = getelementptr inbounds i64, ptr %37, i64 %57
  %121 = load i64, ptr %120, align 8, !tbaa !11
  %122 = and i64 %121, 1
  %123 = icmp eq i64 %122, 0
  br i1 %123, label %126, label %124

124:                                              ; preds = %118
  %125 = ashr i64 %121, 1
  br label %136

126:                                              ; preds = %118
  %127 = icmp eq i64 %121, 0
  br i1 %127, label %135, label %128

128:                                              ; preds = %126
  %129 = inttoptr i64 %121 to ptr
  %130 = load i64, ptr %129, align 8, !tbaa !23
  %131 = icmp eq i64 %130, 2
  br i1 %131, label %132, label %135

132:                                              ; preds = %128
  %133 = getelementptr inbounds nuw i8, ptr %129, i64 8
  %134 = load i64, ptr %133, align 8, !tbaa !25
  br label %136

135:                                              ; preds = %128, %126
  call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

136:                                              ; preds = %132, %124
  %137 = phi i64 [ %125, %124 ], [ %134, %132 ]
  %138 = trunc i64 %137 to i32
  %139 = add nsw i64 %91, 1
  br label %156

140:                                              ; preds = %114
  %141 = add i8 %90, -48
  %142 = icmp ult i8 %141, 10
  br i1 %142, label %143, label %156

143:                                              ; preds = %140, %143
  %144 = phi i8 [ %153, %143 ], [ %90, %140 ]
  %145 = phi i64 [ %148, %143 ], [ %91, %140 ]
  %146 = phi i32 [ %151, %143 ], [ 0, %140 ]
  %147 = mul nsw i32 %146, 10
  %148 = add nsw i64 %145, 1
  %149 = zext nneg i8 %144 to i32
  %150 = add nsw i32 %149, -48
  %151 = add i32 %150, %147
  %152 = getelementptr inbounds i8, ptr %50, i64 %148
  %153 = load i8, ptr %152, align 1, !tbaa !10
  %154 = add i8 %153, -48
  %155 = icmp ult i8 %154, 10
  br i1 %155, label %143, label %156, !llvm.loop !92

156:                                              ; preds = %143, %140, %136, %111, %88
  %157 = phi i32 [ %138, %136 ], [ -1, %140 ], [ -1, %111 ], [ -1, %88 ], [ %151, %143 ]
  %158 = phi i64 [ %139, %136 ], [ %91, %140 ], [ %107, %111 ], [ %81, %88 ], [ %148, %143 ]
  %159 = phi i64 [ %119, %136 ], [ %57, %140 ], [ %57, %111 ], [ %57, %88 ], [ %57, %143 ]
  %160 = getelementptr inbounds i8, ptr %50, i64 %158
  %161 = load i8, ptr %160, align 1, !tbaa !10
  %162 = icmp eq i8 %161, 46
  br i1 %162, label %163, label %182

163:                                              ; preds = %156
  %164 = add nsw i64 %158, 1
  %165 = getelementptr inbounds i8, ptr %50, i64 %164
  %166 = load i8, ptr %165, align 1, !tbaa !10
  %167 = add i8 %166, -48
  %168 = icmp ult i8 %167, 10
  br i1 %168, label %169, label %182

169:                                              ; preds = %163, %169
  %170 = phi i8 [ %179, %169 ], [ %166, %163 ]
  %171 = phi i64 [ %177, %169 ], [ %164, %163 ]
  %172 = phi i32 [ %176, %169 ], [ 0, %163 ]
  %173 = mul nsw i32 %172, 10
  %174 = zext nneg i8 %170 to i32
  %175 = add nsw i32 %174, -48
  %176 = add i32 %175, %173
  %177 = add nsw i64 %171, 1
  %178 = getelementptr inbounds i8, ptr %50, i64 %177
  %179 = load i8, ptr %178, align 1, !tbaa !10
  %180 = add i8 %179, -48
  %181 = icmp ult i8 %180, 10
  br i1 %181, label %169, label %182, !llvm.loop !93

182:                                              ; preds = %169, %163, %156
  %183 = phi i8 [ %161, %156 ], [ %166, %163 ], [ %179, %169 ]
  %184 = phi i32 [ -1, %156 ], [ 0, %163 ], [ %176, %169 ]
  %185 = phi i64 [ %158, %156 ], [ %164, %163 ], [ %177, %169 ]
  %186 = sext i8 %183 to i32
  %187 = icmp eq i8 %183, 37
  br i1 %187, label %188, label %206

188:                                              ; preds = %182
  %189 = load i64, ptr %39, align 8, !tbaa !63
  %190 = add nsw i64 %189, 1
  %191 = load i64, ptr %38, align 8, !tbaa !82
  %192 = icmp slt i64 %190, %191
  br i1 %192, label %193, label %195

193:                                              ; preds = %188
  %194 = load ptr, ptr %5, align 8, !tbaa !61
  br label %202

195:                                              ; preds = %188, %195
  %196 = phi i64 [ %197, %195 ], [ %191, %188 ]
  %197 = shl nsw i64 %196, 1
  %198 = icmp sgt i64 %197, %190
  br i1 %198, label %199, label %195, !llvm.loop !83

199:                                              ; preds = %195
  %200 = load ptr, ptr %5, align 8, !tbaa !61
  %201 = call ptr @realloc(ptr noundef %200, i64 noundef %197) #38
  store ptr %201, ptr %5, align 8, !tbaa !61
  store i64 %197, ptr %38, align 8, !tbaa !82
  br label %202

202:                                              ; preds = %199, %193
  %203 = phi ptr [ %194, %193 ], [ %201, %199 ]
  %204 = getelementptr inbounds i8, ptr %203, i64 %189
  store i8 37, ptr %204, align 1
  store i64 %190, ptr %39, align 8, !tbaa !63
  %205 = getelementptr inbounds i8, ptr %203, i64 %190
  store i8 0, ptr %205, align 1, !tbaa !10
  br label %383

206:                                              ; preds = %182
  %207 = icmp slt i64 %159, %36
  br i1 %207, label %209, label %208

208:                                              ; preds = %206
  call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.174) #36
  unreachable

209:                                              ; preds = %206
  %210 = add nsw i64 %159, 1
  %211 = getelementptr inbounds i64, ptr %37, i64 %159
  %212 = load i64, ptr %211, align 8, !tbaa !11
  %213 = call ptr @strchr(ptr noundef nonnull dereferenceable(1) %6, i32 noundef 45) #35
  %214 = icmp ne ptr %213, null
  %215 = zext i1 %214 to i32
  %216 = and i8 %183, -2
  %217 = icmp eq i8 %216, 114
  br i1 %217, label %218, label %242

218:                                              ; preds = %209
  %219 = icmp eq i8 %183, 115
  br i1 %219, label %220, label %222

220:                                              ; preds = %218
  %221 = call i64 @rt_str(i64 noundef %212)
  br label %232

222:                                              ; preds = %218
  call void @llvm.lifetime.start.p0(ptr nonnull %3) #35
  store <2 x i64> <i64 0, i64 64>, ptr %51, align 8, !tbaa !11
  %223 = call dereferenceable_or_null(64) ptr @calloc(i64 noundef 1, i64 noundef 64) #33
  %224 = icmp eq ptr %223, null
  br i1 %224, label %225, label %228

225:                                              ; preds = %222
  %226 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %227 = call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %226)
  call void @exit(i32 noundef 1) #34
  unreachable

228:                                              ; preds = %222
  store ptr %223, ptr %3, align 8, !tbaa !61
  call fastcc void @to_sb(ptr noundef %3, i64 noundef %212, i32 noundef 1)
  %229 = load ptr, ptr %3, align 8, !tbaa !61
  %230 = load i64, ptr %51, align 8, !tbaa !63
  %231 = call fastcc i64 @mkstr(ptr noundef %229, i64 noundef %230)
  call void @llvm.lifetime.end.p0(ptr nonnull %3) #35
  br label %232

232:                                              ; preds = %228, %220
  %233 = phi i64 [ %221, %220 ], [ %231, %228 ]
  %234 = inttoptr i64 %233 to ptr
  %235 = getelementptr inbounds nuw i8, ptr %234, i64 8
  %236 = load i64, ptr %235, align 8, !tbaa !18
  %237 = zext nneg i32 %184 to i64
  %238 = call i64 @llvm.smin.i64(i64 %236, i64 %237)
  %239 = icmp slt i32 %184, 0
  %240 = select i1 %239, i64 %236, i64 %238
  %241 = getelementptr inbounds nuw i8, ptr %234, i64 16
  call fastcc void @pad_into(ptr noundef %5, ptr noundef nonnull %241, i64 noundef %240, i32 noundef %157, i32 noundef %215, i8 noundef signext 32)
  br label %383

242:                                              ; preds = %209
  switch i8 %183, label %299 [
    i8 120, label %243
    i8 117, label %243
    i8 111, label %243
    i8 105, label %243
    i8 100, label %243
    i8 88, label %243
  ]

243:                                              ; preds = %242, %242, %242, %242, %242, %242
  %244 = and i64 %212, 1
  %245 = icmp eq i64 %244, 0
  br i1 %245, label %246, label %259

246:                                              ; preds = %243
  %247 = icmp eq i64 %212, 0
  br i1 %247, label %263, label %248

248:                                              ; preds = %246
  %249 = inttoptr i64 %212 to ptr
  %250 = load i64, ptr %249, align 8, !tbaa !23
  %251 = and i64 %250, -2
  %252 = icmp eq i64 %251, 2
  br i1 %252, label %253, label %263

253:                                              ; preds = %248
  %254 = icmp eq i64 %250, 3
  %255 = getelementptr inbounds nuw i8, ptr %249, i64 8
  br i1 %254, label %256, label %261

256:                                              ; preds = %253
  %257 = load double, ptr %255, align 8, !tbaa !22
  %258 = fptosi double %257 to i64
  br label %265

259:                                              ; preds = %243
  %260 = ashr i64 %212, 1
  br label %265

261:                                              ; preds = %253
  %262 = load i64, ptr %255, align 8, !tbaa !25
  br label %265

263:                                              ; preds = %248, %246
  %264 = call fastcc ptr @tname(i64 noundef %212)
  call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.175, i32 noundef %186, ptr noundef nonnull %264) #36
  unreachable

265:                                              ; preds = %261, %259, %256
  %266 = phi i64 [ %258, %256 ], [ %260, %259 ], [ %262, %261 ]
  call void @llvm.lifetime.start.p0(ptr nonnull %7) #35
  call void @llvm.lifetime.start.p0(ptr nonnull %8) #35
  %267 = icmp sgt i32 %157, -1
  %268 = select i1 %267, ptr @.str.11, ptr @.str.79
  %269 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr nonnull dereferenceable(1) %7, i64 32, ptr nonnull @.str.176, ptr nonnull %6, ptr nonnull %268, ptr nonnull @.str.79, ptr nonnull @.str.79, ptr nonnull @.str.79)
  switch i8 %183, label %275 [
    i8 120, label %270
    i8 111, label %270
    i8 88, label %270
  ]

270:                                              ; preds = %265, %265, %265
  %271 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr nonnull dereferenceable(1) %7, i64 32, ptr nonnull @.str.177, ptr nonnull %6, ptr nonnull %268, i32 %186)
  %272 = call ptr @strchr(ptr noundef nonnull dereferenceable(1) %7, i32 noundef 32) #35
  %273 = getelementptr inbounds nuw i8, ptr %272, i64 1
  %274 = call i64 @strlen(ptr noundef nonnull dereferenceable(1) %272) #35
  call void @llvm.memmove.p0.p0.i64(ptr noundef nonnull align 1 %272, ptr noundef nonnull align 1 %273, i64 noundef %274, i1 noundef false) #35
  br label %275

275:                                              ; preds = %270, %265
  br i1 %267, label %276, label %278

276:                                              ; preds = %275
  %277 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr nonnull dereferenceable(1) %8, i64 96, ptr nonnull %7, i32 %157, i64 %266)
  br label %280

278:                                              ; preds = %275
  %279 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr nonnull dereferenceable(1) %8, i64 96, ptr nonnull %7, i64 %266)
  br label %280

280:                                              ; preds = %278, %276
  %281 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %8) #35
  %282 = load i64, ptr %39, align 8, !tbaa !63
  %283 = add nsw i64 %282, %281
  %284 = load i64, ptr %38, align 8, !tbaa !82
  %285 = icmp slt i64 %283, %284
  br i1 %285, label %286, label %288

286:                                              ; preds = %280
  %287 = load ptr, ptr %5, align 8, !tbaa !61
  br label %295

288:                                              ; preds = %280, %288
  %289 = phi i64 [ %290, %288 ], [ %284, %280 ]
  %290 = shl nsw i64 %289, 1
  %291 = icmp sgt i64 %290, %283
  br i1 %291, label %292, label %288, !llvm.loop !83

292:                                              ; preds = %288
  %293 = load ptr, ptr %5, align 8, !tbaa !61
  %294 = call ptr @realloc(ptr noundef %293, i64 noundef %290) #38
  store ptr %294, ptr %5, align 8, !tbaa !61
  store i64 %290, ptr %38, align 8, !tbaa !82
  br label %295

295:                                              ; preds = %292, %286
  %296 = phi ptr [ %287, %286 ], [ %294, %292 ]
  %297 = getelementptr inbounds i8, ptr %296, i64 %282
  call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %297, ptr noundef nonnull readonly align 1 %8, i64 noundef %281, i1 noundef false) #35
  store i64 %283, ptr %39, align 8, !tbaa !63
  %298 = getelementptr inbounds i8, ptr %296, i64 %283
  store i8 0, ptr %298, align 1, !tbaa !10
  call void @llvm.lifetime.end.p0(ptr nonnull %8) #35
  call void @llvm.lifetime.end.p0(ptr nonnull %7) #35
  br label %383

299:                                              ; preds = %242
  %300 = call ptr @memchr(ptr nonnull dereferenceable(1) @.str.178, i32 %186, i64 7)
  %301 = icmp eq ptr %300, null
  br i1 %301, label %358, label %302

302:                                              ; preds = %299
  %303 = and i64 %212, 1
  %304 = icmp eq i64 %303, 0
  br i1 %304, label %308, label %305

305:                                              ; preds = %302
  %306 = ashr i64 %212, 1
  %307 = sitofp i64 %306 to double
  br label %321

308:                                              ; preds = %302
  %309 = icmp eq i64 %212, 0
  br i1 %309, label %320, label %310

310:                                              ; preds = %308
  %311 = inttoptr i64 %212 to ptr
  %312 = load i64, ptr %311, align 8, !tbaa !23
  switch i64 %312, label %320 [
    i64 2, label %313
    i64 3, label %317
  ]

313:                                              ; preds = %310
  %314 = getelementptr inbounds nuw i8, ptr %311, i64 8
  %315 = load i64, ptr %314, align 8, !tbaa !25
  %316 = sitofp i64 %315 to double
  br label %321

317:                                              ; preds = %310
  %318 = getelementptr inbounds nuw i8, ptr %311, i64 8
  %319 = load double, ptr %318, align 8, !tbaa !22
  br label %321

320:                                              ; preds = %310, %308
  call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.108) #36
  unreachable

321:                                              ; preds = %317, %313, %305
  %322 = phi double [ %307, %305 ], [ %316, %313 ], [ %319, %317 ]
  call void @llvm.lifetime.start.p0(ptr nonnull %9) #35
  call void @llvm.lifetime.start.p0(ptr nonnull %10) #35
  %323 = icmp sgt i32 %157, -1
  %324 = select i1 %323, ptr @.str.11, ptr @.str.79
  %325 = icmp sgt i32 %184, -1
  %326 = select i1 %325, ptr @.str.180, ptr @.str.79
  %327 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr nonnull dereferenceable(1) %9, i64 32, ptr nonnull @.str.179, ptr nonnull %6, ptr nonnull %324, ptr nonnull %326, i32 %186)
  %328 = select i1 %323, i1 %325, i1 false
  br i1 %328, label %329, label %331

329:                                              ; preds = %321
  %330 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr nonnull dereferenceable(1) %10, i64 512, ptr nonnull %9, i32 %157, i32 %184, double %322)
  br label %339

331:                                              ; preds = %321
  br i1 %323, label %332, label %334

332:                                              ; preds = %331
  %333 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr nonnull dereferenceable(1) %10, i64 512, ptr nonnull %9, i32 %157, double %322)
  br label %339

334:                                              ; preds = %331
  br i1 %325, label %335, label %337

335:                                              ; preds = %334
  %336 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr nonnull dereferenceable(1) %10, i64 512, ptr nonnull %9, i32 %184, double %322)
  br label %339

337:                                              ; preds = %334
  %338 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr nonnull dereferenceable(1) %10, i64 512, ptr nonnull %9, double %322)
  br label %339

339:                                              ; preds = %337, %335, %332, %329
  %340 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %10) #35
  %341 = load i64, ptr %39, align 8, !tbaa !63
  %342 = add nsw i64 %341, %340
  %343 = load i64, ptr %38, align 8, !tbaa !82
  %344 = icmp slt i64 %342, %343
  br i1 %344, label %345, label %347

345:                                              ; preds = %339
  %346 = load ptr, ptr %5, align 8, !tbaa !61
  br label %354

347:                                              ; preds = %339, %347
  %348 = phi i64 [ %349, %347 ], [ %343, %339 ]
  %349 = shl nsw i64 %348, 1
  %350 = icmp sgt i64 %349, %342
  br i1 %350, label %351, label %347, !llvm.loop !83

351:                                              ; preds = %347
  %352 = load ptr, ptr %5, align 8, !tbaa !61
  %353 = call ptr @realloc(ptr noundef %352, i64 noundef %349) #38
  store ptr %353, ptr %5, align 8, !tbaa !61
  store i64 %349, ptr %38, align 8, !tbaa !82
  br label %354

354:                                              ; preds = %351, %345
  %355 = phi ptr [ %346, %345 ], [ %353, %351 ]
  %356 = getelementptr inbounds i8, ptr %355, i64 %341
  call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %356, ptr noundef nonnull readonly align 1 %10, i64 noundef %340, i1 noundef false) #35
  store i64 %342, ptr %39, align 8, !tbaa !63
  %357 = getelementptr inbounds i8, ptr %355, i64 %342
  store i8 0, ptr %357, align 1, !tbaa !10
  call void @llvm.lifetime.end.p0(ptr nonnull %10) #35
  call void @llvm.lifetime.end.p0(ptr nonnull %9) #35
  br label %383

358:                                              ; preds = %299
  %359 = icmp eq i8 %183, 99
  br i1 %359, label %360, label %382

360:                                              ; preds = %358
  call void @llvm.lifetime.start.p0(ptr nonnull %11) #35
  %361 = and i64 %212, 1
  %362 = icmp eq i64 %361, 0
  br i1 %362, label %363, label %371

363:                                              ; preds = %360
  %364 = icmp eq i64 %212, 0
  br i1 %364, label %376, label %365

365:                                              ; preds = %363
  %366 = inttoptr i64 %212 to ptr
  %367 = load i64, ptr %366, align 8, !tbaa !23
  switch i64 %367, label %376 [
    i64 4, label %368
    i64 2, label %373
  ]

368:                                              ; preds = %365
  %369 = getelementptr inbounds nuw i8, ptr %366, i64 16
  %370 = load i8, ptr %369, align 8, !tbaa !10
  br label %380

371:                                              ; preds = %360
  %372 = ashr i64 %212, 1
  br label %377

373:                                              ; preds = %365
  %374 = getelementptr inbounds nuw i8, ptr %366, i64 8
  %375 = load i64, ptr %374, align 8, !tbaa !25
  br label %377

376:                                              ; preds = %365, %363
  call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

377:                                              ; preds = %373, %371
  %378 = phi i64 [ %372, %371 ], [ %375, %373 ]
  %379 = trunc i64 %378 to i8
  br label %380

380:                                              ; preds = %377, %368
  %381 = phi i8 [ %379, %377 ], [ %370, %368 ]
  store i8 %381, ptr %11, align 1, !tbaa !10
  call fastcc void @pad_into(ptr noundef %5, ptr noundef nonnull %11, i64 noundef 1, i32 noundef %157, i32 noundef %215, i8 noundef signext 32)
  call void @llvm.lifetime.end.p0(ptr nonnull %11) #35
  br label %383

382:                                              ; preds = %358
  call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.25, ptr noundef nonnull @.str.181, i32 noundef %186) #36
  unreachable

383:                                              ; preds = %380, %354, %295, %232, %202
  %384 = phi i64 [ %159, %202 ], [ %210, %295 ], [ %210, %380 ], [ %210, %354 ], [ %210, %232 ]
  call void @llvm.lifetime.end.p0(ptr nonnull %6) #35
  br label %385

385:                                              ; preds = %383, %76
  %386 = phi i64 [ %58, %76 ], [ %185, %383 ]
  %387 = phi i64 [ %57, %76 ], [ %384, %383 ]
  %388 = add nsw i64 %386, 1
  %389 = load i64, ptr %46, align 8, !tbaa !18
  %390 = icmp slt i64 %388, %389
  br i1 %390, label %55, label %52, !llvm.loop !94

391:                                              ; preds = %45, %52
  %392 = phi i64 [ %54, %52 ], [ 0, %45 ]
  %393 = phi ptr [ %53, %52 ], [ %40, %45 ]
  %394 = call fastcc i64 @mkstr(ptr noundef %393, i64 noundef %392)
  call void @llvm.lifetime.end.p0(ptr nonnull %5) #35
  call void @llvm.lifetime.end.p0(ptr nonnull %4) #35
  br label %523

395:                                              ; preds = %16
  %396 = and i64 %18, -2
  %397 = icmp eq i64 %396, 2
  br i1 %397, label %398, label %408

398:                                              ; preds = %395, %2
  %399 = and i64 %1, 1
  %400 = icmp eq i64 %399, 0
  br i1 %400, label %401, label %411

401:                                              ; preds = %398
  %402 = icmp eq i64 %1, 0
  br i1 %402, label %408, label %403

403:                                              ; preds = %401
  %404 = inttoptr i64 %1 to ptr
  %405 = load i64, ptr %404, align 8, !tbaa !23
  %406 = and i64 %405, -2
  %407 = icmp eq i64 %406, 2
  br i1 %407, label %411, label %408

408:                                              ; preds = %403, %395, %401, %14
  %409 = tail call fastcc ptr @tname(i64 noundef %0)
  %410 = tail call fastcc ptr @tname(i64 noundef %1)
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.132, ptr noundef nonnull @.str.18, ptr noundef nonnull %409, ptr noundef nonnull %410) #36
  unreachable

411:                                              ; preds = %403, %398
  br i1 %13, label %412, label %416

412:                                              ; preds = %411
  %413 = inttoptr i64 %0 to ptr
  %414 = load i64, ptr %413, align 8, !tbaa !23
  %415 = icmp eq i64 %414, 2
  br i1 %415, label %416, label %469

416:                                              ; preds = %411, %412
  br i1 %400, label %417, label %421

417:                                              ; preds = %416
  %418 = inttoptr i64 %1 to ptr
  %419 = load i64, ptr %418, align 8, !tbaa !23
  %420 = icmp eq i64 %419, 2
  br i1 %420, label %421, label %462

421:                                              ; preds = %416, %417
  br i1 %13, label %424, label %422

422:                                              ; preds = %421
  %423 = ashr i64 %0, 1
  br label %432

424:                                              ; preds = %421
  %425 = inttoptr i64 %0 to ptr
  %426 = load i64, ptr %425, align 8, !tbaa !23
  %427 = icmp eq i64 %426, 2
  br i1 %427, label %428, label %431

428:                                              ; preds = %424
  %429 = getelementptr inbounds nuw i8, ptr %425, i64 8
  %430 = load i64, ptr %429, align 8, !tbaa !25
  br label %432

431:                                              ; preds = %424
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

432:                                              ; preds = %422, %428
  %433 = phi i64 [ %423, %422 ], [ %430, %428 ]
  br i1 %400, label %436, label %434

434:                                              ; preds = %432
  %435 = ashr i64 %1, 1
  br label %444

436:                                              ; preds = %432
  %437 = inttoptr i64 %1 to ptr
  %438 = load i64, ptr %437, align 8, !tbaa !23
  %439 = icmp eq i64 %438, 2
  br i1 %439, label %440, label %443

440:                                              ; preds = %436
  %441 = getelementptr inbounds nuw i8, ptr %437, i64 8
  %442 = load i64, ptr %441, align 8, !tbaa !25
  br label %444

443:                                              ; preds = %436
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

444:                                              ; preds = %434, %440
  %445 = phi i64 [ %435, %434 ], [ %442, %440 ]
  %446 = icmp eq i64 %445, 0
  br i1 %446, label %447, label %448

447:                                              ; preds = %444
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.13, ptr noundef nonnull @.str.16) #36
  unreachable

448:                                              ; preds = %444
  %449 = srem i64 %433, %445
  %450 = icmp eq i64 %449, 0
  %451 = xor i64 %449, %445
  %452 = icmp slt i64 %451, 0
  %453 = select i1 %452, i64 %445, i64 0
  %454 = add nsw i64 %453, %449
  %455 = select i1 %450, i64 0, i64 %454
  %456 = add i64 %455, -4611686018427387904
  %457 = icmp sgt i64 %456, -1
  br i1 %457, label %458, label %459

458:                                              ; preds = %448
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.7, ptr noundef nonnull @.str.131) #36
  unreachable

459:                                              ; preds = %448
  %460 = shl nsw i64 %455, 1
  %461 = or disjoint i64 %460, 1
  br label %523

462:                                              ; preds = %417
  br i1 %13, label %463, label %466

463:                                              ; preds = %462
  %464 = inttoptr i64 %0 to ptr
  %465 = load i64, ptr %464, align 8, !tbaa !23
  br label %469

466:                                              ; preds = %462
  %467 = ashr i64 %0, 1
  %468 = sitofp i64 %467 to double
  br label %487

469:                                              ; preds = %463, %412
  %470 = phi i64 [ %465, %463 ], [ %414, %412 ]
  %471 = phi ptr [ %464, %463 ], [ %413, %412 ]
  switch i64 %470, label %479 [
    i64 2, label %472
    i64 3, label %476
  ]

472:                                              ; preds = %469
  %473 = getelementptr inbounds nuw i8, ptr %471, i64 8
  %474 = load i64, ptr %473, align 8, !tbaa !25
  %475 = sitofp i64 %474 to double
  br label %480

476:                                              ; preds = %469
  %477 = getelementptr inbounds nuw i8, ptr %471, i64 8
  %478 = load double, ptr %477, align 8, !tbaa !22
  br label %480

479:                                              ; preds = %469
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.108) #36
  unreachable

480:                                              ; preds = %472, %476
  %481 = phi double [ %478, %476 ], [ %475, %472 ]
  br i1 %400, label %482, label %484

482:                                              ; preds = %480
  %483 = inttoptr i64 %1 to ptr
  br label %487

484:                                              ; preds = %480
  %485 = ashr i64 %1, 1
  %486 = sitofp i64 %485 to double
  br label %499

487:                                              ; preds = %482, %466
  %488 = phi ptr [ %483, %482 ], [ %418, %466 ]
  %489 = phi double [ %481, %482 ], [ %468, %466 ]
  %490 = load i64, ptr %488, align 8, !tbaa !23
  switch i64 %490, label %498 [
    i64 2, label %491
    i64 3, label %495
  ]

491:                                              ; preds = %487
  %492 = getelementptr inbounds nuw i8, ptr %488, i64 8
  %493 = load i64, ptr %492, align 8, !tbaa !25
  %494 = sitofp i64 %493 to double
  br label %499

495:                                              ; preds = %487
  %496 = getelementptr inbounds nuw i8, ptr %488, i64 8
  %497 = load double, ptr %496, align 8, !tbaa !22
  br label %499

498:                                              ; preds = %487
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.108) #36
  unreachable

499:                                              ; preds = %484, %491, %495
  %500 = phi double [ %481, %484 ], [ %489, %491 ], [ %489, %495 ]
  %501 = phi double [ %486, %484 ], [ %494, %491 ], [ %497, %495 ]
  %502 = fcmp oeq double %501, 0.000000e+00
  br i1 %502, label %503, label %504

503:                                              ; preds = %499
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.13, ptr noundef nonnull @.str.19) #36
  unreachable

504:                                              ; preds = %499
  %505 = frem double %500, %501
  %506 = fcmp une double %505, 0.000000e+00
  br i1 %506, label %507, label %513

507:                                              ; preds = %504
  %508 = fcmp olt double %505, 0.000000e+00
  %509 = fcmp uge double %501, 0.000000e+00
  %510 = xor i1 %509, %508
  %511 = fadd double %501, %505
  %512 = select i1 %510, double %505, double %511
  br label %513

513:                                              ; preds = %507, %504
  %514 = phi double [ %505, %504 ], [ %512, %507 ]
  %515 = tail call dereferenceable_or_null(16) ptr @calloc(i64 noundef 1, i64 noundef 16) #33
  %516 = icmp eq ptr %515, null
  br i1 %516, label %517, label %520

517:                                              ; preds = %513
  %518 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %519 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %518)
  tail call void @exit(i32 noundef 1) #34
  unreachable

520:                                              ; preds = %513
  store i64 3, ptr %515, align 8, !tbaa !19
  %521 = getelementptr inbounds nuw i8, ptr %515, i64 8
  store double %514, ptr %521, align 8, !tbaa !22
  %522 = ptrtoint ptr %515 to i64
  br label %523

523:                                              ; preds = %520, %459, %391
  %524 = phi i64 [ %394, %391 ], [ %461, %459 ], [ %522, %520 ]
  ret i64 %524
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_pow(i64 noundef %0, i64 noundef %1) local_unnamed_addr #2 {
  %3 = and i64 %0, 1
  %4 = icmp eq i64 %3, 0
  br i1 %4, label %5, label %12

5:                                                ; preds = %2
  %6 = icmp eq i64 %0, 0
  br i1 %6, label %22, label %7

7:                                                ; preds = %5
  %8 = inttoptr i64 %0 to ptr
  %9 = load i64, ptr %8, align 8, !tbaa !23
  %10 = and i64 %9, -2
  %11 = icmp eq i64 %10, 2
  br i1 %11, label %12, label %22

12:                                               ; preds = %7, %2
  %13 = and i64 %1, 1
  %14 = icmp eq i64 %13, 0
  br i1 %14, label %15, label %25

15:                                               ; preds = %12
  %16 = icmp eq i64 %1, 0
  br i1 %16, label %22, label %17

17:                                               ; preds = %15
  %18 = inttoptr i64 %1 to ptr
  %19 = load i64, ptr %18, align 8, !tbaa !23
  %20 = and i64 %19, -2
  %21 = icmp eq i64 %20, 2
  br i1 %21, label %25, label %22

22:                                               ; preds = %17, %7, %15, %5
  %23 = tail call fastcc ptr @tname(i64 noundef %0)
  %24 = tail call fastcc ptr @tname(i64 noundef %1)
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.132, ptr noundef nonnull @.str.20, ptr noundef nonnull %23, ptr noundef nonnull %24) #36
  unreachable

25:                                               ; preds = %17, %12
  br i1 %4, label %26, label %30

26:                                               ; preds = %25
  %27 = inttoptr i64 %0 to ptr
  %28 = load i64, ptr %27, align 8, !tbaa !23
  %29 = icmp eq i64 %28, 2
  br i1 %29, label %30, label %104

30:                                               ; preds = %25, %26
  br i1 %14, label %31, label %35

31:                                               ; preds = %30
  %32 = inttoptr i64 %1 to ptr
  %33 = load i64, ptr %32, align 8, !tbaa !23
  %34 = icmp eq i64 %33, 2
  br i1 %34, label %37, label %97

35:                                               ; preds = %30
  %36 = ashr i64 %1, 1
  br label %40

37:                                               ; preds = %31
  %38 = getelementptr inbounds nuw i8, ptr %32, i64 8
  %39 = load i64, ptr %38, align 8, !tbaa !25
  br label %40

40:                                               ; preds = %35, %37
  %41 = phi i64 [ %36, %35 ], [ %39, %37 ]
  %42 = icmp sgt i64 %41, -1
  br i1 %42, label %43, label %97

43:                                               ; preds = %40
  br i1 %4, label %46, label %44

44:                                               ; preds = %43
  %45 = ashr i64 %0, 1
  br label %54

46:                                               ; preds = %43
  %47 = inttoptr i64 %0 to ptr
  %48 = load i64, ptr %47, align 8, !tbaa !23
  %49 = icmp eq i64 %48, 2
  br i1 %49, label %50, label %53

50:                                               ; preds = %46
  %51 = getelementptr inbounds nuw i8, ptr %47, i64 8
  %52 = load i64, ptr %51, align 8, !tbaa !25
  br label %54

53:                                               ; preds = %46
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

54:                                               ; preds = %44, %50
  %55 = phi i64 [ %45, %44 ], [ %52, %50 ]
  br i1 %14, label %58, label %56

56:                                               ; preds = %54
  %57 = ashr i64 %1, 1
  br label %66

58:                                               ; preds = %54
  %59 = inttoptr i64 %1 to ptr
  %60 = load i64, ptr %59, align 8, !tbaa !23
  %61 = icmp eq i64 %60, 2
  br i1 %61, label %62, label %65

62:                                               ; preds = %58
  %63 = getelementptr inbounds nuw i8, ptr %59, i64 8
  %64 = load i64, ptr %63, align 8, !tbaa !25
  br label %66

65:                                               ; preds = %58
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

66:                                               ; preds = %56, %62
  %67 = phi i64 [ %57, %56 ], [ %64, %62 ]
  %68 = icmp sgt i64 %67, 0
  br i1 %68, label %69, label %93

69:                                               ; preds = %66, %84
  %70 = phi i64 [ %81, %84 ], [ 1, %66 ]
  %71 = phi i64 [ %82, %84 ], [ %67, %66 ]
  %72 = phi i64 [ %87, %84 ], [ %55, %66 ]
  %73 = and i64 %71, 1
  %74 = icmp eq i64 %73, 0
  br i1 %74, label %80, label %75

75:                                               ; preds = %69
  %76 = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %70, i64 %72)
  %77 = extractvalue { i64, i1 } %76, 1
  %78 = extractvalue { i64, i1 } %76, 0
  br i1 %77, label %79, label %80

79:                                               ; preds = %75
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.7, ptr noundef nonnull @.str.8) #36
  unreachable

80:                                               ; preds = %75, %69
  %81 = phi i64 [ %78, %75 ], [ %70, %69 ]
  %82 = lshr i64 %71, 1
  %83 = icmp eq i64 %82, 0
  br i1 %83, label %89, label %84

84:                                               ; preds = %80
  %85 = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %72, i64 %72)
  %86 = extractvalue { i64, i1 } %85, 1
  %87 = extractvalue { i64, i1 } %85, 0
  br i1 %86, label %88, label %69, !llvm.loop !95

88:                                               ; preds = %84
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.7, ptr noundef nonnull @.str.8) #36
  unreachable

89:                                               ; preds = %80
  %90 = add i64 %81, -4611686018427387904
  %91 = icmp sgt i64 %90, -1
  br i1 %91, label %92, label %93

92:                                               ; preds = %89
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.7, ptr noundef nonnull @.str.131) #36
  unreachable

93:                                               ; preds = %66, %89
  %94 = phi i64 [ %81, %89 ], [ 1, %66 ]
  %95 = shl nsw i64 %94, 1
  %96 = or disjoint i64 %95, 1
  br label %142

97:                                               ; preds = %40, %31
  br i1 %4, label %98, label %101

98:                                               ; preds = %97
  %99 = inttoptr i64 %0 to ptr
  %100 = load i64, ptr %99, align 8, !tbaa !23
  br label %104

101:                                              ; preds = %97
  %102 = ashr i64 %0, 1
  %103 = sitofp i64 %102 to double
  br label %115

104:                                              ; preds = %98, %26
  %105 = phi i64 [ %100, %98 ], [ %28, %26 ]
  %106 = phi ptr [ %99, %98 ], [ %27, %26 ]
  switch i64 %105, label %114 [
    i64 2, label %107
    i64 3, label %111
  ]

107:                                              ; preds = %104
  %108 = getelementptr inbounds nuw i8, ptr %106, i64 8
  %109 = load i64, ptr %108, align 8, !tbaa !25
  %110 = sitofp i64 %109 to double
  br label %115

111:                                              ; preds = %104
  %112 = getelementptr inbounds nuw i8, ptr %106, i64 8
  %113 = load double, ptr %112, align 8, !tbaa !22
  br label %115

114:                                              ; preds = %104
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.108) #36
  unreachable

115:                                              ; preds = %101, %107, %111
  %116 = phi double [ %103, %101 ], [ %110, %107 ], [ %113, %111 ]
  br i1 %14, label %120, label %117

117:                                              ; preds = %115
  %118 = ashr i64 %1, 1
  %119 = sitofp i64 %118 to double
  br label %131

120:                                              ; preds = %115
  %121 = inttoptr i64 %1 to ptr
  %122 = load i64, ptr %121, align 8, !tbaa !23
  switch i64 %122, label %130 [
    i64 2, label %123
    i64 3, label %127
  ]

123:                                              ; preds = %120
  %124 = getelementptr inbounds nuw i8, ptr %121, i64 8
  %125 = load i64, ptr %124, align 8, !tbaa !25
  %126 = sitofp i64 %125 to double
  br label %131

127:                                              ; preds = %120
  %128 = getelementptr inbounds nuw i8, ptr %121, i64 8
  %129 = load double, ptr %128, align 8, !tbaa !22
  br label %131

130:                                              ; preds = %120
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.108) #36
  unreachable

131:                                              ; preds = %117, %123, %127
  %132 = phi double [ %119, %117 ], [ %126, %123 ], [ %129, %127 ]
  %133 = tail call dereferenceable_or_null(16) ptr @calloc(i64 noundef 1, i64 noundef 16) #33
  %134 = icmp eq ptr %133, null
  br i1 %134, label %135, label %138

135:                                              ; preds = %131
  %136 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %137 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %136)
  tail call void @exit(i32 noundef 1) #34
  unreachable

138:                                              ; preds = %131
  %139 = tail call double @llvm.pow.f64(double %116, double %132)
  store i64 3, ptr %133, align 8, !tbaa !19
  %140 = getelementptr inbounds nuw i8, ptr %133, i64 8
  store double %139, ptr %140, align 8, !tbaa !22
  %141 = ptrtoint ptr %133 to i64
  br label %142

142:                                              ; preds = %138, %93
  %143 = phi i64 [ %96, %93 ], [ %141, %138 ]
  ret i64 %143
}

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.pow.f64(double, double) #13

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_and(i64 noundef %0, i64 noundef %1) local_unnamed_addr #2 {
  %3 = and i64 %0, 1
  %4 = icmp eq i64 %3, 0
  br i1 %4, label %7, label %5

5:                                                ; preds = %2
  %6 = and i64 %1, 1
  br label %91

7:                                                ; preds = %2
  %8 = icmp eq i64 %0, 0
  br i1 %8, label %100, label %9

9:                                                ; preds = %7
  %10 = inttoptr i64 %0 to ptr
  %11 = load i64, ptr %10, align 8, !tbaa !23
  %12 = icmp ne i64 %11, 8
  %13 = and i64 %1, 1
  %14 = icmp ne i64 %13, 0
  %15 = or i1 %14, %12
  %16 = icmp eq i64 %1, 0
  %17 = or i1 %16, %15
  br i1 %17, label %89, label %18

18:                                               ; preds = %9
  %19 = inttoptr i64 %1 to ptr
  %20 = load i64, ptr %19, align 8, !tbaa !23
  %21 = icmp eq i64 %20, 8
  br i1 %21, label %22, label %100

22:                                               ; preds = %18
  %23 = tail call dereferenceable_or_null(56) ptr @calloc(i64 noundef 1, i64 noundef 56) #33
  %24 = icmp eq ptr %23, null
  br i1 %24, label %25, label %28

25:                                               ; preds = %22
  %26 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %27 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %26)
  tail call void @exit(i32 noundef 1) #34
  unreachable

28:                                               ; preds = %22
  store i64 8, ptr %23, align 8, !tbaa !68
  %29 = ptrtoint ptr %23 to i64
  %30 = getelementptr inbounds nuw i8, ptr %10, i64 16
  %31 = load i64, ptr %30, align 8, !tbaa !35
  %32 = icmp sgt i64 %31, 0
  br i1 %32, label %33, label %131

33:                                               ; preds = %28
  %34 = getelementptr inbounds nuw i8, ptr %10, i64 32
  %35 = getelementptr inbounds nuw i8, ptr %19, i64 40
  %36 = getelementptr inbounds nuw i8, ptr %19, i64 48
  %37 = getelementptr inbounds nuw i8, ptr %19, i64 32
  br label %38

38:                                               ; preds = %33, %85
  %39 = phi i64 [ 0, %33 ], [ %86, %85 ]
  %40 = load ptr, ptr %34, align 8, !tbaa !36
  %41 = getelementptr inbounds nuw %struct.Ent, ptr %40, i64 %39
  %42 = load i64, ptr %41, align 8, !tbaa !37
  %43 = icmp eq i64 %42, 0
  br i1 %43, label %85, label %44

44:                                               ; preds = %38
  %45 = getelementptr inbounds nuw i8, ptr %41, i64 16
  %46 = load i64, ptr %45, align 8, !tbaa !39
  %47 = load i64, ptr %35, align 8, !tbaa !40
  %48 = icmp eq i64 %47, 0
  br i1 %48, label %85, label %49

49:                                               ; preds = %44
  %50 = add nsw i64 %47, -1
  %51 = and i64 %50, %46
  %52 = load ptr, ptr %36, align 8, !tbaa !41
  %53 = getelementptr inbounds i64, ptr %52, i64 %51
  %54 = load i64, ptr %53, align 8, !tbaa !11
  %55 = icmp slt i64 %54, 0
  br i1 %55, label %85, label %56

56:                                               ; preds = %49, %75
  %57 = phi ptr [ %76, %75 ], [ %52, %49 ]
  %58 = phi i64 [ %80, %75 ], [ %54, %49 ]
  %59 = phi i64 [ %78, %75 ], [ %51, %49 ]
  %60 = load ptr, ptr %37, align 8, !tbaa !36
  %61 = getelementptr inbounds nuw %struct.Ent, ptr %60, i64 %58
  %62 = load i64, ptr %61, align 8, !tbaa !37
  %63 = icmp eq i64 %62, 0
  br i1 %63, label %75, label %64

64:                                               ; preds = %56
  %65 = getelementptr inbounds nuw i8, ptr %61, i64 16
  %66 = load i64, ptr %65, align 8, !tbaa !39
  %67 = icmp eq i64 %66, %46
  br i1 %67, label %68, label %75

68:                                               ; preds = %64
  %69 = icmp eq i64 %62, %42
  br i1 %69, label %82, label %70

70:                                               ; preds = %68
  %71 = tail call i64 @rt_eq_i(i64 noundef %62, i64 noundef %42) #39
  %72 = icmp eq i64 %71, 0
  br i1 %72, label %73, label %82

73:                                               ; preds = %70
  %74 = load ptr, ptr %36, align 8, !tbaa !41
  br label %75

75:                                               ; preds = %73, %64, %56
  %76 = phi ptr [ %74, %73 ], [ %57, %56 ], [ %57, %64 ]
  %77 = add nuw nsw i64 %59, 1
  %78 = and i64 %77, %50
  %79 = getelementptr inbounds i64, ptr %76, i64 %78
  %80 = load i64, ptr %79, align 8, !tbaa !11
  %81 = icmp slt i64 %80, 0
  br i1 %81, label %85, label %56

82:                                               ; preds = %70, %68
  %83 = load i64, ptr %41, align 8, !tbaa !37
  %84 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  tail call fastcc void @dict_set(ptr noundef nonnull %23, i64 noundef %83, i64 noundef %84)
  br label %85

85:                                               ; preds = %75, %49, %44, %82, %38
  %86 = add nuw nsw i64 %39, 1
  %87 = load i64, ptr %30, align 8, !tbaa !35
  %88 = icmp slt i64 %86, %87
  br i1 %88, label %38, label %131, !llvm.loop !96

89:                                               ; preds = %9
  %90 = icmp eq i64 %11, 2
  br i1 %90, label %91, label %100

91:                                               ; preds = %5, %89
  %92 = phi i64 [ %6, %5 ], [ %13, %89 ]
  %93 = icmp eq i64 %92, 0
  br i1 %93, label %94, label %103

94:                                               ; preds = %91
  %95 = icmp eq i64 %1, 0
  br i1 %95, label %100, label %96

96:                                               ; preds = %94
  %97 = inttoptr i64 %1 to ptr
  %98 = load i64, ptr %97, align 8, !tbaa !23
  %99 = icmp eq i64 %98, 2
  br i1 %99, label %103, label %100

100:                                              ; preds = %18, %94, %7, %96, %89
  %101 = tail call fastcc ptr @tname(i64 noundef %0)
  %102 = tail call fastcc ptr @tname(i64 noundef %1)
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.132, ptr noundef nonnull @.str.21, ptr noundef nonnull %101, ptr noundef nonnull %102) #36
  unreachable

103:                                              ; preds = %91, %96
  br i1 %4, label %106, label %104

104:                                              ; preds = %103
  %105 = ashr i64 %0, 1
  br label %114

106:                                              ; preds = %103
  %107 = inttoptr i64 %0 to ptr
  %108 = load i64, ptr %107, align 8, !tbaa !23
  %109 = icmp eq i64 %108, 2
  br i1 %109, label %110, label %113

110:                                              ; preds = %106
  %111 = getelementptr inbounds nuw i8, ptr %107, i64 8
  %112 = load i64, ptr %111, align 8, !tbaa !25
  br label %114

113:                                              ; preds = %106
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

114:                                              ; preds = %104, %110
  %115 = phi i64 [ %105, %104 ], [ %112, %110 ]
  br i1 %93, label %118, label %116

116:                                              ; preds = %114
  %117 = ashr i64 %1, 1
  br label %126

118:                                              ; preds = %114
  %119 = inttoptr i64 %1 to ptr
  %120 = load i64, ptr %119, align 8, !tbaa !23
  %121 = icmp eq i64 %120, 2
  br i1 %121, label %122, label %125

122:                                              ; preds = %118
  %123 = getelementptr inbounds nuw i8, ptr %119, i64 8
  %124 = load i64, ptr %123, align 8, !tbaa !25
  br label %126

125:                                              ; preds = %118
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

126:                                              ; preds = %116, %122
  %127 = phi i64 [ %117, %116 ], [ %124, %122 ]
  %128 = and i64 %127, %115
  %129 = shl nsw i64 %128, 1
  %130 = or disjoint i64 %129, 1
  br label %131

131:                                              ; preds = %85, %28, %126
  %132 = phi i64 [ %130, %126 ], [ %29, %28 ], [ %29, %85 ]
  ret i64 %132
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_or(i64 noundef %0, i64 noundef %1) local_unnamed_addr #2 {
  %3 = and i64 %0, 1
  %4 = icmp eq i64 %3, 0
  br i1 %4, label %7, label %5

5:                                                ; preds = %2
  %6 = and i64 %1, 1
  br label %71

7:                                                ; preds = %2
  %8 = icmp eq i64 %0, 0
  br i1 %8, label %80, label %9

9:                                                ; preds = %7
  %10 = inttoptr i64 %0 to ptr
  %11 = load i64, ptr %10, align 8, !tbaa !23
  %12 = icmp ne i64 %11, 8
  %13 = and i64 %1, 1
  %14 = icmp ne i64 %13, 0
  %15 = or i1 %14, %12
  %16 = icmp eq i64 %1, 0
  %17 = or i1 %16, %15
  br i1 %17, label %69, label %18

18:                                               ; preds = %9
  %19 = inttoptr i64 %1 to ptr
  %20 = load i64, ptr %19, align 8, !tbaa !23
  %21 = icmp eq i64 %20, 8
  br i1 %21, label %22, label %80

22:                                               ; preds = %18
  %23 = tail call dereferenceable_or_null(56) ptr @calloc(i64 noundef 1, i64 noundef 56) #33
  %24 = icmp eq ptr %23, null
  br i1 %24, label %25, label %28

25:                                               ; preds = %22
  %26 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %27 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %26)
  tail call void @exit(i32 noundef 1) #34
  unreachable

28:                                               ; preds = %22
  store i64 8, ptr %23, align 8, !tbaa !68
  %29 = ptrtoint ptr %23 to i64
  %30 = getelementptr inbounds nuw i8, ptr %10, i64 16
  %31 = load i64, ptr %30, align 8, !tbaa !35
  %32 = icmp sgt i64 %31, 0
  br i1 %32, label %33, label %35

33:                                               ; preds = %28
  %34 = getelementptr inbounds nuw i8, ptr %10, i64 32
  br label %41

35:                                               ; preds = %51, %28
  %36 = getelementptr inbounds nuw i8, ptr %19, i64 16
  %37 = load i64, ptr %36, align 8, !tbaa !35
  %38 = icmp sgt i64 %37, 0
  br i1 %38, label %39, label %111

39:                                               ; preds = %35
  %40 = getelementptr inbounds nuw i8, ptr %19, i64 32
  br label %55

41:                                               ; preds = %33, %51
  %42 = phi i64 [ %31, %33 ], [ %52, %51 ]
  %43 = phi i64 [ 0, %33 ], [ %53, %51 ]
  %44 = load ptr, ptr %34, align 8, !tbaa !36
  %45 = getelementptr inbounds nuw %struct.Ent, ptr %44, i64 %43
  %46 = load i64, ptr %45, align 8, !tbaa !37
  %47 = icmp eq i64 %46, 0
  br i1 %47, label %51, label %48

48:                                               ; preds = %41
  %49 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  tail call fastcc void @dict_set(ptr noundef nonnull %23, i64 noundef %46, i64 noundef %49)
  %50 = load i64, ptr %30, align 8, !tbaa !35
  br label %51

51:                                               ; preds = %41, %48
  %52 = phi i64 [ %42, %41 ], [ %50, %48 ]
  %53 = add nuw nsw i64 %43, 1
  %54 = icmp slt i64 %53, %52
  br i1 %54, label %41, label %35, !llvm.loop !97

55:                                               ; preds = %39, %65
  %56 = phi i64 [ %37, %39 ], [ %66, %65 ]
  %57 = phi i64 [ 0, %39 ], [ %67, %65 ]
  %58 = load ptr, ptr %40, align 8, !tbaa !36
  %59 = getelementptr inbounds nuw %struct.Ent, ptr %58, i64 %57
  %60 = load i64, ptr %59, align 8, !tbaa !37
  %61 = icmp eq i64 %60, 0
  br i1 %61, label %65, label %62

62:                                               ; preds = %55
  %63 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  tail call fastcc void @dict_set(ptr noundef nonnull %23, i64 noundef %60, i64 noundef %63)
  %64 = load i64, ptr %36, align 8, !tbaa !35
  br label %65

65:                                               ; preds = %55, %62
  %66 = phi i64 [ %56, %55 ], [ %64, %62 ]
  %67 = add nuw nsw i64 %57, 1
  %68 = icmp slt i64 %67, %66
  br i1 %68, label %55, label %111, !llvm.loop !98

69:                                               ; preds = %9
  %70 = icmp eq i64 %11, 2
  br i1 %70, label %71, label %80

71:                                               ; preds = %5, %69
  %72 = phi i64 [ %6, %5 ], [ %13, %69 ]
  %73 = icmp eq i64 %72, 0
  br i1 %73, label %74, label %83

74:                                               ; preds = %71
  %75 = icmp eq i64 %1, 0
  br i1 %75, label %80, label %76

76:                                               ; preds = %74
  %77 = inttoptr i64 %1 to ptr
  %78 = load i64, ptr %77, align 8, !tbaa !23
  %79 = icmp eq i64 %78, 2
  br i1 %79, label %83, label %80

80:                                               ; preds = %18, %74, %7, %76, %69
  %81 = tail call fastcc ptr @tname(i64 noundef %0)
  %82 = tail call fastcc ptr @tname(i64 noundef %1)
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.132, ptr noundef nonnull @.str.22, ptr noundef nonnull %81, ptr noundef nonnull %82) #36
  unreachable

83:                                               ; preds = %71, %76
  br i1 %4, label %86, label %84

84:                                               ; preds = %83
  %85 = ashr i64 %0, 1
  br label %94

86:                                               ; preds = %83
  %87 = inttoptr i64 %0 to ptr
  %88 = load i64, ptr %87, align 8, !tbaa !23
  %89 = icmp eq i64 %88, 2
  br i1 %89, label %90, label %93

90:                                               ; preds = %86
  %91 = getelementptr inbounds nuw i8, ptr %87, i64 8
  %92 = load i64, ptr %91, align 8, !tbaa !25
  br label %94

93:                                               ; preds = %86
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

94:                                               ; preds = %84, %90
  %95 = phi i64 [ %85, %84 ], [ %92, %90 ]
  br i1 %73, label %98, label %96

96:                                               ; preds = %94
  %97 = ashr i64 %1, 1
  br label %106

98:                                               ; preds = %94
  %99 = inttoptr i64 %1 to ptr
  %100 = load i64, ptr %99, align 8, !tbaa !23
  %101 = icmp eq i64 %100, 2
  br i1 %101, label %102, label %105

102:                                              ; preds = %98
  %103 = getelementptr inbounds nuw i8, ptr %99, i64 8
  %104 = load i64, ptr %103, align 8, !tbaa !25
  br label %106

105:                                              ; preds = %98
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

106:                                              ; preds = %96, %102
  %107 = phi i64 [ %97, %96 ], [ %104, %102 ]
  %108 = or i64 %107, %95
  %109 = shl nsw i64 %108, 1
  %110 = or disjoint i64 %109, 1
  br label %111

111:                                              ; preds = %65, %35, %106
  %112 = phi i64 [ %110, %106 ], [ %29, %35 ], [ %29, %65 ]
  ret i64 %112
}

; Function Attrs: nounwind ssp uwtable(sync)
define range(i64 -9223372036854775807, -9223372036854775808) i64 @rt_xor(i64 noundef %0, i64 noundef %1) local_unnamed_addr #2 {
  %3 = and i64 %0, 1
  %4 = icmp eq i64 %3, 0
  br i1 %4, label %5, label %11

5:                                                ; preds = %2
  %6 = icmp eq i64 %0, 0
  br i1 %6, label %20, label %7

7:                                                ; preds = %5
  %8 = inttoptr i64 %0 to ptr
  %9 = load i64, ptr %8, align 8, !tbaa !23
  %10 = icmp eq i64 %9, 2
  br i1 %10, label %11, label %20

11:                                               ; preds = %2, %7
  %12 = and i64 %1, 1
  %13 = icmp eq i64 %12, 0
  br i1 %13, label %14, label %23

14:                                               ; preds = %11
  %15 = icmp eq i64 %1, 0
  br i1 %15, label %20, label %16

16:                                               ; preds = %14
  %17 = inttoptr i64 %1 to ptr
  %18 = load i64, ptr %17, align 8, !tbaa !23
  %19 = icmp eq i64 %18, 2
  br i1 %19, label %23, label %20

20:                                               ; preds = %14, %5, %16, %7
  %21 = tail call fastcc ptr @tname(i64 noundef %0)
  %22 = tail call fastcc ptr @tname(i64 noundef %1)
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.132, ptr noundef nonnull @.str.23, ptr noundef nonnull %21, ptr noundef nonnull %22) #36
  unreachable

23:                                               ; preds = %11, %16
  br i1 %4, label %26, label %24

24:                                               ; preds = %23
  %25 = ashr i64 %0, 1
  br label %34

26:                                               ; preds = %23
  %27 = inttoptr i64 %0 to ptr
  %28 = load i64, ptr %27, align 8, !tbaa !23
  %29 = icmp eq i64 %28, 2
  br i1 %29, label %30, label %33

30:                                               ; preds = %26
  %31 = getelementptr inbounds nuw i8, ptr %27, i64 8
  %32 = load i64, ptr %31, align 8, !tbaa !25
  br label %34

33:                                               ; preds = %26
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

34:                                               ; preds = %24, %30
  %35 = phi i64 [ %25, %24 ], [ %32, %30 ]
  br i1 %13, label %38, label %36

36:                                               ; preds = %34
  %37 = ashr i64 %1, 1
  br label %46

38:                                               ; preds = %34
  %39 = inttoptr i64 %1 to ptr
  %40 = load i64, ptr %39, align 8, !tbaa !23
  %41 = icmp eq i64 %40, 2
  br i1 %41, label %42, label %45

42:                                               ; preds = %38
  %43 = getelementptr inbounds nuw i8, ptr %39, i64 8
  %44 = load i64, ptr %43, align 8, !tbaa !25
  br label %46

45:                                               ; preds = %38
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

46:                                               ; preds = %36, %42
  %47 = phi i64 [ %37, %36 ], [ %44, %42 ]
  %48 = xor i64 %47, %35
  %49 = shl nsw i64 %48, 1
  %50 = or disjoint i64 %49, 1
  ret i64 %50
}

; Function Attrs: nounwind ssp uwtable(sync)
define range(i64 -9223372036854775807, -9223372036854775808) i64 @rt_lshift(i64 noundef %0, i64 noundef %1) local_unnamed_addr #2 {
  %3 = and i64 %0, 1
  %4 = icmp eq i64 %3, 0
  br i1 %4, label %5, label %11

5:                                                ; preds = %2
  %6 = icmp eq i64 %0, 0
  br i1 %6, label %20, label %7

7:                                                ; preds = %5
  %8 = inttoptr i64 %0 to ptr
  %9 = load i64, ptr %8, align 8, !tbaa !23
  %10 = icmp eq i64 %9, 2
  br i1 %10, label %11, label %20

11:                                               ; preds = %2, %7
  %12 = and i64 %1, 1
  %13 = icmp eq i64 %12, 0
  br i1 %13, label %14, label %23

14:                                               ; preds = %11
  %15 = icmp eq i64 %1, 0
  br i1 %15, label %20, label %16

16:                                               ; preds = %14
  %17 = inttoptr i64 %1 to ptr
  %18 = load i64, ptr %17, align 8, !tbaa !23
  %19 = icmp eq i64 %18, 2
  br i1 %19, label %25, label %20

20:                                               ; preds = %14, %5, %16, %7
  %21 = tail call fastcc ptr @tname(i64 noundef %0)
  %22 = tail call fastcc ptr @tname(i64 noundef %1)
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.132, ptr noundef nonnull @.str.24, ptr noundef nonnull %21, ptr noundef nonnull %22) #36
  unreachable

23:                                               ; preds = %11
  %24 = ashr i64 %1, 1
  br label %28

25:                                               ; preds = %16
  %26 = getelementptr inbounds nuw i8, ptr %17, i64 8
  %27 = load i64, ptr %26, align 8, !tbaa !25
  br label %28

28:                                               ; preds = %23, %25
  %29 = phi i64 [ %24, %23 ], [ %27, %25 ]
  %30 = icmp slt i64 %29, 0
  br i1 %30, label %31, label %32

31:                                               ; preds = %28
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.25, ptr noundef nonnull @.str.26) #36
  unreachable

32:                                               ; preds = %28
  %33 = icmp samesign ugt i64 %29, 62
  br i1 %33, label %34, label %35

34:                                               ; preds = %32
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.7, ptr noundef nonnull @.str.8) #36
  unreachable

35:                                               ; preds = %32
  br i1 %4, label %36, label %41

36:                                               ; preds = %35
  %37 = inttoptr i64 %0 to ptr
  %38 = load i64, ptr %37, align 8, !tbaa !23
  %39 = icmp eq i64 %38, 2
  br i1 %39, label %43, label %40

40:                                               ; preds = %36
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

41:                                               ; preds = %35
  %42 = ashr i64 %0, 1
  br label %46

43:                                               ; preds = %36
  %44 = getelementptr inbounds nuw i8, ptr %37, i64 8
  %45 = load i64, ptr %44, align 8, !tbaa !25
  br label %46

46:                                               ; preds = %41, %43
  %47 = phi i64 [ %42, %41 ], [ %45, %43 ]
  %48 = shl i64 %47, %29
  %49 = ashr exact i64 %48, %29
  %50 = icmp eq i64 %49, %47
  br i1 %50, label %52, label %51

51:                                               ; preds = %46
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.7, ptr noundef nonnull @.str.8) #36
  unreachable

52:                                               ; preds = %46
  %53 = add i64 %48, -4611686018427387904
  %54 = icmp sgt i64 %53, -1
  br i1 %54, label %55, label %56

55:                                               ; preds = %52
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.7, ptr noundef nonnull @.str.131) #36
  unreachable

56:                                               ; preds = %52
  %57 = shl nsw i64 %48, 1
  %58 = or disjoint i64 %57, 1
  ret i64 %58
}

; Function Attrs: nounwind ssp uwtable(sync)
define range(i64 -9223372036854775807, -9223372036854775808) i64 @rt_rshift(i64 noundef %0, i64 noundef %1) local_unnamed_addr #2 {
  %3 = and i64 %0, 1
  %4 = icmp eq i64 %3, 0
  br i1 %4, label %5, label %11

5:                                                ; preds = %2
  %6 = icmp eq i64 %0, 0
  br i1 %6, label %20, label %7

7:                                                ; preds = %5
  %8 = inttoptr i64 %0 to ptr
  %9 = load i64, ptr %8, align 8, !tbaa !23
  %10 = icmp eq i64 %9, 2
  br i1 %10, label %11, label %20

11:                                               ; preds = %2, %7
  %12 = and i64 %1, 1
  %13 = icmp eq i64 %12, 0
  br i1 %13, label %14, label %23

14:                                               ; preds = %11
  %15 = icmp eq i64 %1, 0
  br i1 %15, label %20, label %16

16:                                               ; preds = %14
  %17 = inttoptr i64 %1 to ptr
  %18 = load i64, ptr %17, align 8, !tbaa !23
  %19 = icmp eq i64 %18, 2
  br i1 %19, label %25, label %20

20:                                               ; preds = %14, %5, %16, %7
  %21 = tail call fastcc ptr @tname(i64 noundef %0)
  %22 = tail call fastcc ptr @tname(i64 noundef %1)
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.132, ptr noundef nonnull @.str.27, ptr noundef nonnull %21, ptr noundef nonnull %22) #36
  unreachable

23:                                               ; preds = %11
  %24 = ashr i64 %1, 1
  br label %28

25:                                               ; preds = %16
  %26 = getelementptr inbounds nuw i8, ptr %17, i64 8
  %27 = load i64, ptr %26, align 8, !tbaa !25
  br label %28

28:                                               ; preds = %23, %25
  %29 = phi i64 [ %24, %23 ], [ %27, %25 ]
  %30 = icmp slt i64 %29, 0
  br i1 %30, label %31, label %32

31:                                               ; preds = %28
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.25, ptr noundef nonnull @.str.26) #36
  unreachable

32:                                               ; preds = %28
  %33 = icmp samesign ugt i64 %29, 63
  br i1 %33, label %34, label %48

34:                                               ; preds = %32
  br i1 %4, label %37, label %35

35:                                               ; preds = %34
  %36 = ashr i64 %0, 1
  br label %45

37:                                               ; preds = %34
  %38 = inttoptr i64 %0 to ptr
  %39 = load i64, ptr %38, align 8, !tbaa !23
  %40 = icmp eq i64 %39, 2
  br i1 %40, label %41, label %44

41:                                               ; preds = %37
  %42 = getelementptr inbounds nuw i8, ptr %38, i64 8
  %43 = load i64, ptr %42, align 8, !tbaa !25
  br label %45

44:                                               ; preds = %37
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

45:                                               ; preds = %35, %41
  %46 = phi i64 [ %36, %35 ], [ %43, %41 ]
  %47 = ashr i64 %46, 63
  br label %62

48:                                               ; preds = %32
  br i1 %4, label %51, label %49

49:                                               ; preds = %48
  %50 = ashr i64 %0, 1
  br label %59

51:                                               ; preds = %48
  %52 = inttoptr i64 %0 to ptr
  %53 = load i64, ptr %52, align 8, !tbaa !23
  %54 = icmp eq i64 %53, 2
  br i1 %54, label %55, label %58

55:                                               ; preds = %51
  %56 = getelementptr inbounds nuw i8, ptr %52, i64 8
  %57 = load i64, ptr %56, align 8, !tbaa !25
  br label %59

58:                                               ; preds = %51
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

59:                                               ; preds = %49, %55
  %60 = phi i64 [ %50, %49 ], [ %57, %55 ]
  %61 = ashr i64 %60, %29
  br label %62

62:                                               ; preds = %59, %45
  %63 = phi i64 [ %47, %45 ], [ %61, %59 ]
  %64 = shl nsw i64 %63, 1
  %65 = or disjoint i64 %64, 1
  ret i64 %65
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_neg(i64 noundef %0) local_unnamed_addr #2 {
  %2 = and i64 %0, 1
  %3 = icmp eq i64 %2, 0
  br i1 %3, label %10, label %4

4:                                                ; preds = %1
  %5 = icmp slt i64 %0, -9223372036854775806
  br i1 %5, label %6, label %7

6:                                                ; preds = %4
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.7, ptr noundef nonnull @.str.131) #36
  unreachable

7:                                                ; preds = %4
  %8 = and i64 %0, -2
  %9 = sub i64 1, %8
  br label %34

10:                                               ; preds = %1
  %11 = icmp eq i64 %0, 0
  br i1 %11, label %32, label %12

12:                                               ; preds = %10
  %13 = inttoptr i64 %0 to ptr
  %14 = load i64, ptr %13, align 8, !tbaa !23
  switch i64 %14, label %32 [
    i64 2, label %15
    i64 3, label %20
  ]

15:                                               ; preds = %12
  %16 = getelementptr inbounds nuw i8, ptr %13, i64 8
  %17 = load i64, ptr %16, align 8, !tbaa !25
  %18 = mul i64 %17, -2
  %19 = or disjoint i64 %18, 1
  br label %34

20:                                               ; preds = %12
  %21 = getelementptr inbounds nuw i8, ptr %13, i64 8
  %22 = load double, ptr %21, align 8, !tbaa !22
  %23 = tail call dereferenceable_or_null(16) ptr @calloc(i64 noundef 1, i64 noundef 16) #33
  %24 = icmp eq ptr %23, null
  br i1 %24, label %25, label %28

25:                                               ; preds = %20
  %26 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %27 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %26)
  tail call void @exit(i32 noundef 1) #34
  unreachable

28:                                               ; preds = %20
  %29 = fneg double %22
  store i64 3, ptr %23, align 8, !tbaa !19
  %30 = getelementptr inbounds nuw i8, ptr %23, i64 8
  store double %29, ptr %30, align 8, !tbaa !22
  %31 = ptrtoint ptr %23 to i64
  br label %34

32:                                               ; preds = %12, %10
  %33 = tail call fastcc ptr @tname(i64 noundef %0)
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.29, ptr noundef nonnull %33) #36
  unreachable

34:                                               ; preds = %28, %15, %7
  %35 = phi i64 [ %9, %7 ], [ %19, %15 ], [ %31, %28 ]
  ret i64 %35
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind ssp willreturn memory(read, inaccessiblemem: none, target_mem0: none, target_mem1: none) uwtable(sync)
define internal fastcc nonnull ptr @tname(i64 noundef %0) unnamed_addr #15 {
  %2 = and i64 %0, 1
  %3 = icmp eq i64 %2, 0
  br i1 %3, label %4, label %32

4:                                                ; preds = %1
  %5 = icmp eq i64 %0, 0
  br i1 %5, label %31, label %6

6:                                                ; preds = %4
  %7 = inttoptr i64 %0 to ptr
  %8 = load i64, ptr %7, align 8, !tbaa !23
  switch i64 %8, label %31 [
    i64 0, label %32
    i64 1, label %9
    i64 2, label %10
    i64 3, label %11
    i64 4, label %12
    i64 5, label %13
    i64 6, label %14
    i64 7, label %15
    i64 8, label %16
    i64 9, label %17
    i64 10, label %18
    i64 11, label %19
    i64 12, label %20
    i64 13, label %28
    i64 14, label %29
    i64 15, label %30
  ]

9:                                                ; preds = %6
  br label %32

10:                                               ; preds = %6
  br label %32

11:                                               ; preds = %6
  br label %32

12:                                               ; preds = %6
  br label %32

13:                                               ; preds = %6
  br label %32

14:                                               ; preds = %6
  br label %32

15:                                               ; preds = %6
  br label %32

16:                                               ; preds = %6
  br label %32

17:                                               ; preds = %6
  br label %32

18:                                               ; preds = %6
  br label %32

19:                                               ; preds = %6
  br label %32

20:                                               ; preds = %6
  %21 = getelementptr inbounds nuw i8, ptr %7, i64 8
  %22 = load i64, ptr %21, align 8, !tbaa !42
  %23 = inttoptr i64 %22 to ptr
  %24 = getelementptr inbounds nuw i8, ptr %23, i64 8
  %25 = load i64, ptr %24, align 8, !tbaa !60
  %26 = inttoptr i64 %25 to ptr
  %27 = getelementptr inbounds nuw i8, ptr %26, i64 16
  br label %32

28:                                               ; preds = %6
  br label %32

29:                                               ; preds = %6
  br label %32

30:                                               ; preds = %6
  br label %32

31:                                               ; preds = %4, %6
  br label %32

32:                                               ; preds = %1, %6, %31, %30, %29, %28, %20, %19, %18, %17, %16, %15, %14, %13, %12, %11, %10, %9
  %33 = phi ptr [ @.str.146, %31 ], [ @.str.145, %30 ], [ @.str.134, %9 ], [ @.str.135, %10 ], [ @.str.136, %11 ], [ @.str.137, %12 ], [ @.str.38, %13 ], [ @.str.39, %14 ], [ @.str.138, %15 ], [ @.str.139, %16 ], [ @.str.140, %17 ], [ @.str.141, %18 ], [ @.str.142, %19 ], [ %27, %20 ], [ @.str.143, %28 ], [ @.str.144, %29 ], [ @.str.133, %6 ], [ @.str.133, %1 ]
  ret ptr %33
}

; Function Attrs: nounwind ssp uwtable(sync)
define range(i64 -9223372036854775807, -9223372036854775808) i64 @rt_invert(i64 noundef %0) local_unnamed_addr #2 {
  %2 = and i64 %0, 1
  %3 = icmp eq i64 %2, 0
  br i1 %3, label %4, label %11

4:                                                ; preds = %1
  %5 = icmp eq i64 %0, 0
  br i1 %5, label %10, label %6

6:                                                ; preds = %4
  %7 = inttoptr i64 %0 to ptr
  %8 = load i64, ptr %7, align 8, !tbaa !23
  %9 = icmp eq i64 %8, 2
  br i1 %9, label %13, label %10

10:                                               ; preds = %4, %6
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.30) #36
  unreachable

11:                                               ; preds = %1
  %12 = ashr i64 %0, 1
  br label %16

13:                                               ; preds = %6
  %14 = getelementptr inbounds nuw i8, ptr %7, i64 8
  %15 = load i64, ptr %14, align 8, !tbaa !25
  br label %16

16:                                               ; preds = %11, %13
  %17 = phi i64 [ %12, %11 ], [ %15, %13 ]
  %18 = xor i64 %17, -1
  %19 = shl nsw i64 %18, 1
  %20 = or disjoint i64 %19, 1
  ret i64 %20
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_not(i64 noundef %0) local_unnamed_addr #2 {
  %2 = tail call i64 @rt_truthy(i64 noundef %0)
  %3 = icmp eq i64 %2, 0
  %4 = load i64, ptr @rt_true_v, align 8
  %5 = load i64, ptr @rt_false_v, align 8
  %6 = select i1 %3, i64 %4, i64 %5
  ret i64 %6
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_toint(i64 noundef %0) local_unnamed_addr #2 {
  %2 = and i64 %0, 1
  %3 = icmp eq i64 %2, 0
  br i1 %3, label %6, label %4

4:                                                ; preds = %1
  %5 = ashr i64 %0, 1
  br label %16

6:                                                ; preds = %1
  %7 = icmp eq i64 %0, 0
  br i1 %7, label %15, label %8

8:                                                ; preds = %6
  %9 = inttoptr i64 %0 to ptr
  %10 = load i64, ptr %9, align 8, !tbaa !23
  %11 = icmp eq i64 %10, 2
  br i1 %11, label %12, label %15

12:                                               ; preds = %8
  %13 = getelementptr inbounds nuw i8, ptr %9, i64 8
  %14 = load i64, ptr %13, align 8, !tbaa !25
  br label %16

15:                                               ; preds = %8, %6
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

16:                                               ; preds = %4, %12
  %17 = phi i64 [ %5, %4 ], [ %14, %12 ]
  ret i64 %17
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_cmp(i64 noundef %0, i64 noundef %1, i64 noundef %2) local_unnamed_addr #2 {
  switch i64 %0, label %105 [
    i64 0, label %4
    i64 1, label %6
    i64 2, label %10
    i64 3, label %14
    i64 4, label %18
    i64 5, label %22
    i64 6, label %26
    i64 7, label %28
    i64 8, label %31
    i64 9, label %68
  ]

4:                                                ; preds = %3
  %5 = tail call i64 @rt_eq_i(i64 noundef %1, i64 noundef %2)
  br label %105

6:                                                ; preds = %3
  %7 = tail call i64 @rt_eq_i(i64 noundef %1, i64 noundef %2)
  %8 = icmp eq i64 %7, 0
  %9 = zext i1 %8 to i64
  br label %105

10:                                               ; preds = %3
  %11 = tail call fastcc i32 @cmp_v(i64 noundef %1, i64 noundef %2)
  %12 = lshr i32 %11, 31
  %13 = zext nneg i32 %12 to i64
  br label %105

14:                                               ; preds = %3
  %15 = tail call fastcc i32 @cmp_v(i64 noundef %1, i64 noundef %2)
  %16 = icmp slt i32 %15, 1
  %17 = zext i1 %16 to i64
  br label %105

18:                                               ; preds = %3
  %19 = tail call fastcc i32 @cmp_v(i64 noundef %1, i64 noundef %2)
  %20 = icmp sgt i32 %19, 0
  %21 = zext i1 %20 to i64
  br label %105

22:                                               ; preds = %3
  %23 = tail call fastcc i32 @cmp_v(i64 noundef %1, i64 noundef %2)
  %24 = icmp sgt i32 %23, -1
  %25 = zext i1 %24 to i64
  br label %105

26:                                               ; preds = %3
  %27 = tail call fastcc i64 @contains(i64 noundef %2, i64 noundef %1)
  br label %105

28:                                               ; preds = %3
  %29 = tail call fastcc i64 @contains(i64 noundef %2, i64 noundef %1)
  %30 = xor i64 %29, 1
  br label %105

31:                                               ; preds = %3
  %32 = icmp eq i64 %1, %2
  br i1 %32, label %105, label %33

33:                                               ; preds = %31
  %34 = and i64 %1, 1
  %35 = icmp eq i64 %34, 0
  br i1 %35, label %36, label %42

36:                                               ; preds = %33
  %37 = icmp eq i64 %1, 0
  br i1 %37, label %105, label %38

38:                                               ; preds = %36
  %39 = inttoptr i64 %1 to ptr
  %40 = load i64, ptr %39, align 8, !tbaa !23
  %41 = icmp eq i64 %40, 2
  br i1 %41, label %42, label %105

42:                                               ; preds = %33, %38
  %43 = and i64 %2, 1
  %44 = icmp eq i64 %43, 0
  br i1 %44, label %45, label %51

45:                                               ; preds = %42
  %46 = icmp eq i64 %2, 0
  br i1 %46, label %105, label %47

47:                                               ; preds = %45
  %48 = inttoptr i64 %2 to ptr
  %49 = load i64, ptr %48, align 8, !tbaa !23
  %50 = icmp eq i64 %49, 2
  br i1 %50, label %51, label %105

51:                                               ; preds = %42, %47
  br i1 %35, label %52, label %55

52:                                               ; preds = %51
  %53 = inttoptr i64 %1 to ptr
  %54 = load i64, ptr %53, align 8, !tbaa !23
  br label %55

55:                                               ; preds = %51, %52
  %56 = phi i64 [ 0, %51 ], [ %54, %52 ]
  br i1 %44, label %57, label %60

57:                                               ; preds = %55
  %58 = inttoptr i64 %2 to ptr
  %59 = load i64, ptr %58, align 8, !tbaa !23
  br label %60

60:                                               ; preds = %55, %57
  %61 = phi i64 [ 0, %55 ], [ %59, %57 ]
  %62 = icmp eq i64 %56, %61
  br i1 %62, label %63, label %105

63:                                               ; preds = %60
  %64 = tail call fastcc i64 @toi(i64 noundef %1)
  %65 = tail call fastcc i64 @toi(i64 noundef %2)
  %66 = icmp eq i64 %64, %65
  %67 = zext i1 %66 to i64
  br label %105

68:                                               ; preds = %3
  %69 = icmp eq i64 %1, %2
  br i1 %69, label %105, label %70

70:                                               ; preds = %68
  %71 = and i64 %1, 1
  %72 = icmp eq i64 %71, 0
  br i1 %72, label %73, label %79

73:                                               ; preds = %70
  %74 = icmp eq i64 %1, 0
  br i1 %74, label %105, label %75

75:                                               ; preds = %73
  %76 = inttoptr i64 %1 to ptr
  %77 = load i64, ptr %76, align 8, !tbaa !23
  %78 = icmp eq i64 %77, 2
  br i1 %78, label %79, label %105

79:                                               ; preds = %70, %75
  %80 = and i64 %2, 1
  %81 = icmp eq i64 %80, 0
  br i1 %81, label %82, label %88

82:                                               ; preds = %79
  %83 = icmp eq i64 %2, 0
  br i1 %83, label %105, label %84

84:                                               ; preds = %82
  %85 = inttoptr i64 %2 to ptr
  %86 = load i64, ptr %85, align 8, !tbaa !23
  %87 = icmp eq i64 %86, 2
  br i1 %87, label %88, label %105

88:                                               ; preds = %79, %84
  br i1 %72, label %89, label %92

89:                                               ; preds = %88
  %90 = inttoptr i64 %1 to ptr
  %91 = load i64, ptr %90, align 8, !tbaa !23
  br label %92

92:                                               ; preds = %88, %89
  %93 = phi i64 [ 0, %88 ], [ %91, %89 ]
  br i1 %81, label %94, label %97

94:                                               ; preds = %92
  %95 = inttoptr i64 %2 to ptr
  %96 = load i64, ptr %95, align 8, !tbaa !23
  br label %97

97:                                               ; preds = %92, %94
  %98 = phi i64 [ 0, %92 ], [ %96, %94 ]
  %99 = icmp eq i64 %93, %98
  br i1 %99, label %100, label %105

100:                                              ; preds = %97
  %101 = tail call fastcc i64 @toi(i64 noundef %1)
  %102 = tail call fastcc i64 @toi(i64 noundef %2)
  %103 = icmp ne i64 %101, %102
  %104 = zext i1 %103 to i64
  br label %105

105:                                              ; preds = %82, %73, %45, %36, %3, %68, %100, %97, %84, %75, %31, %63, %60, %47, %38, %28, %26, %22, %18, %14, %10, %6, %4
  %106 = phi i64 [ %104, %100 ], [ %5, %4 ], [ %9, %6 ], [ %13, %10 ], [ %17, %14 ], [ %21, %18 ], [ %25, %22 ], [ %27, %26 ], [ %30, %28 ], [ %67, %63 ], [ 1, %31 ], [ 0, %60 ], [ 0, %47 ], [ 0, %38 ], [ 0, %68 ], [ 1, %97 ], [ 1, %84 ], [ 1, %75 ], [ 0, %3 ], [ 1, %73 ], [ 0, %36 ], [ 0, %45 ], [ 1, %82 ]
  ret i64 %106
}

; Function Attrs: nounwind ssp uwtable(sync)
define internal fastcc range(i32 -1, 2) i32 @cmp_v(i64 noundef %0, i64 noundef %1) unnamed_addr #2 {
  %3 = alloca [2 x i64], align 8
  %4 = alloca [2 x i64], align 8
  br label %5

5:                                                ; preds = %170, %2
  %6 = phi i64 [ %0, %2 ], [ %173, %170 ]
  %7 = phi i64 [ %1, %2 ], [ %176, %170 ]
  %8 = and i64 %6, 1
  %9 = icmp eq i64 %8, 0
  br i1 %9, label %10, label %16

10:                                               ; preds = %5
  %11 = icmp eq i64 %6, 0
  br i1 %11, label %114, label %12

12:                                               ; preds = %10
  %13 = inttoptr i64 %6 to ptr
  %14 = load i64, ptr %13, align 8, !tbaa !23
  %15 = icmp eq i64 %14, 2
  br i1 %15, label %16, label %54

16:                                               ; preds = %5, %12
  %17 = and i64 %7, 1
  %18 = icmp eq i64 %17, 0
  br i1 %18, label %19, label %25

19:                                               ; preds = %16
  %20 = icmp eq i64 %7, 0
  br i1 %20, label %51, label %21

21:                                               ; preds = %19
  %22 = inttoptr i64 %7 to ptr
  %23 = load i64, ptr %22, align 8, !tbaa !23
  %24 = icmp eq i64 %23, 2
  br i1 %24, label %25, label %51

25:                                               ; preds = %16, %21
  br i1 %9, label %28, label %26

26:                                               ; preds = %25
  %27 = ashr i64 %6, 1
  br label %36

28:                                               ; preds = %25
  %29 = inttoptr i64 %6 to ptr
  %30 = load i64, ptr %29, align 8, !tbaa !23
  %31 = icmp eq i64 %30, 2
  br i1 %31, label %32, label %35

32:                                               ; preds = %28
  %33 = getelementptr inbounds nuw i8, ptr %29, i64 8
  %34 = load i64, ptr %33, align 8, !tbaa !25
  br label %36

35:                                               ; preds = %28
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

36:                                               ; preds = %26, %32
  %37 = phi i64 [ %27, %26 ], [ %34, %32 ]
  br i1 %18, label %40, label %38

38:                                               ; preds = %36
  %39 = ashr i64 %7, 1
  br label %48

40:                                               ; preds = %36
  %41 = inttoptr i64 %7 to ptr
  %42 = load i64, ptr %41, align 8, !tbaa !23
  %43 = icmp eq i64 %42, 2
  br i1 %43, label %44, label %47

44:                                               ; preds = %40
  %45 = getelementptr inbounds nuw i8, ptr %41, i64 8
  %46 = load i64, ptr %45, align 8, !tbaa !25
  br label %48

47:                                               ; preds = %40
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

48:                                               ; preds = %38, %44
  %49 = phi i64 [ %39, %38 ], [ %46, %44 ]
  %50 = tail call i32 @llvm.scmp.i32.i64(i64 %37, i64 %49)
  br label %242

51:                                               ; preds = %19, %21
  br i1 %9, label %52, label %62

52:                                               ; preds = %51
  %53 = inttoptr i64 %6 to ptr
  br label %54

54:                                               ; preds = %52, %12
  %55 = phi ptr [ %53, %52 ], [ %13, %12 ]
  %56 = load i64, ptr %55, align 8, !tbaa !23
  %57 = and i64 %56, -2
  %58 = icmp eq i64 %57, 2
  br i1 %58, label %59, label %111

59:                                               ; preds = %54
  %60 = and i64 %7, 1
  %61 = icmp eq i64 %60, 0
  br i1 %61, label %62, label %73

62:                                               ; preds = %51, %59
  %63 = icmp eq i64 %7, 0
  br i1 %63, label %108, label %64

64:                                               ; preds = %62
  %65 = inttoptr i64 %7 to ptr
  %66 = load i64, ptr %65, align 8, !tbaa !23
  %67 = and i64 %66, -2
  %68 = icmp eq i64 %67, 2
  br i1 %68, label %69, label %108

69:                                               ; preds = %64
  br i1 %9, label %73, label %70

70:                                               ; preds = %69
  %71 = ashr i64 %6, 1
  %72 = sitofp i64 %71 to double
  br label %89

73:                                               ; preds = %59, %69
  %74 = phi i1 [ true, %69 ], [ false, %59 ]
  %75 = inttoptr i64 %6 to ptr
  %76 = load i64, ptr %75, align 8, !tbaa !23
  switch i64 %76, label %80 [
    i64 2, label %81
    i64 3, label %77
  ]

77:                                               ; preds = %73
  %78 = getelementptr inbounds nuw i8, ptr %75, i64 8
  %79 = load double, ptr %78, align 8, !tbaa !22
  br i1 %74, label %89, label %85

80:                                               ; preds = %73
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.108) #36
  unreachable

81:                                               ; preds = %73
  %82 = getelementptr inbounds nuw i8, ptr %75, i64 8
  %83 = load i64, ptr %82, align 8, !tbaa !25
  %84 = sitofp i64 %83 to double
  br i1 %74, label %89, label %85

85:                                               ; preds = %77, %81
  %86 = phi double [ %79, %77 ], [ %84, %81 ]
  %87 = ashr i64 %7, 1
  %88 = sitofp i64 %87 to double
  br label %101

89:                                               ; preds = %77, %70, %81
  %90 = phi double [ %72, %70 ], [ %84, %81 ], [ %79, %77 ]
  %91 = inttoptr i64 %7 to ptr
  %92 = load i64, ptr %91, align 8, !tbaa !23
  switch i64 %92, label %100 [
    i64 2, label %93
    i64 3, label %97
  ]

93:                                               ; preds = %89
  %94 = getelementptr inbounds nuw i8, ptr %91, i64 8
  %95 = load i64, ptr %94, align 8, !tbaa !25
  %96 = sitofp i64 %95 to double
  br label %101

97:                                               ; preds = %89
  %98 = getelementptr inbounds nuw i8, ptr %91, i64 8
  %99 = load double, ptr %98, align 8, !tbaa !22
  br label %101

100:                                              ; preds = %89
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.108) #36
  unreachable

101:                                              ; preds = %85, %93, %97
  %102 = phi double [ %86, %85 ], [ %90, %93 ], [ %90, %97 ]
  %103 = phi double [ %88, %85 ], [ %96, %93 ], [ %99, %97 ]
  %104 = fcmp olt double %102, %103
  %105 = fcmp ogt double %102, %103
  %106 = zext i1 %105 to i32
  %107 = select i1 %104, i32 -1, i32 %106
  br label %242

108:                                              ; preds = %64, %62
  br i1 %9, label %109, label %114

109:                                              ; preds = %108
  %110 = inttoptr i64 %6 to ptr
  br label %111

111:                                              ; preds = %109, %54
  %112 = phi ptr [ %110, %109 ], [ %55, %54 ]
  %113 = load i64, ptr %112, align 8, !tbaa !23
  br label %114

114:                                              ; preds = %10, %108, %111
  %115 = phi i64 [ 0, %108 ], [ %113, %111 ], [ -1, %10 ]
  %116 = and i64 %7, 1
  %117 = icmp eq i64 %116, 0
  br i1 %117, label %118, label %123

118:                                              ; preds = %114
  %119 = icmp eq i64 %7, 0
  br i1 %119, label %123, label %120

120:                                              ; preds = %118
  %121 = inttoptr i64 %7 to ptr
  %122 = load i64, ptr %121, align 8, !tbaa !23
  br label %123

123:                                              ; preds = %114, %118, %120
  %124 = phi i64 [ 0, %114 ], [ %122, %120 ], [ -1, %118 ]
  %125 = icmp eq i64 %115, %124
  br i1 %125, label %126, label %241

126:                                              ; preds = %123
  %127 = icmp eq i64 %115, 4
  br i1 %127, label %128, label %145

128:                                              ; preds = %126
  %129 = inttoptr i64 %6 to ptr
  %130 = getelementptr inbounds nuw i8, ptr %129, i64 8
  %131 = load i64, ptr %130, align 8, !tbaa !18
  %132 = inttoptr i64 %7 to ptr
  %133 = getelementptr inbounds nuw i8, ptr %132, i64 8
  %134 = load i64, ptr %133, align 8, !tbaa !18
  %135 = tail call i64 @llvm.smin.i64(i64 %131, i64 %134)
  %136 = getelementptr inbounds nuw i8, ptr %129, i64 16
  %137 = getelementptr inbounds nuw i8, ptr %132, i64 16
  %138 = tail call i32 @memcmp(ptr noundef nonnull %136, ptr noundef nonnull %137, i64 noundef %135)
  %139 = icmp eq i32 %138, 0
  br i1 %139, label %143, label %140

140:                                              ; preds = %128
  %141 = icmp sgt i32 %138, -1
  %142 = select i1 %141, i32 1, i32 -1
  br label %242

143:                                              ; preds = %128
  %144 = tail call i32 @llvm.scmp.i32.i64(i64 %131, i64 %134)
  br label %242

145:                                              ; preds = %126
  %146 = add i64 %115, -5
  %147 = icmp ult i64 %146, 2
  br i1 %147, label %148, label %189

148:                                              ; preds = %145
  %149 = inttoptr i64 %6 to ptr
  %150 = getelementptr inbounds nuw i8, ptr %149, i64 8
  %151 = load i64, ptr %150, align 8, !tbaa !27
  %152 = inttoptr i64 %7 to ptr
  %153 = getelementptr inbounds nuw i8, ptr %152, i64 8
  %154 = load i64, ptr %153, align 8, !tbaa !27
  %155 = tail call i64 @llvm.smin.i64(i64 %151, i64 %154)
  %156 = icmp sgt i64 %155, 0
  br i1 %156, label %157, label %185

157:                                              ; preds = %148
  %158 = getelementptr inbounds nuw i8, ptr %149, i64 24
  %159 = getelementptr inbounds nuw i8, ptr %152, i64 24
  br label %160

160:                                              ; preds = %157, %177
  %161 = phi i64 [ 0, %157 ], [ %178, %177 ]
  %162 = load ptr, ptr %158, align 8, !tbaa !32
  %163 = getelementptr inbounds nuw i64, ptr %162, i64 %161
  %164 = load i64, ptr %163, align 8, !tbaa !11
  %165 = load ptr, ptr %159, align 8, !tbaa !32
  %166 = getelementptr inbounds nuw i64, ptr %165, i64 %161
  %167 = load i64, ptr %166, align 8, !tbaa !11
  %168 = tail call i64 @rt_eq_i(i64 noundef %164, i64 noundef %167)
  %169 = icmp eq i64 %168, 0
  br i1 %169, label %170, label %177

170:                                              ; preds = %160
  %171 = load ptr, ptr %158, align 8, !tbaa !32
  %172 = getelementptr inbounds nuw i64, ptr %171, i64 %161
  %173 = load i64, ptr %172, align 8, !tbaa !11
  %174 = load ptr, ptr %159, align 8, !tbaa !32
  %175 = getelementptr inbounds nuw i64, ptr %174, i64 %161
  %176 = load i64, ptr %175, align 8, !tbaa !11
  br label %5

177:                                              ; preds = %160
  %178 = add nuw nsw i64 %161, 1
  %179 = icmp eq i64 %178, %155
  br i1 %179, label %180, label %160, !llvm.loop !99

180:                                              ; preds = %177
  %181 = getelementptr inbounds nuw i8, ptr %149, i64 8
  %182 = getelementptr inbounds nuw i8, ptr %152, i64 8
  %183 = load i64, ptr %181, align 8, !tbaa !27
  %184 = load i64, ptr %182, align 8, !tbaa !27
  br label %185

185:                                              ; preds = %148, %180
  %186 = phi i64 [ %184, %180 ], [ %154, %148 ]
  %187 = phi i64 [ %183, %180 ], [ %151, %148 ]
  %188 = tail call i32 @llvm.scmp.i32.i64(i64 %187, i64 %186)
  br label %242

189:                                              ; preds = %145
  %190 = icmp eq i64 %115, 12
  br i1 %190, label %191, label %241

191:                                              ; preds = %189
  %192 = load i64, ptr @cmp_v.k_lt, align 8, !tbaa !11
  %193 = icmp eq i64 %192, 0
  br i1 %193, label %194, label %196

194:                                              ; preds = %191
  %195 = tail call fastcc i64 @mkstr(ptr noundef nonnull @.str.147, i64 noundef 6)
  store i64 %195, ptr @cmp_v.k_lt, align 8, !tbaa !11
  br label %196

196:                                              ; preds = %194, %191
  %197 = phi i64 [ %195, %194 ], [ %192, %191 ]
  %198 = inttoptr i64 %6 to ptr
  %199 = getelementptr inbounds nuw i8, ptr %198, i64 8
  %200 = load i64, ptr %199, align 8, !tbaa !42
  %201 = icmp ne i64 %200, 0
  %202 = and i64 %200, 1
  %203 = icmp eq i64 %202, 0
  %204 = and i1 %201, %203
  br i1 %204, label %205, label %241

205:                                              ; preds = %196, %217
  %206 = phi i64 [ %219, %217 ], [ %200, %196 ]
  %207 = inttoptr i64 %206 to ptr
  %208 = load i64, ptr %207, align 8, !tbaa !23
  %209 = icmp eq i64 %208, 11
  br i1 %209, label %210, label %241

210:                                              ; preds = %205
  %211 = getelementptr inbounds nuw i8, ptr %207, i64 24
  %212 = load i64, ptr %211, align 8, !tbaa !44
  %213 = inttoptr i64 %212 to ptr
  %214 = tail call fastcc i64 @hash_v(i64 noundef %197) #39
  %215 = tail call fastcc ptr @dict_find(ptr noundef %213, i64 noundef %197, i64 noundef %214) #39
  %216 = icmp eq ptr %215, null
  br i1 %216, label %217, label %224

217:                                              ; preds = %210
  %218 = getelementptr inbounds nuw i8, ptr %207, i64 16
  %219 = load i64, ptr %218, align 8, !tbaa !46
  %220 = icmp ne i64 %219, 0
  %221 = and i64 %219, 1
  %222 = icmp eq i64 %221, 0
  %223 = and i1 %220, %222
  br i1 %223, label %205, label %241

224:                                              ; preds = %210
  %225 = getelementptr inbounds nuw i8, ptr %215, i64 8
  %226 = load i64, ptr %225, align 8, !tbaa !42
  %227 = icmp eq i64 %226, 0
  br i1 %227, label %241, label %228

228:                                              ; preds = %224
  call void @llvm.lifetime.start.p0(ptr nonnull %3) #35
  store i64 %6, ptr %3, align 8, !tbaa !11
  %229 = getelementptr inbounds nuw i8, ptr %3, i64 8
  store i64 %7, ptr %229, align 8, !tbaa !11
  %230 = call i64 @rt_call(i64 noundef %226, i64 noundef 2, ptr noundef nonnull %3)
  %231 = call i64 @rt_truthy(i64 noundef %230)
  %232 = icmp eq i64 %231, 0
  br i1 %232, label %233, label %239

233:                                              ; preds = %228
  call void @llvm.lifetime.start.p0(ptr nonnull %4) #35
  store i64 %7, ptr %4, align 8, !tbaa !11
  %234 = getelementptr inbounds nuw i8, ptr %4, i64 8
  store i64 %6, ptr %234, align 8, !tbaa !11
  %235 = call i64 @rt_call(i64 noundef %226, i64 noundef 2, ptr noundef nonnull %4)
  %236 = call i64 @rt_truthy(i64 noundef %235)
  %237 = icmp ne i64 %236, 0
  %238 = zext i1 %237 to i32
  call void @llvm.lifetime.end.p0(ptr nonnull %4) #35
  br label %239

239:                                              ; preds = %228, %233
  %240 = phi i32 [ %238, %233 ], [ -1, %228 ]
  call void @llvm.lifetime.end.p0(ptr nonnull %3) #35
  br label %242

241:                                              ; preds = %123, %217, %205, %196, %224, %189
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.148) #36
  unreachable

242:                                              ; preds = %239, %143, %140, %185, %101, %48
  %243 = phi i32 [ %50, %48 ], [ %107, %101 ], [ %240, %239 ], [ %144, %143 ], [ %142, %140 ], [ %188, %185 ]
  ret i32 %243
}

; Function Attrs: nounwind ssp uwtable(sync)
define internal fastcc range(i64 0, 2) i64 @contains(i64 noundef %0, i64 noundef %1) unnamed_addr #2 {
  %3 = and i64 %0, 1
  %4 = icmp ne i64 %3, 0
  %5 = icmp eq i64 %0, 0
  %6 = or i1 %5, %4
  br i1 %6, label %99, label %7

7:                                                ; preds = %2
  %8 = inttoptr i64 %0 to ptr
  %9 = load i64, ptr %8, align 8, !tbaa !23
  switch i64 %9, label %99 [
    i64 5, label %10
    i64 6, label %10
    i64 4, label %26
    i64 7, label %58
    i64 8, label %58
  ]

10:                                               ; preds = %7, %7
  %11 = getelementptr inbounds nuw i8, ptr %8, i64 24
  %12 = getelementptr inbounds nuw i8, ptr %8, i64 8
  %13 = load i64, ptr %12, align 8, !tbaa !27
  %14 = icmp sgt i64 %13, 0
  br i1 %14, label %19, label %101

15:                                               ; preds = %19
  %16 = add nuw nsw i64 %20, 1
  %17 = load i64, ptr %12, align 8, !tbaa !27
  %18 = icmp slt i64 %16, %17
  br i1 %18, label %19, label %101, !llvm.loop !100

19:                                               ; preds = %10, %15
  %20 = phi i64 [ %16, %15 ], [ 0, %10 ]
  %21 = load ptr, ptr %11, align 8, !tbaa !32
  %22 = getelementptr inbounds nuw i64, ptr %21, i64 %20
  %23 = load i64, ptr %22, align 8, !tbaa !11
  %24 = tail call i64 @rt_eq_i(i64 noundef %23, i64 noundef %1)
  %25 = icmp eq i64 %24, 0
  br i1 %25, label %15, label %101

26:                                               ; preds = %7
  %27 = and i64 %1, 1
  %28 = icmp ne i64 %27, 0
  %29 = icmp eq i64 %1, 0
  %30 = or i1 %29, %28
  br i1 %30, label %35, label %31

31:                                               ; preds = %26
  %32 = inttoptr i64 %1 to ptr
  %33 = load i64, ptr %32, align 8, !tbaa !23
  %34 = icmp eq i64 %33, 4
  br i1 %34, label %36, label %35

35:                                               ; preds = %26, %31
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.149) #36
  unreachable

36:                                               ; preds = %31
  %37 = getelementptr inbounds nuw i8, ptr %32, i64 8
  %38 = load i64, ptr %37, align 8, !tbaa !18
  %39 = icmp eq i64 %38, 0
  br i1 %39, label %101, label %40

40:                                               ; preds = %36
  %41 = getelementptr inbounds nuw i8, ptr %8, i64 8
  %42 = load i64, ptr %41, align 8, !tbaa !18
  %43 = icmp sgt i64 %38, %42
  br i1 %43, label %101, label %44

44:                                               ; preds = %40
  %45 = getelementptr inbounds nuw i8, ptr %8, i64 16
  %46 = getelementptr inbounds nuw i8, ptr %32, i64 16
  br label %51

47:                                               ; preds = %51
  %48 = add nuw nsw i64 %52, 1
  %49 = add nsw i64 %48, %38
  %50 = icmp sgt i64 %49, %42
  br i1 %50, label %56, label %51, !llvm.loop !101

51:                                               ; preds = %44, %47
  %52 = phi i64 [ 0, %44 ], [ %48, %47 ]
  %53 = getelementptr inbounds nuw i8, ptr %45, i64 %52
  %54 = tail call i32 @memcmp(ptr noundef nonnull %53, ptr noundef nonnull %46, i64 noundef %38)
  %55 = icmp eq i32 %54, 0
  br i1 %55, label %56, label %47

56:                                               ; preds = %51, %47
  %57 = zext i1 %55 to i64
  br label %101

58:                                               ; preds = %7, %7
  %59 = tail call fastcc i64 @hash_v(i64 noundef %1) #39
  %60 = getelementptr inbounds nuw i8, ptr %8, i64 40
  %61 = load i64, ptr %60, align 8, !tbaa !40
  %62 = icmp eq i64 %61, 0
  br i1 %62, label %101, label %63

63:                                               ; preds = %58
  %64 = add nsw i64 %61, -1
  %65 = getelementptr inbounds nuw i8, ptr %8, i64 48
  %66 = and i64 %64, %59
  %67 = load ptr, ptr %65, align 8, !tbaa !41
  %68 = getelementptr inbounds i64, ptr %67, i64 %66
  %69 = load i64, ptr %68, align 8, !tbaa !11
  %70 = icmp slt i64 %69, 0
  br i1 %70, label %101, label %71

71:                                               ; preds = %63
  %72 = getelementptr inbounds nuw i8, ptr %8, i64 32
  br label %73

73:                                               ; preds = %92, %71
  %74 = phi ptr [ %67, %71 ], [ %93, %92 ]
  %75 = phi i64 [ %69, %71 ], [ %97, %92 ]
  %76 = phi i64 [ %66, %71 ], [ %95, %92 ]
  %77 = load ptr, ptr %72, align 8, !tbaa !36
  %78 = getelementptr inbounds nuw %struct.Ent, ptr %77, i64 %75
  %79 = load i64, ptr %78, align 8, !tbaa !37
  %80 = icmp eq i64 %79, 0
  br i1 %80, label %92, label %81

81:                                               ; preds = %73
  %82 = getelementptr inbounds nuw i8, ptr %78, i64 16
  %83 = load i64, ptr %82, align 8, !tbaa !39
  %84 = icmp eq i64 %83, %59
  br i1 %84, label %85, label %92

85:                                               ; preds = %81
  %86 = icmp eq i64 %79, %1
  br i1 %86, label %101, label %87

87:                                               ; preds = %85
  %88 = tail call i64 @rt_eq_i(i64 noundef %79, i64 noundef %1) #39
  %89 = icmp eq i64 %88, 0
  br i1 %89, label %90, label %101

90:                                               ; preds = %87
  %91 = load ptr, ptr %65, align 8, !tbaa !41
  br label %92

92:                                               ; preds = %90, %81, %73
  %93 = phi ptr [ %91, %90 ], [ %74, %73 ], [ %74, %81 ]
  %94 = add nuw nsw i64 %76, 1
  %95 = and i64 %94, %64
  %96 = getelementptr inbounds i64, ptr %93, i64 %95
  %97 = load i64, ptr %96, align 8, !tbaa !11
  %98 = icmp slt i64 %97, 0
  br i1 %98, label %101, label %73

99:                                               ; preds = %2, %7
  %100 = tail call fastcc ptr @tname(i64 noundef %0)
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.150, ptr noundef nonnull %100) #36
  unreachable

101:                                              ; preds = %92, %87, %85, %15, %19, %10, %63, %58, %56, %36, %40
  %102 = phi i64 [ 0, %63 ], [ 0, %40 ], [ 1, %36 ], [ %57, %56 ], [ 0, %10 ], [ 0, %58 ], [ 1, %19 ], [ 0, %15 ], [ 0, %92 ], [ 1, %85 ], [ 1, %87 ]
  ret i64 %102
}

; Function Attrs: nofree nounwind ssp uwtable(sync)
define noundef i64 @rt_list_new(i64 noundef %0, ptr noundef readonly captures(none) %1) local_unnamed_addr #0 {
  %3 = tail call fastcc i64 @mklist(i64 noundef %0)
  %4 = inttoptr i64 %3 to ptr
  %5 = getelementptr inbounds nuw i8, ptr %4, i64 24
  %6 = load ptr, ptr %5, align 8, !tbaa !32
  %7 = shl i64 %0, 3
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %6, ptr noundef align 1 %1, i64 noundef %7, i1 noundef false) #35
  %8 = getelementptr inbounds nuw i8, ptr %4, i64 8
  store i64 %0, ptr %8, align 8, !tbaa !27
  ret i64 %3
}

; Function Attrs: nofree nounwind ssp uwtable(sync)
define noundef i64 @rt_tuple_new(i64 noundef %0, ptr noundef readonly captures(none) %1) local_unnamed_addr #0 {
  %3 = tail call fastcc i64 @mktuple(i64 noundef %0)
  %4 = inttoptr i64 %3 to ptr
  %5 = getelementptr inbounds nuw i8, ptr %4, i64 24
  %6 = load ptr, ptr %5, align 8, !tbaa !32
  %7 = shl i64 %0, 3
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %6, ptr noundef align 1 %1, i64 noundef %7, i1 noundef false) #35
  ret i64 %3
}

; Function Attrs: nounwind ssp uwtable(sync)
define noundef i64 @rt_dict_new(i64 noundef %0, ptr noundef readonly captures(none) %1) local_unnamed_addr #2 {
  %3 = tail call dereferenceable_or_null(56) ptr @calloc(i64 noundef 1, i64 noundef 56) #33
  %4 = icmp eq ptr %3, null
  br i1 %4, label %5, label %8

5:                                                ; preds = %2
  %6 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %7 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %6)
  tail call void @exit(i32 noundef 1) #34
  unreachable

8:                                                ; preds = %2
  store i64 7, ptr %3, align 8, !tbaa !68
  %9 = icmp sgt i64 %0, 0
  br i1 %9, label %12, label %10

10:                                               ; preds = %12, %8
  %11 = ptrtoint ptr %3 to i64
  ret i64 %11

12:                                               ; preds = %8, %12
  %13 = phi i64 [ %19, %12 ], [ 0, %8 ]
  %14 = shl nuw nsw i64 %13, 4
  %15 = getelementptr inbounds nuw i8, ptr %1, i64 %14
  %16 = load i64, ptr %15, align 8, !tbaa !11
  %17 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %18 = load i64, ptr %17, align 8, !tbaa !11
  tail call fastcc void @dict_set(ptr noundef nonnull %3, i64 noundef %16, i64 noundef %18)
  %19 = add nuw nsw i64 %13, 1
  %20 = icmp eq i64 %19, %0
  br i1 %20, label %10, label %12, !llvm.loop !102
}

; Function Attrs: nounwind ssp uwtable(sync)
define noundef i64 @rt_set_new(i64 noundef %0, ptr noundef readonly captures(none) %1) local_unnamed_addr #2 {
  %3 = tail call dereferenceable_or_null(56) ptr @calloc(i64 noundef 1, i64 noundef 56) #33
  %4 = icmp eq ptr %3, null
  br i1 %4, label %5, label %8

5:                                                ; preds = %2
  %6 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %7 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %6)
  tail call void @exit(i32 noundef 1) #34
  unreachable

8:                                                ; preds = %2
  store i64 8, ptr %3, align 8, !tbaa !68
  %9 = icmp sgt i64 %0, 0
  br i1 %9, label %12, label %10

10:                                               ; preds = %12, %8
  %11 = ptrtoint ptr %3 to i64
  ret i64 %11

12:                                               ; preds = %8, %12
  %13 = phi i64 [ %17, %12 ], [ 0, %8 ]
  %14 = getelementptr inbounds nuw i64, ptr %1, i64 %13
  %15 = load i64, ptr %14, align 8, !tbaa !11
  %16 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  tail call fastcc void @dict_set(ptr noundef nonnull %3, i64 noundef %15, i64 noundef %16)
  %17 = add nuw nsw i64 %13, 1
  %18 = icmp eq i64 %17, %0
  br i1 %18, label %10, label %12, !llvm.loop !103
}

; Function Attrs: mustprogress nounwind ssp willreturn memory(readwrite, target_mem0: none, target_mem1: none) uwtable(sync)
define i64 @rt_list_append(i64 noundef %0, i64 noundef %1) local_unnamed_addr #16 {
  %3 = inttoptr i64 %0 to ptr
  %4 = getelementptr inbounds nuw i8, ptr %3, i64 8
  %5 = load i64, ptr %4, align 8, !tbaa !27
  %6 = getelementptr inbounds nuw i8, ptr %3, i64 16
  %7 = load i64, ptr %6, align 8, !tbaa !70
  %8 = icmp slt i64 %5, %7
  br i1 %8, label %9, label %12

9:                                                ; preds = %2
  %10 = getelementptr inbounds nuw i8, ptr %3, i64 24
  %11 = load ptr, ptr %10, align 8, !tbaa !32
  br label %19

12:                                               ; preds = %2
  %13 = shl nsw i64 %7, 1
  store i64 %13, ptr %6, align 8, !tbaa !70
  %14 = getelementptr inbounds nuw i8, ptr %3, i64 24
  %15 = load ptr, ptr %14, align 8, !tbaa !32
  %16 = shl i64 %7, 4
  %17 = tail call ptr @realloc(ptr noundef %15, i64 noundef %16) #38
  store ptr %17, ptr %14, align 8, !tbaa !32
  %18 = load i64, ptr %4, align 8, !tbaa !27
  br label %19

19:                                               ; preds = %9, %12
  %20 = phi i64 [ %5, %9 ], [ %18, %12 ]
  %21 = phi ptr [ %11, %9 ], [ %17, %12 ]
  %22 = add nsw i64 %20, 1
  store i64 %22, ptr %4, align 8, !tbaa !27
  %23 = getelementptr inbounds i64, ptr %21, i64 %20
  store i64 %1, ptr %23, align 8, !tbaa !11
  %24 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  ret i64 %24
}

; Function Attrs: mustprogress nounwind ssp willreturn memory(readwrite, target_mem0: none, target_mem1: none) uwtable(sync)
define internal fastcc void @list_append(i64 noundef %0, i64 noundef %1) unnamed_addr #16 {
  %3 = inttoptr i64 %0 to ptr
  %4 = getelementptr inbounds nuw i8, ptr %3, i64 8
  %5 = load i64, ptr %4, align 8, !tbaa !27
  %6 = getelementptr inbounds nuw i8, ptr %3, i64 16
  %7 = load i64, ptr %6, align 8, !tbaa !70
  %8 = icmp slt i64 %5, %7
  br i1 %8, label %9, label %12

9:                                                ; preds = %2
  %10 = getelementptr inbounds nuw i8, ptr %3, i64 24
  %11 = load ptr, ptr %10, align 8, !tbaa !32
  br label %19

12:                                               ; preds = %2
  %13 = shl nsw i64 %7, 1
  store i64 %13, ptr %6, align 8, !tbaa !70
  %14 = getelementptr inbounds nuw i8, ptr %3, i64 24
  %15 = load ptr, ptr %14, align 8, !tbaa !32
  %16 = shl i64 %7, 4
  %17 = tail call ptr @realloc(ptr noundef %15, i64 noundef %16) #38
  store ptr %17, ptr %14, align 8, !tbaa !32
  %18 = load i64, ptr %4, align 8, !tbaa !27
  br label %19

19:                                               ; preds = %9, %12
  %20 = phi i64 [ %5, %9 ], [ %18, %12 ]
  %21 = phi ptr [ %11, %9 ], [ %17, %12 ]
  %22 = add nsw i64 %20, 1
  store i64 %22, ptr %4, align 8, !tbaa !27
  %23 = getelementptr inbounds i64, ptr %21, i64 %20
  store i64 %1, ptr %23, align 8, !tbaa !11
  ret void
}

; Function Attrs: nofree nounwind ssp uwtable(sync)
define noundef i64 @rt_empty_list() local_unnamed_addr #0 {
  %1 = tail call fastcc i64 @mklist(i64 noundef 0)
  ret i64 %1
}

; Function Attrs: nofree nounwind ssp uwtable(sync)
define noundef i64 @rt_func_new(ptr noundef %0, i64 noundef %1, i64 noundef %2, i64 noundef %3, ptr noundef readonly captures(none) %4) local_unnamed_addr #0 {
  %6 = tail call dereferenceable_or_null(48) ptr @calloc(i64 noundef 1, i64 noundef 48) #33
  %7 = icmp eq ptr %6, null
  br i1 %7, label %8, label %11

8:                                                ; preds = %5
  %9 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %10 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %9)
  tail call void @exit(i32 noundef 1) #34
  unreachable

11:                                               ; preds = %5
  store i64 9, ptr %6, align 8, !tbaa !104
  %12 = getelementptr inbounds nuw i8, ptr %6, i64 8
  store ptr %0, ptr %12, align 8, !tbaa !55
  %13 = getelementptr inbounds nuw i8, ptr %6, i64 16
  store i64 %1, ptr %13, align 8, !tbaa !47
  %14 = getelementptr inbounds nuw i8, ptr %6, i64 40
  store i64 %2, ptr %14, align 8, !tbaa !50
  %15 = getelementptr inbounds nuw i8, ptr %6, i64 24
  store i64 %3, ptr %15, align 8, !tbaa !49
  %16 = icmp eq i64 %3, 0
  br i1 %16, label %27, label %17

17:                                               ; preds = %11
  %18 = shl i64 %3, 3
  %19 = tail call i64 @llvm.umax.i64(i64 %18, i64 1)
  %20 = tail call ptr @calloc(i64 noundef 1, i64 noundef %19) #33
  %21 = icmp eq ptr %20, null
  br i1 %21, label %22, label %25

22:                                               ; preds = %17
  %23 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %24 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %23)
  tail call void @exit(i32 noundef 1) #34
  unreachable

25:                                               ; preds = %17
  %26 = getelementptr inbounds nuw i8, ptr %6, i64 32
  store ptr %20, ptr %26, align 8, !tbaa !51
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 %20, ptr noundef align 1 %4, i64 noundef %18, i1 noundef false) #35
  br label %27

27:                                               ; preds = %25, %11
  %28 = ptrtoint ptr %6 to i64
  ret i64 %28
}

; Function Attrs: nofree nounwind ssp uwtable(sync)
define noundef i64 @rt_class_new(i64 noundef %0, i64 noundef %1) local_unnamed_addr #0 {
  %3 = tail call fastcc i64 @new_class(i64 noundef %0, i64 noundef %1)
  ret i64 %3
}

; Function Attrs: nofree nounwind ssp uwtable(sync)
define internal fastcc noundef i64 @new_class(i64 noundef %0, i64 noundef %1) unnamed_addr #0 {
  %3 = tail call dereferenceable_or_null(32) ptr @calloc(i64 noundef 1, i64 noundef 32) #33
  %4 = icmp eq ptr %3, null
  br i1 %4, label %5, label %8

5:                                                ; preds = %2
  %6 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %7 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %6)
  tail call void @exit(i32 noundef 1) #34
  unreachable

8:                                                ; preds = %2
  store i64 11, ptr %3, align 8, !tbaa !105
  %9 = getelementptr inbounds nuw i8, ptr %3, i64 8
  store i64 %0, ptr %9, align 8, !tbaa !60
  %10 = getelementptr inbounds nuw i8, ptr %3, i64 16
  store i64 %1, ptr %10, align 8, !tbaa !46
  %11 = tail call dereferenceable_or_null(56) ptr @calloc(i64 noundef 1, i64 noundef 56) #33
  %12 = icmp eq ptr %11, null
  br i1 %12, label %13, label %16

13:                                               ; preds = %8
  %14 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %15 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %14)
  tail call void @exit(i32 noundef 1) #34
  unreachable

16:                                               ; preds = %8
  store i64 7, ptr %11, align 8, !tbaa !68
  %17 = ptrtoint ptr %11 to i64
  %18 = getelementptr inbounds nuw i8, ptr %3, i64 24
  store i64 %17, ptr %18, align 8, !tbaa !44
  %19 = ptrtoint ptr %3 to i64
  ret i64 %19
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_class_set(i64 noundef %0, i64 noundef %1, i64 noundef %2) local_unnamed_addr #2 {
  %4 = inttoptr i64 %0 to ptr
  %5 = getelementptr inbounds nuw i8, ptr %4, i64 24
  %6 = load i64, ptr %5, align 8, !tbaa !44
  %7 = inttoptr i64 %6 to ptr
  tail call fastcc void @dict_set(ptr noundef %7, i64 noundef %1, i64 noundef %2)
  %8 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  ret i64 %8
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_fstr(i64 noundef %0, ptr noundef readonly captures(none) %1) local_unnamed_addr #2 {
  %3 = tail call dereferenceable_or_null(64) ptr @calloc(i64 noundef 1, i64 noundef 64) #33
  %4 = icmp eq ptr %3, null
  br i1 %4, label %7, label %5

5:                                                ; preds = %2
  %6 = icmp sgt i64 %0, 0
  br i1 %6, label %14, label %10

7:                                                ; preds = %2
  %8 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %9 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %8)
  tail call void @exit(i32 noundef 1) #34
  unreachable

10:                                               ; preds = %33, %5
  %11 = phi i64 [ 0, %5 ], [ %25, %33 ]
  %12 = phi ptr [ %3, %5 ], [ %35, %33 ]
  %13 = tail call fastcc i64 @mkstr(ptr noundef nonnull %12, i64 noundef %11)
  ret i64 %13

14:                                               ; preds = %5, %33
  %15 = phi i64 [ %38, %33 ], [ 0, %5 ]
  %16 = phi ptr [ %35, %33 ], [ %3, %5 ]
  %17 = phi i64 [ %25, %33 ], [ 0, %5 ]
  %18 = phi i64 [ %34, %33 ], [ 64, %5 ]
  %19 = getelementptr inbounds nuw i64, ptr %1, i64 %15
  %20 = load i64, ptr %19, align 8, !tbaa !11
  %21 = inttoptr i64 %20 to ptr
  %22 = getelementptr inbounds nuw i8, ptr %21, i64 16
  %23 = getelementptr inbounds nuw i8, ptr %21, i64 8
  %24 = load i64, ptr %23, align 8, !tbaa !18
  %25 = add nsw i64 %24, %17
  %26 = icmp slt i64 %25, %18
  br i1 %26, label %33, label %27

27:                                               ; preds = %14, %27
  %28 = phi i64 [ %29, %27 ], [ %18, %14 ]
  %29 = shl nsw i64 %28, 1
  %30 = icmp sgt i64 %29, %25
  br i1 %30, label %31, label %27, !llvm.loop !83

31:                                               ; preds = %27
  %32 = tail call ptr @realloc(ptr noundef nonnull %16, i64 noundef %29) #38
  br label %33

33:                                               ; preds = %14, %31
  %34 = phi i64 [ %29, %31 ], [ %18, %14 ]
  %35 = phi ptr [ %32, %31 ], [ %16, %14 ]
  %36 = getelementptr inbounds i8, ptr %35, i64 %17
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %36, ptr noundef nonnull readonly align 1 %22, i64 noundef %24, i1 noundef false) #35
  %37 = getelementptr inbounds i8, ptr %35, i64 %25
  store i8 0, ptr %37, align 1, !tbaa !10
  %38 = add nuw nsw i64 %15, 1
  %39 = icmp eq i64 %38, %0
  br i1 %39, label %10, label %14, !llvm.loop !106
}

; Function Attrs: nounwind ssp memory(readwrite, target_mem0: none, target_mem1: none) uwtable(sync)
define internal fastcc void @sb_add(ptr noundef nonnull captures(none) %0, ptr noundef readonly captures(none) %1, i64 noundef %2) unnamed_addr #17 {
  %4 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %5 = load i64, ptr %4, align 8, !tbaa !63
  %6 = add nsw i64 %5, %2
  %7 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %8 = load i64, ptr %7, align 8, !tbaa !82
  %9 = icmp slt i64 %6, %8
  br i1 %9, label %10, label %12

10:                                               ; preds = %3
  %11 = load ptr, ptr %0, align 8, !tbaa !61
  br label %20

12:                                               ; preds = %3, %12
  %13 = phi i64 [ %14, %12 ], [ %8, %3 ]
  %14 = shl nsw i64 %13, 1
  %15 = icmp sgt i64 %14, %6
  br i1 %15, label %16, label %12, !llvm.loop !83

16:                                               ; preds = %12
  %17 = load ptr, ptr %0, align 8, !tbaa !61
  %18 = tail call ptr @realloc(ptr noundef %17, i64 noundef %14) #38
  store ptr %18, ptr %0, align 8, !tbaa !61
  store i64 %14, ptr %7, align 8, !tbaa !82
  %19 = load i64, ptr %4, align 8, !tbaa !63
  br label %20

20:                                               ; preds = %10, %16
  %21 = phi i64 [ %5, %10 ], [ %19, %16 ]
  %22 = phi ptr [ %11, %10 ], [ %18, %16 ]
  %23 = getelementptr inbounds i8, ptr %22, i64 %21
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %23, ptr noundef align 1 %1, i64 noundef %2, i1 noundef false) #35
  %24 = load i64, ptr %4, align 8, !tbaa !63
  %25 = add nsw i64 %24, %2
  store i64 %25, ptr %4, align 8, !tbaa !63
  %26 = load ptr, ptr %0, align 8, !tbaa !61
  %27 = getelementptr inbounds i8, ptr %26, i64 %25
  store i8 0, ptr %27, align 1, !tbaa !10
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare ptr @llvm.stacksave.p0() #18

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.stackrestore.p0(ptr) #18

; Function Attrs: nounwind ssp uwtable(sync)
define noundef i64 @rt_iter_new(i64 noundef %0) local_unnamed_addr #2 {
  %2 = tail call dereferenceable_or_null(24) ptr @calloc(i64 noundef 1, i64 noundef 24) #33
  %3 = icmp eq ptr %2, null
  br i1 %3, label %4, label %7

4:                                                ; preds = %1
  %5 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %6 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %5)
  tail call void @exit(i32 noundef 1) #34
  unreachable

7:                                                ; preds = %1
  store i64 16, ptr %2, align 8, !tbaa !37
  %8 = and i64 %0, 1
  %9 = icmp ne i64 %8, 0
  %10 = icmp eq i64 %0, 0
  %11 = or i1 %10, %9
  br i1 %11, label %17, label %12

12:                                               ; preds = %7
  %13 = inttoptr i64 %0 to ptr
  %14 = load i64, ptr %13, align 8, !tbaa !23
  %15 = add i64 %14, -5
  %16 = icmp ult i64 %15, 2
  br i1 %16, label %19, label %17

17:                                               ; preds = %12, %7
  %18 = tail call fastcc i64 @as_list(i64 noundef %0)
  br label %19

19:                                               ; preds = %12, %17
  %20 = phi i64 [ %18, %17 ], [ %0, %12 ]
  %21 = getelementptr inbounds nuw i8, ptr %2, i64 8
  store i64 %20, ptr %21, align 8, !tbaa !42
  %22 = ptrtoint ptr %2 to i64
  ret i64 %22
}

; Function Attrs: nounwind ssp uwtable(sync)
define internal fastcc noundef i64 @as_list(i64 noundef %0) unnamed_addr #2 {
  %2 = and i64 %0, 1
  %3 = icmp ne i64 %2, 0
  %4 = icmp eq i64 %0, 0
  %5 = or i1 %4, %3
  br i1 %5, label %115, label %6

6:                                                ; preds = %1
  %7 = inttoptr i64 %0 to ptr
  %8 = load i64, ptr %7, align 8, !tbaa !23
  switch i64 %8, label %115 [
    i64 5, label %117
    i64 6, label %9
    i64 4, label %22
    i64 7, label %73
    i64 8, label %73
  ]

9:                                                ; preds = %6
  %10 = getelementptr inbounds nuw i8, ptr %7, i64 8
  %11 = load i64, ptr %10, align 8, !tbaa !27
  %12 = tail call fastcc i64 @mklist(i64 noundef %11)
  %13 = inttoptr i64 %12 to ptr
  %14 = getelementptr inbounds nuw i8, ptr %13, i64 24
  %15 = load ptr, ptr %14, align 8, !tbaa !32
  %16 = getelementptr inbounds nuw i8, ptr %7, i64 24
  %17 = load ptr, ptr %16, align 8, !tbaa !32
  %18 = load i64, ptr %10, align 8, !tbaa !27
  %19 = shl i64 %18, 3
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %15, ptr noundef align 1 %17, i64 noundef %19, i1 noundef false) #35
  %20 = load i64, ptr %10, align 8, !tbaa !27
  %21 = getelementptr inbounds nuw i8, ptr %13, i64 8
  store i64 %20, ptr %21, align 8, !tbaa !27
  br label %117

22:                                               ; preds = %6
  %23 = getelementptr inbounds nuw i8, ptr %7, i64 8
  %24 = load i64, ptr %23, align 8, !tbaa !18
  %25 = tail call fastcc i64 @mklist(i64 noundef %24)
  %26 = load i64, ptr %23, align 8, !tbaa !18
  %27 = icmp sgt i64 %26, 0
  br i1 %27, label %28, label %117

28:                                               ; preds = %22
  %29 = getelementptr inbounds nuw i8, ptr %7, i64 16
  %30 = inttoptr i64 %25 to ptr
  %31 = getelementptr inbounds nuw i8, ptr %30, i64 8
  %32 = getelementptr inbounds nuw i8, ptr %30, i64 16
  %33 = getelementptr inbounds nuw i8, ptr %30, i64 24
  br label %34

34:                                               ; preds = %28, %65
  %35 = phi i64 [ 0, %28 ], [ %70, %65 ]
  %36 = getelementptr inbounds nuw i8, ptr %29, i64 %35
  %37 = load i8, ptr %36, align 1, !tbaa !10
  %38 = zext i8 %37 to i64
  %39 = getelementptr inbounds nuw i64, ptr @char_cache, i64 %38
  %40 = load i64, ptr %39, align 8, !tbaa !11
  %41 = icmp eq i64 %40, 0
  br i1 %41, label %42, label %52

42:                                               ; preds = %34
  %43 = tail call dereferenceable_or_null(26) ptr @calloc(i64 noundef 1, i64 noundef 26) #33
  %44 = icmp eq ptr %43, null
  br i1 %44, label %45, label %48

45:                                               ; preds = %42
  %46 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %47 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %46)
  tail call void @exit(i32 noundef 1) #34
  unreachable

48:                                               ; preds = %42
  store <2 x i64> <i64 4, i64 1>, ptr %43, align 8, !tbaa !11
  %49 = getelementptr inbounds nuw i8, ptr %43, i64 16
  store i8 %37, ptr %49, align 8
  %50 = getelementptr inbounds nuw i8, ptr %43, i64 17
  store i8 0, ptr %50, align 1, !tbaa !10
  %51 = ptrtoint ptr %43 to i64
  store i64 %51, ptr %39, align 8, !tbaa !11
  br label %52

52:                                               ; preds = %34, %48
  %53 = phi i64 [ %40, %34 ], [ %51, %48 ]
  %54 = load i64, ptr %31, align 8, !tbaa !27
  %55 = load i64, ptr %32, align 8, !tbaa !70
  %56 = icmp slt i64 %54, %55
  br i1 %56, label %57, label %59

57:                                               ; preds = %52
  %58 = load ptr, ptr %33, align 8, !tbaa !32
  br label %65

59:                                               ; preds = %52
  %60 = shl nsw i64 %55, 1
  store i64 %60, ptr %32, align 8, !tbaa !70
  %61 = load ptr, ptr %33, align 8, !tbaa !32
  %62 = shl i64 %55, 4
  %63 = tail call ptr @realloc(ptr noundef %61, i64 noundef %62) #38
  store ptr %63, ptr %33, align 8, !tbaa !32
  %64 = load i64, ptr %31, align 8, !tbaa !27
  br label %65

65:                                               ; preds = %57, %59
  %66 = phi i64 [ %54, %57 ], [ %64, %59 ]
  %67 = phi ptr [ %58, %57 ], [ %63, %59 ]
  %68 = add nsw i64 %66, 1
  store i64 %68, ptr %31, align 8, !tbaa !27
  %69 = getelementptr inbounds i64, ptr %67, i64 %66
  store i64 %53, ptr %69, align 8, !tbaa !11
  %70 = add nuw nsw i64 %35, 1
  %71 = load i64, ptr %23, align 8, !tbaa !18
  %72 = icmp slt i64 %70, %71
  br i1 %72, label %34, label %117, !llvm.loop !107

73:                                               ; preds = %6, %6
  %74 = getelementptr inbounds nuw i8, ptr %7, i64 8
  %75 = load i64, ptr %74, align 8, !tbaa !33
  %76 = tail call fastcc i64 @mklist(i64 noundef %75)
  %77 = getelementptr inbounds nuw i8, ptr %7, i64 16
  %78 = load i64, ptr %77, align 8, !tbaa !35
  %79 = icmp sgt i64 %78, 0
  br i1 %79, label %80, label %117

80:                                               ; preds = %73
  %81 = getelementptr inbounds nuw i8, ptr %7, i64 32
  %82 = inttoptr i64 %76 to ptr
  %83 = getelementptr inbounds nuw i8, ptr %82, i64 8
  %84 = getelementptr inbounds nuw i8, ptr %82, i64 16
  %85 = getelementptr inbounds nuw i8, ptr %82, i64 24
  br label %86

86:                                               ; preds = %111, %80
  %87 = phi i64 [ %78, %80 ], [ %112, %111 ]
  %88 = phi i64 [ 0, %80 ], [ %113, %111 ]
  %89 = load ptr, ptr %81, align 8, !tbaa !36
  %90 = getelementptr inbounds nuw %struct.Ent, ptr %89, i64 %88
  %91 = load i64, ptr %90, align 8, !tbaa !37
  %92 = icmp eq i64 %91, 0
  br i1 %92, label %111, label %93

93:                                               ; preds = %86
  %94 = load i64, ptr %83, align 8, !tbaa !27
  %95 = load i64, ptr %84, align 8, !tbaa !70
  %96 = icmp slt i64 %94, %95
  br i1 %96, label %97, label %99

97:                                               ; preds = %93
  %98 = load ptr, ptr %85, align 8, !tbaa !32
  br label %105

99:                                               ; preds = %93
  %100 = shl nsw i64 %95, 1
  store i64 %100, ptr %84, align 8, !tbaa !70
  %101 = load ptr, ptr %85, align 8, !tbaa !32
  %102 = shl i64 %95, 4
  %103 = tail call ptr @realloc(ptr noundef %101, i64 noundef %102) #38
  store ptr %103, ptr %85, align 8, !tbaa !32
  %104 = load i64, ptr %83, align 8, !tbaa !27
  br label %105

105:                                              ; preds = %99, %97
  %106 = phi i64 [ %94, %97 ], [ %104, %99 ]
  %107 = phi ptr [ %98, %97 ], [ %103, %99 ]
  %108 = add nsw i64 %106, 1
  store i64 %108, ptr %83, align 8, !tbaa !27
  %109 = getelementptr inbounds i64, ptr %107, i64 %106
  store i64 %91, ptr %109, align 8, !tbaa !11
  %110 = load i64, ptr %77, align 8, !tbaa !35
  br label %111

111:                                              ; preds = %105, %86
  %112 = phi i64 [ %87, %86 ], [ %110, %105 ]
  %113 = add nuw nsw i64 %88, 1
  %114 = icmp slt i64 %113, %112
  br i1 %114, label %86, label %117, !llvm.loop !108

115:                                              ; preds = %1, %6
  %116 = tail call fastcc ptr @tname(i64 noundef %0)
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.151, ptr noundef nonnull %116) #36
  unreachable

117:                                              ; preds = %111, %65, %22, %73, %6, %9
  %118 = phi i64 [ %25, %22 ], [ %12, %9 ], [ %0, %6 ], [ %76, %73 ], [ %25, %65 ], [ %76, %111 ]
  ret i64 %118
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind ssp willreturn memory(readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none) uwtable(sync)
define range(i64 0, 2) i64 @rt_iter_next(i64 noundef %0, ptr noundef writeonly captures(none) %1) local_unnamed_addr #19 {
  %3 = inttoptr i64 %0 to ptr
  %4 = getelementptr inbounds nuw i8, ptr %3, i64 16
  %5 = load i64, ptr %4, align 8, !tbaa !39
  %6 = getelementptr inbounds nuw i8, ptr %3, i64 8
  %7 = load i64, ptr %6, align 8, !tbaa !42
  %8 = inttoptr i64 %7 to ptr
  %9 = getelementptr inbounds nuw i8, ptr %8, i64 8
  %10 = load i64, ptr %9, align 8, !tbaa !27
  %11 = icmp slt i64 %5, %10
  br i1 %11, label %12, label %18

12:                                               ; preds = %2
  %13 = getelementptr inbounds nuw i8, ptr %8, i64 24
  %14 = load ptr, ptr %13, align 8, !tbaa !32
  %15 = add nsw i64 %5, 1
  store i64 %15, ptr %4, align 8, !tbaa !39
  %16 = getelementptr inbounds i64, ptr %14, i64 %5
  %17 = load i64, ptr %16, align 8, !tbaa !11
  store i64 %17, ptr %1, align 8, !tbaa !11
  br label %18

18:                                               ; preds = %2, %12
  %19 = phi i64 [ 1, %12 ], [ 0, %2 ]
  ret i64 %19
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_unpack(i64 noundef %0, i64 noundef %1, ptr noundef writeonly captures(none) %2) local_unnamed_addr #2 {
  %4 = ptrtoint ptr %2 to i64
  %5 = tail call fastcc i64 @as_list(i64 noundef %0)
  %6 = inttoptr i64 %5 to ptr
  %7 = getelementptr inbounds nuw i8, ptr %6, i64 8
  %8 = load i64, ptr %7, align 8, !tbaa !27
  %9 = icmp eq i64 %8, %1
  br i1 %9, label %10, label %42

10:                                               ; preds = %3
  %11 = icmp sgt i64 %1, 0
  br i1 %11, label %12, label %46

12:                                               ; preds = %10
  %13 = getelementptr inbounds nuw i8, ptr %6, i64 24
  %14 = load ptr, ptr %13, align 8, !tbaa !32
  %15 = icmp ult i64 %1, 8
  %16 = ptrtoint ptr %14 to i64
  %17 = sub i64 %4, %16
  %18 = icmp ult i64 %17, 64
  %19 = select i1 %15, i1 true, i1 %18
  br i1 %19, label %40, label %20

20:                                               ; preds = %12
  %21 = and i64 %1, 9223372036854775800
  br label %22

22:                                               ; preds = %22, %20
  %23 = phi i64 [ 0, %20 ], [ %36, %22 ]
  %24 = getelementptr inbounds nuw i64, ptr %14, i64 %23
  %25 = getelementptr inbounds nuw i8, ptr %24, i64 16
  %26 = getelementptr inbounds nuw i8, ptr %24, i64 32
  %27 = getelementptr inbounds nuw i8, ptr %24, i64 48
  %28 = load <2 x i64>, ptr %24, align 8, !tbaa !11
  %29 = load <2 x i64>, ptr %25, align 8, !tbaa !11
  %30 = load <2 x i64>, ptr %26, align 8, !tbaa !11
  %31 = load <2 x i64>, ptr %27, align 8, !tbaa !11
  %32 = getelementptr inbounds nuw i64, ptr %2, i64 %23
  %33 = getelementptr inbounds nuw i8, ptr %32, i64 16
  %34 = getelementptr inbounds nuw i8, ptr %32, i64 32
  %35 = getelementptr inbounds nuw i8, ptr %32, i64 48
  store <2 x i64> %28, ptr %32, align 8, !tbaa !11
  store <2 x i64> %29, ptr %33, align 8, !tbaa !11
  store <2 x i64> %30, ptr %34, align 8, !tbaa !11
  store <2 x i64> %31, ptr %35, align 8, !tbaa !11
  %36 = add nuw i64 %23, 8
  %37 = icmp eq i64 %36, %21
  br i1 %37, label %38, label %22, !llvm.loop !109

38:                                               ; preds = %22
  %39 = icmp eq i64 %1, %21
  br i1 %39, label %46, label %40

40:                                               ; preds = %12, %38
  %41 = phi i64 [ 0, %12 ], [ %21, %38 ]
  br label %48

42:                                               ; preds = %3
  %43 = icmp slt i64 %8, %1
  br i1 %43, label %44, label %45

44:                                               ; preds = %42
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.25, ptr noundef nonnull @.str.35, i64 noundef %1, i64 noundef %8) #36
  unreachable

45:                                               ; preds = %42
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.25, ptr noundef nonnull @.str.36, i64 noundef %1) #36
  unreachable

46:                                               ; preds = %48, %38, %10
  %47 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  ret i64 %47

48:                                               ; preds = %40, %48
  %49 = phi i64 [ %53, %48 ], [ %41, %40 ]
  %50 = getelementptr inbounds nuw i64, ptr %14, i64 %49
  %51 = load i64, ptr %50, align 8, !tbaa !11
  %52 = getelementptr inbounds nuw i64, ptr %2, i64 %49
  store i64 %51, ptr %52, align 8, !tbaa !11
  %53 = add nuw nsw i64 %49, 1
  %54 = icmp eq i64 %53, %1
  br i1 %54, label %46, label %48, !llvm.loop !110
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_slice(i64 noundef %0, i64 noundef %1, i64 noundef %2, i64 noundef %3) local_unnamed_addr #2 {
  %5 = and i64 %0, 1
  %6 = icmp ne i64 %5, 0
  %7 = icmp eq i64 %0, 0
  %8 = or i1 %7, %6
  br i1 %8, label %14, label %9

9:                                                ; preds = %4
  %10 = inttoptr i64 %0 to ptr
  %11 = load i64, ptr %10, align 8, !tbaa !23
  %12 = add i64 %11, -7
  %13 = icmp ult i64 %12, -3
  br i1 %13, label %14, label %16

14:                                               ; preds = %4, %9
  %15 = tail call fastcc ptr @tname(i64 noundef %0)
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.37, ptr noundef nonnull %15) #36
  unreachable

16:                                               ; preds = %9
  %17 = getelementptr inbounds nuw i8, ptr %10, i64 8
  %18 = load i64, ptr %17, align 8, !tbaa !11
  %19 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  %20 = icmp eq i64 %3, %19
  br i1 %20, label %42, label %21

21:                                               ; preds = %16
  %22 = and i64 %3, 1
  %23 = icmp eq i64 %22, 0
  br i1 %23, label %26, label %24

24:                                               ; preds = %21
  %25 = ashr i64 %3, 1
  br label %36

26:                                               ; preds = %21
  %27 = icmp eq i64 %3, 0
  br i1 %27, label %35, label %28

28:                                               ; preds = %26
  %29 = inttoptr i64 %3 to ptr
  %30 = load i64, ptr %29, align 8, !tbaa !23
  %31 = icmp eq i64 %30, 2
  br i1 %31, label %32, label %35

32:                                               ; preds = %28
  %33 = getelementptr inbounds nuw i8, ptr %29, i64 8
  %34 = load i64, ptr %33, align 8, !tbaa !25
  br label %36

35:                                               ; preds = %28, %26
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

36:                                               ; preds = %32, %24
  %37 = phi i64 [ %34, %32 ], [ %25, %24 ]
  %38 = icmp eq i64 %37, 0
  br i1 %38, label %39, label %40

39:                                               ; preds = %36
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.25, ptr noundef nonnull @.str.152) #36
  unreachable

40:                                               ; preds = %36
  %41 = icmp sgt i64 %37, 0
  br i1 %41, label %42, label %95

42:                                               ; preds = %40, %16
  %43 = phi i64 [ %37, %40 ], [ 1, %16 ]
  %44 = icmp eq i64 %1, %19
  br i1 %44, label %66, label %45

45:                                               ; preds = %42
  %46 = and i64 %1, 1
  %47 = icmp eq i64 %46, 0
  br i1 %47, label %50, label %48

48:                                               ; preds = %45
  %49 = ashr i64 %1, 1
  br label %60

50:                                               ; preds = %45
  %51 = icmp eq i64 %1, 0
  br i1 %51, label %59, label %52

52:                                               ; preds = %50
  %53 = inttoptr i64 %1 to ptr
  %54 = load i64, ptr %53, align 8, !tbaa !23
  %55 = icmp eq i64 %54, 2
  br i1 %55, label %56, label %59

56:                                               ; preds = %52
  %57 = getelementptr inbounds nuw i8, ptr %53, i64 8
  %58 = load i64, ptr %57, align 8, !tbaa !25
  br label %60

59:                                               ; preds = %52, %50
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

60:                                               ; preds = %56, %48
  %61 = phi i64 [ %58, %56 ], [ %49, %48 ]
  %62 = icmp slt i64 %61, 0
  br i1 %62, label %63, label %66

63:                                               ; preds = %60
  %64 = add nsw i64 %61, %18
  %65 = tail call i64 @llvm.smax.i64(i64 %64, i64 0)
  br label %69

66:                                               ; preds = %60, %42
  %67 = phi i64 [ %61, %60 ], [ 0, %42 ]
  %68 = tail call i64 @llvm.smin.i64(i64 %67, i64 %18)
  br label %69

69:                                               ; preds = %66, %63
  %70 = phi i64 [ %65, %63 ], [ %68, %66 ]
  %71 = icmp eq i64 %2, %19
  br i1 %71, label %87, label %72

72:                                               ; preds = %69
  %73 = and i64 %2, 1
  %74 = icmp eq i64 %73, 0
  br i1 %74, label %77, label %75

75:                                               ; preds = %72
  %76 = ashr i64 %2, 1
  br label %87

77:                                               ; preds = %72
  %78 = icmp eq i64 %2, 0
  br i1 %78, label %86, label %79

79:                                               ; preds = %77
  %80 = inttoptr i64 %2 to ptr
  %81 = load i64, ptr %80, align 8, !tbaa !23
  %82 = icmp eq i64 %81, 2
  br i1 %82, label %83, label %86

83:                                               ; preds = %79
  %84 = getelementptr inbounds nuw i8, ptr %80, i64 8
  %85 = load i64, ptr %84, align 8, !tbaa !25
  br label %87

86:                                               ; preds = %79, %77
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

87:                                               ; preds = %83, %75, %69
  %88 = phi i64 [ %18, %69 ], [ %76, %75 ], [ %85, %83 ]
  %89 = icmp slt i64 %88, 0
  br i1 %89, label %90, label %93

90:                                               ; preds = %87
  %91 = add nsw i64 %88, %18
  %92 = tail call i64 @llvm.smax.i64(i64 %91, i64 0)
  br label %150

93:                                               ; preds = %87
  %94 = tail call i64 @llvm.smin.i64(i64 %88, i64 %18)
  br label %150

95:                                               ; preds = %40
  %96 = icmp eq i64 %1, %19
  br i1 %96, label %97, label %99

97:                                               ; preds = %95
  %98 = add nsw i64 %18, -1
  br label %114

99:                                               ; preds = %95
  %100 = and i64 %1, 1
  %101 = icmp eq i64 %100, 0
  br i1 %101, label %104, label %102

102:                                              ; preds = %99
  %103 = ashr i64 %1, 1
  br label %114

104:                                              ; preds = %99
  %105 = icmp eq i64 %1, 0
  br i1 %105, label %113, label %106

106:                                              ; preds = %104
  %107 = inttoptr i64 %1 to ptr
  %108 = load i64, ptr %107, align 8, !tbaa !23
  %109 = icmp eq i64 %108, 2
  br i1 %109, label %110, label %113

110:                                              ; preds = %106
  %111 = getelementptr inbounds nuw i8, ptr %107, i64 8
  %112 = load i64, ptr %111, align 8, !tbaa !25
  br label %114

113:                                              ; preds = %106, %104
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

114:                                              ; preds = %110, %102, %97
  %115 = phi i64 [ %98, %97 ], [ %103, %102 ], [ %112, %110 ]
  %116 = icmp slt i64 %115, 0
  br i1 %116, label %117, label %120

117:                                              ; preds = %114
  %118 = add nsw i64 %115, %18
  %119 = tail call i64 @llvm.smax.i64(i64 %118, i64 -1)
  br label %123

120:                                              ; preds = %114
  %121 = add nsw i64 %18, -1
  %122 = tail call i64 @llvm.smin.i64(i64 %115, i64 %121)
  br label %123

123:                                              ; preds = %120, %117
  %124 = phi i64 [ %119, %117 ], [ %122, %120 ]
  %125 = icmp eq i64 %2, %19
  br i1 %125, label %158, label %126

126:                                              ; preds = %123
  %127 = and i64 %2, 1
  %128 = icmp eq i64 %127, 0
  br i1 %128, label %131, label %129

129:                                              ; preds = %126
  %130 = ashr i64 %2, 1
  br label %141

131:                                              ; preds = %126
  %132 = icmp eq i64 %2, 0
  br i1 %132, label %140, label %133

133:                                              ; preds = %131
  %134 = inttoptr i64 %2 to ptr
  %135 = load i64, ptr %134, align 8, !tbaa !23
  %136 = icmp eq i64 %135, 2
  br i1 %136, label %137, label %140

137:                                              ; preds = %133
  %138 = getelementptr inbounds nuw i8, ptr %134, i64 8
  %139 = load i64, ptr %138, align 8, !tbaa !25
  br label %141

140:                                              ; preds = %133, %131
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

141:                                              ; preds = %137, %129
  %142 = phi i64 [ %139, %137 ], [ %130, %129 ]
  %143 = icmp slt i64 %142, 0
  br i1 %143, label %144, label %147

144:                                              ; preds = %141
  %145 = add nsw i64 %142, %18
  %146 = tail call i64 @llvm.smax.i64(i64 %145, i64 -1)
  br label %158

147:                                              ; preds = %141
  %148 = add nsw i64 %18, -1
  %149 = tail call i64 @llvm.smin.i64(i64 %142, i64 %148)
  br label %158

150:                                              ; preds = %93, %90
  %151 = phi i64 [ %92, %90 ], [ %94, %93 ]
  %152 = icmp slt i64 %70, %151
  br i1 %152, label %153, label %167

153:                                              ; preds = %150
  %154 = xor i64 %70, -1
  %155 = add i64 %43, %154
  %156 = add i64 %155, %151
  %157 = sdiv i64 %156, %43
  br label %167

158:                                              ; preds = %144, %147, %123
  %159 = phi i64 [ -1, %123 ], [ %149, %147 ], [ %146, %144 ]
  %160 = icmp sgt i64 %124, %159
  br i1 %160, label %161, label %167

161:                                              ; preds = %158
  %162 = add i64 %159, %37
  %163 = xor i64 %162, -1
  %164 = add i64 %124, %163
  %165 = sub nsw i64 0, %37
  %166 = sdiv i64 %164, %165
  br label %167

167:                                              ; preds = %158, %161, %150, %153
  %168 = phi i64 [ %70, %153 ], [ %70, %150 ], [ %124, %161 ], [ %124, %158 ]
  %169 = phi i64 [ %43, %153 ], [ %43, %150 ], [ %37, %161 ], [ %37, %158 ]
  %170 = phi i64 [ %157, %153 ], [ 0, %150 ], [ %166, %161 ], [ 0, %158 ]
  switch i64 %11, label %197 [
    i64 4, label %171
    i64 5, label %199
  ]

171:                                              ; preds = %167
  %172 = icmp eq i64 %169, 1
  br i1 %172, label %173, label %176

173:                                              ; preds = %171
  %174 = getelementptr inbounds nuw i8, ptr %10, i64 16
  %175 = getelementptr inbounds i8, ptr %174, i64 %168
  br label %253

176:                                              ; preds = %171
  %177 = add nsw i64 %170, 1
  %178 = tail call i64 @llvm.umax.i64(i64 %177, i64 1)
  %179 = tail call ptr @calloc(i64 noundef 1, i64 noundef %178) #33
  %180 = icmp eq ptr %179, null
  br i1 %180, label %186, label %181

181:                                              ; preds = %176
  %182 = icmp sgt i64 %170, 0
  br i1 %182, label %183, label %253

183:                                              ; preds = %181
  %184 = getelementptr inbounds nuw i8, ptr %10, i64 16
  %185 = getelementptr i8, ptr %184, i64 %168
  br label %189

186:                                              ; preds = %176
  %187 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %188 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %187)
  tail call void @exit(i32 noundef 1) #34
  unreachable

189:                                              ; preds = %183, %189
  %190 = phi i64 [ 0, %183 ], [ %195, %189 ]
  %191 = mul nsw i64 %190, %169
  %192 = getelementptr i8, ptr %185, i64 %191
  %193 = load i8, ptr %192, align 1, !tbaa !10
  %194 = getelementptr inbounds nuw i8, ptr %179, i64 %190
  store i8 %193, ptr %194, align 1, !tbaa !10
  %195 = add nuw nsw i64 %190, 1
  %196 = icmp eq i64 %195, %170
  br i1 %196, label %253, label %189, !llvm.loop !111

197:                                              ; preds = %167
  %198 = tail call fastcc i64 @mktuple(i64 noundef %170)
  br label %203

199:                                              ; preds = %167
  %200 = tail call fastcc i64 @mklist(i64 noundef %170)
  %201 = inttoptr i64 %200 to ptr
  %202 = getelementptr inbounds nuw i8, ptr %201, i64 8
  store i64 %170, ptr %202, align 8, !tbaa !27
  br label %203

203:                                              ; preds = %197, %199
  %204 = phi i64 [ %200, %199 ], [ %198, %197 ]
  %205 = icmp sgt i64 %170, 0
  br i1 %205, label %206, label %256

206:                                              ; preds = %203
  %207 = getelementptr inbounds nuw i8, ptr %10, i64 24
  %208 = load ptr, ptr %207, align 8, !tbaa !32
  %209 = getelementptr i64, ptr %208, i64 %168
  %210 = inttoptr i64 %204 to ptr
  %211 = getelementptr inbounds nuw i8, ptr %210, i64 24
  %212 = load ptr, ptr %211, align 8, !tbaa !32
  %213 = icmp ugt i64 %170, 9
  %214 = icmp eq i64 %169, 1
  %215 = and i1 %213, %214
  br i1 %215, label %216, label %243

216:                                              ; preds = %206
  %217 = ptrtoint ptr %212 to i64
  %218 = ptrtoint ptr %208 to i64
  %219 = shl i64 %168, 3
  %220 = add i64 %219, %218
  %221 = sub i64 %217, %220
  %222 = icmp ult i64 %221, 64
  br i1 %222, label %243, label %223

223:                                              ; preds = %216
  %224 = and i64 %170, 9223372036854775800
  br label %225

225:                                              ; preds = %225, %223
  %226 = phi i64 [ 0, %223 ], [ %239, %225 ]
  %227 = getelementptr i64, ptr %209, i64 %226
  %228 = getelementptr i8, ptr %227, i64 16
  %229 = getelementptr i8, ptr %227, i64 32
  %230 = getelementptr i8, ptr %227, i64 48
  %231 = load <2 x i64>, ptr %227, align 8, !tbaa !11
  %232 = load <2 x i64>, ptr %228, align 8, !tbaa !11
  %233 = load <2 x i64>, ptr %229, align 8, !tbaa !11
  %234 = load <2 x i64>, ptr %230, align 8, !tbaa !11
  %235 = getelementptr inbounds nuw i64, ptr %212, i64 %226
  %236 = getelementptr inbounds nuw i8, ptr %235, i64 16
  %237 = getelementptr inbounds nuw i8, ptr %235, i64 32
  %238 = getelementptr inbounds nuw i8, ptr %235, i64 48
  store <2 x i64> %231, ptr %235, align 8, !tbaa !11
  store <2 x i64> %232, ptr %236, align 8, !tbaa !11
  store <2 x i64> %233, ptr %237, align 8, !tbaa !11
  store <2 x i64> %234, ptr %238, align 8, !tbaa !11
  %239 = add nuw i64 %226, 8
  %240 = icmp eq i64 %239, %224
  br i1 %240, label %241, label %225, !llvm.loop !112

241:                                              ; preds = %225
  %242 = icmp eq i64 %170, %224
  br i1 %242, label %256, label %243

243:                                              ; preds = %216, %206, %241
  %244 = phi i64 [ 0, %216 ], [ 0, %206 ], [ %224, %241 ]
  br label %245

245:                                              ; preds = %243, %245
  %246 = phi i64 [ %251, %245 ], [ %244, %243 ]
  %247 = mul nsw i64 %246, %169
  %248 = getelementptr i64, ptr %209, i64 %247
  %249 = load i64, ptr %248, align 8, !tbaa !11
  %250 = getelementptr inbounds nuw i64, ptr %212, i64 %246
  store i64 %249, ptr %250, align 8, !tbaa !11
  %251 = add nuw nsw i64 %246, 1
  %252 = icmp eq i64 %251, %170
  br i1 %252, label %256, label %245, !llvm.loop !113

253:                                              ; preds = %189, %181, %173
  %254 = phi ptr [ %175, %173 ], [ %179, %181 ], [ %179, %189 ]
  %255 = tail call fastcc i64 @mkstr(ptr noundef nonnull %254, i64 noundef %170)
  br label %256

256:                                              ; preds = %245, %241, %253, %203
  %257 = phi i64 [ %204, %203 ], [ %255, %253 ], [ %204, %241 ], [ %204, %245 ]
  ret i64 %257
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_getitem(i64 noundef %0, i64 noundef %1) local_unnamed_addr #2 {
  %3 = alloca [2 x i64], align 8
  %4 = and i64 %0, 1
  %5 = icmp ne i64 %4, 0
  %6 = icmp eq i64 %0, 0
  %7 = or i1 %6, %5
  br i1 %7, label %169, label %8

8:                                                ; preds = %2
  %9 = inttoptr i64 %0 to ptr
  %10 = load i64, ptr %9, align 8, !tbaa !23
  switch i64 %10, label %169 [
    i64 5, label %11
    i64 6, label %11
    i64 4, label %44
    i64 7, label %87
    i64 12, label %135
  ]

11:                                               ; preds = %8, %8
  %12 = getelementptr inbounds nuw i8, ptr %9, i64 24
  %13 = load ptr, ptr %12, align 8, !tbaa !32
  %14 = getelementptr inbounds nuw i8, ptr %9, i64 8
  %15 = load i64, ptr %14, align 8, !tbaa !27
  %16 = and i64 %1, 1
  %17 = icmp eq i64 %16, 0
  br i1 %17, label %20, label %18

18:                                               ; preds = %11
  %19 = ashr i64 %1, 1
  br label %30

20:                                               ; preds = %11
  %21 = icmp eq i64 %1, 0
  br i1 %21, label %29, label %22

22:                                               ; preds = %20
  %23 = inttoptr i64 %1 to ptr
  %24 = load i64, ptr %23, align 8, !tbaa !23
  %25 = icmp eq i64 %24, 2
  br i1 %25, label %26, label %29

26:                                               ; preds = %22
  %27 = getelementptr inbounds nuw i8, ptr %23, i64 8
  %28 = load i64, ptr %27, align 8, !tbaa !25
  br label %30

29:                                               ; preds = %22, %20
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

30:                                               ; preds = %26, %18
  %31 = phi i64 [ %19, %18 ], [ %28, %26 ]
  %32 = icmp slt i64 %31, 0
  %33 = select i1 %32, i64 %15, i64 0
  %34 = add nsw i64 %33, %31
  %35 = icmp sgt i64 %34, -1
  %36 = icmp slt i64 %34, %15
  %37 = and i1 %35, %36
  br i1 %37, label %41, label %38

38:                                               ; preds = %30
  %39 = icmp eq i64 %10, 5
  %40 = select i1 %39, ptr @.str.38, ptr @.str.39
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.103, ptr noundef nonnull @.str.153, ptr noundef nonnull %40) #36
  unreachable

41:                                               ; preds = %30
  %42 = getelementptr inbounds nuw i64, ptr %13, i64 %34
  %43 = load i64, ptr %42, align 8, !tbaa !11
  br label %171

44:                                               ; preds = %8
  %45 = getelementptr inbounds nuw i8, ptr %9, i64 8
  %46 = load i64, ptr %45, align 8, !tbaa !18
  %47 = and i64 %1, 1
  %48 = icmp eq i64 %47, 0
  br i1 %48, label %51, label %49

49:                                               ; preds = %44
  %50 = ashr i64 %1, 1
  br label %61

51:                                               ; preds = %44
  %52 = icmp eq i64 %1, 0
  br i1 %52, label %60, label %53

53:                                               ; preds = %51
  %54 = inttoptr i64 %1 to ptr
  %55 = load i64, ptr %54, align 8, !tbaa !23
  %56 = icmp eq i64 %55, 2
  br i1 %56, label %57, label %60

57:                                               ; preds = %53
  %58 = getelementptr inbounds nuw i8, ptr %54, i64 8
  %59 = load i64, ptr %58, align 8, !tbaa !25
  br label %61

60:                                               ; preds = %53, %51
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

61:                                               ; preds = %57, %49
  %62 = phi i64 [ %50, %49 ], [ %59, %57 ]
  %63 = icmp slt i64 %62, 0
  %64 = select i1 %63, i64 %46, i64 0
  %65 = add nsw i64 %64, %62
  %66 = icmp sgt i64 %65, -1
  %67 = icmp slt i64 %65, %46
  %68 = and i1 %66, %67
  br i1 %68, label %70, label %69

69:                                               ; preds = %61
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.103, ptr noundef nonnull @.str.153, ptr noundef nonnull @.str.40) #36
  unreachable

70:                                               ; preds = %61
  %71 = getelementptr inbounds nuw i8, ptr %9, i64 16
  %72 = getelementptr inbounds nuw i8, ptr %71, i64 %65
  %73 = load i8, ptr %72, align 1, !tbaa !10
  %74 = zext i8 %73 to i64
  %75 = getelementptr inbounds nuw i64, ptr @char_cache, i64 %74
  %76 = load i64, ptr %75, align 8, !tbaa !11
  %77 = icmp eq i64 %76, 0
  br i1 %77, label %78, label %171

78:                                               ; preds = %70
  %79 = tail call dereferenceable_or_null(26) ptr @calloc(i64 noundef 1, i64 noundef 26) #33
  %80 = icmp eq ptr %79, null
  br i1 %80, label %81, label %84

81:                                               ; preds = %78
  %82 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %83 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %82)
  tail call void @exit(i32 noundef 1) #34
  unreachable

84:                                               ; preds = %78
  store <2 x i64> <i64 4, i64 1>, ptr %79, align 8, !tbaa !11
  %85 = getelementptr inbounds nuw i8, ptr %79, i64 16
  store i8 %73, ptr %85, align 8
  %86 = ptrtoint ptr %79 to i64
  store i64 %86, ptr %75, align 8, !tbaa !11
  br label %171

87:                                               ; preds = %8
  %88 = tail call fastcc i64 @hash_v(i64 noundef %1) #39
  %89 = getelementptr inbounds nuw i8, ptr %9, i64 40
  %90 = load i64, ptr %89, align 8, !tbaa !40
  %91 = icmp eq i64 %90, 0
  br i1 %91, label %128, label %92

92:                                               ; preds = %87
  %93 = add nsw i64 %90, -1
  %94 = getelementptr inbounds nuw i8, ptr %9, i64 48
  %95 = and i64 %93, %88
  %96 = load ptr, ptr %94, align 8, !tbaa !41
  %97 = getelementptr inbounds i64, ptr %96, i64 %95
  %98 = load i64, ptr %97, align 8, !tbaa !11
  %99 = icmp slt i64 %98, 0
  br i1 %99, label %128, label %100

100:                                              ; preds = %92
  %101 = getelementptr inbounds nuw i8, ptr %9, i64 32
  br label %102

102:                                              ; preds = %121, %100
  %103 = phi ptr [ %96, %100 ], [ %122, %121 ]
  %104 = phi i64 [ %98, %100 ], [ %126, %121 ]
  %105 = phi i64 [ %95, %100 ], [ %124, %121 ]
  %106 = load ptr, ptr %101, align 8, !tbaa !36
  %107 = getelementptr inbounds nuw %struct.Ent, ptr %106, i64 %104
  %108 = load i64, ptr %107, align 8, !tbaa !37
  %109 = icmp eq i64 %108, 0
  br i1 %109, label %121, label %110

110:                                              ; preds = %102
  %111 = getelementptr inbounds nuw i8, ptr %107, i64 16
  %112 = load i64, ptr %111, align 8, !tbaa !39
  %113 = icmp eq i64 %112, %88
  br i1 %113, label %114, label %121

114:                                              ; preds = %110
  %115 = icmp eq i64 %108, %1
  br i1 %115, label %132, label %116

116:                                              ; preds = %114
  %117 = tail call i64 @rt_eq_i(i64 noundef %108, i64 noundef %1) #39
  %118 = icmp eq i64 %117, 0
  br i1 %118, label %119, label %132

119:                                              ; preds = %116
  %120 = load ptr, ptr %94, align 8, !tbaa !41
  br label %121

121:                                              ; preds = %119, %110, %102
  %122 = phi ptr [ %120, %119 ], [ %103, %102 ], [ %103, %110 ]
  %123 = add nuw nsw i64 %105, 1
  %124 = and i64 %123, %93
  %125 = getelementptr inbounds i64, ptr %122, i64 %124
  %126 = load i64, ptr %125, align 8, !tbaa !11
  %127 = icmp slt i64 %126, 0
  br i1 %127, label %128, label %102

128:                                              ; preds = %121, %87, %92
  %129 = tail call i64 @rt_repr(i64 noundef %1)
  %130 = inttoptr i64 %129 to ptr
  %131 = getelementptr inbounds nuw i8, ptr %130, i64 16
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.41, ptr noundef nonnull @.str.42, ptr noundef nonnull %131) #36
  unreachable

132:                                              ; preds = %116, %114
  %133 = getelementptr inbounds nuw i8, ptr %107, i64 8
  %134 = load i64, ptr %133, align 8, !tbaa !42
  br label %171

135:                                              ; preds = %8
  %136 = getelementptr inbounds nuw i8, ptr %9, i64 8
  %137 = load i64, ptr %136, align 8, !tbaa !42
  %138 = load i64, ptr @K_getitem, align 8, !tbaa !11
  %139 = icmp ne i64 %137, 0
  %140 = and i64 %137, 1
  %141 = icmp eq i64 %140, 0
  %142 = and i1 %139, %141
  br i1 %142, label %143, label %169

143:                                              ; preds = %135, %155
  %144 = phi i64 [ %157, %155 ], [ %137, %135 ]
  %145 = inttoptr i64 %144 to ptr
  %146 = load i64, ptr %145, align 8, !tbaa !23
  %147 = icmp eq i64 %146, 11
  br i1 %147, label %148, label %169

148:                                              ; preds = %143
  %149 = getelementptr inbounds nuw i8, ptr %145, i64 24
  %150 = load i64, ptr %149, align 8, !tbaa !44
  %151 = inttoptr i64 %150 to ptr
  %152 = tail call fastcc i64 @hash_v(i64 noundef %138) #39
  %153 = tail call fastcc ptr @dict_find(ptr noundef %151, i64 noundef %138, i64 noundef %152) #39
  %154 = icmp eq ptr %153, null
  br i1 %154, label %155, label %162

155:                                              ; preds = %148
  %156 = getelementptr inbounds nuw i8, ptr %145, i64 16
  %157 = load i64, ptr %156, align 8, !tbaa !46
  %158 = icmp ne i64 %157, 0
  %159 = and i64 %157, 1
  %160 = icmp eq i64 %159, 0
  %161 = and i1 %158, %160
  br i1 %161, label %143, label %169

162:                                              ; preds = %148
  %163 = getelementptr inbounds nuw i8, ptr %153, i64 8
  %164 = load i64, ptr %163, align 8, !tbaa !42
  %165 = icmp eq i64 %164, 0
  br i1 %165, label %169, label %166

166:                                              ; preds = %162
  call void @llvm.lifetime.start.p0(ptr nonnull %3) #35
  store i64 %0, ptr %3, align 8, !tbaa !11
  %167 = getelementptr inbounds nuw i8, ptr %3, i64 8
  store i64 %1, ptr %167, align 8, !tbaa !11
  %168 = call i64 @rt_call(i64 noundef %164, i64 noundef 2, ptr noundef nonnull %3)
  call void @llvm.lifetime.end.p0(ptr nonnull %3) #35
  br label %171

169:                                              ; preds = %155, %143, %135, %162, %2, %8
  %170 = tail call fastcc ptr @tname(i64 noundef %0)
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.37, ptr noundef nonnull %170) #36
  unreachable

171:                                              ; preds = %166, %84, %70, %132, %41
  %172 = phi i64 [ %43, %41 ], [ %168, %166 ], [ %134, %132 ], [ %76, %70 ], [ %86, %84 ]
  ret i64 %172
}

; Function Attrs: nounwind ssp uwtable(sync)
define internal fastcc noundef ptr @dict_get_e(ptr noundef readonly captures(none) %0, i64 noundef %1) unnamed_addr #2 {
  %3 = tail call fastcc i64 @hash_v(i64 noundef %1)
  %4 = getelementptr inbounds nuw i8, ptr %0, i64 40
  %5 = load i64, ptr %4, align 8, !tbaa !40
  %6 = icmp eq i64 %5, 0
  br i1 %6, label %43, label %7

7:                                                ; preds = %2
  %8 = add nsw i64 %5, -1
  %9 = getelementptr inbounds nuw i8, ptr %0, i64 48
  %10 = and i64 %3, %8
  %11 = load ptr, ptr %9, align 8, !tbaa !41
  %12 = getelementptr inbounds i64, ptr %11, i64 %10
  %13 = load i64, ptr %12, align 8, !tbaa !11
  %14 = icmp slt i64 %13, 0
  br i1 %14, label %43, label %15

15:                                               ; preds = %7
  %16 = getelementptr inbounds nuw i8, ptr %0, i64 32
  br label %17

17:                                               ; preds = %15, %36
  %18 = phi ptr [ %11, %15 ], [ %37, %36 ]
  %19 = phi i64 [ %13, %15 ], [ %41, %36 ]
  %20 = phi i64 [ %10, %15 ], [ %39, %36 ]
  %21 = load ptr, ptr %16, align 8, !tbaa !36
  %22 = getelementptr inbounds nuw %struct.Ent, ptr %21, i64 %19
  %23 = load i64, ptr %22, align 8, !tbaa !37
  %24 = icmp eq i64 %23, 0
  br i1 %24, label %36, label %25

25:                                               ; preds = %17
  %26 = getelementptr inbounds nuw i8, ptr %22, i64 16
  %27 = load i64, ptr %26, align 8, !tbaa !39
  %28 = icmp eq i64 %27, %3
  br i1 %28, label %29, label %36

29:                                               ; preds = %25
  %30 = icmp eq i64 %23, %1
  br i1 %30, label %43, label %31

31:                                               ; preds = %29
  %32 = tail call i64 @rt_eq_i(i64 noundef %23, i64 noundef %1)
  %33 = icmp eq i64 %32, 0
  br i1 %33, label %34, label %43

34:                                               ; preds = %31
  %35 = load ptr, ptr %9, align 8, !tbaa !41
  br label %36

36:                                               ; preds = %34, %17, %25
  %37 = phi ptr [ %35, %34 ], [ %18, %17 ], [ %18, %25 ]
  %38 = add nuw nsw i64 %20, 1
  %39 = and i64 %38, %8
  %40 = getelementptr inbounds i64, ptr %37, i64 %39
  %41 = load i64, ptr %40, align 8, !tbaa !11
  %42 = icmp slt i64 %41, 0
  br i1 %42, label %43, label %17

43:                                               ; preds = %36, %31, %29, %7, %2
  %44 = phi ptr [ null, %2 ], [ null, %7 ], [ null, %36 ], [ %22, %31 ], [ %22, %29 ]
  ret ptr %44
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_setitem(i64 noundef %0, i64 noundef %1, i64 noundef %2) local_unnamed_addr #2 {
  %4 = alloca [3 x i64], align 8
  %5 = and i64 %0, 1
  %6 = icmp ne i64 %5, 0
  %7 = icmp eq i64 %0, 0
  %8 = or i1 %7, %6
  br i1 %8, label %81, label %9

9:                                                ; preds = %3
  %10 = inttoptr i64 %0 to ptr
  %11 = load i64, ptr %10, align 8, !tbaa !23
  switch i64 %11, label %81 [
    i64 5, label %12
    i64 7, label %43
    i64 12, label %45
  ]

12:                                               ; preds = %9
  %13 = getelementptr inbounds nuw i8, ptr %10, i64 24
  %14 = load ptr, ptr %13, align 8, !tbaa !32
  %15 = getelementptr inbounds nuw i8, ptr %10, i64 8
  %16 = load i64, ptr %15, align 8, !tbaa !27
  %17 = and i64 %1, 1
  %18 = icmp eq i64 %17, 0
  br i1 %18, label %21, label %19

19:                                               ; preds = %12
  %20 = ashr i64 %1, 1
  br label %31

21:                                               ; preds = %12
  %22 = icmp eq i64 %1, 0
  br i1 %22, label %30, label %23

23:                                               ; preds = %21
  %24 = inttoptr i64 %1 to ptr
  %25 = load i64, ptr %24, align 8, !tbaa !23
  %26 = icmp eq i64 %25, 2
  br i1 %26, label %27, label %30

27:                                               ; preds = %23
  %28 = getelementptr inbounds nuw i8, ptr %24, i64 8
  %29 = load i64, ptr %28, align 8, !tbaa !25
  br label %31

30:                                               ; preds = %23, %21
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

31:                                               ; preds = %27, %19
  %32 = phi i64 [ %20, %19 ], [ %29, %27 ]
  %33 = icmp slt i64 %32, 0
  %34 = select i1 %33, i64 %16, i64 0
  %35 = add nsw i64 %34, %32
  %36 = icmp sgt i64 %35, -1
  %37 = icmp slt i64 %35, %16
  %38 = and i1 %36, %37
  br i1 %38, label %40, label %39

39:                                               ; preds = %31
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.103, ptr noundef nonnull @.str.153, ptr noundef nonnull @.str.43) #36
  unreachable

40:                                               ; preds = %31
  %41 = getelementptr inbounds nuw i64, ptr %14, i64 %35
  store i64 %2, ptr %41, align 8, !tbaa !11
  %42 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  br label %83

43:                                               ; preds = %9
  tail call fastcc void @dict_set(ptr noundef nonnull %10, i64 noundef %1, i64 noundef %2)
  %44 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  br label %83

45:                                               ; preds = %9
  %46 = getelementptr inbounds nuw i8, ptr %10, i64 8
  %47 = load i64, ptr %46, align 8, !tbaa !42
  %48 = load i64, ptr @K_setitem, align 8, !tbaa !11
  %49 = icmp ne i64 %47, 0
  %50 = and i64 %47, 1
  %51 = icmp eq i64 %50, 0
  %52 = and i1 %49, %51
  br i1 %52, label %53, label %81

53:                                               ; preds = %45, %65
  %54 = phi i64 [ %67, %65 ], [ %47, %45 ]
  %55 = inttoptr i64 %54 to ptr
  %56 = load i64, ptr %55, align 8, !tbaa !23
  %57 = icmp eq i64 %56, 11
  br i1 %57, label %58, label %81

58:                                               ; preds = %53
  %59 = getelementptr inbounds nuw i8, ptr %55, i64 24
  %60 = load i64, ptr %59, align 8, !tbaa !44
  %61 = inttoptr i64 %60 to ptr
  %62 = tail call fastcc i64 @hash_v(i64 noundef %48) #39
  %63 = tail call fastcc ptr @dict_find(ptr noundef %61, i64 noundef %48, i64 noundef %62) #39
  %64 = icmp eq ptr %63, null
  br i1 %64, label %65, label %72

65:                                               ; preds = %58
  %66 = getelementptr inbounds nuw i8, ptr %55, i64 16
  %67 = load i64, ptr %66, align 8, !tbaa !46
  %68 = icmp ne i64 %67, 0
  %69 = and i64 %67, 1
  %70 = icmp eq i64 %69, 0
  %71 = and i1 %68, %70
  br i1 %71, label %53, label %81

72:                                               ; preds = %58
  %73 = getelementptr inbounds nuw i8, ptr %63, i64 8
  %74 = load i64, ptr %73, align 8, !tbaa !42
  %75 = icmp eq i64 %74, 0
  br i1 %75, label %81, label %76

76:                                               ; preds = %72
  call void @llvm.lifetime.start.p0(ptr nonnull %4) #35
  store i64 %0, ptr %4, align 8, !tbaa !11
  %77 = getelementptr inbounds nuw i8, ptr %4, i64 8
  store i64 %1, ptr %77, align 8, !tbaa !11
  %78 = getelementptr inbounds nuw i8, ptr %4, i64 16
  store i64 %2, ptr %78, align 8, !tbaa !11
  %79 = call i64 @rt_call(i64 noundef %74, i64 noundef 3, ptr noundef nonnull %4)
  %80 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  call void @llvm.lifetime.end.p0(ptr nonnull %4) #35
  br label %83

81:                                               ; preds = %65, %53, %45, %72, %3, %9
  %82 = tail call fastcc ptr @tname(i64 noundef %0)
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.44, ptr noundef nonnull %82) #36
  unreachable

83:                                               ; preds = %76, %43, %40
  %84 = phi i64 [ %42, %40 ], [ %44, %43 ], [ %80, %76 ]
  ret i64 %84
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_delitem(i64 noundef %0, i64 noundef %1) local_unnamed_addr #2 {
  %3 = and i64 %0, 1
  %4 = icmp ne i64 %3, 0
  %5 = icmp eq i64 %0, 0
  %6 = or i1 %5, %4
  br i1 %6, label %95, label %7

7:                                                ; preds = %2
  %8 = inttoptr i64 %0 to ptr
  %9 = load i64, ptr %8, align 8, !tbaa !23
  switch i64 %9, label %95 [
    i64 5, label %10
    i64 7, label %46
  ]

10:                                               ; preds = %7
  %11 = getelementptr inbounds nuw i8, ptr %8, i64 8
  %12 = load i64, ptr %11, align 8, !tbaa !27
  %13 = and i64 %1, 1
  %14 = icmp eq i64 %13, 0
  br i1 %14, label %17, label %15

15:                                               ; preds = %10
  %16 = ashr i64 %1, 1
  br label %27

17:                                               ; preds = %10
  %18 = icmp eq i64 %1, 0
  br i1 %18, label %26, label %19

19:                                               ; preds = %17
  %20 = inttoptr i64 %1 to ptr
  %21 = load i64, ptr %20, align 8, !tbaa !23
  %22 = icmp eq i64 %21, 2
  br i1 %22, label %23, label %26

23:                                               ; preds = %19
  %24 = getelementptr inbounds nuw i8, ptr %20, i64 8
  %25 = load i64, ptr %24, align 8, !tbaa !25
  br label %27

26:                                               ; preds = %19, %17
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

27:                                               ; preds = %23, %15
  %28 = phi i64 [ %16, %15 ], [ %25, %23 ]
  %29 = icmp slt i64 %28, 0
  %30 = select i1 %29, i64 %12, i64 0
  %31 = add nsw i64 %30, %28
  %32 = icmp sgt i64 %31, -1
  %33 = icmp slt i64 %31, %12
  %34 = and i1 %32, %33
  br i1 %34, label %36, label %35

35:                                               ; preds = %27
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.103, ptr noundef nonnull @.str.153, ptr noundef nonnull @.str.43) #36
  unreachable

36:                                               ; preds = %27
  %37 = getelementptr inbounds nuw i8, ptr %8, i64 24
  %38 = load ptr, ptr %37, align 8, !tbaa !32
  %39 = getelementptr inbounds nuw i64, ptr %38, i64 %31
  %40 = getelementptr inbounds nuw i8, ptr %39, i64 8
  %41 = xor i64 %31, -1
  %42 = add i64 %12, %41
  %43 = shl i64 %42, 3
  tail call void @llvm.memmove.p0.p0.i64(ptr noundef align 1 %39, ptr noundef nonnull align 1 %40, i64 noundef %43, i1 noundef false) #35
  %44 = load i64, ptr %11, align 8, !tbaa !27
  %45 = add nsw i64 %44, -1
  store i64 %45, ptr %11, align 8, !tbaa !27
  br label %97

46:                                               ; preds = %7
  %47 = tail call fastcc i64 @hash_v(i64 noundef %1) #39
  %48 = getelementptr inbounds nuw i8, ptr %8, i64 40
  %49 = load i64, ptr %48, align 8, !tbaa !40
  %50 = icmp eq i64 %49, 0
  br i1 %50, label %91, label %51

51:                                               ; preds = %46
  %52 = add nsw i64 %49, -1
  %53 = getelementptr inbounds nuw i8, ptr %8, i64 48
  %54 = and i64 %52, %47
  %55 = load ptr, ptr %53, align 8, !tbaa !41
  %56 = getelementptr inbounds i64, ptr %55, i64 %54
  %57 = load i64, ptr %56, align 8, !tbaa !11
  %58 = icmp slt i64 %57, 0
  br i1 %58, label %91, label %59

59:                                               ; preds = %51
  %60 = getelementptr inbounds nuw i8, ptr %8, i64 32
  br label %61

61:                                               ; preds = %80, %59
  %62 = phi ptr [ %55, %59 ], [ %81, %80 ]
  %63 = phi i64 [ %57, %59 ], [ %85, %80 ]
  %64 = phi i64 [ %54, %59 ], [ %83, %80 ]
  %65 = load ptr, ptr %60, align 8, !tbaa !36
  %66 = getelementptr inbounds nuw %struct.Ent, ptr %65, i64 %63
  %67 = load i64, ptr %66, align 8, !tbaa !37
  %68 = icmp eq i64 %67, 0
  br i1 %68, label %80, label %69

69:                                               ; preds = %61
  %70 = getelementptr inbounds nuw i8, ptr %66, i64 16
  %71 = load i64, ptr %70, align 8, !tbaa !39
  %72 = icmp eq i64 %71, %47
  br i1 %72, label %73, label %80

73:                                               ; preds = %69
  %74 = icmp eq i64 %67, %1
  br i1 %74, label %87, label %75

75:                                               ; preds = %73
  %76 = tail call i64 @rt_eq_i(i64 noundef %67, i64 noundef %1) #39
  %77 = icmp eq i64 %76, 0
  br i1 %77, label %78, label %87

78:                                               ; preds = %75
  %79 = load ptr, ptr %53, align 8, !tbaa !41
  br label %80

80:                                               ; preds = %78, %69, %61
  %81 = phi ptr [ %79, %78 ], [ %62, %61 ], [ %62, %69 ]
  %82 = add nuw nsw i64 %64, 1
  %83 = and i64 %82, %52
  %84 = getelementptr inbounds i64, ptr %81, i64 %83
  %85 = load i64, ptr %84, align 8, !tbaa !11
  %86 = icmp slt i64 %85, 0
  br i1 %86, label %91, label %61

87:                                               ; preds = %73, %75
  %88 = getelementptr inbounds nuw i8, ptr %8, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %66, i8 0, i64 16, i1 false)
  %89 = load i64, ptr %88, align 8, !tbaa !33
  %90 = add nsw i64 %89, -1
  store i64 %90, ptr %88, align 8, !tbaa !33
  br label %97

91:                                               ; preds = %80, %46, %51
  %92 = tail call i64 @rt_repr(i64 noundef %1)
  %93 = inttoptr i64 %92 to ptr
  %94 = getelementptr inbounds nuw i8, ptr %93, i64 16
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.41, ptr noundef nonnull @.str.42, ptr noundef nonnull %94) #36
  unreachable

95:                                               ; preds = %7, %2
  %96 = tail call fastcc ptr @tname(i64 noundef %0)
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.45, ptr noundef nonnull %96) #36
  unreachable

97:                                               ; preds = %87, %36
  %98 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  ret i64 %98
}

; Function Attrs: nounwind ssp uwtable(sync)
define noundef i64 @m_sqrt(i64 %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = load i64, ptr %1, align 8, !tbaa !11
  %4 = and i64 %3, 1
  %5 = icmp eq i64 %4, 0
  br i1 %5, label %9, label %6

6:                                                ; preds = %2
  %7 = ashr i64 %3, 1
  %8 = sitofp i64 %7 to double
  br label %22

9:                                                ; preds = %2
  %10 = icmp eq i64 %3, 0
  br i1 %10, label %21, label %11

11:                                               ; preds = %9
  %12 = inttoptr i64 %3 to ptr
  %13 = load i64, ptr %12, align 8, !tbaa !23
  switch i64 %13, label %21 [
    i64 2, label %14
    i64 3, label %18
  ]

14:                                               ; preds = %11
  %15 = getelementptr inbounds nuw i8, ptr %12, i64 8
  %16 = load i64, ptr %15, align 8, !tbaa !25
  %17 = sitofp i64 %16 to double
  br label %22

18:                                               ; preds = %11
  %19 = getelementptr inbounds nuw i8, ptr %12, i64 8
  %20 = load double, ptr %19, align 8, !tbaa !22
  br label %22

21:                                               ; preds = %11, %9
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.108) #36
  unreachable

22:                                               ; preds = %6, %14, %18
  %23 = phi double [ %8, %6 ], [ %17, %14 ], [ %20, %18 ]
  %24 = tail call dereferenceable_or_null(16) ptr @calloc(i64 noundef 1, i64 noundef 16) #33
  %25 = icmp eq ptr %24, null
  br i1 %25, label %26, label %29

26:                                               ; preds = %22
  %27 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %28 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %27)
  tail call void @exit(i32 noundef 1) #34
  unreachable

29:                                               ; preds = %22
  %30 = tail call double @llvm.sqrt.f64(double %23)
  store i64 3, ptr %24, align 8, !tbaa !19
  %31 = getelementptr inbounds nuw i8, ptr %24, i64 8
  store double %30, ptr %31, align 8, !tbaa !22
  %32 = ptrtoint ptr %24 to i64
  ret i64 %32
}

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.sqrt.f64(double) #13

; Function Attrs: nounwind ssp uwtable(sync)
define range(i64 -9223372036854775807, -9223372036854775808) i64 @m_floor(i64 %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = load i64, ptr %1, align 8, !tbaa !11
  %4 = and i64 %3, 1
  %5 = icmp eq i64 %4, 0
  br i1 %5, label %9, label %6

6:                                                ; preds = %2
  %7 = ashr i64 %3, 1
  %8 = sitofp i64 %7 to double
  br label %23

9:                                                ; preds = %2
  %10 = icmp eq i64 %3, 0
  br i1 %10, label %22, label %11

11:                                               ; preds = %9
  %12 = inttoptr i64 %3 to ptr
  %13 = load i64, ptr %12, align 8, !tbaa !23
  switch i64 %13, label %22 [
    i64 2, label %14
    i64 3, label %18
  ]

14:                                               ; preds = %11
  %15 = getelementptr inbounds nuw i8, ptr %12, i64 8
  %16 = load i64, ptr %15, align 8, !tbaa !25
  %17 = sitofp i64 %16 to double
  br label %23

18:                                               ; preds = %11
  %19 = getelementptr inbounds nuw i8, ptr %12, i64 8
  %20 = load double, ptr %19, align 8, !tbaa !22
  %21 = tail call double @llvm.floor.f64(double %20)
  br label %23

22:                                               ; preds = %11, %9
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.108) #36
  unreachable

23:                                               ; preds = %6, %14, %18
  %24 = phi double [ %8, %6 ], [ %17, %14 ], [ %21, %18 ]
  %25 = fptosi double %24 to i64
  %26 = add i64 %25, -4611686018427387904
  %27 = icmp sgt i64 %26, -1
  br i1 %27, label %28, label %29

28:                                               ; preds = %23
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.7, ptr noundef nonnull @.str.131) #36
  unreachable

29:                                               ; preds = %23
  %30 = shl nsw i64 %25, 1
  %31 = or disjoint i64 %30, 1
  ret i64 %31
}

; Function Attrs: nounwind ssp uwtable(sync)
define range(i64 -9223372036854775807, -9223372036854775808) i64 @m_ceil(i64 %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = load i64, ptr %1, align 8, !tbaa !11
  %4 = and i64 %3, 1
  %5 = icmp eq i64 %4, 0
  br i1 %5, label %9, label %6

6:                                                ; preds = %2
  %7 = ashr i64 %3, 1
  %8 = sitofp i64 %7 to double
  br label %23

9:                                                ; preds = %2
  %10 = icmp eq i64 %3, 0
  br i1 %10, label %22, label %11

11:                                               ; preds = %9
  %12 = inttoptr i64 %3 to ptr
  %13 = load i64, ptr %12, align 8, !tbaa !23
  switch i64 %13, label %22 [
    i64 2, label %14
    i64 3, label %18
  ]

14:                                               ; preds = %11
  %15 = getelementptr inbounds nuw i8, ptr %12, i64 8
  %16 = load i64, ptr %15, align 8, !tbaa !25
  %17 = sitofp i64 %16 to double
  br label %23

18:                                               ; preds = %11
  %19 = getelementptr inbounds nuw i8, ptr %12, i64 8
  %20 = load double, ptr %19, align 8, !tbaa !22
  %21 = tail call double @llvm.ceil.f64(double %20)
  br label %23

22:                                               ; preds = %11, %9
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.108) #36
  unreachable

23:                                               ; preds = %6, %14, %18
  %24 = phi double [ %8, %6 ], [ %17, %14 ], [ %21, %18 ]
  %25 = fptosi double %24 to i64
  %26 = add i64 %25, -4611686018427387904
  %27 = icmp sgt i64 %26, -1
  br i1 %27, label %28, label %29

28:                                               ; preds = %23
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.7, ptr noundef nonnull @.str.131) #36
  unreachable

29:                                               ; preds = %23
  %30 = shl nsw i64 %25, 1
  %31 = or disjoint i64 %30, 1
  ret i64 %31
}

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.ceil.f64(double) #13

; Function Attrs: nounwind ssp uwtable(sync)
define noundef i64 @m_sin(i64 %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = load i64, ptr %1, align 8, !tbaa !11
  %4 = and i64 %3, 1
  %5 = icmp eq i64 %4, 0
  br i1 %5, label %9, label %6

6:                                                ; preds = %2
  %7 = ashr i64 %3, 1
  %8 = sitofp i64 %7 to double
  br label %22

9:                                                ; preds = %2
  %10 = icmp eq i64 %3, 0
  br i1 %10, label %21, label %11

11:                                               ; preds = %9
  %12 = inttoptr i64 %3 to ptr
  %13 = load i64, ptr %12, align 8, !tbaa !23
  switch i64 %13, label %21 [
    i64 2, label %14
    i64 3, label %18
  ]

14:                                               ; preds = %11
  %15 = getelementptr inbounds nuw i8, ptr %12, i64 8
  %16 = load i64, ptr %15, align 8, !tbaa !25
  %17 = sitofp i64 %16 to double
  br label %22

18:                                               ; preds = %11
  %19 = getelementptr inbounds nuw i8, ptr %12, i64 8
  %20 = load double, ptr %19, align 8, !tbaa !22
  br label %22

21:                                               ; preds = %11, %9
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.108) #36
  unreachable

22:                                               ; preds = %6, %14, %18
  %23 = phi double [ %8, %6 ], [ %17, %14 ], [ %20, %18 ]
  %24 = tail call dereferenceable_or_null(16) ptr @calloc(i64 noundef 1, i64 noundef 16) #33
  %25 = icmp eq ptr %24, null
  br i1 %25, label %26, label %29

26:                                               ; preds = %22
  %27 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %28 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %27)
  tail call void @exit(i32 noundef 1) #34
  unreachable

29:                                               ; preds = %22
  %30 = tail call double @llvm.sin.f64(double %23)
  store i64 3, ptr %24, align 8, !tbaa !19
  %31 = getelementptr inbounds nuw i8, ptr %24, i64 8
  store double %30, ptr %31, align 8, !tbaa !22
  %32 = ptrtoint ptr %24 to i64
  ret i64 %32
}

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.sin.f64(double) #13

; Function Attrs: nounwind ssp uwtable(sync)
define noundef i64 @m_cos(i64 %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = load i64, ptr %1, align 8, !tbaa !11
  %4 = and i64 %3, 1
  %5 = icmp eq i64 %4, 0
  br i1 %5, label %9, label %6

6:                                                ; preds = %2
  %7 = ashr i64 %3, 1
  %8 = sitofp i64 %7 to double
  br label %22

9:                                                ; preds = %2
  %10 = icmp eq i64 %3, 0
  br i1 %10, label %21, label %11

11:                                               ; preds = %9
  %12 = inttoptr i64 %3 to ptr
  %13 = load i64, ptr %12, align 8, !tbaa !23
  switch i64 %13, label %21 [
    i64 2, label %14
    i64 3, label %18
  ]

14:                                               ; preds = %11
  %15 = getelementptr inbounds nuw i8, ptr %12, i64 8
  %16 = load i64, ptr %15, align 8, !tbaa !25
  %17 = sitofp i64 %16 to double
  br label %22

18:                                               ; preds = %11
  %19 = getelementptr inbounds nuw i8, ptr %12, i64 8
  %20 = load double, ptr %19, align 8, !tbaa !22
  br label %22

21:                                               ; preds = %11, %9
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.108) #36
  unreachable

22:                                               ; preds = %6, %14, %18
  %23 = phi double [ %8, %6 ], [ %17, %14 ], [ %20, %18 ]
  %24 = tail call dereferenceable_or_null(16) ptr @calloc(i64 noundef 1, i64 noundef 16) #33
  %25 = icmp eq ptr %24, null
  br i1 %25, label %26, label %29

26:                                               ; preds = %22
  %27 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %28 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %27)
  tail call void @exit(i32 noundef 1) #34
  unreachable

29:                                               ; preds = %22
  %30 = tail call double @llvm.cos.f64(double %23)
  store i64 3, ptr %24, align 8, !tbaa !19
  %31 = getelementptr inbounds nuw i8, ptr %24, i64 8
  store double %30, ptr %31, align 8, !tbaa !22
  %32 = ptrtoint ptr %24 to i64
  ret i64 %32
}

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.cos.f64(double) #13

; Function Attrs: nounwind ssp uwtable(sync)
define noundef i64 @m_tan(i64 %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = load i64, ptr %1, align 8, !tbaa !11
  %4 = and i64 %3, 1
  %5 = icmp eq i64 %4, 0
  br i1 %5, label %9, label %6

6:                                                ; preds = %2
  %7 = ashr i64 %3, 1
  %8 = sitofp i64 %7 to double
  br label %22

9:                                                ; preds = %2
  %10 = icmp eq i64 %3, 0
  br i1 %10, label %21, label %11

11:                                               ; preds = %9
  %12 = inttoptr i64 %3 to ptr
  %13 = load i64, ptr %12, align 8, !tbaa !23
  switch i64 %13, label %21 [
    i64 2, label %14
    i64 3, label %18
  ]

14:                                               ; preds = %11
  %15 = getelementptr inbounds nuw i8, ptr %12, i64 8
  %16 = load i64, ptr %15, align 8, !tbaa !25
  %17 = sitofp i64 %16 to double
  br label %22

18:                                               ; preds = %11
  %19 = getelementptr inbounds nuw i8, ptr %12, i64 8
  %20 = load double, ptr %19, align 8, !tbaa !22
  br label %22

21:                                               ; preds = %11, %9
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.108) #36
  unreachable

22:                                               ; preds = %6, %14, %18
  %23 = phi double [ %8, %6 ], [ %17, %14 ], [ %20, %18 ]
  %24 = tail call dereferenceable_or_null(16) ptr @calloc(i64 noundef 1, i64 noundef 16) #33
  %25 = icmp eq ptr %24, null
  br i1 %25, label %26, label %29

26:                                               ; preds = %22
  %27 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %28 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %27)
  tail call void @exit(i32 noundef 1) #34
  unreachable

29:                                               ; preds = %22
  %30 = tail call double @llvm.tan.f64(double %23)
  store i64 3, ptr %24, align 8, !tbaa !19
  %31 = getelementptr inbounds nuw i8, ptr %24, i64 8
  store double %30, ptr %31, align 8, !tbaa !22
  %32 = ptrtoint ptr %24 to i64
  ret i64 %32
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.tan.f64(double) #20

; Function Attrs: nounwind ssp uwtable(sync)
define noundef i64 @m_exp(i64 %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = load i64, ptr %1, align 8, !tbaa !11
  %4 = and i64 %3, 1
  %5 = icmp eq i64 %4, 0
  br i1 %5, label %9, label %6

6:                                                ; preds = %2
  %7 = ashr i64 %3, 1
  %8 = sitofp i64 %7 to double
  br label %22

9:                                                ; preds = %2
  %10 = icmp eq i64 %3, 0
  br i1 %10, label %21, label %11

11:                                               ; preds = %9
  %12 = inttoptr i64 %3 to ptr
  %13 = load i64, ptr %12, align 8, !tbaa !23
  switch i64 %13, label %21 [
    i64 2, label %14
    i64 3, label %18
  ]

14:                                               ; preds = %11
  %15 = getelementptr inbounds nuw i8, ptr %12, i64 8
  %16 = load i64, ptr %15, align 8, !tbaa !25
  %17 = sitofp i64 %16 to double
  br label %22

18:                                               ; preds = %11
  %19 = getelementptr inbounds nuw i8, ptr %12, i64 8
  %20 = load double, ptr %19, align 8, !tbaa !22
  br label %22

21:                                               ; preds = %11, %9
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.108) #36
  unreachable

22:                                               ; preds = %6, %14, %18
  %23 = phi double [ %8, %6 ], [ %17, %14 ], [ %20, %18 ]
  %24 = tail call dereferenceable_or_null(16) ptr @calloc(i64 noundef 1, i64 noundef 16) #33
  %25 = icmp eq ptr %24, null
  br i1 %25, label %26, label %29

26:                                               ; preds = %22
  %27 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %28 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %27)
  tail call void @exit(i32 noundef 1) #34
  unreachable

29:                                               ; preds = %22
  %30 = tail call double @llvm.exp.f64(double %23)
  store i64 3, ptr %24, align 8, !tbaa !19
  %31 = getelementptr inbounds nuw i8, ptr %24, i64 8
  store double %30, ptr %31, align 8, !tbaa !22
  %32 = ptrtoint ptr %24 to i64
  ret i64 %32
}

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.exp.f64(double) #13

; Function Attrs: nounwind ssp uwtable(sync)
define noundef i64 @m_fabs(i64 %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = load i64, ptr %1, align 8, !tbaa !11
  %4 = and i64 %3, 1
  %5 = icmp eq i64 %4, 0
  br i1 %5, label %9, label %6

6:                                                ; preds = %2
  %7 = ashr i64 %3, 1
  %8 = sitofp i64 %7 to double
  br label %22

9:                                                ; preds = %2
  %10 = icmp eq i64 %3, 0
  br i1 %10, label %21, label %11

11:                                               ; preds = %9
  %12 = inttoptr i64 %3 to ptr
  %13 = load i64, ptr %12, align 8, !tbaa !23
  switch i64 %13, label %21 [
    i64 2, label %14
    i64 3, label %18
  ]

14:                                               ; preds = %11
  %15 = getelementptr inbounds nuw i8, ptr %12, i64 8
  %16 = load i64, ptr %15, align 8, !tbaa !25
  %17 = sitofp i64 %16 to double
  br label %22

18:                                               ; preds = %11
  %19 = getelementptr inbounds nuw i8, ptr %12, i64 8
  %20 = load double, ptr %19, align 8, !tbaa !22
  br label %22

21:                                               ; preds = %11, %9
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.108) #36
  unreachable

22:                                               ; preds = %6, %14, %18
  %23 = phi double [ %8, %6 ], [ %17, %14 ], [ %20, %18 ]
  %24 = tail call dereferenceable_or_null(16) ptr @calloc(i64 noundef 1, i64 noundef 16) #33
  %25 = icmp eq ptr %24, null
  br i1 %25, label %26, label %29

26:                                               ; preds = %22
  %27 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %28 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %27)
  tail call void @exit(i32 noundef 1) #34
  unreachable

29:                                               ; preds = %22
  %30 = tail call double @llvm.fabs.f64(double %23)
  store i64 3, ptr %24, align 8, !tbaa !19
  %31 = getelementptr inbounds nuw i8, ptr %24, i64 8
  store double %30, ptr %31, align 8, !tbaa !22
  %32 = ptrtoint ptr %24 to i64
  ret i64 %32
}

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.fabs.f64(double) #13

; Function Attrs: nounwind ssp uwtable(sync)
define noundef i64 @m_log(i64 noundef %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = load i64, ptr %1, align 8, !tbaa !11
  %4 = and i64 %3, 1
  %5 = icmp eq i64 %4, 0
  br i1 %5, label %9, label %6

6:                                                ; preds = %2
  %7 = ashr i64 %3, 1
  %8 = sitofp i64 %7 to double
  br label %22

9:                                                ; preds = %2
  %10 = icmp eq i64 %3, 0
  br i1 %10, label %21, label %11

11:                                               ; preds = %9
  %12 = inttoptr i64 %3 to ptr
  %13 = load i64, ptr %12, align 8, !tbaa !23
  switch i64 %13, label %21 [
    i64 2, label %14
    i64 3, label %18
  ]

14:                                               ; preds = %11
  %15 = getelementptr inbounds nuw i8, ptr %12, i64 8
  %16 = load i64, ptr %15, align 8, !tbaa !25
  %17 = sitofp i64 %16 to double
  br label %22

18:                                               ; preds = %11
  %19 = getelementptr inbounds nuw i8, ptr %12, i64 8
  %20 = load double, ptr %19, align 8, !tbaa !22
  br label %22

21:                                               ; preds = %11, %9
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.108) #36
  unreachable

22:                                               ; preds = %6, %14, %18
  %23 = phi double [ %8, %6 ], [ %17, %14 ], [ %20, %18 ]
  %24 = fcmp ugt double %23, 0.000000e+00
  br i1 %24, label %26, label %25

25:                                               ; preds = %22
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.25, ptr noundef nonnull @.str.46) #36
  unreachable

26:                                               ; preds = %22
  %27 = icmp sgt i64 %0, 1
  %28 = tail call double @llvm.log.f64(double %23)
  br i1 %27, label %29, label %54

29:                                               ; preds = %26
  %30 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %31 = load i64, ptr %30, align 8, !tbaa !11
  %32 = and i64 %31, 1
  %33 = icmp eq i64 %32, 0
  br i1 %33, label %37, label %34

34:                                               ; preds = %29
  %35 = ashr i64 %31, 1
  %36 = sitofp i64 %35 to double
  br label %50

37:                                               ; preds = %29
  %38 = icmp eq i64 %31, 0
  br i1 %38, label %49, label %39

39:                                               ; preds = %37
  %40 = inttoptr i64 %31 to ptr
  %41 = load i64, ptr %40, align 8, !tbaa !23
  switch i64 %41, label %49 [
    i64 2, label %42
    i64 3, label %46
  ]

42:                                               ; preds = %39
  %43 = getelementptr inbounds nuw i8, ptr %40, i64 8
  %44 = load i64, ptr %43, align 8, !tbaa !25
  %45 = sitofp i64 %44 to double
  br label %50

46:                                               ; preds = %39
  %47 = getelementptr inbounds nuw i8, ptr %40, i64 8
  %48 = load double, ptr %47, align 8, !tbaa !22
  br label %50

49:                                               ; preds = %39, %37
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.108) #36
  unreachable

50:                                               ; preds = %34, %42, %46
  %51 = phi double [ %36, %34 ], [ %45, %42 ], [ %48, %46 ]
  %52 = tail call double @llvm.log.f64(double %51)
  %53 = fdiv double %28, %52
  br label %54

54:                                               ; preds = %26, %50
  %55 = phi double [ %53, %50 ], [ %28, %26 ]
  %56 = tail call dereferenceable_or_null(16) ptr @calloc(i64 noundef 1, i64 noundef 16) #33
  %57 = icmp eq ptr %56, null
  br i1 %57, label %58, label %61

58:                                               ; preds = %54
  %59 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %60 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %59)
  tail call void @exit(i32 noundef 1) #34
  unreachable

61:                                               ; preds = %54
  store i64 3, ptr %56, align 8, !tbaa !19
  %62 = getelementptr inbounds nuw i8, ptr %56, i64 8
  store double %55, ptr %62, align 8, !tbaa !22
  %63 = ptrtoint ptr %56 to i64
  ret i64 %63
}

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.log.f64(double) #13

; Function Attrs: nounwind ssp uwtable(sync)
define noundef i64 @rt_import(i64 noundef %0) local_unnamed_addr #2 {
  %2 = tail call dereferenceable_or_null(16) ptr @calloc(i64 noundef 1, i64 noundef 16) #33
  %3 = icmp eq ptr %2, null
  br i1 %3, label %4, label %7

4:                                                ; preds = %1
  %5 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %6 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %5)
  tail call void @exit(i32 noundef 1) #34
  unreachable

7:                                                ; preds = %1
  store i64 15, ptr %2, align 8, !tbaa !114
  %8 = inttoptr i64 %0 to ptr
  %9 = getelementptr inbounds nuw i8, ptr %8, i64 16
  %10 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(4) @.str.47) #35
  %11 = icmp eq i32 %10, 0
  br i1 %11, label %27, label %12

12:                                               ; preds = %7
  %13 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(5) @.str.48) #35
  %14 = icmp eq i32 %13, 0
  br i1 %14, label %27, label %15

15:                                               ; preds = %12
  %16 = load i8, ptr %9, align 1
  %17 = icmp eq i8 %16, 111
  br i1 %17, label %18, label %26

18:                                               ; preds = %15
  %19 = getelementptr inbounds nuw i8, ptr %8, i64 17
  %20 = load i8, ptr %19, align 1
  %21 = icmp eq i8 %20, 115
  br i1 %21, label %22, label %26

22:                                               ; preds = %18
  %23 = getelementptr inbounds nuw i8, ptr %8, i64 18
  %24 = load i8, ptr %23, align 1
  %25 = icmp eq i8 %24, 0
  br i1 %25, label %27, label %26

26:                                               ; preds = %18, %15, %22
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.50, ptr noundef nonnull @.str.51, ptr noundef nonnull %9) #36
  unreachable

27:                                               ; preds = %22, %12, %7
  %28 = phi i64 [ 1, %7 ], [ 2, %12 ], [ 3, %22 ]
  %29 = getelementptr inbounds nuw i8, ptr %2, i64 8
  store i64 %28, ptr %29, align 8, !tbaa !25
  %30 = ptrtoint ptr %2 to i64
  ret i64 %30
}

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: read)
declare i32 @strcmp(ptr noundef captures(none), ptr noundef captures(none)) local_unnamed_addr #4

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_getattr(i64 noundef %0, i64 noundef %1) local_unnamed_addr #2 {
  %3 = and i64 %0, 1
  %4 = icmp eq i64 %3, 0
  %5 = icmp ne i64 %0, 0
  %6 = and i1 %5, %4
  br i1 %6, label %7, label %286

7:                                                ; preds = %2
  %8 = inttoptr i64 %0 to ptr
  %9 = load i64, ptr %8, align 8, !tbaa !23
  switch i64 %9, label %286 [
    i64 12, label %10
    i64 11, label %112
    i64 15, label %143
  ]

10:                                               ; preds = %7
  %11 = getelementptr inbounds nuw i8, ptr %8, i64 16
  %12 = load i64, ptr %11, align 8, !tbaa !39
  %13 = inttoptr i64 %12 to ptr
  %14 = tail call fastcc i64 @hash_v(i64 noundef %1) #39
  %15 = getelementptr inbounds nuw i8, ptr %13, i64 40
  %16 = load i64, ptr %15, align 8, !tbaa !40
  %17 = icmp eq i64 %16, 0
  br i1 %17, label %57, label %18

18:                                               ; preds = %10
  %19 = add nsw i64 %16, -1
  %20 = getelementptr inbounds nuw i8, ptr %13, i64 48
  %21 = and i64 %19, %14
  %22 = load ptr, ptr %20, align 8, !tbaa !41
  %23 = getelementptr inbounds i64, ptr %22, i64 %21
  %24 = load i64, ptr %23, align 8, !tbaa !11
  %25 = icmp slt i64 %24, 0
  br i1 %25, label %57, label %26

26:                                               ; preds = %18
  %27 = getelementptr inbounds nuw i8, ptr %13, i64 32
  br label %28

28:                                               ; preds = %47, %26
  %29 = phi ptr [ %22, %26 ], [ %48, %47 ]
  %30 = phi i64 [ %24, %26 ], [ %52, %47 ]
  %31 = phi i64 [ %21, %26 ], [ %50, %47 ]
  %32 = load ptr, ptr %27, align 8, !tbaa !36
  %33 = getelementptr inbounds nuw %struct.Ent, ptr %32, i64 %30
  %34 = load i64, ptr %33, align 8, !tbaa !37
  %35 = icmp eq i64 %34, 0
  br i1 %35, label %47, label %36

36:                                               ; preds = %28
  %37 = getelementptr inbounds nuw i8, ptr %33, i64 16
  %38 = load i64, ptr %37, align 8, !tbaa !39
  %39 = icmp eq i64 %38, %14
  br i1 %39, label %40, label %47

40:                                               ; preds = %36
  %41 = icmp eq i64 %34, %1
  br i1 %41, label %54, label %42

42:                                               ; preds = %40
  %43 = tail call i64 @rt_eq_i(i64 noundef %34, i64 noundef %1) #39
  %44 = icmp eq i64 %43, 0
  br i1 %44, label %45, label %54

45:                                               ; preds = %42
  %46 = load ptr, ptr %20, align 8, !tbaa !41
  br label %47

47:                                               ; preds = %45, %36, %28
  %48 = phi ptr [ %46, %45 ], [ %29, %28 ], [ %29, %36 ]
  %49 = add nuw nsw i64 %31, 1
  %50 = and i64 %49, %19
  %51 = getelementptr inbounds i64, ptr %48, i64 %50
  %52 = load i64, ptr %51, align 8, !tbaa !11
  %53 = icmp slt i64 %52, 0
  br i1 %53, label %57, label %28

54:                                               ; preds = %42, %40
  %55 = getelementptr inbounds nuw i8, ptr %33, i64 8
  %56 = load i64, ptr %55, align 8, !tbaa !42
  br label %290

57:                                               ; preds = %47, %10, %18
  %58 = getelementptr inbounds nuw i8, ptr %8, i64 8
  %59 = load i64, ptr %58, align 8, !tbaa !42
  %60 = icmp ne i64 %59, 0
  %61 = and i64 %59, 1
  %62 = icmp eq i64 %61, 0
  %63 = and i1 %60, %62
  br i1 %63, label %64, label %105

64:                                               ; preds = %57, %76
  %65 = phi i64 [ %78, %76 ], [ %59, %57 ]
  %66 = inttoptr i64 %65 to ptr
  %67 = load i64, ptr %66, align 8, !tbaa !23
  %68 = icmp eq i64 %67, 11
  br i1 %68, label %69, label %105

69:                                               ; preds = %64
  %70 = getelementptr inbounds nuw i8, ptr %66, i64 24
  %71 = load i64, ptr %70, align 8, !tbaa !44
  %72 = inttoptr i64 %71 to ptr
  %73 = tail call fastcc i64 @hash_v(i64 noundef %1) #39
  %74 = tail call fastcc ptr @dict_find(ptr noundef %72, i64 noundef %1, i64 noundef %73) #39
  %75 = icmp eq ptr %74, null
  br i1 %75, label %76, label %83

76:                                               ; preds = %69
  %77 = getelementptr inbounds nuw i8, ptr %66, i64 16
  %78 = load i64, ptr %77, align 8, !tbaa !46
  %79 = icmp ne i64 %78, 0
  %80 = and i64 %78, 1
  %81 = icmp eq i64 %80, 0
  %82 = and i1 %79, %81
  br i1 %82, label %64, label %105

83:                                               ; preds = %69
  %84 = getelementptr inbounds nuw i8, ptr %74, i64 8
  %85 = load i64, ptr %84, align 8, !tbaa !42
  %86 = icmp eq i64 %85, 0
  br i1 %86, label %105, label %87

87:                                               ; preds = %83
  %88 = and i64 %85, 1
  %89 = icmp eq i64 %88, 0
  br i1 %89, label %90, label %290

90:                                               ; preds = %87
  %91 = inttoptr i64 %85 to ptr
  %92 = load i64, ptr %91, align 8, !tbaa !23
  %93 = add i64 %92, -9
  %94 = icmp ult i64 %93, 2
  br i1 %94, label %95, label %290

95:                                               ; preds = %90
  %96 = tail call dereferenceable_or_null(24) ptr @calloc(i64 noundef 1, i64 noundef 24) #33
  %97 = icmp eq ptr %96, null
  br i1 %97, label %98, label %101

98:                                               ; preds = %95
  %99 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %100 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %99)
  tail call void @exit(i32 noundef 1) #34
  unreachable

101:                                              ; preds = %95
  store i64 13, ptr %96, align 8, !tbaa !37
  %102 = getelementptr inbounds nuw i8, ptr %96, i64 8
  store i64 %0, ptr %102, align 8, !tbaa !42
  %103 = getelementptr inbounds nuw i8, ptr %96, i64 16
  store i64 %85, ptr %103, align 8, !tbaa !39
  %104 = ptrtoint ptr %96 to i64
  br label %290

105:                                              ; preds = %76, %64, %57, %83
  %106 = inttoptr i64 %1 to ptr
  %107 = getelementptr inbounds nuw i8, ptr %106, i64 16
  %108 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %107, ptr noundef nonnull dereferenceable(10) @.str.52) #35
  %109 = icmp eq i32 %108, 0
  br i1 %109, label %110, label %286

110:                                              ; preds = %105
  %111 = load i64, ptr %58, align 8, !tbaa !42
  br label %290

112:                                              ; preds = %7, %124
  %113 = phi i64 [ %126, %124 ], [ %0, %7 ]
  %114 = inttoptr i64 %113 to ptr
  %115 = load i64, ptr %114, align 8, !tbaa !23
  %116 = icmp eq i64 %115, 11
  br i1 %116, label %117, label %135

117:                                              ; preds = %112
  %118 = getelementptr inbounds nuw i8, ptr %114, i64 24
  %119 = load i64, ptr %118, align 8, !tbaa !44
  %120 = inttoptr i64 %119 to ptr
  %121 = tail call fastcc i64 @hash_v(i64 noundef %1) #39
  %122 = tail call fastcc ptr @dict_find(ptr noundef %120, i64 noundef %1, i64 noundef %121) #39
  %123 = icmp eq ptr %122, null
  br i1 %123, label %124, label %131

124:                                              ; preds = %117
  %125 = getelementptr inbounds nuw i8, ptr %114, i64 16
  %126 = load i64, ptr %125, align 8, !tbaa !46
  %127 = icmp ne i64 %126, 0
  %128 = and i64 %126, 1
  %129 = icmp eq i64 %128, 0
  %130 = and i1 %127, %129
  br i1 %130, label %112, label %135

131:                                              ; preds = %117
  %132 = getelementptr inbounds nuw i8, ptr %122, i64 8
  %133 = load i64, ptr %132, align 8, !tbaa !42
  %134 = icmp eq i64 %133, 0
  br i1 %134, label %135, label %290

135:                                              ; preds = %124, %112, %131
  %136 = inttoptr i64 %1 to ptr
  %137 = getelementptr inbounds nuw i8, ptr %136, i64 16
  %138 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %137, ptr noundef nonnull dereferenceable(9) @.str.53) #35
  %139 = icmp eq i32 %138, 0
  br i1 %139, label %140, label %286

140:                                              ; preds = %135
  %141 = getelementptr inbounds nuw i8, ptr %8, i64 8
  %142 = load i64, ptr %141, align 8, !tbaa !60
  br label %290

143:                                              ; preds = %7
  %144 = inttoptr i64 %1 to ptr
  %145 = getelementptr inbounds nuw i8, ptr %144, i64 16
  %146 = getelementptr inbounds nuw i8, ptr %8, i64 8
  %147 = load i64, ptr %146, align 8, !tbaa !25
  switch i64 %147, label %285 [
    i64 1, label %148
    i64 2, label %184
  ]

148:                                              ; preds = %143
  %149 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %145, ptr noundef nonnull dereferenceable(5) @.str.154) #35
  %150 = icmp eq i32 %149, 0
  br i1 %150, label %151, label %153

151:                                              ; preds = %148
  %152 = load i64, ptr @sys_argv, align 8, !tbaa !11
  br label %290

153:                                              ; preds = %148
  %154 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %145, ptr noundef nonnull dereferenceable(7) @.str.155) #35
  %155 = icmp eq i32 %154, 0
  br i1 %155, label %156, label %158

156:                                              ; preds = %153
  %157 = load i64, ptr @sys_stdout, align 8, !tbaa !11
  br label %290

158:                                              ; preds = %153
  %159 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %145, ptr noundef nonnull dereferenceable(7) @.str.156) #35
  %160 = icmp eq i32 %159, 0
  br i1 %160, label %161, label %163

161:                                              ; preds = %158
  %162 = load i64, ptr @sys_stderr, align 8, !tbaa !11
  br label %290

163:                                              ; preds = %158
  %164 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %145, ptr noundef nonnull dereferenceable(6) @.str.157) #35
  %165 = icmp eq i32 %164, 0
  br i1 %165, label %166, label %168

166:                                              ; preds = %163
  %167 = load i64, ptr @sys_stdin, align 8, !tbaa !11
  br label %290

168:                                              ; preds = %163
  %169 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %145, ptr noundef nonnull dereferenceable(5) @.str.158) #35
  %170 = icmp eq i32 %169, 0
  br i1 %170, label %171, label %181

171:                                              ; preds = %168
  %172 = tail call dereferenceable_or_null(24) ptr @calloc(i64 noundef 1, i64 noundef 24) #33
  %173 = icmp eq ptr %172, null
  br i1 %173, label %174, label %177

174:                                              ; preds = %171
  %175 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %176 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %175)
  tail call void @exit(i32 noundef 1) #34
  unreachable

177:                                              ; preds = %171
  store i64 10, ptr %172, align 8, !tbaa !115
  %178 = getelementptr inbounds nuw i8, ptr %172, i64 8
  store ptr @b_exit, ptr %178, align 8, !tbaa !57
  %179 = getelementptr inbounds nuw i8, ptr %172, i64 16
  store ptr @.str.158, ptr %179, align 8, !tbaa !87
  %180 = ptrtoint ptr %172 to i64
  br label %290

181:                                              ; preds = %168
  %182 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %145, ptr noundef nonnull dereferenceable(8) @.str.159) #35
  %183 = icmp eq i32 %182, 0
  br i1 %183, label %290, label %285

184:                                              ; preds = %143
  %185 = load i8, ptr %145, align 1
  switch i8 %185, label %216 [
    i8 112, label %186
    i8 101, label %203
  ]

186:                                              ; preds = %184
  %187 = getelementptr inbounds nuw i8, ptr %144, i64 17
  %188 = load i8, ptr %187, align 1
  %189 = icmp eq i8 %188, 105
  br i1 %189, label %190, label %216

190:                                              ; preds = %186
  %191 = getelementptr inbounds nuw i8, ptr %144, i64 18
  %192 = load i8, ptr %191, align 1
  %193 = icmp eq i8 %192, 0
  br i1 %193, label %194, label %216

194:                                              ; preds = %190
  %195 = tail call dereferenceable_or_null(16) ptr @calloc(i64 noundef 1, i64 noundef 16) #33
  %196 = icmp eq ptr %195, null
  br i1 %196, label %197, label %200

197:                                              ; preds = %194
  %198 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %199 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %198)
  tail call void @exit(i32 noundef 1) #34
  unreachable

200:                                              ; preds = %194
  store i64 3, ptr %195, align 8, !tbaa !19
  %201 = getelementptr inbounds nuw i8, ptr %195, i64 8
  store double 0x400921FB54442D18, ptr %201, align 8, !tbaa !22
  %202 = ptrtoint ptr %195 to i64
  br label %290

203:                                              ; preds = %184
  %204 = getelementptr inbounds nuw i8, ptr %144, i64 17
  %205 = load i8, ptr %204, align 1
  %206 = icmp eq i8 %205, 0
  br i1 %206, label %207, label %216

207:                                              ; preds = %203
  %208 = tail call dereferenceable_or_null(16) ptr @calloc(i64 noundef 1, i64 noundef 16) #33
  %209 = icmp eq ptr %208, null
  br i1 %209, label %210, label %213

210:                                              ; preds = %207
  %211 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %212 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %211)
  tail call void @exit(i32 noundef 1) #34
  unreachable

213:                                              ; preds = %207
  store i64 3, ptr %208, align 8, !tbaa !19
  %214 = getelementptr inbounds nuw i8, ptr %208, i64 8
  store double 0x4005BF0A8B145769, ptr %214, align 8, !tbaa !22
  %215 = ptrtoint ptr %208 to i64
  br label %290

216:                                              ; preds = %203, %190, %186, %184
  %217 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %145, ptr noundef nonnull dereferenceable(5) @.str.162) #35
  %218 = icmp eq i32 %217, 0
  br i1 %218, label %219, label %229

219:                                              ; preds = %216
  %220 = tail call dereferenceable_or_null(24) ptr @calloc(i64 noundef 1, i64 noundef 24) #33
  %221 = icmp eq ptr %220, null
  br i1 %221, label %222, label %225

222:                                              ; preds = %219
  %223 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %224 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %223)
  tail call void @exit(i32 noundef 1) #34
  unreachable

225:                                              ; preds = %219
  store i64 10, ptr %220, align 8, !tbaa !115
  %226 = getelementptr inbounds nuw i8, ptr %220, i64 8
  store ptr @m_sqrt, ptr %226, align 8, !tbaa !57
  %227 = getelementptr inbounds nuw i8, ptr %220, i64 16
  store ptr @.str.162, ptr %227, align 8, !tbaa !87
  %228 = ptrtoint ptr %220 to i64
  br label %290

229:                                              ; preds = %216
  %230 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %145, ptr noundef nonnull dereferenceable(6) @.str.163) #35
  %231 = icmp eq i32 %230, 0
  br i1 %231, label %232, label %242

232:                                              ; preds = %229
  %233 = tail call dereferenceable_or_null(24) ptr @calloc(i64 noundef 1, i64 noundef 24) #33
  %234 = icmp eq ptr %233, null
  br i1 %234, label %235, label %238

235:                                              ; preds = %232
  %236 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %237 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %236)
  tail call void @exit(i32 noundef 1) #34
  unreachable

238:                                              ; preds = %232
  store i64 10, ptr %233, align 8, !tbaa !115
  %239 = getelementptr inbounds nuw i8, ptr %233, i64 8
  store ptr @m_floor, ptr %239, align 8, !tbaa !57
  %240 = getelementptr inbounds nuw i8, ptr %233, i64 16
  store ptr @.str.163, ptr %240, align 8, !tbaa !87
  %241 = ptrtoint ptr %233 to i64
  br label %290

242:                                              ; preds = %229
  %243 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %145, ptr noundef nonnull dereferenceable(5) @.str.164) #35
  %244 = icmp eq i32 %243, 0
  br i1 %244, label %245, label %255

245:                                              ; preds = %242
  %246 = tail call dereferenceable_or_null(24) ptr @calloc(i64 noundef 1, i64 noundef 24) #33
  %247 = icmp eq ptr %246, null
  br i1 %247, label %248, label %251

248:                                              ; preds = %245
  %249 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %250 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %249)
  tail call void @exit(i32 noundef 1) #34
  unreachable

251:                                              ; preds = %245
  store i64 10, ptr %246, align 8, !tbaa !115
  %252 = getelementptr inbounds nuw i8, ptr %246, i64 8
  store ptr @m_ceil, ptr %252, align 8, !tbaa !57
  %253 = getelementptr inbounds nuw i8, ptr %246, i64 16
  store ptr @.str.164, ptr %253, align 8, !tbaa !87
  %254 = ptrtoint ptr %246 to i64
  br label %290

255:                                              ; preds = %242
  %256 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %145, ptr noundef nonnull dereferenceable(4) @.str.165) #35
  %257 = icmp eq i32 %256, 0
  br i1 %257, label %258, label %260

258:                                              ; preds = %255
  %259 = tail call fastcc i64 @mkbuiltin(ptr noundef nonnull @m_sin, ptr noundef nonnull @.str.165)
  br label %290

260:                                              ; preds = %255
  %261 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %145, ptr noundef nonnull dereferenceable(4) @.str.166) #35
  %262 = icmp eq i32 %261, 0
  br i1 %262, label %263, label %265

263:                                              ; preds = %260
  %264 = tail call fastcc i64 @mkbuiltin(ptr noundef nonnull @m_cos, ptr noundef nonnull @.str.166)
  br label %290

265:                                              ; preds = %260
  %266 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %145, ptr noundef nonnull dereferenceable(4) @.str.167) #35
  %267 = icmp eq i32 %266, 0
  br i1 %267, label %268, label %270

268:                                              ; preds = %265
  %269 = tail call fastcc i64 @mkbuiltin(ptr noundef nonnull @m_tan, ptr noundef nonnull @.str.167)
  br label %290

270:                                              ; preds = %265
  %271 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %145, ptr noundef nonnull dereferenceable(4) @.str.168) #35
  %272 = icmp eq i32 %271, 0
  br i1 %272, label %273, label %275

273:                                              ; preds = %270
  %274 = tail call fastcc i64 @mkbuiltin(ptr noundef nonnull @m_exp, ptr noundef nonnull @.str.168)
  br label %290

275:                                              ; preds = %270
  %276 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %145, ptr noundef nonnull dereferenceable(5) @.str.169) #35
  %277 = icmp eq i32 %276, 0
  br i1 %277, label %278, label %280

278:                                              ; preds = %275
  %279 = tail call fastcc i64 @mkbuiltin(ptr noundef nonnull @m_fabs, ptr noundef nonnull @.str.169)
  br label %290

280:                                              ; preds = %275
  %281 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %145, ptr noundef nonnull dereferenceable(4) @.str.170) #35
  %282 = icmp eq i32 %281, 0
  br i1 %282, label %283, label %285

283:                                              ; preds = %280
  %284 = tail call fastcc i64 @mkbuiltin(ptr noundef nonnull @m_log, ptr noundef nonnull @.str.170)
  br label %290

285:                                              ; preds = %280, %181, %143
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.54, ptr noundef nonnull @.str.171, ptr noundef nonnull %145) #36
  unreachable

286:                                              ; preds = %2, %135, %105, %7
  %287 = tail call fastcc ptr @tname(i64 noundef %0)
  %288 = inttoptr i64 %1 to ptr
  %289 = getelementptr inbounds nuw i8, ptr %288, i64 16
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.54, ptr noundef nonnull @.str.55, ptr noundef nonnull %287, ptr noundef nonnull %289) #36
  unreachable

290:                                              ; preds = %90, %131, %140, %87, %101, %110, %54, %283, %278, %273, %268, %263, %258, %251, %238, %225, %213, %200, %181, %177, %166, %161, %156, %151
  %291 = phi i64 [ 9223372036854775807, %181 ], [ %85, %87 ], [ %202, %200 ], [ %180, %177 ], [ %167, %166 ], [ %162, %161 ], [ %157, %156 ], [ %152, %151 ], [ %284, %283 ], [ %279, %278 ], [ %274, %273 ], [ %269, %268 ], [ %264, %263 ], [ %259, %258 ], [ %254, %251 ], [ %241, %238 ], [ %228, %225 ], [ %215, %213 ], [ %56, %54 ], [ %104, %101 ], [ %85, %90 ], [ %111, %110 ], [ %133, %131 ], [ %142, %140 ]
  ret i64 %291
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_setattr(i64 noundef %0, i64 noundef %1, i64 noundef %2) local_unnamed_addr #2 {
  %4 = and i64 %0, 1
  %5 = icmp ne i64 %4, 0
  %6 = icmp eq i64 %0, 0
  %7 = or i1 %6, %5
  br i1 %7, label %12, label %8

8:                                                ; preds = %3
  %9 = inttoptr i64 %0 to ptr
  %10 = load i64, ptr %9, align 8, !tbaa !23
  switch i64 %10, label %12 [
    i64 12, label %16
    i64 11, label %11
  ]

11:                                               ; preds = %8
  br label %16

12:                                               ; preds = %8, %3
  %13 = tail call fastcc ptr @tname(i64 noundef %0)
  %14 = inttoptr i64 %1 to ptr
  %15 = getelementptr inbounds nuw i8, ptr %14, i64 16
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.54, ptr noundef nonnull @.str.55, ptr noundef nonnull %13, ptr noundef nonnull %15) #36
  unreachable

16:                                               ; preds = %8, %11
  %17 = phi i64 [ 24, %11 ], [ 16, %8 ]
  %18 = getelementptr inbounds nuw i8, ptr %9, i64 %17
  %19 = load i64, ptr %18, align 8, !tbaa !11
  %20 = inttoptr i64 %19 to ptr
  tail call fastcc void @dict_set(ptr noundef %20, i64 noundef %1, i64 noundef %2)
  %21 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  ret i64 %21
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_format(i64 noundef %0, i64 noundef %1) local_unnamed_addr #2 {
  %3 = alloca %struct.SB, align 8
  %4 = alloca [512 x i8], align 1
  %5 = alloca [80 x i8], align 1
  %6 = alloca %struct.SB, align 8
  %7 = alloca [16 x i8], align 1
  %8 = inttoptr i64 %1 to ptr
  %9 = getelementptr inbounds nuw i8, ptr %8, i64 16
  %10 = getelementptr inbounds nuw i8, ptr %8, i64 8
  %11 = load i64, ptr %10, align 8, !tbaa !18
  %12 = icmp sgt i64 %11, 1
  %13 = getelementptr inbounds nuw i8, ptr %4, i64 1
  %14 = getelementptr inbounds nuw i8, ptr %4, i64 1
  br i1 %12, label %15, label %23

15:                                               ; preds = %2
  %16 = getelementptr inbounds nuw i8, ptr %8, i64 17
  %17 = load i8, ptr %16, align 1, !tbaa !10
  %18 = sext i8 %17 to i32
  %19 = tail call ptr @memchr(ptr nonnull dereferenceable(1) @.str.56, i32 %18, i64 5)
  %20 = icmp eq ptr %19, null
  br i1 %20, label %25, label %21

21:                                               ; preds = %15
  %22 = load i8, ptr %9, align 1, !tbaa !10
  br label %32

23:                                               ; preds = %2
  %24 = icmp eq i64 %11, 1
  br i1 %24, label %25, label %32

25:                                               ; preds = %15, %23
  %26 = load i8, ptr %9, align 1, !tbaa !10
  %27 = sext i8 %26 to i32
  %28 = tail call ptr @memchr(ptr nonnull dereferenceable(1) @.str.56, i32 %27, i64 5)
  %29 = icmp ne ptr %28, null
  %30 = select i1 %29, i8 %26, i8 0
  %31 = zext i1 %29 to i64
  br label %32

32:                                               ; preds = %25, %23, %21
  %33 = phi i8 [ %17, %21 ], [ 0, %23 ], [ %30, %25 ]
  %34 = phi i8 [ %22, %21 ], [ 32, %23 ], [ 32, %25 ]
  %35 = phi i64 [ 2, %21 ], [ 0, %23 ], [ %31, %25 ]
  %36 = icmp slt i64 %35, %11
  br i1 %36, label %37, label %49

37:                                               ; preds = %32
  %38 = getelementptr inbounds nuw i8, ptr %9, i64 %35
  %39 = load i8, ptr %38, align 1, !tbaa !10
  %40 = zext nneg i8 %39 to i64
  %41 = icmp ugt i8 %39, 63
  %42 = shl nuw i64 1, %40
  %43 = and i64 %42, 43984760078337
  %44 = icmp eq i64 %43, 0
  %45 = select i1 %41, i1 true, i1 %44
  br i1 %45, label %49, label %46

46:                                               ; preds = %37
  %47 = add nuw nsw i64 %35, 1
  %48 = zext nneg i8 %39 to i32
  br label %49

49:                                               ; preds = %46, %37, %32
  %50 = phi i32 [ %48, %46 ], [ 45, %37 ], [ 45, %32 ]
  %51 = phi i64 [ %47, %46 ], [ %35, %37 ], [ %35, %32 ]
  %52 = icmp slt i64 %51, %11
  br i1 %52, label %53, label %59

53:                                               ; preds = %49
  %54 = getelementptr inbounds nuw i8, ptr %9, i64 %51
  %55 = load i8, ptr %54, align 1, !tbaa !10
  %56 = icmp eq i8 %55, 35
  %57 = zext i1 %56 to i64
  %58 = add nuw nsw i64 %51, %57
  br label %59

59:                                               ; preds = %53, %49
  %60 = phi i64 [ %51, %49 ], [ %58, %53 ]
  %61 = icmp slt i64 %60, %11
  br i1 %61, label %62, label %69

62:                                               ; preds = %59
  %63 = getelementptr inbounds nuw i8, ptr %9, i64 %60
  %64 = load i8, ptr %63, align 1, !tbaa !10
  %65 = icmp ne i8 %64, 48
  %66 = xor i1 %65, true
  %67 = zext i1 %66 to i64
  %68 = add nuw nsw i64 %60, %67
  br label %69

69:                                               ; preds = %62, %59
  %70 = phi i1 [ true, %59 ], [ %65, %62 ]
  %71 = phi i64 [ %60, %59 ], [ %68, %62 ]
  %72 = icmp slt i64 %71, %11
  br i1 %72, label %73, label %92

73:                                               ; preds = %69
  %74 = getelementptr inbounds nuw i8, ptr %9, i64 %71
  %75 = load i8, ptr %74, align 1, !tbaa !10
  %76 = add i8 %75, -48
  %77 = icmp ult i8 %76, 10
  br i1 %77, label %78, label %92

78:                                               ; preds = %73, %85
  %79 = phi i64 [ %87, %85 ], [ %71, %73 ]
  %80 = phi i32 [ %90, %85 ], [ 0, %73 ]
  %81 = getelementptr inbounds i8, ptr %9, i64 %79
  %82 = load i8, ptr %81, align 1, !tbaa !10
  %83 = add i8 %82, -48
  %84 = icmp ult i8 %83, 10
  br i1 %84, label %85, label %92

85:                                               ; preds = %78
  %86 = mul nsw i32 %80, 10
  %87 = add nuw i64 %79, 1
  %88 = zext nneg i8 %82 to i32
  %89 = add i32 %86, -48
  %90 = add i32 %89, %88
  %91 = icmp eq i64 %87, %11
  br i1 %91, label %133, label %78, !llvm.loop !116

92:                                               ; preds = %78, %73, %69
  %93 = phi i32 [ -1, %73 ], [ -1, %69 ], [ %80, %78 ]
  %94 = phi i64 [ %71, %73 ], [ %71, %69 ], [ %79, %78 ]
  %95 = icmp slt i64 %94, %11
  br i1 %95, label %96, label %102

96:                                               ; preds = %92
  %97 = getelementptr inbounds i8, ptr %9, i64 %94
  %98 = load i8, ptr %97, align 1, !tbaa !10
  %99 = icmp eq i8 %98, 44
  %100 = zext i1 %99 to i64
  %101 = add nsw i64 %94, %100
  br label %102

102:                                              ; preds = %96, %92
  %103 = phi i64 [ %94, %92 ], [ %101, %96 ]
  %104 = icmp slt i64 %103, %11
  br i1 %104, label %105, label %126

105:                                              ; preds = %102
  %106 = getelementptr inbounds i8, ptr %9, i64 %103
  %107 = load i8, ptr %106, align 1, !tbaa !10
  %108 = icmp eq i8 %107, 46
  br i1 %108, label %109, label %126

109:                                              ; preds = %105
  %110 = add nsw i64 %103, 1
  %111 = icmp slt i64 %110, %11
  br i1 %111, label %112, label %126

112:                                              ; preds = %109, %119
  %113 = phi i64 [ %124, %119 ], [ %110, %109 ]
  %114 = phi i32 [ %123, %119 ], [ 0, %109 ]
  %115 = getelementptr inbounds i8, ptr %9, i64 %113
  %116 = load i8, ptr %115, align 1, !tbaa !10
  %117 = add i8 %116, -48
  %118 = icmp ult i8 %117, 10
  br i1 %118, label %119, label %126

119:                                              ; preds = %112
  %120 = mul nsw i32 %114, 10
  %121 = zext nneg i8 %116 to i32
  %122 = add i32 %120, -48
  %123 = add i32 %122, %121
  %124 = add i64 %113, 1
  %125 = icmp eq i64 %124, %11
  br i1 %125, label %133, label %112, !llvm.loop !117

126:                                              ; preds = %112, %109, %105, %102
  %127 = phi i32 [ -1, %105 ], [ -1, %102 ], [ 0, %109 ], [ %114, %112 ]
  %128 = phi i64 [ %103, %105 ], [ %103, %102 ], [ %110, %109 ], [ %113, %112 ]
  %129 = icmp slt i64 %128, %11
  br i1 %129, label %130, label %133

130:                                              ; preds = %126
  %131 = getelementptr inbounds i8, ptr %9, i64 %128
  %132 = load i8, ptr %131, align 1, !tbaa !10
  br label %133

133:                                              ; preds = %85, %119, %130, %126
  %134 = phi i32 [ %127, %130 ], [ %127, %126 ], [ %123, %119 ], [ -1, %85 ]
  %135 = phi i32 [ %93, %130 ], [ %93, %126 ], [ %93, %119 ], [ %90, %85 ]
  %136 = phi i8 [ %132, %130 ], [ 0, %126 ], [ 0, %119 ], [ 0, %85 ]
  call void @llvm.lifetime.start.p0(ptr nonnull %3) #35
  %137 = getelementptr inbounds nuw i8, ptr %3, i64 16
  %138 = getelementptr inbounds nuw i8, ptr %3, i64 8
  store <2 x i64> <i64 0, i64 64>, ptr %138, align 8, !tbaa !11
  %139 = tail call dereferenceable_or_null(64) ptr @calloc(i64 noundef 1, i64 noundef 64) #33
  %140 = icmp eq ptr %139, null
  br i1 %140, label %141, label %144

141:                                              ; preds = %133
  %142 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %143 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %142)
  tail call void @exit(i32 noundef 1) #34
  unreachable

144:                                              ; preds = %133
  store ptr %139, ptr %3, align 8, !tbaa !61
  call void @llvm.lifetime.start.p0(ptr nonnull %4) #35
  %145 = icmp eq i8 %136, 0
  br i1 %145, label %146, label %159

146:                                              ; preds = %144
  %147 = and i64 %0, 1
  %148 = icmp eq i64 %147, 0
  br i1 %148, label %149, label %161

149:                                              ; preds = %146
  %150 = icmp eq i64 %0, 0
  br i1 %150, label %156, label %151

151:                                              ; preds = %149
  %152 = inttoptr i64 %0 to ptr
  %153 = load i64, ptr %152, align 8, !tbaa !23
  %154 = freeze i64 %153
  switch i64 %154, label %156 [
    i64 3, label %155
    i64 2, label %161
  ]

155:                                              ; preds = %151
  br label %156

156:                                              ; preds = %151, %155, %149
  %157 = phi i8 [ 115, %151 ], [ 103, %155 ], [ 115, %149 ]
  %158 = zext nneg i8 %157 to i32
  br label %256

159:                                              ; preds = %144
  %160 = sext i8 %136 to i32
  switch i8 %136, label %256 [
    i8 120, label %161
    i8 111, label %161
    i8 100, label %161
    i8 99, label %161
    i8 98, label %161
    i8 88, label %161
  ]

161:                                              ; preds = %151, %146, %159, %159, %159, %159, %159, %159
  %162 = phi i8 [ %136, %159 ], [ %136, %159 ], [ %136, %159 ], [ %136, %159 ], [ %136, %159 ], [ %136, %159 ], [ 100, %151 ], [ 100, %146 ]
  %163 = and i64 %0, 1
  %164 = icmp eq i64 %163, 0
  br i1 %164, label %167, label %165

165:                                              ; preds = %161
  %166 = ashr i64 %0, 1
  br label %177

167:                                              ; preds = %161
  %168 = icmp eq i64 %0, 0
  br i1 %168, label %176, label %169

169:                                              ; preds = %167
  %170 = inttoptr i64 %0 to ptr
  %171 = load i64, ptr %170, align 8, !tbaa !23
  %172 = icmp eq i64 %171, 2
  br i1 %172, label %173, label %176

173:                                              ; preds = %169
  %174 = getelementptr inbounds nuw i8, ptr %170, i64 8
  %175 = load i64, ptr %174, align 8, !tbaa !25
  br label %177

176:                                              ; preds = %169, %167
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

177:                                              ; preds = %165, %173
  %178 = phi i64 [ %166, %165 ], [ %175, %173 ]
  switch i8 %162, label %190 [
    i8 100, label %179
    i8 120, label %181
    i8 88, label %183
    i8 111, label %185
    i8 99, label %187
  ]

179:                                              ; preds = %177
  %180 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr nonnull dereferenceable(1) %4, i64 512, ptr nonnull @.str.58, i64 %178)
  br label %396

181:                                              ; preds = %177
  %182 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr nonnull dereferenceable(1) %4, i64 512, ptr nonnull @.str.59, i64 %178)
  br label %396

183:                                              ; preds = %177
  %184 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr nonnull dereferenceable(1) %4, i64 512, ptr nonnull @.str.60, i64 %178)
  br label %396

185:                                              ; preds = %177
  %186 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr nonnull dereferenceable(1) %4, i64 512, ptr nonnull @.str.61, i64 %178)
  br label %396

187:                                              ; preds = %177
  %188 = trunc i64 %178 to i8
  store i8 %188, ptr %4, align 1, !tbaa !10
  %189 = getelementptr inbounds nuw i8, ptr %4, i64 1
  store i8 0, ptr %189, align 1, !tbaa !10
  br label %398

190:                                              ; preds = %177
  call void @llvm.lifetime.start.p0(ptr nonnull %5) #35
  %191 = icmp slt i64 %178, 0
  %192 = icmp eq i64 %178, 0
  br i1 %192, label %195, label %193

193:                                              ; preds = %190
  %194 = tail call i64 @llvm.abs.i64(i64 %178, i1 true)
  br label %196

195:                                              ; preds = %190
  store i8 48, ptr %5, align 1, !tbaa !10
  br label %208

196:                                              ; preds = %193, %196
  %197 = phi i64 [ %202, %196 ], [ 0, %193 ]
  %198 = phi i64 [ %204, %196 ], [ %194, %193 ]
  %199 = trunc i64 %198 to i8
  %200 = and i8 %199, 1
  %201 = or disjoint i8 %200, 48
  %202 = add nuw nsw i64 %197, 1
  %203 = getelementptr inbounds nuw i8, ptr %5, i64 %197
  store i8 %201, ptr %203, align 1, !tbaa !10
  %204 = lshr i64 %198, 1
  %205 = icmp eq i64 %204, 0
  br i1 %205, label %206, label %196, !llvm.loop !118

206:                                              ; preds = %196
  br i1 %191, label %207, label %208

207:                                              ; preds = %206
  store i8 45, ptr %4, align 1, !tbaa !10
  br label %208

208:                                              ; preds = %206, %207, %195
  %209 = phi i64 [ %202, %207 ], [ %202, %206 ], [ 1, %195 ]
  %210 = phi ptr [ %13, %207 ], [ %4, %206 ], [ %4, %195 ]
  %211 = phi ptr [ %14, %207 ], [ %4, %206 ], [ %4, %195 ]
  %212 = phi i64 [ 1, %207 ], [ 0, %206 ], [ 0, %195 ]
  %213 = and i64 %209, 4294967295
  %214 = icmp ult i64 %209, 32
  br i1 %214, label %240, label %215

215:                                              ; preds = %208
  %216 = and i64 %209, -32
  %217 = sub i64 %213, %216
  %218 = or disjoint i64 %212, %216
  %219 = getelementptr i8, ptr %5, i64 %213
  %220 = getelementptr i8, ptr %219, i64 -16
  %221 = getelementptr i8, ptr %219, i64 -32
  %222 = load <16 x i8>, ptr %220, align 1, !tbaa !10
  %223 = load <16 x i8>, ptr %221, align 1, !tbaa !10
  %224 = shufflevector <16 x i8> %222, <16 x i8> poison, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %225 = shufflevector <16 x i8> %223, <16 x i8> poison, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %226 = getelementptr inbounds nuw i8, ptr %210, i64 16
  store <16 x i8> %224, ptr %210, align 1, !tbaa !10
  store <16 x i8> %225, ptr %226, align 1, !tbaa !10
  %227 = icmp eq i64 %216, 32
  br i1 %227, label %238, label %228, !llvm.loop !119

228:                                              ; preds = %215
  %229 = getelementptr i8, ptr %5, i64 %213
  %230 = getelementptr i8, ptr %229, i64 -48
  %231 = getelementptr i8, ptr %229, i64 -64
  %232 = load <16 x i8>, ptr %230, align 1, !tbaa !10
  %233 = load <16 x i8>, ptr %231, align 1, !tbaa !10
  %234 = shufflevector <16 x i8> %232, <16 x i8> poison, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %235 = shufflevector <16 x i8> %233, <16 x i8> poison, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %236 = getelementptr inbounds nuw i8, ptr %211, i64 32
  %237 = getelementptr inbounds nuw i8, ptr %211, i64 48
  store <16 x i8> %234, ptr %236, align 1, !tbaa !10
  store <16 x i8> %235, ptr %237, align 1, !tbaa !10
  br label %238

238:                                              ; preds = %228, %215
  %239 = icmp eq i64 %209, %216
  br i1 %239, label %252, label %240

240:                                              ; preds = %208, %238
  %241 = phi i64 [ %213, %208 ], [ %217, %238 ]
  %242 = phi i64 [ %212, %208 ], [ %218, %238 ]
  br label %243

243:                                              ; preds = %240, %243
  %244 = phi i64 [ %246, %243 ], [ %241, %240 ]
  %245 = phi i64 [ %249, %243 ], [ %242, %240 ]
  %246 = add nsw i64 %244, -1
  %247 = getelementptr inbounds i8, ptr %5, i64 %246
  %248 = load i8, ptr %247, align 1, !tbaa !10
  %249 = add nuw nsw i64 %245, 1
  %250 = getelementptr inbounds nuw i8, ptr %4, i64 %245
  store i8 %248, ptr %250, align 1, !tbaa !10
  %251 = icmp eq i64 %246, 0
  br i1 %251, label %252, label %243, !llvm.loop !120

252:                                              ; preds = %243, %238
  %253 = phi i64 [ %218, %238 ], [ %249, %243 ]
  %254 = and i64 %253, 4294967295
  %255 = getelementptr inbounds nuw i8, ptr %4, i64 %254
  store i8 0, ptr %255, align 1, !tbaa !10
  call void @llvm.lifetime.end.p0(ptr nonnull %5) #35
  br label %396

256:                                              ; preds = %156, %159
  %257 = phi i32 [ %158, %156 ], [ %160, %159 ]
  %258 = phi i8 [ %157, %156 ], [ %136, %159 ]
  %259 = tail call ptr @memchr(ptr nonnull dereferenceable(1) @.str.62, i32 %257, i64 8)
  %260 = icmp eq ptr %259, null
  br i1 %260, label %304, label %261

261:                                              ; preds = %256
  %262 = and i64 %0, 1
  %263 = icmp ne i64 %262, 0
  br i1 %263, label %264, label %267

264:                                              ; preds = %261
  %265 = ashr i64 %0, 1
  %266 = sitofp i64 %265 to double
  br label %280

267:                                              ; preds = %261
  %268 = icmp eq i64 %0, 0
  br i1 %268, label %279, label %269

269:                                              ; preds = %267
  %270 = inttoptr i64 %0 to ptr
  %271 = load i64, ptr %270, align 8, !tbaa !23
  switch i64 %271, label %279 [
    i64 2, label %272
    i64 3, label %276
  ]

272:                                              ; preds = %269
  %273 = getelementptr inbounds nuw i8, ptr %270, i64 8
  %274 = load i64, ptr %273, align 8, !tbaa !25
  %275 = sitofp i64 %274 to double
  br label %280

276:                                              ; preds = %269
  %277 = getelementptr inbounds nuw i8, ptr %270, i64 8
  %278 = load double, ptr %277, align 8, !tbaa !22
  br label %280

279:                                              ; preds = %269, %267
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.108) #36
  unreachable

280:                                              ; preds = %264, %272, %276
  %281 = phi double [ %266, %264 ], [ %275, %272 ], [ %278, %276 ]
  %282 = icmp eq i8 %258, 37
  br i1 %282, label %283, label %288

283:                                              ; preds = %280
  %284 = icmp sgt i32 %134, -1
  %285 = select i1 %284, i32 %134, i32 6
  %286 = fmul double %281, 1.000000e+02
  %287 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr nonnull dereferenceable(1) %4, i64 512, ptr nonnull @.str.63, i32 %285, double %286)
  br label %396

288:                                              ; preds = %280
  %289 = icmp ne i8 %258, 103
  %290 = icmp sgt i32 %134, -1
  %291 = select i1 %289, i1 true, i1 %290
  %292 = or i1 %263, %291
  br i1 %292, label %300, label %293

293:                                              ; preds = %288
  %294 = inttoptr i64 %0 to ptr
  %295 = load i64, ptr %294, align 8, !tbaa !23
  %296 = icmp eq i64 %295, 3
  br i1 %296, label %297, label %300

297:                                              ; preds = %293
  call void @llvm.lifetime.start.p0(ptr nonnull %6) #35
  call fastcc void @sb_init(ptr noundef %6)
  call fastcc void @fmt_float(ptr noundef %6, double noundef %281)
  %298 = load ptr, ptr %6, align 8, !tbaa !61
  %299 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr nonnull dereferenceable(1) %4, i64 512, ptr nonnull @.str.42, ptr %298)
  call void @llvm.lifetime.end.p0(ptr nonnull %6) #35
  br label %396

300:                                              ; preds = %288, %293
  call void @llvm.lifetime.start.p0(ptr nonnull %7) #35
  %301 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr nonnull dereferenceable(1) %7, i64 16, ptr nonnull @.str.64, i32 %257)
  %302 = select i1 %290, i32 %134, i32 6
  %303 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr nonnull dereferenceable(1) %4, i64 512, ptr nonnull %7, i32 %302, double %281)
  call void @llvm.lifetime.end.p0(ptr nonnull %7) #35
  br label %396

304:                                              ; preds = %256
  %305 = tail call i64 @rt_str(i64 noundef %0)
  %306 = inttoptr i64 %305 to ptr
  %307 = getelementptr inbounds nuw i8, ptr %306, i64 8
  %308 = load i64, ptr %307, align 8, !tbaa !18
  %309 = zext nneg i32 %134 to i64
  %310 = tail call i64 @llvm.smin.i64(i64 %308, i64 %309)
  %311 = icmp slt i32 %134, 0
  %312 = select i1 %311, i64 %308, i64 %310
  %313 = getelementptr inbounds nuw i8, ptr %306, i64 16
  %314 = icmp ne i8 %33, 62
  %315 = icmp ne i8 %33, 94
  %316 = and i1 %314, %315
  %317 = zext i1 %316 to i32
  call fastcc void @pad_into(ptr noundef %3, ptr noundef nonnull %313, i64 noundef %312, i32 noundef %135, i32 noundef %317, i8 noundef signext %34)
  %318 = icmp eq i8 %33, 94
  br i1 %318, label %319, label %734

319:                                              ; preds = %304
  store i64 0, ptr %138, align 8, !tbaa !63
  %320 = sext i32 %135 to i64
  %321 = icmp slt i64 %312, %320
  %322 = sub nsw i64 %320, %312
  %323 = select i1 %321, i64 %322, i64 0
  %324 = sdiv i64 %323, 2
  %325 = icmp sgt i64 %323, 1
  br i1 %325, label %348, label %328

326:                                              ; preds = %363
  %327 = load i64, ptr %138, align 8, !tbaa !63
  br label %328

328:                                              ; preds = %326, %319
  %329 = phi i64 [ %327, %326 ], [ 0, %319 ]
  %330 = add nsw i64 %329, %312
  %331 = load i64, ptr %137, align 8, !tbaa !82
  %332 = icmp slt i64 %330, %331
  br i1 %332, label %333, label %335

333:                                              ; preds = %328
  %334 = load ptr, ptr %3, align 8, !tbaa !61
  br label %342

335:                                              ; preds = %328, %335
  %336 = phi i64 [ %337, %335 ], [ %331, %328 ]
  %337 = shl nsw i64 %336, 1
  %338 = icmp sgt i64 %337, %330
  br i1 %338, label %339, label %335, !llvm.loop !83

339:                                              ; preds = %335
  %340 = load ptr, ptr %3, align 8, !tbaa !61
  %341 = tail call ptr @realloc(ptr noundef %340, i64 noundef %337) #38
  store ptr %341, ptr %3, align 8, !tbaa !61
  store i64 %337, ptr %137, align 8, !tbaa !82
  br label %342

342:                                              ; preds = %333, %339
  %343 = phi ptr [ %334, %333 ], [ %341, %339 ]
  %344 = getelementptr inbounds i8, ptr %343, i64 %329
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %344, ptr noundef nonnull readonly align 1 %313, i64 noundef %312, i1 noundef false) #35
  store i64 %330, ptr %138, align 8, !tbaa !63
  %345 = getelementptr inbounds i8, ptr %343, i64 %330
  store i8 0, ptr %345, align 1, !tbaa !10
  %346 = sub nsw i64 %323, %324
  %347 = icmp sgt i64 %346, 0
  br i1 %347, label %372, label %734

348:                                              ; preds = %319, %363
  %349 = phi i64 [ %370, %363 ], [ 0, %319 ]
  %350 = load i64, ptr %138, align 8, !tbaa !63
  %351 = add nsw i64 %350, 1
  %352 = load i64, ptr %137, align 8, !tbaa !82
  %353 = icmp slt i64 %351, %352
  br i1 %353, label %354, label %356

354:                                              ; preds = %348
  %355 = load ptr, ptr %3, align 8, !tbaa !61
  br label %363

356:                                              ; preds = %348, %356
  %357 = phi i64 [ %358, %356 ], [ %352, %348 ]
  %358 = shl nsw i64 %357, 1
  %359 = icmp sgt i64 %358, %351
  br i1 %359, label %360, label %356, !llvm.loop !83

360:                                              ; preds = %356
  %361 = load ptr, ptr %3, align 8, !tbaa !61
  %362 = tail call ptr @realloc(ptr noundef %361, i64 noundef %358) #38
  store ptr %362, ptr %3, align 8, !tbaa !61
  store i64 %358, ptr %137, align 8, !tbaa !82
  br label %363

363:                                              ; preds = %354, %360
  %364 = phi ptr [ %355, %354 ], [ %362, %360 ]
  %365 = getelementptr inbounds i8, ptr %364, i64 %350
  store i8 %34, ptr %365, align 1
  %366 = load i64, ptr %138, align 8, !tbaa !63
  %367 = add nsw i64 %366, 1
  store i64 %367, ptr %138, align 8, !tbaa !63
  %368 = load ptr, ptr %3, align 8, !tbaa !61
  %369 = getelementptr inbounds i8, ptr %368, i64 %367
  store i8 0, ptr %369, align 1, !tbaa !10
  %370 = add nuw nsw i64 %349, 1
  %371 = icmp eq i64 %370, %324
  br i1 %371, label %326, label %348, !llvm.loop !121

372:                                              ; preds = %342, %387
  %373 = phi i64 [ %394, %387 ], [ 0, %342 ]
  %374 = load i64, ptr %138, align 8, !tbaa !63
  %375 = add nsw i64 %374, 1
  %376 = load i64, ptr %137, align 8, !tbaa !82
  %377 = icmp slt i64 %375, %376
  br i1 %377, label %378, label %380

378:                                              ; preds = %372
  %379 = load ptr, ptr %3, align 8, !tbaa !61
  br label %387

380:                                              ; preds = %372, %380
  %381 = phi i64 [ %382, %380 ], [ %376, %372 ]
  %382 = shl nsw i64 %381, 1
  %383 = icmp sgt i64 %382, %375
  br i1 %383, label %384, label %380, !llvm.loop !83

384:                                              ; preds = %380
  %385 = load ptr, ptr %3, align 8, !tbaa !61
  %386 = tail call ptr @realloc(ptr noundef %385, i64 noundef %382) #38
  store ptr %386, ptr %3, align 8, !tbaa !61
  store i64 %382, ptr %137, align 8, !tbaa !82
  br label %387

387:                                              ; preds = %378, %384
  %388 = phi ptr [ %379, %378 ], [ %386, %384 ]
  %389 = getelementptr inbounds i8, ptr %388, i64 %374
  store i8 %34, ptr %389, align 1
  %390 = load i64, ptr %138, align 8, !tbaa !63
  %391 = add nsw i64 %390, 1
  store i64 %391, ptr %138, align 8, !tbaa !63
  %392 = load ptr, ptr %3, align 8, !tbaa !61
  %393 = getelementptr inbounds i8, ptr %392, i64 %391
  store i8 0, ptr %393, align 1, !tbaa !10
  %394 = add nuw nsw i64 %373, 1
  %395 = icmp slt i64 %394, %346
  br i1 %395, label %372, label %734, !llvm.loop !122

396:                                              ; preds = %181, %185, %252, %183, %179, %297, %300, %283
  %397 = load i8, ptr %4, align 1, !tbaa !10
  br label %398

398:                                              ; preds = %396, %187
  %399 = phi i8 [ %397, %396 ], [ %188, %187 ]
  %400 = phi i8 [ 62, %396 ], [ 60, %187 ]
  %401 = icmp eq i8 %399, 45
  br i1 %401, label %402, label %404

402:                                              ; preds = %398
  %403 = getelementptr inbounds nuw i8, ptr %4, i64 1
  br label %407

404:                                              ; preds = %398
  switch i32 %50, label %406 [
    i32 43, label %407
    i32 32, label %405
  ]

405:                                              ; preds = %404
  br label %407

406:                                              ; preds = %404
  br label %407

407:                                              ; preds = %404, %406, %405, %402
  %408 = phi ptr [ %403, %402 ], [ %4, %404 ], [ %4, %405 ], [ %4, %406 ]
  %409 = phi i64 [ 1, %402 ], [ 1, %404 ], [ 1, %405 ], [ 0, %406 ]
  %410 = phi i1 [ false, %402 ], [ false, %404 ], [ false, %405 ], [ true, %406 ]
  %411 = phi i8 [ 45, %402 ], [ 43, %404 ], [ 32, %405 ], [ 0, %406 ]
  %412 = call i64 @strlen(ptr noundef nonnull dereferenceable(1) %408) #35
  %413 = add i64 %412, %409
  %414 = icmp ne i8 %33, 0
  %415 = or i1 %414, %70
  %416 = select i1 %415, i8 %33, i8 61
  %417 = select i1 %415, i8 %34, i8 48
  %418 = icmp eq i8 %416, 0
  %419 = select i1 %418, i8 %400, i8 %416
  %420 = sext i32 %135 to i64
  %421 = icmp slt i64 %413, %420
  %422 = sub nsw i64 %420, %413
  %423 = select i1 %421, i64 %422, i64 0
  switch i8 %419, label %426 [
    i8 62, label %424
    i8 60, label %495
    i8 61, label %566
  ]

424:                                              ; preds = %407
  %425 = icmp sgt i64 %423, 0
  br i1 %425, label %432, label %429

426:                                              ; preds = %407
  %427 = sdiv i64 %423, 2
  %428 = icmp sgt i64 %423, 1
  br i1 %428, label %635, label %632

429:                                              ; preds = %447, %424
  %430 = load i64, ptr %138, align 8, !tbaa !63
  %431 = load i64, ptr %137, align 8, !tbaa !82
  br i1 %410, label %477, label %456

432:                                              ; preds = %424, %447
  %433 = phi i64 [ %454, %447 ], [ 0, %424 ]
  %434 = load i64, ptr %138, align 8, !tbaa !63
  %435 = add nsw i64 %434, 1
  %436 = load i64, ptr %137, align 8, !tbaa !82
  %437 = icmp slt i64 %435, %436
  br i1 %437, label %438, label %440

438:                                              ; preds = %432
  %439 = load ptr, ptr %3, align 8, !tbaa !61
  br label %447

440:                                              ; preds = %432, %440
  %441 = phi i64 [ %442, %440 ], [ %436, %432 ]
  %442 = shl nsw i64 %441, 1
  %443 = icmp sgt i64 %442, %435
  br i1 %443, label %444, label %440, !llvm.loop !83

444:                                              ; preds = %440
  %445 = load ptr, ptr %3, align 8, !tbaa !61
  %446 = tail call ptr @realloc(ptr noundef %445, i64 noundef %442) #38
  store ptr %446, ptr %3, align 8, !tbaa !61
  store i64 %442, ptr %137, align 8, !tbaa !82
  br label %447

447:                                              ; preds = %438, %444
  %448 = phi ptr [ %439, %438 ], [ %446, %444 ]
  %449 = getelementptr inbounds i8, ptr %448, i64 %434
  store i8 %417, ptr %449, align 1
  %450 = load i64, ptr %138, align 8, !tbaa !63
  %451 = add nsw i64 %450, 1
  store i64 %451, ptr %138, align 8, !tbaa !63
  %452 = load ptr, ptr %3, align 8, !tbaa !61
  %453 = getelementptr inbounds i8, ptr %452, i64 %451
  store i8 0, ptr %453, align 1, !tbaa !10
  %454 = add nuw nsw i64 %433, 1
  %455 = icmp slt i64 %454, %423
  br i1 %455, label %432, label %429, !llvm.loop !123

456:                                              ; preds = %429
  %457 = add nsw i64 %430, 1
  %458 = icmp slt i64 %457, %431
  br i1 %458, label %459, label %461

459:                                              ; preds = %456
  %460 = load ptr, ptr %3, align 8, !tbaa !61
  br label %468

461:                                              ; preds = %456, %461
  %462 = phi i64 [ %463, %461 ], [ %431, %456 ]
  %463 = shl nsw i64 %462, 1
  %464 = icmp sgt i64 %463, %457
  br i1 %464, label %465, label %461, !llvm.loop !83

465:                                              ; preds = %461
  %466 = load ptr, ptr %3, align 8, !tbaa !61
  %467 = tail call ptr @realloc(ptr noundef %466, i64 noundef %463) #38
  store ptr %467, ptr %3, align 8, !tbaa !61
  store i64 %463, ptr %137, align 8, !tbaa !82
  br label %468

468:                                              ; preds = %459, %465
  %469 = phi ptr [ %460, %459 ], [ %467, %465 ]
  %470 = getelementptr inbounds i8, ptr %469, i64 %430
  store i8 %411, ptr %470, align 1
  %471 = load i64, ptr %138, align 8, !tbaa !63
  %472 = add nsw i64 %471, 1
  store i64 %472, ptr %138, align 8, !tbaa !63
  %473 = load ptr, ptr %3, align 8, !tbaa !61
  %474 = getelementptr inbounds i8, ptr %473, i64 %472
  store i8 0, ptr %474, align 1, !tbaa !10
  %475 = load i64, ptr %138, align 8, !tbaa !63
  %476 = load i64, ptr %137, align 8, !tbaa !82
  br label %477

477:                                              ; preds = %468, %429
  %478 = phi i64 [ %476, %468 ], [ %431, %429 ]
  %479 = phi i64 [ %475, %468 ], [ %430, %429 ]
  %480 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %408) #35
  %481 = add nsw i64 %479, %480
  %482 = icmp slt i64 %481, %478
  br i1 %482, label %483, label %485

483:                                              ; preds = %477
  %484 = load ptr, ptr %3, align 8, !tbaa !61
  br label %492

485:                                              ; preds = %477, %485
  %486 = phi i64 [ %487, %485 ], [ %478, %477 ]
  %487 = shl nsw i64 %486, 1
  %488 = icmp sgt i64 %487, %481
  br i1 %488, label %489, label %485, !llvm.loop !83

489:                                              ; preds = %485
  %490 = load ptr, ptr %3, align 8, !tbaa !61
  %491 = tail call ptr @realloc(ptr noundef %490, i64 noundef %487) #38
  store ptr %491, ptr %3, align 8, !tbaa !61
  br label %492

492:                                              ; preds = %483, %489
  %493 = phi ptr [ %484, %483 ], [ %491, %489 ]
  %494 = getelementptr inbounds i8, ptr %493, i64 %479
  call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %494, ptr noundef nonnull readonly align 1 %408, i64 noundef %480, i1 noundef false) #35
  br label %728

495:                                              ; preds = %407
  %496 = load i64, ptr %138, align 8, !tbaa !63
  %497 = load i64, ptr %137, align 8, !tbaa !82
  br i1 %410, label %519, label %498

498:                                              ; preds = %495
  %499 = add nsw i64 %496, 1
  %500 = icmp slt i64 %499, %497
  br i1 %500, label %501, label %503

501:                                              ; preds = %498
  %502 = load ptr, ptr %3, align 8, !tbaa !61
  br label %510

503:                                              ; preds = %498, %503
  %504 = phi i64 [ %505, %503 ], [ %497, %498 ]
  %505 = shl nsw i64 %504, 1
  %506 = icmp sgt i64 %505, %499
  br i1 %506, label %507, label %503, !llvm.loop !83

507:                                              ; preds = %503
  %508 = load ptr, ptr %3, align 8, !tbaa !61
  %509 = tail call ptr @realloc(ptr noundef %508, i64 noundef %505) #38
  store ptr %509, ptr %3, align 8, !tbaa !61
  store i64 %505, ptr %137, align 8, !tbaa !82
  br label %510

510:                                              ; preds = %501, %507
  %511 = phi ptr [ %502, %501 ], [ %509, %507 ]
  %512 = getelementptr inbounds i8, ptr %511, i64 %496
  store i8 %411, ptr %512, align 1
  %513 = load i64, ptr %138, align 8, !tbaa !63
  %514 = add nsw i64 %513, 1
  store i64 %514, ptr %138, align 8, !tbaa !63
  %515 = load ptr, ptr %3, align 8, !tbaa !61
  %516 = getelementptr inbounds i8, ptr %515, i64 %514
  store i8 0, ptr %516, align 1, !tbaa !10
  %517 = load i64, ptr %138, align 8, !tbaa !63
  %518 = load i64, ptr %137, align 8, !tbaa !82
  br label %519

519:                                              ; preds = %510, %495
  %520 = phi i64 [ %518, %510 ], [ %497, %495 ]
  %521 = phi i64 [ %517, %510 ], [ %496, %495 ]
  %522 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %408) #35
  %523 = add nsw i64 %521, %522
  %524 = icmp slt i64 %523, %520
  br i1 %524, label %525, label %527

525:                                              ; preds = %519
  %526 = load ptr, ptr %3, align 8, !tbaa !61
  br label %534

527:                                              ; preds = %519, %527
  %528 = phi i64 [ %529, %527 ], [ %520, %519 ]
  %529 = shl nsw i64 %528, 1
  %530 = icmp sgt i64 %529, %523
  br i1 %530, label %531, label %527, !llvm.loop !83

531:                                              ; preds = %527
  %532 = load ptr, ptr %3, align 8, !tbaa !61
  %533 = tail call ptr @realloc(ptr noundef %532, i64 noundef %529) #38
  store ptr %533, ptr %3, align 8, !tbaa !61
  store i64 %529, ptr %137, align 8, !tbaa !82
  br label %534

534:                                              ; preds = %525, %531
  %535 = phi ptr [ %526, %525 ], [ %533, %531 ]
  %536 = getelementptr inbounds i8, ptr %535, i64 %521
  call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %536, ptr noundef nonnull readonly align 1 %408, i64 noundef %522, i1 noundef false) #35
  %537 = load i64, ptr %138, align 8, !tbaa !63
  %538 = add nsw i64 %537, %522
  store i64 %538, ptr %138, align 8, !tbaa !63
  %539 = load ptr, ptr %3, align 8, !tbaa !61
  %540 = getelementptr inbounds i8, ptr %539, i64 %538
  store i8 0, ptr %540, align 1, !tbaa !10
  %541 = icmp sgt i64 %423, 0
  br i1 %541, label %542, label %734

542:                                              ; preds = %534, %557
  %543 = phi i64 [ %564, %557 ], [ 0, %534 ]
  %544 = load i64, ptr %138, align 8, !tbaa !63
  %545 = add nsw i64 %544, 1
  %546 = load i64, ptr %137, align 8, !tbaa !82
  %547 = icmp slt i64 %545, %546
  br i1 %547, label %548, label %550

548:                                              ; preds = %542
  %549 = load ptr, ptr %3, align 8, !tbaa !61
  br label %557

550:                                              ; preds = %542, %550
  %551 = phi i64 [ %552, %550 ], [ %546, %542 ]
  %552 = shl nsw i64 %551, 1
  %553 = icmp sgt i64 %552, %545
  br i1 %553, label %554, label %550, !llvm.loop !83

554:                                              ; preds = %550
  %555 = load ptr, ptr %3, align 8, !tbaa !61
  %556 = tail call ptr @realloc(ptr noundef %555, i64 noundef %552) #38
  store ptr %556, ptr %3, align 8, !tbaa !61
  store i64 %552, ptr %137, align 8, !tbaa !82
  br label %557

557:                                              ; preds = %548, %554
  %558 = phi ptr [ %549, %548 ], [ %556, %554 ]
  %559 = getelementptr inbounds i8, ptr %558, i64 %544
  store i8 %417, ptr %559, align 1
  %560 = load i64, ptr %138, align 8, !tbaa !63
  %561 = add nsw i64 %560, 1
  store i64 %561, ptr %138, align 8, !tbaa !63
  %562 = load ptr, ptr %3, align 8, !tbaa !61
  %563 = getelementptr inbounds i8, ptr %562, i64 %561
  store i8 0, ptr %563, align 1, !tbaa !10
  %564 = add nuw nsw i64 %543, 1
  %565 = icmp slt i64 %564, %423
  br i1 %565, label %542, label %734, !llvm.loop !124

566:                                              ; preds = %407
  br i1 %410, label %588, label %567

567:                                              ; preds = %566
  %568 = load i64, ptr %138, align 8, !tbaa !63
  %569 = add nsw i64 %568, 1
  %570 = load i64, ptr %137, align 8, !tbaa !82
  %571 = icmp slt i64 %569, %570
  br i1 %571, label %572, label %574

572:                                              ; preds = %567
  %573 = load ptr, ptr %3, align 8, !tbaa !61
  br label %581

574:                                              ; preds = %567, %574
  %575 = phi i64 [ %576, %574 ], [ %570, %567 ]
  %576 = shl nsw i64 %575, 1
  %577 = icmp sgt i64 %576, %569
  br i1 %577, label %578, label %574, !llvm.loop !83

578:                                              ; preds = %574
  %579 = load ptr, ptr %3, align 8, !tbaa !61
  %580 = tail call ptr @realloc(ptr noundef %579, i64 noundef %576) #38
  store ptr %580, ptr %3, align 8, !tbaa !61
  store i64 %576, ptr %137, align 8, !tbaa !82
  br label %581

581:                                              ; preds = %572, %578
  %582 = phi ptr [ %573, %572 ], [ %580, %578 ]
  %583 = getelementptr inbounds i8, ptr %582, i64 %568
  store i8 %411, ptr %583, align 1
  %584 = load i64, ptr %138, align 8, !tbaa !63
  %585 = add nsw i64 %584, 1
  store i64 %585, ptr %138, align 8, !tbaa !63
  %586 = load ptr, ptr %3, align 8, !tbaa !61
  %587 = getelementptr inbounds i8, ptr %586, i64 %585
  store i8 0, ptr %587, align 1, !tbaa !10
  br label %588

588:                                              ; preds = %581, %566
  %589 = icmp sgt i64 %423, 0
  br i1 %589, label %608, label %590

590:                                              ; preds = %623, %588
  %591 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %408) #35
  %592 = load i64, ptr %138, align 8, !tbaa !63
  %593 = add nsw i64 %592, %591
  %594 = load i64, ptr %137, align 8, !tbaa !82
  %595 = icmp slt i64 %593, %594
  br i1 %595, label %596, label %598

596:                                              ; preds = %590
  %597 = load ptr, ptr %3, align 8, !tbaa !61
  br label %605

598:                                              ; preds = %590, %598
  %599 = phi i64 [ %600, %598 ], [ %594, %590 ]
  %600 = shl nsw i64 %599, 1
  %601 = icmp sgt i64 %600, %593
  br i1 %601, label %602, label %598, !llvm.loop !83

602:                                              ; preds = %598
  %603 = load ptr, ptr %3, align 8, !tbaa !61
  %604 = tail call ptr @realloc(ptr noundef %603, i64 noundef %600) #38
  store ptr %604, ptr %3, align 8, !tbaa !61
  br label %605

605:                                              ; preds = %596, %602
  %606 = phi ptr [ %597, %596 ], [ %604, %602 ]
  %607 = getelementptr inbounds i8, ptr %606, i64 %592
  call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %607, ptr noundef nonnull readonly align 1 %408, i64 noundef %591, i1 noundef false) #35
  br label %728

608:                                              ; preds = %588, %623
  %609 = phi i64 [ %630, %623 ], [ 0, %588 ]
  %610 = load i64, ptr %138, align 8, !tbaa !63
  %611 = add nsw i64 %610, 1
  %612 = load i64, ptr %137, align 8, !tbaa !82
  %613 = icmp slt i64 %611, %612
  br i1 %613, label %614, label %616

614:                                              ; preds = %608
  %615 = load ptr, ptr %3, align 8, !tbaa !61
  br label %623

616:                                              ; preds = %608, %616
  %617 = phi i64 [ %618, %616 ], [ %612, %608 ]
  %618 = shl nsw i64 %617, 1
  %619 = icmp sgt i64 %618, %611
  br i1 %619, label %620, label %616, !llvm.loop !83

620:                                              ; preds = %616
  %621 = load ptr, ptr %3, align 8, !tbaa !61
  %622 = tail call ptr @realloc(ptr noundef %621, i64 noundef %618) #38
  store ptr %622, ptr %3, align 8, !tbaa !61
  store i64 %618, ptr %137, align 8, !tbaa !82
  br label %623

623:                                              ; preds = %614, %620
  %624 = phi ptr [ %615, %614 ], [ %622, %620 ]
  %625 = getelementptr inbounds i8, ptr %624, i64 %610
  store i8 %417, ptr %625, align 1
  %626 = load i64, ptr %138, align 8, !tbaa !63
  %627 = add nsw i64 %626, 1
  store i64 %627, ptr %138, align 8, !tbaa !63
  %628 = load ptr, ptr %3, align 8, !tbaa !61
  %629 = getelementptr inbounds i8, ptr %628, i64 %627
  store i8 0, ptr %629, align 1, !tbaa !10
  %630 = add nuw nsw i64 %609, 1
  %631 = icmp slt i64 %630, %423
  br i1 %631, label %608, label %590, !llvm.loop !125

632:                                              ; preds = %650, %426
  %633 = load i64, ptr %138, align 8, !tbaa !63
  %634 = load i64, ptr %137, align 8, !tbaa !82
  br i1 %410, label %680, label %659

635:                                              ; preds = %426, %650
  %636 = phi i64 [ %657, %650 ], [ 0, %426 ]
  %637 = load i64, ptr %138, align 8, !tbaa !63
  %638 = add nsw i64 %637, 1
  %639 = load i64, ptr %137, align 8, !tbaa !82
  %640 = icmp slt i64 %638, %639
  br i1 %640, label %641, label %643

641:                                              ; preds = %635
  %642 = load ptr, ptr %3, align 8, !tbaa !61
  br label %650

643:                                              ; preds = %635, %643
  %644 = phi i64 [ %645, %643 ], [ %639, %635 ]
  %645 = shl nsw i64 %644, 1
  %646 = icmp sgt i64 %645, %638
  br i1 %646, label %647, label %643, !llvm.loop !83

647:                                              ; preds = %643
  %648 = load ptr, ptr %3, align 8, !tbaa !61
  %649 = tail call ptr @realloc(ptr noundef %648, i64 noundef %645) #38
  store ptr %649, ptr %3, align 8, !tbaa !61
  store i64 %645, ptr %137, align 8, !tbaa !82
  br label %650

650:                                              ; preds = %641, %647
  %651 = phi ptr [ %642, %641 ], [ %649, %647 ]
  %652 = getelementptr inbounds i8, ptr %651, i64 %637
  store i8 %417, ptr %652, align 1
  %653 = load i64, ptr %138, align 8, !tbaa !63
  %654 = add nsw i64 %653, 1
  store i64 %654, ptr %138, align 8, !tbaa !63
  %655 = load ptr, ptr %3, align 8, !tbaa !61
  %656 = getelementptr inbounds i8, ptr %655, i64 %654
  store i8 0, ptr %656, align 1, !tbaa !10
  %657 = add nuw nsw i64 %636, 1
  %658 = icmp eq i64 %657, %427
  br i1 %658, label %632, label %635, !llvm.loop !126

659:                                              ; preds = %632
  %660 = add nsw i64 %633, 1
  %661 = icmp slt i64 %660, %634
  br i1 %661, label %662, label %664

662:                                              ; preds = %659
  %663 = load ptr, ptr %3, align 8, !tbaa !61
  br label %671

664:                                              ; preds = %659, %664
  %665 = phi i64 [ %666, %664 ], [ %634, %659 ]
  %666 = shl nsw i64 %665, 1
  %667 = icmp sgt i64 %666, %660
  br i1 %667, label %668, label %664, !llvm.loop !83

668:                                              ; preds = %664
  %669 = load ptr, ptr %3, align 8, !tbaa !61
  %670 = tail call ptr @realloc(ptr noundef %669, i64 noundef %666) #38
  store ptr %670, ptr %3, align 8, !tbaa !61
  store i64 %666, ptr %137, align 8, !tbaa !82
  br label %671

671:                                              ; preds = %662, %668
  %672 = phi ptr [ %663, %662 ], [ %670, %668 ]
  %673 = getelementptr inbounds i8, ptr %672, i64 %633
  store i8 %411, ptr %673, align 1
  %674 = load i64, ptr %138, align 8, !tbaa !63
  %675 = add nsw i64 %674, 1
  store i64 %675, ptr %138, align 8, !tbaa !63
  %676 = load ptr, ptr %3, align 8, !tbaa !61
  %677 = getelementptr inbounds i8, ptr %676, i64 %675
  store i8 0, ptr %677, align 1, !tbaa !10
  %678 = load i64, ptr %138, align 8, !tbaa !63
  %679 = load i64, ptr %137, align 8, !tbaa !82
  br label %680

680:                                              ; preds = %671, %632
  %681 = phi i64 [ %679, %671 ], [ %634, %632 ]
  %682 = phi i64 [ %678, %671 ], [ %633, %632 ]
  %683 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %408) #35
  %684 = add nsw i64 %682, %683
  %685 = icmp slt i64 %684, %681
  br i1 %685, label %686, label %688

686:                                              ; preds = %680
  %687 = load ptr, ptr %3, align 8, !tbaa !61
  br label %695

688:                                              ; preds = %680, %688
  %689 = phi i64 [ %690, %688 ], [ %681, %680 ]
  %690 = shl nsw i64 %689, 1
  %691 = icmp sgt i64 %690, %684
  br i1 %691, label %692, label %688, !llvm.loop !83

692:                                              ; preds = %688
  %693 = load ptr, ptr %3, align 8, !tbaa !61
  %694 = tail call ptr @realloc(ptr noundef %693, i64 noundef %690) #38
  store ptr %694, ptr %3, align 8, !tbaa !61
  store i64 %690, ptr %137, align 8, !tbaa !82
  br label %695

695:                                              ; preds = %686, %692
  %696 = phi ptr [ %687, %686 ], [ %694, %692 ]
  %697 = getelementptr inbounds i8, ptr %696, i64 %682
  call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %697, ptr noundef nonnull readonly align 1 %408, i64 noundef %683, i1 noundef false) #35
  %698 = load i64, ptr %138, align 8, !tbaa !63
  %699 = add nsw i64 %698, %683
  store i64 %699, ptr %138, align 8, !tbaa !63
  %700 = load ptr, ptr %3, align 8, !tbaa !61
  %701 = getelementptr inbounds i8, ptr %700, i64 %699
  store i8 0, ptr %701, align 1, !tbaa !10
  %702 = sub nsw i64 %423, %427
  %703 = icmp sgt i64 %702, 0
  br i1 %703, label %704, label %734

704:                                              ; preds = %695, %719
  %705 = phi i64 [ %726, %719 ], [ 0, %695 ]
  %706 = load i64, ptr %138, align 8, !tbaa !63
  %707 = add nsw i64 %706, 1
  %708 = load i64, ptr %137, align 8, !tbaa !82
  %709 = icmp slt i64 %707, %708
  br i1 %709, label %710, label %712

710:                                              ; preds = %704
  %711 = load ptr, ptr %3, align 8, !tbaa !61
  br label %719

712:                                              ; preds = %704, %712
  %713 = phi i64 [ %714, %712 ], [ %708, %704 ]
  %714 = shl nsw i64 %713, 1
  %715 = icmp sgt i64 %714, %707
  br i1 %715, label %716, label %712, !llvm.loop !83

716:                                              ; preds = %712
  %717 = load ptr, ptr %3, align 8, !tbaa !61
  %718 = tail call ptr @realloc(ptr noundef %717, i64 noundef %714) #38
  store ptr %718, ptr %3, align 8, !tbaa !61
  store i64 %714, ptr %137, align 8, !tbaa !82
  br label %719

719:                                              ; preds = %710, %716
  %720 = phi ptr [ %711, %710 ], [ %718, %716 ]
  %721 = getelementptr inbounds i8, ptr %720, i64 %706
  store i8 %417, ptr %721, align 1
  %722 = load i64, ptr %138, align 8, !tbaa !63
  %723 = add nsw i64 %722, 1
  store i64 %723, ptr %138, align 8, !tbaa !63
  %724 = load ptr, ptr %3, align 8, !tbaa !61
  %725 = getelementptr inbounds i8, ptr %724, i64 %723
  store i8 0, ptr %725, align 1, !tbaa !10
  %726 = add nuw nsw i64 %705, 1
  %727 = icmp slt i64 %726, %702
  br i1 %727, label %704, label %734, !llvm.loop !127

728:                                              ; preds = %492, %605
  %729 = phi i64 [ %591, %605 ], [ %480, %492 ]
  %730 = load i64, ptr %138, align 8, !tbaa !63
  %731 = add nsw i64 %730, %729
  store i64 %731, ptr %138, align 8, !tbaa !63
  %732 = load ptr, ptr %3, align 8, !tbaa !61
  %733 = getelementptr inbounds i8, ptr %732, i64 %731
  store i8 0, ptr %733, align 1, !tbaa !10
  br label %734

734:                                              ; preds = %557, %719, %387, %695, %534, %728, %304, %342
  %735 = load ptr, ptr %3, align 8, !tbaa !61
  %736 = load i64, ptr %138, align 8, !tbaa !63
  %737 = tail call fastcc i64 @mkstr(ptr noundef %735, i64 noundef %736)
  call void @llvm.lifetime.end.p0(ptr nonnull %4) #35
  call void @llvm.lifetime.end.p0(ptr nonnull %3) #35
  ret i64 %737
}

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: read)
declare ptr @strchr(ptr noundef, i32 noundef) local_unnamed_addr #4

; Function Attrs: nounwind ssp uwtable(sync)
define internal fastcc void @fmt_float(ptr noundef nonnull captures(none) %0, double noundef %1) unnamed_addr #2 {
  %3 = alloca [64 x i8], align 1
  %4 = alloca [96 x i8], align 1
  %5 = fcmp ord double %1, 0.000000e+00
  br i1 %5, label %31, label %6

6:                                                ; preds = %2
  %7 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %8 = load i64, ptr %7, align 8, !tbaa !63
  %9 = add nsw i64 %8, 3
  %10 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %11 = load i64, ptr %10, align 8, !tbaa !82
  %12 = icmp slt i64 %9, %11
  br i1 %12, label %13, label %15

13:                                               ; preds = %6
  %14 = load ptr, ptr %0, align 8, !tbaa !61
  br label %23

15:                                               ; preds = %6, %15
  %16 = phi i64 [ %17, %15 ], [ %11, %6 ]
  %17 = shl nsw i64 %16, 1
  %18 = icmp sgt i64 %17, %9
  br i1 %18, label %19, label %15, !llvm.loop !83

19:                                               ; preds = %15
  %20 = load ptr, ptr %0, align 8, !tbaa !61
  %21 = tail call ptr @realloc(ptr noundef %20, i64 noundef %17) #38
  store ptr %21, ptr %0, align 8, !tbaa !61
  store i64 %17, ptr %10, align 8, !tbaa !82
  %22 = load i64, ptr %7, align 8, !tbaa !63
  br label %23

23:                                               ; preds = %13, %19
  %24 = phi i64 [ %8, %13 ], [ %22, %19 ]
  %25 = phi ptr [ %14, %13 ], [ %21, %19 ]
  %26 = getelementptr inbounds i8, ptr %25, i64 %24
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(3) %26, ptr noundef nonnull readonly align 1 dereferenceable(3) @.str.182, i64 noundef 3, i1 noundef false) #35
  %27 = load i64, ptr %7, align 8, !tbaa !63
  %28 = add nsw i64 %27, 3
  store i64 %28, ptr %7, align 8, !tbaa !63
  %29 = load ptr, ptr %0, align 8, !tbaa !61
  %30 = getelementptr inbounds i8, ptr %29, i64 %28
  store i8 0, ptr %30, align 1, !tbaa !10
  br label %171

31:                                               ; preds = %2
  %32 = tail call double @llvm.fabs.f64(double %1)
  %33 = fcmp une double %32, 0x7FF0000000000000
  br i1 %33, label %62, label %34

34:                                               ; preds = %31
  %35 = fcmp olt double %1, 0.000000e+00
  %36 = select i1 %35, ptr @.str.183, ptr @.str.184
  %37 = select i1 %35, i64 4, i64 3
  %38 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %39 = load i64, ptr %38, align 8, !tbaa !63
  %40 = add nsw i64 %39, %37
  %41 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %42 = load i64, ptr %41, align 8, !tbaa !82
  %43 = icmp slt i64 %40, %42
  br i1 %43, label %44, label %46

44:                                               ; preds = %34
  %45 = load ptr, ptr %0, align 8, !tbaa !61
  br label %54

46:                                               ; preds = %34, %46
  %47 = phi i64 [ %48, %46 ], [ %42, %34 ]
  %48 = shl nsw i64 %47, 1
  %49 = icmp sgt i64 %48, %40
  br i1 %49, label %50, label %46, !llvm.loop !83

50:                                               ; preds = %46
  %51 = load ptr, ptr %0, align 8, !tbaa !61
  %52 = tail call ptr @realloc(ptr noundef %51, i64 noundef %48) #38
  store ptr %52, ptr %0, align 8, !tbaa !61
  store i64 %48, ptr %41, align 8, !tbaa !82
  %53 = load i64, ptr %38, align 8, !tbaa !63
  br label %54

54:                                               ; preds = %44, %50
  %55 = phi i64 [ %39, %44 ], [ %53, %50 ]
  %56 = phi ptr [ %45, %44 ], [ %52, %50 ]
  %57 = getelementptr inbounds i8, ptr %56, i64 %55
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(3) %57, ptr noundef nonnull readonly align 1 dereferenceable(3) %36, i64 noundef %37, i1 noundef false) #35
  %58 = load i64, ptr %38, align 8, !tbaa !63
  %59 = add nsw i64 %58, %37
  store i64 %59, ptr %38, align 8, !tbaa !63
  %60 = load ptr, ptr %0, align 8, !tbaa !61
  %61 = getelementptr inbounds i8, ptr %60, i64 %59
  store i8 0, ptr %61, align 1, !tbaa !10
  br label %171

62:                                               ; preds = %31
  %63 = fcmp oeq double %1, 0.000000e+00
  br i1 %63, label %64, label %92

64:                                               ; preds = %62
  %65 = tail call i1 @llvm.is.fpclass.f64(double %1, i32 64)
  %66 = select i1 %65, ptr @.str.186, ptr @.str.185
  %67 = select i1 %65, i64 3, i64 4
  %68 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %69 = load i64, ptr %68, align 8, !tbaa !63
  %70 = add nsw i64 %69, %67
  %71 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %72 = load i64, ptr %71, align 8, !tbaa !82
  %73 = icmp slt i64 %70, %72
  br i1 %73, label %74, label %76

74:                                               ; preds = %64
  %75 = load ptr, ptr %0, align 8, !tbaa !61
  br label %84

76:                                               ; preds = %64, %76
  %77 = phi i64 [ %78, %76 ], [ %72, %64 ]
  %78 = shl nsw i64 %77, 1
  %79 = icmp sgt i64 %78, %70
  br i1 %79, label %80, label %76, !llvm.loop !83

80:                                               ; preds = %76
  %81 = load ptr, ptr %0, align 8, !tbaa !61
  %82 = tail call ptr @realloc(ptr noundef %81, i64 noundef %78) #38
  store ptr %82, ptr %0, align 8, !tbaa !61
  store i64 %78, ptr %71, align 8, !tbaa !82
  %83 = load i64, ptr %68, align 8, !tbaa !63
  br label %84

84:                                               ; preds = %74, %80
  %85 = phi i64 [ %69, %74 ], [ %83, %80 ]
  %86 = phi ptr [ %75, %74 ], [ %82, %80 ]
  %87 = getelementptr inbounds i8, ptr %86, i64 %85
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(3) %87, ptr noundef nonnull readonly align 1 dereferenceable(3) %66, i64 noundef %67, i1 noundef false) #35
  %88 = load i64, ptr %68, align 8, !tbaa !63
  %89 = add nsw i64 %88, %67
  store i64 %89, ptr %68, align 8, !tbaa !63
  %90 = load ptr, ptr %0, align 8, !tbaa !61
  %91 = getelementptr inbounds i8, ptr %90, i64 %89
  store i8 0, ptr %91, align 1, !tbaa !10
  br label %171

92:                                               ; preds = %62
  call void @llvm.lifetime.start.p0(ptr nonnull %3) #35
  call void @llvm.lifetime.start.p0(ptr nonnull %4) #35
  br label %93

93:                                               ; preds = %92, %99
  %94 = phi i32 [ 1, %92 ], [ %100, %99 ]
  %95 = add nsw i32 %94, -1
  %96 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr nonnull dereferenceable(1) %3, i64 64, ptr nonnull @.str.187, i32 %95, double %1)
  %97 = call double @"\01_strtod"(ptr noundef nonnull %3, ptr noundef null) #35
  %98 = fcmp oeq double %97, %1
  br i1 %98, label %102, label %99

99:                                               ; preds = %93
  %100 = add nuw nsw i32 %94, 1
  %101 = icmp eq i32 %100, 18
  br i1 %101, label %102, label %93, !llvm.loop !128

102:                                              ; preds = %93, %99
  %103 = phi i32 [ %94, %93 ], [ 18, %99 ]
  %104 = call i32 @llvm.umin.i32(i32 %103, i32 17)
  %105 = add nsw i32 %104, -1
  %106 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr nonnull dereferenceable(1) %3, i64 64, ptr nonnull @.str.187, i32 %105, double %1)
  %107 = call ptr @strchr(ptr noundef nonnull dereferenceable(1) %3, i32 noundef 101) #35
  %108 = getelementptr inbounds nuw i8, ptr %107, i64 1
  %109 = call i32 @atoi(ptr noundef nonnull %108)
  %110 = add i32 %109, 4
  %111 = icmp ult i32 %110, 20
  br i1 %111, label %112, label %144

112:                                              ; preds = %102
  %113 = sub nsw i32 %105, %109
  %114 = call i32 @llvm.smax.i32(i32 %113, i32 0)
  %115 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr nonnull dereferenceable(1) %4, i64 96, ptr nonnull @.str.82, i32 %114, double %1)
  %116 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %4) #35
  %117 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %118 = load i64, ptr %117, align 8, !tbaa !63
  %119 = add nsw i64 %118, %116
  %120 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %121 = load i64, ptr %120, align 8, !tbaa !82
  %122 = icmp slt i64 %119, %121
  br i1 %122, label %123, label %125

123:                                              ; preds = %112
  %124 = load ptr, ptr %0, align 8, !tbaa !61
  br label %133

125:                                              ; preds = %112, %125
  %126 = phi i64 [ %127, %125 ], [ %121, %112 ]
  %127 = shl nsw i64 %126, 1
  %128 = icmp sgt i64 %127, %119
  br i1 %128, label %129, label %125, !llvm.loop !83

129:                                              ; preds = %125
  %130 = load ptr, ptr %0, align 8, !tbaa !61
  %131 = call ptr @realloc(ptr noundef %130, i64 noundef %127) #38
  store ptr %131, ptr %0, align 8, !tbaa !61
  store i64 %127, ptr %120, align 8, !tbaa !82
  %132 = load i64, ptr %117, align 8, !tbaa !63
  br label %133

133:                                              ; preds = %123, %129
  %134 = phi i64 [ %118, %123 ], [ %132, %129 ]
  %135 = phi ptr [ %124, %123 ], [ %131, %129 ]
  %136 = getelementptr inbounds i8, ptr %135, i64 %134
  call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %136, ptr noundef nonnull readonly align 1 %4, i64 noundef %116, i1 noundef false) #35
  %137 = load i64, ptr %117, align 8, !tbaa !63
  %138 = add nsw i64 %137, %116
  store i64 %138, ptr %117, align 8, !tbaa !63
  %139 = load ptr, ptr %0, align 8, !tbaa !61
  %140 = getelementptr inbounds i8, ptr %139, i64 %138
  store i8 0, ptr %140, align 1, !tbaa !10
  %141 = call ptr @strchr(ptr noundef nonnull dereferenceable(1) %4, i32 noundef 46) #35
  %142 = icmp eq ptr %141, null
  br i1 %142, label %143, label %170

143:                                              ; preds = %133
  call fastcc void @sb_adds(ptr noundef %0, ptr noundef nonnull @.str.188)
  br label %170

144:                                              ; preds = %102
  %145 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %3) #35
  %146 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %147 = load i64, ptr %146, align 8, !tbaa !63
  %148 = add nsw i64 %147, %145
  %149 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %150 = load i64, ptr %149, align 8, !tbaa !82
  %151 = icmp slt i64 %148, %150
  br i1 %151, label %152, label %154

152:                                              ; preds = %144
  %153 = load ptr, ptr %0, align 8, !tbaa !61
  br label %162

154:                                              ; preds = %144, %154
  %155 = phi i64 [ %156, %154 ], [ %150, %144 ]
  %156 = shl nsw i64 %155, 1
  %157 = icmp sgt i64 %156, %148
  br i1 %157, label %158, label %154, !llvm.loop !83

158:                                              ; preds = %154
  %159 = load ptr, ptr %0, align 8, !tbaa !61
  %160 = call ptr @realloc(ptr noundef %159, i64 noundef %156) #38
  store ptr %160, ptr %0, align 8, !tbaa !61
  store i64 %156, ptr %149, align 8, !tbaa !82
  %161 = load i64, ptr %146, align 8, !tbaa !63
  br label %162

162:                                              ; preds = %152, %158
  %163 = phi i64 [ %147, %152 ], [ %161, %158 ]
  %164 = phi ptr [ %153, %152 ], [ %160, %158 ]
  %165 = getelementptr inbounds i8, ptr %164, i64 %163
  call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %165, ptr noundef nonnull readonly align 1 %3, i64 noundef %145, i1 noundef false) #35
  %166 = load i64, ptr %146, align 8, !tbaa !63
  %167 = add nsw i64 %166, %145
  store i64 %167, ptr %146, align 8, !tbaa !63
  %168 = load ptr, ptr %0, align 8, !tbaa !61
  %169 = getelementptr inbounds i8, ptr %168, i64 %167
  store i8 0, ptr %169, align 1, !tbaa !10
  br label %170

170:                                              ; preds = %133, %143, %162
  call void @llvm.lifetime.end.p0(ptr nonnull %4) #35
  call void @llvm.lifetime.end.p0(ptr nonnull %3) #35
  br label %171

171:                                              ; preds = %170, %84, %54, %23
  ret void
}

; Function Attrs: nounwind ssp memory(readwrite, target_mem0: none, target_mem1: none) uwtable(sync)
define internal fastcc void @pad_into(ptr noundef nonnull captures(none) %0, ptr noundef readonly captures(none) %1, i64 noundef %2, i32 noundef %3, i32 noundef range(i32 0, 2) %4, i8 noundef signext %5) unnamed_addr #17 {
  %7 = sext i32 %3 to i64
  %8 = icmp slt i64 %2, %7
  %9 = sub nsw i64 %7, %2
  %10 = select i1 %8, i64 %9, i64 0
  %11 = icmp eq i32 %4, 0
  br i1 %11, label %12, label %68

12:                                               ; preds = %6
  %13 = icmp sgt i64 %10, 0
  br i1 %13, label %14, label %43

14:                                               ; preds = %12
  %15 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %16 = getelementptr inbounds nuw i8, ptr %0, i64 16
  br label %17

17:                                               ; preds = %14, %33
  %18 = phi i64 [ 0, %14 ], [ %41, %33 ]
  %19 = load i64, ptr %15, align 8, !tbaa !63
  %20 = add nsw i64 %19, 1
  %21 = load i64, ptr %16, align 8, !tbaa !82
  %22 = icmp slt i64 %20, %21
  br i1 %22, label %23, label %25

23:                                               ; preds = %17
  %24 = load ptr, ptr %0, align 8, !tbaa !61
  br label %33

25:                                               ; preds = %17, %25
  %26 = phi i64 [ %27, %25 ], [ %21, %17 ]
  %27 = shl nsw i64 %26, 1
  %28 = icmp sgt i64 %27, %20
  br i1 %28, label %29, label %25, !llvm.loop !83

29:                                               ; preds = %25
  %30 = load ptr, ptr %0, align 8, !tbaa !61
  %31 = tail call ptr @realloc(ptr noundef %30, i64 noundef %27) #38
  store ptr %31, ptr %0, align 8, !tbaa !61
  store i64 %27, ptr %16, align 8, !tbaa !82
  %32 = load i64, ptr %15, align 8, !tbaa !63
  br label %33

33:                                               ; preds = %23, %29
  %34 = phi i64 [ %19, %23 ], [ %32, %29 ]
  %35 = phi ptr [ %24, %23 ], [ %31, %29 ]
  %36 = getelementptr inbounds i8, ptr %35, i64 %34
  store i8 %5, ptr %36, align 1
  %37 = load i64, ptr %15, align 8, !tbaa !63
  %38 = add nsw i64 %37, 1
  store i64 %38, ptr %15, align 8, !tbaa !63
  %39 = load ptr, ptr %0, align 8, !tbaa !61
  %40 = getelementptr inbounds i8, ptr %39, i64 %38
  store i8 0, ptr %40, align 1, !tbaa !10
  %41 = add nuw nsw i64 %18, 1
  %42 = icmp slt i64 %41, %10
  br i1 %42, label %17, label %43, !llvm.loop !129

43:                                               ; preds = %33, %12
  %44 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %45 = load i64, ptr %44, align 8, !tbaa !63
  %46 = add nsw i64 %45, %2
  %47 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %48 = load i64, ptr %47, align 8, !tbaa !82
  %49 = icmp slt i64 %46, %48
  br i1 %49, label %50, label %52

50:                                               ; preds = %43
  %51 = load ptr, ptr %0, align 8, !tbaa !61
  br label %60

52:                                               ; preds = %43, %52
  %53 = phi i64 [ %54, %52 ], [ %48, %43 ]
  %54 = shl nsw i64 %53, 1
  %55 = icmp sgt i64 %54, %46
  br i1 %55, label %56, label %52, !llvm.loop !83

56:                                               ; preds = %52
  %57 = load ptr, ptr %0, align 8, !tbaa !61
  %58 = tail call ptr @realloc(ptr noundef %57, i64 noundef %54) #38
  store ptr %58, ptr %0, align 8, !tbaa !61
  store i64 %54, ptr %47, align 8, !tbaa !82
  %59 = load i64, ptr %44, align 8, !tbaa !63
  br label %60

60:                                               ; preds = %50, %56
  %61 = phi i64 [ %45, %50 ], [ %59, %56 ]
  %62 = phi ptr [ %51, %50 ], [ %58, %56 ]
  %63 = getelementptr inbounds i8, ptr %62, i64 %61
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %63, ptr noundef readonly align 1 %1, i64 noundef %2, i1 noundef false) #35
  %64 = load i64, ptr %44, align 8, !tbaa !63
  %65 = add nsw i64 %64, %2
  store i64 %65, ptr %44, align 8, !tbaa !63
  %66 = load ptr, ptr %0, align 8, !tbaa !61
  %67 = getelementptr inbounds i8, ptr %66, i64 %65
  store i8 0, ptr %67, align 1, !tbaa !10
  br label %120

68:                                               ; preds = %6
  %69 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %70 = load i64, ptr %69, align 8, !tbaa !63
  %71 = add nsw i64 %70, %2
  %72 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %73 = load i64, ptr %72, align 8, !tbaa !82
  %74 = icmp slt i64 %71, %73
  br i1 %74, label %75, label %77

75:                                               ; preds = %68
  %76 = load ptr, ptr %0, align 8, !tbaa !61
  br label %85

77:                                               ; preds = %68, %77
  %78 = phi i64 [ %79, %77 ], [ %73, %68 ]
  %79 = shl nsw i64 %78, 1
  %80 = icmp sgt i64 %79, %71
  br i1 %80, label %81, label %77, !llvm.loop !83

81:                                               ; preds = %77
  %82 = load ptr, ptr %0, align 8, !tbaa !61
  %83 = tail call ptr @realloc(ptr noundef %82, i64 noundef %79) #38
  store ptr %83, ptr %0, align 8, !tbaa !61
  store i64 %79, ptr %72, align 8, !tbaa !82
  %84 = load i64, ptr %69, align 8, !tbaa !63
  br label %85

85:                                               ; preds = %75, %81
  %86 = phi i64 [ %70, %75 ], [ %84, %81 ]
  %87 = phi ptr [ %76, %75 ], [ %83, %81 ]
  %88 = getelementptr inbounds i8, ptr %87, i64 %86
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %88, ptr noundef readonly align 1 %1, i64 noundef %2, i1 noundef false) #35
  %89 = load i64, ptr %69, align 8, !tbaa !63
  %90 = add nsw i64 %89, %2
  store i64 %90, ptr %69, align 8, !tbaa !63
  %91 = load ptr, ptr %0, align 8, !tbaa !61
  %92 = getelementptr inbounds i8, ptr %91, i64 %90
  store i8 0, ptr %92, align 1, !tbaa !10
  %93 = icmp sgt i64 %10, 0
  br i1 %93, label %94, label %120

94:                                               ; preds = %85, %110
  %95 = phi i64 [ %118, %110 ], [ 0, %85 ]
  %96 = load i64, ptr %69, align 8, !tbaa !63
  %97 = add nsw i64 %96, 1
  %98 = load i64, ptr %72, align 8, !tbaa !82
  %99 = icmp slt i64 %97, %98
  br i1 %99, label %100, label %102

100:                                              ; preds = %94
  %101 = load ptr, ptr %0, align 8, !tbaa !61
  br label %110

102:                                              ; preds = %94, %102
  %103 = phi i64 [ %104, %102 ], [ %98, %94 ]
  %104 = shl nsw i64 %103, 1
  %105 = icmp sgt i64 %104, %97
  br i1 %105, label %106, label %102, !llvm.loop !83

106:                                              ; preds = %102
  %107 = load ptr, ptr %0, align 8, !tbaa !61
  %108 = tail call ptr @realloc(ptr noundef %107, i64 noundef %104) #38
  store ptr %108, ptr %0, align 8, !tbaa !61
  store i64 %104, ptr %72, align 8, !tbaa !82
  %109 = load i64, ptr %69, align 8, !tbaa !63
  br label %110

110:                                              ; preds = %100, %106
  %111 = phi i64 [ %96, %100 ], [ %109, %106 ]
  %112 = phi ptr [ %101, %100 ], [ %108, %106 ]
  %113 = getelementptr inbounds i8, ptr %112, i64 %111
  store i8 %5, ptr %113, align 1
  %114 = load i64, ptr %69, align 8, !tbaa !63
  %115 = add nsw i64 %114, 1
  store i64 %115, ptr %69, align 8, !tbaa !63
  %116 = load ptr, ptr %0, align 8, !tbaa !61
  %117 = getelementptr inbounds i8, ptr %116, i64 %115
  store i8 0, ptr %117, align 1, !tbaa !10
  %118 = add nuw nsw i64 %95, 1
  %119 = icmp slt i64 %118, %10
  br i1 %119, label %94, label %120, !llvm.loop !130

120:                                              ; preds = %110, %85, %60
  ret void
}

; Function Attrs: nounwind ssp memory(readwrite, target_mem0: none, target_mem1: none) uwtable(sync)
define internal fastcc void @sb_putc(ptr noundef nonnull captures(none) %0, i8 noundef signext %1) unnamed_addr #17 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i64, ptr %3, align 8, !tbaa !63
  %5 = add nsw i64 %4, 1
  %6 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %7 = load i64, ptr %6, align 8, !tbaa !82
  %8 = icmp slt i64 %5, %7
  br i1 %8, label %9, label %11

9:                                                ; preds = %2
  %10 = load ptr, ptr %0, align 8, !tbaa !61
  br label %19

11:                                               ; preds = %2, %11
  %12 = phi i64 [ %13, %11 ], [ %7, %2 ]
  %13 = shl nsw i64 %12, 1
  %14 = icmp sgt i64 %13, %5
  br i1 %14, label %15, label %11, !llvm.loop !83

15:                                               ; preds = %11
  %16 = load ptr, ptr %0, align 8, !tbaa !61
  %17 = tail call ptr @realloc(ptr noundef %16, i64 noundef %13) #38
  store ptr %17, ptr %0, align 8, !tbaa !61
  store i64 %13, ptr %6, align 8, !tbaa !82
  %18 = load i64, ptr %3, align 8, !tbaa !63
  br label %19

19:                                               ; preds = %9, %15
  %20 = phi i64 [ %4, %9 ], [ %18, %15 ]
  %21 = phi ptr [ %10, %9 ], [ %17, %15 ]
  %22 = getelementptr inbounds i8, ptr %21, i64 %20
  store i8 %1, ptr %22, align 1
  %23 = load i64, ptr %3, align 8, !tbaa !63
  %24 = add nsw i64 %23, 1
  store i64 %24, ptr %3, align 8, !tbaa !63
  %25 = load ptr, ptr %0, align 8, !tbaa !61
  %26 = getelementptr inbounds i8, ptr %25, i64 %24
  store i8 0, ptr %26, align 1, !tbaa !10
  ret void
}

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: read)
declare i64 @strlen(ptr noundef captures(none)) local_unnamed_addr #4

; Function Attrs: nounwind ssp memory(readwrite, target_mem0: none, target_mem1: none) uwtable(sync)
define internal fastcc void @sb_adds(ptr noundef nonnull captures(none) %0, ptr noundef readonly captures(none) %1) unnamed_addr #17 {
  %3 = tail call i64 @strlen(ptr noundef nonnull dereferenceable(1) %1) #35
  %4 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %5 = load i64, ptr %4, align 8, !tbaa !63
  %6 = add nsw i64 %5, %3
  %7 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %8 = load i64, ptr %7, align 8, !tbaa !82
  %9 = icmp slt i64 %6, %8
  br i1 %9, label %10, label %12

10:                                               ; preds = %2
  %11 = load ptr, ptr %0, align 8, !tbaa !61
  br label %20

12:                                               ; preds = %2, %12
  %13 = phi i64 [ %14, %12 ], [ %8, %2 ]
  %14 = shl nsw i64 %13, 1
  %15 = icmp sgt i64 %14, %6
  br i1 %15, label %16, label %12, !llvm.loop !83

16:                                               ; preds = %12
  %17 = load ptr, ptr %0, align 8, !tbaa !61
  %18 = tail call ptr @realloc(ptr noundef %17, i64 noundef %14) #38
  store ptr %18, ptr %0, align 8, !tbaa !61
  store i64 %14, ptr %7, align 8, !tbaa !82
  %19 = load i64, ptr %4, align 8, !tbaa !63
  br label %20

20:                                               ; preds = %10, %16
  %21 = phi i64 [ %5, %10 ], [ %19, %16 ]
  %22 = phi ptr [ %11, %10 ], [ %18, %16 ]
  %23 = getelementptr inbounds i8, ptr %22, i64 %21
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %23, ptr noundef nonnull readonly align 1 %1, i64 noundef %3, i1 noundef false) #35
  %24 = load i64, ptr %4, align 8, !tbaa !63
  %25 = add nsw i64 %24, %3
  store i64 %25, ptr %4, align 8, !tbaa !63
  %26 = load ptr, ptr %0, align 8, !tbaa !61
  %27 = getelementptr inbounds i8, ptr %26, i64 %25
  store i8 0, ptr %27, align 1, !tbaa !10
  ret void
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_print(i64 noundef %0, ptr noundef readonly captures(none) %1, i64 noundef %2, i64 noundef %3, i64 noundef %4) local_unnamed_addr #2 {
  %6 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  %7 = icmp eq i64 %4, %6
  %8 = icmp eq i64 %4, 0
  %9 = or i1 %8, %7
  br i1 %9, label %20, label %10

10:                                               ; preds = %5
  %11 = and i64 %4, 1
  %12 = icmp eq i64 %11, 0
  br i1 %12, label %13, label %17

13:                                               ; preds = %10
  %14 = inttoptr i64 %4 to ptr
  %15 = load i64, ptr %14, align 8, !tbaa !23
  %16 = icmp eq i64 %15, 14
  br i1 %16, label %18, label %17

17:                                               ; preds = %13, %10
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.189) #36
  unreachable

18:                                               ; preds = %13
  %19 = getelementptr inbounds nuw i8, ptr %14, i64 8
  br label %20

20:                                               ; preds = %5, %18
  %21 = phi ptr [ %19, %18 ], [ @__stdoutp, %5 ]
  %22 = load ptr, ptr %21, align 8, !tbaa !13
  %23 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %24 = icmp eq ptr %22, %23
  br i1 %24, label %25, label %29

25:                                               ; preds = %20
  %26 = load ptr, ptr @__stdoutp, align 8, !tbaa !13
  %27 = tail call i32 @fflush(ptr noundef %26)
  %28 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  br label %29

29:                                               ; preds = %25, %20
  %30 = phi i64 [ %28, %25 ], [ %6, %20 ]
  %31 = icmp eq i64 %2, %30
  br i1 %31, label %32, label %35

32:                                               ; preds = %29
  %33 = tail call fastcc i64 @mkstr(ptr noundef nonnull @.str.65, i64 noundef 1)
  %34 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  br label %35

35:                                               ; preds = %29, %32
  %36 = phi i64 [ %34, %32 ], [ %30, %29 ]
  %37 = phi i64 [ %33, %32 ], [ %2, %29 ]
  %38 = icmp eq i64 %3, %36
  br i1 %38, label %39, label %41

39:                                               ; preds = %35
  %40 = tail call fastcc i64 @mkstr(ptr noundef nonnull @.str.66, i64 noundef 1)
  br label %41

41:                                               ; preds = %35, %39
  %42 = phi i64 [ %40, %39 ], [ %3, %35 ]
  %43 = icmp sgt i64 %0, 0
  br i1 %43, label %44, label %56

44:                                               ; preds = %41
  %45 = inttoptr i64 %37 to ptr
  %46 = getelementptr inbounds nuw i8, ptr %45, i64 16
  %47 = getelementptr inbounds nuw i8, ptr %45, i64 8
  %48 = load i64, ptr %1, align 8, !tbaa !11
  %49 = tail call i64 @rt_str(i64 noundef %48)
  %50 = inttoptr i64 %49 to ptr
  %51 = getelementptr inbounds nuw i8, ptr %50, i64 16
  %52 = getelementptr inbounds nuw i8, ptr %50, i64 8
  %53 = load i64, ptr %52, align 8, !tbaa !18
  %54 = tail call i64 @"\01_fwrite"(ptr noundef nonnull %51, i64 noundef 1, i64 noundef %53, ptr noundef %22) #35
  %55 = icmp eq i64 %0, 1
  br i1 %55, label %56, label %63

56:                                               ; preds = %63, %44, %41
  %57 = inttoptr i64 %42 to ptr
  %58 = getelementptr inbounds nuw i8, ptr %57, i64 16
  %59 = getelementptr inbounds nuw i8, ptr %57, i64 8
  %60 = load i64, ptr %59, align 8, !tbaa !18
  %61 = tail call i64 @"\01_fwrite"(ptr noundef nonnull %58, i64 noundef 1, i64 noundef %60, ptr noundef %22) #35
  %62 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  ret i64 %62

63:                                               ; preds = %44, %63
  %64 = phi i64 [ %75, %63 ], [ 1, %44 ]
  %65 = load i64, ptr %47, align 8, !tbaa !18
  %66 = tail call i64 @"\01_fwrite"(ptr noundef nonnull %46, i64 noundef 1, i64 noundef %65, ptr noundef %22) #35
  %67 = getelementptr inbounds nuw i64, ptr %1, i64 %64
  %68 = load i64, ptr %67, align 8, !tbaa !11
  %69 = tail call i64 @rt_str(i64 noundef %68)
  %70 = inttoptr i64 %69 to ptr
  %71 = getelementptr inbounds nuw i8, ptr %70, i64 16
  %72 = getelementptr inbounds nuw i8, ptr %70, i64 8
  %73 = load i64, ptr %72, align 8, !tbaa !18
  %74 = tail call i64 @"\01_fwrite"(ptr noundef nonnull %71, i64 noundef 1, i64 noundef %73, ptr noundef %22) #35
  %75 = add nuw nsw i64 %64, 1
  %76 = icmp eq i64 %75, %0
  br i1 %76, label %56, label %63, !llvm.loop !131
}

declare i64 @"\01_fwrite"(ptr noundef, i64 noundef, i64 noundef, ptr noundef) local_unnamed_addr #3

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @b_print(i64 noundef %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  %4 = tail call i64 @rt_print(i64 noundef %0, ptr noundef %1, i64 noundef %3, i64 noundef %3, i64 noundef %3)
  ret i64 %4
}

; Function Attrs: nounwind ssp uwtable(sync)
define noundef i64 @b_open(i64 noundef %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = icmp sgt i64 %0, 1
  br i1 %3, label %4, label %9

4:                                                ; preds = %2
  %5 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %6 = load i64, ptr %5, align 8, !tbaa !11
  %7 = inttoptr i64 %6 to ptr
  %8 = getelementptr inbounds nuw i8, ptr %7, i64 16
  br label %9

9:                                                ; preds = %2, %4
  %10 = phi ptr [ %8, %4 ], [ @.str.67, %2 ]
  %11 = load i64, ptr %1, align 8, !tbaa !11
  %12 = inttoptr i64 %11 to ptr
  %13 = getelementptr inbounds nuw i8, ptr %12, i64 16
  %14 = tail call ptr @"\01_fopen"(ptr noundef nonnull %13, ptr noundef nonnull %10) #35
  %15 = icmp eq ptr %14, null
  br i1 %15, label %16, label %20

16:                                               ; preds = %9
  %17 = load i64, ptr %1, align 8, !tbaa !11
  %18 = inttoptr i64 %17 to ptr
  %19 = getelementptr inbounds nuw i8, ptr %18, i64 16
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.68, ptr noundef nonnull @.str.69, ptr noundef nonnull %19) #36
  unreachable

20:                                               ; preds = %9
  %21 = tail call dereferenceable_or_null(16) ptr @calloc(i64 noundef 1, i64 noundef 16) #33
  %22 = icmp eq ptr %21, null
  br i1 %22, label %23, label %26

23:                                               ; preds = %20
  %24 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %25 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %24)
  tail call void @exit(i32 noundef 1) #34
  unreachable

26:                                               ; preds = %20
  store i64 14, ptr %21, align 8, !tbaa !133
  %27 = getelementptr inbounds nuw i8, ptr %21, i64 8
  store ptr %14, ptr %27, align 8, !tbaa !135
  %28 = ptrtoint ptr %21 to i64
  ret i64 %28
}

declare ptr @"\01_fopen"(ptr noundef, ptr noundef) local_unnamed_addr #3

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @b_input(i64 noundef %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = icmp sgt i64 %0, 0
  br i1 %3, label %4, label %15

4:                                                ; preds = %2
  %5 = load i64, ptr %1, align 8, !tbaa !11
  %6 = tail call i64 @rt_str(i64 noundef %5)
  %7 = inttoptr i64 %6 to ptr
  %8 = getelementptr inbounds nuw i8, ptr %7, i64 16
  %9 = getelementptr inbounds nuw i8, ptr %7, i64 8
  %10 = load i64, ptr %9, align 8, !tbaa !18
  %11 = load ptr, ptr @__stdoutp, align 8, !tbaa !13
  %12 = tail call i64 @"\01_fwrite"(ptr noundef nonnull %8, i64 noundef 1, i64 noundef %10, ptr noundef %11) #35
  %13 = load ptr, ptr @__stdoutp, align 8, !tbaa !13
  %14 = tail call i32 @fflush(ptr noundef %13)
  br label %15

15:                                               ; preds = %4, %2
  %16 = tail call dereferenceable_or_null(64) ptr @calloc(i64 noundef 1, i64 noundef 64) #33
  %17 = icmp eq ptr %16, null
  br i1 %17, label %18, label %21

18:                                               ; preds = %15
  %19 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %20 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %19)
  tail call void @exit(i32 noundef 1) #34
  unreachable

21:                                               ; preds = %15, %38
  %22 = phi i64 [ %39, %38 ], [ 64, %15 ]
  %23 = phi i64 [ %30, %38 ], [ 0, %15 ]
  %24 = phi ptr [ %40, %38 ], [ %16, %15 ]
  %25 = phi i1 [ false, %38 ], [ true, %15 ]
  %26 = load ptr, ptr @__stdinp, align 8, !tbaa !13
  %27 = tail call i32 @fgetc(ptr noundef %26)
  switch i32 %27, label %28 [
    i32 -1, label %43
    i32 10, label %45
  ]

28:                                               ; preds = %21
  %29 = trunc i32 %27 to i8
  %30 = add nuw nsw i64 %23, 1
  %31 = icmp slt i64 %30, %22
  br i1 %31, label %38, label %32

32:                                               ; preds = %28, %32
  %33 = phi i64 [ %34, %32 ], [ %22, %28 ]
  %34 = shl nsw i64 %33, 1
  %35 = icmp sgt i64 %34, %30
  br i1 %35, label %36, label %32, !llvm.loop !83

36:                                               ; preds = %32
  %37 = tail call ptr @realloc(ptr noundef nonnull %24, i64 noundef %34) #38
  br label %38

38:                                               ; preds = %28, %36
  %39 = phi i64 [ %34, %36 ], [ %22, %28 ]
  %40 = phi ptr [ %37, %36 ], [ %24, %28 ]
  %41 = getelementptr inbounds nuw i8, ptr %40, i64 %23
  store i8 %29, ptr %41, align 1
  %42 = getelementptr inbounds nuw i8, ptr %40, i64 %30
  store i8 0, ptr %42, align 1, !tbaa !10
  br label %21, !llvm.loop !136

43:                                               ; preds = %21
  br i1 %25, label %44, label %45

44:                                               ; preds = %43
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.70, ptr noundef nonnull @.str.71) #36
  unreachable

45:                                               ; preds = %21, %43
  %46 = tail call fastcc i64 @mkstr(ptr noundef nonnull %24, i64 noundef %23)
  ret i64 %46
}

; Function Attrs: nofree nounwind
declare noundef i32 @fgetc(ptr noundef captures(none)) local_unnamed_addr #6

; Function Attrs: noreturn nounwind ssp uwtable(sync)
define noundef i64 @b_exit(i64 noundef %0, ptr noundef readonly captures(none) %1) #5 {
  %3 = icmp sgt i64 %0, 0
  br i1 %3, label %4, label %22

4:                                                ; preds = %2
  %5 = load i64, ptr %1, align 8, !tbaa !11
  %6 = and i64 %5, 1
  %7 = icmp eq i64 %6, 0
  br i1 %7, label %11, label %8

8:                                                ; preds = %4
  %9 = lshr i64 %5, 1
  %10 = trunc i64 %9 to i32
  br label %22

11:                                               ; preds = %4
  %12 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  %13 = icmp eq i64 %5, %12
  br i1 %13, label %22, label %14

14:                                               ; preds = %11
  %15 = tail call i64 @rt_str(i64 noundef %5)
  %16 = load ptr, ptr @__stdoutp, align 8, !tbaa !13
  %17 = tail call i32 @fflush(ptr noundef %16)
  %18 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %19 = inttoptr i64 %15 to ptr
  %20 = getelementptr inbounds nuw i8, ptr %19, i64 16
  %21 = tail call i32 (ptr, ptr, ...) @fprintf(ptr noundef %18, ptr noundef nonnull @.str.4, ptr noundef nonnull %20) #35
  br label %22

22:                                               ; preds = %8, %14, %11, %2
  %23 = phi i32 [ %10, %8 ], [ 1, %14 ], [ 0, %11 ], [ 0, %2 ]
  %24 = load ptr, ptr @__stdoutp, align 8, !tbaa !13
  %25 = tail call i32 @fflush(ptr noundef %24)
  tail call void @exit(i32 noundef %23) #37
  unreachable
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @b_len(i64 %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = alloca [1 x i64], align 8
  %4 = load i64, ptr %1, align 8, !tbaa !11
  %5 = and i64 %4, 1
  %6 = icmp ne i64 %5, 0
  %7 = icmp eq i64 %4, 0
  %8 = or i1 %7, %6
  br i1 %8, label %60, label %9

9:                                                ; preds = %2
  %10 = inttoptr i64 %4 to ptr
  %11 = load i64, ptr %10, align 8, !tbaa !23
  switch i64 %11, label %60 [
    i64 4, label %12
    i64 5, label %17
    i64 6, label %17
    i64 7, label %22
    i64 8, label %22
    i64 12, label %27
  ]

12:                                               ; preds = %9
  %13 = getelementptr inbounds nuw i8, ptr %10, i64 8
  %14 = load i64, ptr %13, align 8, !tbaa !18
  %15 = shl nsw i64 %14, 1
  %16 = or disjoint i64 %15, 1
  br label %62

17:                                               ; preds = %9, %9
  %18 = getelementptr inbounds nuw i8, ptr %10, i64 8
  %19 = load i64, ptr %18, align 8, !tbaa !27
  %20 = shl nsw i64 %19, 1
  %21 = or disjoint i64 %20, 1
  br label %62

22:                                               ; preds = %9, %9
  %23 = getelementptr inbounds nuw i8, ptr %10, i64 8
  %24 = load i64, ptr %23, align 8, !tbaa !33
  %25 = shl nsw i64 %24, 1
  %26 = or disjoint i64 %25, 1
  br label %62

27:                                               ; preds = %9
  %28 = getelementptr inbounds nuw i8, ptr %10, i64 8
  %29 = load i64, ptr %28, align 8, !tbaa !42
  %30 = load i64, ptr @K_len, align 8, !tbaa !11
  %31 = icmp ne i64 %29, 0
  %32 = and i64 %29, 1
  %33 = icmp eq i64 %32, 0
  %34 = and i1 %31, %33
  br i1 %34, label %35, label %60

35:                                               ; preds = %27, %47
  %36 = phi i64 [ %49, %47 ], [ %29, %27 ]
  %37 = inttoptr i64 %36 to ptr
  %38 = load i64, ptr %37, align 8, !tbaa !23
  %39 = icmp eq i64 %38, 11
  br i1 %39, label %40, label %60

40:                                               ; preds = %35
  %41 = getelementptr inbounds nuw i8, ptr %37, i64 24
  %42 = load i64, ptr %41, align 8, !tbaa !44
  %43 = inttoptr i64 %42 to ptr
  %44 = tail call fastcc i64 @hash_v(i64 noundef %30) #39
  %45 = tail call fastcc ptr @dict_find(ptr noundef %43, i64 noundef %30, i64 noundef %44) #39
  %46 = icmp eq ptr %45, null
  br i1 %46, label %47, label %54

47:                                               ; preds = %40
  %48 = getelementptr inbounds nuw i8, ptr %37, i64 16
  %49 = load i64, ptr %48, align 8, !tbaa !46
  %50 = icmp ne i64 %49, 0
  %51 = and i64 %49, 1
  %52 = icmp eq i64 %51, 0
  %53 = and i1 %50, %52
  br i1 %53, label %35, label %60

54:                                               ; preds = %40
  %55 = getelementptr inbounds nuw i8, ptr %45, i64 8
  %56 = load i64, ptr %55, align 8, !tbaa !42
  %57 = icmp eq i64 %56, 0
  br i1 %57, label %60, label %58

58:                                               ; preds = %54
  call void @llvm.lifetime.start.p0(ptr nonnull %3) #35
  store i64 %4, ptr %3, align 8, !tbaa !11
  %59 = call i64 @rt_call(i64 noundef %56, i64 noundef 1, ptr noundef nonnull %3)
  call void @llvm.lifetime.end.p0(ptr nonnull %3) #35
  br label %62

60:                                               ; preds = %47, %35, %27, %2, %54, %9
  %61 = tail call fastcc ptr @tname(i64 noundef %4)
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.72, ptr noundef nonnull %61) #36
  unreachable

62:                                               ; preds = %58, %22, %17, %12
  %63 = phi i64 [ %16, %12 ], [ %21, %17 ], [ %26, %22 ], [ %59, %58 ]
  ret i64 %63
}

; Function Attrs: nounwind ssp uwtable(sync)
define noundef i64 @b_range(i64 noundef %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = icmp eq i64 %0, 1
  %4 = load i64, ptr %1, align 8, !tbaa !11
  %5 = and i64 %4, 1
  %6 = icmp eq i64 %5, 0
  br i1 %3, label %7, label %20

7:                                                ; preds = %2
  br i1 %6, label %10, label %8

8:                                                ; preds = %7
  %9 = ashr i64 %4, 1
  br label %75

10:                                               ; preds = %7
  %11 = icmp eq i64 %4, 0
  br i1 %11, label %19, label %12

12:                                               ; preds = %10
  %13 = inttoptr i64 %4 to ptr
  %14 = load i64, ptr %13, align 8, !tbaa !23
  %15 = icmp eq i64 %14, 2
  br i1 %15, label %16, label %19

16:                                               ; preds = %12
  %17 = getelementptr inbounds nuw i8, ptr %13, i64 8
  %18 = load i64, ptr %17, align 8, !tbaa !25
  br label %75

19:                                               ; preds = %12, %10
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

20:                                               ; preds = %2
  br i1 %6, label %23, label %21

21:                                               ; preds = %20
  %22 = ashr i64 %4, 1
  br label %33

23:                                               ; preds = %20
  %24 = icmp eq i64 %4, 0
  br i1 %24, label %32, label %25

25:                                               ; preds = %23
  %26 = inttoptr i64 %4 to ptr
  %27 = load i64, ptr %26, align 8, !tbaa !23
  %28 = icmp eq i64 %27, 2
  br i1 %28, label %29, label %32

29:                                               ; preds = %25
  %30 = getelementptr inbounds nuw i8, ptr %26, i64 8
  %31 = load i64, ptr %30, align 8, !tbaa !25
  br label %33

32:                                               ; preds = %25, %23
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

33:                                               ; preds = %21, %29
  %34 = phi i64 [ %22, %21 ], [ %31, %29 ]
  %35 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %36 = load i64, ptr %35, align 8, !tbaa !11
  %37 = and i64 %36, 1
  %38 = icmp eq i64 %37, 0
  br i1 %38, label %41, label %39

39:                                               ; preds = %33
  %40 = ashr i64 %36, 1
  br label %51

41:                                               ; preds = %33
  %42 = icmp eq i64 %36, 0
  br i1 %42, label %50, label %43

43:                                               ; preds = %41
  %44 = inttoptr i64 %36 to ptr
  %45 = load i64, ptr %44, align 8, !tbaa !23
  %46 = icmp eq i64 %45, 2
  br i1 %46, label %47, label %50

47:                                               ; preds = %43
  %48 = getelementptr inbounds nuw i8, ptr %44, i64 8
  %49 = load i64, ptr %48, align 8, !tbaa !25
  br label %51

50:                                               ; preds = %43, %41
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

51:                                               ; preds = %39, %47
  %52 = phi i64 [ %40, %39 ], [ %49, %47 ]
  %53 = icmp sgt i64 %0, 2
  br i1 %53, label %54, label %75

54:                                               ; preds = %51
  %55 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %56 = load i64, ptr %55, align 8, !tbaa !11
  %57 = and i64 %56, 1
  %58 = icmp eq i64 %57, 0
  br i1 %58, label %61, label %59

59:                                               ; preds = %54
  %60 = ashr i64 %56, 1
  br label %71

61:                                               ; preds = %54
  %62 = icmp eq i64 %56, 0
  br i1 %62, label %70, label %63

63:                                               ; preds = %61
  %64 = inttoptr i64 %56 to ptr
  %65 = load i64, ptr %64, align 8, !tbaa !23
  %66 = icmp eq i64 %65, 2
  br i1 %66, label %67, label %70

67:                                               ; preds = %63
  %68 = getelementptr inbounds nuw i8, ptr %64, i64 8
  %69 = load i64, ptr %68, align 8, !tbaa !25
  br label %71

70:                                               ; preds = %63, %61
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

71:                                               ; preds = %67, %59
  %72 = phi i64 [ %69, %67 ], [ %60, %59 ]
  %73 = icmp eq i64 %72, 0
  br i1 %73, label %74, label %79

74:                                               ; preds = %71
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.25, ptr noundef nonnull @.str.73) #36
  unreachable

75:                                               ; preds = %8, %16, %51
  %76 = phi i64 [ %34, %51 ], [ 0, %16 ], [ 0, %8 ]
  %77 = phi i64 [ %52, %51 ], [ %18, %16 ], [ %9, %8 ]
  %78 = tail call fastcc i64 @mklist(i64 noundef 8)
  br label %89

79:                                               ; preds = %71
  %80 = tail call fastcc i64 @mklist(i64 noundef 8)
  %81 = icmp sgt i64 %72, 0
  br i1 %81, label %89, label %82

82:                                               ; preds = %79
  %83 = icmp sgt i64 %34, %52
  br i1 %83, label %84, label %144

84:                                               ; preds = %82
  %85 = inttoptr i64 %80 to ptr
  %86 = getelementptr inbounds nuw i8, ptr %85, i64 8
  %87 = getelementptr inbounds nuw i8, ptr %85, i64 16
  %88 = getelementptr inbounds nuw i8, ptr %85, i64 24
  br label %122

89:                                               ; preds = %75, %79
  %90 = phi i64 [ %78, %75 ], [ %80, %79 ]
  %91 = phi i64 [ %77, %75 ], [ %52, %79 ]
  %92 = phi i64 [ 1, %75 ], [ %72, %79 ]
  %93 = phi i64 [ %76, %75 ], [ %34, %79 ]
  %94 = icmp slt i64 %93, %91
  br i1 %94, label %95, label %144

95:                                               ; preds = %89
  %96 = inttoptr i64 %90 to ptr
  %97 = getelementptr inbounds nuw i8, ptr %96, i64 8
  %98 = getelementptr inbounds nuw i8, ptr %96, i64 16
  %99 = getelementptr inbounds nuw i8, ptr %96, i64 24
  br label %100

100:                                              ; preds = %95, %115
  %101 = phi i64 [ %93, %95 ], [ %120, %115 ]
  %102 = shl nsw i64 %101, 1
  %103 = or disjoint i64 %102, 1
  %104 = load i64, ptr %97, align 8, !tbaa !27
  %105 = load i64, ptr %98, align 8, !tbaa !70
  %106 = icmp slt i64 %104, %105
  br i1 %106, label %107, label %109

107:                                              ; preds = %100
  %108 = load ptr, ptr %99, align 8, !tbaa !32
  br label %115

109:                                              ; preds = %100
  %110 = shl nsw i64 %105, 1
  store i64 %110, ptr %98, align 8, !tbaa !70
  %111 = load ptr, ptr %99, align 8, !tbaa !32
  %112 = shl i64 %105, 4
  %113 = tail call ptr @realloc(ptr noundef %111, i64 noundef %112) #38
  store ptr %113, ptr %99, align 8, !tbaa !32
  %114 = load i64, ptr %97, align 8, !tbaa !27
  br label %115

115:                                              ; preds = %107, %109
  %116 = phi i64 [ %104, %107 ], [ %114, %109 ]
  %117 = phi ptr [ %108, %107 ], [ %113, %109 ]
  %118 = add nsw i64 %116, 1
  store i64 %118, ptr %97, align 8, !tbaa !27
  %119 = getelementptr inbounds i64, ptr %117, i64 %116
  store i64 %103, ptr %119, align 8, !tbaa !11
  %120 = add nsw i64 %101, %92
  %121 = icmp slt i64 %120, %91
  br i1 %121, label %100, label %144, !llvm.loop !137

122:                                              ; preds = %84, %137
  %123 = phi i64 [ %34, %84 ], [ %142, %137 ]
  %124 = shl nsw i64 %123, 1
  %125 = or disjoint i64 %124, 1
  %126 = load i64, ptr %86, align 8, !tbaa !27
  %127 = load i64, ptr %87, align 8, !tbaa !70
  %128 = icmp slt i64 %126, %127
  br i1 %128, label %129, label %131

129:                                              ; preds = %122
  %130 = load ptr, ptr %88, align 8, !tbaa !32
  br label %137

131:                                              ; preds = %122
  %132 = shl nsw i64 %127, 1
  store i64 %132, ptr %87, align 8, !tbaa !70
  %133 = load ptr, ptr %88, align 8, !tbaa !32
  %134 = shl i64 %127, 4
  %135 = tail call ptr @realloc(ptr noundef %133, i64 noundef %134) #38
  store ptr %135, ptr %88, align 8, !tbaa !32
  %136 = load i64, ptr %86, align 8, !tbaa !27
  br label %137

137:                                              ; preds = %129, %131
  %138 = phi i64 [ %126, %129 ], [ %136, %131 ]
  %139 = phi ptr [ %130, %129 ], [ %135, %131 ]
  %140 = add nsw i64 %138, 1
  store i64 %140, ptr %86, align 8, !tbaa !27
  %141 = getelementptr inbounds i64, ptr %139, i64 %138
  store i64 %125, ptr %141, align 8, !tbaa !11
  %142 = add nsw i64 %123, %72
  %143 = icmp sgt i64 %142, %52
  br i1 %143, label %122, label %144, !llvm.loop !138

144:                                              ; preds = %137, %115, %82, %89
  %145 = phi i64 [ %90, %115 ], [ %90, %89 ], [ %80, %82 ], [ %80, %137 ]
  ret i64 %145
}

; Function Attrs: nounwind ssp uwtable(sync)
define range(i64 1, 0) i64 @b_int(i64 noundef %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = alloca ptr, align 8
  %4 = icmp eq i64 %0, 0
  br i1 %4, label %117, label %5

5:                                                ; preds = %2
  %6 = load i64, ptr %1, align 8, !tbaa !11
  %7 = and i64 %6, 1
  %8 = icmp eq i64 %7, 0
  br i1 %8, label %9, label %117

9:                                                ; preds = %5
  %10 = icmp eq i64 %6, 0
  br i1 %10, label %115, label %11

11:                                               ; preds = %9
  %12 = inttoptr i64 %6 to ptr
  %13 = load i64, ptr %12, align 8, !tbaa !23
  switch i64 %13, label %115 [
    i64 2, label %14
    i64 3, label %19
    i64 4, label %33
  ]

14:                                               ; preds = %11
  %15 = getelementptr inbounds nuw i8, ptr %12, i64 8
  %16 = load i64, ptr %15, align 8, !tbaa !25
  %17 = shl nsw i64 %16, 1
  %18 = or disjoint i64 %17, 1
  br label %117

19:                                               ; preds = %11
  %20 = getelementptr inbounds nuw i8, ptr %12, i64 8
  %21 = load double, ptr %20, align 8, !tbaa !22
  %22 = tail call double @llvm.fabs.f64(double %21)
  %23 = fcmp ueq double %22, 0x7FF0000000000000
  br i1 %23, label %24, label %25

24:                                               ; preds = %19
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.25, ptr noundef nonnull @.str.74) #36
  unreachable

25:                                               ; preds = %19
  %26 = fptosi double %21 to i64
  %27 = add i64 %26, -4611686018427387904
  %28 = icmp sgt i64 %27, -1
  br i1 %28, label %29, label %30

29:                                               ; preds = %25
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.7, ptr noundef nonnull @.str.131) #36
  unreachable

30:                                               ; preds = %25
  %31 = shl nsw i64 %26, 1
  %32 = or disjoint i64 %31, 1
  br label %117

33:                                               ; preds = %11
  %34 = icmp sgt i64 %0, 1
  br i1 %34, label %35, label %55

35:                                               ; preds = %33
  %36 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %37 = load i64, ptr %36, align 8, !tbaa !11
  %38 = and i64 %37, 1
  %39 = icmp eq i64 %38, 0
  br i1 %39, label %42, label %40

40:                                               ; preds = %35
  %41 = ashr i64 %37, 1
  br label %52

42:                                               ; preds = %35
  %43 = icmp eq i64 %37, 0
  br i1 %43, label %51, label %44

44:                                               ; preds = %42
  %45 = inttoptr i64 %37 to ptr
  %46 = load i64, ptr %45, align 8, !tbaa !23
  %47 = icmp eq i64 %46, 2
  br i1 %47, label %48, label %51

48:                                               ; preds = %44
  %49 = getelementptr inbounds nuw i8, ptr %45, i64 8
  %50 = load i64, ptr %49, align 8, !tbaa !25
  br label %52

51:                                               ; preds = %44, %42
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

52:                                               ; preds = %40, %48
  %53 = phi i64 [ %41, %40 ], [ %50, %48 ]
  %54 = trunc i64 %53 to i32
  br label %55

55:                                               ; preds = %33, %52
  %56 = phi i32 [ %54, %52 ], [ 10, %33 ]
  %57 = getelementptr inbounds nuw i8, ptr %12, i64 16
  br label %58

58:                                               ; preds = %70, %55
  %59 = phi ptr [ %57, %55 ], [ %73, %70 ]
  %60 = load i8, ptr %59, align 1, !tbaa !10
  %61 = icmp sgt i8 %60, -1
  br i1 %61, label %62, label %67

62:                                               ; preds = %58
  %63 = zext nneg i8 %60 to i64
  %64 = getelementptr inbounds nuw i32, ptr getelementptr inbounds nuw (i8, ptr @_DefaultRuneLocale, i64 60), i64 %63
  %65 = load i32, ptr %64, align 4, !tbaa !6
  %66 = and i32 %65, 16384
  br label %70

67:                                               ; preds = %58
  %68 = zext i8 %60 to i32
  %69 = tail call i32 @__maskrune(i32 noundef %68, i64 noundef 16384) #35
  br label %70

70:                                               ; preds = %62, %67
  %71 = phi i32 [ %66, %62 ], [ %69, %67 ]
  %72 = icmp eq i32 %71, 0
  %73 = getelementptr inbounds nuw i8, ptr %59, i64 1
  br i1 %72, label %74, label %58, !llvm.loop !139

74:                                               ; preds = %70
  call void @llvm.lifetime.start.p0(ptr nonnull %3) #35
  %75 = load i8, ptr %59, align 1, !tbaa !10
  %76 = icmp eq i8 %75, 0
  br i1 %76, label %77, label %81

77:                                               ; preds = %74
  %78 = tail call i64 @rt_repr(i64 noundef %6)
  %79 = inttoptr i64 %78 to ptr
  %80 = getelementptr inbounds nuw i8, ptr %79, i64 16
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.25, ptr noundef nonnull @.str.75, i32 noundef %56, ptr noundef nonnull %80) #36
  unreachable

81:                                               ; preds = %74
  %82 = call i64 @strtoll(ptr noundef nonnull %59, ptr noundef nonnull %3, i32 noundef %56)
  %83 = load ptr, ptr %3, align 8, !tbaa !67
  br label %84

84:                                               ; preds = %96, %81
  %85 = phi ptr [ %99, %96 ], [ %83, %81 ]
  %86 = load i8, ptr %85, align 1, !tbaa !10
  %87 = icmp sgt i8 %86, -1
  br i1 %87, label %88, label %93

88:                                               ; preds = %84
  %89 = zext nneg i8 %86 to i64
  %90 = getelementptr inbounds nuw i32, ptr getelementptr inbounds nuw (i8, ptr @_DefaultRuneLocale, i64 60), i64 %89
  %91 = load i32, ptr %90, align 4, !tbaa !6
  %92 = and i32 %91, 16384
  br label %96

93:                                               ; preds = %84
  %94 = zext i8 %86 to i32
  %95 = tail call i32 @__maskrune(i32 noundef %94, i64 noundef 16384) #35
  br label %96

96:                                               ; preds = %88, %93
  %97 = phi i32 [ %92, %88 ], [ %95, %93 ]
  %98 = icmp eq i32 %97, 0
  %99 = getelementptr inbounds nuw i8, ptr %85, i64 1
  br i1 %98, label %100, label %84, !llvm.loop !140

100:                                              ; preds = %96
  %101 = icmp ne ptr %85, %59
  %102 = icmp eq i8 %86, 0
  %103 = and i1 %101, %102
  br i1 %103, label %108, label %104

104:                                              ; preds = %100
  %105 = tail call i64 @rt_repr(i64 noundef %6)
  %106 = inttoptr i64 %105 to ptr
  %107 = getelementptr inbounds nuw i8, ptr %106, i64 16
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.25, ptr noundef nonnull @.str.75, i32 noundef %56, ptr noundef nonnull %107) #36
  unreachable

108:                                              ; preds = %100
  %109 = add i64 %82, -4611686018427387904
  %110 = icmp sgt i64 %109, -1
  br i1 %110, label %111, label %112

111:                                              ; preds = %108
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.7, ptr noundef nonnull @.str.131) #36
  unreachable

112:                                              ; preds = %108
  %113 = shl nsw i64 %82, 1
  %114 = or disjoint i64 %113, 1
  call void @llvm.lifetime.end.p0(ptr nonnull %3) #35
  br label %117

115:                                              ; preds = %9, %11
  %116 = tail call fastcc ptr @tname(i64 noundef %6)
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.76, ptr noundef nonnull %116) #36
  unreachable

117:                                              ; preds = %14, %30, %112, %5, %2
  %118 = phi i64 [ 1, %2 ], [ %114, %112 ], [ %18, %14 ], [ %32, %30 ], [ %6, %5 ]
  ret i64 %118
}

; Function Attrs: mustprogress nocallback nofree nounwind willreturn
declare i64 @strtoll(ptr noundef readonly, ptr noundef captures(none), i32 noundef) local_unnamed_addr #21

; Function Attrs: nounwind ssp uwtable(sync)
define noundef i64 @b_float(i64 noundef %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = alloca ptr, align 8
  %4 = icmp eq i64 %0, 0
  br i1 %4, label %5, label %12

5:                                                ; preds = %2
  %6 = tail call dereferenceable_or_null(16) ptr @calloc(i64 noundef 1, i64 noundef 16) #33
  %7 = icmp eq ptr %6, null
  br i1 %7, label %8, label %11

8:                                                ; preds = %5
  %9 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %10 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %9)
  tail call void @exit(i32 noundef 1) #34
  unreachable

11:                                               ; preds = %5
  store i64 3, ptr %6, align 8, !tbaa !19
  br label %83

12:                                               ; preds = %2
  %13 = load i64, ptr %1, align 8, !tbaa !11
  %14 = and i64 %13, 1
  %15 = icmp eq i64 %14, 0
  br i1 %15, label %16, label %23

16:                                               ; preds = %12
  %17 = icmp eq i64 %13, 0
  br i1 %17, label %82, label %18

18:                                               ; preds = %16
  %19 = inttoptr i64 %13 to ptr
  %20 = load i64, ptr %19, align 8, !tbaa !23
  %21 = and i64 %20, -2
  %22 = icmp eq i64 %21, 2
  br i1 %22, label %26, label %43

23:                                               ; preds = %12
  %24 = ashr i64 %13, 1
  %25 = sitofp i64 %24 to double
  br label %34

26:                                               ; preds = %18
  %27 = icmp eq i64 %20, 2
  %28 = getelementptr inbounds nuw i8, ptr %19, i64 8
  br i1 %27, label %29, label %32

29:                                               ; preds = %26
  %30 = load i64, ptr %28, align 8, !tbaa !25
  %31 = sitofp i64 %30 to double
  br label %34

32:                                               ; preds = %26
  %33 = load double, ptr %28, align 8, !tbaa !22
  br label %34

34:                                               ; preds = %23, %29, %32
  %35 = phi double [ %25, %23 ], [ %31, %29 ], [ %33, %32 ]
  %36 = tail call dereferenceable_or_null(16) ptr @calloc(i64 noundef 1, i64 noundef 16) #33
  %37 = icmp eq ptr %36, null
  br i1 %37, label %38, label %41

38:                                               ; preds = %34
  %39 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %40 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %39)
  tail call void @exit(i32 noundef 1) #34
  unreachable

41:                                               ; preds = %34
  store i64 3, ptr %36, align 8, !tbaa !19
  %42 = getelementptr inbounds nuw i8, ptr %36, i64 8
  store double %35, ptr %42, align 8, !tbaa !22
  br label %83

43:                                               ; preds = %18
  %44 = icmp eq i64 %20, 4
  br i1 %44, label %45, label %82

45:                                               ; preds = %43
  call void @llvm.lifetime.start.p0(ptr nonnull %3) #35
  %46 = getelementptr inbounds nuw i8, ptr %19, i64 16
  %47 = call double @"\01_strtod"(ptr noundef nonnull %46, ptr noundef nonnull %3) #35
  %48 = load ptr, ptr %3, align 8, !tbaa !67
  br label %49

49:                                               ; preds = %64, %45
  %50 = phi ptr [ %65, %64 ], [ %48, %45 ]
  %51 = load i8, ptr %50, align 1, !tbaa !10
  %52 = icmp sgt i8 %51, -1
  br i1 %52, label %53, label %58

53:                                               ; preds = %49
  %54 = zext nneg i8 %51 to i64
  %55 = getelementptr inbounds nuw i32, ptr getelementptr inbounds nuw (i8, ptr @_DefaultRuneLocale, i64 60), i64 %54
  %56 = load i32, ptr %55, align 4, !tbaa !6
  %57 = and i32 %56, 16384
  br label %61

58:                                               ; preds = %49
  %59 = zext i8 %51 to i32
  %60 = call i32 @__maskrune(i32 noundef %59, i64 noundef 16384) #35
  br label %61

61:                                               ; preds = %53, %58
  %62 = phi i32 [ %57, %53 ], [ %60, %58 ]
  %63 = icmp eq i32 %62, 0
  br i1 %63, label %66, label %64

64:                                               ; preds = %61
  %65 = getelementptr inbounds nuw i8, ptr %50, i64 1
  store ptr %65, ptr %3, align 8, !tbaa !67
  br label %49, !llvm.loop !141

66:                                               ; preds = %61
  %67 = icmp ne ptr %50, %46
  %68 = icmp eq i8 %51, 0
  %69 = and i1 %67, %68
  br i1 %69, label %74, label %70

70:                                               ; preds = %66
  %71 = call i64 @rt_repr(i64 noundef %13)
  %72 = inttoptr i64 %71 to ptr
  %73 = getelementptr inbounds nuw i8, ptr %72, i64 16
  call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.25, ptr noundef nonnull @.str.77, ptr noundef nonnull %73) #36
  unreachable

74:                                               ; preds = %66
  %75 = call dereferenceable_or_null(16) ptr @calloc(i64 noundef 1, i64 noundef 16) #33
  %76 = icmp eq ptr %75, null
  br i1 %76, label %77, label %80

77:                                               ; preds = %74
  %78 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %79 = call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %78)
  call void @exit(i32 noundef 1) #34
  unreachable

80:                                               ; preds = %74
  store i64 3, ptr %75, align 8, !tbaa !19
  %81 = getelementptr inbounds nuw i8, ptr %75, i64 8
  store double %47, ptr %81, align 8, !tbaa !22
  call void @llvm.lifetime.end.p0(ptr nonnull %3) #35
  br label %83

82:                                               ; preds = %16, %43
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.78) #36
  unreachable

83:                                               ; preds = %41, %80, %11
  %84 = phi ptr [ %6, %11 ], [ %36, %41 ], [ %75, %80 ]
  %85 = ptrtoint ptr %84 to i64
  ret i64 %85
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @b_str(i64 noundef %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = icmp eq i64 %0, 0
  br i1 %3, label %7, label %4

4:                                                ; preds = %2
  %5 = load i64, ptr %1, align 8, !tbaa !11
  %6 = tail call i64 @rt_str(i64 noundef %5)
  br label %15

7:                                                ; preds = %2
  %8 = tail call dereferenceable_or_null(25) ptr @calloc(i64 noundef 1, i64 noundef 25) #33
  %9 = icmp eq ptr %8, null
  br i1 %9, label %10, label %13

10:                                               ; preds = %7
  %11 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %12 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %11)
  tail call void @exit(i32 noundef 1) #34
  unreachable

13:                                               ; preds = %7
  store i64 4, ptr %8, align 8, !tbaa !16
  %14 = ptrtoint ptr %8 to i64
  br label %15

15:                                               ; preds = %13, %4
  %16 = phi i64 [ %6, %4 ], [ %14, %13 ]
  ret i64 %16
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @b_bool(i64 noundef %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = icmp eq i64 %0, 0
  br i1 %3, label %12, label %4

4:                                                ; preds = %2
  %5 = load i64, ptr %1, align 8, !tbaa !11
  %6 = tail call i64 @rt_truthy(i64 noundef %5)
  %7 = and i64 %6, 4294967295
  %8 = icmp eq i64 %7, 0
  %9 = load i64, ptr @rt_true_v, align 8
  %10 = load i64, ptr @rt_false_v, align 8
  %11 = select i1 %8, i64 %10, i64 %9
  br label %14

12:                                               ; preds = %2
  %13 = load i64, ptr @rt_false_v, align 8, !tbaa !11
  br label %14

14:                                               ; preds = %12, %4
  %15 = phi i64 [ %11, %4 ], [ %13, %12 ]
  ret i64 %15
}

; Function Attrs: nounwind ssp uwtable(sync)
define noundef i64 @b_list(i64 noundef %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = icmp eq i64 %0, 0
  br i1 %3, label %22, label %4

4:                                                ; preds = %2
  %5 = load i64, ptr %1, align 8, !tbaa !11
  %6 = tail call fastcc i64 @as_list(i64 noundef %5)
  %7 = icmp eq i64 %6, %5
  br i1 %7, label %8, label %24

8:                                                ; preds = %4
  %9 = inttoptr i64 %5 to ptr
  %10 = getelementptr inbounds nuw i8, ptr %9, i64 8
  %11 = load i64, ptr %10, align 8, !tbaa !27
  %12 = tail call fastcc i64 @mklist(i64 noundef %11)
  %13 = inttoptr i64 %12 to ptr
  %14 = getelementptr inbounds nuw i8, ptr %13, i64 24
  %15 = load ptr, ptr %14, align 8, !tbaa !32
  %16 = getelementptr inbounds nuw i8, ptr %9, i64 24
  %17 = load ptr, ptr %16, align 8, !tbaa !32
  %18 = load i64, ptr %10, align 8, !tbaa !27
  %19 = shl i64 %18, 3
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %15, ptr noundef align 1 %17, i64 noundef %19, i1 noundef false) #35
  %20 = load i64, ptr %10, align 8, !tbaa !27
  %21 = getelementptr inbounds nuw i8, ptr %13, i64 8
  store i64 %20, ptr %21, align 8, !tbaa !27
  br label %24

22:                                               ; preds = %2
  %23 = tail call fastcc i64 @mklist(i64 noundef 0)
  br label %24

24:                                               ; preds = %8, %4, %22
  %25 = phi i64 [ %23, %22 ], [ %12, %8 ], [ %6, %4 ]
  ret i64 %25
}

; Function Attrs: nounwind ssp uwtable(sync)
define internal fastcc noundef i64 @list_copy(i64 noundef %0) unnamed_addr #2 {
  %2 = tail call fastcc i64 @as_list(i64 noundef %0)
  %3 = icmp eq i64 %2, %0
  br i1 %3, label %4, label %18

4:                                                ; preds = %1
  %5 = inttoptr i64 %0 to ptr
  %6 = getelementptr inbounds nuw i8, ptr %5, i64 8
  %7 = load i64, ptr %6, align 8, !tbaa !27
  %8 = tail call fastcc i64 @mklist(i64 noundef %7)
  %9 = inttoptr i64 %8 to ptr
  %10 = getelementptr inbounds nuw i8, ptr %9, i64 24
  %11 = load ptr, ptr %10, align 8, !tbaa !32
  %12 = getelementptr inbounds nuw i8, ptr %5, i64 24
  %13 = load ptr, ptr %12, align 8, !tbaa !32
  %14 = load i64, ptr %6, align 8, !tbaa !27
  %15 = shl i64 %14, 3
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %11, ptr noundef align 1 %13, i64 noundef %15, i1 noundef false) #35
  %16 = load i64, ptr %6, align 8, !tbaa !27
  %17 = getelementptr inbounds nuw i8, ptr %9, i64 8
  store i64 %16, ptr %17, align 8, !tbaa !27
  br label %18

18:                                               ; preds = %1, %4
  %19 = phi i64 [ %8, %4 ], [ %2, %1 ]
  ret i64 %19
}

; Function Attrs: nounwind ssp uwtable(sync)
define noundef i64 @b_tuple(i64 noundef %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = icmp eq i64 %0, 0
  br i1 %3, label %4, label %6

4:                                                ; preds = %2
  %5 = tail call fastcc i64 @mktuple(i64 noundef 0)
  br label %20

6:                                                ; preds = %2
  %7 = load i64, ptr %1, align 8, !tbaa !11
  %8 = tail call fastcc i64 @as_list(i64 noundef %7)
  %9 = inttoptr i64 %8 to ptr
  %10 = getelementptr inbounds nuw i8, ptr %9, i64 8
  %11 = load i64, ptr %10, align 8, !tbaa !27
  %12 = tail call fastcc i64 @mktuple(i64 noundef %11)
  %13 = inttoptr i64 %12 to ptr
  %14 = getelementptr inbounds nuw i8, ptr %13, i64 24
  %15 = load ptr, ptr %14, align 8, !tbaa !32
  %16 = getelementptr inbounds nuw i8, ptr %9, i64 24
  %17 = load ptr, ptr %16, align 8, !tbaa !32
  %18 = load i64, ptr %10, align 8, !tbaa !27
  %19 = shl i64 %18, 3
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %15, ptr noundef align 1 %17, i64 noundef %19, i1 noundef false) #35
  br label %20

20:                                               ; preds = %6, %4
  %21 = phi i64 [ %12, %6 ], [ %5, %4 ]
  ret i64 %21
}

; Function Attrs: nounwind ssp uwtable(sync)
define noundef i64 @b_dict(i64 noundef %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = tail call dereferenceable_or_null(56) ptr @calloc(i64 noundef 1, i64 noundef 56) #33
  %4 = icmp eq ptr %3, null
  br i1 %4, label %5, label %8

5:                                                ; preds = %2
  %6 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %7 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %6)
  tail call void @exit(i32 noundef 1) #34
  unreachable

8:                                                ; preds = %2
  store i64 7, ptr %3, align 8, !tbaa !68
  %9 = icmp eq i64 %0, 0
  br i1 %9, label %72, label %10

10:                                               ; preds = %8
  %11 = load i64, ptr %1, align 8, !tbaa !11
  %12 = and i64 %11, 1
  %13 = icmp ne i64 %12, 0
  %14 = icmp eq i64 %11, 0
  %15 = or i1 %14, %13
  br i1 %15, label %44, label %16

16:                                               ; preds = %10
  %17 = inttoptr i64 %11 to ptr
  %18 = load i64, ptr %17, align 8, !tbaa !23
  %19 = icmp eq i64 %18, 7
  br i1 %19, label %20, label %44

20:                                               ; preds = %16
  %21 = getelementptr inbounds nuw i8, ptr %17, i64 16
  %22 = load i64, ptr %21, align 8, !tbaa !35
  %23 = icmp sgt i64 %22, 0
  br i1 %23, label %24, label %72

24:                                               ; preds = %20, %37
  %25 = phi i64 [ %38, %37 ], [ %11, %20 ]
  %26 = phi ptr [ %40, %37 ], [ %17, %20 ]
  %27 = phi i64 [ %39, %37 ], [ 0, %20 ]
  %28 = getelementptr inbounds nuw i8, ptr %26, i64 32
  %29 = load ptr, ptr %28, align 8, !tbaa !36
  %30 = getelementptr inbounds nuw %struct.Ent, ptr %29, i64 %27
  %31 = load i64, ptr %30, align 8, !tbaa !37
  %32 = icmp eq i64 %31, 0
  br i1 %32, label %37, label %33

33:                                               ; preds = %24
  %34 = getelementptr inbounds nuw i8, ptr %30, i64 8
  %35 = load i64, ptr %34, align 8, !tbaa !42
  tail call fastcc void @dict_set(ptr noundef nonnull %3, i64 noundef %31, i64 noundef %35)
  %36 = load i64, ptr %1, align 8, !tbaa !11
  br label %37

37:                                               ; preds = %24, %33
  %38 = phi i64 [ %25, %24 ], [ %36, %33 ]
  %39 = add nuw nsw i64 %27, 1
  %40 = inttoptr i64 %38 to ptr
  %41 = getelementptr inbounds nuw i8, ptr %40, i64 16
  %42 = load i64, ptr %41, align 8, !tbaa !35
  %43 = icmp slt i64 %39, %42
  br i1 %43, label %24, label %72, !llvm.loop !142

44:                                               ; preds = %10, %16
  %45 = tail call fastcc i64 @as_list(i64 noundef %11)
  %46 = inttoptr i64 %45 to ptr
  %47 = getelementptr inbounds nuw i8, ptr %46, i64 8
  %48 = load i64, ptr %47, align 8, !tbaa !27
  %49 = icmp sgt i64 %48, 0
  br i1 %49, label %50, label %72

50:                                               ; preds = %44
  %51 = getelementptr inbounds nuw i8, ptr %46, i64 24
  br label %52

52:                                               ; preds = %50, %63
  %53 = phi i64 [ 0, %50 ], [ %69, %63 ]
  %54 = load ptr, ptr %51, align 8, !tbaa !32
  %55 = getelementptr inbounds nuw i64, ptr %54, i64 %53
  %56 = load i64, ptr %55, align 8, !tbaa !11
  %57 = tail call fastcc i64 @as_list(i64 noundef %56)
  %58 = inttoptr i64 %57 to ptr
  %59 = getelementptr inbounds nuw i8, ptr %58, i64 8
  %60 = load i64, ptr %59, align 8, !tbaa !27
  %61 = icmp eq i64 %60, 2
  br i1 %61, label %63, label %62

62:                                               ; preds = %52
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.25, ptr noundef nonnull @.str.80) #36
  unreachable

63:                                               ; preds = %52
  %64 = getelementptr inbounds nuw i8, ptr %58, i64 24
  %65 = load ptr, ptr %64, align 8, !tbaa !32
  %66 = load i64, ptr %65, align 8, !tbaa !11
  %67 = getelementptr inbounds nuw i8, ptr %65, i64 8
  %68 = load i64, ptr %67, align 8, !tbaa !11
  tail call fastcc void @dict_set(ptr noundef nonnull %3, i64 noundef %66, i64 noundef %68)
  %69 = add nuw nsw i64 %53, 1
  %70 = load i64, ptr %47, align 8, !tbaa !27
  %71 = icmp slt i64 %69, %70
  br i1 %71, label %52, label %72, !llvm.loop !143

72:                                               ; preds = %37, %63, %20, %44, %8
  %73 = ptrtoint ptr %3 to i64
  ret i64 %73
}

; Function Attrs: nounwind ssp uwtable(sync)
define noundef i64 @b_set(i64 noundef %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = tail call dereferenceable_or_null(56) ptr @calloc(i64 noundef 1, i64 noundef 56) #33
  %4 = icmp eq ptr %3, null
  br i1 %4, label %5, label %8

5:                                                ; preds = %2
  %6 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %7 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %6)
  tail call void @exit(i32 noundef 1) #34
  unreachable

8:                                                ; preds = %2
  store i64 8, ptr %3, align 8, !tbaa !68
  %9 = icmp eq i64 %0, 0
  br i1 %9, label %28, label %10

10:                                               ; preds = %8
  %11 = load i64, ptr %1, align 8, !tbaa !11
  %12 = tail call fastcc i64 @as_list(i64 noundef %11)
  %13 = inttoptr i64 %12 to ptr
  %14 = getelementptr inbounds nuw i8, ptr %13, i64 8
  %15 = load i64, ptr %14, align 8, !tbaa !27
  %16 = icmp sgt i64 %15, 0
  br i1 %16, label %17, label %28

17:                                               ; preds = %10
  %18 = getelementptr inbounds nuw i8, ptr %13, i64 24
  br label %19

19:                                               ; preds = %17, %19
  %20 = phi i64 [ 0, %17 ], [ %25, %19 ]
  %21 = load ptr, ptr %18, align 8, !tbaa !32
  %22 = getelementptr inbounds nuw i64, ptr %21, i64 %20
  %23 = load i64, ptr %22, align 8, !tbaa !11
  %24 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  tail call fastcc void @dict_set(ptr noundef nonnull %3, i64 noundef %23, i64 noundef %24)
  %25 = add nuw nsw i64 %20, 1
  %26 = load i64, ptr %14, align 8, !tbaa !27
  %27 = icmp slt i64 %25, %26
  br i1 %27, label %19, label %28, !llvm.loop !144

28:                                               ; preds = %19, %10, %8
  %29 = ptrtoint ptr %3 to i64
  ret i64 %29
}

; Function Attrs: nofree nosync nounwind ssp memory(read, inaccessiblemem: none, target_mem0: none, target_mem1: none) uwtable(sync)
define i64 @b_isinstance(i64 %0, ptr noundef readonly captures(none) %1) #11 {
  %3 = load i64, ptr %1, align 8, !tbaa !11
  %4 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %5 = load i64, ptr %4, align 8, !tbaa !11
  %6 = tail call fastcc i64 @isinst1(i64 noundef %3, i64 noundef %5)
  %7 = icmp eq i64 %6, 0
  %8 = load i64, ptr @rt_true_v, align 8
  %9 = load i64, ptr @rt_false_v, align 8
  %10 = select i1 %7, i64 %9, i64 %8
  ret i64 %10
}

; Function Attrs: nofree nosync nounwind ssp memory(read, inaccessiblemem: none, target_mem0: none, target_mem1: none) uwtable(sync)
define internal fastcc range(i64 0, 2) i64 @isinst1(i64 noundef %0, i64 noundef %1) unnamed_addr #11 {
  %3 = and i64 %1, 1
  %4 = icmp ne i64 %3, 0
  %5 = icmp eq i64 %1, 0
  %6 = or i1 %5, %4
  br i1 %6, label %100, label %7

7:                                                ; preds = %2
  %8 = inttoptr i64 %1 to ptr
  %9 = load i64, ptr %8, align 8, !tbaa !23
  switch i64 %9, label %100 [
    i64 6, label %10
    i64 11, label %26
    i64 10, label %56
  ]

10:                                               ; preds = %7
  %11 = getelementptr inbounds nuw i8, ptr %8, i64 8
  %12 = load i64, ptr %11, align 8, !tbaa !27
  %13 = icmp sgt i64 %12, 0
  br i1 %13, label %14, label %100

14:                                               ; preds = %10
  %15 = getelementptr inbounds nuw i8, ptr %8, i64 24
  %16 = load ptr, ptr %15, align 8, !tbaa !32
  br label %17

17:                                               ; preds = %17, %14
  %18 = phi i64 [ 0, %14 ], [ %23, %17 ]
  %19 = getelementptr inbounds nuw i64, ptr %16, i64 %18
  %20 = load i64, ptr %19, align 8, !tbaa !11
  %21 = tail call fastcc i64 @isinst1(i64 noundef %0, i64 noundef %20)
  %22 = icmp ne i64 %21, 0
  %23 = add nuw nsw i64 %18, 1
  %24 = icmp eq i64 %23, %12
  %25 = select i1 %22, i1 true, i1 %24
  br i1 %25, label %100, label %17, !llvm.loop !145

26:                                               ; preds = %7
  %27 = and i64 %0, 1
  %28 = icmp ne i64 %27, 0
  %29 = icmp eq i64 %0, 0
  %30 = or i1 %29, %28
  br i1 %30, label %100, label %31

31:                                               ; preds = %26
  %32 = inttoptr i64 %0 to ptr
  %33 = load i64, ptr %32, align 8, !tbaa !23
  %34 = icmp eq i64 %33, 12
  br i1 %34, label %35, label %100

35:                                               ; preds = %31
  %36 = getelementptr inbounds nuw i8, ptr %32, i64 8
  %37 = load i64, ptr %36, align 8, !tbaa !11
  %38 = icmp ne i64 %37, 0
  %39 = and i64 %37, 1
  %40 = icmp eq i64 %39, 0
  %41 = and i1 %38, %40
  br i1 %41, label %42, label %100

42:                                               ; preds = %35, %49
  %43 = phi i64 [ %51, %49 ], [ %37, %35 ]
  %44 = inttoptr i64 %43 to ptr
  %45 = load i64, ptr %44, align 8, !tbaa !23
  %46 = icmp eq i64 %45, 11
  br i1 %46, label %47, label %100

47:                                               ; preds = %42
  %48 = icmp eq i64 %43, %1
  br i1 %48, label %100, label %49

49:                                               ; preds = %47
  %50 = getelementptr inbounds nuw i8, ptr %44, i64 16
  %51 = load i64, ptr %50, align 8, !tbaa !11
  %52 = icmp ne i64 %51, 0
  %53 = and i64 %51, 1
  %54 = icmp eq i64 %53, 0
  %55 = and i1 %52, %54
  br i1 %55, label %42, label %100, !llvm.loop !65

56:                                               ; preds = %7
  %57 = getelementptr inbounds nuw i8, ptr %8, i64 8
  %58 = load ptr, ptr %57, align 8, !tbaa !57
  %59 = and i64 %0, 1
  %60 = icmp eq i64 %59, 0
  br i1 %60, label %61, label %66

61:                                               ; preds = %56
  %62 = icmp eq i64 %0, 0
  br i1 %62, label %66, label %63

63:                                               ; preds = %61
  %64 = inttoptr i64 %0 to ptr
  %65 = load i64, ptr %64, align 8, !tbaa !23
  br label %66

66:                                               ; preds = %56, %61, %63
  %67 = phi i64 [ 0, %56 ], [ %65, %63 ], [ -1, %61 ]
  %68 = icmp eq ptr %58, @b_int
  br i1 %68, label %69, label %72

69:                                               ; preds = %66
  %70 = and i64 %67, -3
  %71 = icmp eq i64 %70, 0
  br label %100

72:                                               ; preds = %66
  %73 = icmp eq ptr %58, @b_float
  br i1 %73, label %74, label %76

74:                                               ; preds = %72
  %75 = icmp eq i64 %67, 3
  br label %100

76:                                               ; preds = %72
  %77 = icmp eq ptr %58, @b_str
  br i1 %77, label %78, label %80

78:                                               ; preds = %76
  %79 = icmp eq i64 %67, 4
  br label %100

80:                                               ; preds = %76
  %81 = icmp eq ptr %58, @b_bool
  br i1 %81, label %82, label %84

82:                                               ; preds = %80
  %83 = icmp eq i64 %67, 2
  br label %100

84:                                               ; preds = %80
  %85 = icmp eq ptr %58, @b_list
  br i1 %85, label %86, label %88

86:                                               ; preds = %84
  %87 = icmp eq i64 %67, 5
  br label %100

88:                                               ; preds = %84
  %89 = icmp eq ptr %58, @b_tuple
  br i1 %89, label %90, label %92

90:                                               ; preds = %88
  %91 = icmp eq i64 %67, 6
  br label %100

92:                                               ; preds = %88
  %93 = icmp eq ptr %58, @b_dict
  br i1 %93, label %94, label %96

94:                                               ; preds = %92
  %95 = icmp eq i64 %67, 7
  br label %100

96:                                               ; preds = %92
  %97 = icmp eq ptr %58, @b_set
  %98 = icmp eq i64 %67, 8
  %99 = select i1 %97, i1 %98, i1 false
  br label %100

100:                                              ; preds = %49, %47, %42, %17, %7, %10, %96, %94, %90, %86, %82, %78, %74, %69, %2, %35, %31, %26
  %101 = phi i1 [ %71, %69 ], [ %91, %90 ], [ %83, %82 ], [ %79, %78 ], [ false, %31 ], [ false, %26 ], [ false, %35 ], [ %87, %86 ], [ false, %10 ], [ %99, %96 ], [ false, %7 ], [ false, %2 ], [ %75, %74 ], [ %95, %94 ], [ %22, %17 ], [ true, %47 ], [ false, %49 ], [ false, %42 ]
  %102 = zext i1 %101 to i64
  ret i64 %102
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @b_abs(i64 %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = load i64, ptr %1, align 8, !tbaa !11
  %4 = and i64 %3, 1
  %5 = icmp eq i64 %4, 0
  br i1 %5, label %15, label %6

6:                                                ; preds = %2
  %7 = ashr i64 %3, 1
  %8 = icmp slt i64 %7, 0
  br i1 %8, label %9, label %38

9:                                                ; preds = %6
  %10 = icmp samesign ult i64 %7, -4611686018427387903
  br i1 %10, label %11, label %12

11:                                               ; preds = %9
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.7, ptr noundef nonnull @.str.131) #36
  unreachable

12:                                               ; preds = %9
  %13 = and i64 %3, -2
  %14 = sub nsw i64 1, %13
  br label %38

15:                                               ; preds = %2
  %16 = icmp eq i64 %3, 0
  br i1 %16, label %37, label %17

17:                                               ; preds = %15
  %18 = inttoptr i64 %3 to ptr
  %19 = load i64, ptr %18, align 8, !tbaa !23
  switch i64 %19, label %37 [
    i64 3, label %20
    i64 2, label %32
  ]

20:                                               ; preds = %17
  %21 = getelementptr inbounds nuw i8, ptr %18, i64 8
  %22 = load double, ptr %21, align 8, !tbaa !22
  %23 = tail call dereferenceable_or_null(16) ptr @calloc(i64 noundef 1, i64 noundef 16) #33
  %24 = icmp eq ptr %23, null
  br i1 %24, label %25, label %28

25:                                               ; preds = %20
  %26 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %27 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %26)
  tail call void @exit(i32 noundef 1) #34
  unreachable

28:                                               ; preds = %20
  %29 = tail call double @llvm.fabs.f64(double %22)
  store i64 3, ptr %23, align 8, !tbaa !19
  %30 = getelementptr inbounds nuw i8, ptr %23, i64 8
  store double %29, ptr %30, align 8, !tbaa !22
  %31 = ptrtoint ptr %23 to i64
  br label %38

32:                                               ; preds = %17
  %33 = getelementptr inbounds nuw i8, ptr %18, i64 8
  %34 = load i64, ptr %33, align 8, !tbaa !25
  %35 = shl nsw i64 %34, 1
  %36 = or disjoint i64 %35, 1
  br label %38

37:                                               ; preds = %17, %15
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.81) #36
  unreachable

38:                                               ; preds = %12, %6, %32, %28
  %39 = phi i64 [ %36, %32 ], [ %31, %28 ], [ %14, %12 ], [ %3, %6 ]
  ret i64 %39
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @b_min(i64 noundef %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = icmp eq i64 %0, 1
  br i1 %3, label %4, label %12

4:                                                ; preds = %2
  %5 = load i64, ptr %1, align 8, !tbaa !11
  %6 = tail call fastcc i64 @as_list(i64 noundef %5)
  %7 = inttoptr i64 %6 to ptr
  %8 = getelementptr inbounds nuw i8, ptr %7, i64 24
  %9 = load ptr, ptr %8, align 8, !tbaa !32
  %10 = getelementptr inbounds nuw i8, ptr %7, i64 8
  %11 = load i64, ptr %10, align 8, !tbaa !27
  br label %12

12:                                               ; preds = %4, %2
  %13 = phi i64 [ %11, %4 ], [ %0, %2 ]
  %14 = phi ptr [ %9, %4 ], [ %1, %2 ]
  %15 = icmp eq i64 %13, 0
  br i1 %15, label %16, label %17

16:                                               ; preds = %12
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.25, ptr noundef nonnull @.str.190) #36
  unreachable

17:                                               ; preds = %12
  %18 = load i64, ptr %14, align 8, !tbaa !11
  %19 = icmp sgt i64 %13, 1
  br i1 %19, label %20, label %33

20:                                               ; preds = %17, %29
  %21 = phi i64 [ %31, %29 ], [ 1, %17 ]
  %22 = phi i64 [ %30, %29 ], [ %18, %17 ]
  %23 = getelementptr inbounds nuw i64, ptr %14, i64 %21
  %24 = load i64, ptr %23, align 8, !tbaa !11
  %25 = tail call fastcc i32 @cmp_v(i64 noundef %24, i64 noundef %22)
  %26 = icmp slt i32 %25, 0
  br i1 %26, label %27, label %29

27:                                               ; preds = %20
  %28 = load i64, ptr %23, align 8, !tbaa !11
  br label %29

29:                                               ; preds = %27, %20
  %30 = phi i64 [ %28, %27 ], [ %22, %20 ]
  %31 = add nuw nsw i64 %21, 1
  %32 = icmp eq i64 %31, %13
  br i1 %32, label %33, label %20, !llvm.loop !146

33:                                               ; preds = %29, %17
  %34 = phi i64 [ %18, %17 ], [ %30, %29 ]
  ret i64 %34
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @b_max(i64 noundef %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = icmp eq i64 %0, 1
  br i1 %3, label %4, label %12

4:                                                ; preds = %2
  %5 = load i64, ptr %1, align 8, !tbaa !11
  %6 = tail call fastcc i64 @as_list(i64 noundef %5)
  %7 = inttoptr i64 %6 to ptr
  %8 = getelementptr inbounds nuw i8, ptr %7, i64 24
  %9 = load ptr, ptr %8, align 8, !tbaa !32
  %10 = getelementptr inbounds nuw i8, ptr %7, i64 8
  %11 = load i64, ptr %10, align 8, !tbaa !27
  br label %12

12:                                               ; preds = %4, %2
  %13 = phi i64 [ %11, %4 ], [ %0, %2 ]
  %14 = phi ptr [ %9, %4 ], [ %1, %2 ]
  %15 = icmp eq i64 %13, 0
  br i1 %15, label %16, label %17

16:                                               ; preds = %12
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.25, ptr noundef nonnull @.str.190) #36
  unreachable

17:                                               ; preds = %12
  %18 = load i64, ptr %14, align 8, !tbaa !11
  %19 = icmp sgt i64 %13, 1
  br i1 %19, label %20, label %33

20:                                               ; preds = %17, %29
  %21 = phi i64 [ %31, %29 ], [ 1, %17 ]
  %22 = phi i64 [ %30, %29 ], [ %18, %17 ]
  %23 = getelementptr inbounds nuw i64, ptr %14, i64 %21
  %24 = load i64, ptr %23, align 8, !tbaa !11
  %25 = tail call fastcc i32 @cmp_v(i64 noundef %24, i64 noundef %22)
  %26 = icmp sgt i32 %25, 0
  br i1 %26, label %27, label %29

27:                                               ; preds = %20
  %28 = load i64, ptr %23, align 8, !tbaa !11
  br label %29

29:                                               ; preds = %27, %20
  %30 = phi i64 [ %28, %27 ], [ %22, %20 ]
  %31 = add nuw nsw i64 %21, 1
  %32 = icmp eq i64 %31, %13
  br i1 %32, label %33, label %20, !llvm.loop !146

33:                                               ; preds = %29, %17
  %34 = phi i64 [ %18, %17 ], [ %30, %29 ]
  ret i64 %34
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @b_sum(i64 noundef %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = load i64, ptr %1, align 8, !tbaa !11
  %4 = tail call fastcc i64 @as_list(i64 noundef %3)
  %5 = icmp sgt i64 %0, 1
  br i1 %5, label %6, label %9

6:                                                ; preds = %2
  %7 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %8 = load i64, ptr %7, align 8, !tbaa !11
  br label %9

9:                                                ; preds = %2, %6
  %10 = phi i64 [ %8, %6 ], [ 1, %2 ]
  %11 = inttoptr i64 %4 to ptr
  %12 = getelementptr inbounds nuw i8, ptr %11, i64 8
  %13 = load i64, ptr %12, align 8, !tbaa !27
  %14 = icmp sgt i64 %13, 0
  br i1 %14, label %15, label %17

15:                                               ; preds = %9
  %16 = getelementptr inbounds nuw i8, ptr %11, i64 24
  br label %19

17:                                               ; preds = %19, %9
  %18 = phi i64 [ %10, %9 ], [ %25, %19 ]
  ret i64 %18

19:                                               ; preds = %15, %19
  %20 = phi i64 [ 0, %15 ], [ %26, %19 ]
  %21 = phi i64 [ %10, %15 ], [ %25, %19 ]
  %22 = load ptr, ptr %16, align 8, !tbaa !32
  %23 = getelementptr inbounds nuw i64, ptr %22, i64 %20
  %24 = load i64, ptr %23, align 8, !tbaa !11
  %25 = tail call i64 @rt_add(i64 noundef %21, i64 noundef %24)
  %26 = add nuw nsw i64 %20, 1
  %27 = load i64, ptr %12, align 8, !tbaa !27
  %28 = icmp slt i64 %26, %27
  br i1 %28, label %19, label %17, !llvm.loop !147
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @b_round(i64 noundef %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = alloca [512 x i8], align 1
  %4 = load i64, ptr %1, align 8, !tbaa !11
  %5 = and i64 %4, 1
  %6 = icmp eq i64 %5, 0
  br i1 %6, label %10, label %7

7:                                                ; preds = %2
  %8 = ashr i64 %4, 1
  %9 = sitofp i64 %8 to double
  br label %23

10:                                               ; preds = %2
  %11 = icmp eq i64 %4, 0
  br i1 %11, label %22, label %12

12:                                               ; preds = %10
  %13 = inttoptr i64 %4 to ptr
  %14 = load i64, ptr %13, align 8, !tbaa !23
  switch i64 %14, label %22 [
    i64 2, label %15
    i64 3, label %19
  ]

15:                                               ; preds = %12
  %16 = getelementptr inbounds nuw i8, ptr %13, i64 8
  %17 = load i64, ptr %16, align 8, !tbaa !25
  %18 = sitofp i64 %17 to double
  br label %23

19:                                               ; preds = %12
  %20 = getelementptr inbounds nuw i8, ptr %13, i64 8
  %21 = load double, ptr %20, align 8, !tbaa !22
  br label %23

22:                                               ; preds = %12, %10
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.108) #36
  unreachable

23:                                               ; preds = %7, %15, %19
  %24 = phi double [ %9, %7 ], [ %18, %15 ], [ %21, %19 ]
  %25 = icmp sgt i64 %0, 1
  br i1 %25, label %26, label %61

26:                                               ; preds = %23
  %27 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %28 = load i64, ptr %27, align 8, !tbaa !11
  %29 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  %30 = icmp eq i64 %28, %29
  br i1 %30, label %61, label %31

31:                                               ; preds = %26
  %32 = and i64 %28, 1
  %33 = icmp eq i64 %32, 0
  br i1 %33, label %36, label %34

34:                                               ; preds = %31
  %35 = ashr i64 %28, 1
  br label %46

36:                                               ; preds = %31
  %37 = icmp eq i64 %28, 0
  br i1 %37, label %45, label %38

38:                                               ; preds = %36
  %39 = inttoptr i64 %28 to ptr
  %40 = load i64, ptr %39, align 8, !tbaa !23
  %41 = icmp eq i64 %40, 2
  br i1 %41, label %42, label %45

42:                                               ; preds = %38
  %43 = getelementptr inbounds nuw i8, ptr %39, i64 8
  %44 = load i64, ptr %43, align 8, !tbaa !25
  br label %46

45:                                               ; preds = %38, %36
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

46:                                               ; preds = %34, %42
  %47 = phi i64 [ %35, %34 ], [ %44, %42 ]
  %48 = tail call i64 @llvm.smax.i64(i64 %47, i64 0)
  %49 = tail call i64 @llvm.umin.i64(i64 %48, i64 300)
  call void @llvm.lifetime.start.p0(ptr nonnull %3) #35
  %50 = trunc nuw nsw i64 %49 to i32
  %51 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr nonnull dereferenceable(1) %3, i64 512, ptr nonnull @.str.82, i32 %50, double %24)
  %52 = call double @"\01_strtod"(ptr noundef nonnull %3, ptr noundef null) #35
  %53 = call dereferenceable_or_null(16) ptr @calloc(i64 noundef 1, i64 noundef 16) #33
  %54 = icmp eq ptr %53, null
  br i1 %54, label %55, label %58

55:                                               ; preds = %46
  %56 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %57 = call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %56)
  call void @exit(i32 noundef 1) #34
  unreachable

58:                                               ; preds = %46
  store i64 3, ptr %53, align 8, !tbaa !19
  %59 = getelementptr inbounds nuw i8, ptr %53, i64 8
  store double %52, ptr %59, align 8, !tbaa !22
  %60 = ptrtoint ptr %53 to i64
  call void @llvm.lifetime.end.p0(ptr nonnull %3) #35
  br label %70

61:                                               ; preds = %26, %23
  %62 = tail call double @llvm.rint.f64(double %24)
  %63 = fptosi double %62 to i64
  %64 = add i64 %63, -4611686018427387904
  %65 = icmp sgt i64 %64, -1
  br i1 %65, label %66, label %67

66:                                               ; preds = %61
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.7, ptr noundef nonnull @.str.131) #36
  unreachable

67:                                               ; preds = %61
  %68 = shl nsw i64 %63, 1
  %69 = or disjoint i64 %68, 1
  br label %70

70:                                               ; preds = %67, %58
  %71 = phi i64 [ %60, %58 ], [ %69, %67 ]
  ret i64 %71
}

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.rint.f64(double) #13

; Function Attrs: nounwind ssp uwtable(sync)
define noundef i64 @b_sorted(i64 %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = load i64, ptr %1, align 8, !tbaa !11
  %4 = tail call fastcc i64 @as_list(i64 noundef %3)
  %5 = icmp eq i64 %4, %3
  br i1 %5, label %10, label %6

6:                                                ; preds = %2
  %7 = inttoptr i64 %4 to ptr
  %8 = getelementptr inbounds nuw i8, ptr %7, i64 8
  %9 = load i64, ptr %8, align 8, !tbaa !27
  br label %24

10:                                               ; preds = %2
  %11 = inttoptr i64 %3 to ptr
  %12 = getelementptr inbounds nuw i8, ptr %11, i64 8
  %13 = load i64, ptr %12, align 8, !tbaa !27
  %14 = tail call fastcc i64 @mklist(i64 noundef %13)
  %15 = inttoptr i64 %14 to ptr
  %16 = getelementptr inbounds nuw i8, ptr %15, i64 24
  %17 = load ptr, ptr %16, align 8, !tbaa !32
  %18 = getelementptr inbounds nuw i8, ptr %11, i64 24
  %19 = load ptr, ptr %18, align 8, !tbaa !32
  %20 = load i64, ptr %12, align 8, !tbaa !27
  %21 = shl i64 %20, 3
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %17, ptr noundef align 1 %19, i64 noundef %21, i1 noundef false) #35
  %22 = load i64, ptr %12, align 8, !tbaa !27
  %23 = getelementptr inbounds nuw i8, ptr %15, i64 8
  store i64 %22, ptr %23, align 8, !tbaa !27
  br label %24

24:                                               ; preds = %6, %10
  %25 = phi ptr [ %7, %6 ], [ %15, %10 ]
  %26 = phi i64 [ %9, %6 ], [ %22, %10 ]
  %27 = phi i64 [ %4, %6 ], [ %14, %10 ]
  %28 = tail call i64 @llvm.umax.i64(i64 %26, i64 1)
  %29 = shl i64 %28, 3
  %30 = tail call i64 @llvm.umax.i64(i64 %29, i64 1)
  %31 = tail call ptr @calloc(i64 noundef 1, i64 noundef %30) #33
  %32 = icmp eq ptr %31, null
  br i1 %32, label %33, label %36

33:                                               ; preds = %24
  %34 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %35 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %34)
  tail call void @exit(i32 noundef 1) #34
  unreachable

36:                                               ; preds = %24
  %37 = getelementptr inbounds nuw i8, ptr %25, i64 24
  %38 = load ptr, ptr %37, align 8, !tbaa !32
  tail call fastcc void @msort(ptr noundef %38, ptr noundef %31, i64 noundef %26)
  ret i64 %27
}

; Function Attrs: nounwind ssp uwtable(sync)
define internal fastcc void @list_sort(i64 noundef %0) unnamed_addr #2 {
  %2 = inttoptr i64 %0 to ptr
  %3 = getelementptr inbounds nuw i8, ptr %2, i64 8
  %4 = load i64, ptr %3, align 8, !tbaa !27
  %5 = tail call i64 @llvm.umax.i64(i64 %4, i64 1)
  %6 = shl i64 %5, 3
  %7 = tail call i64 @llvm.umax.i64(i64 %6, i64 1)
  %8 = tail call ptr @calloc(i64 noundef 1, i64 noundef %7) #33
  %9 = icmp eq ptr %8, null
  br i1 %9, label %10, label %13

10:                                               ; preds = %1
  %11 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %12 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %11)
  tail call void @exit(i32 noundef 1) #34
  unreachable

13:                                               ; preds = %1
  %14 = getelementptr inbounds nuw i8, ptr %2, i64 24
  %15 = load ptr, ptr %14, align 8, !tbaa !32
  tail call fastcc void @msort(ptr noundef %15, ptr noundef %8, i64 noundef %4)
  ret void
}

; Function Attrs: nounwind ssp uwtable(sync)
define noundef i64 @b_reversed(i64 %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = load i64, ptr %1, align 8, !tbaa !11
  %4 = tail call fastcc i64 @as_list(i64 noundef %3)
  %5 = icmp eq i64 %4, %3
  br i1 %5, label %10, label %6

6:                                                ; preds = %2
  %7 = inttoptr i64 %4 to ptr
  %8 = getelementptr inbounds nuw i8, ptr %7, i64 8
  %9 = load i64, ptr %8, align 8, !tbaa !27
  br label %24

10:                                               ; preds = %2
  %11 = inttoptr i64 %3 to ptr
  %12 = getelementptr inbounds nuw i8, ptr %11, i64 8
  %13 = load i64, ptr %12, align 8, !tbaa !27
  %14 = tail call fastcc i64 @mklist(i64 noundef %13)
  %15 = inttoptr i64 %14 to ptr
  %16 = getelementptr inbounds nuw i8, ptr %15, i64 24
  %17 = load ptr, ptr %16, align 8, !tbaa !32
  %18 = getelementptr inbounds nuw i8, ptr %11, i64 24
  %19 = load ptr, ptr %18, align 8, !tbaa !32
  %20 = load i64, ptr %12, align 8, !tbaa !27
  %21 = shl i64 %20, 3
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %17, ptr noundef align 1 %19, i64 noundef %21, i1 noundef false) #35
  %22 = load i64, ptr %12, align 8, !tbaa !27
  %23 = getelementptr inbounds nuw i8, ptr %15, i64 8
  store i64 %22, ptr %23, align 8, !tbaa !27
  br label %24

24:                                               ; preds = %6, %10
  %25 = phi ptr [ %7, %6 ], [ %15, %10 ]
  %26 = phi i64 [ %9, %6 ], [ %22, %10 ]
  %27 = phi i64 [ %4, %6 ], [ %14, %10 ]
  %28 = icmp sgt i64 %26, 1
  br i1 %28, label %29, label %33

29:                                               ; preds = %24
  %30 = add nsw i64 %26, -1
  %31 = getelementptr inbounds nuw i8, ptr %25, i64 24
  %32 = load ptr, ptr %31, align 8, !tbaa !32
  br label %34

33:                                               ; preds = %34, %24
  ret i64 %27

34:                                               ; preds = %29, %34
  %35 = phi i64 [ %30, %29 ], [ %42, %34 ]
  %36 = phi i64 [ 0, %29 ], [ %41, %34 ]
  %37 = getelementptr inbounds nuw i64, ptr %32, i64 %36
  %38 = load i64, ptr %37, align 8, !tbaa !11
  %39 = getelementptr inbounds i64, ptr %32, i64 %35
  %40 = load i64, ptr %39, align 8, !tbaa !11
  store i64 %40, ptr %37, align 8, !tbaa !11
  store i64 %38, ptr %39, align 8, !tbaa !11
  %41 = add nuw nsw i64 %36, 1
  %42 = add nsw i64 %35, -1
  %43 = icmp slt i64 %41, %42
  br i1 %43, label %34, label %33, !llvm.loop !148
}

; Function Attrs: nounwind ssp uwtable(sync)
define noundef i64 @b_enumerate(i64 noundef %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = load i64, ptr %1, align 8, !tbaa !11
  %4 = tail call fastcc i64 @as_list(i64 noundef %3)
  %5 = icmp sgt i64 %0, 1
  br i1 %5, label %6, label %23

6:                                                ; preds = %2
  %7 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %8 = load i64, ptr %7, align 8, !tbaa !11
  %9 = and i64 %8, 1
  %10 = icmp eq i64 %9, 0
  br i1 %10, label %13, label %11

11:                                               ; preds = %6
  %12 = ashr i64 %8, 1
  br label %23

13:                                               ; preds = %6
  %14 = icmp eq i64 %8, 0
  br i1 %14, label %22, label %15

15:                                               ; preds = %13
  %16 = inttoptr i64 %8 to ptr
  %17 = load i64, ptr %16, align 8, !tbaa !23
  %18 = icmp eq i64 %17, 2
  br i1 %18, label %19, label %22

19:                                               ; preds = %15
  %20 = getelementptr inbounds nuw i8, ptr %16, i64 8
  %21 = load i64, ptr %20, align 8, !tbaa !25
  br label %23

22:                                               ; preds = %15, %13
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

23:                                               ; preds = %19, %11, %2
  %24 = phi i64 [ 0, %2 ], [ %12, %11 ], [ %21, %19 ]
  %25 = inttoptr i64 %4 to ptr
  %26 = getelementptr inbounds nuw i8, ptr %25, i64 8
  %27 = load i64, ptr %26, align 8, !tbaa !27
  %28 = tail call fastcc i64 @mklist(i64 noundef %27)
  %29 = load i64, ptr %26, align 8, !tbaa !27
  %30 = icmp sgt i64 %29, 0
  br i1 %30, label %31, label %37

31:                                               ; preds = %23
  %32 = getelementptr inbounds nuw i8, ptr %25, i64 24
  %33 = inttoptr i64 %28 to ptr
  %34 = getelementptr inbounds nuw i8, ptr %33, i64 8
  %35 = getelementptr inbounds nuw i8, ptr %33, i64 16
  %36 = getelementptr inbounds nuw i8, ptr %33, i64 24
  br label %38

37:                                               ; preds = %62, %23
  ret i64 %28

38:                                               ; preds = %31, %62
  %39 = phi i64 [ 0, %31 ], [ %67, %62 ]
  %40 = add nsw i64 %39, %24
  %41 = shl nsw i64 %40, 1
  %42 = or disjoint i64 %41, 1
  %43 = load ptr, ptr %32, align 8, !tbaa !32
  %44 = getelementptr inbounds nuw i64, ptr %43, i64 %39
  %45 = load i64, ptr %44, align 8, !tbaa !11
  %46 = tail call fastcc i64 @mktuple(i64 noundef 2)
  %47 = inttoptr i64 %46 to ptr
  %48 = getelementptr inbounds nuw i8, ptr %47, i64 24
  %49 = load ptr, ptr %48, align 8, !tbaa !32
  store i64 %42, ptr %49, align 8, !tbaa !11
  %50 = getelementptr inbounds nuw i8, ptr %49, i64 8
  store i64 %45, ptr %50, align 8, !tbaa !11
  %51 = load i64, ptr %34, align 8, !tbaa !27
  %52 = load i64, ptr %35, align 8, !tbaa !70
  %53 = icmp slt i64 %51, %52
  br i1 %53, label %54, label %56

54:                                               ; preds = %38
  %55 = load ptr, ptr %36, align 8, !tbaa !32
  br label %62

56:                                               ; preds = %38
  %57 = shl nsw i64 %52, 1
  store i64 %57, ptr %35, align 8, !tbaa !70
  %58 = load ptr, ptr %36, align 8, !tbaa !32
  %59 = shl i64 %52, 4
  %60 = tail call ptr @realloc(ptr noundef %58, i64 noundef %59) #38
  store ptr %60, ptr %36, align 8, !tbaa !32
  %61 = load i64, ptr %34, align 8, !tbaa !27
  br label %62

62:                                               ; preds = %54, %56
  %63 = phi i64 [ %51, %54 ], [ %61, %56 ]
  %64 = phi ptr [ %55, %54 ], [ %60, %56 ]
  %65 = add nsw i64 %63, 1
  store i64 %65, ptr %34, align 8, !tbaa !27
  %66 = getelementptr inbounds i64, ptr %64, i64 %63
  store i64 %46, ptr %66, align 8, !tbaa !11
  %67 = add nuw nsw i64 %39, 1
  %68 = load i64, ptr %26, align 8, !tbaa !27
  %69 = icmp slt i64 %67, %68
  br i1 %69, label %38, label %37, !llvm.loop !149
}

; Function Attrs: nounwind ssp uwtable(sync)
define noundef i64 @b_zip(i64 noundef %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = icmp eq i64 %0, 0
  br i1 %3, label %4, label %6

4:                                                ; preds = %2
  %5 = tail call fastcc i64 @mklist(i64 noundef 0)
  br label %106

6:                                                ; preds = %2
  %7 = tail call ptr @llvm.stacksave.p0()
  %8 = alloca i64, i64 %0, align 8
  %9 = icmp sgt i64 %0, 0
  br i1 %9, label %25, label %10

10:                                               ; preds = %6
  %11 = tail call fastcc i64 @mklist(i64 noundef -1)
  br label %45

12:                                               ; preds = %41
  %13 = tail call fastcc i64 @mklist(i64 noundef %42)
  %14 = icmp sgt i64 %42, 0
  br i1 %14, label %15, label %45

15:                                               ; preds = %12
  %16 = inttoptr i64 %13 to ptr
  %17 = getelementptr inbounds nuw i8, ptr %16, i64 8
  %18 = getelementptr inbounds nuw i8, ptr %16, i64 16
  %19 = getelementptr inbounds nuw i8, ptr %16, i64 24
  %20 = and i64 %0, 1
  %21 = icmp eq i64 %0, 1
  %22 = and i64 %0, 9223372036854775806
  %23 = icmp eq i64 %20, 0
  %24 = icmp ne i64 %20, 0
  br label %47

25:                                               ; preds = %6, %41
  %26 = phi i64 [ %42, %41 ], [ -1, %6 ]
  %27 = phi i64 [ %43, %41 ], [ 0, %6 ]
  %28 = getelementptr inbounds nuw i64, ptr %1, i64 %27
  %29 = load i64, ptr %28, align 8, !tbaa !11
  %30 = tail call fastcc i64 @as_list(i64 noundef %29)
  %31 = getelementptr inbounds nuw i64, ptr %8, i64 %27
  store i64 %30, ptr %31, align 8, !tbaa !11
  %32 = icmp slt i64 %26, 0
  %33 = inttoptr i64 %30 to ptr
  br i1 %32, label %38, label %34

34:                                               ; preds = %25
  %35 = getelementptr inbounds nuw i8, ptr %33, i64 8
  %36 = load i64, ptr %35, align 8, !tbaa !27
  %37 = icmp slt i64 %36, %26
  br i1 %37, label %38, label %41

38:                                               ; preds = %25, %34
  %39 = getelementptr inbounds nuw i8, ptr %33, i64 8
  %40 = load i64, ptr %39, align 8, !tbaa !27
  br label %41

41:                                               ; preds = %34, %38
  %42 = phi i64 [ %40, %38 ], [ %26, %34 ]
  %43 = add nuw nsw i64 %27, 1
  %44 = icmp eq i64 %43, %0
  br i1 %44, label %12, label %25, !llvm.loop !150

45:                                               ; preds = %76, %10, %12
  %46 = phi i64 [ %11, %10 ], [ %13, %12 ], [ %13, %76 ]
  call void @llvm.stackrestore.p0(ptr %7)
  br label %106

47:                                               ; preds = %15, %76
  %48 = phi i64 [ 0, %15 ], [ %81, %76 ]
  %49 = tail call fastcc i64 @mktuple(i64 noundef %0)
  %50 = inttoptr i64 %49 to ptr
  %51 = getelementptr inbounds nuw i8, ptr %50, i64 24
  %52 = load ptr, ptr %51, align 8, !tbaa !32
  br i1 %21, label %54, label %83

53:                                               ; preds = %83
  br i1 %23, label %64, label %54

54:                                               ; preds = %53, %47
  %55 = phi i64 [ 0, %47 ], [ %103, %53 ]
  tail call void @llvm.assume(i1 %24)
  %56 = getelementptr inbounds nuw i64, ptr %8, i64 %55
  %57 = load i64, ptr %56, align 8, !tbaa !11
  %58 = inttoptr i64 %57 to ptr
  %59 = getelementptr inbounds nuw i8, ptr %58, i64 24
  %60 = load ptr, ptr %59, align 8, !tbaa !32
  %61 = getelementptr inbounds nuw i64, ptr %60, i64 %48
  %62 = load i64, ptr %61, align 8, !tbaa !11
  %63 = getelementptr inbounds nuw i64, ptr %52, i64 %55
  store i64 %62, ptr %63, align 8, !tbaa !11
  br label %64

64:                                               ; preds = %53, %54
  %65 = load i64, ptr %17, align 8, !tbaa !27
  %66 = load i64, ptr %18, align 8, !tbaa !70
  %67 = icmp slt i64 %65, %66
  br i1 %67, label %68, label %70

68:                                               ; preds = %64
  %69 = load ptr, ptr %19, align 8, !tbaa !32
  br label %76

70:                                               ; preds = %64
  %71 = shl nsw i64 %66, 1
  store i64 %71, ptr %18, align 8, !tbaa !70
  %72 = load ptr, ptr %19, align 8, !tbaa !32
  %73 = shl i64 %66, 4
  %74 = tail call ptr @realloc(ptr noundef %72, i64 noundef %73) #38
  store ptr %74, ptr %19, align 8, !tbaa !32
  %75 = load i64, ptr %17, align 8, !tbaa !27
  br label %76

76:                                               ; preds = %68, %70
  %77 = phi i64 [ %65, %68 ], [ %75, %70 ]
  %78 = phi ptr [ %69, %68 ], [ %74, %70 ]
  %79 = add nsw i64 %77, 1
  store i64 %79, ptr %17, align 8, !tbaa !27
  %80 = getelementptr inbounds i64, ptr %78, i64 %77
  store i64 %49, ptr %80, align 8, !tbaa !11
  %81 = add nuw nsw i64 %48, 1
  %82 = icmp eq i64 %81, %42
  br i1 %82, label %45, label %47, !llvm.loop !151

83:                                               ; preds = %47, %83
  %84 = phi i64 [ %103, %83 ], [ 0, %47 ]
  %85 = phi i64 [ %104, %83 ], [ 0, %47 ]
  %86 = getelementptr inbounds nuw i64, ptr %8, i64 %84
  %87 = load i64, ptr %86, align 8, !tbaa !11
  %88 = inttoptr i64 %87 to ptr
  %89 = getelementptr inbounds nuw i8, ptr %88, i64 24
  %90 = load ptr, ptr %89, align 8, !tbaa !32
  %91 = getelementptr inbounds nuw i64, ptr %90, i64 %48
  %92 = load i64, ptr %91, align 8, !tbaa !11
  %93 = getelementptr inbounds nuw i64, ptr %52, i64 %84
  store i64 %92, ptr %93, align 8, !tbaa !11
  %94 = or disjoint i64 %84, 1
  %95 = getelementptr inbounds nuw i64, ptr %8, i64 %94
  %96 = load i64, ptr %95, align 8, !tbaa !11
  %97 = inttoptr i64 %96 to ptr
  %98 = getelementptr inbounds nuw i8, ptr %97, i64 24
  %99 = load ptr, ptr %98, align 8, !tbaa !32
  %100 = getelementptr inbounds nuw i64, ptr %99, i64 %48
  %101 = load i64, ptr %100, align 8, !tbaa !11
  %102 = getelementptr inbounds nuw i64, ptr %52, i64 %94
  store i64 %101, ptr %102, align 8, !tbaa !11
  %103 = add nuw nsw i64 %84, 2
  %104 = add i64 %85, 2
  %105 = icmp eq i64 %104, %22
  br i1 %105, label %53, label %83, !llvm.loop !152

106:                                              ; preds = %45, %4
  %107 = phi i64 [ %5, %4 ], [ %46, %45 ]
  ret i64 %107
}

; Function Attrs: nounwind ssp uwtable(sync)
define noundef i64 @b_map(i64 %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = alloca [1 x i64], align 8
  %4 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %5 = load i64, ptr %4, align 8, !tbaa !11
  %6 = tail call fastcc i64 @as_list(i64 noundef %5)
  %7 = inttoptr i64 %6 to ptr
  %8 = getelementptr inbounds nuw i8, ptr %7, i64 8
  %9 = load i64, ptr %8, align 8, !tbaa !27
  %10 = tail call fastcc i64 @mklist(i64 noundef %9)
  %11 = load i64, ptr %8, align 8, !tbaa !27
  %12 = icmp sgt i64 %11, 0
  br i1 %12, label %13, label %19

13:                                               ; preds = %2
  %14 = getelementptr inbounds nuw i8, ptr %7, i64 24
  %15 = inttoptr i64 %10 to ptr
  %16 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %17 = getelementptr inbounds nuw i8, ptr %15, i64 16
  %18 = getelementptr inbounds nuw i8, ptr %15, i64 24
  br label %20

19:                                               ; preds = %38, %2
  ret i64 %10

20:                                               ; preds = %13, %38
  %21 = phi i64 [ 0, %13 ], [ %43, %38 ]
  call void @llvm.lifetime.start.p0(ptr nonnull %3) #35
  %22 = load ptr, ptr %14, align 8, !tbaa !32
  %23 = getelementptr inbounds nuw i64, ptr %22, i64 %21
  %24 = load i64, ptr %23, align 8, !tbaa !11
  store i64 %24, ptr %3, align 8, !tbaa !11
  %25 = load i64, ptr %1, align 8, !tbaa !11
  %26 = call i64 @rt_call(i64 noundef %25, i64 noundef 1, ptr noundef nonnull %3)
  %27 = load i64, ptr %16, align 8, !tbaa !27
  %28 = load i64, ptr %17, align 8, !tbaa !70
  %29 = icmp slt i64 %27, %28
  br i1 %29, label %30, label %32

30:                                               ; preds = %20
  %31 = load ptr, ptr %18, align 8, !tbaa !32
  br label %38

32:                                               ; preds = %20
  %33 = shl nsw i64 %28, 1
  store i64 %33, ptr %17, align 8, !tbaa !70
  %34 = load ptr, ptr %18, align 8, !tbaa !32
  %35 = shl i64 %28, 4
  %36 = call ptr @realloc(ptr noundef %34, i64 noundef %35) #38
  store ptr %36, ptr %18, align 8, !tbaa !32
  %37 = load i64, ptr %16, align 8, !tbaa !27
  br label %38

38:                                               ; preds = %30, %32
  %39 = phi i64 [ %27, %30 ], [ %37, %32 ]
  %40 = phi ptr [ %31, %30 ], [ %36, %32 ]
  %41 = add nsw i64 %39, 1
  store i64 %41, ptr %16, align 8, !tbaa !27
  %42 = getelementptr inbounds i64, ptr %40, i64 %39
  store i64 %26, ptr %42, align 8, !tbaa !11
  call void @llvm.lifetime.end.p0(ptr nonnull %3) #35
  %43 = add nuw nsw i64 %21, 1
  %44 = load i64, ptr %8, align 8, !tbaa !27
  %45 = icmp slt i64 %43, %44
  br i1 %45, label %20, label %19, !llvm.loop !153
}

; Function Attrs: nounwind ssp uwtable(sync)
define noundef i64 @b_filter(i64 %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = alloca [1 x i64], align 8
  %4 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %5 = load i64, ptr %4, align 8, !tbaa !11
  %6 = tail call fastcc i64 @as_list(i64 noundef %5)
  %7 = tail call fastcc i64 @mklist(i64 noundef 4)
  %8 = inttoptr i64 %6 to ptr
  %9 = getelementptr inbounds nuw i8, ptr %8, i64 8
  %10 = load i64, ptr %9, align 8, !tbaa !27
  %11 = icmp sgt i64 %10, 0
  br i1 %11, label %12, label %18

12:                                               ; preds = %2
  %13 = getelementptr inbounds nuw i8, ptr %8, i64 24
  %14 = inttoptr i64 %7 to ptr
  %15 = getelementptr inbounds nuw i8, ptr %14, i64 8
  %16 = getelementptr inbounds nuw i8, ptr %14, i64 16
  %17 = getelementptr inbounds nuw i8, ptr %14, i64 24
  br label %19

18:                                               ; preds = %51, %2
  ret i64 %7

19:                                               ; preds = %12, %51
  %20 = phi i64 [ 0, %12 ], [ %52, %51 ]
  call void @llvm.lifetime.start.p0(ptr nonnull %3) #35
  %21 = load ptr, ptr %13, align 8, !tbaa !32
  %22 = getelementptr inbounds nuw i64, ptr %21, i64 %20
  %23 = load i64, ptr %22, align 8, !tbaa !11
  store i64 %23, ptr %3, align 8, !tbaa !11
  %24 = load i64, ptr %1, align 8, !tbaa !11
  %25 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  %26 = icmp eq i64 %24, %25
  br i1 %26, label %29, label %27

27:                                               ; preds = %19
  %28 = call i64 @rt_call(i64 noundef %24, i64 noundef 1, ptr noundef nonnull %3)
  br label %29

29:                                               ; preds = %19, %27
  %30 = phi i64 [ %28, %27 ], [ %23, %19 ]
  %31 = call i64 @rt_truthy(i64 noundef %30)
  %32 = icmp eq i64 %31, 0
  br i1 %32, label %51, label %33

33:                                               ; preds = %29
  %34 = load i64, ptr %3, align 8, !tbaa !11
  %35 = load i64, ptr %15, align 8, !tbaa !27
  %36 = load i64, ptr %16, align 8, !tbaa !70
  %37 = icmp slt i64 %35, %36
  br i1 %37, label %38, label %40

38:                                               ; preds = %33
  %39 = load ptr, ptr %17, align 8, !tbaa !32
  br label %46

40:                                               ; preds = %33
  %41 = shl nsw i64 %36, 1
  store i64 %41, ptr %16, align 8, !tbaa !70
  %42 = load ptr, ptr %17, align 8, !tbaa !32
  %43 = shl i64 %36, 4
  %44 = call ptr @realloc(ptr noundef %42, i64 noundef %43) #38
  store ptr %44, ptr %17, align 8, !tbaa !32
  %45 = load i64, ptr %15, align 8, !tbaa !27
  br label %46

46:                                               ; preds = %38, %40
  %47 = phi i64 [ %35, %38 ], [ %45, %40 ]
  %48 = phi ptr [ %39, %38 ], [ %44, %40 ]
  %49 = add nsw i64 %47, 1
  store i64 %49, ptr %15, align 8, !tbaa !27
  %50 = getelementptr inbounds i64, ptr %48, i64 %47
  store i64 %34, ptr %50, align 8, !tbaa !11
  br label %51

51:                                               ; preds = %46, %29
  call void @llvm.lifetime.end.p0(ptr nonnull %3) #35
  %52 = add nuw nsw i64 %20, 1
  %53 = load i64, ptr %9, align 8, !tbaa !27
  %54 = icmp slt i64 %52, %53
  br i1 %54, label %19, label %18, !llvm.loop !154
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @b_any(i64 %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = load i64, ptr %1, align 8, !tbaa !11
  %4 = tail call fastcc i64 @as_list(i64 noundef %3)
  %5 = inttoptr i64 %4 to ptr
  %6 = getelementptr inbounds nuw i8, ptr %5, i64 8
  %7 = load i64, ptr %6, align 8, !tbaa !27
  %8 = icmp sgt i64 %7, 0
  br i1 %8, label %9, label %22

9:                                                ; preds = %2
  %10 = getelementptr inbounds nuw i8, ptr %5, i64 24
  br label %15

11:                                               ; preds = %15
  %12 = add nuw nsw i64 %16, 1
  %13 = load i64, ptr %6, align 8, !tbaa !27
  %14 = icmp slt i64 %12, %13
  br i1 %14, label %15, label %22, !llvm.loop !155

15:                                               ; preds = %9, %11
  %16 = phi i64 [ 0, %9 ], [ %12, %11 ]
  %17 = load ptr, ptr %10, align 8, !tbaa !32
  %18 = getelementptr inbounds nuw i64, ptr %17, i64 %16
  %19 = load i64, ptr %18, align 8, !tbaa !11
  %20 = tail call i64 @rt_truthy(i64 noundef %19)
  %21 = icmp eq i64 %20, 0
  br i1 %21, label %11, label %22

22:                                               ; preds = %15, %11, %2
  %23 = phi ptr [ @rt_false_v, %2 ], [ @rt_false_v, %11 ], [ @rt_true_v, %15 ]
  %24 = load i64, ptr %23, align 8
  ret i64 %24
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @b_all(i64 %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = load i64, ptr %1, align 8, !tbaa !11
  %4 = tail call fastcc i64 @as_list(i64 noundef %3)
  %5 = inttoptr i64 %4 to ptr
  %6 = getelementptr inbounds nuw i8, ptr %5, i64 8
  %7 = load i64, ptr %6, align 8, !tbaa !27
  %8 = icmp sgt i64 %7, 0
  br i1 %8, label %9, label %22

9:                                                ; preds = %2
  %10 = getelementptr inbounds nuw i8, ptr %5, i64 24
  br label %15

11:                                               ; preds = %15
  %12 = add nuw nsw i64 %16, 1
  %13 = load i64, ptr %6, align 8, !tbaa !27
  %14 = icmp slt i64 %12, %13
  br i1 %14, label %15, label %22, !llvm.loop !156

15:                                               ; preds = %9, %11
  %16 = phi i64 [ 0, %9 ], [ %12, %11 ]
  %17 = load ptr, ptr %10, align 8, !tbaa !32
  %18 = getelementptr inbounds nuw i64, ptr %17, i64 %16
  %19 = load i64, ptr %18, align 8, !tbaa !11
  %20 = tail call i64 @rt_truthy(i64 noundef %19)
  %21 = icmp eq i64 %20, 0
  br i1 %21, label %22, label %11

22:                                               ; preds = %15, %11, %2
  %23 = phi ptr [ @rt_true_v, %2 ], [ @rt_true_v, %11 ], [ @rt_false_v, %15 ]
  %24 = load i64, ptr %23, align 8
  ret i64 %24
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @b_chr(i64 %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = load i64, ptr %1, align 8, !tbaa !11
  %4 = and i64 %3, 1
  %5 = icmp eq i64 %4, 0
  br i1 %5, label %8, label %6

6:                                                ; preds = %2
  %7 = ashr i64 %3, 1
  br label %18

8:                                                ; preds = %2
  %9 = icmp eq i64 %3, 0
  br i1 %9, label %17, label %10

10:                                               ; preds = %8
  %11 = inttoptr i64 %3 to ptr
  %12 = load i64, ptr %11, align 8, !tbaa !23
  %13 = icmp eq i64 %12, 2
  br i1 %13, label %14, label %17

14:                                               ; preds = %10
  %15 = getelementptr inbounds nuw i8, ptr %11, i64 8
  %16 = load i64, ptr %15, align 8, !tbaa !25
  br label %18

17:                                               ; preds = %10, %8
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

18:                                               ; preds = %6, %14
  %19 = phi i64 [ %7, %6 ], [ %16, %14 ]
  %20 = trunc i64 %19 to i8
  %21 = and i64 %19, 255
  %22 = getelementptr inbounds nuw i64, ptr @char_cache, i64 %21
  %23 = load i64, ptr %22, align 8, !tbaa !11
  %24 = icmp eq i64 %23, 0
  br i1 %24, label %25, label %34

25:                                               ; preds = %18
  %26 = tail call dereferenceable_or_null(26) ptr @calloc(i64 noundef 1, i64 noundef 26) #33
  %27 = icmp eq ptr %26, null
  br i1 %27, label %28, label %31

28:                                               ; preds = %25
  %29 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %30 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %29)
  tail call void @exit(i32 noundef 1) #34
  unreachable

31:                                               ; preds = %25
  store <2 x i64> <i64 4, i64 1>, ptr %26, align 8, !tbaa !11
  %32 = getelementptr inbounds nuw i8, ptr %26, i64 16
  store i8 %20, ptr %32, align 8
  %33 = ptrtoint ptr %26 to i64
  store i64 %33, ptr %22, align 8, !tbaa !11
  br label %34

34:                                               ; preds = %18, %31
  %35 = phi i64 [ %23, %18 ], [ %33, %31 ]
  ret i64 %35
}

; Function Attrs: nounwind ssp uwtable(sync)
define range(i64 1, 512) i64 @b_ord(i64 %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = load i64, ptr %1, align 8, !tbaa !11
  %4 = and i64 %3, 1
  %5 = icmp ne i64 %4, 0
  %6 = icmp eq i64 %3, 0
  %7 = or i1 %6, %5
  br i1 %7, label %16, label %8

8:                                                ; preds = %2
  %9 = inttoptr i64 %3 to ptr
  %10 = load i64, ptr %9, align 8, !tbaa !23
  %11 = icmp eq i64 %10, 4
  br i1 %11, label %12, label %16

12:                                               ; preds = %8
  %13 = getelementptr inbounds nuw i8, ptr %9, i64 8
  %14 = load i64, ptr %13, align 8, !tbaa !18
  %15 = icmp eq i64 %14, 1
  br i1 %15, label %17, label %16

16:                                               ; preds = %2, %12, %8
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.83) #36
  unreachable

17:                                               ; preds = %12
  %18 = getelementptr inbounds nuw i8, ptr %9, i64 16
  %19 = load i8, ptr %18, align 8, !tbaa !10
  %20 = zext i8 %19 to i64
  %21 = shl nuw nsw i64 %20, 1
  %22 = or disjoint i64 %21, 1
  ret i64 %22
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @b_hex(i64 %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = alloca [96 x i8], align 1
  %4 = alloca [80 x i8], align 1
  %5 = load i64, ptr %1, align 8, !tbaa !11
  %6 = and i64 %5, 1
  %7 = icmp eq i64 %6, 0
  %8 = getelementptr inbounds nuw i8, ptr %3, i64 1
  %9 = getelementptr inbounds nuw i8, ptr %3, i64 1
  br i1 %7, label %12, label %10

10:                                               ; preds = %2
  %11 = ashr i64 %5, 1
  br label %22

12:                                               ; preds = %2
  %13 = icmp eq i64 %5, 0
  br i1 %13, label %21, label %14

14:                                               ; preds = %12
  %15 = inttoptr i64 %5 to ptr
  %16 = load i64, ptr %15, align 8, !tbaa !23
  %17 = icmp eq i64 %16, 2
  br i1 %17, label %18, label %21

18:                                               ; preds = %14
  %19 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %20 = load i64, ptr %19, align 8, !tbaa !25
  br label %22

21:                                               ; preds = %14, %12
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

22:                                               ; preds = %10, %18
  %23 = phi i64 [ %11, %10 ], [ %20, %18 ]
  call void @llvm.lifetime.start.p0(ptr nonnull %3) #35
  %24 = icmp slt i64 %23, 0
  call void @llvm.lifetime.start.p0(ptr nonnull %4) #35
  %25 = icmp eq i64 %23, 0
  br i1 %25, label %26, label %27

26:                                               ; preds = %22
  store i8 48, ptr %4, align 1, !tbaa !10
  br label %44

27:                                               ; preds = %22
  %28 = tail call i64 @llvm.abs.i64(i64 %23, i1 true)
  br label %29

29:                                               ; preds = %29, %27
  %30 = phi i64 [ 0, %27 ], [ %38, %29 ]
  %31 = phi i64 [ %28, %27 ], [ %40, %29 ]
  %32 = and i64 %31, 15
  %33 = trunc nuw nsw i64 %32 to i8
  %34 = icmp samesign ult i64 %32, 10
  %35 = or disjoint i8 %33, 48
  %36 = add nuw nsw i8 %33, 87
  %37 = select i1 %34, i8 %35, i8 %36
  %38 = add nuw nsw i64 %30, 1
  %39 = getelementptr inbounds nuw i8, ptr %4, i64 %30
  store i8 %37, ptr %39, align 1, !tbaa !10
  %40 = lshr i64 %31, 4
  %41 = icmp samesign ult i64 %31, 16
  br i1 %41, label %42, label %29, !llvm.loop !157

42:                                               ; preds = %29
  br i1 %24, label %43, label %44

43:                                               ; preds = %42
  store i8 45, ptr %3, align 1, !tbaa !10
  br label %44

44:                                               ; preds = %43, %42, %26
  %45 = phi i64 [ %38, %43 ], [ %38, %42 ], [ 1, %26 ]
  %46 = phi ptr [ %8, %43 ], [ %3, %42 ], [ %3, %26 ]
  %47 = phi ptr [ %9, %43 ], [ %3, %42 ], [ %3, %26 ]
  %48 = phi i64 [ 3, %43 ], [ 2, %42 ], [ 2, %26 ]
  store i8 48, ptr %46, align 1, !tbaa !10
  %49 = getelementptr inbounds nuw i8, ptr %47, i64 1
  store i8 120, ptr %49, align 1, !tbaa !10
  %50 = shl i64 %45, 32
  %51 = ashr exact i64 %50, 32
  %52 = icmp ult i64 %45, 32
  br i1 %52, label %80, label %53

53:                                               ; preds = %44
  %54 = and i64 %45, -32
  %55 = sub i64 %51, %54
  %56 = or disjoint i64 %48, %54
  %57 = getelementptr i8, ptr %4, i64 %51
  %58 = getelementptr i8, ptr %57, i64 -16
  %59 = getelementptr i8, ptr %57, i64 -32
  %60 = load <16 x i8>, ptr %58, align 1, !tbaa !10
  %61 = load <16 x i8>, ptr %59, align 1, !tbaa !10
  %62 = shufflevector <16 x i8> %60, <16 x i8> poison, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %63 = shufflevector <16 x i8> %61, <16 x i8> poison, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %64 = getelementptr inbounds nuw i8, ptr %3, i64 %48
  %65 = getelementptr inbounds nuw i8, ptr %64, i64 16
  store <16 x i8> %62, ptr %64, align 1, !tbaa !10
  store <16 x i8> %63, ptr %65, align 1, !tbaa !10
  %66 = icmp eq i64 %54, 32
  br i1 %66, label %78, label %67, !llvm.loop !158

67:                                               ; preds = %53
  %68 = getelementptr i8, ptr %4, i64 %51
  %69 = getelementptr i8, ptr %68, i64 -48
  %70 = getelementptr i8, ptr %68, i64 -64
  %71 = load <16 x i8>, ptr %69, align 1, !tbaa !10
  %72 = load <16 x i8>, ptr %70, align 1, !tbaa !10
  %73 = shufflevector <16 x i8> %71, <16 x i8> poison, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %74 = shufflevector <16 x i8> %72, <16 x i8> poison, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %75 = getelementptr inbounds nuw i8, ptr %3, i64 %48
  %76 = getelementptr inbounds nuw i8, ptr %75, i64 32
  %77 = getelementptr inbounds nuw i8, ptr %75, i64 48
  store <16 x i8> %73, ptr %76, align 1, !tbaa !10
  store <16 x i8> %74, ptr %77, align 1, !tbaa !10
  br label %78

78:                                               ; preds = %67, %53
  %79 = icmp eq i64 %45, %54
  br i1 %79, label %92, label %80

80:                                               ; preds = %44, %78
  %81 = phi i64 [ %51, %44 ], [ %55, %78 ]
  %82 = phi i64 [ %48, %44 ], [ %56, %78 ]
  br label %83

83:                                               ; preds = %80, %83
  %84 = phi i64 [ %86, %83 ], [ %81, %80 ]
  %85 = phi i64 [ %89, %83 ], [ %82, %80 ]
  %86 = add nsw i64 %84, -1
  %87 = getelementptr inbounds i8, ptr %4, i64 %86
  %88 = load i8, ptr %87, align 1, !tbaa !10
  %89 = add nuw nsw i64 %85, 1
  %90 = getelementptr inbounds nuw i8, ptr %3, i64 %85
  store i8 %88, ptr %90, align 1, !tbaa !10
  %91 = icmp eq i64 %86, 0
  br i1 %91, label %92, label %83, !llvm.loop !159

92:                                               ; preds = %83, %78
  %93 = phi i64 [ %56, %78 ], [ %89, %83 ]
  %94 = and i64 %93, 4294967295
  %95 = getelementptr inbounds nuw i8, ptr %3, i64 %94
  store i8 0, ptr %95, align 1, !tbaa !10
  %96 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %3) #35
  %97 = call fastcc i64 @mkstr(ptr noundef nonnull readonly %3, i64 noundef %96)
  call void @llvm.lifetime.end.p0(ptr nonnull %4) #35
  call void @llvm.lifetime.end.p0(ptr nonnull %3) #35
  ret i64 %97
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @b_oct(i64 %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = alloca [96 x i8], align 1
  %4 = alloca [80 x i8], align 1
  %5 = load i64, ptr %1, align 8, !tbaa !11
  %6 = and i64 %5, 1
  %7 = icmp eq i64 %6, 0
  %8 = getelementptr inbounds nuw i8, ptr %3, i64 1
  %9 = getelementptr inbounds nuw i8, ptr %3, i64 1
  br i1 %7, label %12, label %10

10:                                               ; preds = %2
  %11 = ashr i64 %5, 1
  br label %22

12:                                               ; preds = %2
  %13 = icmp eq i64 %5, 0
  br i1 %13, label %21, label %14

14:                                               ; preds = %12
  %15 = inttoptr i64 %5 to ptr
  %16 = load i64, ptr %15, align 8, !tbaa !23
  %17 = icmp eq i64 %16, 2
  br i1 %17, label %18, label %21

18:                                               ; preds = %14
  %19 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %20 = load i64, ptr %19, align 8, !tbaa !25
  br label %22

21:                                               ; preds = %14, %12
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

22:                                               ; preds = %10, %18
  %23 = phi i64 [ %11, %10 ], [ %20, %18 ]
  call void @llvm.lifetime.start.p0(ptr nonnull %3) #35
  %24 = icmp slt i64 %23, 0
  call void @llvm.lifetime.start.p0(ptr nonnull %4) #35
  %25 = icmp eq i64 %23, 0
  br i1 %25, label %26, label %27

26:                                               ; preds = %22
  store i8 48, ptr %4, align 1, !tbaa !10
  br label %41

27:                                               ; preds = %22
  %28 = tail call i64 @llvm.abs.i64(i64 %23, i1 true)
  br label %29

29:                                               ; preds = %29, %27
  %30 = phi i64 [ 0, %27 ], [ %35, %29 ]
  %31 = phi i64 [ %28, %27 ], [ %37, %29 ]
  %32 = trunc i64 %31 to i8
  %33 = and i8 %32, 7
  %34 = or disjoint i8 %33, 48
  %35 = add nuw nsw i64 %30, 1
  %36 = getelementptr inbounds nuw i8, ptr %4, i64 %30
  store i8 %34, ptr %36, align 1, !tbaa !10
  %37 = lshr i64 %31, 3
  %38 = icmp samesign ult i64 %31, 8
  br i1 %38, label %39, label %29, !llvm.loop !157

39:                                               ; preds = %29
  br i1 %24, label %40, label %41

40:                                               ; preds = %39
  store i8 45, ptr %3, align 1, !tbaa !10
  br label %41

41:                                               ; preds = %40, %39, %26
  %42 = phi i64 [ %35, %40 ], [ %35, %39 ], [ 1, %26 ]
  %43 = phi ptr [ %8, %40 ], [ %3, %39 ], [ %3, %26 ]
  %44 = phi ptr [ %9, %40 ], [ %3, %39 ], [ %3, %26 ]
  %45 = phi i64 [ 3, %40 ], [ 2, %39 ], [ 2, %26 ]
  store i8 48, ptr %43, align 1, !tbaa !10
  %46 = getelementptr inbounds nuw i8, ptr %44, i64 1
  store i8 111, ptr %46, align 1, !tbaa !10
  %47 = shl i64 %42, 32
  %48 = ashr exact i64 %47, 32
  %49 = icmp ult i64 %42, 32
  br i1 %49, label %77, label %50

50:                                               ; preds = %41
  %51 = and i64 %42, -32
  %52 = sub i64 %48, %51
  %53 = or disjoint i64 %45, %51
  %54 = getelementptr i8, ptr %4, i64 %48
  %55 = getelementptr i8, ptr %54, i64 -16
  %56 = getelementptr i8, ptr %54, i64 -32
  %57 = load <16 x i8>, ptr %55, align 1, !tbaa !10
  %58 = load <16 x i8>, ptr %56, align 1, !tbaa !10
  %59 = shufflevector <16 x i8> %57, <16 x i8> poison, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %60 = shufflevector <16 x i8> %58, <16 x i8> poison, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %61 = getelementptr inbounds nuw i8, ptr %3, i64 %45
  %62 = getelementptr inbounds nuw i8, ptr %61, i64 16
  store <16 x i8> %59, ptr %61, align 1, !tbaa !10
  store <16 x i8> %60, ptr %62, align 1, !tbaa !10
  %63 = icmp eq i64 %51, 32
  br i1 %63, label %75, label %64, !llvm.loop !160

64:                                               ; preds = %50
  %65 = getelementptr i8, ptr %4, i64 %48
  %66 = getelementptr i8, ptr %65, i64 -48
  %67 = getelementptr i8, ptr %65, i64 -64
  %68 = load <16 x i8>, ptr %66, align 1, !tbaa !10
  %69 = load <16 x i8>, ptr %67, align 1, !tbaa !10
  %70 = shufflevector <16 x i8> %68, <16 x i8> poison, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %71 = shufflevector <16 x i8> %69, <16 x i8> poison, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %72 = getelementptr inbounds nuw i8, ptr %3, i64 %45
  %73 = getelementptr inbounds nuw i8, ptr %72, i64 32
  %74 = getelementptr inbounds nuw i8, ptr %72, i64 48
  store <16 x i8> %70, ptr %73, align 1, !tbaa !10
  store <16 x i8> %71, ptr %74, align 1, !tbaa !10
  br label %75

75:                                               ; preds = %64, %50
  %76 = icmp eq i64 %42, %51
  br i1 %76, label %89, label %77

77:                                               ; preds = %41, %75
  %78 = phi i64 [ %48, %41 ], [ %52, %75 ]
  %79 = phi i64 [ %45, %41 ], [ %53, %75 ]
  br label %80

80:                                               ; preds = %77, %80
  %81 = phi i64 [ %83, %80 ], [ %78, %77 ]
  %82 = phi i64 [ %86, %80 ], [ %79, %77 ]
  %83 = add nsw i64 %81, -1
  %84 = getelementptr inbounds i8, ptr %4, i64 %83
  %85 = load i8, ptr %84, align 1, !tbaa !10
  %86 = add nuw nsw i64 %82, 1
  %87 = getelementptr inbounds nuw i8, ptr %3, i64 %82
  store i8 %85, ptr %87, align 1, !tbaa !10
  %88 = icmp eq i64 %83, 0
  br i1 %88, label %89, label %80, !llvm.loop !161

89:                                               ; preds = %80, %75
  %90 = phi i64 [ %53, %75 ], [ %86, %80 ]
  %91 = and i64 %90, 4294967295
  %92 = getelementptr inbounds nuw i8, ptr %3, i64 %91
  store i8 0, ptr %92, align 1, !tbaa !10
  %93 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %3) #35
  %94 = call fastcc i64 @mkstr(ptr noundef nonnull readonly %3, i64 noundef %93)
  call void @llvm.lifetime.end.p0(ptr nonnull %4) #35
  call void @llvm.lifetime.end.p0(ptr nonnull %3) #35
  ret i64 %94
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @b_bin(i64 %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = alloca [96 x i8], align 1
  %4 = alloca [80 x i8], align 1
  %5 = load i64, ptr %1, align 8, !tbaa !11
  %6 = and i64 %5, 1
  %7 = icmp eq i64 %6, 0
  %8 = getelementptr inbounds nuw i8, ptr %3, i64 1
  %9 = getelementptr inbounds nuw i8, ptr %3, i64 1
  br i1 %7, label %12, label %10

10:                                               ; preds = %2
  %11 = ashr i64 %5, 1
  br label %22

12:                                               ; preds = %2
  %13 = icmp eq i64 %5, 0
  br i1 %13, label %21, label %14

14:                                               ; preds = %12
  %15 = inttoptr i64 %5 to ptr
  %16 = load i64, ptr %15, align 8, !tbaa !23
  %17 = icmp eq i64 %16, 2
  br i1 %17, label %18, label %21

18:                                               ; preds = %14
  %19 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %20 = load i64, ptr %19, align 8, !tbaa !25
  br label %22

21:                                               ; preds = %14, %12
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

22:                                               ; preds = %10, %18
  %23 = phi i64 [ %11, %10 ], [ %20, %18 ]
  call void @llvm.lifetime.start.p0(ptr nonnull %3) #35
  %24 = icmp slt i64 %23, 0
  call void @llvm.lifetime.start.p0(ptr nonnull %4) #35
  %25 = icmp eq i64 %23, 0
  br i1 %25, label %26, label %27

26:                                               ; preds = %22
  store i8 48, ptr %4, align 1, !tbaa !10
  br label %41

27:                                               ; preds = %22
  %28 = tail call i64 @llvm.abs.i64(i64 %23, i1 true)
  br label %29

29:                                               ; preds = %29, %27
  %30 = phi i64 [ 0, %27 ], [ %35, %29 ]
  %31 = phi i64 [ %28, %27 ], [ %37, %29 ]
  %32 = trunc i64 %31 to i8
  %33 = and i8 %32, 1
  %34 = or disjoint i8 %33, 48
  %35 = add nuw nsw i64 %30, 1
  %36 = getelementptr inbounds nuw i8, ptr %4, i64 %30
  store i8 %34, ptr %36, align 1, !tbaa !10
  %37 = lshr i64 %31, 1
  %38 = icmp samesign ult i64 %31, 2
  br i1 %38, label %39, label %29, !llvm.loop !157

39:                                               ; preds = %29
  br i1 %24, label %40, label %41

40:                                               ; preds = %39
  store i8 45, ptr %3, align 1, !tbaa !10
  br label %41

41:                                               ; preds = %40, %39, %26
  %42 = phi i64 [ %35, %40 ], [ %35, %39 ], [ 1, %26 ]
  %43 = phi ptr [ %8, %40 ], [ %3, %39 ], [ %3, %26 ]
  %44 = phi ptr [ %9, %40 ], [ %3, %39 ], [ %3, %26 ]
  %45 = phi i64 [ 3, %40 ], [ 2, %39 ], [ 2, %26 ]
  store i8 48, ptr %43, align 1, !tbaa !10
  %46 = getelementptr inbounds nuw i8, ptr %44, i64 1
  store i8 98, ptr %46, align 1, !tbaa !10
  %47 = shl i64 %42, 32
  %48 = ashr exact i64 %47, 32
  %49 = icmp ult i64 %42, 32
  br i1 %49, label %77, label %50

50:                                               ; preds = %41
  %51 = and i64 %42, -32
  %52 = sub i64 %48, %51
  %53 = or disjoint i64 %45, %51
  %54 = getelementptr i8, ptr %4, i64 %48
  %55 = getelementptr i8, ptr %54, i64 -16
  %56 = getelementptr i8, ptr %54, i64 -32
  %57 = load <16 x i8>, ptr %55, align 1, !tbaa !10
  %58 = load <16 x i8>, ptr %56, align 1, !tbaa !10
  %59 = shufflevector <16 x i8> %57, <16 x i8> poison, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %60 = shufflevector <16 x i8> %58, <16 x i8> poison, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %61 = getelementptr inbounds nuw i8, ptr %3, i64 %45
  %62 = getelementptr inbounds nuw i8, ptr %61, i64 16
  store <16 x i8> %59, ptr %61, align 1, !tbaa !10
  store <16 x i8> %60, ptr %62, align 1, !tbaa !10
  %63 = icmp eq i64 %51, 32
  br i1 %63, label %75, label %64, !llvm.loop !162

64:                                               ; preds = %50
  %65 = getelementptr i8, ptr %4, i64 %48
  %66 = getelementptr i8, ptr %65, i64 -48
  %67 = getelementptr i8, ptr %65, i64 -64
  %68 = load <16 x i8>, ptr %66, align 1, !tbaa !10
  %69 = load <16 x i8>, ptr %67, align 1, !tbaa !10
  %70 = shufflevector <16 x i8> %68, <16 x i8> poison, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %71 = shufflevector <16 x i8> %69, <16 x i8> poison, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %72 = getelementptr inbounds nuw i8, ptr %3, i64 %45
  %73 = getelementptr inbounds nuw i8, ptr %72, i64 32
  %74 = getelementptr inbounds nuw i8, ptr %72, i64 48
  store <16 x i8> %70, ptr %73, align 1, !tbaa !10
  store <16 x i8> %71, ptr %74, align 1, !tbaa !10
  br label %75

75:                                               ; preds = %64, %50
  %76 = icmp eq i64 %42, %51
  br i1 %76, label %89, label %77

77:                                               ; preds = %41, %75
  %78 = phi i64 [ %48, %41 ], [ %52, %75 ]
  %79 = phi i64 [ %45, %41 ], [ %53, %75 ]
  br label %80

80:                                               ; preds = %77, %80
  %81 = phi i64 [ %83, %80 ], [ %78, %77 ]
  %82 = phi i64 [ %86, %80 ], [ %79, %77 ]
  %83 = add nsw i64 %81, -1
  %84 = getelementptr inbounds i8, ptr %4, i64 %83
  %85 = load i8, ptr %84, align 1, !tbaa !10
  %86 = add nuw nsw i64 %82, 1
  %87 = getelementptr inbounds nuw i8, ptr %3, i64 %82
  store i8 %85, ptr %87, align 1, !tbaa !10
  %88 = icmp eq i64 %83, 0
  br i1 %88, label %89, label %80, !llvm.loop !163

89:                                               ; preds = %80, %75
  %90 = phi i64 [ %53, %75 ], [ %86, %80 ]
  %91 = and i64 %90, 4294967295
  %92 = getelementptr inbounds nuw i8, ptr %3, i64 %91
  store i8 0, ptr %92, align 1, !tbaa !10
  %93 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %3) #35
  %94 = call fastcc i64 @mkstr(ptr noundef nonnull readonly %3, i64 noundef %93)
  call void @llvm.lifetime.end.p0(ptr nonnull %4) #35
  call void @llvm.lifetime.end.p0(ptr nonnull %3) #35
  ret i64 %94
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @b_repr(i64 %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = alloca %struct.SB, align 8
  %4 = load i64, ptr %1, align 8, !tbaa !11
  call void @llvm.lifetime.start.p0(ptr nonnull %3) #35
  %5 = getelementptr inbounds nuw i8, ptr %3, i64 8
  store <2 x i64> <i64 0, i64 64>, ptr %5, align 8, !tbaa !11
  %6 = tail call dereferenceable_or_null(64) ptr @calloc(i64 noundef 1, i64 noundef 64) #33
  %7 = icmp eq ptr %6, null
  br i1 %7, label %8, label %11

8:                                                ; preds = %2
  %9 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %10 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %9)
  tail call void @exit(i32 noundef 1) #34
  unreachable

11:                                               ; preds = %2
  store ptr %6, ptr %3, align 8, !tbaa !61
  call fastcc void @to_sb(ptr noundef %3, i64 noundef %4, i32 noundef 1)
  %12 = load ptr, ptr %3, align 8, !tbaa !61
  %13 = load i64, ptr %5, align 8, !tbaa !63
  %14 = call fastcc i64 @mkstr(ptr noundef %12, i64 noundef %13)
  call void @llvm.lifetime.end.p0(ptr nonnull %3) #35
  ret i64 %14
}

; Function Attrs: nounwind ssp uwtable(sync)
define noundef i64 @b_divmod(i64 %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = load i64, ptr %1, align 8, !tbaa !11
  %4 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %5 = load i64, ptr %4, align 8, !tbaa !11
  %6 = tail call i64 @rt_floordiv(i64 noundef %3, i64 noundef %5)
  %7 = load i64, ptr %1, align 8, !tbaa !11
  %8 = load i64, ptr %4, align 8, !tbaa !11
  %9 = tail call i64 @rt_mod(i64 noundef %7, i64 noundef %8)
  %10 = tail call fastcc i64 @mktuple(i64 noundef 2)
  %11 = inttoptr i64 %10 to ptr
  %12 = getelementptr inbounds nuw i8, ptr %11, i64 24
  %13 = load ptr, ptr %12, align 8, !tbaa !32
  store i64 %6, ptr %13, align 8, !tbaa !11
  %14 = getelementptr inbounds nuw i8, ptr %13, i64 8
  store i64 %9, ptr %14, align 8, !tbaa !11
  ret i64 %10
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @b_pow(i64 %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = load i64, ptr %1, align 8, !tbaa !11
  %4 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %5 = load i64, ptr %4, align 8, !tbaa !11
  %6 = tail call i64 @rt_pow(i64 noundef %3, i64 noundef %5)
  ret i64 %6
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @b_hasattr(i64 %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = load i64, ptr %1, align 8, !tbaa !11
  %4 = and i64 %3, 1
  %5 = icmp ne i64 %4, 0
  %6 = icmp eq i64 %3, 0
  %7 = or i1 %6, %5
  br i1 %7, label %97, label %8

8:                                                ; preds = %2
  %9 = inttoptr i64 %3 to ptr
  %10 = load i64, ptr %9, align 8, !tbaa !23
  %11 = icmp eq i64 %10, 12
  br i1 %11, label %12, label %97

12:                                               ; preds = %8
  %13 = getelementptr inbounds nuw i8, ptr %9, i64 16
  %14 = load i64, ptr %13, align 8, !tbaa !39
  %15 = inttoptr i64 %14 to ptr
  %16 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %17 = load i64, ptr %16, align 8, !tbaa !11
  %18 = tail call fastcc i64 @hash_v(i64 noundef %17) #39
  %19 = getelementptr inbounds nuw i8, ptr %15, i64 40
  %20 = load i64, ptr %19, align 8, !tbaa !40
  %21 = icmp eq i64 %20, 0
  br i1 %21, label %60, label %22

22:                                               ; preds = %12
  %23 = add nsw i64 %20, -1
  %24 = getelementptr inbounds nuw i8, ptr %15, i64 48
  %25 = and i64 %23, %18
  %26 = load ptr, ptr %24, align 8, !tbaa !41
  %27 = getelementptr inbounds i64, ptr %26, i64 %25
  %28 = load i64, ptr %27, align 8, !tbaa !11
  %29 = icmp slt i64 %28, 0
  br i1 %29, label %60, label %30

30:                                               ; preds = %22
  %31 = getelementptr inbounds nuw i8, ptr %15, i64 32
  br label %32

32:                                               ; preds = %51, %30
  %33 = phi ptr [ %26, %30 ], [ %52, %51 ]
  %34 = phi i64 [ %28, %30 ], [ %56, %51 ]
  %35 = phi i64 [ %25, %30 ], [ %54, %51 ]
  %36 = load ptr, ptr %31, align 8, !tbaa !36
  %37 = getelementptr inbounds nuw %struct.Ent, ptr %36, i64 %34
  %38 = load i64, ptr %37, align 8, !tbaa !37
  %39 = icmp eq i64 %38, 0
  br i1 %39, label %51, label %40

40:                                               ; preds = %32
  %41 = getelementptr inbounds nuw i8, ptr %37, i64 16
  %42 = load i64, ptr %41, align 8, !tbaa !39
  %43 = icmp eq i64 %42, %18
  br i1 %43, label %44, label %51

44:                                               ; preds = %40
  %45 = icmp eq i64 %38, %17
  br i1 %45, label %58, label %46

46:                                               ; preds = %44
  %47 = tail call i64 @rt_eq_i(i64 noundef %38, i64 noundef %17) #39
  %48 = icmp eq i64 %47, 0
  br i1 %48, label %49, label %58

49:                                               ; preds = %46
  %50 = load ptr, ptr %24, align 8, !tbaa !41
  br label %51

51:                                               ; preds = %49, %40, %32
  %52 = phi ptr [ %50, %49 ], [ %33, %32 ], [ %33, %40 ]
  %53 = add nuw nsw i64 %35, 1
  %54 = and i64 %53, %23
  %55 = getelementptr inbounds i64, ptr %52, i64 %54
  %56 = load i64, ptr %55, align 8, !tbaa !11
  %57 = icmp slt i64 %56, 0
  br i1 %57, label %60, label %32

58:                                               ; preds = %46, %44
  %59 = load i64, ptr @rt_true_v, align 8, !tbaa !11
  br label %99

60:                                               ; preds = %51, %12, %22
  %61 = getelementptr inbounds nuw i8, ptr %9, i64 8
  %62 = load i64, ptr %61, align 8, !tbaa !42
  %63 = load i64, ptr %16, align 8, !tbaa !11
  %64 = icmp ne i64 %62, 0
  %65 = and i64 %62, 1
  %66 = icmp eq i64 %65, 0
  %67 = and i1 %64, %66
  br i1 %67, label %68, label %87

68:                                               ; preds = %60, %80
  %69 = phi i64 [ %82, %80 ], [ %62, %60 ]
  %70 = inttoptr i64 %69 to ptr
  %71 = load i64, ptr %70, align 8, !tbaa !23
  %72 = icmp eq i64 %71, 11
  br i1 %72, label %73, label %87

73:                                               ; preds = %68
  %74 = getelementptr inbounds nuw i8, ptr %70, i64 24
  %75 = load i64, ptr %74, align 8, !tbaa !44
  %76 = inttoptr i64 %75 to ptr
  %77 = tail call fastcc i64 @hash_v(i64 noundef %63) #39
  %78 = tail call fastcc ptr @dict_find(ptr noundef %76, i64 noundef %63, i64 noundef %77) #39
  %79 = icmp eq ptr %78, null
  br i1 %79, label %80, label %89

80:                                               ; preds = %73
  %81 = getelementptr inbounds nuw i8, ptr %70, i64 16
  %82 = load i64, ptr %81, align 8, !tbaa !46
  %83 = icmp ne i64 %82, 0
  %84 = and i64 %82, 1
  %85 = icmp eq i64 %84, 0
  %86 = and i1 %83, %85
  br i1 %86, label %68, label %87

87:                                               ; preds = %80, %68, %60
  %88 = load i64, ptr @rt_false_v, align 8
  br label %99

89:                                               ; preds = %73
  %90 = getelementptr inbounds nuw i8, ptr %78, i64 8
  %91 = load i64, ptr %90, align 8, !tbaa !42
  %92 = freeze i64 %91
  %93 = icmp eq i64 %92, 0
  %94 = load i64, ptr @rt_true_v, align 8
  %95 = load i64, ptr @rt_false_v, align 8
  %96 = select i1 %93, i64 %95, i64 %94
  br label %99

97:                                               ; preds = %2, %8
  %98 = load i64, ptr @rt_false_v, align 8, !tbaa !11
  br label %99

99:                                               ; preds = %89, %87, %97, %58
  %100 = phi i64 [ %59, %58 ], [ %98, %97 ], [ %96, %89 ], [ %88, %87 ]
  ret i64 %100
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @b_getattr(i64 noundef %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = icmp sgt i64 %0, 2
  br i1 %3, label %4, label %11

4:                                                ; preds = %2
  %5 = tail call i64 @b_hasattr(i64 poison, ptr noundef %1)
  %6 = load i64, ptr @rt_false_v, align 8, !tbaa !11
  %7 = icmp eq i64 %5, %6
  br i1 %7, label %8, label %11

8:                                                ; preds = %4
  %9 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %10 = load i64, ptr %9, align 8, !tbaa !11
  br label %16

11:                                               ; preds = %4, %2
  %12 = load i64, ptr %1, align 8, !tbaa !11
  %13 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %14 = load i64, ptr %13, align 8, !tbaa !11
  %15 = tail call i64 @rt_getattr(i64 noundef %12, i64 noundef %14)
  br label %16

16:                                               ; preds = %11, %8
  %17 = phi i64 [ %10, %8 ], [ %15, %11 ]
  ret i64 %17
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @b_setattr(i64 %0, ptr noundef readonly captures(none) %1) #2 {
  %3 = load i64, ptr %1, align 8, !tbaa !11
  %4 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %5 = load i64, ptr %4, align 8, !tbaa !11
  %6 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %7 = load i64, ptr %6, align 8, !tbaa !11
  %8 = and i64 %3, 1
  %9 = icmp ne i64 %8, 0
  %10 = icmp eq i64 %3, 0
  %11 = or i1 %10, %9
  br i1 %11, label %16, label %12

12:                                               ; preds = %2
  %13 = inttoptr i64 %3 to ptr
  %14 = load i64, ptr %13, align 8, !tbaa !23
  switch i64 %14, label %16 [
    i64 12, label %20
    i64 11, label %15
  ]

15:                                               ; preds = %12
  br label %20

16:                                               ; preds = %12, %2
  %17 = tail call fastcc ptr @tname(i64 noundef %3)
  %18 = inttoptr i64 %5 to ptr
  %19 = getelementptr inbounds nuw i8, ptr %18, i64 16
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.54, ptr noundef nonnull @.str.55, ptr noundef nonnull %17, ptr noundef nonnull %19) #36
  unreachable

20:                                               ; preds = %12, %15
  %21 = phi i64 [ 24, %15 ], [ 16, %12 ]
  %22 = getelementptr inbounds nuw i8, ptr %13, i64 %21
  %23 = load i64, ptr %22, align 8, !tbaa !11
  %24 = inttoptr i64 %23 to ptr
  tail call fastcc void @dict_set(ptr noundef %24, i64 noundef %5, i64 noundef %7)
  %25 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  ret i64 %25
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind ssp willreturn memory(read, inaccessiblemem: none, target_mem0: none, target_mem1: none) uwtable(sync)
define i64 @b_callable(i64 %0, ptr noundef readonly captures(none) %1) #15 {
  %3 = load i64, ptr %1, align 8, !tbaa !11
  %4 = and i64 %3, 1
  %5 = icmp ne i64 %4, 0
  %6 = icmp eq i64 %3, 0
  %7 = or i1 %6, %5
  br i1 %7, label %8, label %10

8:                                                ; preds = %2
  %9 = load i64, ptr @rt_false_v, align 8
  br label %20

10:                                               ; preds = %2
  %11 = inttoptr i64 %3 to ptr
  %12 = load i64, ptr %11, align 8, !tbaa !23
  switch i64 %12, label %15 [
    i64 13, label %13
    i64 10, label %13
    i64 9, label %13
  ]

13:                                               ; preds = %10, %10, %10
  %14 = load i64, ptr @rt_true_v, align 8
  br label %20

15:                                               ; preds = %10
  %16 = icmp eq i64 %12, 11
  %17 = load i64, ptr @rt_true_v, align 8
  %18 = load i64, ptr @rt_false_v, align 8
  %19 = select i1 %16, i64 %17, i64 %18
  br label %20

20:                                               ; preds = %15, %8, %13
  %21 = phi i64 [ %14, %13 ], [ %19, %15 ], [ %9, %8 ]
  ret i64 %21
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_callmeth(i64 noundef %0, i64 noundef %1, i64 noundef %2, ptr noundef %3) local_unnamed_addr #2 {
  %5 = alloca %struct.SB, align 8
  %6 = alloca %struct.SB, align 8
  %7 = alloca %struct.SB, align 8
  %8 = inttoptr i64 %1 to ptr
  %9 = getelementptr inbounds nuw i8, ptr %8, i64 16
  %10 = and i64 %0, 1
  %11 = icmp ne i64 %10, 0
  %12 = icmp eq i64 %0, 0
  %13 = or i1 %12, %11
  br i1 %13, label %2126, label %14

14:                                               ; preds = %4
  %15 = inttoptr i64 %0 to ptr
  %16 = load i64, ptr %15, align 8, !tbaa !23
  switch i64 %16, label %2126 [
    i64 12, label %17
    i64 11, label %118
    i64 15, label %121
    i64 4, label %124
    i64 5, label %1158
    i64 6, label %1477
    i64 7, label %1527
    i64 8, label %1939
    i64 14, label %2124
  ]

17:                                               ; preds = %14
  %18 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %19 = load i64, ptr %18, align 8, !tbaa !42
  %20 = icmp ne i64 %19, 0
  %21 = and i64 %19, 1
  %22 = icmp eq i64 %21, 0
  %23 = and i1 %20, %22
  br i1 %23, label %24, label %65

24:                                               ; preds = %17, %36
  %25 = phi i64 [ %38, %36 ], [ %19, %17 ]
  %26 = inttoptr i64 %25 to ptr
  %27 = load i64, ptr %26, align 8, !tbaa !23
  %28 = icmp eq i64 %27, 11
  br i1 %28, label %29, label %65

29:                                               ; preds = %24
  %30 = getelementptr inbounds nuw i8, ptr %26, i64 24
  %31 = load i64, ptr %30, align 8, !tbaa !44
  %32 = inttoptr i64 %31 to ptr
  %33 = tail call fastcc i64 @hash_v(i64 noundef %1) #39
  %34 = tail call fastcc ptr @dict_find(ptr noundef %32, i64 noundef %1, i64 noundef %33) #39
  %35 = icmp eq ptr %34, null
  br i1 %35, label %36, label %43

36:                                               ; preds = %29
  %37 = getelementptr inbounds nuw i8, ptr %26, i64 16
  %38 = load i64, ptr %37, align 8, !tbaa !46
  %39 = icmp ne i64 %38, 0
  %40 = and i64 %38, 1
  %41 = icmp eq i64 %40, 0
  %42 = and i1 %39, %41
  br i1 %42, label %24, label %65

43:                                               ; preds = %29
  %44 = getelementptr inbounds nuw i8, ptr %34, i64 8
  %45 = load i64, ptr %44, align 8, !tbaa !42
  %46 = icmp eq i64 %45, 0
  br i1 %46, label %65, label %47

47:                                               ; preds = %43
  %48 = and i64 %45, 1
  %49 = icmp eq i64 %48, 0
  br i1 %49, label %50, label %65

50:                                               ; preds = %47
  %51 = inttoptr i64 %45 to ptr
  %52 = load i64, ptr %51, align 8, !tbaa !23
  %53 = add i64 %52, -9
  %54 = icmp ult i64 %53, 2
  br i1 %54, label %55, label %65

55:                                               ; preds = %50
  %56 = add nsw i64 %2, 1
  %57 = tail call ptr @llvm.stacksave.p0()
  %58 = alloca i64, i64 %56, align 8
  store i64 %0, ptr %58, align 8, !tbaa !11
  %59 = icmp sgt i64 %2, 0
  br i1 %59, label %60, label %63

60:                                               ; preds = %55
  %61 = getelementptr i8, ptr %58, i64 8
  %62 = shl nuw i64 %2, 3
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %61, ptr align 8 %3, i64 %62, i1 false), !tbaa !11
  br label %63

63:                                               ; preds = %60, %55
  %64 = call i64 @rt_call(i64 noundef %45, i64 noundef %56, ptr noundef nonnull %58)
  call void @llvm.stackrestore.p0(ptr %57)
  br label %2128

65:                                               ; preds = %36, %24, %50, %47, %17, %43
  %66 = phi i1 [ false, %47 ], [ false, %50 ], [ true, %43 ], [ true, %17 ], [ true, %24 ], [ true, %36 ]
  %67 = phi i64 [ %45, %47 ], [ %45, %50 ], [ 0, %43 ], [ 0, %17 ], [ 0, %24 ], [ 0, %36 ]
  %68 = getelementptr inbounds nuw i8, ptr %15, i64 16
  %69 = load i64, ptr %68, align 8, !tbaa !39
  %70 = inttoptr i64 %69 to ptr
  %71 = tail call fastcc i64 @hash_v(i64 noundef %1) #39
  %72 = getelementptr inbounds nuw i8, ptr %70, i64 40
  %73 = load i64, ptr %72, align 8, !tbaa !40
  %74 = icmp eq i64 %73, 0
  br i1 %74, label %115, label %75

75:                                               ; preds = %65
  %76 = add nsw i64 %73, -1
  %77 = getelementptr inbounds nuw i8, ptr %70, i64 48
  %78 = and i64 %76, %71
  %79 = load ptr, ptr %77, align 8, !tbaa !41
  %80 = getelementptr inbounds i64, ptr %79, i64 %78
  %81 = load i64, ptr %80, align 8, !tbaa !11
  %82 = icmp slt i64 %81, 0
  br i1 %82, label %115, label %83

83:                                               ; preds = %75
  %84 = getelementptr inbounds nuw i8, ptr %70, i64 32
  br label %85

85:                                               ; preds = %104, %83
  %86 = phi ptr [ %79, %83 ], [ %105, %104 ]
  %87 = phi i64 [ %81, %83 ], [ %109, %104 ]
  %88 = phi i64 [ %78, %83 ], [ %107, %104 ]
  %89 = load ptr, ptr %84, align 8, !tbaa !36
  %90 = getelementptr inbounds nuw %struct.Ent, ptr %89, i64 %87
  %91 = load i64, ptr %90, align 8, !tbaa !37
  %92 = icmp eq i64 %91, 0
  br i1 %92, label %104, label %93

93:                                               ; preds = %85
  %94 = getelementptr inbounds nuw i8, ptr %90, i64 16
  %95 = load i64, ptr %94, align 8, !tbaa !39
  %96 = icmp eq i64 %95, %71
  br i1 %96, label %97, label %104

97:                                               ; preds = %93
  %98 = icmp eq i64 %91, %1
  br i1 %98, label %111, label %99

99:                                               ; preds = %97
  %100 = tail call i64 @rt_eq_i(i64 noundef %91, i64 noundef %1) #39
  %101 = icmp eq i64 %100, 0
  br i1 %101, label %102, label %111

102:                                              ; preds = %99
  %103 = load ptr, ptr %77, align 8, !tbaa !41
  br label %104

104:                                              ; preds = %102, %93, %85
  %105 = phi ptr [ %103, %102 ], [ %86, %85 ], [ %86, %93 ]
  %106 = add nuw nsw i64 %88, 1
  %107 = and i64 %106, %76
  %108 = getelementptr inbounds i64, ptr %105, i64 %107
  %109 = load i64, ptr %108, align 8, !tbaa !11
  %110 = icmp slt i64 %109, 0
  br i1 %110, label %115, label %85

111:                                              ; preds = %99, %97
  %112 = getelementptr inbounds nuw i8, ptr %90, i64 8
  %113 = load i64, ptr %112, align 8, !tbaa !42
  %114 = tail call i64 @rt_call(i64 noundef %113, i64 noundef %2, ptr noundef %3)
  br label %2128

115:                                              ; preds = %104, %65, %75
  br i1 %66, label %2126, label %116

116:                                              ; preds = %115
  %117 = tail call i64 @rt_call(i64 noundef %67, i64 noundef %2, ptr noundef %3)
  br label %2128

118:                                              ; preds = %14
  %119 = tail call i64 @rt_getattr(i64 noundef %0, i64 noundef %1)
  %120 = tail call i64 @rt_call(i64 noundef %119, i64 noundef %2, ptr noundef %3)
  br label %2128

121:                                              ; preds = %14
  %122 = tail call i64 @rt_getattr(i64 noundef %0, i64 noundef %1)
  %123 = tail call i64 @rt_call(i64 noundef %122, i64 noundef %2, ptr noundef %3)
  br label %2128

124:                                              ; preds = %14
  %125 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(5) @.str.191) #35
  %126 = icmp eq i32 %125, 0
  br i1 %126, label %127, label %206

127:                                              ; preds = %124
  %128 = load i64, ptr %3, align 8, !tbaa !11
  %129 = tail call fastcc i64 @as_list(i64 noundef %128)
  %130 = tail call dereferenceable_or_null(64) ptr @calloc(i64 noundef 1, i64 noundef 64) #33
  %131 = icmp eq ptr %130, null
  br i1 %131, label %141, label %132

132:                                              ; preds = %127
  %133 = inttoptr i64 %129 to ptr
  %134 = getelementptr inbounds nuw i8, ptr %133, i64 8
  %135 = load i64, ptr %134, align 8, !tbaa !27
  %136 = icmp sgt i64 %135, 0
  br i1 %136, label %137, label %144

137:                                              ; preds = %132
  %138 = getelementptr inbounds nuw i8, ptr %15, i64 16
  %139 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %140 = getelementptr inbounds nuw i8, ptr %133, i64 24
  br label %148

141:                                              ; preds = %127
  %142 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %143 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %142)
  tail call void @exit(i32 noundef 1) #34
  unreachable

144:                                              ; preds = %198, %132
  %145 = phi i64 [ 0, %132 ], [ %190, %198 ]
  %146 = phi ptr [ %130, %132 ], [ %200, %198 ]
  %147 = tail call fastcc i64 @mkstr(ptr noundef nonnull %146, i64 noundef %145)
  br label %2128

148:                                              ; preds = %198, %137
  %149 = phi i64 [ 0, %137 ], [ %203, %198 ]
  %150 = phi ptr [ %130, %137 ], [ %200, %198 ]
  %151 = phi i64 [ 0, %137 ], [ %190, %198 ]
  %152 = phi i64 [ 64, %137 ], [ %199, %198 ]
  %153 = icmp eq i64 %149, 0
  br i1 %153, label %169, label %154

154:                                              ; preds = %148
  %155 = load i64, ptr %139, align 8, !tbaa !18
  %156 = add nsw i64 %155, %151
  %157 = icmp slt i64 %156, %152
  br i1 %157, label %164, label %158

158:                                              ; preds = %154, %158
  %159 = phi i64 [ %160, %158 ], [ %152, %154 ]
  %160 = shl nsw i64 %159, 1
  %161 = icmp sgt i64 %160, %156
  br i1 %161, label %162, label %158, !llvm.loop !83

162:                                              ; preds = %158
  %163 = tail call ptr @realloc(ptr noundef nonnull %150, i64 noundef %160) #38
  br label %164

164:                                              ; preds = %162, %154
  %165 = phi i64 [ %160, %162 ], [ %152, %154 ]
  %166 = phi ptr [ %163, %162 ], [ %150, %154 ]
  %167 = getelementptr inbounds i8, ptr %166, i64 %151
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %167, ptr noundef nonnull readonly align 1 %138, i64 noundef %155, i1 noundef false) #35
  %168 = getelementptr inbounds i8, ptr %166, i64 %156
  store i8 0, ptr %168, align 1, !tbaa !10
  br label %169

169:                                              ; preds = %164, %148
  %170 = phi i64 [ %152, %148 ], [ %165, %164 ]
  %171 = phi i64 [ %151, %148 ], [ %156, %164 ]
  %172 = phi ptr [ %150, %148 ], [ %166, %164 ]
  %173 = load ptr, ptr %140, align 8, !tbaa !32
  %174 = getelementptr inbounds nuw i64, ptr %173, i64 %149
  %175 = load i64, ptr %174, align 8, !tbaa !11
  %176 = and i64 %175, 1
  %177 = icmp ne i64 %176, 0
  %178 = icmp eq i64 %175, 0
  %179 = or i1 %178, %177
  br i1 %179, label %184, label %180

180:                                              ; preds = %169
  %181 = inttoptr i64 %175 to ptr
  %182 = load i64, ptr %181, align 8, !tbaa !23
  %183 = icmp eq i64 %182, 4
  br i1 %183, label %186, label %184

184:                                              ; preds = %180, %169
  %185 = tail call fastcc ptr @tname(i64 noundef %175)
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.192, i64 noundef %149, ptr noundef nonnull %185) #36
  unreachable

186:                                              ; preds = %180
  %187 = getelementptr inbounds nuw i8, ptr %181, i64 16
  %188 = getelementptr inbounds nuw i8, ptr %181, i64 8
  %189 = load i64, ptr %188, align 8, !tbaa !18
  %190 = add nsw i64 %189, %171
  %191 = icmp slt i64 %190, %170
  br i1 %191, label %198, label %192

192:                                              ; preds = %186, %192
  %193 = phi i64 [ %194, %192 ], [ %170, %186 ]
  %194 = shl nsw i64 %193, 1
  %195 = icmp sgt i64 %194, %190
  br i1 %195, label %196, label %192, !llvm.loop !83

196:                                              ; preds = %192
  %197 = tail call ptr @realloc(ptr noundef nonnull %172, i64 noundef %194) #38
  br label %198

198:                                              ; preds = %196, %186
  %199 = phi i64 [ %194, %196 ], [ %170, %186 ]
  %200 = phi ptr [ %197, %196 ], [ %172, %186 ]
  %201 = getelementptr inbounds i8, ptr %200, i64 %171
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %201, ptr noundef nonnull readonly align 1 %187, i64 noundef %189, i1 noundef false) #35
  %202 = getelementptr inbounds i8, ptr %200, i64 %190
  store i8 0, ptr %202, align 1, !tbaa !10
  %203 = add nuw nsw i64 %149, 1
  %204 = load i64, ptr %134, align 8, !tbaa !27
  %205 = icmp slt i64 %203, %204
  br i1 %205, label %148, label %144, !llvm.loop !164

206:                                              ; preds = %124
  %207 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(6) @.str.193) #35
  %208 = icmp eq i32 %207, 0
  br i1 %208, label %209, label %453

209:                                              ; preds = %206
  %210 = tail call fastcc i64 @mklist(i64 noundef 4)
  %211 = icmp sgt i64 %2, 1
  br i1 %211, label %212, label %229

212:                                              ; preds = %209
  %213 = getelementptr inbounds nuw i8, ptr %3, i64 8
  %214 = load i64, ptr %213, align 8, !tbaa !11
  %215 = and i64 %214, 1
  %216 = icmp eq i64 %215, 0
  br i1 %216, label %219, label %217

217:                                              ; preds = %212
  %218 = ashr i64 %214, 1
  br label %231

219:                                              ; preds = %212
  %220 = icmp eq i64 %214, 0
  br i1 %220, label %228, label %221

221:                                              ; preds = %219
  %222 = inttoptr i64 %214 to ptr
  %223 = load i64, ptr %222, align 8, !tbaa !23
  %224 = icmp eq i64 %223, 2
  br i1 %224, label %225, label %228

225:                                              ; preds = %221
  %226 = getelementptr inbounds nuw i8, ptr %222, i64 8
  %227 = load i64, ptr %226, align 8, !tbaa !25
  br label %231

228:                                              ; preds = %221, %219
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

229:                                              ; preds = %209
  %230 = icmp eq i64 %2, 0
  br i1 %230, label %236, label %231

231:                                              ; preds = %229, %225, %217
  %232 = phi i64 [ -1, %229 ], [ %227, %225 ], [ %218, %217 ]
  %233 = load i64, ptr %3, align 8, !tbaa !11
  %234 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  %235 = icmp eq i64 %233, %234
  br i1 %235, label %236, label %363

236:                                              ; preds = %231, %229
  %237 = phi i64 [ %232, %231 ], [ -1, %229 ]
  %238 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %239 = getelementptr inbounds nuw i8, ptr %15, i64 16
  %240 = inttoptr i64 %210 to ptr
  %241 = getelementptr inbounds nuw i8, ptr %240, i64 8
  %242 = getelementptr inbounds nuw i8, ptr %240, i64 16
  %243 = getelementptr inbounds nuw i8, ptr %240, i64 24
  br label %244

244:                                              ; preds = %355, %236
  %245 = phi i64 [ 0, %236 ], [ %340, %355 ]
  %246 = phi i64 [ %237, %236 ], [ %362, %355 ]
  %247 = load i64, ptr %238, align 8, !tbaa !18
  %248 = icmp slt i64 %245, %247
  br i1 %248, label %249, label %271

249:                                              ; preds = %244, %268
  %250 = phi i64 [ %265, %268 ], [ %247, %244 ]
  %251 = phi i64 [ %269, %268 ], [ %245, %244 ]
  %252 = getelementptr inbounds i8, ptr %239, i64 %251
  %253 = load i8, ptr %252, align 1, !tbaa !10
  %254 = icmp sgt i8 %253, -1
  br i1 %254, label %255, label %260

255:                                              ; preds = %249
  %256 = zext nneg i8 %253 to i64
  %257 = getelementptr inbounds nuw i32, ptr getelementptr inbounds nuw (i8, ptr @_DefaultRuneLocale, i64 60), i64 %256
  %258 = load i32, ptr %257, align 4, !tbaa !6
  %259 = and i32 %258, 16384
  br label %264

260:                                              ; preds = %249
  %261 = zext i8 %253 to i32
  %262 = tail call i32 @__maskrune(i32 noundef %261, i64 noundef 16384) #35
  %263 = load i64, ptr %238, align 8, !tbaa !18
  br label %264

264:                                              ; preds = %260, %255
  %265 = phi i64 [ %250, %255 ], [ %263, %260 ]
  %266 = phi i32 [ %259, %255 ], [ %262, %260 ]
  %267 = icmp eq i32 %266, 0
  br i1 %267, label %271, label %268

268:                                              ; preds = %264
  %269 = add nsw i64 %251, 1
  %270 = icmp slt i64 %269, %265
  br i1 %270, label %249, label %271, !llvm.loop !165

271:                                              ; preds = %268, %264, %244
  %272 = phi i64 [ %247, %244 ], [ %265, %264 ], [ %265, %268 ]
  %273 = phi i64 [ %245, %244 ], [ %269, %268 ], [ %251, %264 ]
  %274 = icmp slt i64 %273, %272
  br i1 %274, label %275, label %2128

275:                                              ; preds = %271
  %276 = icmp eq i64 %246, 0
  br i1 %276, label %277, label %319

277:                                              ; preds = %275
  %278 = getelementptr i8, ptr %15, i64 15
  br label %279

279:                                              ; preds = %295, %277
  %280 = phi i64 [ %272, %277 ], [ %296, %295 ]
  %281 = getelementptr i8, ptr %278, i64 %280
  %282 = load i8, ptr %281, align 1, !tbaa !10
  %283 = icmp sgt i8 %282, -1
  br i1 %283, label %284, label %289

284:                                              ; preds = %279
  %285 = zext nneg i8 %282 to i64
  %286 = getelementptr inbounds nuw i32, ptr getelementptr inbounds nuw (i8, ptr @_DefaultRuneLocale, i64 60), i64 %285
  %287 = load i32, ptr %286, align 4, !tbaa !6
  %288 = and i32 %287, 16384
  br label %292

289:                                              ; preds = %279
  %290 = zext i8 %282 to i32
  %291 = tail call i32 @__maskrune(i32 noundef %290, i64 noundef 16384) #35
  br label %292

292:                                              ; preds = %289, %284
  %293 = phi i32 [ %288, %284 ], [ %291, %289 ]
  %294 = icmp eq i32 %293, 0
  br i1 %294, label %298, label %295

295:                                              ; preds = %292
  %296 = add nsw i64 %280, -1
  %297 = icmp sgt i64 %296, %273
  br i1 %297, label %279, label %298, !llvm.loop !166

298:                                              ; preds = %295, %292
  %299 = phi i64 [ %280, %292 ], [ %273, %295 ]
  %300 = getelementptr inbounds i8, ptr %239, i64 %273
  %301 = sub nsw i64 %299, %273
  %302 = tail call fastcc i64 @mkstr(ptr noundef nonnull %300, i64 noundef %301)
  %303 = load i64, ptr %241, align 8, !tbaa !27
  %304 = load i64, ptr %242, align 8, !tbaa !70
  %305 = icmp slt i64 %303, %304
  br i1 %305, label %306, label %308

306:                                              ; preds = %298
  %307 = load ptr, ptr %243, align 8, !tbaa !32
  br label %314

308:                                              ; preds = %298
  %309 = shl nsw i64 %304, 1
  store i64 %309, ptr %242, align 8, !tbaa !70
  %310 = load ptr, ptr %243, align 8, !tbaa !32
  %311 = shl i64 %304, 4
  %312 = tail call ptr @realloc(ptr noundef %310, i64 noundef %311) #38
  store ptr %312, ptr %243, align 8, !tbaa !32
  %313 = load i64, ptr %241, align 8, !tbaa !27
  br label %314

314:                                              ; preds = %308, %306
  %315 = phi i64 [ %303, %306 ], [ %313, %308 ]
  %316 = phi ptr [ %307, %306 ], [ %312, %308 ]
  %317 = add nsw i64 %315, 1
  store i64 %317, ptr %241, align 8, !tbaa !27
  %318 = getelementptr inbounds i64, ptr %316, i64 %315
  store i64 %302, ptr %318, align 8, !tbaa !11
  br label %2128

319:                                              ; preds = %275, %335
  %320 = phi i64 [ %336, %335 ], [ %273, %275 ]
  %321 = getelementptr inbounds i8, ptr %239, i64 %320
  %322 = load i8, ptr %321, align 1, !tbaa !10
  %323 = icmp sgt i8 %322, -1
  br i1 %323, label %324, label %329

324:                                              ; preds = %319
  %325 = zext nneg i8 %322 to i64
  %326 = getelementptr inbounds nuw i32, ptr getelementptr inbounds nuw (i8, ptr @_DefaultRuneLocale, i64 60), i64 %325
  %327 = load i32, ptr %326, align 4, !tbaa !6
  %328 = and i32 %327, 16384
  br label %332

329:                                              ; preds = %319
  %330 = zext i8 %322 to i32
  %331 = tail call i32 @__maskrune(i32 noundef %330, i64 noundef 16384) #35
  br label %332

332:                                              ; preds = %329, %324
  %333 = phi i32 [ %328, %324 ], [ %331, %329 ]
  %334 = icmp eq i32 %333, 0
  br i1 %334, label %335, label %339

335:                                              ; preds = %332
  %336 = add nsw i64 %320, 1
  %337 = load i64, ptr %238, align 8, !tbaa !18
  %338 = icmp slt i64 %336, %337
  br i1 %338, label %319, label %339, !llvm.loop !167

339:                                              ; preds = %335, %332
  %340 = phi i64 [ %320, %332 ], [ %336, %335 ]
  %341 = getelementptr inbounds i8, ptr %239, i64 %273
  %342 = sub nsw i64 %340, %273
  %343 = tail call fastcc i64 @mkstr(ptr noundef nonnull %341, i64 noundef %342)
  %344 = load i64, ptr %241, align 8, !tbaa !27
  %345 = load i64, ptr %242, align 8, !tbaa !70
  %346 = icmp slt i64 %344, %345
  br i1 %346, label %347, label %349

347:                                              ; preds = %339
  %348 = load ptr, ptr %243, align 8, !tbaa !32
  br label %355

349:                                              ; preds = %339
  %350 = shl nsw i64 %345, 1
  store i64 %350, ptr %242, align 8, !tbaa !70
  %351 = load ptr, ptr %243, align 8, !tbaa !32
  %352 = shl i64 %345, 4
  %353 = tail call ptr @realloc(ptr noundef %351, i64 noundef %352) #38
  store ptr %353, ptr %243, align 8, !tbaa !32
  %354 = load i64, ptr %241, align 8, !tbaa !27
  br label %355

355:                                              ; preds = %349, %347
  %356 = phi i64 [ %344, %347 ], [ %354, %349 ]
  %357 = phi ptr [ %348, %347 ], [ %353, %349 ]
  %358 = add nsw i64 %356, 1
  store i64 %358, ptr %241, align 8, !tbaa !27
  %359 = getelementptr inbounds i64, ptr %357, i64 %356
  store i64 %343, ptr %359, align 8, !tbaa !11
  %360 = icmp sgt i64 %246, 0
  %361 = sext i1 %360 to i64
  %362 = add nsw i64 %246, %361
  br label %244

363:                                              ; preds = %231
  %364 = inttoptr i64 %233 to ptr
  %365 = getelementptr inbounds nuw i8, ptr %364, i64 8
  %366 = load i64, ptr %365, align 8, !tbaa !18
  %367 = icmp eq i64 %366, 0
  br i1 %367, label %380, label %368

368:                                              ; preds = %363
  %369 = icmp eq i64 %232, 0
  br i1 %369, label %370, label %372

370:                                              ; preds = %368
  %371 = inttoptr i64 %210 to ptr
  br label %398

372:                                              ; preds = %368
  %373 = getelementptr inbounds nuw i8, ptr %15, i64 16
  %374 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %375 = getelementptr inbounds nuw i8, ptr %364, i64 16
  %376 = inttoptr i64 %210 to ptr
  %377 = getelementptr inbounds nuw i8, ptr %376, i64 8
  %378 = getelementptr inbounds nuw i8, ptr %376, i64 16
  %379 = getelementptr inbounds nuw i8, ptr %376, i64 24
  br label %381

380:                                              ; preds = %363
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.25, ptr noundef nonnull @.str.194) #36
  unreachable

381:                                              ; preds = %442, %372
  %382 = phi i64 [ %366, %372 ], [ %447, %442 ]
  %383 = phi i64 [ %232, %372 ], [ %451, %442 ]
  %384 = phi i64 [ 0, %372 ], [ %448, %442 ]
  %385 = tail call i64 @llvm.smax.i64(i64 %384, i64 0)
  %386 = load i64, ptr %374, align 8, !tbaa !18
  %387 = add nsw i64 %385, %382
  %388 = icmp sgt i64 %387, %386
  br i1 %388, label %398, label %389

389:                                              ; preds = %381, %394
  %390 = phi i64 [ %395, %394 ], [ %385, %381 ]
  %391 = getelementptr inbounds nuw i8, ptr %373, i64 %390
  %392 = tail call i32 @memcmp(ptr noundef nonnull readonly %391, ptr noundef nonnull readonly %375, i64 noundef %382)
  %393 = icmp eq i32 %392, 0
  br i1 %393, label %427, label %394

394:                                              ; preds = %389
  %395 = add nuw nsw i64 %390, 1
  %396 = add nsw i64 %395, %382
  %397 = icmp sgt i64 %396, %386
  br i1 %397, label %398, label %389, !llvm.loop !168

398:                                              ; preds = %442, %381, %394, %370
  %399 = phi ptr [ %371, %370 ], [ %376, %394 ], [ %376, %381 ], [ %376, %442 ]
  %400 = phi i64 [ 0, %370 ], [ %384, %394 ], [ %384, %381 ], [ %448, %442 ]
  %401 = getelementptr inbounds nuw i8, ptr %15, i64 16
  %402 = getelementptr inbounds i8, ptr %401, i64 %400
  %403 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %404 = load i64, ptr %403, align 8, !tbaa !18
  %405 = sub nsw i64 %404, %400
  %406 = tail call fastcc i64 @mkstr(ptr noundef nonnull %402, i64 noundef %405)
  %407 = getelementptr inbounds nuw i8, ptr %399, i64 8
  %408 = load i64, ptr %407, align 8, !tbaa !27
  %409 = getelementptr inbounds nuw i8, ptr %399, i64 16
  %410 = load i64, ptr %409, align 8, !tbaa !70
  %411 = icmp slt i64 %408, %410
  br i1 %411, label %412, label %415

412:                                              ; preds = %398
  %413 = getelementptr inbounds nuw i8, ptr %399, i64 24
  %414 = load ptr, ptr %413, align 8, !tbaa !32
  br label %422

415:                                              ; preds = %398
  %416 = shl nsw i64 %410, 1
  store i64 %416, ptr %409, align 8, !tbaa !70
  %417 = getelementptr inbounds nuw i8, ptr %399, i64 24
  %418 = load ptr, ptr %417, align 8, !tbaa !32
  %419 = shl i64 %410, 4
  %420 = tail call ptr @realloc(ptr noundef %418, i64 noundef %419) #38
  store ptr %420, ptr %417, align 8, !tbaa !32
  %421 = load i64, ptr %407, align 8, !tbaa !27
  br label %422

422:                                              ; preds = %415, %412
  %423 = phi i64 [ %408, %412 ], [ %421, %415 ]
  %424 = phi ptr [ %414, %412 ], [ %420, %415 ]
  %425 = add nsw i64 %423, 1
  store i64 %425, ptr %407, align 8, !tbaa !27
  %426 = getelementptr inbounds i64, ptr %424, i64 %423
  store i64 %406, ptr %426, align 8, !tbaa !11
  br label %2128

427:                                              ; preds = %389
  %428 = getelementptr inbounds i8, ptr %373, i64 %384
  %429 = sub nsw i64 %390, %384
  %430 = tail call fastcc i64 @mkstr(ptr noundef nonnull %428, i64 noundef %429)
  %431 = load i64, ptr %377, align 8, !tbaa !27
  %432 = load i64, ptr %378, align 8, !tbaa !70
  %433 = icmp slt i64 %431, %432
  br i1 %433, label %434, label %436

434:                                              ; preds = %427
  %435 = load ptr, ptr %379, align 8, !tbaa !32
  br label %442

436:                                              ; preds = %427
  %437 = shl nsw i64 %432, 1
  store i64 %437, ptr %378, align 8, !tbaa !70
  %438 = load ptr, ptr %379, align 8, !tbaa !32
  %439 = shl i64 %432, 4
  %440 = tail call ptr @realloc(ptr noundef %438, i64 noundef %439) #38
  store ptr %440, ptr %379, align 8, !tbaa !32
  %441 = load i64, ptr %377, align 8, !tbaa !27
  br label %442

442:                                              ; preds = %436, %434
  %443 = phi i64 [ %431, %434 ], [ %441, %436 ]
  %444 = phi ptr [ %435, %434 ], [ %440, %436 ]
  %445 = add nsw i64 %443, 1
  store i64 %445, ptr %377, align 8, !tbaa !27
  %446 = getelementptr inbounds i64, ptr %444, i64 %443
  store i64 %430, ptr %446, align 8, !tbaa !11
  %447 = load i64, ptr %365, align 8, !tbaa !18
  %448 = add nsw i64 %447, %390
  %449 = icmp sgt i64 %383, 0
  %450 = sext i1 %449 to i64
  %451 = add nsw i64 %383, %450
  %452 = icmp eq i64 %451, 0
  br i1 %452, label %398, label %381

453:                                              ; preds = %206
  %454 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(6) @.str.195) #35
  %455 = icmp eq i32 %454, 0
  br i1 %455, label %462, label %456

456:                                              ; preds = %453
  %457 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(7) @.str.196) #35
  %458 = icmp eq i32 %457, 0
  br i1 %458, label %462, label %459

459:                                              ; preds = %456
  %460 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(7) @.str.197) #35
  %461 = icmp eq i32 %460, 0
  br i1 %461, label %462, label %514

462:                                              ; preds = %459, %456, %453
  %463 = icmp sgt i64 %2, 0
  br i1 %463, label %464, label %471

464:                                              ; preds = %462
  %465 = load i64, ptr %3, align 8, !tbaa !11
  %466 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  %467 = icmp eq i64 %465, %466
  br i1 %467, label %471, label %468

468:                                              ; preds = %464
  %469 = inttoptr i64 %465 to ptr
  %470 = getelementptr inbounds nuw i8, ptr %469, i64 16
  br label %471

471:                                              ; preds = %468, %464, %462
  %472 = phi ptr [ %470, %468 ], [ @.str.198, %464 ], [ @.str.198, %462 ]
  %473 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %474 = load i64, ptr %473, align 8, !tbaa !18
  %475 = load i8, ptr %9, align 1, !tbaa !10
  %476 = icmp eq i8 %475, 114
  br i1 %476, label %493, label %477

477:                                              ; preds = %471
  %478 = getelementptr inbounds nuw i8, ptr %15, i64 16
  %479 = icmp sgt i64 %474, 0
  br i1 %479, label %480, label %490

480:                                              ; preds = %477, %487
  %481 = phi i64 [ %488, %487 ], [ 0, %477 ]
  %482 = getelementptr inbounds nuw i8, ptr %478, i64 %481
  %483 = load i8, ptr %482, align 1, !tbaa !10
  %484 = sext i8 %483 to i32
  %485 = tail call ptr @strchr(ptr noundef nonnull dereferenceable(1) %472, i32 noundef %484) #35
  %486 = icmp eq ptr %485, null
  br i1 %486, label %490, label %487

487:                                              ; preds = %480
  %488 = add nuw nsw i64 %481, 1
  %489 = icmp eq i64 %488, %474
  br i1 %489, label %490, label %480, !llvm.loop !169

490:                                              ; preds = %487, %480, %477
  %491 = phi i64 [ 0, %477 ], [ %474, %487 ], [ %481, %480 ]
  %492 = icmp eq i8 %475, 108
  br i1 %492, label %507, label %493

493:                                              ; preds = %490, %471
  %494 = phi i64 [ %491, %490 ], [ 0, %471 ]
  %495 = getelementptr i8, ptr %15, i64 15
  %496 = icmp sgt i64 %474, %494
  br i1 %496, label %497, label %507

497:                                              ; preds = %493, %504
  %498 = phi i64 [ %505, %504 ], [ %474, %493 ]
  %499 = getelementptr i8, ptr %495, i64 %498
  %500 = load i8, ptr %499, align 1, !tbaa !10
  %501 = sext i8 %500 to i32
  %502 = tail call ptr @strchr(ptr noundef nonnull dereferenceable(1) %472, i32 noundef %501) #35
  %503 = icmp eq ptr %502, null
  br i1 %503, label %507, label %504

504:                                              ; preds = %497
  %505 = add nsw i64 %498, -1
  %506 = icmp sgt i64 %505, %494
  br i1 %506, label %497, label %507, !llvm.loop !170

507:                                              ; preds = %504, %497, %493, %490
  %508 = phi i64 [ %491, %490 ], [ %494, %493 ], [ %494, %497 ], [ %494, %504 ]
  %509 = phi i64 [ %474, %490 ], [ %474, %493 ], [ %494, %504 ], [ %498, %497 ]
  %510 = getelementptr inbounds nuw i8, ptr %15, i64 16
  %511 = getelementptr inbounds nuw i8, ptr %510, i64 %508
  %512 = sub nsw i64 %509, %508
  %513 = tail call fastcc i64 @mkstr(ptr noundef nonnull %511, i64 noundef %512)
  br label %2128

514:                                              ; preds = %459
  %515 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(11) @.str.199) #35
  %516 = icmp eq i32 %515, 0
  br i1 %516, label %520, label %517

517:                                              ; preds = %514
  %518 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(9) @.str.200) #35
  %519 = icmp eq i32 %518, 0
  br i1 %519, label %520, label %576

520:                                              ; preds = %517, %514
  %521 = load i8, ptr %9, align 1, !tbaa !10
  %522 = icmp eq i8 %521, 115
  %523 = load i64, ptr %3, align 8, !tbaa !11
  %524 = and i64 %523, 1
  %525 = icmp ne i64 %524, 0
  %526 = icmp eq i64 %523, 0
  %527 = or i1 %526, %525
  br i1 %527, label %537, label %528

528:                                              ; preds = %520
  %529 = inttoptr i64 %523 to ptr
  %530 = load i64, ptr %529, align 8, !tbaa !23
  %531 = freeze i64 %530
  %532 = icmp eq i64 %531, 6
  br i1 %532, label %533, label %537

533:                                              ; preds = %528
  %534 = getelementptr inbounds nuw i8, ptr %529, i64 8
  %535 = load i64, ptr %534, align 8, !tbaa !27
  %536 = icmp sgt i64 %535, 0
  br i1 %536, label %537, label %572

537:                                              ; preds = %533, %528, %520
  %538 = phi i64 [ %535, %533 ], [ 1, %528 ], [ 1, %520 ]
  %539 = phi ptr [ %529, %533 ], [ null, %528 ], [ null, %520 ]
  %540 = phi i1 [ false, %533 ], [ true, %528 ], [ true, %520 ]
  %541 = getelementptr inbounds nuw i8, ptr %539, i64 24
  %542 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %543 = load i64, ptr %542, align 8, !tbaa !18
  %544 = getelementptr inbounds nuw i8, ptr %15, i64 16
  %545 = getelementptr inbounds i8, ptr %544, i64 %543
  br label %546

546:                                              ; preds = %569, %537
  %547 = phi i64 [ 0, %537 ], [ %570, %569 ]
  br i1 %540, label %552, label %548

548:                                              ; preds = %546
  %549 = load ptr, ptr %541, align 8, !tbaa !32
  %550 = getelementptr inbounds nuw i64, ptr %549, i64 %547
  %551 = load i64, ptr %550, align 8, !tbaa !11
  br label %552

552:                                              ; preds = %548, %546
  %553 = phi i64 [ %551, %548 ], [ %523, %546 ]
  %554 = inttoptr i64 %553 to ptr
  %555 = getelementptr inbounds nuw i8, ptr %554, i64 8
  %556 = load i64, ptr %555, align 8, !tbaa !18
  %557 = icmp sgt i64 %556, %543
  br i1 %557, label %569, label %558

558:                                              ; preds = %552
  br i1 %522, label %559, label %563

559:                                              ; preds = %558
  %560 = getelementptr inbounds nuw i8, ptr %554, i64 16
  %561 = tail call i32 @memcmp(ptr noundef nonnull %544, ptr noundef nonnull %560, i64 noundef %556)
  %562 = icmp eq i32 %561, 0
  br i1 %562, label %574, label %569

563:                                              ; preds = %558
  %564 = sub i64 0, %556
  %565 = getelementptr inbounds i8, ptr %545, i64 %564
  %566 = getelementptr inbounds nuw i8, ptr %554, i64 16
  %567 = tail call i32 @memcmp(ptr noundef nonnull %565, ptr noundef nonnull %566, i64 noundef %556)
  %568 = icmp eq i32 %567, 0
  br i1 %568, label %574, label %569

569:                                              ; preds = %563, %559, %552
  %570 = add nuw nsw i64 %547, 1
  %571 = icmp eq i64 %570, %538
  br i1 %571, label %572, label %546, !llvm.loop !171

572:                                              ; preds = %569, %533
  %573 = load i64, ptr @rt_false_v, align 8
  br label %2128

574:                                              ; preds = %563, %559
  %575 = load i64, ptr @rt_true_v, align 8, !tbaa !11
  br label %2128

576:                                              ; preds = %517
  %577 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(5) @.str.201) #35
  %578 = icmp eq i32 %577, 0
  br i1 %578, label %579, label %592

579:                                              ; preds = %576
  %580 = load i64, ptr %3, align 8, !tbaa !11
  %581 = inttoptr i64 %580 to ptr
  %582 = icmp sgt i64 %2, 1
  br i1 %582, label %583, label %587

583:                                              ; preds = %579
  %584 = getelementptr inbounds nuw i8, ptr %3, i64 8
  %585 = load i64, ptr %584, align 8, !tbaa !11
  %586 = tail call fastcc i64 @toi(i64 noundef %585)
  br label %587

587:                                              ; preds = %583, %579
  %588 = phi i64 [ %586, %583 ], [ 0, %579 ]
  %589 = tail call fastcc i64 @str_find(ptr noundef nonnull %15, ptr noundef %581, i64 noundef %588)
  %590 = shl nsw i64 %589, 1
  %591 = or disjoint i64 %590, 1
  br label %2128

592:                                              ; preds = %576
  %593 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(6) @.str.202) #35
  %594 = icmp eq i32 %593, 0
  br i1 %594, label %595, label %618

595:                                              ; preds = %592
  %596 = load i64, ptr %3, align 8, !tbaa !11
  %597 = inttoptr i64 %596 to ptr
  %598 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %599 = load i64, ptr %598, align 8, !tbaa !18
  %600 = getelementptr inbounds nuw i8, ptr %597, i64 8
  %601 = load i64, ptr %600, align 8, !tbaa !18
  %602 = sub nsw i64 %599, %601
  %603 = icmp slt i64 %602, 0
  br i1 %603, label %2128, label %604

604:                                              ; preds = %595
  %605 = getelementptr inbounds nuw i8, ptr %15, i64 16
  %606 = getelementptr inbounds nuw i8, ptr %597, i64 16
  br label %607

607:                                              ; preds = %615, %604
  %608 = phi i64 [ %602, %604 ], [ %616, %615 ]
  %609 = getelementptr inbounds nuw i8, ptr %605, i64 %608
  %610 = tail call i32 @memcmp(ptr noundef nonnull %609, ptr noundef nonnull %606, i64 noundef %601)
  %611 = icmp eq i32 %610, 0
  br i1 %611, label %612, label %615

612:                                              ; preds = %607
  %613 = shl nuw nsw i64 %608, 1
  %614 = or disjoint i64 %613, 1
  br label %2128

615:                                              ; preds = %607
  %616 = add nsw i64 %608, -1
  %617 = icmp slt i64 %608, 1
  br i1 %617, label %2128, label %607, !llvm.loop !172

618:                                              ; preds = %592
  %619 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(6) @.str.203) #35
  %620 = icmp eq i32 %619, 0
  br i1 %620, label %621, label %637

621:                                              ; preds = %618
  %622 = load i64, ptr %3, align 8, !tbaa !11
  %623 = inttoptr i64 %622 to ptr
  %624 = icmp sgt i64 %2, 1
  br i1 %624, label %625, label %629

625:                                              ; preds = %621
  %626 = getelementptr inbounds nuw i8, ptr %3, i64 8
  %627 = load i64, ptr %626, align 8, !tbaa !11
  %628 = tail call fastcc i64 @toi(i64 noundef %627)
  br label %629

629:                                              ; preds = %625, %621
  %630 = phi i64 [ %628, %625 ], [ 0, %621 ]
  %631 = tail call fastcc i64 @str_find(ptr noundef nonnull %15, ptr noundef %623, i64 noundef %630)
  %632 = icmp slt i64 %631, 0
  br i1 %632, label %633, label %634

633:                                              ; preds = %629
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.25, ptr noundef nonnull @.str.204) #36
  unreachable

634:                                              ; preds = %629
  %635 = shl nuw nsw i64 %631, 1
  %636 = or disjoint i64 %635, 1
  br label %2128

637:                                              ; preds = %618
  %638 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(6) @.str.205) #35
  %639 = icmp eq i32 %638, 0
  br i1 %639, label %640, label %680

640:                                              ; preds = %637
  %641 = load i64, ptr %3, align 8, !tbaa !11
  %642 = inttoptr i64 %641 to ptr
  %643 = getelementptr inbounds nuw i8, ptr %642, i64 8
  %644 = load i64, ptr %643, align 8, !tbaa !18
  %645 = icmp eq i64 %644, 0
  br i1 %645, label %653, label %646

646:                                              ; preds = %640
  %647 = getelementptr inbounds nuw i8, ptr %15, i64 16
  %648 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %649 = load i64, ptr %648, align 8, !tbaa !18
  %650 = icmp sgt i64 %644, %649
  br i1 %650, label %676, label %651

651:                                              ; preds = %646
  %652 = getelementptr inbounds nuw i8, ptr %642, i64 16
  br label %658

653:                                              ; preds = %640
  %654 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %655 = load i64, ptr %654, align 8, !tbaa !18
  %656 = shl i64 %655, 1
  %657 = add i64 %656, 3
  br label %2128

658:                                              ; preds = %670, %651
  %659 = phi i64 [ 0, %651 ], [ %673, %670 ]
  %660 = phi i64 [ 0, %651 ], [ %671, %670 ]
  br label %661

661:                                              ; preds = %666, %658
  %662 = phi i64 [ %659, %658 ], [ %667, %666 ]
  %663 = getelementptr inbounds nuw i8, ptr %647, i64 %662
  %664 = tail call i32 @memcmp(ptr noundef nonnull readonly %663, ptr noundef nonnull readonly %652, i64 noundef %644)
  %665 = icmp eq i32 %664, 0
  br i1 %665, label %670, label %666

666:                                              ; preds = %661
  %667 = add nuw nsw i64 %662, 1
  %668 = add nsw i64 %667, %644
  %669 = icmp sgt i64 %668, %649
  br i1 %669, label %676, label %661, !llvm.loop !168

670:                                              ; preds = %661
  %671 = add nuw nsw i64 %660, 1
  %672 = add nsw i64 %662, %644
  %673 = tail call i64 @llvm.smax.i64(i64 %672, i64 0)
  %674 = add nsw i64 %673, %644
  %675 = icmp sgt i64 %674, %649
  br i1 %675, label %676, label %658, !llvm.loop !173

676:                                              ; preds = %670, %666, %646
  %677 = phi i64 [ %660, %666 ], [ 0, %646 ], [ %671, %670 ]
  %678 = shl nuw nsw i64 %677, 1
  %679 = or disjoint i64 %678, 1
  br label %2128

680:                                              ; preds = %637
  %681 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(8) @.str.206) #35
  %682 = icmp eq i32 %681, 0
  br i1 %682, label %683, label %796

683:                                              ; preds = %680
  %684 = load i64, ptr %3, align 8, !tbaa !11
  %685 = inttoptr i64 %684 to ptr
  %686 = getelementptr inbounds nuw i8, ptr %3, i64 8
  %687 = load i64, ptr %686, align 8, !tbaa !11
  %688 = inttoptr i64 %687 to ptr
  %689 = icmp sgt i64 %2, 2
  br i1 %689, label %690, label %694

690:                                              ; preds = %683
  %691 = getelementptr inbounds nuw i8, ptr %3, i64 16
  %692 = load i64, ptr %691, align 8, !tbaa !11
  %693 = tail call fastcc i64 @toi(i64 noundef %692)
  br label %694

694:                                              ; preds = %690, %683
  %695 = phi i64 [ %693, %690 ], [ -1, %683 ]
  %696 = getelementptr inbounds nuw i8, ptr %685, i64 8
  %697 = load i64, ptr %696, align 8, !tbaa !18
  %698 = icmp eq i64 %697, 0
  br i1 %698, label %699, label %700

699:                                              ; preds = %694
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.25, ptr noundef nonnull @.str.207) #36
  unreachable

700:                                              ; preds = %694
  call void @llvm.lifetime.start.p0(ptr nonnull %5) #35
  call fastcc void @sb_init(ptr noundef %5)
  %701 = load ptr, ptr %5, align 8
  %702 = icmp eq i64 %695, 0
  br i1 %702, label %730, label %703

703:                                              ; preds = %700
  %704 = getelementptr inbounds nuw i8, ptr %15, i64 16
  %705 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %706 = getelementptr inbounds nuw i8, ptr %685, i64 16
  %707 = getelementptr inbounds nuw i8, ptr %5, i64 8
  %708 = getelementptr inbounds nuw i8, ptr %5, i64 16
  %709 = getelementptr inbounds nuw i8, ptr %688, i64 16
  %710 = getelementptr inbounds nuw i8, ptr %688, i64 8
  %711 = load i64, ptr %696, align 8, !tbaa !18
  br label %712

712:                                              ; preds = %781, %703
  %713 = phi i64 [ %711, %703 ], [ %785, %781 ]
  %714 = phi i64 [ 0, %703 ], [ %786, %781 ]
  %715 = phi i64 [ %695, %703 ], [ %789, %781 ]
  %716 = phi ptr [ %701, %703 ], [ %782, %781 ]
  %717 = tail call i64 @llvm.smax.i64(i64 %714, i64 0)
  %718 = load i64, ptr %705, align 8, !tbaa !18
  %719 = add nsw i64 %717, %713
  %720 = icmp sgt i64 %719, %718
  br i1 %720, label %730, label %721

721:                                              ; preds = %712, %726
  %722 = phi i64 [ %727, %726 ], [ %717, %712 ]
  %723 = getelementptr inbounds nuw i8, ptr %704, i64 %722
  %724 = tail call i32 @memcmp(ptr noundef nonnull readonly %723, ptr noundef nonnull readonly %706, i64 noundef %713)
  %725 = icmp eq i32 %724, 0
  br i1 %725, label %754, label %726

726:                                              ; preds = %721
  %727 = add nuw nsw i64 %722, 1
  %728 = add nsw i64 %727, %713
  %729 = icmp sgt i64 %728, %718
  br i1 %729, label %735, label %721, !llvm.loop !168

730:                                              ; preds = %781, %712, %700
  %731 = phi ptr [ %701, %700 ], [ %782, %781 ], [ %716, %712 ]
  %732 = phi i64 [ 0, %700 ], [ %786, %781 ], [ %714, %712 ]
  %733 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %734 = load i64, ptr %733, align 8, !tbaa !18
  br label %735

735:                                              ; preds = %726, %730
  %736 = phi i64 [ %734, %730 ], [ %718, %726 ]
  %737 = phi ptr [ %731, %730 ], [ %716, %726 ]
  %738 = phi i64 [ %732, %730 ], [ %714, %726 ]
  %739 = getelementptr inbounds nuw i8, ptr %15, i64 16
  %740 = getelementptr inbounds i8, ptr %739, i64 %738
  %741 = sub nsw i64 %736, %738
  %742 = getelementptr inbounds nuw i8, ptr %5, i64 8
  %743 = load i64, ptr %742, align 8, !tbaa !63
  %744 = add nsw i64 %743, %741
  %745 = getelementptr inbounds nuw i8, ptr %5, i64 16
  %746 = load i64, ptr %745, align 8, !tbaa !82
  %747 = icmp slt i64 %744, %746
  br i1 %747, label %791, label %748

748:                                              ; preds = %735, %748
  %749 = phi i64 [ %750, %748 ], [ %746, %735 ]
  %750 = shl nsw i64 %749, 1
  %751 = icmp sgt i64 %750, %744
  br i1 %751, label %752, label %748, !llvm.loop !83

752:                                              ; preds = %748
  %753 = tail call ptr @realloc(ptr noundef %737, i64 noundef %750) #38
  br label %791

754:                                              ; preds = %721
  %755 = getelementptr inbounds i8, ptr %704, i64 %714
  %756 = sub nsw i64 %722, %714
  %757 = load i64, ptr %707, align 8, !tbaa !63
  %758 = add nsw i64 %757, %756
  %759 = load i64, ptr %708, align 8, !tbaa !82
  %760 = icmp slt i64 %758, %759
  br i1 %760, label %767, label %761

761:                                              ; preds = %754, %761
  %762 = phi i64 [ %763, %761 ], [ %759, %754 ]
  %763 = shl nsw i64 %762, 1
  %764 = icmp sgt i64 %763, %758
  br i1 %764, label %765, label %761, !llvm.loop !83

765:                                              ; preds = %761
  %766 = tail call ptr @realloc(ptr noundef %716, i64 noundef %763) #38
  store i64 %763, ptr %708, align 8, !tbaa !82
  br label %767

767:                                              ; preds = %765, %754
  %768 = phi ptr [ %766, %765 ], [ %716, %754 ]
  %769 = getelementptr inbounds i8, ptr %768, i64 %757
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %769, ptr noundef nonnull readonly align 1 %755, i64 noundef %756, i1 noundef false) #35
  %770 = getelementptr inbounds i8, ptr %768, i64 %758
  store i8 0, ptr %770, align 1, !tbaa !10
  %771 = load i64, ptr %710, align 8, !tbaa !18
  %772 = add nsw i64 %771, %758
  %773 = load i64, ptr %708, align 8, !tbaa !82
  %774 = icmp slt i64 %772, %773
  br i1 %774, label %781, label %775

775:                                              ; preds = %767, %775
  %776 = phi i64 [ %777, %775 ], [ %773, %767 ]
  %777 = shl nsw i64 %776, 1
  %778 = icmp sgt i64 %777, %772
  br i1 %778, label %779, label %775, !llvm.loop !83

779:                                              ; preds = %775
  %780 = tail call ptr @realloc(ptr noundef nonnull %768, i64 noundef %777) #38
  store i64 %777, ptr %708, align 8, !tbaa !82
  br label %781

781:                                              ; preds = %779, %767
  %782 = phi ptr [ %780, %779 ], [ %768, %767 ]
  %783 = getelementptr inbounds i8, ptr %782, i64 %758
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %783, ptr noundef nonnull readonly align 1 %709, i64 noundef %771, i1 noundef false) #35
  store i64 %772, ptr %707, align 8, !tbaa !63
  %784 = getelementptr inbounds i8, ptr %782, i64 %772
  store i8 0, ptr %784, align 1, !tbaa !10
  %785 = load i64, ptr %696, align 8, !tbaa !18
  %786 = add nsw i64 %785, %722
  %787 = icmp sgt i64 %715, 0
  %788 = sext i1 %787 to i64
  %789 = add nsw i64 %715, %788
  %790 = icmp eq i64 %789, 0
  br i1 %790, label %730, label %712

791:                                              ; preds = %752, %735
  %792 = phi ptr [ %753, %752 ], [ %737, %735 ]
  %793 = getelementptr inbounds i8, ptr %792, i64 %743
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %793, ptr noundef nonnull readonly align 1 %740, i64 noundef %741, i1 noundef false) #35
  %794 = getelementptr inbounds i8, ptr %792, i64 %744
  store i8 0, ptr %794, align 1, !tbaa !10
  %795 = tail call fastcc i64 @mkstr(ptr noundef %792, i64 noundef %744)
  call void @llvm.lifetime.end.p0(ptr nonnull %5) #35
  br label %2128

796:                                              ; preds = %680
  %797 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(6) @.str.208) #35
  %798 = icmp eq i32 %797, 0
  br i1 %798, label %802, label %799

799:                                              ; preds = %796
  %800 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(6) @.str.209) #35
  %801 = icmp eq i32 %800, 0
  br i1 %801, label %802, label %832

802:                                              ; preds = %799, %796
  %803 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %804 = load i64, ptr %803, align 8, !tbaa !18
  %805 = add nsw i64 %804, 1
  %806 = tail call fastcc ptr @xmalloc(i64 noundef %805)
  %807 = load i64, ptr %803, align 8, !tbaa !18
  %808 = icmp sgt i64 %807, 0
  br i1 %808, label %809, label %811

809:                                              ; preds = %802
  %810 = getelementptr inbounds nuw i8, ptr %15, i64 16
  br label %814

811:                                              ; preds = %825, %802
  %812 = phi i64 [ %807, %802 ], [ %830, %825 ]
  %813 = tail call fastcc i64 @mkstr(ptr noundef nonnull %806, i64 noundef %812)
  br label %2128

814:                                              ; preds = %825, %809
  %815 = phi i64 [ 0, %809 ], [ %829, %825 ]
  %816 = load i8, ptr %9, align 1, !tbaa !10
  %817 = icmp eq i8 %816, 117
  %818 = getelementptr inbounds nuw i8, ptr %810, i64 %815
  %819 = load i8, ptr %818, align 1, !tbaa !10
  %820 = zext i8 %819 to i32
  br i1 %817, label %821, label %823

821:                                              ; preds = %814
  %822 = tail call i32 @__toupper(i32 noundef %820) #35
  br label %825

823:                                              ; preds = %814
  %824 = tail call i32 @__tolower(i32 noundef %820) #35
  br label %825

825:                                              ; preds = %823, %821
  %826 = phi i32 [ %822, %821 ], [ %824, %823 ]
  %827 = trunc i32 %826 to i8
  %828 = getelementptr inbounds nuw i8, ptr %806, i64 %815
  store i8 %827, ptr %828, align 1, !tbaa !10
  %829 = add nuw nsw i64 %815, 1
  %830 = load i64, ptr %803, align 8, !tbaa !18
  %831 = icmp slt i64 %829, %830
  br i1 %831, label %814, label %811, !llvm.loop !174

832:                                              ; preds = %799
  %833 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(11) @.str.210) #35
  %834 = icmp eq i32 %833, 0
  br i1 %834, label %835, label %864

835:                                              ; preds = %832
  %836 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %837 = load i64, ptr %836, align 8, !tbaa !18
  %838 = add nsw i64 %837, 1
  %839 = tail call fastcc ptr @xmalloc(i64 noundef %838)
  %840 = load i64, ptr %836, align 8, !tbaa !18
  %841 = icmp sgt i64 %840, 0
  br i1 %841, label %842, label %850

842:                                              ; preds = %835
  %843 = getelementptr inbounds nuw i8, ptr %15, i64 16
  %844 = load i8, ptr %843, align 1, !tbaa !10
  %845 = zext i8 %844 to i32
  %846 = tail call i32 @__toupper(i32 noundef %845) #35
  %847 = load i64, ptr %836, align 8, !tbaa !18
  %848 = trunc i32 %846 to i8
  store i8 %848, ptr %839, align 1, !tbaa !10
  %849 = icmp sgt i64 %847, 1
  br i1 %849, label %853, label %850

850:                                              ; preds = %853, %842, %835
  %851 = phi i64 [ %840, %835 ], [ %847, %842 ], [ %859, %853 ]
  %852 = tail call fastcc i64 @mkstr(ptr noundef nonnull %839, i64 noundef %851)
  br label %2128

853:                                              ; preds = %842, %853
  %854 = phi i64 [ %862, %853 ], [ 1, %842 ]
  %855 = getelementptr inbounds nuw i8, ptr %843, i64 %854
  %856 = load i8, ptr %855, align 1, !tbaa !10
  %857 = zext i8 %856 to i32
  %858 = tail call i32 @__tolower(i32 noundef %857) #35
  %859 = load i64, ptr %836, align 8, !tbaa !18
  %860 = trunc i32 %858 to i8
  %861 = getelementptr inbounds nuw i8, ptr %839, i64 %854
  store i8 %860, ptr %861, align 1, !tbaa !10
  %862 = add nuw nsw i64 %854, 1
  %863 = icmp slt i64 %862, %859
  br i1 %863, label %853, label %850, !llvm.loop !175

864:                                              ; preds = %832
  %865 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(8) @.str.211) #35
  %866 = icmp eq i32 %865, 0
  br i1 %866, label %882, label %867

867:                                              ; preds = %864
  %868 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(8) @.str.212) #35
  %869 = icmp eq i32 %868, 0
  br i1 %869, label %882, label %870

870:                                              ; preds = %867
  %871 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(8) @.str.213) #35
  %872 = icmp eq i32 %871, 0
  br i1 %872, label %882, label %873

873:                                              ; preds = %870
  %874 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(8) @.str.214) #35
  %875 = icmp eq i32 %874, 0
  br i1 %875, label %882, label %876

876:                                              ; preds = %873
  %877 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(8) @.str.215) #35
  %878 = icmp eq i32 %877, 0
  br i1 %878, label %882, label %879

879:                                              ; preds = %876
  %880 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(8) @.str.216) #35
  %881 = icmp eq i32 %880, 0
  br i1 %881, label %882, label %1030

882:                                              ; preds = %879, %876, %873, %870, %867, %864
  %883 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %884 = load i64, ptr %883, align 8, !tbaa !18
  %885 = icmp eq i64 %884, 0
  br i1 %885, label %893, label %886

886:                                              ; preds = %882
  %887 = icmp sgt i64 %884, 0
  br i1 %887, label %888, label %1014

888:                                              ; preds = %886
  %889 = getelementptr inbounds nuw i8, ptr %15, i64 16
  %890 = getelementptr inbounds nuw i8, ptr %8, i64 18
  %891 = getelementptr inbounds nuw i8, ptr %8, i64 19
  %892 = getelementptr inbounds nuw i8, ptr %8, i64 20
  br label %895

893:                                              ; preds = %882
  %894 = load i64, ptr @rt_false_v, align 8, !tbaa !11
  br label %2128

895:                                              ; preds = %1004, %888
  %896 = phi i64 [ 0, %888 ], [ %1008, %1004 ]
  %897 = phi i32 [ 0, %888 ], [ %1007, %1004 ]
  %898 = getelementptr inbounds nuw i8, ptr %889, i64 %896
  %899 = load i8, ptr %898, align 1, !tbaa !10
  %900 = load i8, ptr %890, align 1, !tbaa !10
  switch i8 %900, label %968 [
    i8 100, label %901
    i8 97, label %904
    i8 117, label %949
    i8 115, label %936
  ]

901:                                              ; preds = %895
  %902 = add i8 %899, -48
  %903 = icmp ult i8 %902, 10
  br label %990

904:                                              ; preds = %895
  %905 = load i8, ptr %891, align 1, !tbaa !10
  %906 = icmp eq i8 %905, 108
  br i1 %906, label %907, label %923

907:                                              ; preds = %904
  %908 = load i8, ptr %892, align 1, !tbaa !10
  %909 = icmp eq i8 %908, 112
  br i1 %909, label %910, label %923

910:                                              ; preds = %907
  %911 = icmp sgt i8 %899, -1
  br i1 %911, label %912, label %917

912:                                              ; preds = %910
  %913 = zext nneg i8 %899 to i64
  %914 = getelementptr inbounds nuw i32, ptr getelementptr inbounds nuw (i8, ptr @_DefaultRuneLocale, i64 60), i64 %913
  %915 = load i32, ptr %914, align 4, !tbaa !6
  %916 = and i32 %915, 256
  br label %920

917:                                              ; preds = %910
  %918 = zext i8 %899 to i32
  %919 = tail call i32 @__maskrune(i32 noundef %918, i64 noundef 256) #35
  br label %920

920:                                              ; preds = %917, %912
  %921 = phi i32 [ %916, %912 ], [ %919, %917 ]
  %922 = icmp ne i32 %921, 0
  br label %990

923:                                              ; preds = %907, %904
  %924 = icmp sgt i8 %899, -1
  br i1 %924, label %925, label %930

925:                                              ; preds = %923
  %926 = zext nneg i8 %899 to i64
  %927 = getelementptr inbounds nuw i32, ptr getelementptr inbounds nuw (i8, ptr @_DefaultRuneLocale, i64 60), i64 %926
  %928 = load i32, ptr %927, align 4, !tbaa !6
  %929 = and i32 %928, 1280
  br label %933

930:                                              ; preds = %923
  %931 = zext i8 %899 to i32
  %932 = tail call i32 @__maskrune(i32 noundef %931, i64 noundef 1280) #35
  br label %933

933:                                              ; preds = %930, %925
  %934 = phi i32 [ %929, %925 ], [ %932, %930 ]
  %935 = icmp ne i32 %934, 0
  br label %990

936:                                              ; preds = %895
  %937 = icmp sgt i8 %899, -1
  br i1 %937, label %938, label %943

938:                                              ; preds = %936
  %939 = zext nneg i8 %899 to i64
  %940 = getelementptr inbounds nuw i32, ptr getelementptr inbounds nuw (i8, ptr @_DefaultRuneLocale, i64 60), i64 %939
  %941 = load i32, ptr %940, align 4, !tbaa !6
  %942 = and i32 %941, 16384
  br label %946

943:                                              ; preds = %936
  %944 = zext i8 %899 to i32
  %945 = tail call i32 @__maskrune(i32 noundef %944, i64 noundef 16384) #35
  br label %946

946:                                              ; preds = %943, %938
  %947 = phi i32 [ %942, %938 ], [ %945, %943 ]
  %948 = icmp ne i32 %947, 0
  br label %990

949:                                              ; preds = %895
  %950 = zext i8 %899 to i32
  %951 = icmp sgt i8 %899, -1
  br i1 %951, label %952, label %958

952:                                              ; preds = %949
  %953 = zext nneg i8 %899 to i64
  %954 = getelementptr inbounds nuw i32, ptr getelementptr inbounds nuw (i8, ptr @_DefaultRuneLocale, i64 60), i64 %953
  %955 = load i32, ptr %954, align 4, !tbaa !6
  %956 = and i32 %955, 32768
  %957 = icmp eq i32 %956, 0
  br i1 %957, label %961, label %993

958:                                              ; preds = %949
  %959 = tail call i32 @__maskrune(i32 noundef %950, i64 noundef 32768) #35
  %960 = icmp eq i32 %959, 0
  br i1 %960, label %963, label %987

961:                                              ; preds = %952
  %962 = and i32 %955, 256
  br label %965

963:                                              ; preds = %958
  %964 = tail call i32 @__maskrune(i32 noundef %950, i64 noundef 256) #35
  br label %965

965:                                              ; preds = %963, %961
  %966 = phi i32 [ %962, %961 ], [ %964, %963 ]
  %967 = icmp eq i32 %966, 0
  br label %990

968:                                              ; preds = %895
  %969 = zext i8 %899 to i32
  %970 = icmp sgt i8 %899, -1
  br i1 %970, label %971, label %977

971:                                              ; preds = %968
  %972 = zext nneg i8 %899 to i64
  %973 = getelementptr inbounds nuw i32, ptr getelementptr inbounds nuw (i8, ptr @_DefaultRuneLocale, i64 60), i64 %972
  %974 = load i32, ptr %973, align 4, !tbaa !6
  %975 = and i32 %974, 4096
  %976 = icmp eq i32 %975, 0
  br i1 %976, label %980, label %993

977:                                              ; preds = %968
  %978 = tail call i32 @__maskrune(i32 noundef %969, i64 noundef 4096) #35
  %979 = icmp eq i32 %978, 0
  br i1 %979, label %982, label %987

980:                                              ; preds = %971
  %981 = and i32 %974, 256
  br label %984

982:                                              ; preds = %977
  %983 = tail call i32 @__maskrune(i32 noundef %969, i64 noundef 256) #35
  br label %984

984:                                              ; preds = %982, %980
  %985 = phi i32 [ %981, %980 ], [ %983, %982 ]
  %986 = icmp eq i32 %985, 0
  br label %990

987:                                              ; preds = %977, %958
  %988 = phi i32 [ %969, %977 ], [ %950, %958 ]
  %989 = tail call i32 @__maskrune(i32 noundef %988, i64 noundef 256) #35
  br label %1004

990:                                              ; preds = %984, %965, %946, %933, %920, %901
  %991 = phi i1 [ %903, %901 ], [ %922, %920 ], [ %935, %933 ], [ %948, %946 ], [ %967, %965 ], [ %986, %984 ]
  %992 = icmp sgt i8 %899, -1
  br i1 %992, label %996, label %1001

993:                                              ; preds = %971, %952
  %994 = phi i32 [ %974, %971 ], [ %955, %952 ]
  %995 = and i32 %994, 256
  br label %1004

996:                                              ; preds = %990
  %997 = zext nneg i8 %899 to i64
  %998 = getelementptr inbounds nuw i32, ptr getelementptr inbounds nuw (i8, ptr @_DefaultRuneLocale, i64 60), i64 %997
  %999 = load i32, ptr %998, align 4, !tbaa !6
  %1000 = and i32 %999, 256
  br i1 %991, label %1004, label %1156

1001:                                             ; preds = %990
  %1002 = zext i8 %899 to i32
  %1003 = tail call i32 @__maskrune(i32 noundef %1002, i64 noundef 256) #35
  br i1 %991, label %1004, label %1156

1004:                                             ; preds = %1001, %996, %993, %987
  %1005 = phi i32 [ %1000, %996 ], [ %1003, %1001 ], [ %989, %987 ], [ %995, %993 ]
  %1006 = icmp eq i32 %1005, 0
  %1007 = select i1 %1006, i32 %897, i32 1
  %1008 = add nuw nsw i64 %896, 1
  %1009 = load i64, ptr %883, align 8, !tbaa !18
  %1010 = icmp slt i64 %1008, %1009
  br i1 %1010, label %895, label %1011, !llvm.loop !176

1011:                                             ; preds = %1004
  %1012 = load i8, ptr %890, align 1, !tbaa !10
  %1013 = icmp eq i8 %1012, 117
  br i1 %1013, label %1024, label %1018

1014:                                             ; preds = %886
  %1015 = getelementptr inbounds nuw i8, ptr %8, i64 18
  %1016 = load i8, ptr %1015, align 1, !tbaa !10
  %1017 = icmp eq i8 %1016, 117
  br i1 %1017, label %1026, label %1018

1018:                                             ; preds = %1014, %1011
  %1019 = phi i8 [ %1016, %1014 ], [ %1012, %1011 ]
  %1020 = phi i32 [ 0, %1014 ], [ %1007, %1011 ]
  %1021 = icmp ne i8 %1019, 108
  %1022 = icmp ne i32 %1020, 0
  %1023 = select i1 %1021, i1 true, i1 %1022
  br i1 %1023, label %1028, label %1026

1024:                                             ; preds = %1011
  %1025 = icmp eq i32 %1007, 0
  br i1 %1025, label %1026, label %1028

1026:                                             ; preds = %1024, %1018, %1014
  %1027 = load i64, ptr @rt_false_v, align 8, !tbaa !11
  br label %2128

1028:                                             ; preds = %1024, %1018
  %1029 = load i64, ptr @rt_true_v, align 8, !tbaa !11
  br label %2128

1030:                                             ; preds = %879
  %1031 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(6) @.str.217) #35
  %1032 = icmp eq i32 %1031, 0
  br i1 %1032, label %1039, label %1033

1033:                                             ; preds = %1030
  %1034 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(6) @.str.218) #35
  %1035 = icmp eq i32 %1034, 0
  br i1 %1035, label %1039, label %1036

1036:                                             ; preds = %1033
  %1037 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(7) @.str.219) #35
  %1038 = icmp eq i32 %1037, 0
  br i1 %1038, label %1039, label %1083

1039:                                             ; preds = %1036, %1033, %1030
  %1040 = load i64, ptr %3, align 8, !tbaa !11
  %1041 = tail call fastcc i64 @toi(i64 noundef %1040)
  %1042 = icmp sgt i64 %2, 1
  br i1 %1042, label %1043, label %1049

1043:                                             ; preds = %1039
  %1044 = getelementptr inbounds nuw i8, ptr %3, i64 8
  %1045 = load i64, ptr %1044, align 8, !tbaa !11
  %1046 = inttoptr i64 %1045 to ptr
  %1047 = getelementptr inbounds nuw i8, ptr %1046, i64 16
  %1048 = load i8, ptr %1047, align 8, !tbaa !10
  br label %1049

1049:                                             ; preds = %1043, %1039
  %1050 = phi i8 [ %1048, %1043 ], [ 32, %1039 ]
  call void @llvm.lifetime.start.p0(ptr nonnull %6) #35
  call fastcc void @sb_init(ptr noundef %6)
  %1051 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %1052 = load i64, ptr %1051, align 8, !tbaa !18
  %1053 = icmp sgt i64 %1041, %1052
  %1054 = sub nsw i64 %1041, %1052
  %1055 = select i1 %1053, i64 %1054, i64 0
  %1056 = load i8, ptr %9, align 1, !tbaa !10
  switch i8 %1056, label %1064 [
    i8 114, label %1059
    i8 99, label %1057
  ]

1057:                                             ; preds = %1049
  %1058 = lshr i64 %1055, 1
  br label %1059

1059:                                             ; preds = %1057, %1049
  %1060 = phi i64 [ %1055, %1049 ], [ %1058, %1057 ]
  %1061 = icmp sgt i64 %1060, 0
  br i1 %1061, label %1070, label %1064

1062:                                             ; preds = %1070
  %1063 = load i64, ptr %1051, align 8, !tbaa !18
  br label %1064

1064:                                             ; preds = %1062, %1059, %1049
  %1065 = phi i64 [ %1060, %1062 ], [ %1060, %1059 ], [ 0, %1049 ]
  %1066 = phi i64 [ %1063, %1062 ], [ %1052, %1059 ], [ %1052, %1049 ]
  %1067 = getelementptr inbounds nuw i8, ptr %15, i64 16
  call fastcc void @sb_add(ptr noundef %6, ptr noundef nonnull %1067, i64 noundef %1066)
  %1068 = sub nsw i64 %1055, %1065
  %1069 = icmp sgt i64 %1068, 0
  br i1 %1069, label %1079, label %1074

1070:                                             ; preds = %1059, %1070
  %1071 = phi i64 [ %1072, %1070 ], [ 0, %1059 ]
  call fastcc void @sb_putc(ptr noundef %6, i8 noundef signext %1050)
  %1072 = add nuw nsw i64 %1071, 1
  %1073 = icmp eq i64 %1072, %1060
  br i1 %1073, label %1062, label %1070, !llvm.loop !177

1074:                                             ; preds = %1079, %1064
  %1075 = load ptr, ptr %6, align 8, !tbaa !61
  %1076 = getelementptr inbounds nuw i8, ptr %6, i64 8
  %1077 = load i64, ptr %1076, align 8, !tbaa !63
  %1078 = tail call fastcc i64 @mkstr(ptr noundef %1075, i64 noundef %1077)
  call void @llvm.lifetime.end.p0(ptr nonnull %6) #35
  br label %2128

1079:                                             ; preds = %1064, %1079
  %1080 = phi i64 [ %1081, %1079 ], [ 0, %1064 ]
  call fastcc void @sb_putc(ptr noundef %6, i8 noundef signext %1050)
  %1081 = add nuw nsw i64 %1080, 1
  %1082 = icmp slt i64 %1081, %1068
  br i1 %1082, label %1079, label %1074, !llvm.loop !178

1083:                                             ; preds = %1036
  %1084 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(6) @.str.220) #35
  %1085 = icmp eq i32 %1084, 0
  br i1 %1085, label %1086, label %1113

1086:                                             ; preds = %1083
  %1087 = load i64, ptr %3, align 8, !tbaa !11
  %1088 = tail call fastcc i64 @toi(i64 noundef %1087)
  call void @llvm.lifetime.start.p0(ptr nonnull %7) #35
  call fastcc void @sb_init(ptr noundef %7)
  %1089 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %1090 = load i64, ptr %1089, align 8, !tbaa !18
  %1091 = icmp sgt i64 %1088, %1090
  %1092 = sub i64 %1088, %1090
  %1093 = icmp eq i64 %1090, 0
  br i1 %1093, label %1098, label %1094

1094:                                             ; preds = %1086
  %1095 = getelementptr inbounds nuw i8, ptr %15, i64 16
  %1096 = load i8, ptr %1095, align 8, !tbaa !10
  switch i8 %1096, label %1098 [
    i8 45, label %1097
    i8 43, label %1097
  ]

1097:                                             ; preds = %1094, %1094
  call fastcc void @sb_putc(ptr noundef %7, i8 noundef signext %1096)
  br label %1098

1098:                                             ; preds = %1097, %1094, %1086
  %1099 = phi i64 [ 1, %1097 ], [ 0, %1094 ], [ 0, %1086 ]
  br i1 %1091, label %1109, label %1100

1100:                                             ; preds = %1109, %1098
  %1101 = getelementptr inbounds nuw i8, ptr %15, i64 16
  %1102 = getelementptr inbounds nuw i8, ptr %1101, i64 %1099
  %1103 = load i64, ptr %1089, align 8, !tbaa !18
  %1104 = sub nsw i64 %1103, %1099
  call fastcc void @sb_add(ptr noundef %7, ptr noundef nonnull %1102, i64 noundef %1104)
  %1105 = load ptr, ptr %7, align 8, !tbaa !61
  %1106 = getelementptr inbounds nuw i8, ptr %7, i64 8
  %1107 = load i64, ptr %1106, align 8, !tbaa !63
  %1108 = tail call fastcc i64 @mkstr(ptr noundef %1105, i64 noundef %1107)
  call void @llvm.lifetime.end.p0(ptr nonnull %7) #35
  br label %2128

1109:                                             ; preds = %1098, %1109
  %1110 = phi i64 [ %1111, %1109 ], [ 0, %1098 ]
  call fastcc void @sb_putc(ptr noundef %7, i8 noundef signext 48)
  %1111 = add nuw i64 %1110, 1
  %1112 = icmp eq i64 %1111, %1092
  br i1 %1112, label %1100, label %1109, !llvm.loop !179

1113:                                             ; preds = %1083
  %1114 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(11) @.str.221) #35
  %1115 = icmp eq i32 %1114, 0
  br i1 %1115, label %1116, label %1144

1116:                                             ; preds = %1113
  %1117 = tail call fastcc i64 @mklist(i64 noundef 4)
  %1118 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %1119 = load i64, ptr %1118, align 8, !tbaa !18
  %1120 = icmp sgt i64 %1119, 0
  br i1 %1120, label %1121, label %2128

1121:                                             ; preds = %1116
  %1122 = getelementptr inbounds nuw i8, ptr %15, i64 16
  br label %1123

1123:                                             ; preds = %1136, %1121
  %1124 = phi i64 [ %1119, %1121 ], [ %1142, %1136 ]
  %1125 = phi i64 [ 0, %1121 ], [ %1141, %1136 ]
  %1126 = add nsw i64 %1125, 1
  %1127 = tail call i64 @llvm.smax.i64(i64 %1124, i64 %1126)
  br label %1128

1128:                                             ; preds = %1133, %1123
  %1129 = phi i64 [ %1125, %1123 ], [ %1134, %1133 ]
  %1130 = getelementptr inbounds i8, ptr %1122, i64 %1129
  %1131 = load i8, ptr %1130, align 1, !tbaa !10
  %1132 = icmp eq i8 %1131, 10
  br i1 %1132, label %1136, label %1133

1133:                                             ; preds = %1128
  %1134 = add i64 %1129, 1
  %1135 = icmp eq i64 %1134, %1127
  br i1 %1135, label %1136, label %1128, !llvm.loop !180

1136:                                             ; preds = %1133, %1128
  %1137 = phi i64 [ %1127, %1133 ], [ %1129, %1128 ]
  %1138 = getelementptr inbounds i8, ptr %1122, i64 %1125
  %1139 = sub nsw i64 %1137, %1125
  %1140 = tail call fastcc i64 @mkstr(ptr noundef nonnull %1138, i64 noundef %1139)
  tail call fastcc void @list_append(i64 noundef %1117, i64 noundef %1140)
  %1141 = add nsw i64 %1137, 1
  %1142 = load i64, ptr %1118, align 8, !tbaa !18
  %1143 = icmp slt i64 %1141, %1142
  br i1 %1143, label %1123, label %2128, !llvm.loop !181

1144:                                             ; preds = %1113
  %1145 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(7) @.str.222) #35
  %1146 = icmp eq i32 %1145, 0
  br i1 %1146, label %2128, label %1147

1147:                                             ; preds = %1144
  %1148 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(7) @.str.223) #35
  %1149 = icmp eq i32 %1148, 0
  br i1 %1149, label %2128, label %1150

1150:                                             ; preds = %1147
  %1151 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(7) @.str.224) #35
  %1152 = icmp eq i32 %1151, 0
  br i1 %1152, label %1153, label %1155

1153:                                             ; preds = %1150
  %1154 = tail call fastcc i64 @str_format_method(i64 noundef %0, i64 noundef %2, ptr noundef readonly %3)
  br label %2128

1155:                                             ; preds = %1150
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.54, ptr noundef nonnull @.str.225, ptr noundef nonnull %9) #36
  unreachable

1156:                                             ; preds = %1001, %996
  %1157 = load i64, ptr @rt_false_v, align 8
  br label %2128

1158:                                             ; preds = %14
  %1159 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(7) @.str.228) #35
  %1160 = icmp eq i32 %1159, 0
  br i1 %1160, label %1161, label %1184

1161:                                             ; preds = %1158
  %1162 = load i64, ptr %3, align 8, !tbaa !11
  %1163 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %1164 = load i64, ptr %1163, align 8, !tbaa !27
  %1165 = getelementptr inbounds nuw i8, ptr %15, i64 16
  %1166 = load i64, ptr %1165, align 8, !tbaa !70
  %1167 = icmp slt i64 %1164, %1166
  br i1 %1167, label %1168, label %1171

1168:                                             ; preds = %1161
  %1169 = getelementptr inbounds nuw i8, ptr %15, i64 24
  %1170 = load ptr, ptr %1169, align 8, !tbaa !32
  br label %1178

1171:                                             ; preds = %1161
  %1172 = shl nsw i64 %1166, 1
  store i64 %1172, ptr %1165, align 8, !tbaa !70
  %1173 = getelementptr inbounds nuw i8, ptr %15, i64 24
  %1174 = load ptr, ptr %1173, align 8, !tbaa !32
  %1175 = shl i64 %1166, 4
  %1176 = tail call ptr @realloc(ptr noundef %1174, i64 noundef %1175) #38
  store ptr %1176, ptr %1173, align 8, !tbaa !32
  %1177 = load i64, ptr %1163, align 8, !tbaa !27
  br label %1178

1178:                                             ; preds = %1171, %1168
  %1179 = phi i64 [ %1164, %1168 ], [ %1177, %1171 ]
  %1180 = phi ptr [ %1170, %1168 ], [ %1176, %1171 ]
  %1181 = add nsw i64 %1179, 1
  store i64 %1181, ptr %1163, align 8, !tbaa !27
  %1182 = getelementptr inbounds i64, ptr %1180, i64 %1179
  store i64 %1162, ptr %1182, align 8, !tbaa !11
  %1183 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  br label %2128

1184:                                             ; preds = %1158
  %1185 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(7) @.str.229) #35
  %1186 = icmp eq i32 %1185, 0
  br i1 %1186, label %1187, label %1245

1187:                                             ; preds = %1184
  %1188 = load i64, ptr %3, align 8, !tbaa !11
  %1189 = tail call fastcc i64 @as_list(i64 noundef %1188)
  %1190 = icmp eq i64 %1189, %1188
  br i1 %1190, label %1195, label %1191

1191:                                             ; preds = %1187
  %1192 = inttoptr i64 %1189 to ptr
  %1193 = getelementptr inbounds nuw i8, ptr %1192, i64 8
  %1194 = load i64, ptr %1193, align 8, !tbaa !27
  br label %1209

1195:                                             ; preds = %1187
  %1196 = inttoptr i64 %1188 to ptr
  %1197 = getelementptr inbounds nuw i8, ptr %1196, i64 8
  %1198 = load i64, ptr %1197, align 8, !tbaa !27
  %1199 = tail call fastcc i64 @mklist(i64 noundef %1198)
  %1200 = inttoptr i64 %1199 to ptr
  %1201 = getelementptr inbounds nuw i8, ptr %1200, i64 24
  %1202 = load ptr, ptr %1201, align 8, !tbaa !32
  %1203 = getelementptr inbounds nuw i8, ptr %1196, i64 24
  %1204 = load ptr, ptr %1203, align 8, !tbaa !32
  %1205 = load i64, ptr %1197, align 8, !tbaa !27
  %1206 = shl i64 %1205, 3
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %1202, ptr noundef align 1 %1204, i64 noundef %1206, i1 noundef false) #35
  %1207 = load i64, ptr %1197, align 8, !tbaa !27
  %1208 = getelementptr inbounds nuw i8, ptr %1200, i64 8
  store i64 %1207, ptr %1208, align 8, !tbaa !27
  br label %1209

1209:                                             ; preds = %1195, %1191
  %1210 = phi ptr [ %1192, %1191 ], [ %1200, %1195 ]
  %1211 = phi i64 [ %1194, %1191 ], [ %1207, %1195 ]
  %1212 = getelementptr inbounds nuw i8, ptr %1210, i64 8
  %1213 = icmp sgt i64 %1211, 0
  br i1 %1213, label %1214, label %1219

1214:                                             ; preds = %1209
  %1215 = getelementptr inbounds nuw i8, ptr %1210, i64 24
  %1216 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %1217 = getelementptr inbounds nuw i8, ptr %15, i64 16
  %1218 = getelementptr inbounds nuw i8, ptr %15, i64 24
  br label %1221

1219:                                             ; preds = %1237, %1209
  %1220 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  br label %2128

1221:                                             ; preds = %1237, %1214
  %1222 = phi i64 [ 0, %1214 ], [ %1242, %1237 ]
  %1223 = load ptr, ptr %1215, align 8, !tbaa !32
  %1224 = getelementptr inbounds nuw i64, ptr %1223, i64 %1222
  %1225 = load i64, ptr %1224, align 8, !tbaa !11
  %1226 = load i64, ptr %1216, align 8, !tbaa !27
  %1227 = load i64, ptr %1217, align 8, !tbaa !70
  %1228 = icmp slt i64 %1226, %1227
  br i1 %1228, label %1229, label %1231

1229:                                             ; preds = %1221
  %1230 = load ptr, ptr %1218, align 8, !tbaa !32
  br label %1237

1231:                                             ; preds = %1221
  %1232 = shl nsw i64 %1227, 1
  store i64 %1232, ptr %1217, align 8, !tbaa !70
  %1233 = load ptr, ptr %1218, align 8, !tbaa !32
  %1234 = shl i64 %1227, 4
  %1235 = tail call ptr @realloc(ptr noundef %1233, i64 noundef %1234) #38
  store ptr %1235, ptr %1218, align 8, !tbaa !32
  %1236 = load i64, ptr %1216, align 8, !tbaa !27
  br label %1237

1237:                                             ; preds = %1231, %1229
  %1238 = phi i64 [ %1226, %1229 ], [ %1236, %1231 ]
  %1239 = phi ptr [ %1230, %1229 ], [ %1235, %1231 ]
  %1240 = add nsw i64 %1238, 1
  store i64 %1240, ptr %1216, align 8, !tbaa !27
  %1241 = getelementptr inbounds i64, ptr %1239, i64 %1238
  store i64 %1225, ptr %1241, align 8, !tbaa !11
  %1242 = add nuw nsw i64 %1222, 1
  %1243 = load i64, ptr %1212, align 8, !tbaa !27
  %1244 = icmp slt i64 %1242, %1243
  br i1 %1244, label %1221, label %1219, !llvm.loop !182

1245:                                             ; preds = %1184
  %1246 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(4) @.str.230) #35
  %1247 = icmp eq i32 %1246, 0
  br i1 %1247, label %1248, label %1294

1248:                                             ; preds = %1245
  %1249 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %1250 = load i64, ptr %1249, align 8, !tbaa !27
  %1251 = icmp eq i64 %1250, 0
  br i1 %1251, label %1252, label %1253

1252:                                             ; preds = %1248
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.103, ptr noundef nonnull @.str.231) #36
  unreachable

1253:                                             ; preds = %1248
  %1254 = icmp eq i64 %2, 0
  br i1 %1254, label %1280, label %1255

1255:                                             ; preds = %1253
  %1256 = load i64, ptr %3, align 8, !tbaa !11
  %1257 = and i64 %1256, 1
  %1258 = icmp eq i64 %1257, 0
  br i1 %1258, label %1261, label %1259

1259:                                             ; preds = %1255
  %1260 = ashr i64 %1256, 1
  br label %1271

1261:                                             ; preds = %1255
  %1262 = icmp eq i64 %1256, 0
  br i1 %1262, label %1270, label %1263

1263:                                             ; preds = %1261
  %1264 = inttoptr i64 %1256 to ptr
  %1265 = load i64, ptr %1264, align 8, !tbaa !23
  %1266 = icmp eq i64 %1265, 2
  br i1 %1266, label %1267, label %1270

1267:                                             ; preds = %1263
  %1268 = getelementptr inbounds nuw i8, ptr %1264, i64 8
  %1269 = load i64, ptr %1268, align 8, !tbaa !25
  br label %1271

1270:                                             ; preds = %1263, %1261
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

1271:                                             ; preds = %1267, %1259
  %1272 = phi i64 [ %1260, %1259 ], [ %1269, %1267 ]
  %1273 = icmp slt i64 %1272, 0
  %1274 = select i1 %1273, i64 %1250, i64 0
  %1275 = add nsw i64 %1274, %1272
  %1276 = icmp sgt i64 %1275, -1
  %1277 = icmp slt i64 %1275, %1250
  %1278 = and i1 %1276, %1277
  br i1 %1278, label %1282, label %1279

1279:                                             ; preds = %1271
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.103, ptr noundef nonnull @.str.153, ptr noundef nonnull @.str.230) #36
  unreachable

1280:                                             ; preds = %1253
  %1281 = add nsw i64 %1250, -1
  br label %1282

1282:                                             ; preds = %1280, %1271
  %1283 = phi i64 [ %1281, %1280 ], [ %1275, %1271 ]
  %1284 = getelementptr inbounds nuw i8, ptr %15, i64 24
  %1285 = load ptr, ptr %1284, align 8, !tbaa !32
  %1286 = getelementptr inbounds i64, ptr %1285, i64 %1283
  %1287 = load i64, ptr %1286, align 8, !tbaa !11
  %1288 = getelementptr inbounds nuw i8, ptr %1286, i64 8
  %1289 = xor i64 %1283, -1
  %1290 = add i64 %1250, %1289
  %1291 = shl i64 %1290, 3
  tail call void @llvm.memmove.p0.p0.i64(ptr noundef nonnull align 1 %1286, ptr noundef nonnull align 1 %1288, i64 noundef %1291, i1 noundef false) #35
  %1292 = load i64, ptr %1249, align 8, !tbaa !27
  %1293 = add nsw i64 %1292, -1
  store i64 %1293, ptr %1249, align 8, !tbaa !27
  br label %2128

1294:                                             ; preds = %1245
  %1295 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(7) @.str.232) #35
  %1296 = icmp eq i32 %1295, 0
  br i1 %1296, label %1297, label %1353

1297:                                             ; preds = %1294
  %1298 = load i64, ptr %3, align 8, !tbaa !11
  %1299 = and i64 %1298, 1
  %1300 = icmp eq i64 %1299, 0
  br i1 %1300, label %1303, label %1301

1301:                                             ; preds = %1297
  %1302 = ashr i64 %1298, 1
  br label %1313

1303:                                             ; preds = %1297
  %1304 = icmp eq i64 %1298, 0
  br i1 %1304, label %1312, label %1305

1305:                                             ; preds = %1303
  %1306 = inttoptr i64 %1298 to ptr
  %1307 = load i64, ptr %1306, align 8, !tbaa !23
  %1308 = icmp eq i64 %1307, 2
  br i1 %1308, label %1309, label %1312

1309:                                             ; preds = %1305
  %1310 = getelementptr inbounds nuw i8, ptr %1306, i64 8
  %1311 = load i64, ptr %1310, align 8, !tbaa !25
  br label %1313

1312:                                             ; preds = %1305, %1303
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.107) #36
  unreachable

1313:                                             ; preds = %1309, %1301
  %1314 = phi i64 [ %1302, %1301 ], [ %1311, %1309 ]
  %1315 = icmp slt i64 %1314, 0
  %1316 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %1317 = load i64, ptr %1316, align 8, !tbaa !27
  %1318 = add nsw i64 %1317, %1314
  %1319 = tail call i64 @llvm.smax.i64(i64 %1318, i64 0)
  %1320 = select i1 %1315, i64 %1319, i64 %1314
  %1321 = tail call i64 @llvm.smin.i64(i64 %1320, i64 %1317)
  %1322 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  %1323 = getelementptr inbounds nuw i8, ptr %15, i64 16
  %1324 = load i64, ptr %1323, align 8, !tbaa !70
  %1325 = icmp slt i64 %1317, %1324
  br i1 %1325, label %1326, label %1329

1326:                                             ; preds = %1313
  %1327 = getelementptr inbounds nuw i8, ptr %15, i64 24
  %1328 = load ptr, ptr %1327, align 8, !tbaa !32
  br label %1336

1329:                                             ; preds = %1313
  %1330 = shl nsw i64 %1324, 1
  store i64 %1330, ptr %1323, align 8, !tbaa !70
  %1331 = getelementptr inbounds nuw i8, ptr %15, i64 24
  %1332 = load ptr, ptr %1331, align 8, !tbaa !32
  %1333 = shl i64 %1324, 4
  %1334 = tail call ptr @realloc(ptr noundef %1332, i64 noundef %1333) #38
  store ptr %1334, ptr %1331, align 8, !tbaa !32
  %1335 = load i64, ptr %1316, align 8, !tbaa !27
  br label %1336

1336:                                             ; preds = %1329, %1326
  %1337 = phi i64 [ %1317, %1326 ], [ %1335, %1329 ]
  %1338 = phi ptr [ %1328, %1326 ], [ %1334, %1329 ]
  %1339 = add nsw i64 %1337, 1
  store i64 %1339, ptr %1316, align 8, !tbaa !27
  %1340 = getelementptr inbounds i64, ptr %1338, i64 %1337
  store i64 %1322, ptr %1340, align 8, !tbaa !11
  %1341 = getelementptr inbounds nuw i8, ptr %15, i64 24
  %1342 = getelementptr inbounds i64, ptr %1338, i64 %1321
  %1343 = getelementptr inbounds nuw i8, ptr %1342, i64 8
  %1344 = load i64, ptr %1316, align 8, !tbaa !27
  %1345 = xor i64 %1321, -1
  %1346 = add i64 %1344, %1345
  %1347 = shl i64 %1346, 3
  tail call void @llvm.memmove.p0.p0.i64(ptr noundef nonnull align 1 %1343, ptr noundef align 1 %1342, i64 noundef %1347, i1 noundef false) #35
  %1348 = getelementptr inbounds nuw i8, ptr %3, i64 8
  %1349 = load i64, ptr %1348, align 8, !tbaa !11
  %1350 = load ptr, ptr %1341, align 8, !tbaa !32
  %1351 = getelementptr inbounds i64, ptr %1350, i64 %1321
  store i64 %1349, ptr %1351, align 8, !tbaa !11
  %1352 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  br label %2128

1353:                                             ; preds = %1294
  %1354 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(7) @.str.233) #35
  %1355 = icmp eq i32 %1354, 0
  br i1 %1355, label %1356, label %1386

1356:                                             ; preds = %1353
  %1357 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %1358 = load i64, ptr %1357, align 8, !tbaa !27
  %1359 = icmp sgt i64 %1358, 0
  br i1 %1359, label %1360, label %1385

1360:                                             ; preds = %1356
  %1361 = getelementptr inbounds nuw i8, ptr %15, i64 24
  br label %1362

1362:                                             ; preds = %1381, %1360
  %1363 = phi i64 [ 0, %1360 ], [ %1382, %1381 ]
  %1364 = load ptr, ptr %1361, align 8, !tbaa !32
  %1365 = getelementptr inbounds nuw i64, ptr %1364, i64 %1363
  %1366 = load i64, ptr %1365, align 8, !tbaa !11
  %1367 = load i64, ptr %3, align 8, !tbaa !11
  %1368 = tail call i64 @rt_eq_i(i64 noundef %1366, i64 noundef %1367)
  %1369 = icmp eq i64 %1368, 0
  br i1 %1369, label %1381, label %1370

1370:                                             ; preds = %1362
  %1371 = load ptr, ptr %1361, align 8, !tbaa !32
  %1372 = getelementptr inbounds nuw i64, ptr %1371, i64 %1363
  %1373 = getelementptr inbounds nuw i8, ptr %1372, i64 8
  %1374 = load i64, ptr %1357, align 8, !tbaa !27
  %1375 = xor i64 %1363, -1
  %1376 = add i64 %1374, %1375
  %1377 = shl i64 %1376, 3
  tail call void @llvm.memmove.p0.p0.i64(ptr noundef align 1 %1372, ptr noundef nonnull align 1 %1373, i64 noundef %1377, i1 noundef false) #35
  %1378 = load i64, ptr %1357, align 8, !tbaa !27
  %1379 = add nsw i64 %1378, -1
  store i64 %1379, ptr %1357, align 8, !tbaa !27
  %1380 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  br label %2128

1381:                                             ; preds = %1362
  %1382 = add nuw nsw i64 %1363, 1
  %1383 = load i64, ptr %1357, align 8, !tbaa !27
  %1384 = icmp slt i64 %1382, %1383
  br i1 %1384, label %1362, label %1385, !llvm.loop !183

1385:                                             ; preds = %1381, %1356
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.25, ptr noundef nonnull @.str.234) #36
  unreachable

1386:                                             ; preds = %1353
  %1387 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(6) @.str.203) #35
  %1388 = icmp eq i32 %1387, 0
  br i1 %1388, label %1389, label %1411

1389:                                             ; preds = %1386
  %1390 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %1391 = load i64, ptr %1390, align 8, !tbaa !27
  %1392 = icmp sgt i64 %1391, 0
  br i1 %1392, label %1393, label %1410

1393:                                             ; preds = %1389
  %1394 = getelementptr inbounds nuw i8, ptr %15, i64 24
  br label %1395

1395:                                             ; preds = %1406, %1393
  %1396 = phi i64 [ 0, %1393 ], [ %1407, %1406 ]
  %1397 = load ptr, ptr %1394, align 8, !tbaa !32
  %1398 = getelementptr inbounds nuw i64, ptr %1397, i64 %1396
  %1399 = load i64, ptr %1398, align 8, !tbaa !11
  %1400 = load i64, ptr %3, align 8, !tbaa !11
  %1401 = tail call i64 @rt_eq_i(i64 noundef %1399, i64 noundef %1400)
  %1402 = icmp eq i64 %1401, 0
  br i1 %1402, label %1406, label %1403

1403:                                             ; preds = %1395
  %1404 = shl nuw nsw i64 %1396, 1
  %1405 = or disjoint i64 %1404, 1
  br label %2128

1406:                                             ; preds = %1395
  %1407 = add nuw nsw i64 %1396, 1
  %1408 = load i64, ptr %1390, align 8, !tbaa !27
  %1409 = icmp slt i64 %1407, %1408
  br i1 %1409, label %1395, label %1410, !llvm.loop !184

1410:                                             ; preds = %1406, %1389
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.25, ptr noundef nonnull @.str.235) #36
  unreachable

1411:                                             ; preds = %1386
  %1412 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(6) @.str.205) #35
  %1413 = icmp eq i32 %1412, 0
  br i1 %1413, label %1414, label %1437

1414:                                             ; preds = %1411
  %1415 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %1416 = load i64, ptr %1415, align 8, !tbaa !27
  %1417 = icmp sgt i64 %1416, 0
  br i1 %1417, label %1418, label %2128

1418:                                             ; preds = %1414
  %1419 = getelementptr inbounds nuw i8, ptr %15, i64 24
  br label %1423

1420:                                             ; preds = %1423
  %1421 = shl nuw nsw i64 %1433, 1
  %1422 = or disjoint i64 %1421, 1
  br label %2128

1423:                                             ; preds = %1423, %1418
  %1424 = phi i64 [ 0, %1418 ], [ %1434, %1423 ]
  %1425 = phi i64 [ 0, %1418 ], [ %1433, %1423 ]
  %1426 = load ptr, ptr %1419, align 8, !tbaa !32
  %1427 = getelementptr inbounds nuw i64, ptr %1426, i64 %1424
  %1428 = load i64, ptr %1427, align 8, !tbaa !11
  %1429 = load i64, ptr %3, align 8, !tbaa !11
  %1430 = tail call i64 @rt_eq_i(i64 noundef %1428, i64 noundef %1429)
  %1431 = icmp ne i64 %1430, 0
  %1432 = zext i1 %1431 to i64
  %1433 = add nuw nsw i64 %1425, %1432
  %1434 = add nuw nsw i64 %1424, 1
  %1435 = load i64, ptr %1415, align 8, !tbaa !27
  %1436 = icmp slt i64 %1434, %1435
  br i1 %1436, label %1423, label %1420, !llvm.loop !185

1437:                                             ; preds = %1411
  %1438 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(8) @.str.236) #35
  %1439 = icmp eq i32 %1438, 0
  br i1 %1439, label %1440, label %1460

1440:                                             ; preds = %1437
  %1441 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %1442 = load i64, ptr %1441, align 8, !tbaa !27
  %1443 = icmp sgt i64 %1442, 1
  br i1 %1443, label %1444, label %1448

1444:                                             ; preds = %1440
  %1445 = add nsw i64 %1442, -1
  %1446 = getelementptr inbounds nuw i8, ptr %15, i64 24
  %1447 = load ptr, ptr %1446, align 8, !tbaa !32
  br label %1450

1448:                                             ; preds = %1450, %1440
  %1449 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  br label %2128

1450:                                             ; preds = %1450, %1444
  %1451 = phi i64 [ %1445, %1444 ], [ %1458, %1450 ]
  %1452 = phi i64 [ 0, %1444 ], [ %1457, %1450 ]
  %1453 = getelementptr inbounds nuw i64, ptr %1447, i64 %1452
  %1454 = load i64, ptr %1453, align 8, !tbaa !11
  %1455 = getelementptr inbounds i64, ptr %1447, i64 %1451
  %1456 = load i64, ptr %1455, align 8, !tbaa !11
  store i64 %1456, ptr %1453, align 8, !tbaa !11
  store i64 %1454, ptr %1455, align 8, !tbaa !11
  %1457 = add nuw nsw i64 %1452, 1
  %1458 = add nsw i64 %1451, -1
  %1459 = icmp slt i64 %1457, %1458
  br i1 %1459, label %1450, label %1448, !llvm.loop !186

1460:                                             ; preds = %1437
  %1461 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(5) @.str.237) #35
  %1462 = icmp eq i32 %1461, 0
  br i1 %1462, label %1463, label %1465

1463:                                             ; preds = %1460
  tail call fastcc void @list_sort(i64 noundef %0)
  %1464 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  br label %2128

1465:                                             ; preds = %1460
  %1466 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(5) @.str.238) #35
  %1467 = icmp eq i32 %1466, 0
  br i1 %1467, label %1468, label %1470

1468:                                             ; preds = %1465
  %1469 = tail call fastcc i64 @list_copy(i64 noundef %0)
  br label %2128

1470:                                             ; preds = %1465
  %1471 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(6) @.str.239) #35
  %1472 = icmp eq i32 %1471, 0
  br i1 %1472, label %1473, label %1476

1473:                                             ; preds = %1470
  %1474 = getelementptr inbounds nuw i8, ptr %15, i64 8
  store i64 0, ptr %1474, align 8, !tbaa !27
  %1475 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  br label %2128

1476:                                             ; preds = %1470
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.54, ptr noundef nonnull @.str.240, ptr noundef nonnull %9) #36
  unreachable

1477:                                             ; preds = %14
  %1478 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(6) @.str.203) #35
  %1479 = icmp eq i32 %1478, 0
  br i1 %1479, label %1480, label %1499

1480:                                             ; preds = %1477
  %1481 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %1482 = load i64, ptr %1481, align 8, !tbaa !27
  %1483 = icmp sgt i64 %1482, 0
  br i1 %1483, label %1484, label %1498

1484:                                             ; preds = %1480
  %1485 = getelementptr inbounds nuw i8, ptr %15, i64 24
  br label %1486

1486:                                             ; preds = %1494, %1484
  %1487 = phi i64 [ 0, %1484 ], [ %1495, %1494 ]
  %1488 = load ptr, ptr %1485, align 8, !tbaa !32
  %1489 = getelementptr inbounds nuw i64, ptr %1488, i64 %1487
  %1490 = load i64, ptr %1489, align 8, !tbaa !11
  %1491 = load i64, ptr %3, align 8, !tbaa !11
  %1492 = tail call i64 @rt_eq_i(i64 noundef %1490, i64 noundef %1491)
  %1493 = icmp eq i64 %1492, 0
  br i1 %1493, label %1494, label %1523

1494:                                             ; preds = %1486
  %1495 = add nuw nsw i64 %1487, 1
  %1496 = load i64, ptr %1481, align 8, !tbaa !27
  %1497 = icmp slt i64 %1495, %1496
  br i1 %1497, label %1486, label %1498, !llvm.loop !187

1498:                                             ; preds = %1494, %1480
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.25, ptr noundef nonnull @.str.241) #36
  unreachable

1499:                                             ; preds = %1477
  %1500 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(6) @.str.205) #35
  %1501 = icmp eq i32 %1500, 0
  br i1 %1501, label %1502, label %1522

1502:                                             ; preds = %1499
  %1503 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %1504 = load i64, ptr %1503, align 8, !tbaa !27
  %1505 = icmp sgt i64 %1504, 0
  br i1 %1505, label %1506, label %1523

1506:                                             ; preds = %1502
  %1507 = getelementptr inbounds nuw i8, ptr %15, i64 24
  br label %1508

1508:                                             ; preds = %1508, %1506
  %1509 = phi i64 [ 0, %1506 ], [ %1519, %1508 ]
  %1510 = phi i64 [ 0, %1506 ], [ %1518, %1508 ]
  %1511 = load ptr, ptr %1507, align 8, !tbaa !32
  %1512 = getelementptr inbounds nuw i64, ptr %1511, i64 %1509
  %1513 = load i64, ptr %1512, align 8, !tbaa !11
  %1514 = load i64, ptr %3, align 8, !tbaa !11
  %1515 = tail call i64 @rt_eq_i(i64 noundef %1513, i64 noundef %1514)
  %1516 = icmp ne i64 %1515, 0
  %1517 = zext i1 %1516 to i64
  %1518 = add nuw nsw i64 %1510, %1517
  %1519 = add nuw nsw i64 %1509, 1
  %1520 = load i64, ptr %1503, align 8, !tbaa !27
  %1521 = icmp slt i64 %1519, %1520
  br i1 %1521, label %1508, label %1523, !llvm.loop !188

1522:                                             ; preds = %1499
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.54, ptr noundef nonnull @.str.242, ptr noundef nonnull %9) #36
  unreachable

1523:                                             ; preds = %1508, %1486, %1502
  %1524 = phi i64 [ %1487, %1486 ], [ 0, %1502 ], [ %1518, %1508 ]
  %1525 = shl nuw nsw i64 %1524, 1
  %1526 = or disjoint i64 %1525, 1
  br label %2128

1527:                                             ; preds = %14
  %1528 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(4) @.str.243) #35
  %1529 = icmp eq i32 %1528, 0
  br i1 %1529, label %1530, label %1581

1530:                                             ; preds = %1527
  %1531 = load i64, ptr %3, align 8, !tbaa !11
  %1532 = tail call fastcc i64 @hash_v(i64 noundef %1531) #39
  %1533 = getelementptr inbounds nuw i8, ptr %15, i64 40
  %1534 = load i64, ptr %1533, align 8, !tbaa !40
  %1535 = icmp eq i64 %1534, 0
  br i1 %1535, label %1572, label %1536

1536:                                             ; preds = %1530
  %1537 = add nsw i64 %1534, -1
  %1538 = getelementptr inbounds nuw i8, ptr %15, i64 48
  %1539 = and i64 %1537, %1532
  %1540 = load ptr, ptr %1538, align 8, !tbaa !41
  %1541 = getelementptr inbounds i64, ptr %1540, i64 %1539
  %1542 = load i64, ptr %1541, align 8, !tbaa !11
  %1543 = icmp slt i64 %1542, 0
  br i1 %1543, label %1572, label %1544

1544:                                             ; preds = %1536
  %1545 = getelementptr inbounds nuw i8, ptr %15, i64 32
  br label %1546

1546:                                             ; preds = %1565, %1544
  %1547 = phi ptr [ %1540, %1544 ], [ %1566, %1565 ]
  %1548 = phi i64 [ %1542, %1544 ], [ %1570, %1565 ]
  %1549 = phi i64 [ %1539, %1544 ], [ %1568, %1565 ]
  %1550 = load ptr, ptr %1545, align 8, !tbaa !36
  %1551 = getelementptr inbounds nuw %struct.Ent, ptr %1550, i64 %1548
  %1552 = load i64, ptr %1551, align 8, !tbaa !37
  %1553 = icmp eq i64 %1552, 0
  br i1 %1553, label %1565, label %1554

1554:                                             ; preds = %1546
  %1555 = getelementptr inbounds nuw i8, ptr %1551, i64 16
  %1556 = load i64, ptr %1555, align 8, !tbaa !39
  %1557 = icmp eq i64 %1556, %1532
  br i1 %1557, label %1558, label %1565

1558:                                             ; preds = %1554
  %1559 = icmp eq i64 %1552, %1531
  br i1 %1559, label %1572, label %1560

1560:                                             ; preds = %1558
  %1561 = tail call i64 @rt_eq_i(i64 noundef %1552, i64 noundef %1531) #39
  %1562 = icmp eq i64 %1561, 0
  br i1 %1562, label %1563, label %1572

1563:                                             ; preds = %1560
  %1564 = load ptr, ptr %1538, align 8, !tbaa !41
  br label %1565

1565:                                             ; preds = %1563, %1554, %1546
  %1566 = phi ptr [ %1564, %1563 ], [ %1547, %1546 ], [ %1547, %1554 ]
  %1567 = add nuw nsw i64 %1549, 1
  %1568 = and i64 %1567, %1537
  %1569 = getelementptr inbounds i64, ptr %1566, i64 %1568
  %1570 = load i64, ptr %1569, align 8, !tbaa !11
  %1571 = icmp slt i64 %1570, 0
  br i1 %1571, label %1572, label %1546

1572:                                             ; preds = %1565, %1560, %1558, %1536, %1530
  %1573 = phi ptr [ null, %1530 ], [ null, %1536 ], [ null, %1565 ], [ %1551, %1560 ], [ %1551, %1558 ]
  %1574 = icmp eq ptr %1573, null
  %1575 = getelementptr inbounds nuw i8, ptr %1573, i64 8
  %1576 = icmp sgt i64 %2, 1
  %1577 = getelementptr inbounds nuw i8, ptr %3, i64 8
  %1578 = select i1 %1576, ptr %1577, ptr @rt_none_v
  %1579 = select i1 %1574, ptr %1578, ptr %1575
  %1580 = load i64, ptr %1579, align 8, !tbaa !11
  br label %2128

1581:                                             ; preds = %1527
  %1582 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(5) @.str.244) #35
  %1583 = icmp eq i32 %1582, 0
  br i1 %1583, label %1584, label %1626

1584:                                             ; preds = %1581
  %1585 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %1586 = load i64, ptr %1585, align 8, !tbaa !33
  %1587 = tail call fastcc i64 @mklist(i64 noundef %1586)
  %1588 = getelementptr inbounds nuw i8, ptr %15, i64 16
  %1589 = load i64, ptr %1588, align 8, !tbaa !35
  %1590 = icmp sgt i64 %1589, 0
  br i1 %1590, label %1591, label %2128

1591:                                             ; preds = %1584
  %1592 = getelementptr inbounds nuw i8, ptr %15, i64 32
  %1593 = inttoptr i64 %1587 to ptr
  %1594 = getelementptr inbounds nuw i8, ptr %1593, i64 8
  %1595 = getelementptr inbounds nuw i8, ptr %1593, i64 16
  %1596 = getelementptr inbounds nuw i8, ptr %1593, i64 24
  br label %1597

1597:                                             ; preds = %1622, %1591
  %1598 = phi i64 [ %1589, %1591 ], [ %1623, %1622 ]
  %1599 = phi i64 [ 0, %1591 ], [ %1624, %1622 ]
  %1600 = load ptr, ptr %1592, align 8, !tbaa !36
  %1601 = getelementptr inbounds nuw %struct.Ent, ptr %1600, i64 %1599
  %1602 = load i64, ptr %1601, align 8, !tbaa !37
  %1603 = icmp eq i64 %1602, 0
  br i1 %1603, label %1622, label %1604

1604:                                             ; preds = %1597
  %1605 = load i64, ptr %1594, align 8, !tbaa !27
  %1606 = load i64, ptr %1595, align 8, !tbaa !70
  %1607 = icmp slt i64 %1605, %1606
  br i1 %1607, label %1608, label %1610

1608:                                             ; preds = %1604
  %1609 = load ptr, ptr %1596, align 8, !tbaa !32
  br label %1616

1610:                                             ; preds = %1604
  %1611 = shl nsw i64 %1606, 1
  store i64 %1611, ptr %1595, align 8, !tbaa !70
  %1612 = load ptr, ptr %1596, align 8, !tbaa !32
  %1613 = shl i64 %1606, 4
  %1614 = tail call ptr @realloc(ptr noundef %1612, i64 noundef %1613) #38
  store ptr %1614, ptr %1596, align 8, !tbaa !32
  %1615 = load i64, ptr %1594, align 8, !tbaa !27
  br label %1616

1616:                                             ; preds = %1610, %1608
  %1617 = phi i64 [ %1605, %1608 ], [ %1615, %1610 ]
  %1618 = phi ptr [ %1609, %1608 ], [ %1614, %1610 ]
  %1619 = add nsw i64 %1617, 1
  store i64 %1619, ptr %1594, align 8, !tbaa !27
  %1620 = getelementptr inbounds i64, ptr %1618, i64 %1617
  store i64 %1602, ptr %1620, align 8, !tbaa !11
  %1621 = load i64, ptr %1588, align 8, !tbaa !35
  br label %1622

1622:                                             ; preds = %1616, %1597
  %1623 = phi i64 [ %1598, %1597 ], [ %1621, %1616 ]
  %1624 = add nuw nsw i64 %1599, 1
  %1625 = icmp slt i64 %1624, %1623
  br i1 %1625, label %1597, label %2128, !llvm.loop !108

1626:                                             ; preds = %1581
  %1627 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(7) @.str.245) #35
  %1628 = icmp eq i32 %1627, 0
  br i1 %1628, label %1629, label %1673

1629:                                             ; preds = %1626
  %1630 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %1631 = load i64, ptr %1630, align 8, !tbaa !33
  %1632 = tail call fastcc i64 @mklist(i64 noundef %1631)
  %1633 = getelementptr inbounds nuw i8, ptr %15, i64 16
  %1634 = load i64, ptr %1633, align 8, !tbaa !35
  %1635 = icmp sgt i64 %1634, 0
  br i1 %1635, label %1636, label %2128

1636:                                             ; preds = %1629
  %1637 = getelementptr inbounds nuw i8, ptr %15, i64 32
  %1638 = inttoptr i64 %1632 to ptr
  %1639 = getelementptr inbounds nuw i8, ptr %1638, i64 8
  %1640 = getelementptr inbounds nuw i8, ptr %1638, i64 16
  %1641 = getelementptr inbounds nuw i8, ptr %1638, i64 24
  br label %1642

1642:                                             ; preds = %1669, %1636
  %1643 = phi i64 [ %1634, %1636 ], [ %1670, %1669 ]
  %1644 = phi i64 [ 0, %1636 ], [ %1671, %1669 ]
  %1645 = load ptr, ptr %1637, align 8, !tbaa !36
  %1646 = getelementptr inbounds nuw %struct.Ent, ptr %1645, i64 %1644
  %1647 = load i64, ptr %1646, align 8, !tbaa !37
  %1648 = icmp eq i64 %1647, 0
  br i1 %1648, label %1669, label %1649

1649:                                             ; preds = %1642
  %1650 = getelementptr inbounds nuw i8, ptr %1646, i64 8
  %1651 = load i64, ptr %1650, align 8, !tbaa !42
  %1652 = load i64, ptr %1639, align 8, !tbaa !27
  %1653 = load i64, ptr %1640, align 8, !tbaa !70
  %1654 = icmp slt i64 %1652, %1653
  br i1 %1654, label %1655, label %1657

1655:                                             ; preds = %1649
  %1656 = load ptr, ptr %1641, align 8, !tbaa !32
  br label %1663

1657:                                             ; preds = %1649
  %1658 = shl nsw i64 %1653, 1
  store i64 %1658, ptr %1640, align 8, !tbaa !70
  %1659 = load ptr, ptr %1641, align 8, !tbaa !32
  %1660 = shl i64 %1653, 4
  %1661 = tail call ptr @realloc(ptr noundef %1659, i64 noundef %1660) #38
  store ptr %1661, ptr %1641, align 8, !tbaa !32
  %1662 = load i64, ptr %1639, align 8, !tbaa !27
  br label %1663

1663:                                             ; preds = %1657, %1655
  %1664 = phi i64 [ %1652, %1655 ], [ %1662, %1657 ]
  %1665 = phi ptr [ %1656, %1655 ], [ %1661, %1657 ]
  %1666 = add nsw i64 %1664, 1
  store i64 %1666, ptr %1639, align 8, !tbaa !27
  %1667 = getelementptr inbounds i64, ptr %1665, i64 %1664
  store i64 %1651, ptr %1667, align 8, !tbaa !11
  %1668 = load i64, ptr %1633, align 8, !tbaa !35
  br label %1669

1669:                                             ; preds = %1663, %1642
  %1670 = phi i64 [ %1643, %1642 ], [ %1668, %1663 ]
  %1671 = add nuw nsw i64 %1644, 1
  %1672 = icmp slt i64 %1671, %1670
  br i1 %1672, label %1642, label %2128, !llvm.loop !189

1673:                                             ; preds = %1626
  %1674 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(6) @.str.246) #35
  %1675 = icmp eq i32 %1674, 0
  br i1 %1675, label %1676, label %1725

1676:                                             ; preds = %1673
  %1677 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %1678 = load i64, ptr %1677, align 8, !tbaa !33
  %1679 = tail call fastcc i64 @mklist(i64 noundef %1678)
  %1680 = getelementptr inbounds nuw i8, ptr %15, i64 16
  %1681 = load i64, ptr %1680, align 8, !tbaa !35
  %1682 = icmp sgt i64 %1681, 0
  br i1 %1682, label %1683, label %2128

1683:                                             ; preds = %1676
  %1684 = getelementptr inbounds nuw i8, ptr %15, i64 32
  %1685 = inttoptr i64 %1679 to ptr
  %1686 = getelementptr inbounds nuw i8, ptr %1685, i64 8
  %1687 = getelementptr inbounds nuw i8, ptr %1685, i64 16
  %1688 = getelementptr inbounds nuw i8, ptr %1685, i64 24
  br label %1689

1689:                                             ; preds = %1721, %1683
  %1690 = phi i64 [ %1681, %1683 ], [ %1722, %1721 ]
  %1691 = phi i64 [ 0, %1683 ], [ %1723, %1721 ]
  %1692 = load ptr, ptr %1684, align 8, !tbaa !36
  %1693 = getelementptr inbounds nuw %struct.Ent, ptr %1692, i64 %1691
  %1694 = load i64, ptr %1693, align 8, !tbaa !37
  %1695 = icmp eq i64 %1694, 0
  br i1 %1695, label %1721, label %1696

1696:                                             ; preds = %1689
  %1697 = getelementptr inbounds nuw i8, ptr %1693, i64 8
  %1698 = load i64, ptr %1697, align 8, !tbaa !42
  %1699 = tail call fastcc i64 @mktuple(i64 noundef 2)
  %1700 = inttoptr i64 %1699 to ptr
  %1701 = getelementptr inbounds nuw i8, ptr %1700, i64 24
  %1702 = load ptr, ptr %1701, align 8, !tbaa !32
  store i64 %1694, ptr %1702, align 8, !tbaa !11
  %1703 = getelementptr inbounds nuw i8, ptr %1702, i64 8
  store i64 %1698, ptr %1703, align 8, !tbaa !11
  %1704 = load i64, ptr %1686, align 8, !tbaa !27
  %1705 = load i64, ptr %1687, align 8, !tbaa !70
  %1706 = icmp slt i64 %1704, %1705
  br i1 %1706, label %1707, label %1709

1707:                                             ; preds = %1696
  %1708 = load ptr, ptr %1688, align 8, !tbaa !32
  br label %1715

1709:                                             ; preds = %1696
  %1710 = shl nsw i64 %1705, 1
  store i64 %1710, ptr %1687, align 8, !tbaa !70
  %1711 = load ptr, ptr %1688, align 8, !tbaa !32
  %1712 = shl i64 %1705, 4
  %1713 = tail call ptr @realloc(ptr noundef %1711, i64 noundef %1712) #38
  store ptr %1713, ptr %1688, align 8, !tbaa !32
  %1714 = load i64, ptr %1686, align 8, !tbaa !27
  br label %1715

1715:                                             ; preds = %1709, %1707
  %1716 = phi i64 [ %1704, %1707 ], [ %1714, %1709 ]
  %1717 = phi ptr [ %1708, %1707 ], [ %1713, %1709 ]
  %1718 = add nsw i64 %1716, 1
  store i64 %1718, ptr %1686, align 8, !tbaa !27
  %1719 = getelementptr inbounds i64, ptr %1717, i64 %1716
  store i64 %1699, ptr %1719, align 8, !tbaa !11
  %1720 = load i64, ptr %1680, align 8, !tbaa !35
  br label %1721

1721:                                             ; preds = %1715, %1689
  %1722 = phi i64 [ %1690, %1689 ], [ %1720, %1715 ]
  %1723 = add nuw nsw i64 %1691, 1
  %1724 = icmp slt i64 %1723, %1722
  br i1 %1724, label %1689, label %2128, !llvm.loop !190

1725:                                             ; preds = %1673
  %1726 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(4) @.str.230) #35
  %1727 = icmp eq i32 %1726, 0
  br i1 %1727, label %1728, label %1824

1728:                                             ; preds = %1725
  %1729 = load i64, ptr %3, align 8, !tbaa !11
  %1730 = tail call fastcc i64 @hash_v(i64 noundef %1729) #39
  %1731 = getelementptr inbounds nuw i8, ptr %15, i64 40
  %1732 = load i64, ptr %1731, align 8, !tbaa !40
  %1733 = icmp eq i64 %1732, 0
  br i1 %1733, label %1770, label %1734

1734:                                             ; preds = %1728
  %1735 = add nsw i64 %1732, -1
  %1736 = getelementptr inbounds nuw i8, ptr %15, i64 48
  %1737 = and i64 %1735, %1730
  %1738 = load ptr, ptr %1736, align 8, !tbaa !41
  %1739 = getelementptr inbounds i64, ptr %1738, i64 %1737
  %1740 = load i64, ptr %1739, align 8, !tbaa !11
  %1741 = icmp slt i64 %1740, 0
  br i1 %1741, label %1770, label %1742

1742:                                             ; preds = %1734
  %1743 = getelementptr inbounds nuw i8, ptr %15, i64 32
  br label %1744

1744:                                             ; preds = %1763, %1742
  %1745 = phi ptr [ %1738, %1742 ], [ %1764, %1763 ]
  %1746 = phi i64 [ %1740, %1742 ], [ %1768, %1763 ]
  %1747 = phi i64 [ %1737, %1742 ], [ %1766, %1763 ]
  %1748 = load ptr, ptr %1743, align 8, !tbaa !36
  %1749 = getelementptr inbounds nuw %struct.Ent, ptr %1748, i64 %1746
  %1750 = load i64, ptr %1749, align 8, !tbaa !37
  %1751 = icmp eq i64 %1750, 0
  br i1 %1751, label %1763, label %1752

1752:                                             ; preds = %1744
  %1753 = getelementptr inbounds nuw i8, ptr %1749, i64 16
  %1754 = load i64, ptr %1753, align 8, !tbaa !39
  %1755 = icmp eq i64 %1754, %1730
  br i1 %1755, label %1756, label %1763

1756:                                             ; preds = %1752
  %1757 = icmp eq i64 %1750, %1729
  br i1 %1757, label %1780, label %1758

1758:                                             ; preds = %1756
  %1759 = tail call i64 @rt_eq_i(i64 noundef %1750, i64 noundef %1729) #39
  %1760 = icmp eq i64 %1759, 0
  br i1 %1760, label %1761, label %1780

1761:                                             ; preds = %1758
  %1762 = load ptr, ptr %1736, align 8, !tbaa !41
  br label %1763

1763:                                             ; preds = %1761, %1752, %1744
  %1764 = phi ptr [ %1762, %1761 ], [ %1745, %1744 ], [ %1745, %1752 ]
  %1765 = add nuw nsw i64 %1747, 1
  %1766 = and i64 %1765, %1735
  %1767 = getelementptr inbounds i64, ptr %1764, i64 %1766
  %1768 = load i64, ptr %1767, align 8, !tbaa !11
  %1769 = icmp slt i64 %1768, 0
  br i1 %1769, label %1770, label %1744

1770:                                             ; preds = %1763, %1734, %1728
  %1771 = icmp sgt i64 %2, 1
  br i1 %1771, label %1772, label %1775

1772:                                             ; preds = %1770
  %1773 = getelementptr inbounds nuw i8, ptr %3, i64 8
  %1774 = load i64, ptr %1773, align 8, !tbaa !11
  br label %2128

1775:                                             ; preds = %1770
  %1776 = load i64, ptr %3, align 8, !tbaa !11
  %1777 = tail call i64 @rt_repr(i64 noundef %1776)
  %1778 = inttoptr i64 %1777 to ptr
  %1779 = getelementptr inbounds nuw i8, ptr %1778, i64 16
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.41, ptr noundef nonnull @.str.42, ptr noundef nonnull %1779) #36
  unreachable

1780:                                             ; preds = %1758, %1756
  %1781 = getelementptr inbounds nuw i8, ptr %1749, i64 8
  %1782 = load i64, ptr %1781, align 8, !tbaa !42
  %1783 = load i64, ptr %3, align 8, !tbaa !11
  %1784 = tail call fastcc i64 @hash_v(i64 noundef %1783) #39
  %1785 = load i64, ptr %1731, align 8, !tbaa !40
  %1786 = icmp eq i64 %1785, 0
  br i1 %1786, label %2128, label %1787

1787:                                             ; preds = %1780
  %1788 = add nsw i64 %1785, -1
  %1789 = and i64 %1788, %1784
  %1790 = load ptr, ptr %1736, align 8, !tbaa !41
  %1791 = getelementptr inbounds i64, ptr %1790, i64 %1789
  %1792 = load i64, ptr %1791, align 8, !tbaa !11
  %1793 = icmp slt i64 %1792, 0
  br i1 %1793, label %2128, label %1794

1794:                                             ; preds = %1787, %1813
  %1795 = phi ptr [ %1814, %1813 ], [ %1790, %1787 ]
  %1796 = phi i64 [ %1818, %1813 ], [ %1792, %1787 ]
  %1797 = phi i64 [ %1816, %1813 ], [ %1789, %1787 ]
  %1798 = load ptr, ptr %1743, align 8, !tbaa !36
  %1799 = getelementptr inbounds nuw %struct.Ent, ptr %1798, i64 %1796
  %1800 = load i64, ptr %1799, align 8, !tbaa !37
  %1801 = icmp eq i64 %1800, 0
  br i1 %1801, label %1813, label %1802

1802:                                             ; preds = %1794
  %1803 = getelementptr inbounds nuw i8, ptr %1799, i64 16
  %1804 = load i64, ptr %1803, align 8, !tbaa !39
  %1805 = icmp eq i64 %1804, %1784
  br i1 %1805, label %1806, label %1813

1806:                                             ; preds = %1802
  %1807 = icmp eq i64 %1800, %1783
  br i1 %1807, label %1820, label %1808

1808:                                             ; preds = %1806
  %1809 = tail call i64 @rt_eq_i(i64 noundef %1800, i64 noundef %1783) #39
  %1810 = icmp eq i64 %1809, 0
  br i1 %1810, label %1811, label %1820

1811:                                             ; preds = %1808
  %1812 = load ptr, ptr %1736, align 8, !tbaa !41
  br label %1813

1813:                                             ; preds = %1811, %1802, %1794
  %1814 = phi ptr [ %1812, %1811 ], [ %1795, %1794 ], [ %1795, %1802 ]
  %1815 = add nuw nsw i64 %1797, 1
  %1816 = and i64 %1815, %1788
  %1817 = getelementptr inbounds i64, ptr %1814, i64 %1816
  %1818 = load i64, ptr %1817, align 8, !tbaa !11
  %1819 = icmp slt i64 %1818, 0
  br i1 %1819, label %2128, label %1794

1820:                                             ; preds = %1808, %1806
  %1821 = getelementptr inbounds nuw i8, ptr %15, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %1799, i8 0, i64 16, i1 false)
  %1822 = load i64, ptr %1821, align 8, !tbaa !33
  %1823 = add nsw i64 %1822, -1
  store i64 %1823, ptr %1821, align 8, !tbaa !33
  br label %2128

1824:                                             ; preds = %1725
  %1825 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(11) @.str.247) #35
  %1826 = icmp eq i32 %1825, 0
  br i1 %1826, label %1827, label %1878

1827:                                             ; preds = %1824
  %1828 = load i64, ptr %3, align 8, !tbaa !11
  %1829 = tail call fastcc i64 @hash_v(i64 noundef %1828) #39
  %1830 = getelementptr inbounds nuw i8, ptr %15, i64 40
  %1831 = load i64, ptr %1830, align 8, !tbaa !40
  %1832 = icmp eq i64 %1831, 0
  br i1 %1832, label %1872, label %1833

1833:                                             ; preds = %1827
  %1834 = add nsw i64 %1831, -1
  %1835 = getelementptr inbounds nuw i8, ptr %15, i64 48
  %1836 = and i64 %1834, %1829
  %1837 = load ptr, ptr %1835, align 8, !tbaa !41
  %1838 = getelementptr inbounds i64, ptr %1837, i64 %1836
  %1839 = load i64, ptr %1838, align 8, !tbaa !11
  %1840 = icmp slt i64 %1839, 0
  br i1 %1840, label %1872, label %1841

1841:                                             ; preds = %1833
  %1842 = getelementptr inbounds nuw i8, ptr %15, i64 32
  br label %1843

1843:                                             ; preds = %1862, %1841
  %1844 = phi ptr [ %1837, %1841 ], [ %1863, %1862 ]
  %1845 = phi i64 [ %1839, %1841 ], [ %1867, %1862 ]
  %1846 = phi i64 [ %1836, %1841 ], [ %1865, %1862 ]
  %1847 = load ptr, ptr %1842, align 8, !tbaa !36
  %1848 = getelementptr inbounds nuw %struct.Ent, ptr %1847, i64 %1845
  %1849 = load i64, ptr %1848, align 8, !tbaa !37
  %1850 = icmp eq i64 %1849, 0
  br i1 %1850, label %1862, label %1851

1851:                                             ; preds = %1843
  %1852 = getelementptr inbounds nuw i8, ptr %1848, i64 16
  %1853 = load i64, ptr %1852, align 8, !tbaa !39
  %1854 = icmp eq i64 %1853, %1829
  br i1 %1854, label %1855, label %1862

1855:                                             ; preds = %1851
  %1856 = icmp eq i64 %1849, %1828
  br i1 %1856, label %1869, label %1857

1857:                                             ; preds = %1855
  %1858 = tail call i64 @rt_eq_i(i64 noundef %1849, i64 noundef %1828) #39
  %1859 = icmp eq i64 %1858, 0
  br i1 %1859, label %1860, label %1869

1860:                                             ; preds = %1857
  %1861 = load ptr, ptr %1835, align 8, !tbaa !41
  br label %1862

1862:                                             ; preds = %1860, %1851, %1843
  %1863 = phi ptr [ %1861, %1860 ], [ %1844, %1843 ], [ %1844, %1851 ]
  %1864 = add nuw nsw i64 %1846, 1
  %1865 = and i64 %1864, %1834
  %1866 = getelementptr inbounds i64, ptr %1863, i64 %1865
  %1867 = load i64, ptr %1866, align 8, !tbaa !11
  %1868 = icmp slt i64 %1867, 0
  br i1 %1868, label %1872, label %1843

1869:                                             ; preds = %1857, %1855
  %1870 = getelementptr inbounds nuw i8, ptr %1848, i64 8
  %1871 = load i64, ptr %1870, align 8, !tbaa !42
  br label %2128

1872:                                             ; preds = %1862, %1833, %1827
  %1873 = icmp sgt i64 %2, 1
  %1874 = getelementptr inbounds nuw i8, ptr %3, i64 8
  %1875 = select i1 %1873, ptr %1874, ptr @rt_none_v
  %1876 = load i64, ptr %1875, align 8, !tbaa !11
  %1877 = load i64, ptr %3, align 8, !tbaa !11
  tail call fastcc void @dict_set(ptr noundef nonnull %15, i64 noundef %1877, i64 noundef %1876)
  br label %2128

1878:                                             ; preds = %1824
  %1879 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(7) @.str.248) #35
  %1880 = icmp eq i32 %1879, 0
  br i1 %1880, label %1881, label %1906

1881:                                             ; preds = %1878
  %1882 = load i64, ptr %3, align 8, !tbaa !11
  %1883 = inttoptr i64 %1882 to ptr
  %1884 = getelementptr inbounds nuw i8, ptr %1883, i64 16
  %1885 = load i64, ptr %1884, align 8, !tbaa !35
  %1886 = icmp sgt i64 %1885, 0
  br i1 %1886, label %1887, label %1889

1887:                                             ; preds = %1881
  %1888 = getelementptr inbounds nuw i8, ptr %1883, i64 32
  br label %1891

1889:                                             ; preds = %1902, %1881
  %1890 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  br label %2128

1891:                                             ; preds = %1902, %1887
  %1892 = phi i64 [ %1885, %1887 ], [ %1903, %1902 ]
  %1893 = phi i64 [ 0, %1887 ], [ %1904, %1902 ]
  %1894 = load ptr, ptr %1888, align 8, !tbaa !36
  %1895 = getelementptr inbounds nuw %struct.Ent, ptr %1894, i64 %1893
  %1896 = load i64, ptr %1895, align 8, !tbaa !37
  %1897 = icmp eq i64 %1896, 0
  br i1 %1897, label %1902, label %1898

1898:                                             ; preds = %1891
  %1899 = getelementptr inbounds nuw i8, ptr %1895, i64 8
  %1900 = load i64, ptr %1899, align 8, !tbaa !42
  tail call fastcc void @dict_set(ptr noundef %15, i64 noundef %1896, i64 noundef %1900)
  %1901 = load i64, ptr %1884, align 8, !tbaa !35
  br label %1902

1902:                                             ; preds = %1898, %1891
  %1903 = phi i64 [ %1892, %1891 ], [ %1901, %1898 ]
  %1904 = add nuw nsw i64 %1893, 1
  %1905 = icmp slt i64 %1904, %1903
  br i1 %1905, label %1891, label %1889, !llvm.loop !191

1906:                                             ; preds = %1878
  %1907 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(5) @.str.238) #35
  %1908 = icmp eq i32 %1907, 0
  br i1 %1908, label %1909, label %1932

1909:                                             ; preds = %1906
  %1910 = tail call fastcc i64 @dict_new(i64 noundef 7)
  %1911 = getelementptr inbounds nuw i8, ptr %15, i64 16
  %1912 = load i64, ptr %1911, align 8, !tbaa !35
  %1913 = icmp sgt i64 %1912, 0
  br i1 %1913, label %1914, label %2128

1914:                                             ; preds = %1909
  %1915 = getelementptr inbounds nuw i8, ptr %15, i64 32
  %1916 = inttoptr i64 %1910 to ptr
  br label %1917

1917:                                             ; preds = %1928, %1914
  %1918 = phi i64 [ %1912, %1914 ], [ %1929, %1928 ]
  %1919 = phi i64 [ 0, %1914 ], [ %1930, %1928 ]
  %1920 = load ptr, ptr %1915, align 8, !tbaa !36
  %1921 = getelementptr inbounds nuw %struct.Ent, ptr %1920, i64 %1919
  %1922 = load i64, ptr %1921, align 8, !tbaa !37
  %1923 = icmp eq i64 %1922, 0
  br i1 %1923, label %1928, label %1924

1924:                                             ; preds = %1917
  %1925 = getelementptr inbounds nuw i8, ptr %1921, i64 8
  %1926 = load i64, ptr %1925, align 8, !tbaa !42
  tail call fastcc void @dict_set(ptr noundef %1916, i64 noundef %1922, i64 noundef %1926)
  %1927 = load i64, ptr %1911, align 8, !tbaa !35
  br label %1928

1928:                                             ; preds = %1924, %1917
  %1929 = phi i64 [ %1918, %1917 ], [ %1927, %1924 ]
  %1930 = add nuw nsw i64 %1919, 1
  %1931 = icmp slt i64 %1930, %1929
  br i1 %1931, label %1917, label %2128, !llvm.loop !192

1932:                                             ; preds = %1906
  %1933 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(6) @.str.239) #35
  %1934 = icmp eq i32 %1933, 0
  br i1 %1934, label %1935, label %1938

1935:                                             ; preds = %1932
  %1936 = getelementptr inbounds nuw i8, ptr %15, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(48) %1936, i8 0, i64 48, i1 false)
  %1937 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  br label %2128

1938:                                             ; preds = %1932
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.54, ptr noundef nonnull @.str.249, ptr noundef nonnull %9) #36
  unreachable

1939:                                             ; preds = %14
  %1940 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(4) @.str.250) #35
  %1941 = icmp eq i32 %1940, 0
  br i1 %1941, label %1942, label %1946

1942:                                             ; preds = %1939
  %1943 = load i64, ptr %3, align 8, !tbaa !11
  %1944 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  tail call fastcc void @dict_set(ptr noundef nonnull %15, i64 noundef %1943, i64 noundef %1944)
  %1945 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  br label %2128

1946:                                             ; preds = %1939
  %1947 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(8) @.str.251) #35
  %1948 = icmp eq i32 %1947, 0
  br i1 %1948, label %1949, label %1997

1949:                                             ; preds = %1946
  %1950 = load i64, ptr %3, align 8, !tbaa !11
  %1951 = tail call fastcc i64 @hash_v(i64 noundef %1950) #39
  %1952 = getelementptr inbounds nuw i8, ptr %15, i64 40
  %1953 = load i64, ptr %1952, align 8, !tbaa !40
  %1954 = icmp eq i64 %1953, 0
  br i1 %1954, label %1995, label %1955

1955:                                             ; preds = %1949
  %1956 = add nsw i64 %1953, -1
  %1957 = getelementptr inbounds nuw i8, ptr %15, i64 48
  %1958 = and i64 %1956, %1951
  %1959 = load ptr, ptr %1957, align 8, !tbaa !41
  %1960 = getelementptr inbounds i64, ptr %1959, i64 %1958
  %1961 = load i64, ptr %1960, align 8, !tbaa !11
  %1962 = icmp slt i64 %1961, 0
  br i1 %1962, label %1995, label %1963

1963:                                             ; preds = %1955
  %1964 = getelementptr inbounds nuw i8, ptr %15, i64 32
  br label %1965

1965:                                             ; preds = %1984, %1963
  %1966 = phi ptr [ %1959, %1963 ], [ %1985, %1984 ]
  %1967 = phi i64 [ %1961, %1963 ], [ %1989, %1984 ]
  %1968 = phi i64 [ %1958, %1963 ], [ %1987, %1984 ]
  %1969 = load ptr, ptr %1964, align 8, !tbaa !36
  %1970 = getelementptr inbounds nuw %struct.Ent, ptr %1969, i64 %1967
  %1971 = load i64, ptr %1970, align 8, !tbaa !37
  %1972 = icmp eq i64 %1971, 0
  br i1 %1972, label %1984, label %1973

1973:                                             ; preds = %1965
  %1974 = getelementptr inbounds nuw i8, ptr %1970, i64 16
  %1975 = load i64, ptr %1974, align 8, !tbaa !39
  %1976 = icmp eq i64 %1975, %1951
  br i1 %1976, label %1977, label %1984

1977:                                             ; preds = %1973
  %1978 = icmp eq i64 %1971, %1950
  br i1 %1978, label %1991, label %1979

1979:                                             ; preds = %1977
  %1980 = tail call i64 @rt_eq_i(i64 noundef %1971, i64 noundef %1950) #39
  %1981 = icmp eq i64 %1980, 0
  br i1 %1981, label %1982, label %1991

1982:                                             ; preds = %1979
  %1983 = load ptr, ptr %1957, align 8, !tbaa !41
  br label %1984

1984:                                             ; preds = %1982, %1973, %1965
  %1985 = phi ptr [ %1983, %1982 ], [ %1966, %1965 ], [ %1966, %1973 ]
  %1986 = add nuw nsw i64 %1968, 1
  %1987 = and i64 %1986, %1956
  %1988 = getelementptr inbounds i64, ptr %1985, i64 %1987
  %1989 = load i64, ptr %1988, align 8, !tbaa !11
  %1990 = icmp slt i64 %1989, 0
  br i1 %1990, label %1995, label %1965

1991:                                             ; preds = %1979, %1977
  %1992 = getelementptr inbounds nuw i8, ptr %15, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %1970, i8 0, i64 16, i1 false)
  %1993 = load i64, ptr %1992, align 8, !tbaa !33
  %1994 = add nsw i64 %1993, -1
  store i64 %1994, ptr %1992, align 8, !tbaa !33
  br label %1995

1995:                                             ; preds = %1984, %1991, %1955, %1949
  %1996 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  br label %2128

1997:                                             ; preds = %1946
  %1998 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(7) @.str.233) #35
  %1999 = icmp eq i32 %1998, 0
  br i1 %1999, label %2000, label %2052

2000:                                             ; preds = %1997
  %2001 = load i64, ptr %3, align 8, !tbaa !11
  %2002 = tail call fastcc i64 @hash_v(i64 noundef %2001) #39
  %2003 = getelementptr inbounds nuw i8, ptr %15, i64 40
  %2004 = load i64, ptr %2003, align 8, !tbaa !40
  %2005 = icmp eq i64 %2004, 0
  br i1 %2005, label %2042, label %2006

2006:                                             ; preds = %2000
  %2007 = add nsw i64 %2004, -1
  %2008 = getelementptr inbounds nuw i8, ptr %15, i64 48
  %2009 = and i64 %2007, %2002
  %2010 = load ptr, ptr %2008, align 8, !tbaa !41
  %2011 = getelementptr inbounds i64, ptr %2010, i64 %2009
  %2012 = load i64, ptr %2011, align 8, !tbaa !11
  %2013 = icmp slt i64 %2012, 0
  br i1 %2013, label %2042, label %2014

2014:                                             ; preds = %2006
  %2015 = getelementptr inbounds nuw i8, ptr %15, i64 32
  br label %2016

2016:                                             ; preds = %2035, %2014
  %2017 = phi ptr [ %2010, %2014 ], [ %2036, %2035 ]
  %2018 = phi i64 [ %2012, %2014 ], [ %2040, %2035 ]
  %2019 = phi i64 [ %2009, %2014 ], [ %2038, %2035 ]
  %2020 = load ptr, ptr %2015, align 8, !tbaa !36
  %2021 = getelementptr inbounds nuw %struct.Ent, ptr %2020, i64 %2018
  %2022 = load i64, ptr %2021, align 8, !tbaa !37
  %2023 = icmp eq i64 %2022, 0
  br i1 %2023, label %2035, label %2024

2024:                                             ; preds = %2016
  %2025 = getelementptr inbounds nuw i8, ptr %2021, i64 16
  %2026 = load i64, ptr %2025, align 8, !tbaa !39
  %2027 = icmp eq i64 %2026, %2002
  br i1 %2027, label %2028, label %2035

2028:                                             ; preds = %2024
  %2029 = icmp eq i64 %2022, %2001
  br i1 %2029, label %2047, label %2030

2030:                                             ; preds = %2028
  %2031 = tail call i64 @rt_eq_i(i64 noundef %2022, i64 noundef %2001) #39
  %2032 = icmp eq i64 %2031, 0
  br i1 %2032, label %2033, label %2047

2033:                                             ; preds = %2030
  %2034 = load ptr, ptr %2008, align 8, !tbaa !41
  br label %2035

2035:                                             ; preds = %2033, %2024, %2016
  %2036 = phi ptr [ %2034, %2033 ], [ %2017, %2016 ], [ %2017, %2024 ]
  %2037 = add nuw nsw i64 %2019, 1
  %2038 = and i64 %2037, %2007
  %2039 = getelementptr inbounds i64, ptr %2036, i64 %2038
  %2040 = load i64, ptr %2039, align 8, !tbaa !11
  %2041 = icmp slt i64 %2040, 0
  br i1 %2041, label %2042, label %2016

2042:                                             ; preds = %2035, %2006, %2000
  %2043 = load i64, ptr %3, align 8, !tbaa !11
  %2044 = tail call i64 @rt_repr(i64 noundef %2043)
  %2045 = inttoptr i64 %2044 to ptr
  %2046 = getelementptr inbounds nuw i8, ptr %2045, i64 16
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.41, ptr noundef nonnull @.str.42, ptr noundef nonnull %2046) #36
  unreachable

2047:                                             ; preds = %2030, %2028
  %2048 = getelementptr inbounds nuw i8, ptr %15, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %2021, i8 0, i64 16, i1 false)
  %2049 = load i64, ptr %2048, align 8, !tbaa !33
  %2050 = add nsw i64 %2049, -1
  store i64 %2050, ptr %2048, align 8, !tbaa !33
  %2051 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  br label %2128

2052:                                             ; preds = %1997
  %2053 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(5) @.str.238) #35
  %2054 = icmp eq i32 %2053, 0
  br i1 %2054, label %2055, label %2082

2055:                                             ; preds = %2052
  %2056 = tail call dereferenceable_or_null(56) ptr @calloc(i64 noundef 1, i64 noundef 56) #33
  %2057 = icmp eq ptr %2056, null
  br i1 %2057, label %2058, label %2061

2058:                                             ; preds = %2055
  %2059 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %2060 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %2059)
  tail call void @exit(i32 noundef 1) #34
  unreachable

2061:                                             ; preds = %2055
  store i64 8, ptr %2056, align 8, !tbaa !68
  %2062 = ptrtoint ptr %2056 to i64
  %2063 = getelementptr inbounds nuw i8, ptr %15, i64 16
  %2064 = load i64, ptr %2063, align 8, !tbaa !35
  %2065 = icmp sgt i64 %2064, 0
  br i1 %2065, label %2066, label %2128

2066:                                             ; preds = %2061
  %2067 = getelementptr inbounds nuw i8, ptr %15, i64 32
  br label %2068

2068:                                             ; preds = %2078, %2066
  %2069 = phi i64 [ %2064, %2066 ], [ %2079, %2078 ]
  %2070 = phi i64 [ 0, %2066 ], [ %2080, %2078 ]
  %2071 = load ptr, ptr %2067, align 8, !tbaa !36
  %2072 = getelementptr inbounds nuw %struct.Ent, ptr %2071, i64 %2070
  %2073 = load i64, ptr %2072, align 8, !tbaa !37
  %2074 = icmp eq i64 %2073, 0
  br i1 %2074, label %2078, label %2075

2075:                                             ; preds = %2068
  %2076 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  tail call fastcc void @dict_set(ptr noundef nonnull %2056, i64 noundef %2073, i64 noundef %2076)
  %2077 = load i64, ptr %2063, align 8, !tbaa !35
  br label %2078

2078:                                             ; preds = %2075, %2068
  %2079 = phi i64 [ %2069, %2068 ], [ %2077, %2075 ]
  %2080 = add nuw nsw i64 %2070, 1
  %2081 = icmp slt i64 %2080, %2079
  br i1 %2081, label %2068, label %2128, !llvm.loop !193

2082:                                             ; preds = %2052
  %2083 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(7) @.str.248) #35
  %2084 = icmp eq i32 %2083, 0
  br i1 %2084, label %2085, label %2105

2085:                                             ; preds = %2082
  %2086 = load i64, ptr %3, align 8, !tbaa !11
  %2087 = tail call fastcc i64 @as_list(i64 noundef %2086)
  %2088 = inttoptr i64 %2087 to ptr
  %2089 = getelementptr inbounds nuw i8, ptr %2088, i64 8
  %2090 = load i64, ptr %2089, align 8, !tbaa !27
  %2091 = icmp sgt i64 %2090, 0
  br i1 %2091, label %2092, label %2094

2092:                                             ; preds = %2085
  %2093 = getelementptr inbounds nuw i8, ptr %2088, i64 24
  br label %2096

2094:                                             ; preds = %2096, %2085
  %2095 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  br label %2128

2096:                                             ; preds = %2096, %2092
  %2097 = phi i64 [ 0, %2092 ], [ %2102, %2096 ]
  %2098 = load ptr, ptr %2093, align 8, !tbaa !32
  %2099 = getelementptr inbounds nuw i64, ptr %2098, i64 %2097
  %2100 = load i64, ptr %2099, align 8, !tbaa !11
  %2101 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  tail call fastcc void @dict_set(ptr noundef nonnull %15, i64 noundef %2100, i64 noundef %2101)
  %2102 = add nuw nsw i64 %2097, 1
  %2103 = load i64, ptr %2089, align 8, !tbaa !27
  %2104 = icmp slt i64 %2102, %2103
  br i1 %2104, label %2096, label %2094, !llvm.loop !194

2105:                                             ; preds = %2082
  %2106 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(6) @.str.252) #35
  %2107 = icmp eq i32 %2106, 0
  br i1 %2107, label %2108, label %2111

2108:                                             ; preds = %2105
  %2109 = load i64, ptr %3, align 8, !tbaa !11
  %2110 = tail call i64 @rt_or(i64 noundef %0, i64 noundef %2109)
  br label %2128

2111:                                             ; preds = %2105
  %2112 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(13) @.str.253) #35
  %2113 = icmp eq i32 %2112, 0
  br i1 %2113, label %2114, label %2117

2114:                                             ; preds = %2111
  %2115 = load i64, ptr %3, align 8, !tbaa !11
  %2116 = tail call i64 @rt_and(i64 noundef %0, i64 noundef %2115)
  br label %2128

2117:                                             ; preds = %2111
  %2118 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(11) @.str.254) #35
  %2119 = icmp eq i32 %2118, 0
  br i1 %2119, label %2120, label %2123

2120:                                             ; preds = %2117
  %2121 = load i64, ptr %3, align 8, !tbaa !11
  %2122 = tail call i64 @rt_sub(i64 noundef %0, i64 noundef %2121)
  br label %2128

2123:                                             ; preds = %2117
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.54, ptr noundef nonnull @.str.255, ptr noundef nonnull %9) #36
  unreachable

2124:                                             ; preds = %14
  %2125 = tail call fastcc i64 @meth_file(i64 noundef %0, ptr noundef nonnull %9, ptr noundef %3)
  br label %2128

2126:                                             ; preds = %4, %115, %14
  %2127 = tail call fastcc ptr @tname(i64 noundef %0)
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.54, ptr noundef nonnull @.str.55, ptr noundef nonnull %2127, ptr noundef nonnull %9) #36
  unreachable

2128:                                             ; preds = %2078, %1928, %1813, %1721, %1669, %1622, %1136, %615, %271, %2120, %2114, %2108, %2094, %2061, %2047, %1995, %1942, %1935, %1909, %1889, %1872, %1869, %1820, %1787, %1780, %1772, %1676, %1629, %1584, %1572, %1473, %1468, %1463, %1448, %1420, %1414, %1403, %1370, %1336, %1282, %1219, %1178, %1156, %1153, %1147, %1144, %1116, %1100, %1074, %1028, %1026, %893, %850, %811, %791, %676, %653, %634, %612, %595, %587, %574, %572, %507, %422, %314, %144, %63, %116, %111, %2124, %1523, %121, %118
  %2129 = phi i64 [ %2125, %2124 ], [ %120, %118 ], [ %123, %121 ], [ %117, %116 ], [ %210, %271 ], [ %1526, %1523 ], [ %1422, %1420 ], [ %1679, %1721 ], [ %64, %63 ], [ %114, %111 ], [ %147, %144 ], [ %1154, %1153 ], [ %513, %507 ], [ %1910, %1928 ], [ %591, %587 ], [ %1117, %1116 ], [ %636, %634 ], [ %1782, %1813 ], [ %795, %791 ], [ %813, %811 ], [ %852, %850 ], [ %894, %893 ], [ %679, %676 ], [ %1078, %1074 ], [ %1108, %1100 ], [ %0, %1144 ], [ -1, %595 ], [ %210, %422 ], [ %210, %314 ], [ %657, %653 ], [ %1029, %1028 ], [ %1027, %1026 ], [ %0, %1147 ], [ %614, %612 ], [ %573, %572 ], [ %1157, %1156 ], [ %575, %574 ], [ %1183, %1178 ], [ %1220, %1219 ], [ %1287, %1282 ], [ %1352, %1336 ], [ %1380, %1370 ], [ %1405, %1403 ], [ %1475, %1473 ], [ %1449, %1448 ], [ %1464, %1463 ], [ %1469, %1468 ], [ 1, %1414 ], [ %1580, %1572 ], [ %1679, %1676 ], [ %1937, %1935 ], [ %1632, %1669 ], [ %1910, %1909 ], [ %1774, %1772 ], [ %1890, %1889 ], [ %1876, %1872 ], [ %1782, %1820 ], [ %1871, %1869 ], [ %1587, %1584 ], [ %1782, %1780 ], [ %1782, %1787 ], [ %1632, %1629 ], [ %1117, %1136 ], [ %1587, %1622 ], [ -1, %615 ], [ %1945, %1942 ], [ %1996, %1995 ], [ %2051, %2047 ], [ %2122, %2120 ], [ %2095, %2094 ], [ %2110, %2108 ], [ %2116, %2114 ], [ %2062, %2061 ], [ %2062, %2078 ]
  ret i64 %2129
}

; Function Attrs: nounwind ssp uwtable(sync)
define internal fastcc i64 @meth_file(i64 noundef %0, ptr noundef %1, ptr noundef readonly captures(none) %2) unnamed_addr #2 {
  %4 = alloca [4096 x i8], align 1
  %5 = inttoptr i64 %0 to ptr
  %6 = getelementptr inbounds nuw i8, ptr %5, i64 8
  %7 = load ptr, ptr %6, align 8, !tbaa !135
  %8 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %1, ptr noundef nonnull dereferenceable(5) @.str.256) #35
  %9 = icmp eq i32 %8, 0
  br i1 %9, label %10, label %43

10:                                               ; preds = %3
  %11 = tail call dereferenceable_or_null(64) ptr @calloc(i64 noundef 1, i64 noundef 64) #33
  %12 = icmp eq ptr %11, null
  br i1 %12, label %13, label %16

13:                                               ; preds = %10
  %14 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %15 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %14)
  tail call void @exit(i32 noundef 1) #34
  unreachable

16:                                               ; preds = %10
  call void @llvm.lifetime.start.p0(ptr nonnull %4) #35
  %17 = call i64 @fread(ptr noundef nonnull %4, i64 noundef 1, i64 noundef 4096, ptr noundef %7)
  %18 = icmp eq i64 %17, 0
  br i1 %18, label %39, label %19

19:                                               ; preds = %16, %32
  %20 = phi i64 [ %37, %32 ], [ %17, %16 ]
  %21 = phi ptr [ %34, %32 ], [ %11, %16 ]
  %22 = phi i64 [ %24, %32 ], [ 0, %16 ]
  %23 = phi i64 [ %33, %32 ], [ 64, %16 ]
  %24 = add nsw i64 %22, %20
  %25 = icmp slt i64 %24, %23
  br i1 %25, label %32, label %26

26:                                               ; preds = %19, %26
  %27 = phi i64 [ %28, %26 ], [ %23, %19 ]
  %28 = shl nsw i64 %27, 1
  %29 = icmp sgt i64 %28, %24
  br i1 %29, label %30, label %26, !llvm.loop !83

30:                                               ; preds = %26
  %31 = tail call ptr @realloc(ptr noundef nonnull %21, i64 noundef %28) #38
  br label %32

32:                                               ; preds = %30, %19
  %33 = phi i64 [ %28, %30 ], [ %23, %19 ]
  %34 = phi ptr [ %31, %30 ], [ %21, %19 ]
  %35 = getelementptr inbounds i8, ptr %34, i64 %22
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(1) %35, ptr noundef nonnull readonly align 1 dereferenceable(1) %4, i64 noundef %20, i1 noundef false) #35
  %36 = getelementptr inbounds i8, ptr %34, i64 %24
  store i8 0, ptr %36, align 1, !tbaa !10
  %37 = call i64 @fread(ptr noundef nonnull %4, i64 noundef 1, i64 noundef 4096, ptr noundef %7)
  %38 = icmp eq i64 %37, 0
  br i1 %38, label %39, label %19, !llvm.loop !195

39:                                               ; preds = %32, %16
  %40 = phi i64 [ 0, %16 ], [ %24, %32 ]
  %41 = phi ptr [ %11, %16 ], [ %34, %32 ]
  %42 = tail call fastcc i64 @mkstr(ptr noundef nonnull %41, i64 noundef %40)
  call void @llvm.lifetime.end.p0(ptr nonnull %4) #35
  br label %143

43:                                               ; preds = %3
  %44 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %1, ptr noundef nonnull dereferenceable(9) @.str.257) #35
  %45 = icmp eq i32 %44, 0
  br i1 %45, label %46, label %48

46:                                               ; preds = %43
  %47 = tail call fastcc i64 @file_readline(ptr noundef %7)
  br label %143

48:                                               ; preds = %43
  %49 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %1, ptr noundef nonnull dereferenceable(10) @.str.258) #35
  %50 = icmp eq i32 %49, 0
  br i1 %50, label %51, label %86

51:                                               ; preds = %48
  %52 = tail call fastcc i64 @mklist(i64 noundef 8)
  %53 = tail call fastcc i64 @file_readline(ptr noundef %7)
  %54 = inttoptr i64 %53 to ptr
  %55 = getelementptr inbounds nuw i8, ptr %54, i64 8
  %56 = load i64, ptr %55, align 8, !tbaa !18
  %57 = icmp eq i64 %56, 0
  br i1 %57, label %143, label %58

58:                                               ; preds = %51
  %59 = inttoptr i64 %52 to ptr
  %60 = getelementptr inbounds nuw i8, ptr %59, i64 8
  %61 = getelementptr inbounds nuw i8, ptr %59, i64 16
  %62 = getelementptr inbounds nuw i8, ptr %59, i64 24
  br label %63

63:                                               ; preds = %58, %76
  %64 = phi i64 [ %53, %58 ], [ %81, %76 ]
  %65 = load i64, ptr %60, align 8, !tbaa !27
  %66 = load i64, ptr %61, align 8, !tbaa !70
  %67 = icmp slt i64 %65, %66
  br i1 %67, label %68, label %70

68:                                               ; preds = %63
  %69 = load ptr, ptr %62, align 8, !tbaa !32
  br label %76

70:                                               ; preds = %63
  %71 = shl nsw i64 %66, 1
  store i64 %71, ptr %61, align 8, !tbaa !70
  %72 = load ptr, ptr %62, align 8, !tbaa !32
  %73 = shl i64 %66, 4
  %74 = tail call ptr @realloc(ptr noundef %72, i64 noundef %73) #38
  store ptr %74, ptr %62, align 8, !tbaa !32
  %75 = load i64, ptr %60, align 8, !tbaa !27
  br label %76

76:                                               ; preds = %70, %68
  %77 = phi i64 [ %65, %68 ], [ %75, %70 ]
  %78 = phi ptr [ %69, %68 ], [ %74, %70 ]
  %79 = add nsw i64 %77, 1
  store i64 %79, ptr %60, align 8, !tbaa !27
  %80 = getelementptr inbounds i64, ptr %78, i64 %77
  store i64 %64, ptr %80, align 8, !tbaa !11
  %81 = tail call fastcc i64 @file_readline(ptr noundef %7)
  %82 = inttoptr i64 %81 to ptr
  %83 = getelementptr inbounds nuw i8, ptr %82, i64 8
  %84 = load i64, ptr %83, align 8, !tbaa !18
  %85 = icmp eq i64 %84, 0
  br i1 %85, label %143, label %63

86:                                               ; preds = %48
  %87 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %1, ptr noundef nonnull dereferenceable(6) @.str.259) #35
  %88 = icmp eq i32 %87, 0
  br i1 %88, label %89, label %120

89:                                               ; preds = %86
  %90 = load i64, ptr %2, align 8, !tbaa !11
  %91 = and i64 %90, 1
  %92 = icmp ne i64 %91, 0
  %93 = icmp eq i64 %90, 0
  %94 = or i1 %93, %92
  br i1 %94, label %99, label %95

95:                                               ; preds = %89
  %96 = inttoptr i64 %90 to ptr
  %97 = load i64, ptr %96, align 8, !tbaa !23
  %98 = icmp eq i64 %97, 4
  br i1 %98, label %100, label %99

99:                                               ; preds = %89, %95
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.260) #36
  unreachable

100:                                              ; preds = %95
  %101 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %102 = icmp eq ptr %7, %101
  br i1 %102, label %103, label %108

103:                                              ; preds = %100
  %104 = load ptr, ptr @__stdoutp, align 8, !tbaa !13
  %105 = tail call i32 @fflush(ptr noundef %104)
  %106 = load i64, ptr %2, align 8, !tbaa !11
  %107 = inttoptr i64 %106 to ptr
  br label %108

108:                                              ; preds = %103, %100
  %109 = phi ptr [ %107, %103 ], [ %96, %100 ]
  %110 = getelementptr inbounds nuw i8, ptr %109, i64 16
  %111 = getelementptr inbounds nuw i8, ptr %109, i64 8
  %112 = load i64, ptr %111, align 8, !tbaa !18
  %113 = tail call i64 @"\01_fwrite"(ptr noundef nonnull %110, i64 noundef 1, i64 noundef %112, ptr noundef %7) #35
  %114 = load i64, ptr %2, align 8, !tbaa !11
  %115 = inttoptr i64 %114 to ptr
  %116 = getelementptr inbounds nuw i8, ptr %115, i64 8
  %117 = load i64, ptr %116, align 8, !tbaa !18
  %118 = shl nsw i64 %117, 1
  %119 = or disjoint i64 %118, 1
  br label %143

120:                                              ; preds = %86
  %121 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %1, ptr noundef nonnull dereferenceable(6) @.str.261) #35
  %122 = icmp eq i32 %121, 0
  br i1 %122, label %123, label %126

123:                                              ; preds = %120
  %124 = tail call i32 @fflush(ptr noundef %7)
  %125 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  br label %143

126:                                              ; preds = %120
  %127 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %1, ptr noundef nonnull dereferenceable(6) @.str.87) #35
  %128 = icmp eq i32 %127, 0
  br i1 %128, label %129, label %142

129:                                              ; preds = %126
  %130 = load ptr, ptr @__stdoutp, align 8, !tbaa !13
  %131 = icmp eq ptr %7, %130
  %132 = load ptr, ptr @__stderrp, align 8
  %133 = icmp eq ptr %7, %132
  %134 = select i1 %131, i1 true, i1 %133
  %135 = load ptr, ptr @__stdinp, align 8
  %136 = icmp eq ptr %7, %135
  %137 = select i1 %134, i1 true, i1 %136
  br i1 %137, label %140, label %138

138:                                              ; preds = %129
  %139 = tail call i32 @fclose(ptr noundef %7)
  br label %140

140:                                              ; preds = %138, %129
  %141 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  br label %143

142:                                              ; preds = %126
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.54, ptr noundef nonnull @.str.262, ptr noundef nonnull %1) #36
  unreachable

143:                                              ; preds = %76, %51, %140, %123, %108, %46, %39
  %144 = phi i64 [ %42, %39 ], [ %47, %46 ], [ %141, %140 ], [ %119, %108 ], [ %125, %123 ], [ %52, %51 ], [ %52, %76 ]
  ret i64 %144
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_with_exit(i64 noundef %0) local_unnamed_addr #2 {
  %2 = and i64 %0, 1
  %3 = icmp ne i64 %2, 0
  %4 = icmp eq i64 %0, 0
  %5 = or i1 %4, %3
  br i1 %5, label %12, label %6

6:                                                ; preds = %1
  %7 = inttoptr i64 %0 to ptr
  %8 = load i64, ptr %7, align 8, !tbaa !23
  %9 = icmp eq i64 %8, 14
  br i1 %9, label %10, label %12

10:                                               ; preds = %6
  %11 = tail call fastcc i64 @meth_file(i64 noundef %0, ptr noundef nonnull @.str.87, ptr noundef null)
  br label %12

12:                                               ; preds = %1, %10, %6
  %13 = load i64, ptr @rt_none_v, align 8, !tbaa !11
  ret i64 %13
}

; Function Attrs: nounwind ssp uwtable(sync)
define i64 @rt_getbuiltin(ptr noundef %0) local_unnamed_addr #2 {
  br label %12

2:                                                ; preds = %12
  %3 = add nuw nsw i64 %13, 1
  %4 = getelementptr inbounds nuw %struct.BEnt, ptr @btab, i64 %3
  %5 = load ptr, ptr %4, align 8, !tbaa !196
  %6 = icmp eq i64 %3, 41
  br i1 %6, label %7, label %12, !llvm.loop !198

7:                                                ; preds = %2
  %8 = load i32, ptr @nexc, align 4, !tbaa !6
  %9 = icmp sgt i32 %8, 0
  br i1 %9, label %10, label %42

10:                                               ; preds = %7
  %11 = zext nneg i32 %8 to i64
  br label %33

12:                                               ; preds = %1, %2
  %13 = phi i64 [ 0, %1 ], [ %3, %2 ]
  %14 = phi ptr [ @.str.263, %1 ], [ %5, %2 ]
  %15 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %14, ptr noundef nonnull dereferenceable(1) %0) #35
  %16 = icmp eq i32 %15, 0
  br i1 %16, label %17, label %2

17:                                               ; preds = %12
  %18 = getelementptr inbounds nuw %struct.BEnt, ptr @btab, i64 %13
  %19 = getelementptr inbounds nuw i8, ptr %18, i64 8
  %20 = load ptr, ptr %19, align 8, !tbaa !199
  %21 = tail call dereferenceable_or_null(24) ptr @calloc(i64 noundef 1, i64 noundef 24) #33
  %22 = icmp eq ptr %21, null
  br i1 %22, label %23, label %26

23:                                               ; preds = %17
  %24 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %25 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %24)
  tail call void @exit(i32 noundef 1) #34
  unreachable

26:                                               ; preds = %17
  store i64 10, ptr %21, align 8, !tbaa !115
  %27 = getelementptr inbounds nuw i8, ptr %21, i64 8
  store ptr %20, ptr %27, align 8, !tbaa !57
  %28 = getelementptr inbounds nuw i8, ptr %21, i64 16
  store ptr %14, ptr %28, align 8, !tbaa !87
  %29 = ptrtoint ptr %21 to i64
  br label %43

30:                                               ; preds = %33
  %31 = add nuw nsw i64 %34, 1
  %32 = icmp eq i64 %31, %11
  br i1 %32, label %42, label %33, !llvm.loop !200

33:                                               ; preds = %10, %30
  %34 = phi i64 [ 0, %10 ], [ %31, %30 ]
  %35 = getelementptr inbounds nuw ptr, ptr @exc_nm, i64 %34
  %36 = load ptr, ptr %35, align 8, !tbaa !67
  %37 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %36, ptr noundef nonnull dereferenceable(1) %0) #35
  %38 = icmp eq i32 %37, 0
  br i1 %38, label %39, label %30

39:                                               ; preds = %33
  %40 = getelementptr inbounds nuw i64, ptr @exc_cls, i64 %34
  %41 = load i64, ptr %40, align 8, !tbaa !11
  br label %43

42:                                               ; preds = %30, %7
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.88, ptr noundef nonnull @.str.89, ptr noundef nonnull %0) #36
  unreachable

43:                                               ; preds = %39, %26
  %44 = phi i64 [ %41, %39 ], [ %29, %26 ]
  ret i64 %44
}

; Function Attrs: nofree nounwind ssp uwtable(sync)
define internal fastcc noundef i64 @mkbuiltin(ptr noundef %0, ptr noundef %1) unnamed_addr #0 {
  %3 = tail call dereferenceable_or_null(24) ptr @calloc(i64 noundef 1, i64 noundef 24) #33
  %4 = icmp eq ptr %3, null
  br i1 %4, label %5, label %8

5:                                                ; preds = %2
  %6 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %7 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %6)
  tail call void @exit(i32 noundef 1) #34
  unreachable

8:                                                ; preds = %2
  store i64 10, ptr %3, align 8, !tbaa !115
  %9 = getelementptr inbounds nuw i8, ptr %3, i64 8
  store ptr %0, ptr %9, align 8, !tbaa !57
  %10 = getelementptr inbounds nuw i8, ptr %3, i64 16
  store ptr %1, ptr %10, align 8, !tbaa !87
  %11 = ptrtoint ptr %3 to i64
  ret i64 %11
}

; Function Attrs: nounwind ssp uwtable(sync)
define void @rt_init(i32 noundef %0, ptr noundef readonly captures(none) %1) local_unnamed_addr #2 {
  store i64 ptrtoint (ptr @none_o to i64), ptr @rt_none_v, align 8, !tbaa !11
  store i64 ptrtoint (ptr @true_o to i64), ptr @rt_true_v, align 8, !tbaa !11
  store i64 ptrtoint (ptr @false_o to i64), ptr @rt_false_v, align 8, !tbaa !11
  %3 = tail call fastcc i64 @mkstr(ptr noundef nonnull @.str.90, i64 noundef 4)
  store i64 %3, ptr @K_args, align 8, !tbaa !11
  %4 = tail call fastcc i64 @mkstr(ptr noundef nonnull @.str.91, i64 noundef 8)
  store i64 %4, ptr @K_init, align 8, !tbaa !11
  %5 = tail call fastcc i64 @mkstr(ptr noundef nonnull @.str.92, i64 noundef 7)
  store i64 %5, ptr @K_str, align 8, !tbaa !11
  %6 = tail call fastcc i64 @mkstr(ptr noundef nonnull @.str.93, i64 noundef 8)
  store i64 %6, ptr @K_repr, align 8, !tbaa !11
  %7 = tail call fastcc i64 @mkstr(ptr noundef nonnull @.str.94, i64 noundef 7)
  store i64 %7, ptr @K_len, align 8, !tbaa !11
  %8 = tail call fastcc i64 @mkstr(ptr noundef nonnull @.str.95, i64 noundef 11)
  store i64 %8, ptr @K_getitem, align 8, !tbaa !11
  %9 = tail call fastcc i64 @mkstr(ptr noundef nonnull @.str.96, i64 noundef 11)
  store i64 %9, ptr @K_setitem, align 8, !tbaa !11
  %10 = tail call fastcc i64 @mkstr(ptr noundef nonnull @.str.53, i64 noundef 8)
  tail call fastcc void @def_exc(ptr noundef nonnull @.str.97, ptr noundef null)
  tail call fastcc void @def_exc(ptr noundef nonnull @.str.25, ptr noundef nonnull @.str.97)
  tail call fastcc void @def_exc(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.97)
  tail call fastcc void @def_exc(ptr noundef nonnull @.str.88, ptr noundef nonnull @.str.97)
  tail call fastcc void @def_exc(ptr noundef nonnull @.str.54, ptr noundef nonnull @.str.97)
  tail call fastcc void @def_exc(ptr noundef nonnull @.str.98, ptr noundef nonnull @.str.97)
  tail call fastcc void @def_exc(ptr noundef nonnull @.str.6, ptr noundef nonnull @.str.97)
  tail call fastcc void @def_exc(ptr noundef nonnull @.str.99, ptr noundef nonnull @.str.97)
  tail call fastcc void @def_exc(ptr noundef nonnull @.str.100, ptr noundef nonnull @.str.97)
  tail call fastcc void @def_exc(ptr noundef nonnull @.str.101, ptr noundef nonnull @.str.97)
  tail call fastcc void @def_exc(ptr noundef nonnull @.str.102, ptr noundef nonnull @.str.97)
  tail call fastcc void @def_exc(ptr noundef nonnull @.str.50, ptr noundef nonnull @.str.97)
  tail call fastcc void @def_exc(ptr noundef nonnull @.str.70, ptr noundef nonnull @.str.97)
  tail call fastcc void @def_exc(ptr noundef nonnull @.str.103, ptr noundef nonnull @.str.102)
  tail call fastcc void @def_exc(ptr noundef nonnull @.str.41, ptr noundef nonnull @.str.102)
  tail call fastcc void @def_exc(ptr noundef nonnull @.str.13, ptr noundef nonnull @.str.101)
  tail call fastcc void @def_exc(ptr noundef nonnull @.str.7, ptr noundef nonnull @.str.101)
  tail call fastcc void @def_exc(ptr noundef nonnull @.str.104, ptr noundef nonnull @.str.98)
  tail call fastcc void @def_exc(ptr noundef nonnull @.str.68, ptr noundef nonnull @.str.100)
  tail call fastcc void @def_exc(ptr noundef nonnull @.str.105, ptr noundef nonnull @.str.100)
  %11 = load ptr, ptr @__stdoutp, align 8, !tbaa !13
  %12 = tail call i32 @setvbuf(ptr noundef %11, ptr noundef null, i32 noundef 0, i64 noundef 65536)
  %13 = load ptr, ptr @__stdoutp, align 8, !tbaa !13
  %14 = tail call dereferenceable_or_null(16) ptr @calloc(i64 noundef 1, i64 noundef 16) #33
  %15 = icmp eq ptr %14, null
  br i1 %15, label %16, label %19

16:                                               ; preds = %2
  %17 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %18 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %17)
  tail call void @exit(i32 noundef 1) #34
  unreachable

19:                                               ; preds = %2
  store i64 14, ptr %14, align 8, !tbaa !133
  %20 = getelementptr inbounds nuw i8, ptr %14, i64 8
  store ptr %13, ptr %20, align 8, !tbaa !135
  %21 = ptrtoint ptr %14 to i64
  store i64 %21, ptr @sys_stdout, align 8, !tbaa !11
  %22 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %23 = tail call dereferenceable_or_null(16) ptr @calloc(i64 noundef 1, i64 noundef 16) #33
  %24 = icmp eq ptr %23, null
  br i1 %24, label %25, label %27

25:                                               ; preds = %19
  %26 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %22)
  tail call void @exit(i32 noundef 1) #34
  unreachable

27:                                               ; preds = %19
  store i64 14, ptr %23, align 8, !tbaa !133
  %28 = getelementptr inbounds nuw i8, ptr %23, i64 8
  store ptr %22, ptr %28, align 8, !tbaa !135
  %29 = ptrtoint ptr %23 to i64
  store i64 %29, ptr @sys_stderr, align 8, !tbaa !11
  %30 = load ptr, ptr @__stdinp, align 8, !tbaa !13
  %31 = tail call dereferenceable_or_null(16) ptr @calloc(i64 noundef 1, i64 noundef 16) #33
  %32 = icmp eq ptr %31, null
  br i1 %32, label %33, label %35

33:                                               ; preds = %27
  %34 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %22)
  tail call void @exit(i32 noundef 1) #34
  unreachable

35:                                               ; preds = %27
  store i64 14, ptr %31, align 8, !tbaa !133
  %36 = getelementptr inbounds nuw i8, ptr %31, i64 8
  store ptr %30, ptr %36, align 8, !tbaa !135
  %37 = ptrtoint ptr %31 to i64
  store i64 %37, ptr @sys_stdin, align 8, !tbaa !11
  %38 = sext i32 %0 to i64
  %39 = tail call fastcc i64 @mklist(i64 noundef %38)
  store i64 %39, ptr @sys_argv, align 8, !tbaa !11
  %40 = icmp sgt i32 %0, 0
  br i1 %40, label %41, label %43

41:                                               ; preds = %35
  %42 = zext nneg i32 %0 to i64
  br label %44

43:                                               ; preds = %67, %35
  ret void

44:                                               ; preds = %41, %67
  %45 = phi i64 [ 0, %41 ], [ %72, %67 ]
  %46 = load i64, ptr @sys_argv, align 8, !tbaa !11
  %47 = getelementptr inbounds nuw ptr, ptr %1, i64 %45
  %48 = load ptr, ptr %47, align 8, !tbaa !67
  %49 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %48) #35
  %50 = tail call fastcc i64 @mkstr(ptr noundef nonnull readonly %48, i64 noundef %49)
  %51 = inttoptr i64 %46 to ptr
  %52 = getelementptr inbounds nuw i8, ptr %51, i64 8
  %53 = load i64, ptr %52, align 8, !tbaa !27
  %54 = getelementptr inbounds nuw i8, ptr %51, i64 16
  %55 = load i64, ptr %54, align 8, !tbaa !70
  %56 = icmp slt i64 %53, %55
  br i1 %56, label %57, label %60

57:                                               ; preds = %44
  %58 = getelementptr inbounds nuw i8, ptr %51, i64 24
  %59 = load ptr, ptr %58, align 8, !tbaa !32
  br label %67

60:                                               ; preds = %44
  %61 = shl nsw i64 %55, 1
  store i64 %61, ptr %54, align 8, !tbaa !70
  %62 = getelementptr inbounds nuw i8, ptr %51, i64 24
  %63 = load ptr, ptr %62, align 8, !tbaa !32
  %64 = shl i64 %55, 4
  %65 = tail call ptr @realloc(ptr noundef %63, i64 noundef %64) #38
  store ptr %65, ptr %62, align 8, !tbaa !32
  %66 = load i64, ptr %52, align 8, !tbaa !27
  br label %67

67:                                               ; preds = %57, %60
  %68 = phi i64 [ %53, %57 ], [ %66, %60 ]
  %69 = phi ptr [ %59, %57 ], [ %65, %60 ]
  %70 = add nsw i64 %68, 1
  store i64 %70, ptr %52, align 8, !tbaa !27
  %71 = getelementptr inbounds i64, ptr %69, i64 %68
  store i64 %50, ptr %71, align 8, !tbaa !11
  %72 = add nuw nsw i64 %45, 1
  %73 = icmp eq i64 %72, %42
  br i1 %73, label %43, label %44, !llvm.loop !201
}

; Function Attrs: nounwind ssp uwtable(sync)
define internal fastcc void @def_exc(ptr noundef %0, ptr noundef %1) unnamed_addr #2 {
  %3 = icmp eq ptr %1, null
  br i1 %3, label %23, label %4

4:                                                ; preds = %2
  %5 = load i32, ptr @nexc, align 4, !tbaa !6
  %6 = icmp sgt i32 %5, 0
  br i1 %6, label %7, label %18

7:                                                ; preds = %4
  %8 = zext nneg i32 %5 to i64
  br label %12

9:                                                ; preds = %12
  %10 = add nuw nsw i64 %13, 1
  %11 = icmp eq i64 %10, %8
  br i1 %11, label %18, label %12, !llvm.loop !66

12:                                               ; preds = %9, %7
  %13 = phi i64 [ 0, %7 ], [ %10, %9 ]
  %14 = getelementptr inbounds nuw ptr, ptr @exc_nm, i64 %13
  %15 = load ptr, ptr %14, align 8, !tbaa !67
  %16 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %15, ptr noundef nonnull dereferenceable(1) %1) #35
  %17 = icmp eq i32 %16, 0
  br i1 %17, label %21, label %9

18:                                               ; preds = %9, %4
  %19 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %20 = tail call i32 (ptr, ptr, ...) @fprintf(ptr noundef %19, ptr noundef nonnull @.str.109, ptr noundef nonnull %1) #35
  tail call void @exit(i32 noundef 2) #34
  unreachable

21:                                               ; preds = %12
  %22 = getelementptr inbounds nuw i64, ptr @exc_cls, i64 %13
  br label %23

23:                                               ; preds = %2, %21
  %24 = phi ptr [ %22, %21 ], [ @rt_none_v, %2 ]
  %25 = load i64, ptr %24, align 8, !tbaa !11
  %26 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %0) #35
  %27 = tail call fastcc i64 @mkstr(ptr noundef nonnull readonly %0, i64 noundef %26)
  %28 = tail call fastcc i64 @new_class(i64 noundef %27, i64 noundef %25)
  br i1 %3, label %29, label %44

29:                                               ; preds = %23
  %30 = load i64, ptr @K_init, align 8, !tbaa !11
  %31 = tail call dereferenceable_or_null(24) ptr @calloc(i64 noundef 1, i64 noundef 24) #33
  %32 = icmp eq ptr %31, null
  br i1 %32, label %33, label %36

33:                                               ; preds = %29
  %34 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %35 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %34)
  tail call void @exit(i32 noundef 1) #34
  unreachable

36:                                               ; preds = %29
  store i64 10, ptr %31, align 8, !tbaa !115
  %37 = getelementptr inbounds nuw i8, ptr %31, i64 8
  store ptr @b_exc_init, ptr %37, align 8, !tbaa !57
  %38 = getelementptr inbounds nuw i8, ptr %31, i64 16
  store ptr @.str.91, ptr %38, align 8, !tbaa !87
  %39 = ptrtoint ptr %31 to i64
  %40 = inttoptr i64 %28 to ptr
  %41 = getelementptr inbounds nuw i8, ptr %40, i64 24
  %42 = load i64, ptr %41, align 8, !tbaa !44
  %43 = inttoptr i64 %42 to ptr
  tail call fastcc void @dict_set(ptr noundef %43, i64 noundef %30, i64 noundef %39)
  br label %44

44:                                               ; preds = %36, %23
  %45 = load i32, ptr @nexc, align 4, !tbaa !6
  %46 = sext i32 %45 to i64
  %47 = getelementptr inbounds ptr, ptr @exc_nm, i64 %46
  store ptr %0, ptr %47, align 8, !tbaa !67
  %48 = add nsw i32 %45, 1
  store i32 %48, ptr @nexc, align 4, !tbaa !6
  %49 = getelementptr inbounds i64, ptr @exc_cls, i64 %46
  store i64 %28, ptr %49, align 8, !tbaa !11
  ret void
}

; Function Attrs: nofree nounwind
declare noundef i32 @setvbuf(ptr noundef captures(none), ptr noundef, i32 noundef, i64 noundef) local_unnamed_addr #6

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,zeroed") allocsize(0,1) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @calloc(i64 noundef, i64 noundef) local_unnamed_addr #22

; Function Attrs: nounwind ssp uwtable(sync)
define internal fastcc i64 @hash_v(i64 noundef %0) unnamed_addr #2 {
  %2 = and i64 %0, 1
  %3 = icmp eq i64 %2, 0
  br i1 %3, label %7, label %4

4:                                                ; preds = %1
  %5 = ashr i64 %0, 1
  %6 = mul i64 %5, -7046029254386353131
  br label %62

7:                                                ; preds = %1
  %8 = icmp eq i64 %0, 0
  br i1 %8, label %60, label %9

9:                                                ; preds = %7
  %10 = inttoptr i64 %0 to ptr
  %11 = load i64, ptr %10, align 8, !tbaa !23
  switch i64 %11, label %60 [
    i64 2, label %18
    i64 3, label %22
    i64 4, label %31
    i64 6, label %12
    i64 5, label %59
    i64 7, label %59
    i64 8, label %59
  ]

12:                                               ; preds = %9
  %13 = getelementptr inbounds nuw i8, ptr %10, i64 8
  %14 = load i64, ptr %13, align 8, !tbaa !27
  %15 = icmp sgt i64 %14, 0
  br i1 %15, label %16, label %62

16:                                               ; preds = %12
  %17 = getelementptr inbounds nuw i8, ptr %10, i64 24
  br label %47

18:                                               ; preds = %9
  %19 = getelementptr inbounds nuw i8, ptr %10, i64 8
  %20 = load i64, ptr %19, align 8, !tbaa !25
  %21 = mul i64 %20, -7046029254386353131
  br label %62

22:                                               ; preds = %9
  %23 = getelementptr inbounds nuw i8, ptr %10, i64 8
  %24 = load double, ptr %23, align 8, !tbaa !22
  %25 = fptosi double %24 to i64
  %26 = sitofp i64 %25 to double
  %27 = fcmp oeq double %24, %26
  %28 = mul i64 %25, -7046029254386353131
  %29 = bitcast double %24 to i64
  %30 = select i1 %27, i64 %28, i64 %29
  br label %62

31:                                               ; preds = %9
  %32 = getelementptr inbounds nuw i8, ptr %10, i64 8
  %33 = load i64, ptr %32, align 8, !tbaa !18
  %34 = icmp sgt i64 %33, 0
  br i1 %34, label %35, label %62

35:                                               ; preds = %31
  %36 = getelementptr inbounds nuw i8, ptr %10, i64 16
  br label %37

37:                                               ; preds = %35, %37
  %38 = phi i64 [ 0, %35 ], [ %45, %37 ]
  %39 = phi i64 [ 1469598103934665603, %35 ], [ %44, %37 ]
  %40 = getelementptr inbounds nuw i8, ptr %36, i64 %38
  %41 = load i8, ptr %40, align 1, !tbaa !10
  %42 = zext i8 %41 to i64
  %43 = xor i64 %39, %42
  %44 = mul i64 %43, 1099511628211
  %45 = add nuw nsw i64 %38, 1
  %46 = icmp eq i64 %45, %33
  br i1 %46, label %62, label %37, !llvm.loop !202

47:                                               ; preds = %16, %47
  %48 = phi i64 [ 0, %16 ], [ %56, %47 ]
  %49 = phi i64 [ 3430008, %16 ], [ %55, %47 ]
  %50 = load ptr, ptr %17, align 8, !tbaa !32
  %51 = getelementptr inbounds nuw i64, ptr %50, i64 %48
  %52 = load i64, ptr %51, align 8, !tbaa !11
  %53 = tail call fastcc i64 @hash_v(i64 noundef %52)
  %54 = xor i64 %53, %49
  %55 = mul i64 %54, 1000003
  %56 = add nuw nsw i64 %48, 1
  %57 = load i64, ptr %13, align 8, !tbaa !27
  %58 = icmp slt i64 %56, %57
  br i1 %58, label %47, label %62, !llvm.loop !203

59:                                               ; preds = %9, %9, %9
  tail call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.28, ptr noundef nonnull @.str.110) #36
  unreachable

60:                                               ; preds = %7, %9
  %61 = ashr i64 %0, 3
  br label %62

62:                                               ; preds = %47, %37, %12, %31, %60, %22, %18, %4
  %63 = phi i64 [ %6, %4 ], [ %61, %60 ], [ %21, %18 ], [ %30, %22 ], [ %44, %37 ], [ 1469598103934665603, %31 ], [ 3430008, %12 ], [ %55, %47 ]
  ret i64 %63
}

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #23

; Function Attrs: nounwind ssp uwtable(sync)
define internal fastcc void @repr_str(ptr noundef nonnull captures(none) %0, ptr noundef readonly %1) unnamed_addr #2 {
  %3 = alloca [8 x i8], align 1
  %4 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %5 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %6 = load i64, ptr %5, align 8, !tbaa !18
  %7 = tail call ptr @memchr(ptr noundef nonnull %4, i32 noundef 39, i64 noundef %6) #35
  %8 = icmp eq ptr %7, null
  br i1 %8, label %13, label %9

9:                                                ; preds = %2
  %10 = tail call ptr @memchr(ptr noundef nonnull %4, i32 noundef 34, i64 noundef %6) #35
  %11 = icmp eq ptr %10, null
  %12 = select i1 %11, i8 34, i8 39
  br label %13

13:                                               ; preds = %9, %2
  %14 = phi i8 [ %12, %9 ], [ 39, %2 ]
  %15 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %16 = load i64, ptr %15, align 8, !tbaa !63
  %17 = add nsw i64 %16, 1
  %18 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %19 = load i64, ptr %18, align 8, !tbaa !82
  %20 = icmp slt i64 %17, %19
  br i1 %20, label %21, label %23

21:                                               ; preds = %13
  %22 = load ptr, ptr %0, align 8, !tbaa !61
  br label %31

23:                                               ; preds = %13, %23
  %24 = phi i64 [ %25, %23 ], [ %19, %13 ]
  %25 = shl nsw i64 %24, 1
  %26 = icmp sgt i64 %25, %17
  br i1 %26, label %27, label %23, !llvm.loop !83

27:                                               ; preds = %23
  %28 = load ptr, ptr %0, align 8, !tbaa !61
  %29 = tail call ptr @realloc(ptr noundef %28, i64 noundef %25) #38
  store ptr %29, ptr %0, align 8, !tbaa !61
  store i64 %25, ptr %18, align 8, !tbaa !82
  %30 = load i64, ptr %15, align 8, !tbaa !63
  br label %31

31:                                               ; preds = %21, %27
  %32 = phi i64 [ %16, %21 ], [ %30, %27 ]
  %33 = phi ptr [ %22, %21 ], [ %29, %27 ]
  %34 = getelementptr inbounds i8, ptr %33, i64 %32
  store i8 %14, ptr %34, align 1
  %35 = load i64, ptr %15, align 8, !tbaa !63
  %36 = add nsw i64 %35, 1
  store i64 %36, ptr %15, align 8, !tbaa !63
  %37 = load ptr, ptr %0, align 8, !tbaa !61
  %38 = getelementptr inbounds i8, ptr %37, i64 %36
  store i8 0, ptr %38, align 1, !tbaa !10
  %39 = load i64, ptr %5, align 8, !tbaa !18
  %40 = icmp sgt i64 %39, 0
  br i1 %40, label %64, label %41

41:                                               ; preds = %239, %31
  %42 = load i64, ptr %15, align 8, !tbaa !63
  %43 = add nsw i64 %42, 1
  %44 = load i64, ptr %18, align 8, !tbaa !82
  %45 = icmp slt i64 %43, %44
  br i1 %45, label %46, label %48

46:                                               ; preds = %41
  %47 = load ptr, ptr %0, align 8, !tbaa !61
  br label %56

48:                                               ; preds = %41, %48
  %49 = phi i64 [ %50, %48 ], [ %44, %41 ]
  %50 = shl nsw i64 %49, 1
  %51 = icmp sgt i64 %50, %43
  br i1 %51, label %52, label %48, !llvm.loop !83

52:                                               ; preds = %48
  %53 = load ptr, ptr %0, align 8, !tbaa !61
  %54 = tail call ptr @realloc(ptr noundef %53, i64 noundef %50) #38
  store ptr %54, ptr %0, align 8, !tbaa !61
  store i64 %50, ptr %18, align 8, !tbaa !82
  %55 = load i64, ptr %15, align 8, !tbaa !63
  br label %56

56:                                               ; preds = %46, %52
  %57 = phi i64 [ %42, %46 ], [ %55, %52 ]
  %58 = phi ptr [ %47, %46 ], [ %54, %52 ]
  %59 = getelementptr inbounds i8, ptr %58, i64 %57
  store i8 %14, ptr %59, align 1
  %60 = load i64, ptr %15, align 8, !tbaa !63
  %61 = add nsw i64 %60, 1
  store i64 %61, ptr %15, align 8, !tbaa !63
  %62 = load ptr, ptr %0, align 8, !tbaa !61
  %63 = getelementptr inbounds i8, ptr %62, i64 %61
  store i8 0, ptr %63, align 1, !tbaa !10
  ret void

64:                                               ; preds = %31, %239
  %65 = phi i64 [ %240, %239 ], [ 0, %31 ]
  %66 = getelementptr inbounds nuw i8, ptr %4, i64 %65
  %67 = load i8, ptr %66, align 1, !tbaa !10
  %68 = zext i8 %67 to i32
  %69 = icmp eq i8 %67, %14
  %70 = icmp eq i8 %67, 92
  %71 = or i1 %69, %70
  br i1 %71, label %72, label %117

72:                                               ; preds = %64
  %73 = load i64, ptr %15, align 8, !tbaa !63
  %74 = add nsw i64 %73, 1
  %75 = load i64, ptr %18, align 8, !tbaa !82
  %76 = icmp slt i64 %74, %75
  br i1 %76, label %77, label %79

77:                                               ; preds = %72
  %78 = load ptr, ptr %0, align 8, !tbaa !61
  br label %87

79:                                               ; preds = %72, %79
  %80 = phi i64 [ %81, %79 ], [ %75, %72 ]
  %81 = shl nsw i64 %80, 1
  %82 = icmp sgt i64 %81, %74
  br i1 %82, label %83, label %79, !llvm.loop !83

83:                                               ; preds = %79
  %84 = load ptr, ptr %0, align 8, !tbaa !61
  %85 = tail call ptr @realloc(ptr noundef %84, i64 noundef %81) #38
  store ptr %85, ptr %0, align 8, !tbaa !61
  store i64 %81, ptr %18, align 8, !tbaa !82
  %86 = load i64, ptr %15, align 8, !tbaa !63
  br label %87

87:                                               ; preds = %77, %83
  %88 = phi i64 [ %73, %77 ], [ %86, %83 ]
  %89 = phi ptr [ %78, %77 ], [ %85, %83 ]
  %90 = getelementptr inbounds i8, ptr %89, i64 %88
  store i8 92, ptr %90, align 1
  %91 = load i64, ptr %15, align 8, !tbaa !63
  %92 = add nsw i64 %91, 1
  store i64 %92, ptr %15, align 8, !tbaa !63
  %93 = load ptr, ptr %0, align 8, !tbaa !61
  %94 = getelementptr inbounds i8, ptr %93, i64 %92
  store i8 0, ptr %94, align 1, !tbaa !10
  %95 = load i64, ptr %15, align 8, !tbaa !63
  %96 = add nsw i64 %95, 1
  %97 = load i64, ptr %18, align 8, !tbaa !82
  %98 = icmp slt i64 %96, %97
  br i1 %98, label %99, label %101

99:                                               ; preds = %87
  %100 = load ptr, ptr %0, align 8, !tbaa !61
  br label %109

101:                                              ; preds = %87, %101
  %102 = phi i64 [ %103, %101 ], [ %97, %87 ]
  %103 = shl nsw i64 %102, 1
  %104 = icmp sgt i64 %103, %96
  br i1 %104, label %105, label %101, !llvm.loop !83

105:                                              ; preds = %101
  %106 = load ptr, ptr %0, align 8, !tbaa !61
  %107 = tail call ptr @realloc(ptr noundef %106, i64 noundef %103) #38
  store ptr %107, ptr %0, align 8, !tbaa !61
  store i64 %103, ptr %18, align 8, !tbaa !82
  %108 = load i64, ptr %15, align 8, !tbaa !63
  br label %109

109:                                              ; preds = %99, %105
  %110 = phi i64 [ %95, %99 ], [ %108, %105 ]
  %111 = phi ptr [ %100, %99 ], [ %107, %105 ]
  %112 = getelementptr inbounds i8, ptr %111, i64 %110
  store i8 %67, ptr %112, align 1
  %113 = load i64, ptr %15, align 8, !tbaa !63
  %114 = add nsw i64 %113, 1
  store i64 %114, ptr %15, align 8, !tbaa !63
  %115 = load ptr, ptr %0, align 8, !tbaa !61
  %116 = getelementptr inbounds i8, ptr %115, i64 %114
  store i8 0, ptr %116, align 1, !tbaa !10
  br label %239

117:                                              ; preds = %64
  switch i8 %67, label %187 [
    i8 10, label %118
    i8 9, label %141
    i8 13, label %164
  ]

118:                                              ; preds = %117
  %119 = load i64, ptr %15, align 8, !tbaa !63
  %120 = add nsw i64 %119, 2
  %121 = load i64, ptr %18, align 8, !tbaa !82
  %122 = icmp slt i64 %120, %121
  br i1 %122, label %123, label %125

123:                                              ; preds = %118
  %124 = load ptr, ptr %0, align 8, !tbaa !61
  br label %133

125:                                              ; preds = %118, %125
  %126 = phi i64 [ %127, %125 ], [ %121, %118 ]
  %127 = shl nsw i64 %126, 1
  %128 = icmp sgt i64 %127, %120
  br i1 %128, label %129, label %125, !llvm.loop !83

129:                                              ; preds = %125
  %130 = load ptr, ptr %0, align 8, !tbaa !61
  %131 = tail call ptr @realloc(ptr noundef %130, i64 noundef %127) #38
  store ptr %131, ptr %0, align 8, !tbaa !61
  store i64 %127, ptr %18, align 8, !tbaa !82
  %132 = load i64, ptr %15, align 8, !tbaa !63
  br label %133

133:                                              ; preds = %123, %129
  %134 = phi i64 [ %119, %123 ], [ %132, %129 ]
  %135 = phi ptr [ %124, %123 ], [ %131, %129 ]
  %136 = getelementptr inbounds i8, ptr %135, i64 %134
  store i16 28252, ptr %136, align 1
  %137 = load i64, ptr %15, align 8, !tbaa !63
  %138 = add nsw i64 %137, 2
  store i64 %138, ptr %15, align 8, !tbaa !63
  %139 = load ptr, ptr %0, align 8, !tbaa !61
  %140 = getelementptr inbounds i8, ptr %139, i64 %138
  store i8 0, ptr %140, align 1, !tbaa !10
  br label %239

141:                                              ; preds = %117
  %142 = load i64, ptr %15, align 8, !tbaa !63
  %143 = add nsw i64 %142, 2
  %144 = load i64, ptr %18, align 8, !tbaa !82
  %145 = icmp slt i64 %143, %144
  br i1 %145, label %146, label %148

146:                                              ; preds = %141
  %147 = load ptr, ptr %0, align 8, !tbaa !61
  br label %156

148:                                              ; preds = %141, %148
  %149 = phi i64 [ %150, %148 ], [ %144, %141 ]
  %150 = shl nsw i64 %149, 1
  %151 = icmp sgt i64 %150, %143
  br i1 %151, label %152, label %148, !llvm.loop !83

152:                                              ; preds = %148
  %153 = load ptr, ptr %0, align 8, !tbaa !61
  %154 = tail call ptr @realloc(ptr noundef %153, i64 noundef %150) #38
  store ptr %154, ptr %0, align 8, !tbaa !61
  store i64 %150, ptr %18, align 8, !tbaa !82
  %155 = load i64, ptr %15, align 8, !tbaa !63
  br label %156

156:                                              ; preds = %146, %152
  %157 = phi i64 [ %142, %146 ], [ %155, %152 ]
  %158 = phi ptr [ %147, %146 ], [ %154, %152 ]
  %159 = getelementptr inbounds i8, ptr %158, i64 %157
  store i16 29788, ptr %159, align 1
  %160 = load i64, ptr %15, align 8, !tbaa !63
  %161 = add nsw i64 %160, 2
  store i64 %161, ptr %15, align 8, !tbaa !63
  %162 = load ptr, ptr %0, align 8, !tbaa !61
  %163 = getelementptr inbounds i8, ptr %162, i64 %161
  store i8 0, ptr %163, align 1, !tbaa !10
  br label %239

164:                                              ; preds = %117
  %165 = load i64, ptr %15, align 8, !tbaa !63
  %166 = add nsw i64 %165, 2
  %167 = load i64, ptr %18, align 8, !tbaa !82
  %168 = icmp slt i64 %166, %167
  br i1 %168, label %169, label %171

169:                                              ; preds = %164
  %170 = load ptr, ptr %0, align 8, !tbaa !61
  br label %179

171:                                              ; preds = %164, %171
  %172 = phi i64 [ %173, %171 ], [ %167, %164 ]
  %173 = shl nsw i64 %172, 1
  %174 = icmp sgt i64 %173, %166
  br i1 %174, label %175, label %171, !llvm.loop !83

175:                                              ; preds = %171
  %176 = load ptr, ptr %0, align 8, !tbaa !61
  %177 = tail call ptr @realloc(ptr noundef %176, i64 noundef %173) #38
  store ptr %177, ptr %0, align 8, !tbaa !61
  store i64 %173, ptr %18, align 8, !tbaa !82
  %178 = load i64, ptr %15, align 8, !tbaa !63
  br label %179

179:                                              ; preds = %169, %175
  %180 = phi i64 [ %165, %169 ], [ %178, %175 ]
  %181 = phi ptr [ %170, %169 ], [ %177, %175 ]
  %182 = getelementptr inbounds i8, ptr %181, i64 %180
  store i16 29276, ptr %182, align 1
  %183 = load i64, ptr %15, align 8, !tbaa !63
  %184 = add nsw i64 %183, 2
  store i64 %184, ptr %15, align 8, !tbaa !63
  %185 = load ptr, ptr %0, align 8, !tbaa !61
  %186 = getelementptr inbounds i8, ptr %185, i64 %184
  store i8 0, ptr %186, align 1, !tbaa !10
  br label %239

187:                                              ; preds = %117
  %188 = icmp ult i8 %67, 32
  %189 = icmp eq i8 %67, 127
  %190 = or i1 %188, %189
  br i1 %190, label %191, label %216

191:                                              ; preds = %187
  call void @llvm.lifetime.start.p0(ptr nonnull %3) #35
  %192 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr nonnull dereferenceable(1) %3, i64 8, ptr nonnull @.str.130, i32 %68)
  %193 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %3) #35
  %194 = load i64, ptr %15, align 8, !tbaa !63
  %195 = add nsw i64 %194, %193
  %196 = load i64, ptr %18, align 8, !tbaa !82
  %197 = icmp slt i64 %195, %196
  br i1 %197, label %198, label %200

198:                                              ; preds = %191
  %199 = load ptr, ptr %0, align 8, !tbaa !61
  br label %208

200:                                              ; preds = %191, %200
  %201 = phi i64 [ %202, %200 ], [ %196, %191 ]
  %202 = shl nsw i64 %201, 1
  %203 = icmp sgt i64 %202, %195
  br i1 %203, label %204, label %200, !llvm.loop !83

204:                                              ; preds = %200
  %205 = load ptr, ptr %0, align 8, !tbaa !61
  %206 = tail call ptr @realloc(ptr noundef %205, i64 noundef %202) #38
  store ptr %206, ptr %0, align 8, !tbaa !61
  store i64 %202, ptr %18, align 8, !tbaa !82
  %207 = load i64, ptr %15, align 8, !tbaa !63
  br label %208

208:                                              ; preds = %198, %204
  %209 = phi i64 [ %194, %198 ], [ %207, %204 ]
  %210 = phi ptr [ %199, %198 ], [ %206, %204 ]
  %211 = getelementptr inbounds i8, ptr %210, i64 %209
  call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %211, ptr noundef nonnull readonly align 1 %3, i64 noundef %193, i1 noundef false) #35
  %212 = load i64, ptr %15, align 8, !tbaa !63
  %213 = add nsw i64 %212, %193
  store i64 %213, ptr %15, align 8, !tbaa !63
  %214 = load ptr, ptr %0, align 8, !tbaa !61
  %215 = getelementptr inbounds i8, ptr %214, i64 %213
  store i8 0, ptr %215, align 1, !tbaa !10
  call void @llvm.lifetime.end.p0(ptr nonnull %3) #35
  br label %239

216:                                              ; preds = %187
  %217 = load i64, ptr %15, align 8, !tbaa !63
  %218 = add nsw i64 %217, 1
  %219 = load i64, ptr %18, align 8, !tbaa !82
  %220 = icmp slt i64 %218, %219
  br i1 %220, label %221, label %223

221:                                              ; preds = %216
  %222 = load ptr, ptr %0, align 8, !tbaa !61
  br label %231

223:                                              ; preds = %216, %223
  %224 = phi i64 [ %225, %223 ], [ %219, %216 ]
  %225 = shl nsw i64 %224, 1
  %226 = icmp sgt i64 %225, %218
  br i1 %226, label %227, label %223, !llvm.loop !83

227:                                              ; preds = %223
  %228 = load ptr, ptr %0, align 8, !tbaa !61
  %229 = tail call ptr @realloc(ptr noundef %228, i64 noundef %225) #38
  store ptr %229, ptr %0, align 8, !tbaa !61
  store i64 %225, ptr %18, align 8, !tbaa !82
  %230 = load i64, ptr %15, align 8, !tbaa !63
  br label %231

231:                                              ; preds = %221, %227
  %232 = phi i64 [ %217, %221 ], [ %230, %227 ]
  %233 = phi ptr [ %222, %221 ], [ %229, %227 ]
  %234 = getelementptr inbounds i8, ptr %233, i64 %232
  store i8 %67, ptr %234, align 1
  %235 = load i64, ptr %15, align 8, !tbaa !63
  %236 = add nsw i64 %235, 1
  store i64 %236, ptr %15, align 8, !tbaa !63
  %237 = load ptr, ptr %0, align 8, !tbaa !61
  %238 = getelementptr inbounds i8, ptr %237, i64 %236
  store i8 0, ptr %238, align 1, !tbaa !10
  br label %239

239:                                              ; preds = %133, %179, %231, %208, %156, %109
  %240 = add nuw nsw i64 %65, 1
  %241 = load i64, ptr %5, align 8, !tbaa !18
  %242 = icmp slt i64 %240, %241
  br i1 %242, label %64, label %41, !llvm.loop !204
}

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: read)
declare ptr @memchr(ptr noundef, i32 noundef, i64 noundef) local_unnamed_addr #4

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.va_start.p0(ptr) #18

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.va_end.p0(ptr) #18

; Function Attrs: mustprogress nounwind willreturn allockind("realloc") allocsize(1) memory(argmem: readwrite, inaccessiblemem: readwrite)
declare noalias noundef ptr @realloc(ptr allocptr noundef captures(none), i64 noundef) local_unnamed_addr #24

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(read)
declare i32 @atoi(ptr noundef captures(none)) local_unnamed_addr #25

declare i32 @__maskrune(i32 noundef, i64 noundef) local_unnamed_addr #3

; Function Attrs: nounwind ssp uwtable(sync)
define internal fastcc void @msort(ptr noundef %0, ptr noundef nonnull %1, i64 noundef %2) unnamed_addr #2 {
  %4 = ptrtoint ptr %0 to i64
  %5 = ptrtoint ptr %1 to i64
  %6 = ptrtoint ptr %0 to i64
  %7 = ptrtoint ptr %1 to i64
  %8 = icmp slt i64 %2, 2
  br i1 %8, label %144, label %9

9:                                                ; preds = %3
  %10 = lshr i64 %2, 1
  tail call fastcc void @msort(ptr noundef %0, ptr noundef %1, i64 noundef %10)
  %11 = getelementptr inbounds nuw i64, ptr %0, i64 %10
  %12 = sub nsw i64 %2, %10
  tail call fastcc void @msort(ptr noundef %11, ptr noundef %1, i64 noundef %12)
  br label %57

13:                                               ; preds = %57
  %14 = icmp samesign ult i64 %69, %10
  br i1 %14, label %15, label %79

15:                                               ; preds = %13
  %16 = add i64 %75, %10
  %17 = sub i64 %16, %69
  %18 = sub nsw i64 %10, %60
  %19 = sext i1 %66 to i64
  %20 = add i64 %18, %19
  %21 = icmp ult i64 %20, 10
  br i1 %21, label %54, label %22

22:                                               ; preds = %15
  %23 = add i64 %7, 8
  %24 = shl i64 %58, 3
  %25 = shl i64 %69, 3
  %26 = add i64 %23, %24
  %27 = add i64 %25, %6
  %28 = sub i64 %26, %27
  %29 = icmp ult i64 %28, 64
  br i1 %29, label %54, label %30

30:                                               ; preds = %22
  %31 = and i64 %20, -8
  %32 = add i64 %75, %31
  %33 = add i64 %69, %31
  %34 = getelementptr i64, ptr %0, i64 %69
  %35 = getelementptr i64, ptr %1, i64 %75
  br label %36

36:                                               ; preds = %36, %30
  %37 = phi i64 [ 0, %30 ], [ %50, %36 ]
  %38 = getelementptr i64, ptr %34, i64 %37
  %39 = getelementptr inbounds nuw i8, ptr %38, i64 16
  %40 = getelementptr inbounds nuw i8, ptr %38, i64 32
  %41 = getelementptr inbounds nuw i8, ptr %38, i64 48
  %42 = load <2 x i64>, ptr %38, align 8, !tbaa !11
  %43 = load <2 x i64>, ptr %39, align 8, !tbaa !11
  %44 = load <2 x i64>, ptr %40, align 8, !tbaa !11
  %45 = load <2 x i64>, ptr %41, align 8, !tbaa !11
  %46 = getelementptr i64, ptr %35, i64 %37
  %47 = getelementptr inbounds nuw i8, ptr %46, i64 16
  %48 = getelementptr inbounds nuw i8, ptr %46, i64 32
  %49 = getelementptr inbounds nuw i8, ptr %46, i64 48
  store <2 x i64> %42, ptr %46, align 8, !tbaa !11
  store <2 x i64> %43, ptr %47, align 8, !tbaa !11
  store <2 x i64> %44, ptr %48, align 8, !tbaa !11
  store <2 x i64> %45, ptr %49, align 8, !tbaa !11
  %50 = add nuw i64 %37, 8
  %51 = icmp eq i64 %50, %31
  br i1 %51, label %52, label %36, !llvm.loop !205

52:                                               ; preds = %36
  %53 = icmp eq i64 %20, %31
  br i1 %53, label %79, label %54

54:                                               ; preds = %22, %15, %52
  %55 = phi i64 [ %75, %22 ], [ %75, %15 ], [ %32, %52 ]
  %56 = phi i64 [ %69, %22 ], [ %69, %15 ], [ %33, %52 ]
  br label %124

57:                                               ; preds = %9, %57
  %58 = phi i64 [ %75, %57 ], [ 0, %9 ]
  %59 = phi i64 [ %72, %57 ], [ %10, %9 ]
  %60 = phi i64 [ %69, %57 ], [ 0, %9 ]
  %61 = getelementptr inbounds nuw i64, ptr %0, i64 %59
  %62 = load i64, ptr %61, align 8, !tbaa !11
  %63 = getelementptr inbounds nuw i64, ptr %0, i64 %60
  %64 = load i64, ptr %63, align 8, !tbaa !11
  %65 = tail call fastcc i32 @cmp_v(i64 noundef %62, i64 noundef %64)
  %66 = icmp sgt i32 %65, -1
  %67 = select i1 %66, ptr %63, ptr %61
  %68 = zext i1 %66 to i64
  %69 = add nuw nsw i64 %60, %68
  %70 = xor i1 %66, true
  %71 = zext i1 %70 to i64
  %72 = add i64 %59, %71
  %73 = load i64, ptr %67, align 8, !tbaa !11
  %74 = getelementptr inbounds nuw i64, ptr %1, i64 %58
  store i64 %73, ptr %74, align 8, !tbaa !11
  %75 = add nuw i64 %58, 1
  %76 = icmp samesign ult i64 %69, %10
  %77 = icmp slt i64 %72, %2
  %78 = and i1 %76, %77
  br i1 %78, label %57, label %13, !llvm.loop !206

79:                                               ; preds = %124, %52, %13
  %80 = phi i64 [ %75, %13 ], [ %17, %52 ], [ %17, %124 ]
  %81 = icmp slt i64 %72, %2
  br i1 %81, label %82, label %142

82:                                               ; preds = %79
  %83 = add i64 %80, %2
  %84 = sub i64 %83, %72
  %85 = sub i64 %2, %59
  %86 = xor i1 %66, true
  %87 = sext i1 %86 to i64
  %88 = add i64 %85, %87
  %89 = icmp ult i64 %88, 10
  br i1 %89, label %121, label %90

90:                                               ; preds = %82
  %91 = shl i64 %80, 3
  %92 = shl i64 %72, 3
  %93 = add i64 %91, %5
  %94 = add i64 %92, %4
  %95 = sub i64 %93, %94
  %96 = icmp ult i64 %95, 64
  br i1 %96, label %121, label %97

97:                                               ; preds = %90
  %98 = and i64 %88, -8
  %99 = add i64 %80, %98
  %100 = add i64 %72, %98
  %101 = getelementptr i64, ptr %0, i64 %72
  %102 = getelementptr i64, ptr %1, i64 %80
  br label %103

103:                                              ; preds = %103, %97
  %104 = phi i64 [ 0, %97 ], [ %117, %103 ]
  %105 = getelementptr i64, ptr %101, i64 %104
  %106 = getelementptr inbounds nuw i8, ptr %105, i64 16
  %107 = getelementptr inbounds nuw i8, ptr %105, i64 32
  %108 = getelementptr inbounds nuw i8, ptr %105, i64 48
  %109 = load <2 x i64>, ptr %105, align 8, !tbaa !11
  %110 = load <2 x i64>, ptr %106, align 8, !tbaa !11
  %111 = load <2 x i64>, ptr %107, align 8, !tbaa !11
  %112 = load <2 x i64>, ptr %108, align 8, !tbaa !11
  %113 = getelementptr i64, ptr %102, i64 %104
  %114 = getelementptr inbounds nuw i8, ptr %113, i64 16
  %115 = getelementptr inbounds nuw i8, ptr %113, i64 32
  %116 = getelementptr inbounds nuw i8, ptr %113, i64 48
  store <2 x i64> %109, ptr %113, align 8, !tbaa !11
  store <2 x i64> %110, ptr %114, align 8, !tbaa !11
  store <2 x i64> %111, ptr %115, align 8, !tbaa !11
  store <2 x i64> %112, ptr %116, align 8, !tbaa !11
  %117 = add nuw i64 %104, 8
  %118 = icmp eq i64 %117, %98
  br i1 %118, label %119, label %103, !llvm.loop !207

119:                                              ; preds = %103
  %120 = icmp eq i64 %88, %98
  br i1 %120, label %142, label %121

121:                                              ; preds = %90, %82, %119
  %122 = phi i64 [ %80, %90 ], [ %80, %82 ], [ %99, %119 ]
  %123 = phi i64 [ %72, %90 ], [ %72, %82 ], [ %100, %119 ]
  br label %133

124:                                              ; preds = %54, %124
  %125 = phi i64 [ %130, %124 ], [ %55, %54 ]
  %126 = phi i64 [ %127, %124 ], [ %56, %54 ]
  %127 = add nuw nsw i64 %126, 1
  %128 = getelementptr inbounds nuw i64, ptr %0, i64 %126
  %129 = load i64, ptr %128, align 8, !tbaa !11
  %130 = add i64 %125, 1
  %131 = getelementptr inbounds nuw i64, ptr %1, i64 %125
  store i64 %129, ptr %131, align 8, !tbaa !11
  %132 = icmp eq i64 %130, %17
  br i1 %132, label %79, label %124, !llvm.loop !208

133:                                              ; preds = %121, %133
  %134 = phi i64 [ %139, %133 ], [ %122, %121 ]
  %135 = phi i64 [ %136, %133 ], [ %123, %121 ]
  %136 = add nuw nsw i64 %135, 1
  %137 = getelementptr inbounds nuw i64, ptr %0, i64 %135
  %138 = load i64, ptr %137, align 8, !tbaa !11
  %139 = add i64 %134, 1
  %140 = getelementptr inbounds nuw i64, ptr %1, i64 %134
  store i64 %138, ptr %140, align 8, !tbaa !11
  %141 = icmp eq i64 %139, %84
  br i1 %141, label %142, label %133, !llvm.loop !209

142:                                              ; preds = %133, %119, %79
  %143 = shl i64 %2, 3
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 %0, ptr noundef nonnull align 1 %1, i64 noundef %143, i1 noundef false) #35
  br label %144

144:                                              ; preds = %3, %142
  ret void
}

; Function Attrs: nofree norecurse nounwind ssp memory(argmem: read) uwtable(sync)
define internal fastcc range(i64 -1, -9223372036854775808) i64 @str_find(ptr noundef readonly captures(none) %0, ptr noundef readonly captures(none) %1, i64 noundef %2) unnamed_addr #26 {
  %4 = tail call i64 @llvm.smax.i64(i64 %2, i64 0)
  %5 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %6 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %7 = load i64, ptr %6, align 8, !tbaa !18
  %8 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %9 = load i64, ptr %8, align 8, !tbaa !18
  %10 = add nsw i64 %7, %4
  %11 = icmp sgt i64 %10, %9
  br i1 %11, label %23, label %12

12:                                               ; preds = %3
  %13 = getelementptr inbounds nuw i8, ptr %1, i64 16
  br label %14

14:                                               ; preds = %12, %19
  %15 = phi i64 [ %4, %12 ], [ %20, %19 ]
  %16 = getelementptr inbounds nuw i8, ptr %5, i64 %15
  %17 = tail call i32 @memcmp(ptr noundef nonnull %16, ptr noundef nonnull %13, i64 noundef %7)
  %18 = icmp eq i32 %17, 0
  br i1 %18, label %23, label %19

19:                                               ; preds = %14
  %20 = add nuw nsw i64 %15, 1
  %21 = add nsw i64 %7, %20
  %22 = icmp sgt i64 %21, %9
  br i1 %22, label %23, label %14, !llvm.loop !168

23:                                               ; preds = %14, %19, %3
  %24 = phi i64 [ -1, %3 ], [ -1, %19 ], [ %15, %14 ]
  ret i64 %24
}

; Function Attrs: nounwind ssp uwtable(sync)
define internal fastcc i64 @str_format_method(i64 noundef %0, i64 noundef %1, ptr noundef readonly captures(none) %2) unnamed_addr #2 {
  %4 = alloca %struct.SB, align 8
  %5 = alloca [128 x i8], align 1
  %6 = inttoptr i64 %0 to ptr
  %7 = tail call dereferenceable_or_null(64) ptr @calloc(i64 noundef 1, i64 noundef 64) #33
  %8 = icmp eq ptr %7, null
  br i1 %8, label %16, label %9

9:                                                ; preds = %3
  %10 = getelementptr inbounds nuw i8, ptr %6, i64 8
  %11 = load i64, ptr %10, align 8, !tbaa !18
  %12 = icmp sgt i64 %11, 0
  br i1 %12, label %13, label %19

13:                                               ; preds = %9
  %14 = getelementptr inbounds nuw i8, ptr %6, i64 16
  %15 = getelementptr inbounds nuw i8, ptr %4, i64 8
  br label %23

16:                                               ; preds = %3
  %17 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %18 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %17)
  tail call void @exit(i32 noundef 1) #34
  unreachable

19:                                               ; preds = %167, %9
  %20 = phi i64 [ 0, %9 ], [ %169, %167 ]
  %21 = phi ptr [ %7, %9 ], [ %170, %167 ]
  %22 = call fastcc i64 @mkstr(ptr noundef nonnull %21, i64 noundef %20)
  ret i64 %22

23:                                               ; preds = %13, %167
  %24 = phi i64 [ %11, %13 ], [ %174, %167 ]
  %25 = phi i64 [ 0, %13 ], [ %172, %167 ]
  %26 = phi i64 [ 0, %13 ], [ %173, %167 ]
  %27 = phi ptr [ %7, %13 ], [ %170, %167 ]
  %28 = phi i64 [ 0, %13 ], [ %169, %167 ]
  %29 = phi i64 [ 64, %13 ], [ %168, %167 ]
  %30 = getelementptr inbounds i8, ptr %14, i64 %26
  %31 = load i8, ptr %30, align 1, !tbaa !10
  switch i8 %31, label %75 [
    i8 123, label %32
    i8 125, label %54
  ]

32:                                               ; preds = %23
  %33 = add nsw i64 %26, 1
  %34 = icmp slt i64 %33, %24
  br i1 %34, label %35, label %39

35:                                               ; preds = %32
  %36 = getelementptr inbounds i8, ptr %14, i64 %33
  %37 = load i8, ptr %36, align 1, !tbaa !10
  %38 = icmp eq i8 %37, 123
  br i1 %38, label %40, label %39

39:                                               ; preds = %32, %35
  br label %89

40:                                               ; preds = %35
  %41 = add nsw i64 %28, 1
  %42 = icmp slt i64 %41, %29
  br i1 %42, label %49, label %43

43:                                               ; preds = %40, %43
  %44 = phi i64 [ %45, %43 ], [ %29, %40 ]
  %45 = shl nuw nsw i64 %44, 1
  %46 = icmp sgt i64 %45, %41
  br i1 %46, label %47, label %43, !llvm.loop !83

47:                                               ; preds = %43
  %48 = call ptr @realloc(ptr noundef nonnull %27, i64 noundef %45) #38
  br label %49

49:                                               ; preds = %40, %47
  %50 = phi i64 [ %45, %47 ], [ %29, %40 ]
  %51 = phi ptr [ %48, %47 ], [ %27, %40 ]
  %52 = getelementptr inbounds i8, ptr %51, i64 %28
  store i8 123, ptr %52, align 1
  %53 = getelementptr inbounds i8, ptr %51, i64 %41
  store i8 0, ptr %53, align 1, !tbaa !10
  br label %167

54:                                               ; preds = %23
  %55 = add nsw i64 %26, 1
  %56 = icmp slt i64 %55, %24
  br i1 %56, label %57, label %75

57:                                               ; preds = %54
  %58 = getelementptr inbounds i8, ptr %14, i64 %55
  %59 = load i8, ptr %58, align 1, !tbaa !10
  %60 = icmp eq i8 %59, 125
  br i1 %60, label %61, label %75

61:                                               ; preds = %57
  %62 = add nsw i64 %28, 1
  %63 = icmp slt i64 %62, %29
  br i1 %63, label %70, label %64

64:                                               ; preds = %61, %64
  %65 = phi i64 [ %66, %64 ], [ %29, %61 ]
  %66 = shl nuw nsw i64 %65, 1
  %67 = icmp sgt i64 %66, %62
  br i1 %67, label %68, label %64, !llvm.loop !83

68:                                               ; preds = %64
  %69 = call ptr @realloc(ptr noundef nonnull %27, i64 noundef %66) #38
  br label %70

70:                                               ; preds = %61, %68
  %71 = phi i64 [ %66, %68 ], [ %29, %61 ]
  %72 = phi ptr [ %69, %68 ], [ %27, %61 ]
  %73 = getelementptr inbounds i8, ptr %72, i64 %28
  store i8 125, ptr %73, align 1
  %74 = getelementptr inbounds i8, ptr %72, i64 %62
  store i8 0, ptr %74, align 1, !tbaa !10
  br label %167

75:                                               ; preds = %54, %57, %23
  %76 = add nsw i64 %28, 1
  %77 = icmp slt i64 %76, %29
  br i1 %77, label %84, label %78

78:                                               ; preds = %75, %78
  %79 = phi i64 [ %80, %78 ], [ %29, %75 ]
  %80 = shl nuw nsw i64 %79, 1
  %81 = icmp sgt i64 %80, %76
  br i1 %81, label %82, label %78, !llvm.loop !83

82:                                               ; preds = %78
  %83 = call ptr @realloc(ptr noundef nonnull %27, i64 noundef %80) #38
  br label %84

84:                                               ; preds = %75, %82
  %85 = phi i64 [ %80, %82 ], [ %29, %75 ]
  %86 = phi ptr [ %83, %82 ], [ %27, %75 ]
  %87 = getelementptr inbounds i8, ptr %86, i64 %28
  store i8 %31, ptr %87, align 1
  %88 = getelementptr inbounds i8, ptr %86, i64 %76
  store i8 0, ptr %88, align 1, !tbaa !10
  br label %167

89:                                               ; preds = %39, %93
  %90 = phi i64 [ %91, %93 ], [ %26, %39 ]
  %91 = add nsw i64 %90, 1
  %92 = icmp slt i64 %91, %24
  br i1 %92, label %93, label %97

93:                                               ; preds = %89
  %94 = getelementptr inbounds i8, ptr %14, i64 %91
  %95 = load i8, ptr %94, align 1, !tbaa !10
  %96 = icmp eq i8 %95, 125
  br i1 %96, label %98, label %89, !llvm.loop !210

97:                                               ; preds = %89
  call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.25, ptr noundef nonnull @.str.226) #36
  unreachable

98:                                               ; preds = %93
  call void @llvm.lifetime.start.p0(ptr nonnull %5) #35
  %99 = sub i64 %90, %26
  %100 = call i64 @llvm.smin.i64(i64 %99, i64 127)
  %101 = getelementptr inbounds nuw i8, ptr %30, i64 1
  %102 = call ptr @__memcpy_chk(ptr noundef nonnull %5, ptr noundef nonnull %101, i64 noundef %100, i64 noundef 128) #35
  %103 = getelementptr inbounds i8, ptr %5, i64 %100
  store i8 0, ptr %103, align 1, !tbaa !10
  %104 = call ptr @strchr(ptr noundef nonnull dereferenceable(1) %5, i32 noundef 58) #35
  %105 = icmp eq ptr %104, null
  br i1 %105, label %108, label %106

106:                                              ; preds = %98
  %107 = getelementptr inbounds nuw i8, ptr %104, i64 1
  store i8 0, ptr %104, align 1, !tbaa !10
  br label %108

108:                                              ; preds = %98, %106
  %109 = phi ptr [ %107, %106 ], [ @.str.79, %98 ]
  %110 = call ptr @strchr(ptr noundef nonnull dereferenceable(1) %5, i32 noundef 33) #35
  %111 = icmp eq ptr %110, null
  br i1 %111, label %116, label %112

112:                                              ; preds = %108
  %113 = getelementptr inbounds nuw i8, ptr %110, i64 1
  %114 = load i8, ptr %113, align 1, !tbaa !10
  store i8 0, ptr %110, align 1, !tbaa !10
  %115 = sext i8 %114 to i32
  br label %116

116:                                              ; preds = %112, %108
  %117 = phi i32 [ %115, %112 ], [ 0, %108 ]
  %118 = load i8, ptr %5, align 1, !tbaa !10
  %119 = icmp eq i8 %118, 0
  br i1 %119, label %123, label %120

120:                                              ; preds = %116
  %121 = call i32 @atoi(ptr noundef nonnull %5)
  %122 = sext i32 %121 to i64
  br label %125

123:                                              ; preds = %116
  %124 = add nsw i64 %25, 1
  br label %125

125:                                              ; preds = %123, %120
  %126 = phi i64 [ %122, %120 ], [ %25, %123 ]
  %127 = phi i64 [ %25, %120 ], [ %124, %123 ]
  %128 = icmp slt i64 %126, %1
  br i1 %128, label %130, label %129

129:                                              ; preds = %125
  call void (ptr, ptr, ...) @thr(ptr noundef nonnull @.str.103, ptr noundef nonnull @.str.227, i64 noundef %126) #36
  unreachable

130:                                              ; preds = %125
  %131 = getelementptr inbounds i64, ptr %2, i64 %126
  %132 = load i64, ptr %131, align 8, !tbaa !11
  switch i32 %117, label %145 [
    i32 114, label %133
    i32 115, label %143
  ]

133:                                              ; preds = %130
  call void @llvm.lifetime.start.p0(ptr nonnull %4) #35
  store <2 x i64> <i64 0, i64 64>, ptr %15, align 8, !tbaa !11
  %134 = call dereferenceable_or_null(64) ptr @calloc(i64 noundef 1, i64 noundef 64) #33
  %135 = icmp eq ptr %134, null
  br i1 %135, label %136, label %139

136:                                              ; preds = %133
  %137 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %138 = call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %137)
  call void @exit(i32 noundef 1) #34
  unreachable

139:                                              ; preds = %133
  store ptr %134, ptr %4, align 8, !tbaa !61
  call fastcc void @to_sb(ptr noundef %4, i64 noundef %132, i32 noundef 1)
  %140 = load ptr, ptr %4, align 8, !tbaa !61
  %141 = load i64, ptr %15, align 8, !tbaa !63
  %142 = call fastcc i64 @mkstr(ptr noundef %140, i64 noundef %141)
  call void @llvm.lifetime.end.p0(ptr nonnull %4) #35
  br label %145

143:                                              ; preds = %130
  %144 = call i64 @rt_str(i64 noundef %132)
  br label %145

145:                                              ; preds = %130, %143, %139
  %146 = phi i64 [ %142, %139 ], [ %144, %143 ], [ %132, %130 ]
  %147 = call i64 @strlen(ptr noundef nonnull dereferenceable(1) %109) #35
  %148 = call fastcc i64 @mkstr(ptr noundef nonnull %109, i64 noundef %147)
  %149 = call i64 @rt_format(i64 noundef %146, i64 noundef %148)
  %150 = inttoptr i64 %149 to ptr
  %151 = getelementptr inbounds nuw i8, ptr %150, i64 16
  %152 = getelementptr inbounds nuw i8, ptr %150, i64 8
  %153 = load i64, ptr %152, align 8, !tbaa !18
  %154 = add nsw i64 %153, %28
  %155 = icmp slt i64 %154, %29
  br i1 %155, label %162, label %156

156:                                              ; preds = %145, %156
  %157 = phi i64 [ %158, %156 ], [ %29, %145 ]
  %158 = shl nsw i64 %157, 1
  %159 = icmp sgt i64 %158, %154
  br i1 %159, label %160, label %156, !llvm.loop !83

160:                                              ; preds = %156
  %161 = call ptr @realloc(ptr noundef %27, i64 noundef %158) #38
  br label %162

162:                                              ; preds = %145, %160
  %163 = phi i64 [ %158, %160 ], [ %29, %145 ]
  %164 = phi ptr [ %161, %160 ], [ %27, %145 ]
  %165 = getelementptr inbounds i8, ptr %164, i64 %28
  call void @llvm.memcpy.p0.p0.i64(ptr noundef align 1 %165, ptr noundef nonnull readonly align 1 %151, i64 noundef %153, i1 noundef false) #35
  %166 = getelementptr inbounds i8, ptr %164, i64 %154
  store i8 0, ptr %166, align 1, !tbaa !10
  call void @llvm.lifetime.end.p0(ptr nonnull %5) #35
  br label %167

167:                                              ; preds = %162, %84, %70, %49
  %168 = phi i64 [ %85, %84 ], [ %50, %49 ], [ %71, %70 ], [ %163, %162 ]
  %169 = phi i64 [ %76, %84 ], [ %41, %49 ], [ %62, %70 ], [ %154, %162 ]
  %170 = phi ptr [ %86, %84 ], [ %51, %49 ], [ %72, %70 ], [ %164, %162 ]
  %171 = phi i64 [ %26, %84 ], [ %33, %49 ], [ %55, %70 ], [ %91, %162 ]
  %172 = phi i64 [ %25, %84 ], [ %25, %49 ], [ %25, %70 ], [ %127, %162 ]
  %173 = add nsw i64 %171, 1
  %174 = load i64, ptr %10, align 8, !tbaa !18
  %175 = icmp slt i64 %173, %174
  br i1 %175, label %23, label %19, !llvm.loop !211
}

declare i32 @__toupper(i32 noundef) local_unnamed_addr #3

declare i32 @__tolower(i32 noundef) local_unnamed_addr #3

; Function Attrs: nounwind ssp uwtable(sync)
define internal fastcc i64 @file_readline(ptr noundef captures(none) %0) unnamed_addr #2 {
  %2 = tail call dereferenceable_or_null(64) ptr @calloc(i64 noundef 1, i64 noundef 64) #33
  %3 = icmp eq ptr %2, null
  br i1 %3, label %4, label %7

4:                                                ; preds = %1
  %5 = load ptr, ptr @__stderrp, align 8, !tbaa !13
  %6 = tail call i64 @fwrite(ptr nonnull @.str.106, i64 14, i64 1, ptr %5)
  tail call void @exit(i32 noundef 1) #34
  unreachable

7:                                                ; preds = %1, %23
  %8 = phi i64 [ %24, %23 ], [ 64, %1 ]
  %9 = phi i64 [ %15, %23 ], [ 0, %1 ]
  %10 = phi ptr [ %25, %23 ], [ %2, %1 ]
  %11 = tail call i32 @fgetc(ptr noundef %0)
  %12 = icmp eq i32 %11, -1
  br i1 %12, label %29, label %13

13:                                               ; preds = %7
  %14 = trunc i32 %11 to i8
  %15 = add nuw nsw i64 %9, 1
  %16 = icmp slt i64 %15, %8
  br i1 %16, label %23, label %17

17:                                               ; preds = %13, %17
  %18 = phi i64 [ %19, %17 ], [ %8, %13 ]
  %19 = shl nsw i64 %18, 1
  %20 = icmp sgt i64 %19, %15
  br i1 %20, label %21, label %17, !llvm.loop !83

21:                                               ; preds = %17
  %22 = tail call ptr @realloc(ptr noundef nonnull %10, i64 noundef %19) #38
  br label %23

23:                                               ; preds = %13, %21
  %24 = phi i64 [ %19, %21 ], [ %8, %13 ]
  %25 = phi ptr [ %22, %21 ], [ %10, %13 ]
  %26 = getelementptr inbounds nuw i8, ptr %25, i64 %9
  store i8 %14, ptr %26, align 1
  %27 = getelementptr inbounds nuw i8, ptr %25, i64 %15
  store i8 0, ptr %27, align 1, !tbaa !10
  %28 = icmp eq i32 %11, 10
  br i1 %28, label %29, label %7, !llvm.loop !212

29:                                               ; preds = %23, %7
  %30 = phi i64 [ %9, %7 ], [ %15, %23 ]
  %31 = phi ptr [ %10, %7 ], [ %25, %23 ]
  %32 = tail call fastcc i64 @mkstr(ptr noundef nonnull %31, i64 noundef %30)
  ret i64 %32
}

; Function Attrs: nofree nounwind
declare noundef i32 @fclose(ptr noundef captures(none)) local_unnamed_addr #6

; Function Attrs: nofree nounwind
declare noundef i64 @fread(ptr noundef writeonly captures(none), i64 noundef, i64 noundef, ptr noundef captures(none)) local_unnamed_addr #6

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.umax.i64(i64, i64) #27

; Function Attrs: nofree nounwind
declare noundef i64 @fwrite(ptr noundef readonly captures(none), i64 noundef, i64 noundef, ptr noundef captures(none)) local_unnamed_addr #28

; Function Attrs: nofree nounwind
declare noundef i32 @snprintf(ptr noalias noundef writeonly captures(none), i64 noundef, ptr noundef readonly captures(none), ...) local_unnamed_addr #28

; Function Attrs: nofree nounwind
declare noundef i32 @vsnprintf(ptr noundef captures(none), i64 noundef, ptr noundef readonly captures(none), ptr noundef) local_unnamed_addr #28

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.smax.i64(i64, i64) #27

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare range(i32 -1, 2) i32 @llvm.scmp.i32.i64(i64, i64) #27

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.abs.i64(i64, i1 immarg) #29

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #27

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #27

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.umin.i64(i64, i64) #27

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.smin.i64(i64, i64) #27

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #30

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i1 @llvm.is.fpclass.f64(double, i32 immarg) #27

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #31

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memmove.p0.p0.i64(ptr writeonly captures(none), ptr readonly captures(none), i64, i1 immarg) #32

attributes #0 = { nofree nounwind ssp uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { nounwind ssp uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #3 = { "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #4 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: read) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #5 = { noreturn nounwind ssp uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #6 = { nofree nounwind "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #7 = { nofree noreturn "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #8 = { noreturn "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #9 = { mustprogress nofree norecurse nosync nounwind ssp willreturn memory(readwrite, argmem: none, inaccessiblemem: none, target_mem0: none, target_mem1: none) uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #10 = { mustprogress nofree norecurse nosync nounwind ssp willreturn memory(read, argmem: none, inaccessiblemem: none, target_mem0: none, target_mem1: none) uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #11 = { nofree nosync nounwind ssp memory(read, inaccessiblemem: none, target_mem0: none, target_mem1: none) uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #12 = { nofree norecurse nosync nounwind ssp memory(read, inaccessiblemem: none, target_mem0: none, target_mem1: none) uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #13 = { mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) }
attributes #14 = { nocallback nofree nounwind memory(argmem: readwrite) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #15 = { mustprogress nofree norecurse nosync nounwind ssp willreturn memory(read, inaccessiblemem: none, target_mem0: none, target_mem1: none) uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #16 = { mustprogress nounwind ssp willreturn memory(readwrite, target_mem0: none, target_mem1: none) uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #17 = { nounwind ssp memory(readwrite, target_mem0: none, target_mem1: none) uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #18 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #19 = { mustprogress nofree norecurse nosync nounwind ssp willreturn memory(readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none) uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #20 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #21 = { mustprogress nocallback nofree nounwind willreturn "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #22 = { mustprogress nofree nounwind willreturn allockind("alloc,zeroed") allocsize(0,1) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #23 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #24 = { mustprogress nounwind willreturn allockind("realloc") allocsize(1) memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #25 = { mustprogress nocallback nofree nounwind willreturn memory(read) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #26 = { nofree norecurse nounwind ssp memory(argmem: read) uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #27 = { nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) }
attributes #28 = { nofree nounwind }
attributes #29 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #30 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #31 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }
attributes #32 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #33 = { allocsize(0,1) }
attributes #34 = { cold noreturn nounwind }
attributes #35 = { nounwind }
attributes #36 = { noreturn }
attributes #37 = { noreturn nounwind }
attributes #38 = { allocsize(1) }
attributes #39 = { "function-inline-cost-multiplier"="2" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}
!llvm.errno.tbaa = !{!6}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 15, i32 2]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 4}
!5 = !{!"Homebrew clang version 22.1.4"}
!6 = !{!7, !7, i64 0}
!7 = !{!"int", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = !{!8, !8, i64 0}
!11 = !{!12, !12, i64 0}
!12 = !{!"long long", !8, i64 0}
!13 = !{!14, !14, i64 0}
!14 = !{!"p1 _ZTS7__sFILE", !15, i64 0}
!15 = !{!"any pointer", !8, i64 0}
!16 = !{!17, !12, i64 0}
!17 = !{!"", !12, i64 0, !12, i64 8, !8, i64 16}
!18 = !{!17, !12, i64 8}
!19 = !{!20, !12, i64 0}
!20 = !{!"", !12, i64 0, !21, i64 8}
!21 = !{!"double", !8, i64 0}
!22 = !{!20, !21, i64 8}
!23 = !{!24, !12, i64 0}
!24 = !{!"", !12, i64 0}
!25 = !{!26, !12, i64 8}
!26 = !{!"", !12, i64 0, !12, i64 8}
!27 = !{!28, !12, i64 8}
!28 = !{!"", !12, i64 0, !12, i64 8, !12, i64 16, !29, i64 24}
!29 = !{!"p1 long long", !15, i64 0}
!30 = distinct !{!30, !31}
!31 = !{!"llvm.loop.mustprogress"}
!32 = !{!28, !29, i64 24}
!33 = !{!34, !12, i64 8}
!34 = !{!"", !12, i64 0, !12, i64 8, !12, i64 16, !12, i64 24, !15, i64 32, !12, i64 40, !29, i64 48}
!35 = !{!34, !12, i64 16}
!36 = !{!34, !15, i64 32}
!37 = !{!38, !12, i64 0}
!38 = !{!"", !12, i64 0, !12, i64 8, !12, i64 16}
!39 = !{!38, !12, i64 16}
!40 = !{!34, !12, i64 40}
!41 = !{!34, !29, i64 48}
!42 = !{!38, !12, i64 8}
!43 = distinct !{!43, !31}
!44 = !{!45, !12, i64 24}
!45 = !{!"", !12, i64 0, !12, i64 8, !12, i64 16, !12, i64 24}
!46 = !{!45, !12, i64 16}
!47 = !{!48, !12, i64 16}
!48 = !{!"", !12, i64 0, !15, i64 8, !12, i64 16, !12, i64 24, !29, i64 32, !12, i64 40}
!49 = !{!48, !12, i64 24}
!50 = !{!48, !12, i64 40}
!51 = !{!48, !29, i64 32}
!52 = distinct !{!52, !31, !53, !54}
!53 = !{!"llvm.loop.isvectorized", i32 1}
!54 = !{!"llvm.loop.unroll.runtime.disable"}
!55 = !{!48, !15, i64 8}
!56 = distinct !{!56, !31, !53}
!57 = !{!58, !15, i64 8}
!58 = !{!"", !12, i64 0, !15, i64 8, !59, i64 16}
!59 = !{!"p1 omnipotent char", !15, i64 0}
!60 = !{!45, !12, i64 8}
!61 = !{!62, !59, i64 0}
!62 = !{!"", !59, i64 0, !12, i64 8, !12, i64 16}
!63 = !{!62, !12, i64 8}
!64 = distinct !{!64, !31}
!65 = distinct !{!65, !31}
!66 = distinct !{!66, !31}
!67 = !{!59, !59, i64 0}
!68 = !{!34, !12, i64 0}
!69 = !{!28, !12, i64 0}
!70 = !{!28, !12, i64 16}
!71 = !{!34, !12, i64 24}
!72 = !{i64 0, i64 8, !11, i64 8, i64 8, !11, i64 16, i64 8, !11}
!73 = distinct !{!73, !74}
!74 = !{!"llvm.loop.unroll.disable"}
!75 = distinct !{!75, !31}
!76 = distinct !{!76, !31}
!77 = distinct !{!77, !31}
!78 = distinct !{!78, !31}
!79 = distinct !{!79, !31}
!80 = distinct !{!80, !31, !53, !54}
!81 = distinct !{!81, !31, !53}
!82 = !{!62, !12, i64 16}
!83 = distinct !{!83, !31}
!84 = distinct !{!84, !31}
!85 = distinct !{!85, !31}
!86 = distinct !{!86, !31}
!87 = !{!58, !59, i64 16}
!88 = distinct !{!88, !31}
!89 = distinct !{!89, !31}
!90 = distinct !{!90, !31}
!91 = distinct !{!91, !31}
!92 = distinct !{!92, !31}
!93 = distinct !{!93, !31}
!94 = distinct !{!94, !31}
!95 = distinct !{!95, !31}
!96 = distinct !{!96, !31}
!97 = distinct !{!97, !31}
!98 = distinct !{!98, !31}
!99 = distinct !{!99, !31}
!100 = distinct !{!100, !31}
!101 = distinct !{!101, !31}
!102 = distinct !{!102, !31}
!103 = distinct !{!103, !31}
!104 = !{!48, !12, i64 0}
!105 = !{!45, !12, i64 0}
!106 = distinct !{!106, !31}
!107 = distinct !{!107, !31}
!108 = distinct !{!108, !31}
!109 = distinct !{!109, !31, !53, !54}
!110 = distinct !{!110, !31, !53}
!111 = distinct !{!111, !31, !53}
!112 = distinct !{!112, !31, !53, !54}
!113 = distinct !{!113, !31, !53}
!114 = !{!26, !12, i64 0}
!115 = !{!58, !12, i64 0}
!116 = distinct !{!116, !31}
!117 = distinct !{!117, !31}
!118 = distinct !{!118, !31}
!119 = distinct !{!119, !31, !53, !54}
!120 = distinct !{!120, !31, !54, !53}
!121 = distinct !{!121, !31}
!122 = distinct !{!122, !31}
!123 = distinct !{!123, !31}
!124 = distinct !{!124, !31}
!125 = distinct !{!125, !31}
!126 = distinct !{!126, !31}
!127 = distinct !{!127, !31}
!128 = distinct !{!128, !31}
!129 = distinct !{!129, !31}
!130 = distinct !{!130, !31}
!131 = distinct !{!131, !31, !132}
!132 = !{!"llvm.loop.peeled.count", i32 1}
!133 = !{!134, !12, i64 0}
!134 = !{!"", !12, i64 0, !14, i64 8}
!135 = !{!134, !14, i64 8}
!136 = distinct !{!136, !31}
!137 = distinct !{!137, !31}
!138 = distinct !{!138, !31}
!139 = distinct !{!139, !31}
!140 = distinct !{!140, !31}
!141 = distinct !{!141, !31}
!142 = distinct !{!142, !31}
!143 = distinct !{!143, !31}
!144 = distinct !{!144, !31}
!145 = distinct !{!145, !31}
!146 = distinct !{!146, !31}
!147 = distinct !{!147, !31}
!148 = distinct !{!148, !31}
!149 = distinct !{!149, !31}
!150 = distinct !{!150, !31}
!151 = distinct !{!151, !31}
!152 = distinct !{!152, !31}
!153 = distinct !{!153, !31}
!154 = distinct !{!154, !31}
!155 = distinct !{!155, !31}
!156 = distinct !{!156, !31}
!157 = distinct !{!157, !31}
!158 = distinct !{!158, !31, !53, !54}
!159 = distinct !{!159, !31, !54, !53}
!160 = distinct !{!160, !31, !53, !54}
!161 = distinct !{!161, !31, !54, !53}
!162 = distinct !{!162, !31, !53, !54}
!163 = distinct !{!163, !31, !54, !53}
!164 = distinct !{!164, !31}
!165 = distinct !{!165, !31}
!166 = distinct !{!166, !31}
!167 = distinct !{!167, !31}
!168 = distinct !{!168, !31}
!169 = distinct !{!169, !31}
!170 = distinct !{!170, !31}
!171 = distinct !{!171, !31}
!172 = distinct !{!172, !31}
!173 = distinct !{!173, !31}
!174 = distinct !{!174, !31}
!175 = distinct !{!175, !31, !132}
!176 = distinct !{!176, !31}
!177 = distinct !{!177, !31}
!178 = distinct !{!178, !31}
!179 = distinct !{!179, !31}
!180 = distinct !{!180, !31}
!181 = distinct !{!181, !31}
!182 = distinct !{!182, !31}
!183 = distinct !{!183, !31}
!184 = distinct !{!184, !31}
!185 = distinct !{!185, !31}
!186 = distinct !{!186, !31}
!187 = distinct !{!187, !31}
!188 = distinct !{!188, !31}
!189 = distinct !{!189, !31}
!190 = distinct !{!190, !31}
!191 = distinct !{!191, !31}
!192 = distinct !{!192, !31}
!193 = distinct !{!193, !31}
!194 = distinct !{!194, !31}
!195 = distinct !{!195, !31}
!196 = !{!197, !59, i64 0}
!197 = !{!"", !59, i64 0, !15, i64 8}
!198 = distinct !{!198, !31}
!199 = !{!197, !15, i64 8}
!200 = distinct !{!200, !31}
!201 = distinct !{!201, !31}
!202 = distinct !{!202, !31}
!203 = distinct !{!203, !31}
!204 = distinct !{!204, !31}
!205 = distinct !{!205, !31, !53, !54}
!206 = distinct !{!206, !31}
!207 = distinct !{!207, !31, !53, !54}
!208 = distinct !{!208, !31, !53}
!209 = distinct !{!209, !31, !53}
!210 = distinct !{!210, !31}
!211 = distinct !{!211, !31}
!212 = distinct !{!212, !31}
