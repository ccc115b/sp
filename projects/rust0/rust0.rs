// ============================================================
// rust0 - a self-compiling miniature Rust compiler.
// The compiler is written in the small language it itself accepts.
// It emits LLVM IR (.ll text files).
//
// Boot chain:  rustc compiles this file into r0c (stage 0);
//   r0c compiles this file into stage1.ll; lli runs stage1.ll
//   (the same compiler, running as LLVM IR) which compiles this
//   file again into stage2.ll; the fixed point stage1 == stage2
//   proves the compiler accepts its own source.
// ============================================================

// runtime (rt.c) interface
extern "C" {
    fn r0_write(p: *const u8);
    fn r0_writeint(v: i64);
    fn r0_wch(c: i64);
    fn r0_wstrlit(p: *const u8, off: i64, l: i64);
    fn r0_strlen2(p: *const u8, off: i64, l: i64) -> i64;
    fn r0_print(p: *const u8);
    fn r0_printint(v: i64);
    fn r0_b(p: *const u8, i: i64) -> i64;
    fn r0_kw(p: *const u8, s: i64, l: i64, k: i64) -> i64;
    fn r0_mt(p: *const u8, s: i64, l: i64, k: i64) -> i64;
    fn r0_sp_eq(p: *const u8, a1: i64, l1: i64, a2: i64, l2: i64) -> i64;
    fn r0_parseint(p: *const u8, off: i64, l: i64) -> i64;
    fn r0_zf(p: *const u8, n: i64);
    fn r0_load(p: *const u8);
    fn r0_srcp() -> *const u8;
    fn r0_srclen() -> i64;
    fn r0_save(p: *const u8);
    fn r0_pc(m: *const u8, row: i64);
    fn r0_wchd(c: i64);
    fn r0_wchd2(c: i64);
    fn r0_panic(m: *const u8);
    fn r0_argc() -> i64;
    fn r0_arg(i: i64) -> *const u8;
}

const K_FN: i64 = 0;
const K_LET: i64 = 1;
const K_MUT: i64 = 2;
const K_RET: i64 = 3;
const K_IF: i64 = 4;
const K_ELSE: i64 = 5;
const K_WHILE: i64 = 6;
const K_FOR: i64 = 7;
const K_IN: i64 = 8;
const K_BRK: i64 = 9;
const K_CONT: i64 = 10;
const K_STRUCT: i64 = 11;
const K_CONST: i64 = 12;
const K_EX: i64 = 13;
const K_TRUE: i64 = 14;
const K_FALSE: i64 = 15;
const K_UNSAFE: i64 = 16;
const K_I64: i64 = 17;
const K_BOOL: i64 = 18;
const K_USIZE: i64 = 19;
const K_U8: i64 = 20;
const K_AS: i64 = 21;

const T_IDENT: i64 = 0;
const T_NUM: i64 = 1;
const T_PT: i64 = 2;
const T_KW: i64 = 3;
const T_STR: i64 = 4;

const Y_I64: i64 = 0;
const Y_BOOL: i64 = 1;
const Y_UNIT: i64 = 2;
const Y_PTR8: i64 = 3;
const Y_RI: i64 = 4;
const Y_RM: i64 = 5;
const Y_ARR: i64 = 6;
const Y_NAMED: i64 = 7;

const TI64: i64 = 0;
const TBOOL: i64 = 1;
const TUNIT: i64 = 2;
const TPTR8: i64 = 3;

const N_LET: i64 = 0;
const N_ASS: i64 = 1;
const N_CASS: i64 = 2;
const N_RET: i64 = 3;
const N_IF: i64 = 4;
const N_WHILE: i64 = 5;
const N_FOR: i64 = 6;
const N_BLK: i64 = 7;
const N_BRK: i64 = 8;
const N_CONT: i64 = 9;

const N_CALL: i64 = 16;
const N_ID: i64 = 17;
const N_NUMV: i64 = 18;
const N_BOOLV: i64 = 19;
const N_STRV: i64 = 20;
const N_BIN: i64 = 21;
const N_NOT: i64 = 22;
const N_NEG: i64 = 23;
const N_ADDR: i64 = 24;
const N_IDX: i64 = 25;
const N_FLD: i64 = 26;
const N_SLIT: i64 = 27;
const N_FPAIR: i64 = 28;
const N_ARR: i64 = 29;
const N_AS: i64 = 30;

const B_ADD: i64 = 0;
const B_SUB: i64 = 1;
const B_MUL: i64 = 2;
const B_DIV: i64 = 3;
const B_MOD: i64 = 4;
const B_EQ: i64 = 5;
const B_NE: i64 = 6;
const B_LT: i64 = 7;
const B_LE: i64 = 8;
const B_GT: i64 = 9;
const B_GE: i64 = 10;
const B_ANDD: i64 = 11;
const B_ORR: i64 = 12;
const B_ANDEQ: i64 = 13;
const B_OREQ: i64 = 14;
const B_XOREQ: i64 = 15;

struct Toks {
    k: [i64; 24000],
    v: [i64; 24000],
    st: [i64; 24000],
    sl: [i64; 24000],
    row: [i64; 24000],
    n: i64,
}

struct Nds {
    op: [i64; 24000],
    a: [i64; 24000],
    b: [i64; 24000],
    c: [i64; 24000],
    num: [i64; 24000],
    ty: [i64; 24000],
    nx: [i64; 24000],
    row: [i64; 24000],
    n: i64,
}

struct Tys {
    k: [i64; 256],
    a: [i64; 256],
    b: [i64; 256],
    n: i64,
}

struct Tyds {
    nm: [i64; 32],
    ln: [i64; 32],
    fst: [i64; 32],
    cnt: [i64; 32],
    tid: [i64; 32],
    n: i64,
}

struct Fldt {
    nm: [i64; 256],
    ln: [i64; 256],
    ty: [i64; 256],
    n: i64,
}

struct Fsig {
    nm: [i64; 160],
    ln: [i64; 160],
    ret: [i64; 160],
    pst: [i64; 160],
    np: [i64; 160],
    ext: [i64; 160],
    pfst: [i64; 160],
    bt: [i64; 160],
    vst: [i64; 160],
    vn: [i64; 160],
    n: i64,
}

struct Cst {
    nm: [i64; 160],
    ln: [i64; 160],
    ty: [i64; 160],
    val: [i64; 160],
    n: i64,
}

struct Vs {
    nm: [i64; 1024],
    ln: [i64; 1024],
    ty: [i64; 1024],
    fd: [i64; 1024],
    n: i64,
}

struct Cx {
    tmp: i64,
    lbl: i64,
    cur: i64,
    term: bool,
    dep: i64,
    brk: [i64; 32],
    cnt: [i64; 32],
    vk: i64,
    vv: i64,
    vt: i64,
    ak: [i64; 12],
    av: [i64; 12],
    at: [i64; 12],
    pk: i64,
    pv: i64,
    pt: i64,
    sp: [i64; 1024],
    sln: [i64; 1024],
    slz: [i64; 1024],
    ns: i64,
    wst: [i64; 2],
    wvl: [i64; 2],
    rtl: i64,
}

struct P {
    src: *const u8,
    slen: i64,
    pos: i64,
    row: i64,
    cur: i64,
    cfn: i64,
    tk: Toks,
    nd: Nds,
    tys: Tys,
    tyds: Tyds,
    flds: Fldt,
    fs: Fsig,
    cst: Cst,
    vs: Vs,
    cx: Cx,
}

// ------------------------------------------------------------------
// emit helpers
// ------------------------------------------------------------------

fn wch(c: i64) {
    unsafe {
        r0_wch(c);
    }
}

// safe wrappers over the runtime (all direct extern calls need unsafe)
fn rb(s: *const u8, i: i64) -> i64 {
    unsafe {
        return r0_b(s, i);
    }
}

fn rkw(s: *const u8, st: i64, ln: i64, k: i64) -> i64 {
    unsafe {
        return r0_kw(s, st, ln, k);
    }
}

fn rmt(s: *const u8, st: i64, ln: i64, k: i64) -> i64 {
    unsafe {
        return r0_mt(s, st, ln, k);
    }
}

fn req(s: *const u8, a1: i64, l1: i64, a2: i64, l2: i64) -> i64 {
    unsafe {
        return r0_sp_eq(s, a1, l1, a2, l2);
    }
}

fn rpi(s: *const u8, st: i64, ln: i64) -> i64 {
    unsafe {
        return r0_parseint(s, st, ln);
    }
}

fn rsl(s: *const u8, st: i64, ln: i64) -> i64 {
    unsafe {
        return r0_strlen2(s, st, ln);
    }
}

fn wstrlit(s: *const u8, off: i64, ln: i64) {
    unsafe {
        r0_wstrlit(s, off, ln);
    }
}

fn ws(p: &P, st: i64, ln: i64) {
    let mut j = 0;
    while j < ln {
        wch(rb(p.src, st + j));
        j += 1;
    }
}

fn w(s: *const u8) {
    unsafe {
        r0_write(s);
    }
}

fn wi(v: i64) {
    unsafe {
        r0_writeint(v);
    }
}

fn perr(p: &mut P, m: *const u8) {
    unsafe {
        r0_pc(m, p.tk.row[p.cur as usize]);
    }
}

// type text writer: prints the LLVM IR type name for a type id
fn wt(p: &P, ty: i64) {
    let k = p.tys.k[ty as usize];
    if k == Y_I64 {
        w("i64\0".as_ptr());
    } else if k == Y_BOOL {
        w("i1\0".as_ptr());
    } else if k == Y_UNIT {
        w("void\0".as_ptr());
    } else if k == Y_PTR8 {
        w("i8*\0".as_ptr());
    } else if k == Y_RI || k == Y_RM {
        wt(p, p.tys.a[ty as usize]);
        w("*\0".as_ptr());
    } else if k == Y_ARR {
        w("[\0".as_ptr());
        wi(p.tys.b[ty as usize]);
        w(" x \0".as_ptr());
        wt(p, p.tys.a[ty as usize]);
        w("]\0".as_ptr());
    } else {
        // named struct type
        w("%struct.\0".as_ptr());
        let ti = p.tys.a[ty as usize];
        ws(p, p.tyds.nm[ti as usize], p.tyds.ln[ti as usize]);
    }
}

// ------------------------------------------------------------------
// token helpers
// ------------------------------------------------------------------

fn tk(p: &P) -> i64 {
    return p.tk.k[p.cur as usize];
}

fn tv(p: &P) -> i64 {
    return p.tk.v[p.cur as usize];
}

fn tst(p: &P) -> i64 {
    return p.tk.st[p.cur as usize];
}

fn tsln(p: &P) -> i64 {
    return p.tk.sl[p.cur as usize];
}

fn adv(p: &mut P) {
    p.cur += 1;
}

// ------------------------------------------------------------------
// lexer
// ------------------------------------------------------------------

fn is_alpha(c: i64) -> bool {
    if c >= 97 && c <= 122 {
        return true;
    }
    if c >= 65 && c <= 90 {
        return true;
    }
    if c == 95 {
        return true;
    }
    return false;
}

fn is_digit(c: i64) -> bool {
    return c >= 48 && c <= 57;
}

fn is_idchar(c: i64) -> bool {
    return is_alpha(c) || is_digit(c);
}

fn lex(p: &mut P) {
    let n = p.slen;
    p.tk.n = 0;
    p.pos = 0;
    p.row = 1;
    while p.pos < n {
        let mut c = rb(p.src, p.pos);
        if c == 10 {
            p.row += 1;
            p.pos += 1;
            continue;
        }
        if c == 32 || c == 9 || c == 13 {
            p.pos += 1;
            continue;
        }
        if c == 47 && rb(p.src, p.pos + 1) == 47 {
            while p.pos < n && c != 10 {
                p.pos += 1;
                c = rb(p.src, p.pos);
            }
            continue;
        }
        if c == 47 && rb(p.src, p.pos + 1) == 42 {
            p.pos += 2;
            while p.pos < n && !(rb(p.src, p.pos) == 42 && rb(p.src, p.pos + 1) == 47) {
                if rb(p.src, p.pos) == 10 {
                    p.row += 1;
                }
                p.pos += 1;
            }
            p.pos += 2;
            continue;
        }
        if p.tk.n >= 24000 {
            unsafe {
                r0_panic("rust0 error: out of tokens\n\0".as_ptr());
            }
        }
        let i = p.tk.n;
        let st = p.pos;
        let row0 = p.row;
        if is_alpha(c) {
            while p.pos < n && is_idchar(rb(p.src, p.pos)) {
                p.pos += 1;
            }
            let ln = p.pos - st;
            let mut kind = T_IDENT;
            let mut v = 0;
            let mut kid = 0;
            while kid < 22 {
                if rkw(p.src, st, ln, kid) == 1 {
                    kind = T_KW;
                    v = kid;
                    break;
                }
                kid += 1;
            }
            p.tk.k[i as usize] = kind;
            p.tk.v[i as usize] = v;
            p.tk.st[i as usize] = st;
            p.tk.sl[i as usize] = ln;
            p.tk.row[i as usize] = row0;
            p.tk.n += 1;
            continue;
        }
        if is_digit(c) {
            while p.pos < n && is_digit(rb(p.src, p.pos)) {
                p.pos += 1;
            }
            let ln = p.pos - st;
            p.tk.k[i as usize] = T_NUM;
            p.tk.v[i as usize] = rpi(p.src, st, ln);
            p.tk.st[i as usize] = st;
            p.tk.sl[i as usize] = ln;
            p.tk.row[i as usize] = row0;
            p.tk.n += 1;
            continue;
        }
        if c == 34 {
            p.pos += 1;
            while p.pos < n {
                let c2 = rb(p.src, p.pos);
                if c2 == 92 {
                    p.pos += 2;
                    continue;
                }
                if c2 == 34 {
                    break;
                }
                p.pos += 1;
            }
            let ln = p.pos - st - 1;
            p.tk.k[i as usize] = T_STR;
            p.tk.v[i as usize] = 0;
            p.tk.st[i as usize] = st + 1;
            p.tk.sl[i as usize] = ln;
            p.tk.row[i as usize] = row0;
            p.tk.n += 1;
            p.pos += 1;
            continue;
        }
        p.tk.k[i as usize] = T_PT;
        p.tk.v[i as usize] = c;
        p.tk.st[i as usize] = st;
        p.tk.sl[i as usize] = 1;
        p.tk.row[i as usize] = row0;
        p.tk.n += 1;
        p.pos += 1;
    }
}

// ------------------------------------------------------------------
// small node constructors
// ------------------------------------------------------------------

fn nn(p: &mut P, op: i64, a: i64, b: i64, c: i64, num: i64, ty: i64, row: i64) -> i64 {
    let n = p.nd.n;
    if n >= 23990 {
        unsafe {
            r0_panic("rust0 error: out of nodes\n\0".as_ptr());
        }
    }
    p.nd.n += 1;
    p.nd.op[n as usize] = op;
    p.nd.a[n as usize] = a;
    p.nd.b[n as usize] = b;
    p.nd.c[n as usize] = c;
    p.nd.num[n as usize] = num;
    p.nd.ty[n as usize] = ty;
    p.nd.nx[n as usize] = 0;
    p.nd.row[n as usize] = row;
    return n;
}

// ------------------------------------------------------------------
// type parsing / interning
// ------------------------------------------------------------------

fn ty_intern(p: &mut P, k: i64, a: i64, b: i64) -> i64 {
    if k < 4 {
        return k;
    }
    let mut i = 0;
    while i < p.tys.n {
        if p.tys.k[i as usize] == k && p.tys.a[i as usize] == a && p.tys.b[i as usize] == b {
            return i;
        }
        i += 1;
    }
    let n = p.tys.n;
    p.tys.n += 1;
    p.tys.k[n as usize] = k;
    p.tys.a[n as usize] = a;
    p.tys.b[n as usize] = b;
    return n;
}

fn ty_named_by_name(p: &mut P, st: i64, ln: i64) -> i64 {
    let mut i = 0;
    while i < p.tyds.n {
        if req(p.src, st, ln, p.tyds.nm[i as usize], p.tyds.ln[i as usize]) == 1 {
            return p.tyds.tid[i as usize];
        }
        i += 1;
    }
    return -1;
}

fn eat(p: &mut P, kw: i64) -> bool {
    if tk(p) == T_KW && tv(p) == kw {
        adv(p);
        return true;
    }
    return false;
}

fn eatpt(p: &mut P, c: i64) -> bool {
    if tk(p) == T_PT && tv(p) == c {
        adv(p);
        return true;
    }
    return false;
}

fn expectpt(p: &mut P, c: i64, m: *const u8) {
    if !eatpt(p, c) {
        perr(p, m);
    }
}

// ------------------------------------------------------------------
// type parser (interns into p.tys)
// ------------------------------------------------------------------

fn parse_type(p: &mut P) -> i64 {
    if tk(p) == T_KW {
        let k = tv(p);
        if k == K_I64 || k == K_USIZE {
            adv(p);
            return TI64;
        }
        if k == K_BOOL {
            adv(p);
            return TBOOL;
        }
        perr(p, "expected type\0".as_ptr());
    }
    if tk(p) == T_PT && tv(p) == 42 {
        adv(p);
        if !eat(p, K_CONST) {
            perr(p, "only *const u8 supported\0".as_ptr());
        }
        if tk(p) != T_KW || tv(p) != K_U8 {
            perr(p, "expected u8\0".as_ptr());
        }
        adv(p);
        return TPTR8;
    }
    if tk(p) == T_PT && tv(p) == 38 {
        adv(p);
        let mutflag = eat(p, K_MUT);
        let inner = parse_type(p);
        if mutflag {
            return ty_intern(p, Y_RM, inner, 0);
        }
        return ty_intern(p, Y_RI, inner, 0);
    }
    if tk(p) == T_PT && tv(p) == 91 {
        adv(p);
        let elem = parse_type(p);
        expectpt(p, 59, "expected ; in array type\0".as_ptr());
        if tk(p) != T_NUM {
            perr(p, "expected array size\0".as_ptr());
        }
        let n = tv(p);
        adv(p);
        expectpt(p, 93, "expected ] in array type\0".as_ptr());
        return ty_intern(p, Y_ARR, elem, n);
    }
    if tk(p) == T_IDENT {
        let st = tst(p);
        let ln = tsln(p);
        adv(p);
        let t = ty_named_by_name(p, st, ln);
        if t < 0 {
            perr(p, "unknown type name\0".as_ptr());
        }
        return t;
    }
    perr(p, "expected type\0".as_ptr());
    return 0;
}

// ------------------------------------------------------------------
// pass 1: collect top-level items (struct / const / fn / extern)
// ------------------------------------------------------------------

fn getident(p: &mut P, m: *const u8) {
    if tk(p) != T_IDENT {
        perr(p, m);
    }
    p.cx.wst[0] = tst(p);
    p.cx.wvl[0] = tsln(p);
    adv(p);
}

fn push_var(p: &mut P, ty: i64) -> i64 {
    let n = p.vs.n;
    unsafe {
        r0_wchd(80);
        r0_wchd2(n);
        r0_wchd(47);
        r0_wchd2(p.cfn);
        r0_wchd(44);
        r0_wchd2(ty);
        r0_wchd(10);
    }
    p.vs.n += 1;
    p.vs.nm[n as usize] = 0;
    p.vs.ln[n as usize] = 0;
    p.vs.ty[n as usize] = ty;
    p.vs.fd[n as usize] = p.cfn;
    p.fs.vn[p.cfn as usize] = n + 1;
    return n;
}

fn parse_struct_item(p: &mut P) {
    adv(p);
    getident(p, "struct name\0".as_ptr());
    let nst = p.cx.wst[0];
    let nln = p.cx.wvl[0];
    expectpt(p, 123, "expected { after struct name\0".as_ptr());
    let fst = p.flds.n;
    while !eatpt(p, 125) {
        getident(p, "field name\0".as_ptr());
        let fst2 = p.cx.wst[0];
        let fln2 = p.cx.wvl[0];
        expectpt(p, 58, "expected : after field name\0".as_ptr());
        let t = parse_type(p);
        if p.flds.n >= 255 {
            unsafe {
                r0_panic("rust0 error: out of fields\n\0".as_ptr());
            }
        }
        let fi2 = p.flds.n;
        p.flds.n += 1;
        p.flds.nm[fi2 as usize] = fst2;
        p.flds.ln[fi2 as usize] = fln2;
        p.flds.ty[fi2 as usize] = t;
        if eatpt(p, 44) {
            continue;
        }
        if !eatpt(p, 125) {
            perr(p, "expected , or }\0".as_ptr());
        }
        break;
    }
    let ti2 = p.tyds.n;
    p.tyds.n += 1;
    p.tyds.nm[ti2 as usize] = nst;
    p.tyds.ln[ti2 as usize] = nln;
    p.tyds.fst[ti2 as usize] = fst;
    p.tyds.cnt[ti2 as usize] = p.flds.n - fst;
    p.tyds.tid[ti2 as usize] = ty_intern(p, Y_NAMED, ti2, 0);
    w("  %struct.\0".as_ptr());
    ws(p, nst, nln);
    w(" = type { \0".as_ptr());
    let mut j = 0;
    while j < p.tyds.cnt[ti2 as usize] {
        wt(p, p.flds.ty[(fst + j) as usize]);
        if j + 1 < p.tyds.cnt[ti2 as usize] {
            w(", \0".as_ptr());
        }
        j += 1;
    }
    w(" }\n\0".as_ptr());
}

fn parse_const_item(p: &mut P) {
    adv(p);
    getident(p, "const name\0".as_ptr());
    let nst = p.cx.wst[0];
    let nln = p.cx.wvl[0];
    expectpt(p, 58, "expected : after const name\0".as_ptr());
    let t = parse_type(p);
    expectpt(p, 61, "expected = in const\0".as_ptr());
    let mut v = 0;
    if tk(p) == T_NUM {
        v = tv(p);
        adv(p);
    } else if tk(p) == T_KW && tv(p) == K_TRUE {
        v = 1;
        adv(p);
    } else if tk(p) == T_KW && tv(p) == K_FALSE {
        v = 0;
        adv(p);
    } else {
        perr(p, "const must be literal\0".as_ptr());
    }
    expectpt(p, 59, "expected ; after const\0".as_ptr());
    let c2 = p.cst.n;
    p.cst.n += 1;
    p.cst.nm[c2 as usize] = nst;
    p.cst.ln[c2 as usize] = nln;
    p.cst.ty[c2 as usize] = t;
    p.cst.val[c2 as usize] = v;
}

fn parse_sig(p: &mut P, ext: i64) -> i64 {
    if !eat(p, K_FN) {
        perr(p, "expected fn\0".as_ptr());
    }
    getident(p, "fn name\0".as_ptr());
    let nst = p.cx.wst[0];
    let nln = p.cx.wvl[0];
    expectpt(p, 40, "expected(\0".as_ptr());
    let pst = p.vs.n;
    let pfst = p.flds.n;
    let mut np = 0;
    while !eatpt(p, 41) {
        eat(p, K_MUT);
        getident(p, "param name\0".as_ptr());
        let pst2 = p.cx.wst[0];
        let pnl2 = p.cx.wvl[0];
        expectpt(p, 58, "expected : after param\0".as_ptr());
        let t = parse_type(p);
        if ext == 0 {
            let vi3 = p.vs.n;
            p.vs.n += 1;
            p.vs.nm[vi3 as usize] = pst2;
            p.vs.ln[vi3 as usize] = pnl2;
            p.vs.ty[vi3 as usize] = t;
        } else {
            let fi3 = p.flds.n;
            p.flds.n += 1;
            p.flds.nm[fi3 as usize] = 0;
            p.flds.ln[fi3 as usize] = 0;
            p.flds.ty[fi3 as usize] = t;
        }
        np += 1;
        if eatpt(p, 44) {
            continue;
        }
        if !eatpt(p, 41) {
            perr(p, "expected , or )\0".as_ptr());
        }
        break;
    }
    let mut ret = TUNIT;
    if eatpt(p, 45) {
        expectpt(p, 62, "expected > after ->\0".as_ptr());
        ret = parse_type(p);
    }
    if p.fs.n >= 155 {
        unsafe {
            r0_panic("rust0 error: out of fns\n\0".as_ptr());
        }
    }
    let fi = p.fs.n;
    p.fs.n += 1;
    p.fs.nm[fi as usize] = nst;
    p.fs.ln[fi as usize] = nln;
    p.fs.ret[fi as usize] = ret;
    p.fs.pst[fi as usize] = pst;
    p.fs.np[fi as usize] = np;
    p.fs.ext[fi as usize] = ext;
    p.fs.pfst[fi as usize] = pfst;
    if ext == 0 {
        let mut j = 0;
        while j < np {
            p.vs.fd[(pst + j) as usize] = fi;
            j += 1;
        }
    }
    if ext == 1 {
        w("declare \0".as_ptr());
        wt(p, ret);
        w(" @\0".as_ptr());
        ws(p, nst, nln);
        w("(\0".as_ptr());
        let mut j = 0;
        while j < np {
            if j > 0 {
                w(", \0".as_ptr());
            }
            wt(p, p.flds.ty[(pfst + j) as usize]);
            j += 1;
        }
        w(");\n\0".as_ptr());
    }
    return fi;
}

fn collect(p: &mut P) {
    while p.cur < p.tk.n {
        while eatpt(p, 59) {}
        if p.cur >= p.tk.n {
            break;
        }
        if tk(p) == T_KW {
            let k = tv(p);
            if k == K_STRUCT {
                parse_struct_item(p);
                continue;
            }
            if k == K_CONST {
                parse_const_item(p);
                continue;
            }
            if k == K_FN {
                let fi = parse_sig(p, 0);
                expectpt(p, 123, "expected { after fn sig\0".as_ptr());
                p.fs.bt[fi as usize] = p.cur;
                p.fs.vst[fi as usize] = p.vs.n;
                p.fs.vn[fi as usize] = p.vs.n;
                p.cfn = fi;
                let mut depth = 1;
                while p.cur < p.tk.n && depth > 0 {
                    if tk(p) == T_PT && tv(p) == 123 {
                        depth += 1;
                        adv(p);
                        continue;
                    }
                    if tk(p) == T_PT && tv(p) == 125 {
                        depth -= 1;
                        adv(p);
                        continue;
                    }
                    adv(p);
                }
                continue;
            }
            if k == K_EX {
                adv(p);
                if tk(p) != T_STR {
                    perr(p, "expected \"C\"\0".as_ptr());
                }
                let cst = tst(p);
                let csl = tsln(p);
                if csl != 1 || rb(p.src, cst) != 67 {
                    perr(p, "expected \"C\"\0".as_ptr());
                }
                adv(p);
                expectpt(p, 123, "expected { after extern\0".as_ptr());
                while !eatpt(p, 125) {
                    while eatpt(p, 59) {}
                    if eatpt(p, 125) {
                        break;
                    }
                    let _efi = parse_sig(p, 1);
                    if eatpt(p, 59) {
                        continue;
                    }
                }
                if eatpt(p, 59) {}
                continue;
            }
            perr(p, "expected item\0".as_ptr());
        }
        perr(p, "expected item\0".as_ptr());
    }
}

// ------------------------------------------------------------------
// lookups
// ------------------------------------------------------------------

fn lookup_var(p: &P, lo: i64, st: i64, ln: i64) -> i64 {
    let mut i = p.vs.n;
    while i > 0 {
        i -= 1;
        if p.vs.fd[i as usize] == p.cfn && p.vs.fd[i as usize] >= 0 {
            if req(p.src, st, ln, p.vs.nm[i as usize], p.vs.ln[i as usize]) == 1 {
                return i;
            }
        }
    }
    return -1;
}

fn lookup_fn(p: &P, st: i64, ln: i64) -> i64 {
    let mut i = p.fs.n;
    while i > 0 {
        i -= 1;
        if req(p.src, st, ln, p.fs.nm[i as usize], p.fs.ln[i as usize]) == 1 {
            return i;
        }
    }
    return -1;
}

fn lookup_cst(p: &P, st: i64, ln: i64) -> i64 {
    let mut i = p.cst.n;
    while i > 0 {
        i -= 1;
        if req(p.src, st, ln, p.cst.nm[i as usize], p.cst.ln[i as usize]) == 1 {
            return i;
        }
    }
    return -1;
}

// ------------------------------------------------------------------
// pass 2: statement + expression parser (types computed inline)
// ------------------------------------------------------------------

fn tk2(p: &P) -> i64 {
    return p.tk.k[(p.cur + 1) as usize];
}

fn tv2(p: &P) -> i64 {
    return p.tk.v[(p.cur + 1) as usize];
}

fn struct_field_idx(p: &P, tyd: i64, st: i64, ln: i64) -> i64 {
    let fst = p.tyds.fst[tyd as usize];
    let cnt = p.tyds.cnt[tyd as usize];
    let mut i = 0;
    while i < cnt {
        if req(p.src, st, ln, p.flds.nm[(fst + i) as usize], p.flds.ln[(fst + i) as usize]) == 1 {
            return i;
        }
        i += 1;
    }
    return -1;
}

fn is_ref(k: i64) -> bool {
    return k == Y_RI || k == Y_RM;
}

// build a binary node with type checking
fn mkb(p: &mut P, num: i64, a: i64, b: i64, row: i64) -> i64 {
    let ta = p.nd.ty[a as usize];
    let tb = p.nd.ty[b as usize];
    let mut ty = TI64;
    if num <= B_MOD {
        if ta != TI64 || tb != TI64 {
            perr(p, "arithmetic needs i64\0".as_ptr());
        }
        ty = TI64;
    } else if num <= B_GE {
        if ta != TI64 || tb != TI64 {
            perr(p, "comparison needs i64\0".as_ptr());
        }
        ty = TBOOL;
    } else {
        if ta != TBOOL || tb != TBOOL {
            perr(p, "logic needs bool\0".as_ptr());
        }
        ty = TBOOL;
    }
    return nn(p, N_BIN, a, b, 0, num, ty, row);
}

fn parse_stmts(p: &mut P) -> i64 {
    let mut head = 0;
    let mut tail = 0;
    while !(tk(p) == T_PT && tv(p) == 125) {
        if p.cur >= p.tk.n {
            perr(p, "unexpected end of file\0".as_ptr());
        }
        let s = parse_stmt(p);
        if head == 0 {
            head = s;
        } else {
            p.nd.nx[tail as usize] = s;
        }
        tail = s;
    }
    return head;
}

fn parse_block(p: &mut P) -> i64 {
    expectpt(p, 123, "expected {\0".as_ptr());
    let base = p.vs.n;
    let head = parse_stmts(p);
    expectpt(p, 125, "expected }\0".as_ptr());
    p.vs.n = base;
    return head;
}

fn parse_if(p: &mut P) -> i64 {
    let row = p.tk.row[p.cur as usize];
    adv(p);
    let c = e_or(p);
    if p.nd.ty[c as usize] != TBOOL {
        perr(p, "if condition must be bool\0".as_ptr());
    }
    let body = parse_block(p);
    let mut els = 0;
    if eat(p, K_ELSE) {
        if tk(p) == T_KW && tv(p) == K_IF {
            els = parse_if(p);
        } else {
            els = parse_block(p);
        }
    }
    return nn(p, N_IF, body, c, els, 0, TUNIT, row);
}

fn parse_let(p: &mut P) -> i64 {
    let row = p.tk.row[p.cur as usize];
    adv(p);
    eat(p, K_MUT);
    getident(p, "let name\0".as_ptr());
    let nst = p.cx.wst[0];
    let nln = p.cx.wvl[0];
    let mut ty = -1;
    if eatpt(p, 58) {
        ty = parse_type(p);
    }
    let mut init = 0;
    if eatpt(p, 61) {
        init = e_or(p);
        let ity = p.nd.ty[init as usize];
        if p.nd.op[init as usize] == N_STRV {
            perr(p, "str literal only as call argument\0".as_ptr());
        }
        if ty >= 0 && ty != ity {
            perr(p, "let type mismatch\0".as_ptr());
        }
        ty = ity;
    }
    if ty < 0 {
        perr(p, "let needs type or init\0".as_ptr());
    }
    expectpt(p, 59, "expected ; after let\0".as_ptr());
    let v = push_var(p, ty);
    p.vs.nm[v as usize] = nst;
    p.vs.ln[v as usize] = nln;
    return nn(p, N_LET, v, init, 0, 0, ty, row);
}

fn parse_stmt(p: &mut P) -> i64 {
    let row = p.tk.row[p.cur as usize];
    if tk(p) == T_KW {
        let k = tv(p);
        if k == K_LET {
            return parse_let(p);
        }
        if k == K_IF {
            return parse_if(p);
        }
        if k == K_WHILE {
            adv(p);
            let c = e_or(p);
            if p.nd.ty[c as usize] != TBOOL {
                perr(p, "while condition must be bool\0".as_ptr());
            }
            let body = parse_block(p);
            return nn(p, N_WHILE, body, c, 0, 0, TUNIT, row);
        }
        if k == K_FOR {
            adv(p);
            getident(p, "loop var\0".as_ptr());
            let nst = p.cx.wst[0];
            let nln = p.cx.wvl[0];
            if !eat(p, K_IN) {
                perr(p, "expected in\0".as_ptr());
            }
            let lo = e_or(p);
            expectpt(p, 46, "expected ..\0".as_ptr());
            expectpt(p, 46, "expected ..\0".as_ptr());
            let hi = e_or(p);
            if p.nd.ty[lo as usize] != TI64 || p.nd.ty[hi as usize] != TI64 {
                perr(p, "for range must be i64\0".as_ptr());
            }
            let v = push_var(p, TI64);
            p.vs.nm[v as usize] = nst;
            p.vs.ln[v as usize] = nln;
            let body = parse_block(p);
            return nn(p, N_FOR, v, lo, hi, body, TUNIT, row);
        }
        if k == K_RET {
            adv(p);
            if eatpt(p, 59) {
                return nn(p, N_RET, 0, 0, 0, 0, TUNIT, row);
            }
            let e = e_or(p);
            expectpt(p, 59, "expected ; after return\0".as_ptr());
            return nn(p, N_RET, e, 0, 0, 0, TUNIT, row);
        }
        if k == K_BRK {
            adv(p);
            expectpt(p, 59, "expected ;\0".as_ptr());
            return nn(p, N_BRK, 0, 0, 0, 0, TUNIT, row);
        }
        if k == K_CONT {
            adv(p);
            expectpt(p, 59, "expected ;\0".as_ptr());
            return nn(p, N_CONT, 0, 0, 0, 0, TUNIT, row);
        }
        if k == K_UNSAFE {
            adv(p);
            let body = parse_block(p);
            return nn(p, N_BLK, body, 0, 0, 0, TUNIT, row);
        }
    }
    if tk(p) == T_PT && tv(p) == 123 {
        let body = parse_block(p);
        return nn(p, N_BLK, body, 0, 0, 0, TUNIT, row);
    }
    // expression / assignment statement
    let lhs = e_or(p);
    if tk(p) == T_PT && tv(p) == 61 && tv2(p) != 61 {
        adv(p);
        let rhs = e_or(p);
        expectpt(p, 59, "expected ;\0".as_ptr());
        if p.nd.ty[rhs as usize] != p.nd.ty[lhs as usize] {
            perr(p, "assignment type mismatch\0".as_ptr());
        }
        return nn(p, N_ASS, lhs, rhs, 0, 0, TUNIT, row);
    }
    if tk(p) == T_PT && tv2(p) == 61 {
        let c = tv(p);
        let mut num = -1;
        if c == 43 {
            num = B_ADD;
        } else if c == 45 {
            num = B_SUB;
        } else if c == 42 {
            num = B_MUL;
        } else if c == 47 {
            num = B_DIV;
        } else if c == 37 {
            num = B_MOD;
        } else if c == 38 {
            num = B_ANDEQ;
        } else if c == 124 {
            num = B_OREQ;
        } else if c == 94 {
            num = B_XOREQ;
        }
        if num >= 0 {
            adv(p);
            adv(p);
            let rhs = e_or(p);
            expectpt(p, 59, "expected ;\0".as_ptr());
            return nn(p, N_CASS, lhs, rhs, 0, num, TUNIT, row);
        }
    }
    expectpt(p, 59, "expected ;\0".as_ptr());
    return lhs;
}

// ------------------------------------------------------------------
// expression parsing (precedence climbing)
// ------------------------------------------------------------------

fn e_or(p: &mut P) -> i64 {
    let mut lhs = e_and(p);
    while tk(p) == T_PT && tv(p) == 124 && tv2(p) == 124 {
        let row = p.tk.row[p.cur as usize];
        adv(p);
        adv(p);
        let rhs = e_and(p);
        lhs = mkb(p, B_ORR, lhs, rhs, row);
    }
    return lhs;
}

fn e_and(p: &mut P) -> i64 {
    let mut lhs = e_cmp(p);
    while tk(p) == T_PT && tv(p) == 38 && tv2(p) == 38 {
        let row = p.tk.row[p.cur as usize];
        adv(p);
        adv(p);
        let rhs = e_cmp(p);
        lhs = mkb(p, B_ANDD, lhs, rhs, row);
    }
    return lhs;
}

fn e_cmp(p: &mut P) -> i64 {
    let mut lhs = e_add(p);
    while tk(p) == T_PT {
        let v = tv(p);
        let row = p.tk.row[p.cur as usize];
        let mut num = -1;
        let mut twotok = false;
        if v == 61 && tv2(p) == 61 {
            num = B_EQ;
            twotok = true;
        } else if v == 33 && tv2(p) == 61 {
            num = B_NE;
            twotok = true;
        } else if v == 60 && tv2(p) == 61 {
            num = B_LE;
            twotok = true;
        } else if v == 60 {
            num = B_LT;
        } else if v == 62 && tv2(p) == 61 {
            num = B_GE;
            twotok = true;
        } else if v == 62 {
            num = B_GT;
        }
        if num < 0 {
            break;
        }
        adv(p);
        if twotok {
            adv(p);
        }
        let rhs = e_add(p);
        lhs = mkb(p, num, lhs, rhs, row);
    }
    return lhs;
}

fn e_add(p: &mut P) -> i64 {
    let mut lhs = e_mul(p);
    while tk(p) == T_PT && (tv(p) == 43 || tv(p) == 45) && tv2(p) != 61 {
        let row = p.tk.row[p.cur as usize];
        let mut num = B_ADD;
        if tv(p) == 45 {
            num = B_SUB;
        }
        adv(p);
        let rhs = e_mul(p);
        lhs = mkb(p, num, lhs, rhs, row);
    }
    return lhs;
}

fn e_cast(p: &mut P) -> i64 {
    let mut lhs = e_un(p);
    while tk(p) == T_KW && tv(p) == K_AS {
        let row = p.tk.row[p.cur as usize];
        adv(p);
        if tk(p) == T_KW && (tv(p) == K_I64 || tv(p) == K_USIZE) {
            adv(p);
        } else {
            perr(p, "only as i64 / as usize supported\0".as_ptr());
        }
        if p.nd.ty[lhs as usize] != TI64 {
            perr(p, "cast operand must be i64\0".as_ptr());
        }
        lhs = nn(p, N_AS, lhs, 0, 0, 0, TI64, row);
    }
    return lhs;
}

fn e_mul(p: &mut P) -> i64 {
    let mut lhs = e_cast(p);
    while tk(p) == T_PT && (tv(p) == 42 || tv(p) == 47 || tv(p) == 37) && tv2(p) != 61 {
        let row = p.tk.row[p.cur as usize];
        let mut num = B_MUL;
        if tv(p) == 47 {
            num = B_DIV;
        } else if tv(p) == 37 {
            num = B_MOD;
        }
        adv(p);
        let rhs = e_cast(p);
        lhs = mkb(p, num, lhs, rhs, row);
    }
    return lhs;
}

fn e_un(p: &mut P) -> i64 {
    if tk(p) == T_PT && tv(p) == 45 {
        let row = p.tk.row[p.cur as usize];
        adv(p);
        let a = e_un(p);
        if p.nd.ty[a as usize] != TI64 {
            perr(p, "unary - needs i64\0".as_ptr());
        }
        return nn(p, N_NEG, a, 0, 0, 0, TI64, row);
    }
    if tk(p) == T_PT && tv(p) == 33 {
        let row = p.tk.row[p.cur as usize];
        adv(p);
        let a = e_un(p);
        if p.nd.ty[a as usize] != TBOOL {
            perr(p, "unary ! needs bool\0".as_ptr());
        }
        return nn(p, N_NOT, a, 0, 0, 0, TBOOL, row);
    }
    if tk(p) == T_PT && tv(p) == 38 && tv2(p) != 38 {
        let row = p.tk.row[p.cur as usize];
        adv(p);
        let mutflag = eat(p, K_MUT);
        let a = e_post(p);
        let aty = p.nd.ty[a as usize];
        if p.nd.op[a as usize] != N_ID && p.nd.op[a as usize] != N_FLD && p.nd.op[a as usize] != N_IDX {
            perr(p, "& needs an lvalue\0".as_ptr());
        }
        let mut rty = 0;
        let mut mflag = 0;
        if mutflag {
            rty = ty_intern(p, Y_RM, aty, 0);
            mflag = 1;
        } else {
            rty = ty_intern(p, Y_RI, aty, 0);
        }
        return nn(p, N_ADDR, a, 0, 0, mflag, rty, row);
    }
    return e_post(p);
}

fn e_post(p: &mut P) -> i64 {
    let mut base = e_prim(p);
    while true {
        if tk(p) == T_PT && tv(p) == 46 {
            if tv2(p) == 46 {
                break; // range operator
            }
            let row = p.tk.row[p.cur as usize];
            adv(p);
            if tk(p) != T_IDENT {
                perr(p, "expected field name\0".as_ptr());
            }
            let fst = tst(p);
            let fln = tsln(p);
            adv(p);
            // "...\0".as_ptr() special method on string literals
            if p.nd.op[base as usize] == N_STRV && rmt(p.src, fst, fln, 0) == 1 {
                if !eatpt(p, 40) {
                    perr(p, "expected (\0".as_ptr());
                }
                expectpt(p, 41, "expected )\0".as_ptr());
                continue;
            }
            if eatpt(p, 40) {
                perr(p, "methods not supported\0".as_ptr());
            }
            // field access
            let bty = p.nd.ty[base as usize];
            let mut sty = bty;
            if is_ref(p.tys.k[sty as usize]) {
                sty = p.tys.a[sty as usize];
            }
            if p.tys.k[sty as usize] != Y_NAMED {
                perr(p, "field access on non-struct\0".as_ptr());
            }
            let tyd = p.tys.a[sty as usize];
            let fi = struct_field_idx(p, tyd, fst, fln);
            if fi < 0 {
                perr(p, "unknown field\0".as_ptr());
            }
            let fty = p.flds.ty[(p.tyds.fst[tyd as usize] + fi) as usize];
            base = nn(p, N_FLD, base, 0, 0, fi, fty, row);
            continue;
        }
        if tk(p) == T_PT && tv(p) == 91 {
            let row = p.tk.row[p.cur as usize];
            adv(p);
            let ix = e_or(p);
            expectpt(p, 93, "expected ]\0".as_ptr());
            if p.nd.ty[ix as usize] != TI64 {
                perr(p, "index must be i64\0".as_ptr());
            }
            let bty = p.nd.ty[base as usize];
            let mut sty = bty;
            if is_ref(p.tys.k[sty as usize]) {
                sty = p.tys.a[sty as usize];
            }
            if p.tys.k[sty as usize] != Y_ARR {
                perr(p, "indexing non-array\0".as_ptr());
            }
            base = nn(p, N_IDX, base, ix, 0, 0, p.tys.a[sty as usize], row);
            continue;
        }
        break;
    }
    return base;
}

fn e_prim(p: &mut P) -> i64 {
    let row = p.tk.row[p.cur as usize];
    if tk(p) == T_NUM {
        let v = tv(p);
        adv(p);
        return nn(p, N_NUMV, 0, 0, 0, v, TI64, row);
    }
    if tk(p) == T_STR {
        let st = tst(p);
        let ln = tsln(p);
        adv(p);
        return nn(p, N_STRV, st, ln, 0, 0, TPTR8, row);
    }
    if tk(p) == T_KW && (tv(p) == K_TRUE || tv(p) == K_FALSE) {
        let mut v = 0;
        if tv(p) == K_TRUE {
            v = 1;
        }
        adv(p);
        return nn(p, N_BOOLV, 0, 0, 0, v, TBOOL, row);
    }
    if tk(p) == T_PT && tv(p) == 40 {
        adv(p);
        let e = e_or(p);
        expectpt(p, 41, "expected )\0".as_ptr());
        return e;
    }
    if tk(p) == T_PT && tv(p) == 91 {
        adv(p);
        let e = e_or(p);
        expectpt(p, 59, "expected ; in array literal\0".as_ptr());
        if tk(p) != T_NUM {
            perr(p, "expected array size\0".as_ptr());
        }
        let cnt = tv(p);
        adv(p);
        expectpt(p, 93, "expected ]\0".as_ptr());
        let eop = p.nd.op[e as usize];
        if eop != N_NUMV && eop != N_BOOLV {
            perr(p, "array literal element must be a constant\0".as_ptr());
        }
        let ety = p.nd.ty[e as usize];
        let aty = ty_intern(p, Y_ARR, ety, cnt);
        return nn(p, N_ARR, e, 0, 0, cnt, aty, row);
    }
    if tk(p) == T_IDENT {
        let st = tst(p);
        let ln = tsln(p);
        adv(p);
        if tk(p) == T_PT && tv(p) == 40 {
            return parse_call(p, st, ln, row);
        }
        if tk(p) == T_PT && tv(p) == 123 && ty_named_by_name(p, st, ln) >= 0 {
            return parse_slit(p, st, ln, row);
        }
        let v = lookup_var(p, 0, st, ln);
        if v >= 0 {
            return nn(p, N_ID, v, 0, 0, 0, p.vs.ty[v as usize], row);
        }
        let c = lookup_cst(p, st, ln);
        if c >= 0 {
            return nn(p, N_NUMV, 0, 0, 0, p.cst.val[c as usize], p.cst.ty[c as usize], row);
        }
        perr(p, "unknown identifier\0".as_ptr());
    }
    perr(p, "expected expression\0".as_ptr());
    return 0;
}

fn parse_call(p: &mut P, st: i64, ln: i64, row: i64) -> i64 {
    let fi = lookup_fn(p, st, ln);
    if fi < 0 {
        perr(p, "unknown function\0".as_ptr());
    }
    adv(p); // (
    let np = p.fs.np[fi as usize];
    let mut first = 0;
    let mut tail = 0;
    let mut cnt = 0;
    while !eatpt(p, 41) {
        if cnt >= np {
            perr(p, "too many arguments\0".as_ptr());
        }
        // expected param type
        let mut pt2 = TI64;
        if p.fs.ext[fi as usize] == 0 {
            pt2 = p.vs.ty[(p.fs.pst[fi as usize] + cnt) as usize];
        } else {
            pt2 = p.flds.ty[(p.fs.pfst[fi as usize] + cnt) as usize];
        }
        let a = e_or(p);
        let aty = p.nd.ty[a as usize];
        if !ref_ok(p, aty, pt2) {
            perr(p, "argument type mismatch\0".as_ptr());
        }
        if first == 0 {
            first = a;
        } else {
            p.nd.nx[tail as usize] = a;
        }
        tail = a;
        cnt += 1;
        if eatpt(p, 44) {
            continue;
        }
        if !eatpt(p, 41) {
            perr(p, "expected , or )\0".as_ptr());
        }
        break;
    }
    if cnt != np {
        perr(p, "wrong argument count\0".as_ptr());
    }
    return nn(p, N_CALL, fi, first, 0, 0, p.fs.ret[fi as usize], row);
}

fn parse_slit(p: &mut P, st: i64, ln: i64, row: i64) -> i64 {
    let mut i = 0;
    let mut found = -1;
    while i < p.tyds.n {
        if req(p.src, st, ln, p.tyds.nm[i as usize], p.tyds.ln[i as usize]) == 1 {
            found = i;
            break;
        }
        i += 1;
    }
    if found < 0 {
        perr(p, "unknown struct\0".as_ptr());
    }
    adv(p); // {
    let mut first = 0;
    let mut tail = 0;
    let mut cnt = 0;
    while !eatpt(p, 125) {
        if tk(p) != T_IDENT {
            perr(p, "expected field name\0".as_ptr());
        }
        let fst = tst(p);
        let fln = tsln(p);
        adv(p);
        expectpt(p, 58, "expected : after field\0".as_ptr());
        let fi = struct_field_idx(p, found, fst, fln);
        if fi < 0 {
            perr(p, "unknown field\0".as_ptr());
        }
        let e = e_or(p);
        if p.nd.ty[e as usize] != p.flds.ty[(p.tyds.fst[found as usize] + fi) as usize] {
            perr(p, "field type mismatch\0".as_ptr());
        }
        let n = nn(p, N_FPAIR, e, 0, 0, fi, 0, row);
        if first == 0 {
            first = n;
        } else {
            p.nd.nx[tail as usize] = n;
        }
        tail = n;
        cnt += 1;
        if eatpt(p, 44) {
            continue;
        }
        if !eatpt(p, 125) {
            perr(p, "expected , or }\0".as_ptr());
        }
        break;
    }
    if cnt != p.tyds.cnt[found as usize] {
        perr(p, "missing struct fields\0".as_ptr());
    }
    return nn(p, N_SLIT, found, first, 0, 0, p.tyds.tid[found as usize], row);
}



// ------------------------------------------------------------------

// ------------------------------------------------------------------
// code generation
// ------------------------------------------------------------------

fn nlbl(p: &mut P) -> i64 {
    let l = p.cx.lbl;
    p.cx.lbl += 1;
    return l;
}

fn ntmp(p: &mut P) -> i64 {
    let t = p.cx.tmp;
    p.cx.tmp += 1;
    return t;
}

// close current block (with fallthrough br if needed) and open label l
fn openblk(p: &mut P, l: i64) {
    if !p.cx.term {
        w("  br label %b\0".as_ptr());
        wi(l);
        w("\n\0".as_ptr());
    }
    w("b\0".as_ptr());
    wi(l);
    w(":\n\0".as_ptr());
    p.cx.cur = l;
    p.cx.term = false;
}

fn manual_br(p: &mut P, l: i64) {
    w("  br label %b\0".as_ptr());
    wi(l);
    w("\n\0".as_ptr());
    p.cx.term = true;
}

fn slotref(p: &P, v: i64) {
    w("%v\0".as_ptr());
    wi(v);
}

fn tempref(p: &P, t: i64) {
    w("%t\0".as_ptr());
    wi(t);
}

// write the text of a value state (k, v) given expected type ty
fn wv(p: &P, k: i64, v: i64, ty: i64) {
    if k == 0 {
        tempref(p, v);
    } else if k == 5 {
        slotref(p, v);
    } else if k == 2 || (k == 1 && ty == TBOOL) {
        if v == 1 {
            w("true\0".as_ptr());
        } else {
            w("false\0".as_ptr());
        }
    } else if k == 1 {
        wi(v);
    } else {
        w("<void>\0".as_ptr());
    }
}

fn register_str(p: &mut P, st: i64, ln: i64) -> i64 {
    let mut i = 0;
    while i < p.cx.ns {
        if p.cx.sp[i as usize] == st && p.cx.sln[i as usize] == ln {
            return i;
        }
        i += 1;
    }
    let n = p.cx.ns;
    p.cx.ns += 1;
    p.cx.sp[n as usize] = st;
    p.cx.sln[n as usize] = ln;
    p.cx.slz[n as usize] = rsl(p.src, st, ln) + 1;
    return n;
}

// store value state (k, v) of type ty into pointer state (pk, pv)
fn storeto(p: &mut P, k: i64, v: i64, ty: i64, pk: i64, pv: i64) {
    let mut k2 = k;
    let mut v2 = v;
    if k2 == 3 {
        let sid = v2;
        let t = ntmp(p);
        w("  %t\0".as_ptr());
        wi(t);
        w(" = getelementptr inbounds [\0".as_ptr());
        wi(p.cx.slz[sid as usize]);
        w(" x i8], [\0".as_ptr());
        wi(p.cx.slz[sid as usize]);
        w(" x i8]* @.s\0".as_ptr());
        wi(sid);
        w(", i64 0, i64 0\n\0".as_ptr());
        k2 = 0;
        v2 = t;
    }
    w("  store \0".as_ptr());
    wt(p, ty);
    w(" \0".as_ptr());
    wv(p, k2, v2, ty);
    w(", \0".as_ptr());
    wt(p, ty);
    w("* \0".as_ptr());
    if pk == 5 {
        slotref(p, pv);
    } else {
        tempref(p, pv);
    }
    w("\n\0".as_ptr());
}

// compute address of lvalue node; result state in cx.pk / cx.pv / cx.pt(type)
fn addr(p: &mut P, n: i64) {
    let op = p.nd.op[n as usize];
    if op == N_ID {
        let varid = p.nd.a[n as usize];
        let vty = p.vs.ty[varid as usize];
        if is_ref(p.tys.k[vty as usize]) {
            let t = ntmp(p);
            w("  %t\0".as_ptr());
            wi(t);
            w(" = load \0".as_ptr());
            wt(p, vty);
            w(", \0".as_ptr());
            wt(p, vty);
            w("* \0".as_ptr());
            slotref(p, varid);
            w("\n\0".as_ptr());
            p.cx.pk = 0;
            p.cx.pv = t;
            p.cx.pt = p.tys.a[vty as usize];
        } else {
            p.cx.pk = 5;
            p.cx.pv = varid;
            p.cx.pt = vty;
        }
        return;
    }
    if op == N_FLD {
        addr(p, p.nd.a[n as usize]);
        let sty = p.cx.pt;
        let tyd = p.tys.a[sty as usize];
        let fi = p.nd.num[n as usize];
        let fty = p.flds.ty[(p.tyds.fst[tyd as usize] + fi) as usize];
        let t = ntmp(p);
        w("  %t\0".as_ptr());
        wi(t);
        w(" = getelementptr inbounds \0".as_ptr());
        wt(p, sty);
        w(", \0".as_ptr());
        wt(p, sty);
        w("* \0".as_ptr());
        if p.cx.pk == 5 {
            slotref(p, p.cx.pv);
        } else {
            tempref(p, p.cx.pv);
        }
        w(", i64 0, i32 \0".as_ptr());
        wi(fi);
        w("\n\0".as_ptr());
        p.cx.pk = 0;
        p.cx.pv = t;
        p.cx.pt = fty;
        return;
    }
    if op == N_IDX {
        addr(p, p.nd.a[n as usize]);
        let arrty = p.cx.pt;
        let base = p.cx.pk;
        let basev = p.cx.pv;
        ev(p, p.nd.b[n as usize]);
        let ik = p.cx.vk;
        let iv = p.cx.vv;
        let t = ntmp(p);
        w("  %t\0".as_ptr());
        wi(t);
        w(" = getelementptr inbounds \0".as_ptr());
        wt(p, arrty);
        w(", \0".as_ptr());
        wt(p, arrty);
        w("* \0".as_ptr());
        if base == 5 {
            slotref(p, basev);
        } else {
            tempref(p, basev);
        }
        w(", i64 0, i64 \0".as_ptr());
        wv(p, ik, iv, TI64);
        w("\n\0".as_ptr());
        p.cx.pk = 0;
        p.cx.pv = t;
        p.cx.pt = p.tys.a[arrty as usize];
        return;
    }
    unsafe {
        r0_panic("rust0 error: not an lvalue\n\0".as_ptr());
    }
}

// evaluate expression node; result value state in cx.vk / cx.vv / cx.vt
fn ev(p: &mut P, n: i64) {
    let op = p.nd.op[n as usize];
    let ty = p.nd.ty[n as usize];
    if op == N_NUMV {
        p.cx.vk = 1;
        p.cx.vv = p.nd.num[n as usize];
        p.cx.vt = ty;
        return;
    }
    if op == N_BOOLV {
        p.cx.vk = 2;
        p.cx.vv = p.nd.num[n as usize];
        p.cx.vt = ty;
        return;
    }
    if op == N_STRV {
        p.cx.vk = 3;
        p.cx.vv = register_str(p, p.nd.a[n as usize], p.nd.b[n as usize]);
        p.cx.vt = ty;
        return;
    }
    if op == N_ID {
        let varid = p.nd.a[n as usize];
        let vty = p.vs.ty[varid as usize];
        let t = ntmp(p);
        w("  %t\0".as_ptr());
        wi(t);
        w(" = load \0".as_ptr());
        wt(p, vty);
        w(", \0".as_ptr());
        wt(p, vty);
        w("* \0".as_ptr());
        slotref(p, varid);
        w("\n\0".as_ptr());
        if is_ref(p.tys.k[vty as usize]) {
            p.cx.vt = p.tys.a[vty as usize];
        } else {
            p.cx.vt = vty;
        }
        p.cx.vk = 0;
        p.cx.vv = t;
        return;
    }
    if op == N_AS {
        ev(p, p.nd.a[n as usize]);
        p.cx.vt = ty;
        return;
    }
    if op == N_NEG {
        ev(p, p.nd.a[n as usize]);
        let lk = p.cx.vk;
        let lv = p.cx.vv;
        let t = ntmp(p);
        w("  %t\0".as_ptr());
        wi(t);
        w(" = sub i64 0, \0".as_ptr());
        wv(p, lk, lv, TI64);
        w("\n\0".as_ptr());
        p.cx.vk = 0;
        p.cx.vv = t;
        return;
    }
    if op == N_NOT {
        ev(p, p.nd.a[n as usize]);
        let lk = p.cx.vk;
        let lv = p.cx.vv;
        let t = ntmp(p);
        w("  %t\0".as_ptr());
        wi(t);
        w(" = xor i1 \0".as_ptr());
        wv(p, lk, lv, TBOOL);
        w(", true\n\0".as_ptr());
        p.cx.vk = 0;
        p.cx.vv = t;
        return;
    }
    if op == N_FLD || op == N_IDX {
        addr(p, n);
        let pk = p.cx.pk;
        let pv = p.cx.pv;
        let t = ntmp(p);
        w("  %t\0".as_ptr());
        wi(t);
        w(" = load \0".as_ptr());
        wt(p, ty);
        w(", \0".as_ptr());
        wt(p, ty);
        w("* \0".as_ptr());
        if pk == 5 {
            slotref(p, pv);
        } else {
            tempref(p, pv);
        }
        w("\n\0".as_ptr());
        p.cx.vk = 0;
        p.cx.vv = t;
        p.cx.vt = ty;
        return;
    }
    if op == N_ADDR {
        let a = p.nd.a[n as usize];
        if p.nd.op[a as usize] == N_ID && is_ref(p.tys.k[p.vs.ty[p.nd.a[a as usize] as usize] as usize]) {
            let varid = p.nd.a[a as usize];
            let vty = p.vs.ty[varid as usize];
            let t = ntmp(p);
            w("  %t\0".as_ptr());
            wi(t);
            w(" = load \0".as_ptr());
            wt(p, vty);
            w(", \0".as_ptr());
            wt(p, vty);
            w("* \0".as_ptr());
            slotref(p, varid);
            w("\n\0".as_ptr());
            p.cx.vk = 0;
            p.cx.vv = t;
            p.cx.vt = p.tys.a[vty as usize];
            return;
        }
        addr(p, a);
        p.cx.vk = p.cx.pk;
        p.cx.vv = p.cx.pv;
        p.cx.vt = ty;
        return;
    }
    if op == N_BIN {
        ev_bin(p, n);
        return;
    }
    if op == N_CALL {
        ev_call(p, n);
        return;
    }
    unsafe {
        r0_panic("rust0 error: cannot evaluate node\n\0".as_ptr());
    }
}

fn ev_bin(p: &mut P, n: i64) {
    let num = p.nd.num[n as usize];
    let a = p.nd.a[n as usize];
    let b = p.nd.b[n as usize];
    if num == B_ANDD || num == B_ORR {
        ev(p, a);
        let lk = p.cx.vk;
        let lv = p.cx.vv;
        if lk == 2 {
            // constant lhs: short circuit
            if num == B_ANDD && lv == 0 {
                p.cx.vk = 2;
                p.cx.vv = 0;
                return;
            }
            if num == B_ORR && lv == 1 {
                p.cx.vk = 2;
                p.cx.vv = 1;
                return;
            }
            ev(p, b);
            return;
        }
        let pre = p.cx.cur;
        let lr = nlbl(p);
        let lm = nlbl(p);
        w("  br i1 \0".as_ptr());
        wv(p, lk, lv, TBOOL);
        w(", label %b\0".as_ptr());
        wi(lr);
        w(", label %b\0".as_ptr());
        wi(lm);
        w("\n\0".as_ptr());
        p.cx.term = true;
        openblk(p, lr);
        ev(p, b);
        let rk = p.cx.vk;
        let rv = p.cx.vv;
        let rb2 = p.cx.cur;
        manual_br(p, lm);
        openblk(p, lm);
        let t = ntmp(p);
        w("  %t\0".as_ptr());
        wi(t);
        w(" = phi i1 [ \0".as_ptr());
        if num == B_ANDD {
            w("false\0".as_ptr());
        } else {
            w("true\0".as_ptr());
        }
        w(", %b\0".as_ptr());
        wi(pre);
        w(" ], [ \0".as_ptr());
        wv(p, rk, rv, TBOOL);
        w(", %b\0".as_ptr());
        wi(rb2);
        w(" ]\n\0".as_ptr());
        p.cx.vk = 0;
        p.cx.vv = t;
        p.cx.vt = TBOOL;
        return;
    }
    ev(p, a);
    let lk = p.cx.vk;
    let lv = p.cx.vv;
    ev(p, b);
    let rk = p.cx.vk;
    let rv = p.cx.vv;
    let t = ntmp(p);
    w("  %t\0".as_ptr());
    wi(t);
    if num == B_ADD {
        w(" = add i64 \0".as_ptr());
    } else if num == B_SUB {
        w(" = sub i64 \0".as_ptr());
    } else if num == B_MUL {
        w(" = mul i64 \0".as_ptr());
    } else if num == B_DIV {
        w(" = sdiv i64 \0".as_ptr());
    } else if num == B_MOD {
        w(" = srem i64 \0".as_ptr());
    } else if num == B_EQ {
        w(" = icmp eq i64 \0".as_ptr());
    } else if num == B_NE {
        w(" = icmp ne i64 \0".as_ptr());
    } else if num == B_LT {
        w(" = icmp slt i64 \0".as_ptr());
    } else if num == B_LE {
        w(" = icmp sle i64 \0".as_ptr());
    } else if num == B_GT {
        w(" = icmp sgt i64 \0".as_ptr());
    } else {
        w(" = icmp sge i64 \0".as_ptr());
    }
    wv(p, lk, lv, TI64);
    w(", \0".as_ptr());
    wv(p, rk, rv, TI64);
    w("\n\0".as_ptr());
    p.cx.vk = 0;
    p.cx.vv = t;
    if num <= B_MOD {
        p.cx.vt = TI64;
    } else {
        p.cx.vt = TBOOL;
    }
}

fn ref_ok(p: &mut P, aty: i64, pt2: i64) -> bool {
    if aty == pt2 {
        return true;
    }
    if is_ref(p.tys.k[aty as usize]) && is_ref(p.tys.k[pt2 as usize]) {
        if p.tys.a[aty as usize] == p.tys.a[pt2 as usize]
            && (p.tys.k[pt2 as usize] == Y_RI || p.tys.k[aty as usize] == Y_RI)
        {
            return true;
        }
    }
    return false;
}

fn ev_call(p: &mut P, n: i64) {
    let fi = p.nd.a[n as usize];
    let np = p.fs.np[fi as usize];
    let ext = p.fs.ext[fi as usize];
    let mut arg = p.nd.b[n as usize];
    let mut k = 0;
    while k < np {
        let mut pt2 = TI64;
        if ext == 0 {
            pt2 = p.vs.ty[(p.fs.pst[fi as usize] + k) as usize];
        } else {
            pt2 = p.flds.ty[(p.fs.pfst[fi as usize] + k) as usize];
        }
        if arg == 0 {
            unsafe {
                r0_panic("rust0 error: missing argument\n\0".as_ptr());
            }
        }
        if is_ref(p.tys.k[pt2 as usize]) {
            if p.nd.op[arg as usize] == N_ADDR {
                addr(p, p.nd.a[arg as usize]);
                p.cx.ak[k as usize] = p.cx.pk;
                p.cx.av[k as usize] = p.cx.pv;
            } else {
                ev(p, arg);
                p.cx.ak[k as usize] = p.cx.vk;
                p.cx.av[k as usize] = p.cx.vv;
            }
        } else {
            ev(p, arg);
            p.cx.ak[k as usize] = p.cx.vk;
            p.cx.av[k as usize] = p.cx.vv;
        }
        p.cx.at[k as usize] = pt2;
        arg = p.nd.nx[arg as usize];
        k += 1;
    }
    // convert string constants to address temps
    k = 0;
    while k < np {
        if p.cx.ak[k as usize] == 3 {
            let sid = p.cx.av[k as usize];
            let t = ntmp(p);
            w("  %t\0".as_ptr());
            wi(t);
            w(" = getelementptr inbounds [\0".as_ptr());
            wi(p.cx.slz[sid as usize]);
            w(" x i8], [\0".as_ptr());
            wi(p.cx.slz[sid as usize]);
            w(" x i8]* @.s\0".as_ptr());
            wi(sid);
            w(", i64 0, i64 0\n\0".as_ptr());
            p.cx.ak[k as usize] = 0;
            p.cx.av[k as usize] = t;
        }
        k += 1;
    }
    let ret = p.fs.ret[fi as usize];
    let t = ntmp(p);
    w("  \0".as_ptr());
    if ret != TUNIT {
        w("%t\0".as_ptr());
        wi(t);
        w(" = \0".as_ptr());
    }
    w("call \0".as_ptr());
    wt(p, ret);
    w(" @\0".as_ptr());
    if ext == 0 {
        w("r0fn_\0".as_ptr());
    }
    ws(p, p.fs.nm[fi as usize], p.fs.ln[fi as usize]);
    w("(\0".as_ptr());
    k = 0;
    while k < np {
        if k > 0 {
            w(", \0".as_ptr());
        }
        wt(p, p.cx.at[k as usize]);
        w(" \0".as_ptr());
        wv(p, p.cx.ak[k as usize], p.cx.av[k as usize], p.cx.at[k as usize]);
        k += 1;
    }
    w(")\n\0".as_ptr());
    if ret != TUNIT {
        p.cx.vk = 0;
        p.cx.vv = t;
        p.cx.vt = ret;
    } else {
        p.cx.vk = 4;
        p.cx.vv = 0;
        p.cx.vt = TUNIT;
    }
}

// store a struct literal's fields into the struct at pointer state (pk, pv)
fn cg_setstruct(p: &mut P, pk: i64, pv: i64, sty: i64, n: i64) {
    let tyd = p.tys.a[sty as usize];
    let mut fp = p.nd.b[n as usize];
    while fp != 0 {
        let fi = p.nd.num[fp as usize];
        let fty = p.flds.ty[(p.tyds.fst[tyd as usize] + fi) as usize];
        let e = p.nd.a[fp as usize];
        let t = ntmp(p);
        w("  %t\0".as_ptr());
        wi(t);
        w(" = getelementptr inbounds \0".as_ptr());
        wt(p, sty);
        w(", \0".as_ptr());
        wt(p, sty);
        w("* \0".as_ptr());
        if pk == 5 {
            slotref(p, pv);
        } else {
            tempref(p, pv);
        }
        w(", i64 0, i32 \0".as_ptr());
        wi(fi);
        w("\n\0".as_ptr());
        if p.nd.op[e as usize] == N_SLIT {
            cg_setstruct(p, 0, t, fty, e);
        } else if p.nd.op[e as usize] == N_ARR {
            cg_setarr(p, 0, t, fty, e);
        } else {
            ev(p, e);
            storeto(p, p.cx.vk, p.cx.vv, fty, 0, t);
        }
        fp = p.nd.nx[fp as usize];
    }
}

// store an array literal [e; N] into the array at pointer state (pk, pv)
fn cg_setarr(p: &mut P, pk: i64, pv: i64, arrty: i64, n: i64) {
    let elem = p.nd.a[n as usize];
    let cnt = p.nd.num[n as usize];
    let ety = p.tys.a[arrty as usize];
    let eop = p.nd.op[elem as usize];
    if (eop == N_NUMV && p.nd.num[elem as usize] == 0) || (eop == N_BOOLV && p.nd.num[elem as usize] == 0) {
        let mut bytes = cnt * 8;
        if ety == TBOOL {
            bytes = cnt;
        }
        let t = ntmp(p);
        w("  %t\0".as_ptr());
        wi(t);
        w(" = bitcast \0".as_ptr());
        wt(p, arrty);
        w("* \0".as_ptr());
        if pk == 5 {
            slotref(p, pv);
        } else {
            tempref(p, pv);
        }
        w(" to i8*\n  call void @r0_zf(i8* %t\0".as_ptr());
        wi(t);
        w(", i64 \0".as_ptr());
        wi(bytes);
        w(")\n\0".as_ptr());
        return;
    }
    ev(p, elem);
    let ek = p.cx.vk;
    let ev2 = p.cx.vv;
    let mut j = 0;
    while j < cnt {
        let t = ntmp(p);
        w("  %t\0".as_ptr());
        wi(t);
        w(" = getelementptr inbounds \0".as_ptr());
        wt(p, arrty);
        w(", \0".as_ptr());
        wt(p, arrty);
        w("* \0".as_ptr());
        if pk == 5 {
            slotref(p, pv);
        } else {
            tempref(p, pv);
        }
        w(", i64 0, i64 \0".as_ptr());
        wi(j);
        w("\n\0".as_ptr());
        storeto(p, ek, ev2, ety, 0, t);
        j += 1;
    }
}

fn cg_stmts(p: &mut P, head: i64) {
    let mut n = head;
    while n != 0 {
        if p.cx.term {
            let l = nlbl(p);
            openblk(p, l);
        }
        cg_stmt(p, n);
        n = p.nd.nx[n as usize];
    }
}

fn cg_stmt(p: &mut P, n: i64) {
    let op = p.nd.op[n as usize];
    if op == N_LET {
        let v = p.nd.a[n as usize];
        let vty = p.vs.ty[v as usize];
        let init = p.nd.b[n as usize];
        if init == 0 {
            return;
        }
        if p.nd.op[init as usize] == N_SLIT {
            cg_setstruct(p, 5, v, vty, init);
            return;
        }
        if p.nd.op[init as usize] == N_ARR {
            cg_setarr(p, 5, v, vty, init);
            return;
        }
        ev(p, init);
        storeto(p, p.cx.vk, p.cx.vv, vty, 5, v);
        return;
    }
    if op == N_ASS {
        addr(p, p.nd.a[n as usize]);
        let pk = p.cx.pk;
        let pv = p.cx.pv;
        let ty = p.nd.ty[p.nd.a[n as usize] as usize];
        ev(p, p.nd.b[n as usize]);
        storeto(p, p.cx.vk, p.cx.vv, ty, pk, pv);
        return;
    }
    if op == N_CASS {
        addr(p, p.nd.a[n as usize]);
        let pk = p.cx.pk;
        let pv = p.cx.pv;
        let ty = p.nd.ty[p.nd.a[n as usize] as usize];
        ev(p, p.nd.b[n as usize]);
        let rk = p.cx.vk;
        let rv = p.cx.vv;
        let tl = ntmp(p);
        w("  %t\0".as_ptr());
        wi(tl);
        w(" = load \0".as_ptr());
        wt(p, ty);
        w(", \0".as_ptr());
        wt(p, ty);
        w("* \0".as_ptr());
        if pk == 5 {
            slotref(p, pv);
        } else {
            tempref(p, pv);
        }
        w("\n\0".as_ptr());
        let t = ntmp(p);
        w("  %t\0".as_ptr());
        wi(t);
        let num = p.nd.num[n as usize];
        if ty == TBOOL {
            if num == B_ANDEQ {
                w(" = and i1 \0".as_ptr());
            } else if num == B_OREQ {
                w(" = or i1 \0".as_ptr());
            } else {
                w(" = xor i1 \0".as_ptr());
            }
        } else if num == B_ADD {
            w(" = add i64 \0".as_ptr());
        } else if num == B_SUB {
            w(" = sub i64 \0".as_ptr());
        } else if num == B_MUL {
            w(" = mul i64 \0".as_ptr());
        } else if num == B_DIV {
            w(" = sdiv i64 \0".as_ptr());
        } else {
            w(" = srem i64 \0".as_ptr());
        }
        wv(p, 0, tl, ty);
        w(", \0".as_ptr());
        wv(p, rk, rv, ty);
        w("\n\0".as_ptr());
        storeto(p, 0, t, ty, pk, pv);
        return;
    }
    if op == N_RET {
        let e = p.nd.a[n as usize];
        if e != 0 {
            ev(p, e);
            let rt = p.fs.ret[p.cfn as usize];
            w("  store \0".as_ptr());
            wt(p, rt);
            w(" \0".as_ptr());
            wv(p, p.cx.vk, p.cx.vv, rt);
            w(", \0".as_ptr());
            wt(p, rt);
            w("* %rv\n\0".as_ptr());
        }
        manual_br(p, p.cx.rtl);
        return;
    }
    if op == N_BRK {
        manual_br(p, p.cx.brk[(p.cx.dep - 1) as usize]);
        return;
    }
    if op == N_CONT {
        manual_br(p, p.cx.cnt[(p.cx.dep - 1) as usize]);
        return;
    }
    if op == N_BLK {
        cg_stmts(p, p.nd.a[n as usize]);
        return;
    }
    if op == N_IF {
        cg_if(p, n);
        return;
    }
    if op == N_WHILE {
        cg_while(p, n);
        return;
    }
    if op == N_FOR {
        cg_for(p, n);
        return;
    }
    ev(p, n);
    return;
}

fn cg_if(p: &mut P, n: i64) {
    let cond = p.nd.b[n as usize];
    ev(p, cond);
    let ck = p.cx.vk;
    let cv = p.cx.vv;
    if ck == 2 {
        if cv == 1 {
            cg_stmts(p, p.nd.a[n as usize]);
        } else if p.nd.c[n as usize] != 0 {
            let els = p.nd.c[n as usize];
            if p.nd.op[els as usize] == N_IF {
                cg_stmt(p, els);
            } else {
                cg_stmts(p, els);
            }
        }
        return;
    }
    let lt = nlbl(p);
    let bend = nlbl(p);
    let mut le = bend;
    if p.nd.c[n as usize] != 0 {
        le = nlbl(p);
    }
    w("  br i1 \0".as_ptr());
    wv(p, ck, cv, TBOOL);
    w(", label %b\0".as_ptr());
    wi(lt);
    w(", label %b\0".as_ptr());
    wi(le);
    w("\n\0".as_ptr());
    p.cx.term = true;
    openblk(p, lt);
    cg_stmts(p, p.nd.a[n as usize]);
    if !p.cx.term {
        manual_br(p, bend);
    }
    if p.nd.c[n as usize] != 0 {
        let els = p.nd.c[n as usize];
        w("b\0".as_ptr());
        wi(le);
        w(":\n\0".as_ptr());
        p.cx.cur = le;
        p.cx.term = false;
        if p.nd.op[els as usize] == N_IF {
            cg_stmt(p, els);
        } else {
            cg_stmts(p, els);
        }
    }
    openblk(p, bend);
}

fn cg_while(p: &mut P, n: i64) {
    let cond = p.nd.b[n as usize];
    let body = p.nd.a[n as usize];
    let bc = nlbl(p);
    let bb = nlbl(p);
    let be = nlbl(p);
    openblk(p, bc);
    ev(p, cond);
    let ck = p.cx.vk;
    let cv = p.cx.vv;
    if ck == 2 && cv == 0 {
        manual_br(p, be);
        openblk(p, be);
        return;
    }
    w("  br i1 \0".as_ptr());
    wv(p, ck, cv, TBOOL);
    w(", label %b\0".as_ptr());
    wi(bb);
    w(", label %b\0".as_ptr());
    wi(be);
    w("\n\0".as_ptr());
    p.cx.term = true;
    openblk(p, bb);
    p.cx.brk[p.cx.dep as usize] = be;
    p.cx.cnt[p.cx.dep as usize] = bc;
    p.cx.dep += 1;
    cg_stmts(p, body);
    p.cx.dep -= 1;
    if !p.cx.term {
        manual_br(p, bc);
    }
    openblk(p, be);
}

fn cg_for(p: &mut P, n: i64) {
    let v = p.nd.a[n as usize];
    let lo = p.nd.b[n as usize];
    let hi = p.nd.c[n as usize];
    let body = p.nd.num[n as usize];
    ev(p, lo);
    storeto(p, p.cx.vk, p.cx.vv, TI64, 5, v);
    ev(p, hi);
    let hk = p.cx.vk;
    let hv = p.cx.vv;
    let bc = nlbl(p);
    let bb = nlbl(p);
    let bi = nlbl(p);
    let be = nlbl(p);
    openblk(p, bc);
    let tl = ntmp(p);
    w("  %t\0".as_ptr());
    wi(tl);
    w(" = load i64, i64* \0".as_ptr());
    slotref(p, v);
    w("\n  %t\0".as_ptr());
    let tc = ntmp(p);
    wi(tc);
    w(" = icmp slt i64 %t\0".as_ptr());
    wi(tl);
    w(", \0".as_ptr());
    wv(p, hk, hv, TI64);
    w("\n  br i1 %t\0".as_ptr());
    wi(tc);
    w(", label %b\0".as_ptr());
    wi(bb);
    w(", label %b\0".as_ptr());
    wi(be);
    w("\n\0".as_ptr());
    p.cx.term = true;
    openblk(p, bb);
    p.cx.brk[p.cx.dep as usize] = be;
    p.cx.cnt[p.cx.dep as usize] = bi;
    p.cx.dep += 1;
    cg_stmts(p, body);
    p.cx.dep -= 1;
    if !p.cx.term {
        manual_br(p, bi);
    }
    openblk(p, bi);
    let ti = ntmp(p);
    w("  %t\0".as_ptr());
    wi(ti);
    w(" = load i64, i64* \0".as_ptr());
    slotref(p, v);
    w("\n  %t\0".as_ptr());
    let tn = ntmp(p);
    wi(tn);
    w(" = add i64 %t\0".as_ptr());
    wi(ti);
    w(", 1\n  store i64 %t\0".as_ptr());
    wi(tn);
    w(", i64* \0".as_ptr());
    slotref(p, v);
    w("\n\0".as_ptr());
    manual_br(p, bc);
    openblk(p, be);
}

fn cg_fn(p: &mut P, fi: i64, head: i64) {
    p.cx.tmp = 0;
    p.cx.dep = 0;
    p.cx.term = false;
    let rtl = nlbl(p);
    let bl = nlbl(p);
    p.cx.rtl = rtl;
    let ret = p.fs.ret[fi as usize];
    let np = p.fs.np[fi as usize];
    w("define \0".as_ptr());
    wt(p, ret);
    w(" @r0fn_\0".as_ptr());
    ws(p, p.fs.nm[fi as usize], p.fs.ln[fi as usize]);
    w("(\0".as_ptr());
    let mut k = 0;
    while k < np {
        if k > 0 {
            w(", \0".as_ptr());
        }
        wt(p, p.vs.ty[(p.fs.pst[fi as usize] + k) as usize]);
        w(" %a\0".as_ptr());
        wi(k);
        k += 1;
    }
    w(") {\n\0".as_ptr());
    if ret != TUNIT {
        w("  %rv = alloca \0".as_ptr());
        wt(p, ret);
        w("\n\0".as_ptr());
    }
    k = 0;
    while k < np {
        let pt2 = p.vs.ty[(p.fs.pst[fi as usize] + k) as usize];
        let slot = p.fs.pst[fi as usize] + k;
        w("  %v\0".as_ptr());
        wi(slot);
        w(" = alloca \0".as_ptr());
        wt(p, pt2);
        w("\n  store \0".as_ptr());
        wt(p, pt2);
        w(" %a\0".as_ptr());
        wi(k);
        w(", \0".as_ptr());
        wt(p, pt2);
        w("* %v\0".as_ptr());
        wi(slot);
        w("\n\0".as_ptr());
        k += 1;
    }
    unsafe {
        r0_wchd(70);
        r0_wchd(58);
        r0_wchd2(fi);
        r0_wchd(32);
        let mut nk = 0;
        while nk < p.fs.ln[fi as usize] {
            r0_wchd((*(p.src.add((p.fs.nm[fi as usize] + nk) as usize))) as i64);
            nk += 1;
        }
        r0_wchd(32);
        r0_wchd(32);
        r0_wchd2(p.fs.vst[fi as usize]);
        r0_wchd(32);
        r0_wchd2(p.fs.vn[fi as usize]);
        r0_wchd(10);
    }
    let mut i = p.fs.vst[fi as usize];
    while i < p.fs.vn[fi as usize] {
        w("  %v\0".as_ptr());
        wi(i);
        w(" = alloca \0".as_ptr());
        wt(p, p.vs.ty[i as usize]);
        w("\n\0".as_ptr());
        i += 1;
    }
    manual_br(p, bl);
    w("b\0".as_ptr());
    wi(bl);
    w(":\n\0".as_ptr());
    p.cx.cur = bl;
    p.cx.term = false;
    cg_stmts(p, head);
    openblk(p, rtl);
    if ret == TUNIT {
        w("  ret void\n\0".as_ptr());
    } else {
        w("  %rr = load \0".as_ptr());
        wt(p, ret);
        w(", \0".as_ptr());
        wt(p, ret);
        w("* %rv\n  ret \0".as_ptr());
        wt(p, ret);
        w(" %rr\n\0".as_ptr());
    }
    w("}\n\0".as_ptr());
}

// ------------------------------------------------------------------
// driver
// ------------------------------------------------------------------

fn compile(p: &mut P) {
    lex(p);
    collect(p);
    w("\n\0".as_ptr());
    let vbase = p.vs.n;
    let mut fi = 0;
    while fi < p.fs.n {
        if p.fs.ext[fi as usize] == 0 {
            p.cfn = fi;
            p.cur = p.fs.bt[fi as usize];
            p.vs.n = vbase;
            p.fs.vst[fi as usize] = vbase;
            p.fs.vn[fi as usize] = vbase;
            let head = parse_stmts(p);
            expectpt(p, 125, "expected } after fn body\0".as_ptr());
            p.vs.n = vbase;
            cg_fn(p, fi, head);
        }
        fi += 1;
    }
    w("\n\0".as_ptr());
    let mut i = 0;
    while i < p.cx.ns {
        w("@.s\0".as_ptr());
        wi(i);
        w(" = private unnamed_addr constant [\0".as_ptr());
        wi(p.cx.slz[i as usize]);
        w(" x i8] c\"\0".as_ptr());
        wstrlit(p.src, p.cx.sp[i as usize], p.cx.sln[i as usize]);
        w("\\00\"\n\0".as_ptr());
        i += 1;
    }
}

fn main() {
    let mut p = P {
        src: "\0".as_ptr(),
        slen: 0,
        pos: 0,
        row: 1,
        cur: 0,
        cfn: 0,
        tk: Toks {
            k: [0; 24000],
            v: [0; 24000],
            st: [0; 24000],
            sl: [0; 24000],
            row: [0; 24000],
            n: 0,
        },
        nd: Nds {
            op: [0; 24000],
            a: [0; 24000],
            b: [0; 24000],
            c: [0; 24000],
            num: [0; 24000],
            ty: [0; 24000],
            nx: [0; 24000],
            row: [0; 24000],
            n: 1,
        },
        tys: Tys {
            k: [0; 256],
            a: [0; 256],
            b: [0; 256],
            n: 4,
        },
        tyds: Tyds {
            nm: [0; 32],
            ln: [0; 32],
            fst: [0; 32],
            cnt: [0; 32],
            tid: [0; 32],
            n: 0,
        },
        flds: Fldt {
            nm: [0; 256],
            ln: [0; 256],
            ty: [0; 256],
            n: 0,
        },
        fs: Fsig {
            nm: [0; 160],
            ln: [0; 160],
            ret: [0; 160],
            pst: [0; 160],
            np: [0; 160],
            ext: [0; 160],
            pfst: [0; 160],
            bt: [0; 160],
            vst: [0; 160],
            vn: [0; 160],
            n: 0,
        },
        cst: Cst {
            nm: [0; 160],
            ln: [0; 160],
            ty: [0; 160],
            val: [0; 160],
            n: 0,
        },
        vs: Vs {
            nm: [0; 1024],
            ln: [0; 1024],
            ty: [0; 1024],
            fd: [0; 1024],
            n: 0,
        },
        cx: Cx {
            tmp: 0,
            lbl: 0,
            cur: 0,
            term: false,
            dep: 0,
            brk: [0; 32],
            cnt: [0; 32],
            vk: 0,
            vv: 0,
            vt: 0,
            ak: [0; 12],
            av: [0; 12],
            at: [0; 12],
            pk: 0,
            pv: 0,
            pt: 0,
            sp: [0; 1024],
            sln: [0; 1024],
            slz: [0; 1024],
            ns: 0,
            wst: [0; 2],
            wvl: [0; 2],
            rtl: 0,
        },
    };
    p.tys.k[0 as usize] = Y_I64;
    p.tys.k[1 as usize] = Y_BOOL;
    p.tys.k[2 as usize] = Y_UNIT;
    p.tys.k[3 as usize] = Y_PTR8;
    let mut ai = 1;
    unsafe {
        if r0_argc() > 1 {
            let q = r0_arg(1);
            let mut j = 0;
            let mut eq = 1;
            while true {
                let cb = r0_b("--args\0".as_ptr(), j);
                let ab = r0_b(q, j);
                if cb != ab {
                    eq = 0;
                    break;
                }
                if cb == 0 {
                    break;
                }
                j += 1;
            }
            if eq == 1 {
                ai = 2;
            }
        }
        if r0_argc() < ai + 2 {
            r0_panic("use: r0c input.rs output.ll\n\0".as_ptr());
        }
        r0_load(r0_arg(ai));
    }
    unsafe {
        p.src = r0_srcp();
        p.slen = r0_srclen();
    }
    compile(&mut p);
    unsafe {
        r0_save(r0_arg(ai + 1));
    }
}
