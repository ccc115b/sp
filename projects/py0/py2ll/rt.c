/* rt.c - runtime library for py2ll (Python subset -> LLVM IR)
 *
 * Values are 64-bit words:
 *   low bit 1  -> small integer (63-bit, value = v >> 1)
 *   otherwise  -> pointer to a heap object whose first word is a type tag
 * No GC: memory is simply never freed.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stdarg.h>
#include <setjmp.h>
#include <math.h>
#include <ctype.h>

typedef int64_t V;
typedef int64_t I;

enum { T_INT = 0, T_NONE = 1, T_BOOL, T_FLOAT, T_STR, T_LIST, T_TUPLE, T_DICT, T_SET,
       T_FUNC, T_BUILTIN, T_CLASS, T_INST, T_BOUND, T_FILE, T_MODULE, T_ITER };

typedef V (*Fn)(I argc, V *argv);
typedef struct { I tag; } Obj;
typedef struct { I tag; I b; } BoolO;
typedef struct { I tag; double d; } FloatO;
typedef struct { I tag; I len; char data[1]; } StrO;
typedef struct { I tag; I len; I cap; V *items; } ListO;
typedef struct { V k; V v; I h; } Ent;
typedef struct { I tag; I n; I used; I cap; Ent *ents; I icap; I *idx; } DictO;
typedef struct { I tag; Fn fn; I nparams; I ndef; V *defs; V name; } FuncO;
typedef struct { I tag; Fn fn; const char *name; } BuiltinO;
typedef struct { I tag; V name; V base; V dict; } ClassO;
typedef struct { I tag; V cls; V attrs; } InstO;
typedef struct { I tag; V self; V func; } BoundO;
typedef struct { I tag; FILE *f; } FileO;
typedef struct { I tag; I id; } ModO;
typedef struct { I tag; V seq; I i; } IterO;

#define ISINT(v) (((v) & 1) != 0)
#define MKINT(n) ((((I)(n)) * 2) + 1)
#define INTV(v) (((I)(v)) >> 1)
#define INT_MAX62 ((((I)1) << 62) - 1)
#define INT_MIN62 (-(((I)1) << 62))

static Obj none_o = {T_NONE};
static BoolO true_o = {T_BOOL, 1}, false_o = {T_BOOL, 0};
V rt_none_v, rt_true_v, rt_false_v;
#define NONE rt_none_v

static inline I tagof(V v) { return ISINT(v) ? T_INT : (v == 0 ? -1 : ((Obj *)v)->tag); }
static inline V B(int b) { return b ? rt_true_v : rt_false_v; }

static void *xmalloc(size_t n) {
    void *p = calloc(1, n ? n : 1);
    if (!p) { fprintf(stderr, "out of memory\n"); exit(1); }
    return p;
}

/* ---------------------------------------------------------------- forward */
V rt_call(V f, I argc, V *argv);
V rt_str(V v);
V rt_repr(V v);
V rt_raise(V exc);
I rt_eq_i(V a, V b);
I rt_truthy(V v);
V rt_getattr(V o, V name);
static void thr(const char *cls, const char *fmt, ...) __attribute__((noreturn));
static V mkstr(const char *s, I n);
static V mklist(I n);
static V as_list(V v);
static I hash_v(V v);
static V dict_new(I tag);
static Ent *dict_find(DictO *d, V k, I h);
static void dict_set(DictO *d, V k, V v);
static V class_lookup(V cls, V name);
static I inst_of(V obj, V cls);
V b_int(I, V *); V b_float(I, V *); V b_str(I, V *); V b_bool(I, V *); V b_list(I, V *);
V b_tuple(I, V *); V b_dict(I, V *); V b_set(I, V *); V b_exit(I, V *);

/* ---------------------------------------------------------------- strings */
typedef struct { char *p; I n, cap; } SB;
static void sb_init(SB *s) { s->cap = 64; s->n = 0; s->p = xmalloc(64); }
static void sb_add(SB *s, const char *d, I n) {
    if (s->n + n + 1 > s->cap) {
        I nc = s->cap * 2;
        while (nc < s->n + n + 1) nc *= 2;
        s->p = realloc(s->p, nc);
        s->cap = nc;
    }
    memcpy(s->p + s->n, d, n);
    s->n += n;
    s->p[s->n] = 0;
}
static void sb_adds(SB *s, const char *c) { sb_add(s, c, strlen(c)); }
static void sb_putc(SB *s, char c) { sb_add(s, &c, 1); }

static V char_cache[256];
static V mkstr(const char *s, I n) {
    if (n == 1 && char_cache[(unsigned char)s[0]]) return char_cache[(unsigned char)s[0]];
    StrO *o = xmalloc(sizeof(StrO) + n + 1);
    o->tag = T_STR; o->len = n;
    memcpy(o->data, s, n);
    o->data[n] = 0;
    if (n == 1) char_cache[(unsigned char)s[0]] = (V)o;
    return (V)o;
}
static V sb_str(SB *s) { return mkstr(s->p, s->n); }
static V S(const char *c) { return mkstr(c, strlen(c)); }
#define STR(v) ((StrO *)(v))
V rt_mkstr(const char *d, I n) { return mkstr(d, n); }

/* ---------------------------------------------------------------- objects */
V rt_mkfloat(double d) { FloatO *o = xmalloc(sizeof(FloatO)); o->tag = T_FLOAT; o->d = d; return (V)o; }
V rt_mkfloat_cstr(const char *s) { return rt_mkfloat(strtod(s, NULL)); }
static V mkint(I n) {
    if (n > INT_MAX62 || n < INT_MIN62) thr("OverflowError", "integer overflow (runtime ints are 63-bit)");
    return MKINT(n);
}
static V mklist(I n) {
    ListO *o = xmalloc(sizeof(ListO));
    o->tag = T_LIST; o->len = 0; o->cap = n < 4 ? 4 : n;
    o->items = xmalloc(sizeof(V) * o->cap);
    return (V)o;
}
static V mktuple(I n) {
    ListO *o = xmalloc(sizeof(ListO));
    o->tag = T_TUPLE; o->len = n; o->cap = n;
    o->items = xmalloc(sizeof(V) * (n ? n : 1));
    return (V)o;
}
#define LST(v) ((ListO *)(v))
static void list_append(V l, V x) {
    ListO *o = LST(l);
    if (o->len >= o->cap) { o->cap *= 2; o->items = realloc(o->items, sizeof(V) * o->cap); }
    o->items[o->len++] = x;
}
static V tuple2(V a, V b) { V t = mktuple(2); LST(t)->items[0] = a; LST(t)->items[1] = b; return t; }

static V mkfile(FILE *f) { FileO *o = xmalloc(sizeof(FileO)); o->tag = T_FILE; o->f = f; return (V)o; }
static V mkbuiltin(Fn fn, const char *name) { BuiltinO *o = xmalloc(sizeof(BuiltinO)); o->tag = T_BUILTIN; o->fn = fn; o->name = name; return (V)o; }

/* ---------------------------------------------------------------- dict */
#define DCT(v) ((DictO *)(v))
static V dict_new(I tag) { DictO *d = xmalloc(sizeof(DictO)); d->tag = tag; return (V)d; }
static void dict_rebuild(DictO *d, I newcap) {
    Ent *ne = xmalloc(sizeof(Ent) * newcap);
    I k = 0;
    for (I i = 0; i < d->used; i++) if (d->ents[i].k) ne[k++] = d->ents[i];
    I ic = 8;
    while (ic < newcap * 2) ic <<= 1;
    I *ni = xmalloc(sizeof(I) * ic);
    for (I i = 0; i < ic; i++) ni[i] = -1;
    for (I i = 0; i < k; i++) {
        I j = ne[i].h & (ic - 1);
        while (ni[j] != -1) j = (j + 1) & (ic - 1);
        ni[j] = i;
    }
    d->ents = ne; d->used = k; d->cap = newcap; d->idx = ni; d->icap = ic;
}
static Ent *dict_find(DictO *d, V k, I h) {
    if (!d->icap) return NULL;
    I m = d->icap - 1, i = h & m;
    for (;;) {
        I e = d->idx[i];
        if (e < 0) return NULL;
        Ent *en = &d->ents[e];
        if (en->k && en->h == h && (en->k == k || rt_eq_i(en->k, k))) return en;
        i = (i + 1) & m;
    }
}
static Ent *dict_get_e(DictO *d, V k) { return dict_find(d, k, hash_v(k)); }
static void dict_set(DictO *d, V k, V v) {
    I h = hash_v(k);
    Ent *e = dict_find(d, k, h);
    if (e) { e->v = v; return; }
    if (d->used >= d->cap) dict_rebuild(d, d->n * 2 < 8 ? 8 : d->n * 2);
    I idx = d->used++;
    d->ents[idx].k = k; d->ents[idx].v = v; d->ents[idx].h = h;
    d->n++;
    I m = d->icap - 1, i = h & m;
    while (d->idx[i] != -1) i = (i + 1) & m;
    d->idx[i] = idx;
}
static int dict_del(DictO *d, V k) {
    Ent *e = dict_get_e(d, k);
    if (!e) return 0;
    e->k = 0; e->v = 0; d->n--;
    return 1;
}
static V dict_keys(DictO *d) {
    V l = mklist(d->n);
    for (I i = 0; i < d->used; i++) if (d->ents[i].k) list_append(l, d->ents[i].k);
    return l;
}

/* ---------------------------------------------------------------- hashing / equality */
static I hash_v(V v) {
    if (ISINT(v)) return INTV(v) * 0x9E3779B97F4A7C15LL;
    switch (tagof(v)) {
    case T_BOOL: return ((BoolO *)v)->b * 0x9E3779B97F4A7C15LL;
    case T_FLOAT: {
        double d = ((FloatO *)v)->d;
        if (d == (double)(I)d) return ((I)d) * 0x9E3779B97F4A7C15LL;
        I b; memcpy(&b, &d, 8); return b;
    }
    case T_STR: {
        uint64_t h = 1469598103934665603ULL;
        StrO *s = STR(v);
        for (I i = 0; i < s->len; i++) { h ^= (unsigned char)s->data[i]; h *= 1099511628211ULL; }
        return (I)h;
    }
    case T_TUPLE: {
        uint64_t h = 0x345678;
        for (I i = 0; i < LST(v)->len; i++) h = (h ^ (uint64_t)hash_v(LST(v)->items[i])) * 1000003ULL;
        return (I)h;
    }
    case T_LIST: case T_DICT: case T_SET: thr("TypeError", "unhashable type");
    default: return v >> 3;
    }
}

static int is_intlike(V v) { return ISINT(v) || tagof(v) == T_BOOL; }
static I toi(V v) {
    if (ISINT(v)) return INTV(v);
    if (tagof(v) == T_BOOL) return ((BoolO *)v)->b;
    thr("TypeError", "an integer is required");
}
static int is_num(V v) { return is_intlike(v) || tagof(v) == T_FLOAT; }
static double tod(V v) {
    if (ISINT(v)) return (double)INTV(v);
    if (tagof(v) == T_BOOL) return (double)((BoolO *)v)->b;
    if (tagof(v) == T_FLOAT) return ((FloatO *)v)->d;
    thr("TypeError", "a number is required");
}

I rt_eq_i(V a, V b) {
    if (a == b) return 1;
    I ta = tagof(a), tb = tagof(b);
    if (is_intlike(a) && is_intlike(b)) return toi(a) == toi(b);
    if (is_num(a) && is_num(b)) return tod(a) == tod(b);
    if (ta != tb) {
        if (ta == T_INST) goto inst_eq;
        return 0;
    }
    switch (ta) {
    case T_STR: return STR(a)->len == STR(b)->len && memcmp(STR(a)->data, STR(b)->data, STR(a)->len) == 0;
    case T_LIST: case T_TUPLE:
        if (LST(a)->len != LST(b)->len) return 0;
        for (I i = 0; i < LST(a)->len; i++) if (!rt_eq_i(LST(a)->items[i], LST(b)->items[i])) return 0;
        return 1;
    case T_DICT: case T_SET: {
        if (DCT(a)->n != DCT(b)->n) return 0;
        for (I i = 0; i < DCT(a)->used; i++) {
            Ent *e = &DCT(a)->ents[i];
            if (!e->k) continue;
            Ent *o = dict_find(DCT(b), e->k, e->h);
            if (!o) return 0;
            if (ta == T_DICT && !rt_eq_i(e->v, o->v)) return 0;
        }
        return 1;
    }
    case T_INST: inst_eq: {
        static V k_eq = 0;
        if (!k_eq) k_eq = S("__eq__");
        V m = class_lookup(((InstO *)a)->cls, k_eq);
        if (m) { V args[2] = {a, b}; return rt_truthy(rt_call(m, 2, args)); }
        return 0;
    }
    default: return 0;
    }
}

static int cmp_v(V a, V b) {
    if (is_intlike(a) && is_intlike(b)) { I x = toi(a), y = toi(b); return x < y ? -1 : x > y; }
    if (is_num(a) && is_num(b)) { double x = tod(a), y = tod(b); return x < y ? -1 : x > y; }
    I ta = tagof(a), tb = tagof(b);
    if (ta == tb) {
        if (ta == T_STR) {
            I n = STR(a)->len < STR(b)->len ? STR(a)->len : STR(b)->len;
            int c = memcmp(STR(a)->data, STR(b)->data, n);
            if (c) return c < 0 ? -1 : 1;
            return STR(a)->len < STR(b)->len ? -1 : STR(a)->len > STR(b)->len;
        }
        if (ta == T_LIST || ta == T_TUPLE) {
            I n = LST(a)->len < LST(b)->len ? LST(a)->len : LST(b)->len;
            for (I i = 0; i < n; i++) {
                if (rt_eq_i(LST(a)->items[i], LST(b)->items[i])) continue;
                return cmp_v(LST(a)->items[i], LST(b)->items[i]);
            }
            return LST(a)->len < LST(b)->len ? -1 : LST(a)->len > LST(b)->len;
        }
        if (ta == T_INST) {
            static V k_lt = 0;
            if (!k_lt) k_lt = S("__lt__");
            V m = class_lookup(((InstO *)a)->cls, k_lt);
            if (m) {
                V args[2] = {a, b};
                if (rt_truthy(rt_call(m, 2, args))) return -1;
                V args2[2] = {b, a};
                if (rt_truthy(rt_call(m, 2, args2))) return 1;
                return 0;
            }
        }
    }
    thr("TypeError", "'<' not supported between instances of incompatible types");
}

/* ---------------------------------------------------------------- errors / exceptions */
static V cur_exc;
static jmp_buf jbs[1024];
static I nh = 0;
#define MAXEXC 40
static V exc_cls[MAXEXC];
static const char *exc_nm[MAXEXC];
static int nexc = 0;
static V K_args, K_init, K_str, K_repr, K_len, K_getitem, K_setitem, K_name;

static V new_class(V name, V base) {
    ClassO *c = xmalloc(sizeof(ClassO));
    c->tag = T_CLASS; c->name = name; c->base = base; c->dict = dict_new(T_DICT);
    return (V)c;
}
static V new_inst(V cls) {
    InstO *o = xmalloc(sizeof(InstO));
    o->tag = T_INST; o->cls = cls; o->attrs = dict_new(T_DICT);
    return (V)o;
}
static V class_lookup(V cls, V name) {
    while (cls && tagof(cls) == T_CLASS) {
        Ent *e = dict_get_e(DCT(((ClassO *)cls)->dict), name);
        if (e) return e->v;
        cls = ((ClassO *)cls)->base;
    }
    return 0;
}
static I inst_of(V obj, V cls) {
    if (tagof(obj) != T_INST) return 0;
    V c = ((InstO *)obj)->cls;
    while (c && tagof(c) == T_CLASS) {
        if (c == cls) return 1;
        c = ((ClassO *)c)->base;
    }
    return 0;
}
static V exc_by_name(const char *n) {
    for (int i = 0; i < nexc; i++) if (strcmp(exc_nm[i], n) == 0) return exc_cls[i];
    fprintf(stderr, "internal: unknown exception %s\n", n);
    exit(2);
}
static void thr(const char *cls, const char *fmt, ...) {
    char buf[1024];
    va_list ap;
    va_start(ap, fmt);
    vsnprintf(buf, sizeof buf, fmt, ap);
    va_end(ap);
    V inst = new_inst(exc_by_name(cls));
    V t = mktuple(1);
    LST(t)->items[0] = mkstr(buf, strlen(buf));
    dict_set(DCT(((InstO *)inst)->attrs), K_args, t);
    rt_raise(inst);
    __builtin_unreachable();
}
static const char *tname(V v);
V rt_raise(V exc) {
    if (tagof(exc) == T_CLASS) exc = rt_call(exc, 0, NULL);
    if (tagof(exc) != T_INST) { fflush(stdout); fprintf(stderr, "TypeError: exceptions must derive from Exception\n"); exit(1); }
    cur_exc = exc;
    if (nh > 0) { nh--; longjmp(jbs[nh], 1); }
    fflush(stdout);
    V s = rt_str(exc);
    V cn = ((ClassO *)((InstO *)exc)->cls)->name;
    fprintf(stderr, "Traceback (most recent call last):\n  <compiled code>\n");
    if (STR(s)->len) fprintf(stderr, "%s: %s\n", STR(cn)->data, STR(s)->data);
    else fprintf(stderr, "%s\n", STR(cn)->data);
    exit(1);
}
void *rt_try_push(void) {
    if (nh >= 1024) { fprintf(stderr, "too many nested try blocks\n"); exit(1); }
    return &jbs[nh++];
}
void rt_try_pop(void) { if (nh > 0) nh--; }
V rt_exc_cur(void) { return cur_exc; }
I rt_exc_match(V exc, V cls) {
    if (tagof(cls) == T_TUPLE) {
        for (I i = 0; i < LST(cls)->len; i++) if (rt_exc_match(exc, LST(cls)->items[i])) return 1;
        return 0;
    }
    return inst_of(exc, cls);
}
V rt_assert_fail(V msg) {
    V inst = new_inst(exc_by_name("AssertionError"));
    V t = mktuple(msg == NONE ? 0 : 1);
    if (msg != NONE) LST(t)->items[0] = msg;
    dict_set(DCT(((InstO *)inst)->attrs), K_args, t);
    return rt_raise(inst);
}
V b_exc_init(I argc, V *argv) {
    V t = mktuple(argc - 1);
    for (I i = 1; i < argc; i++) LST(t)->items[i - 1] = argv[i];
    dict_set(DCT(((InstO *)argv[0])->attrs), K_args, t);
    return NONE;
}

/* ---------------------------------------------------------------- repr / str */
static const char *tname(V v) {
    switch (tagof(v)) {
    case T_INT: return "int"; case T_NONE: return "NoneType"; case T_BOOL: return "bool";
    case T_FLOAT: return "float"; case T_STR: return "str"; case T_LIST: return "list";
    case T_TUPLE: return "tuple"; case T_DICT: return "dict"; case T_SET: return "set";
    case T_FUNC: return "function"; case T_BUILTIN: return "builtin_function_or_method";
    case T_CLASS: return "type"; case T_INST: return STR(((ClassO *)((InstO *)v)->cls)->name)->data;
    case T_BOUND: return "method"; case T_FILE: return "file"; case T_MODULE: return "module";
    default: return "object";
    }
}
static void fmt_float(SB *sb, double d) {
    if (isnan(d)) { sb_adds(sb, "nan"); return; }
    if (isinf(d)) { sb_adds(sb, d < 0 ? "-inf" : "inf"); return; }
    if (d == 0) { sb_adds(sb, signbit(d) ? "-0.0" : "0.0"); return; }
    char buf[64], buf2[96];
    int p;
    for (p = 1; p <= 17; p++) {
        snprintf(buf, sizeof buf, "%.*e", p - 1, d);
        if (strtod(buf, NULL) == d) break;
    }
    if (p > 17) p = 17;
    snprintf(buf, sizeof buf, "%.*e", p - 1, d);
    char *e = strchr(buf, 'e');
    int e10 = atoi(e + 1);
    if (e10 >= -4 && e10 < 16) {
        int k = p - 1 - e10;
        if (k < 0) k = 0;
        snprintf(buf2, sizeof buf2, "%.*f", k, d);
        sb_adds(sb, buf2);
        if (!strchr(buf2, '.')) sb_adds(sb, ".0");
    } else {
        sb_adds(sb, buf);
    }
}
static void repr_str(SB *sb, StrO *s) {
    char q = '\'';
    if (memchr(s->data, '\'', s->len) && !memchr(s->data, '"', s->len)) q = '"';
    sb_putc(sb, q);
    for (I i = 0; i < s->len; i++) {
        unsigned char c = s->data[i];
        if (c == (unsigned char)q || c == '\\') { sb_putc(sb, '\\'); sb_putc(sb, c); }
        else if (c == '\n') sb_adds(sb, "\\n");
        else if (c == '\t') sb_adds(sb, "\\t");
        else if (c == '\r') sb_adds(sb, "\\r");
        else if (c < 32 || c == 127) { char t[8]; snprintf(t, sizeof t, "\\x%02x", c); sb_adds(sb, t); }
        else sb_putc(sb, c);
    }
    sb_putc(sb, q);
}
static void to_sb(SB *sb, V v, int repr) {
    char tmp[64];
    if (ISINT(v)) { snprintf(tmp, sizeof tmp, "%lld", (long long)INTV(v)); sb_adds(sb, tmp); return; }
    switch (tagof(v)) {
    case T_NONE: sb_adds(sb, "None"); return;
    case T_BOOL: sb_adds(sb, ((BoolO *)v)->b ? "True" : "False"); return;
    case T_FLOAT: fmt_float(sb, ((FloatO *)v)->d); return;
    case T_STR: if (repr) repr_str(sb, STR(v)); else sb_add(sb, STR(v)->data, STR(v)->len); return;
    case T_LIST: case T_TUPLE: {
        int tup = tagof(v) == T_TUPLE;
        sb_putc(sb, tup ? '(' : '[');
        for (I i = 0; i < LST(v)->len; i++) {
            if (i) sb_adds(sb, ", ");
            to_sb(sb, LST(v)->items[i], 1);
        }
        if (tup && LST(v)->len == 1) sb_putc(sb, ',');
        sb_putc(sb, tup ? ')' : ']');
        return;
    }
    case T_DICT: {
        sb_putc(sb, '{');
        int first = 1;
        for (I i = 0; i < DCT(v)->used; i++) {
            Ent *e = &DCT(v)->ents[i];
            if (!e->k) continue;
            if (!first) sb_adds(sb, ", ");
            first = 0;
            to_sb(sb, e->k, 1); sb_adds(sb, ": "); to_sb(sb, e->v, 1);
        }
        sb_putc(sb, '}');
        return;
    }
    case T_SET: {
        if (DCT(v)->n == 0) { sb_adds(sb, "set()"); return; }
        sb_putc(sb, '{');
        int first = 1;
        for (I i = 0; i < DCT(v)->used; i++) {
            Ent *e = &DCT(v)->ents[i];
            if (!e->k) continue;
            if (!first) sb_adds(sb, ", ");
            first = 0;
            to_sb(sb, e->k, 1);
        }
        sb_putc(sb, '}');
        return;
    }
    case T_FUNC: sb_adds(sb, "<function "); sb_adds(sb, STR(((FuncO *)v)->name)->data); sb_putc(sb, '>'); return;
    case T_BUILTIN: sb_adds(sb, "<built-in function "); sb_adds(sb, ((BuiltinO *)v)->name); sb_putc(sb, '>'); return;
    case T_CLASS: sb_adds(sb, "<class '"); sb_adds(sb, STR(((ClassO *)v)->name)->data); sb_adds(sb, "'>"); return;
    case T_INST: {
        InstO *in = (InstO *)v;
        V m = 0;
        if (!repr) m = class_lookup(in->cls, K_str);
        if (!m) m = class_lookup(in->cls, K_repr);
        if (m) {
            V args[1] = {v};
            V r = rt_call(m, 1, args);
            if (tagof(r) != T_STR) thr("TypeError", "__str__ returned non-string");
            sb_add(sb, STR(r)->data, STR(r)->len);
            return;
        }
        Ent *e = dict_get_e(DCT(in->attrs), K_args);
        if (e && !repr && inst_of(v, exc_by_name("Exception"))) {
            V t = e->v;
            if (LST(t)->len == 1) to_sb(sb, LST(t)->items[0], 0);
            else if (LST(t)->len > 1) to_sb(sb, t, 1);
            return;
        }
        if (e && inst_of(v, exc_by_name("Exception"))) {
            sb_adds(sb, STR(((ClassO *)in->cls)->name)->data);
            to_sb(sb, e->v, 1);
            return;
        }
        sb_putc(sb, '<'); sb_adds(sb, STR(((ClassO *)in->cls)->name)->data); sb_adds(sb, " object>");
        return;
    }
    case T_BOUND: sb_adds(sb, "<bound method>"); return;
    case T_FILE: sb_adds(sb, "<file>"); return;
    case T_MODULE: sb_adds(sb, "<module>"); return;
    default: sb_adds(sb, "<object>"); return;
    }
}
V rt_str(V v) {
    if (tagof(v) == T_STR) return v;
    SB sb; sb_init(&sb); to_sb(&sb, v, 0); return sb_str(&sb);
}
V rt_repr(V v) { SB sb; sb_init(&sb); to_sb(&sb, v, 1); return sb_str(&sb); }

/* ---------------------------------------------------------------- truthiness */
I rt_truthy(V v) {
    if (ISINT(v)) return v != 1;
    switch (tagof(v)) {
    case T_NONE: return 0;
    case T_BOOL: return ((BoolO *)v)->b;
    case T_FLOAT: return ((FloatO *)v)->d != 0;
    case T_STR: return STR(v)->len > 0;
    case T_LIST: case T_TUPLE: return LST(v)->len > 0;
    case T_DICT: case T_SET: return DCT(v)->n > 0;
    case T_INST: {
        V m = class_lookup(((InstO *)v)->cls, K_len);
        if (m) { V a[1] = {v}; return rt_truthy(rt_call(m, 1, a)); }
        return 1;
    }
    default: return 1;
    }
}

/* ---------------------------------------------------------------- arithmetic */
static void bad_op(const char *op, V a, V b) {
    thr("TypeError", "unsupported operand type(s) for %s: '%s' and '%s'", op, tname(a), tname(b));
}
V rt_add(V a, V b) {
    if (ISINT(a) && ISINT(b)) { I r; if (!__builtin_add_overflow(a, b - 1, &r)) return r; thr("OverflowError", "integer overflow"); }
    if (is_num(a) && is_num(b)) {
        if (tagof(a) == T_FLOAT || tagof(b) == T_FLOAT) return rt_mkfloat(tod(a) + tod(b));
        return mkint(toi(a) + toi(b));
    }
    I ta = tagof(a), tb = tagof(b);
    if (ta == T_STR && tb == T_STR) {
        StrO *x = STR(a), *y = STR(b);
        StrO *o = xmalloc(sizeof(StrO) + x->len + y->len + 1);
        o->tag = T_STR; o->len = x->len + y->len;
        memcpy(o->data, x->data, x->len);
        memcpy(o->data + x->len, y->data, y->len);
        o->data[o->len] = 0;
        return (V)o;
    }
    if ((ta == T_LIST && tb == T_LIST) || (ta == T_TUPLE && tb == T_TUPLE)) {
        I n = LST(a)->len + LST(b)->len;
        V r = ta == T_LIST ? mklist(n) : mktuple(n);
        if (ta == T_LIST) {
            LST(r)->len = n;
        }
        memcpy(LST(r)->items, LST(a)->items, sizeof(V) * LST(a)->len);
        memcpy(LST(r)->items + LST(a)->len, LST(b)->items, sizeof(V) * LST(b)->len);
        return r;
    }
    bad_op("+", a, b);
    return 0;
}
V rt_sub(V a, V b) {
    if (ISINT(a) && ISINT(b)) { I r; if (!__builtin_sub_overflow(a, b - 1, &r)) return r; thr("OverflowError", "integer overflow"); }
    if (is_num(a) && is_num(b)) {
        if (tagof(a) == T_FLOAT || tagof(b) == T_FLOAT) return rt_mkfloat(tod(a) - tod(b));
        return mkint(toi(a) - toi(b));
    }
    if (tagof(a) == T_SET && tagof(b) == T_SET) {
        V r = dict_new(T_SET);
        for (I i = 0; i < DCT(a)->used; i++) {
            Ent *e = &DCT(a)->ents[i];
            if (e->k && !dict_find(DCT(b), e->k, e->h)) dict_set(DCT(r), e->k, NONE);
        }
        return r;
    }
    bad_op("-", a, b);
    return 0;
}
static V repeat_seq(V s, I n) {
    if (n < 0) n = 0;
    I t = tagof(s);
    if (t == T_STR) {
        SB sb; sb_init(&sb);
        for (I i = 0; i < n; i++) sb_add(&sb, STR(s)->data, STR(s)->len);
        return sb_str(&sb);
    }
    I len = LST(s)->len;
    V r = t == T_LIST ? mklist(len * n) : mktuple(len * n);
    if (t == T_LIST) LST(r)->len = len * n;
    for (I i = 0; i < n; i++) memcpy(LST(r)->items + i * len, LST(s)->items, sizeof(V) * len);
    return r;
}
V rt_mul(V a, V b) {
    if (ISINT(a) && ISINT(b)) { I r; if (!__builtin_mul_overflow(a - 1, INTV(b), &r)) return r + 1; thr("OverflowError", "integer overflow"); }
    if (is_num(a) && is_num(b)) {
        if (tagof(a) == T_FLOAT || tagof(b) == T_FLOAT) return rt_mkfloat(tod(a) * tod(b));
        I r; if (__builtin_mul_overflow(toi(a), toi(b), &r)) thr("OverflowError", "integer overflow");
        return mkint(r);
    }
    I ta = tagof(a), tb = tagof(b);
    if ((ta == T_STR || ta == T_LIST || ta == T_TUPLE) && is_intlike(b)) return repeat_seq(a, toi(b));
    if ((tb == T_STR || tb == T_LIST || tb == T_TUPLE) && is_intlike(a)) return repeat_seq(b, toi(a));
    bad_op("*", a, b);
    return 0;
}
V rt_truediv(V a, V b) {
    if (!is_num(a) || !is_num(b)) bad_op("/", a, b);
    double y = tod(b);
    if (y == 0) thr("ZeroDivisionError", "division by zero");
    return rt_mkfloat(tod(a) / y);
}
V rt_floordiv(V a, V b) {
    if (!is_num(a) || !is_num(b)) bad_op("//", a, b);
    if (is_intlike(a) && is_intlike(b)) {
        I x = toi(a), y = toi(b);
        if (y == 0) thr("ZeroDivisionError", "integer division or modulo by zero");
        I q = x / y;
        if ((x % y != 0) && ((x < 0) != (y < 0))) q--;
        return mkint(q);
    }
    double y = tod(b);
    if (y == 0) thr("ZeroDivisionError", "float floor division by zero");
    return rt_mkfloat(floor(tod(a) / y));
}
static V pct_format(V fmt, V args);
V rt_mod(V a, V b) {
    if (tagof(a) == T_STR) return pct_format(a, b);
    if (!is_num(a) || !is_num(b)) bad_op("%", a, b);
    if (is_intlike(a) && is_intlike(b)) {
        I x = toi(a), y = toi(b);
        if (y == 0) thr("ZeroDivisionError", "integer division or modulo by zero");
        I r = x % y;
        if (r != 0 && ((r < 0) != (y < 0))) r += y;
        return mkint(r);
    }
    double x = tod(a), y = tod(b);
    if (y == 0) thr("ZeroDivisionError", "float modulo");
    double r = fmod(x, y);
    if (r != 0 && ((r < 0) != (y < 0))) r += y;
    return rt_mkfloat(r);
}
V rt_pow(V a, V b) {
    if (!is_num(a) || !is_num(b)) bad_op("**", a, b);
    if (is_intlike(a) && is_intlike(b) && toi(b) >= 0) {
        I base = toi(a), e = toi(b), r = 1;
        while (e > 0) {
            if (e & 1) { if (__builtin_mul_overflow(r, base, &r)) thr("OverflowError", "integer overflow"); }
            e >>= 1;
            if (e && __builtin_mul_overflow(base, base, &base)) thr("OverflowError", "integer overflow");
        }
        return mkint(r);
    }
    return rt_mkfloat(pow(tod(a), tod(b)));
}
V rt_and(V a, V b) {
    if (tagof(a) == T_SET && tagof(b) == T_SET) {
        V r = dict_new(T_SET);
        for (I i = 0; i < DCT(a)->used; i++) {
            Ent *e = &DCT(a)->ents[i];
            if (e->k && dict_find(DCT(b), e->k, e->h)) dict_set(DCT(r), e->k, NONE);
        }
        return r;
    }
    if (!is_intlike(a) || !is_intlike(b)) bad_op("&", a, b);
    return MKINT(toi(a) & toi(b));
}
V rt_or(V a, V b) {
    if (tagof(a) == T_SET && tagof(b) == T_SET) {
        V r = dict_new(T_SET);
        for (I i = 0; i < DCT(a)->used; i++) if (DCT(a)->ents[i].k) dict_set(DCT(r), DCT(a)->ents[i].k, NONE);
        for (I i = 0; i < DCT(b)->used; i++) if (DCT(b)->ents[i].k) dict_set(DCT(r), DCT(b)->ents[i].k, NONE);
        return r;
    }
    if (!is_intlike(a) || !is_intlike(b)) bad_op("|", a, b);
    return MKINT(toi(a) | toi(b));
}
V rt_xor(V a, V b) { if (!is_intlike(a) || !is_intlike(b)) bad_op("^", a, b); return MKINT(toi(a) ^ toi(b)); }
V rt_lshift(V a, V b) {
    if (!is_intlike(a) || !is_intlike(b)) bad_op("<<", a, b);
    I s = toi(b);
    if (s < 0) thr("ValueError", "negative shift count");
    if (s > 62) thr("OverflowError", "integer overflow");
    I r = toi(a) << s;
    if ((r >> s) != toi(a)) thr("OverflowError", "integer overflow");
    return mkint(r);
}
V rt_rshift(V a, V b) {
    if (!is_intlike(a) || !is_intlike(b)) bad_op(">>", a, b);
    I s = toi(b);
    if (s < 0) thr("ValueError", "negative shift count");
    return MKINT(s > 63 ? (toi(a) < 0 ? -1 : 0) : toi(a) >> s);
}
V rt_neg(V a) {
    if (ISINT(a)) return mkint(-INTV(a));
    if (tagof(a) == T_BOOL) return MKINT(-toi(a));
    if (tagof(a) == T_FLOAT) return rt_mkfloat(-((FloatO *)a)->d);
    thr("TypeError", "bad operand type for unary -: '%s'", tname(a));
}
V rt_invert(V a) { if (!is_intlike(a)) thr("TypeError", "bad operand type for unary ~"); return MKINT(~toi(a)); }
V rt_not(V a) { return B(!rt_truthy(a)); }
I rt_toint(V a) { return toi(a); }

/* ---------------------------------------------------------------- containment / compare */
static I contains(V c, V x) {
    switch (tagof(c)) {
    case T_LIST: case T_TUPLE:
        for (I i = 0; i < LST(c)->len; i++) if (rt_eq_i(LST(c)->items[i], x)) return 1;
        return 0;
    case T_STR: {
        if (tagof(x) != T_STR) thr("TypeError", "'in <string>' requires string as left operand");
        StrO *h = STR(c), *n = STR(x);
        if (n->len == 0) return 1;
        if (n->len > h->len) return 0;
        for (I i = 0; i + n->len <= h->len; i++) if (memcmp(h->data + i, n->data, n->len) == 0) return 1;
        return 0;
    }
    case T_DICT: case T_SET: return dict_get_e(DCT(c), x) != NULL;
    default: thr("TypeError", "argument of type '%s' is not iterable", tname(c));
    }
}
I rt_cmp(I op, V a, V b) {
    switch (op) {
    case 0: return rt_eq_i(a, b);
    case 1: return !rt_eq_i(a, b);
    case 2: return cmp_v(a, b) < 0;
    case 3: return cmp_v(a, b) <= 0;
    case 4: return cmp_v(a, b) > 0;
    case 5: return cmp_v(a, b) >= 0;
    case 6: return contains(b, a);
    case 7: return !contains(b, a);
    case 8: return a == b || (is_intlike(a) && is_intlike(b) && tagof(a) == tagof(b) && toi(a) == toi(b));
    case 9: return !(a == b || (is_intlike(a) && is_intlike(b) && tagof(a) == tagof(b) && toi(a) == toi(b)));
    }
    return 0;
}

/* ---------------------------------------------------------------- constructors for IR */
V rt_list_new(I n, V *items) {
    V l = mklist(n);
    memcpy(LST(l)->items, items, sizeof(V) * n);
    LST(l)->len = n;
    return l;
}
V rt_tuple_new(I n, V *items) {
    V t = mktuple(n);
    memcpy(LST(t)->items, items, sizeof(V) * n);
    return t;
}
V rt_dict_new(I n, V *kv) {
    V d = dict_new(T_DICT);
    for (I i = 0; i < n; i++) dict_set(DCT(d), kv[2 * i], kv[2 * i + 1]);
    return d;
}
V rt_set_new(I n, V *items) {
    V d = dict_new(T_SET);
    for (I i = 0; i < n; i++) dict_set(DCT(d), items[i], NONE);
    return d;
}
V rt_list_append(V l, V x) { list_append(l, x); return NONE; }
V rt_empty_list(void) { return mklist(0); }
V rt_func_new(Fn fn, I nparams, V name, I ndef, V *defs) {
    FuncO *f = xmalloc(sizeof(FuncO));
    f->tag = T_FUNC; f->fn = fn; f->nparams = nparams; f->name = name; f->ndef = ndef;
    if (ndef) { f->defs = xmalloc(sizeof(V) * ndef); memcpy(f->defs, defs, sizeof(V) * ndef); }
    return (V)f;
}
V rt_class_new(V name, V base) { return new_class(name, base); }
V rt_class_set(V cls, V name, V val) { dict_set(DCT(((ClassO *)cls)->dict), name, val); return NONE; }
V rt_fstr(I n, V *parts) {
    SB sb; sb_init(&sb);
    for (I i = 0; i < n; i++) sb_add(&sb, STR(parts[i])->data, STR(parts[i])->len);
    return sb_str(&sb);
}

/* ---------------------------------------------------------------- calls */
static V mkbound(V self, V func) { BoundO *b = xmalloc(sizeof(BoundO)); b->tag = T_BOUND; b->self = self; b->func = func; return (V)b; }

V rt_call(V f, I argc, V *argv) {
    switch (tagof(f)) {
    case T_FUNC: {
        FuncO *fo = (FuncO *)f;
        if (argc < fo->nparams) {
            I missing = fo->nparams - argc;
            if (missing > fo->ndef) thr("TypeError", "%s() missing %lld required positional argument(s)", STR(fo->name)->data, (long long)(missing - fo->ndef));
            V buf[fo->nparams];
            for (I i = 0; i < argc; i++) buf[i] = argv[i];
            for (I i = argc; i < fo->nparams; i++) buf[i] = fo->defs[i - (fo->nparams - fo->ndef)];
            return fo->fn(fo->nparams, buf);
        }
        if (argc > fo->nparams) thr("TypeError", "%s() takes %lld positional argument(s) but %lld were given", STR(fo->name)->data, (long long)fo->nparams, (long long)argc);
        return fo->fn(argc, argv);
    }
    case T_BUILTIN: return ((BuiltinO *)f)->fn(argc, argv);
    case T_BOUND: {
        V buf[argc + 1];
        buf[0] = ((BoundO *)f)->self;
        for (I i = 0; i < argc; i++) buf[i + 1] = argv[i];
        return rt_call(((BoundO *)f)->func, argc + 1, buf);
    }
    case T_CLASS: {
        V inst = new_inst(f);
        V init = class_lookup(f, K_init);
        if (init) {
            V buf[argc + 1];
            buf[0] = inst;
            for (I i = 0; i < argc; i++) buf[i + 1] = argv[i];
            rt_call(init, argc + 1, buf);
        } else if (argc > 0) {
            thr("TypeError", "%s() takes no arguments", STR(((ClassO *)f)->name)->data);
        }
        return inst;
    }
    default: thr("TypeError", "'%s' object is not callable", tname(f));
    }
}

/* ---------------------------------------------------------------- sequences helpers */
static V as_list(V v) {
    switch (tagof(v)) {
    case T_LIST: return v;
    case T_TUPLE: { V l = mklist(LST(v)->len); memcpy(LST(l)->items, LST(v)->items, sizeof(V) * LST(v)->len); LST(l)->len = LST(v)->len; return l; }
    case T_STR: {
        V l = mklist(STR(v)->len);
        for (I i = 0; i < STR(v)->len; i++) list_append(l, mkstr(STR(v)->data + i, 1));
        return l;
    }
    case T_DICT: case T_SET: return dict_keys(DCT(v));
    default: thr("TypeError", "'%s' object is not iterable", tname(v));
    }
}
static V list_copy(V v) {
    V a = as_list(v);
    if (a != v) return a;
    V l = mklist(LST(v)->len);
    memcpy(LST(l)->items, LST(v)->items, sizeof(V) * LST(v)->len);
    LST(l)->len = LST(v)->len;
    return l;
}
V rt_iter_new(V v) {
    IterO *it = xmalloc(sizeof(IterO));
    it->tag = T_ITER; it->i = 0;
    if (tagof(v) == T_LIST || tagof(v) == T_TUPLE) it->seq = v;
    else it->seq = as_list(v);
    return (V)it;
}
I rt_iter_next(V itv, V *out) {
    IterO *it = (IterO *)itv;
    if (it->i >= LST(it->seq)->len) return 0;
    *out = LST(it->seq)->items[it->i++];
    return 1;
}
V rt_unpack(V seq, I n, V *out) {
    V l = as_list(seq);
    if (LST(l)->len != n) {
        if (LST(l)->len < n) thr("ValueError", "not enough values to unpack (expected %lld, got %lld)", (long long)n, (long long)LST(l)->len);
        thr("ValueError", "too many values to unpack (expected %lld)", (long long)n);
    }
    for (I i = 0; i < n; i++) out[i] = LST(l)->items[i];
    return NONE;
}
static I norm_index(V k, I n, const char *what) {
    I i = toi(k);
    if (i < 0) i += n;
    if (i < 0 || i >= n) thr("IndexError", "%s index out of range", what);
    return i;
}
static void slice_idx(V lo, V hi, V st, I n, I *a, I *b, I *s) {
    I step = (st == NONE) ? 1 : toi(st);
    if (step == 0) thr("ValueError", "slice step cannot be zero");
    if (step > 0) {
        I l = lo == NONE ? 0 : toi(lo);
        if (l < 0) { l += n; if (l < 0) l = 0; } else if (l > n) l = n;
        I h = hi == NONE ? n : toi(hi);
        if (h < 0) { h += n; if (h < 0) h = 0; } else if (h > n) h = n;
        *a = l; *b = h;
    } else {
        I l = lo == NONE ? n - 1 : toi(lo);
        if (l < 0) { l += n; if (l < 0) l = -1; } else if (l >= n) l = n - 1;
        I h = hi == NONE ? -1 : toi(hi);
        if (hi != NONE) { if (h < 0) { h += n; if (h < 0) h = -1; } else if (h >= n) h = n - 1; }
        *a = l; *b = h;
    }
    *s = step;
}
V rt_slice(V o, V lo, V hi, V st) {
    I t = tagof(o);
    if (t != T_STR && t != T_LIST && t != T_TUPLE) thr("TypeError", "'%s' object is not subscriptable", tname(o));
    I n = t == T_STR ? STR(o)->len : LST(o)->len, a, b, s;
    slice_idx(lo, hi, st, n, &a, &b, &s);
    I cnt = 0;
    if (s > 0) { if (a < b) cnt = (b - a + s - 1) / s; } else { if (a > b) cnt = (a - b - s - 1) / (-s); }
    if (t == T_STR) {
        if (s == 1) return mkstr(STR(o)->data + a, cnt);
        char *buf = xmalloc(cnt + 1);
        for (I i = 0; i < cnt; i++) buf[i] = STR(o)->data[a + i * s];
        V r = mkstr(buf, cnt);
        return r;
    }
    V r = t == T_LIST ? mklist(cnt) : mktuple(cnt);
    if (t == T_LIST) LST(r)->len = cnt;
    for (I i = 0; i < cnt; i++) LST(r)->items[i] = LST(o)->items[a + i * s];
    return r;
}
V rt_getitem(V o, V k) {
    switch (tagof(o)) {
    case T_LIST: case T_TUPLE: return LST(o)->items[norm_index(k, LST(o)->len, tagof(o) == T_LIST ? "list" : "tuple")];
    case T_STR: { I i = norm_index(k, STR(o)->len, "string"); return mkstr(STR(o)->data + i, 1); }
    case T_DICT: {
        Ent *e = dict_get_e(DCT(o), k);
        if (!e) {
            V r = rt_repr(k);
            thr("KeyError", "%s", STR(r)->data);
        }
        return e->v;
    }
    case T_INST: {
        V m = class_lookup(((InstO *)o)->cls, K_getitem);
        if (m) { V a[2] = {o, k}; return rt_call(m, 2, a); }
        break;
    }
    }
    thr("TypeError", "'%s' object is not subscriptable", tname(o));
}
V rt_setitem(V o, V k, V v) {
    switch (tagof(o)) {
    case T_LIST: LST(o)->items[norm_index(k, LST(o)->len, "list assignment")] = v; return NONE;
    case T_DICT: dict_set(DCT(o), k, v); return NONE;
    case T_INST: {
        V m = class_lookup(((InstO *)o)->cls, K_setitem);
        if (m) { V a[3] = {o, k, v}; rt_call(m, 3, a); return NONE; }
        break;
    }
    }
    thr("TypeError", "'%s' object does not support item assignment", tname(o));
}
V rt_delitem(V o, V k) {
    if (tagof(o) == T_LIST) {
        I i = norm_index(k, LST(o)->len, "list assignment");
        memmove(LST(o)->items + i, LST(o)->items + i + 1, sizeof(V) * (LST(o)->len - i - 1));
        LST(o)->len--;
        return NONE;
    }
    if (tagof(o) == T_DICT) {
        if (!dict_del(DCT(o), k)) { V r = rt_repr(k); thr("KeyError", "%s", STR(r)->data); }
        return NONE;
    }
    thr("TypeError", "'%s' object doesn't support item deletion", tname(o));
}

/* ---------------------------------------------------------------- attributes / modules */
static V sys_argv, sys_stdout, sys_stderr, sys_stdin;
V m_sqrt(I c, V *a) { return rt_mkfloat(sqrt(tod(a[0]))); }
V m_floor(I c, V *a) { return mkint((I)floor(tod(a[0]))); }
V m_ceil(I c, V *a) { return mkint((I)ceil(tod(a[0]))); }
V m_sin(I c, V *a) { return rt_mkfloat(sin(tod(a[0]))); }
V m_cos(I c, V *a) { return rt_mkfloat(cos(tod(a[0]))); }
V m_tan(I c, V *a) { return rt_mkfloat(tan(tod(a[0]))); }
V m_exp(I c, V *a) { return rt_mkfloat(exp(tod(a[0]))); }
V m_fabs(I c, V *a) { return rt_mkfloat(fabs(tod(a[0]))); }
V m_log(I c, V *a) {
    double x = tod(a[0]);
    if (x <= 0) thr("ValueError", "math domain error");
    return rt_mkfloat(c > 1 ? log(x) / log(tod(a[1])) : log(x));
}
V rt_import(V name) {
    ModO *m = xmalloc(sizeof(ModO));
    m->tag = T_MODULE;
    const char *n = STR(name)->data;
    if (!strcmp(n, "sys")) m->id = 1;
    else if (!strcmp(n, "math")) m->id = 2;
    else if (!strcmp(n, "os")) m->id = 3;
    else thr("ImportError", "No module named '%s'", n);
    return (V)m;
}
static V module_attr(ModO *m, const char *nm) {
    if (m->id == 1) {
        if (!strcmp(nm, "argv")) return sys_argv;
        if (!strcmp(nm, "stdout")) return sys_stdout;
        if (!strcmp(nm, "stderr")) return sys_stderr;
        if (!strcmp(nm, "stdin")) return sys_stdin;
        if (!strcmp(nm, "exit")) return mkbuiltin(b_exit, "exit");
        if (!strcmp(nm, "maxsize")) return MKINT(INT_MAX62);
    } else if (m->id == 2) {
        if (!strcmp(nm, "pi")) return rt_mkfloat(3.14159265358979323846);
        if (!strcmp(nm, "e")) return rt_mkfloat(2.71828182845904523536);
        if (!strcmp(nm, "sqrt")) return mkbuiltin(m_sqrt, "sqrt");
        if (!strcmp(nm, "floor")) return mkbuiltin(m_floor, "floor");
        if (!strcmp(nm, "ceil")) return mkbuiltin(m_ceil, "ceil");
        if (!strcmp(nm, "sin")) return mkbuiltin(m_sin, "sin");
        if (!strcmp(nm, "cos")) return mkbuiltin(m_cos, "cos");
        if (!strcmp(nm, "tan")) return mkbuiltin(m_tan, "tan");
        if (!strcmp(nm, "exp")) return mkbuiltin(m_exp, "exp");
        if (!strcmp(nm, "fabs")) return mkbuiltin(m_fabs, "fabs");
        if (!strcmp(nm, "log")) return mkbuiltin(m_log, "log");
    }
    thr("AttributeError", "module has no attribute '%s'", nm);
}
V rt_getattr(V o, V name) {
    switch (tagof(o)) {
    case T_INST: {
        InstO *in = (InstO *)o;
        Ent *e = dict_get_e(DCT(in->attrs), name);
        if (e) return e->v;
        V m = class_lookup(in->cls, name);
        if (m) return (tagof(m) == T_FUNC || tagof(m) == T_BUILTIN) ? mkbound(o, m) : m;
        if (!strcmp(STR(name)->data, "__class__")) return in->cls;
        break;
    }
    case T_CLASS: {
        V m = class_lookup(o, name);
        if (m) return m;
        if (!strcmp(STR(name)->data, "__name__")) return ((ClassO *)o)->name;
        break;
    }
    case T_MODULE: return module_attr((ModO *)o, STR(name)->data);
    }
    thr("AttributeError", "'%s' object has no attribute '%s'", tname(o), STR(name)->data);
}
V rt_setattr(V o, V name, V val) {
    if (tagof(o) == T_INST) { dict_set(DCT(((InstO *)o)->attrs), name, val); return NONE; }
    if (tagof(o) == T_CLASS) { dict_set(DCT(((ClassO *)o)->dict), name, val); return NONE; }
    thr("AttributeError", "'%s' object has no attribute '%s'", tname(o), STR(name)->data);
}

/* ---------------------------------------------------------------- formatting */
static void pad_into(SB *sb, const char *s, I len, int width, int left, char fill) {
    I padn = width > len ? width - len : 0;
    if (!left) for (I i = 0; i < padn; i++) sb_putc(sb, fill);
    sb_add(sb, s, len);
    if (left) for (I i = 0; i < padn; i++) sb_putc(sb, fill);
}
static V pct_format(V fmt, V args) {
    StrO *f = STR(fmt);
    V *items; I n; V one[1];
    if (tagof(args) == T_TUPLE) { items = LST(args)->items; n = LST(args)->len; }
    else { one[0] = args; items = one; n = 1; }
    SB sb; sb_init(&sb);
    I ai = 0;
    for (I i = 0; i < f->len; i++) {
        char c = f->data[i];
        if (c != '%') { sb_putc(&sb, c); continue; }
        i++;
        if (i >= f->len) thr("ValueError", "incomplete format");
        char flags[8]; int nf = 0;
        while (f->data[i] && strchr("-+ 0#", f->data[i])) { if (nf < 7) flags[nf++] = f->data[i]; i++; }
        flags[nf] = 0;
        int width = -1, prec = -1;
        if (f->data[i] == '*') { width = (int)toi(items[ai++]); i++; }
        else if (isdigit((unsigned char)f->data[i])) { width = 0; while (isdigit((unsigned char)f->data[i])) width = width * 10 + (f->data[i++] - '0'); }
        if (f->data[i] == '.') { i++; prec = 0; while (isdigit((unsigned char)f->data[i])) prec = prec * 10 + (f->data[i++] - '0'); }
        char conv = f->data[i];
        if (conv == '%') { sb_putc(&sb, '%'); continue; }
        if (ai >= n) thr("TypeError", "not enough arguments for format string");
        V a = items[ai++];
        int left = strchr(flags, '-') != NULL;
        if (conv == 's' || conv == 'r') {
            V s = conv == 's' ? rt_str(a) : rt_repr(a);
            I len = STR(s)->len;
            if (prec >= 0 && prec < len) len = prec;
            pad_into(&sb, STR(s)->data, len, width, left, ' ');
        } else if (conv == 'd' || conv == 'i' || conv == 'u' || conv == 'x' || conv == 'X' || conv == 'o') {
            I v = is_num(a) ? (tagof(a) == T_FLOAT ? (I)tod(a) : toi(a)) : (thr("TypeError", "%%%c format: a number is required, not %s", conv, tname(a)), 0);
            char fm[32], out[96];
            snprintf(fm, sizeof fm, "%%%s%s%s%s%slld", flags, width >= 0 ? "*" : "", "", "", "");
            if (conv == 'x' || conv == 'X' || conv == 'o') { snprintf(fm, sizeof fm, "%%%s%s ll%c", flags, width >= 0 ? "*" : "", conv); char *sp = strchr(fm, ' '); memmove(sp, sp + 1, strlen(sp)); }
            else if (conv == 'i' || conv == 'u') { /* same as d */ }
            if (width >= 0) snprintf(out, sizeof out, fm, width, (long long)v); else snprintf(out, sizeof out, fm, (long long)v);
            sb_adds(&sb, out);
        } else if (strchr("fFeEgG", conv)) {
            double d = tod(a);
            char fm[32], out[512];
            snprintf(fm, sizeof fm, "%%%s%s%s%c", flags, width >= 0 ? "*" : "", prec >= 0 ? ".*" : "", conv);
            if (width >= 0 && prec >= 0) snprintf(out, sizeof out, fm, width, prec, d);
            else if (width >= 0) snprintf(out, sizeof out, fm, width, d);
            else if (prec >= 0) snprintf(out, sizeof out, fm, prec, d);
            else snprintf(out, sizeof out, fm, d);
            sb_adds(&sb, out);
        } else if (conv == 'c') {
            char ch;
            if (tagof(a) == T_STR) ch = STR(a)->data[0]; else ch = (char)toi(a);
            pad_into(&sb, &ch, 1, width, left, ' ');
        } else {
            thr("ValueError", "unsupported format character '%c'", conv);
        }
    }
    return sb_str(&sb);
}

/* format(value, spec) used by f-strings and str.format */
V rt_format(V val, V spec) {
    StrO *sp = STR(spec);
    const char *s = sp->data;
    I n = sp->len, i = 0;
    char fill = ' ', align = 0, sign = '-', type = 0;
    int width = -1, prec = -1, zero = 0, comma = 0;
    if (n >= 2 && strchr("<>^=", s[1])) { fill = s[0]; align = s[1]; i = 2; }
    else if (n >= 1 && strchr("<>^=", s[0])) { align = s[0]; i = 1; }
    if (i < n && strchr("+- ", s[i])) sign = s[i++];
    if (i < n && s[i] == '#') i++;
    if (i < n && s[i] == '0') { zero = 1; i++; }
    if (i < n && isdigit((unsigned char)s[i])) { width = 0; while (i < n && isdigit((unsigned char)s[i])) width = width * 10 + (s[i++] - '0'); }
    if (i < n && s[i] == ',') { comma = 1; i++; }
    if (i < n && s[i] == '.') { i++; prec = 0; while (i < n && isdigit((unsigned char)s[i])) prec = prec * 10 + (s[i++] - '0'); }
    if (i < n) type = s[i];
    (void)comma;
    SB sb; sb_init(&sb);
    char tmp[512];
    int numeric = 0;
    if (type == 0) type = (tagof(val) == T_STR) ? 's' : (is_intlike(val) ? 'd' : (tagof(val) == T_FLOAT ? 'g' : 's'));
    if (type == 'd' || type == 'x' || type == 'X' || type == 'o' || type == 'b' || type == 'c') {
        I v = toi(val);
        numeric = 1;
        if (type == 'd') snprintf(tmp, sizeof tmp, "%lld", (long long)v);
        else if (type == 'x') snprintf(tmp, sizeof tmp, "%llx", (long long)v);
        else if (type == 'X') snprintf(tmp, sizeof tmp, "%llX", (long long)v);
        else if (type == 'o') snprintf(tmp, sizeof tmp, "%llo", (long long)v);
        else if (type == 'c') { tmp[0] = (char)v; tmp[1] = 0; numeric = 0; }
        else {
            char t2[80]; int k = 0; unsigned long long u = v < 0 ? -v : v;
            if (u == 0) t2[k++] = '0';
            while (u) { t2[k++] = '0' + (u & 1); u >>= 1; }
            int p = 0; if (v < 0) tmp[p++] = '-';
            while (k) tmp[p++] = t2[--k];
            tmp[p] = 0;
        }
    } else if (strchr("fFeEgG%", type)) {
        double d = tod(val);
        numeric = 1;
        if (type == '%') { snprintf(tmp, sizeof tmp, "%.*f%%", prec >= 0 ? prec : 6, d * 100); }
        else if (type == 'g' && prec < 0 && tagof(val) == T_FLOAT) { SB t; sb_init(&t); fmt_float(&t, d); snprintf(tmp, sizeof tmp, "%s", t.p); }
        else { char fm[16]; snprintf(fm, sizeof fm, "%%.*%c", type); snprintf(tmp, sizeof tmp, fm, prec >= 0 ? prec : 6, d); }
    } else {
        V str = rt_str(val);
        I len = STR(str)->len;
        if (prec >= 0 && prec < len) len = prec;
        pad_into(&sb, STR(str)->data, len, width, align != '>' && align != '^', fill);
        if (align == '^') { sb.n = 0; I padn = width > len ? width - len : 0; for (I k = 0; k < padn / 2; k++) sb_putc(&sb, fill); sb_add(&sb, STR(str)->data, len); for (I k = 0; k < padn - padn / 2; k++) sb_putc(&sb, fill); }
        return sb_str(&sb);
    }
    char *num = tmp;
    char signch = 0;
    if (num[0] == '-') { signch = '-'; num++; }
    else if (sign == '+') signch = '+';
    else if (sign == ' ') signch = ' ';
    I len = strlen(num) + (signch ? 1 : 0);
    if (zero && !align) { align = '='; fill = '0'; }
    if (!align) align = numeric ? '>' : '<';
    I padn = width > len ? width - len : 0;
    if (align == '>') { for (I k = 0; k < padn; k++) sb_putc(&sb, fill); if (signch) sb_putc(&sb, signch); sb_adds(&sb, num); }
    else if (align == '<') { if (signch) sb_putc(&sb, signch); sb_adds(&sb, num); for (I k = 0; k < padn; k++) sb_putc(&sb, fill); }
    else if (align == '=') { if (signch) sb_putc(&sb, signch); for (I k = 0; k < padn; k++) sb_putc(&sb, fill); sb_adds(&sb, num); }
    else { for (I k = 0; k < padn / 2; k++) sb_putc(&sb, fill); if (signch) sb_putc(&sb, signch); sb_adds(&sb, num); for (I k = 0; k < padn - padn / 2; k++) sb_putc(&sb, fill); }
    return sb_str(&sb);
}

static V str_format_method(V fmt, I argc, V *argv) {
    StrO *f = STR(fmt);
    SB sb; sb_init(&sb);
    I auto_i = 0;
    for (I i = 0; i < f->len; i++) {
        char c = f->data[i];
        if (c == '{' && i + 1 < f->len && f->data[i + 1] == '{') { sb_putc(&sb, '{'); i++; continue; }
        if (c == '}' && i + 1 < f->len && f->data[i + 1] == '}') { sb_putc(&sb, '}'); i++; continue; }
        if (c != '{') { sb_putc(&sb, c); continue; }
        I j = i + 1;
        while (j < f->len && f->data[j] != '}') j++;
        if (j >= f->len) thr("ValueError", "Single '{' encountered in format string");
        char field[128]; I fl = j - i - 1; if (fl > 127) fl = 127;
        memcpy(field, f->data + i + 1, fl); field[fl] = 0;
        char *spec = strchr(field, ':'); char conv = 0;
        if (spec) { *spec++ = 0; } else spec = (char *)"";
        char *bang = strchr(field, '!');
        if (bang) { conv = bang[1]; *bang = 0; }
        I idx;
        if (field[0]) idx = atoi(field); else idx = auto_i++;
        if (idx >= argc) thr("IndexError", "Replacement index %lld out of range", (long long)idx);
        V v = argv[idx];
        if (conv == 'r') v = rt_repr(v); else if (conv == 's') v = rt_str(v);
        V r = rt_format(v, mkstr(spec, strlen(spec)));
        sb_add(&sb, STR(r)->data, STR(r)->len);
        i = j;
    }
    return sb_str(&sb);
}

/* ---------------------------------------------------------------- print / files */
static FILE *file_of(V f) {
    if (f == NONE || f == 0) return stdout;
    if (tagof(f) != T_FILE) thr("TypeError", "file argument must be a file");
    return ((FileO *)f)->f;
}
V rt_print(I argc, V *argv, V sep, V end, V file) {
    FILE *fp = file_of(file);
    if (fp == stderr) fflush(stdout);
    V s = sep == NONE ? S(" ") : sep, e = end == NONE ? S("\n") : end;
    for (I i = 0; i < argc; i++) {
        if (i) fwrite(STR(s)->data, 1, STR(s)->len, fp);
        V t = rt_str(argv[i]);
        fwrite(STR(t)->data, 1, STR(t)->len, fp);
    }
    fwrite(STR(e)->data, 1, STR(e)->len, fp);
    return NONE;
}
V b_print(I argc, V *argv) { return rt_print(argc, argv, NONE, NONE, NONE); }
V b_open(I argc, V *argv) {
    const char *mode = argc > 1 ? STR(argv[1])->data : "r";
    FILE *f = fopen(STR(argv[0])->data, mode);
    if (!f) thr("FileNotFoundError", "[Errno 2] No such file or directory: '%s'", STR(argv[0])->data);
    return mkfile(f);
}
V b_input(I argc, V *argv) {
    if (argc > 0) { V s = rt_str(argv[0]); fwrite(STR(s)->data, 1, STR(s)->len, stdout); fflush(stdout); }
    SB sb; sb_init(&sb);
    int c; int got = 0;
    while ((c = fgetc(stdin)) != EOF) { got = 1; if (c == '\n') break; sb_putc(&sb, c); }
    if (!got) thr("EOFError", "EOF when reading a line");
    return sb_str(&sb);
}
static V file_read_all(FILE *f) {
    SB sb; sb_init(&sb);
    char buf[4096]; size_t n;
    while ((n = fread(buf, 1, sizeof buf, f)) > 0) sb_add(&sb, buf, n);
    return sb_str(&sb);
}
static V file_readline(FILE *f) {
    SB sb; sb_init(&sb);
    int c;
    while ((c = fgetc(f)) != EOF) { sb_putc(&sb, c); if (c == '\n') break; }
    return sb_str(&sb);
}
V b_exit(I argc, V *argv) {
    int code = 0;
    if (argc > 0) {
        if (ISINT(argv[0])) code = (int)INTV(argv[0]);
        else if (argv[0] != NONE) { V s = rt_str(argv[0]); fflush(stdout); fprintf(stderr, "%s\n", STR(s)->data); code = 1; }
    }
    fflush(stdout);
    exit(code);
}

/* ---------------------------------------------------------------- builtins */
V b_len(I argc, V *argv) {
    V v = argv[0];
    switch (tagof(v)) {
    case T_STR: return MKINT(STR(v)->len);
    case T_LIST: case T_TUPLE: return MKINT(LST(v)->len);
    case T_DICT: case T_SET: return MKINT(DCT(v)->n);
    case T_INST: {
        V m = class_lookup(((InstO *)v)->cls, K_len);
        if (m) { V a[1] = {v}; return rt_call(m, 1, a); }
    }
    }
    thr("TypeError", "object of type '%s' has no len()", tname(v));
}
V b_range(I argc, V *argv) {
    I a = 0, b, s = 1;
    if (argc == 1) b = toi(argv[0]);
    else { a = toi(argv[0]); b = toi(argv[1]); if (argc > 2) s = toi(argv[2]); }
    if (s == 0) thr("ValueError", "range() arg 3 must not be zero");
    V l = mklist(8);
    if (s > 0) for (I i = a; i < b; i += s) list_append(l, MKINT(i));
    else for (I i = a; i > b; i += s) list_append(l, MKINT(i));
    return l;
}
V b_int(I argc, V *argv) {
    if (argc == 0) return MKINT(0);
    V v = argv[0];
    if (ISINT(v)) return v;
    switch (tagof(v)) {
    case T_BOOL: return MKINT(((BoolO *)v)->b);
    case T_FLOAT: {
        double d = ((FloatO *)v)->d;
        if (isnan(d) || isinf(d)) thr("ValueError", "cannot convert float to integer");
        return mkint((I)d);
    }
    case T_STR: {
        int base = argc > 1 ? (int)toi(argv[1]) : 10;
        const char *p = STR(v)->data;
        while (isspace((unsigned char)*p)) p++;
        char *end;
        const char *start = p;
        if (*p == '\0') thr("ValueError", "invalid literal for int() with base %d: %s", base, STR(rt_repr(v))->data);
        long long r = strtoll(p, &end, base);
        while (isspace((unsigned char)*end)) end++;
        if (end == start || *end != '\0') thr("ValueError", "invalid literal for int() with base %d: %s", base, STR(rt_repr(v))->data);
        return mkint(r);
    }
    }
    thr("TypeError", "int() argument must be a string or a number, not '%s'", tname(v));
}
V b_float(I argc, V *argv) {
    if (argc == 0) return rt_mkfloat(0);
    V v = argv[0];
    if (is_num(v)) return rt_mkfloat(tod(v));
    if (tagof(v) == T_STR) {
        char *end;
        const char *p = STR(v)->data;
        double d = strtod(p, &end);
        while (isspace((unsigned char)*end)) end++;
        if (end == p || *end) thr("ValueError", "could not convert string to float: %s", STR(rt_repr(v))->data);
        return rt_mkfloat(d);
    }
    thr("TypeError", "float() argument must be a string or a number");
}
V b_str(I argc, V *argv) { return argc ? rt_str(argv[0]) : mkstr("", 0); }
V b_bool(I argc, V *argv) { return argc ? B(rt_truthy(argv[0])) : rt_false_v; }
V b_list(I argc, V *argv) { return argc ? list_copy(argv[0]) : mklist(0); }
V b_tuple(I argc, V *argv) {
    if (!argc) return mktuple(0);
    V l = as_list(argv[0]);
    V t = mktuple(LST(l)->len);
    memcpy(LST(t)->items, LST(l)->items, sizeof(V) * LST(l)->len);
    return t;
}
V b_dict(I argc, V *argv) {
    V d = dict_new(T_DICT);
    if (argc && tagof(argv[0]) == T_DICT) {
        for (I i = 0; i < DCT(argv[0])->used; i++) if (DCT(argv[0])->ents[i].k) dict_set(DCT(d), DCT(argv[0])->ents[i].k, DCT(argv[0])->ents[i].v);
    } else if (argc) {
        V l = as_list(argv[0]);
        for (I i = 0; i < LST(l)->len; i++) {
            V p = as_list(LST(l)->items[i]);
            if (LST(p)->len != 2) thr("ValueError", "dictionary update sequence element has wrong length");
            dict_set(DCT(d), LST(p)->items[0], LST(p)->items[1]);
        }
    }
    return d;
}
V b_set(I argc, V *argv) {
    V d = dict_new(T_SET);
    if (argc) {
        V l = as_list(argv[0]);
        for (I i = 0; i < LST(l)->len; i++) dict_set(DCT(d), LST(l)->items[i], NONE);
    }
    return d;
}
static I isinst1(V obj, V t) {
    if (tagof(t) == T_TUPLE) {
        for (I i = 0; i < LST(t)->len; i++) if (isinst1(obj, LST(t)->items[i])) return 1;
        return 0;
    }
    if (tagof(t) == T_CLASS) return inst_of(obj, t);
    if (tagof(t) == T_BUILTIN) {
        Fn f = ((BuiltinO *)t)->fn;
        I g = tagof(obj);
        if (f == b_int) return g == T_INT || g == T_BOOL;
        if (f == b_float) return g == T_FLOAT;
        if (f == b_str) return g == T_STR;
        if (f == b_bool) return g == T_BOOL;
        if (f == b_list) return g == T_LIST;
        if (f == b_tuple) return g == T_TUPLE;
        if (f == b_dict) return g == T_DICT;
        if (f == b_set) return g == T_SET;
    }
    return 0;
}
V b_isinstance(I argc, V *argv) { return B(isinst1(argv[0], argv[1])); }
V b_abs(I argc, V *argv) {
    V v = argv[0];
    if (ISINT(v)) return INTV(v) < 0 ? mkint(-INTV(v)) : v;
    if (tagof(v) == T_FLOAT) return rt_mkfloat(fabs(((FloatO *)v)->d));
    if (tagof(v) == T_BOOL) return MKINT(toi(v));
    thr("TypeError", "bad operand type for abs()");
}
static V minmax(I argc, V *argv, int sign) {
    V l; I n; V *items;
    if (argc == 1) { l = as_list(argv[0]); items = LST(l)->items; n = LST(l)->len; }
    else { items = argv; n = argc; }
    if (n == 0) thr("ValueError", "min()/max() arg is an empty sequence");
    V best = items[0];
    for (I i = 1; i < n; i++) if (cmp_v(items[i], best) * sign > 0) best = items[i];
    return best;
}
V b_min(I argc, V *argv) { return minmax(argc, argv, -1); }
V b_max(I argc, V *argv) { return minmax(argc, argv, 1); }
V b_sum(I argc, V *argv) {
    V l = as_list(argv[0]);
    V acc = argc > 1 ? argv[1] : MKINT(0);
    for (I i = 0; i < LST(l)->len; i++) acc = rt_add(acc, LST(l)->items[i]);
    return acc;
}
V b_round(I argc, V *argv) {
    double d = tod(argv[0]);
    if (argc > 1 && argv[1] != NONE) {
        I nd = toi(argv[1]);
        if (nd < 0) nd = 0;
        if (nd > 300) nd = 300;
        char buf[512];
        snprintf(buf, sizeof buf, "%.*f", (int)nd, d);
        return rt_mkfloat(strtod(buf, NULL));
    }
    return mkint((I)rint(d));
}
static void msort(V *a, V *tmp, I n) {
    if (n < 2) return;
    I m = n / 2;
    msort(a, tmp, m);
    msort(a + m, tmp, n - m);
    I i = 0, j = m, k = 0;
    while (i < m && j < n) { if (cmp_v(a[j], a[i]) < 0) tmp[k++] = a[j++]; else tmp[k++] = a[i++]; }
    while (i < m) tmp[k++] = a[i++];
    while (j < n) tmp[k++] = a[j++];
    memcpy(a, tmp, sizeof(V) * n);
}
static void list_sort(V l) {
    I n = LST(l)->len;
    V *tmp = xmalloc(sizeof(V) * (n ? n : 1));
    msort(LST(l)->items, tmp, n);
}
V b_sorted(I argc, V *argv) { V l = list_copy(argv[0]); list_sort(l); return l; }
V b_reversed(I argc, V *argv) {
    V l = list_copy(argv[0]);
    for (I i = 0, j = LST(l)->len - 1; i < j; i++, j--) { V t = LST(l)->items[i]; LST(l)->items[i] = LST(l)->items[j]; LST(l)->items[j] = t; }
    return l;
}
V b_enumerate(I argc, V *argv) {
    V l = as_list(argv[0]);
    I start = argc > 1 ? toi(argv[1]) : 0;
    V r = mklist(LST(l)->len);
    for (I i = 0; i < LST(l)->len; i++) list_append(r, tuple2(MKINT(start + i), LST(l)->items[i]));
    return r;
}
V b_zip(I argc, V *argv) {
    if (argc == 0) return mklist(0);
    V ls[argc];
    I n = -1;
    for (I i = 0; i < argc; i++) { ls[i] = as_list(argv[i]); if (n < 0 || LST(ls[i])->len < n) n = LST(ls[i])->len; }
    V r = mklist(n);
    for (I i = 0; i < n; i++) {
        V t = mktuple(argc);
        for (I j = 0; j < argc; j++) LST(t)->items[j] = LST(ls[j])->items[i];
        list_append(r, t);
    }
    return r;
}
V b_map(I argc, V *argv) {
    V l = as_list(argv[1]);
    V r = mklist(LST(l)->len);
    for (I i = 0; i < LST(l)->len; i++) { V a[1] = {LST(l)->items[i]}; list_append(r, rt_call(argv[0], 1, a)); }
    return r;
}
V b_filter(I argc, V *argv) {
    V l = as_list(argv[1]);
    V r = mklist(4);
    for (I i = 0; i < LST(l)->len; i++) {
        V a[1] = {LST(l)->items[i]};
        I keep = argv[0] == NONE ? rt_truthy(a[0]) : rt_truthy(rt_call(argv[0], 1, a));
        if (keep) list_append(r, a[0]);
    }
    return r;
}
V b_any(I argc, V *argv) { V l = as_list(argv[0]); for (I i = 0; i < LST(l)->len; i++) if (rt_truthy(LST(l)->items[i])) return rt_true_v; return rt_false_v; }
V b_all(I argc, V *argv) { V l = as_list(argv[0]); for (I i = 0; i < LST(l)->len; i++) if (!rt_truthy(LST(l)->items[i])) return rt_false_v; return rt_true_v; }
V b_chr(I argc, V *argv) { char c = (char)toi(argv[0]); return mkstr(&c, 1); }
V b_ord(I argc, V *argv) {
    if (tagof(argv[0]) != T_STR || STR(argv[0])->len != 1) thr("TypeError", "ord() expected a character");
    return MKINT((unsigned char)STR(argv[0])->data[0]);
}
static V based(I v, const char *prefix, int base) {
    char buf[96]; int k = 0; unsigned long long u = v < 0 ? -v : v;
    char t[80];
    if (u == 0) t[k++] = '0';
    while (u) { int d = u % base; t[k++] = d < 10 ? '0' + d : 'a' + d - 10; u /= base; }
    int p = 0; if (v < 0) buf[p++] = '-';
    for (const char *q = prefix; *q; q++) buf[p++] = *q;
    while (k) buf[p++] = t[--k];
    buf[p] = 0;
    return S(buf);
}
V b_hex(I argc, V *argv) { return based(toi(argv[0]), "0x", 16); }
V b_oct(I argc, V *argv) { return based(toi(argv[0]), "0o", 8); }
V b_bin(I argc, V *argv) { return based(toi(argv[0]), "0b", 2); }
V b_repr(I argc, V *argv) { return rt_repr(argv[0]); }
V b_divmod(I argc, V *argv) { return tuple2(rt_floordiv(argv[0], argv[1]), rt_mod(argv[0], argv[1])); }
V b_pow(I argc, V *argv) { return rt_pow(argv[0], argv[1]); }
V b_hasattr(I argc, V *argv) {
    V o = argv[0];
    if (tagof(o) == T_INST) {
        if (dict_get_e(DCT(((InstO *)o)->attrs), argv[1])) return rt_true_v;
        return B(class_lookup(((InstO *)o)->cls, argv[1]) != 0);
    }
    return rt_false_v;
}
V b_getattr(I argc, V *argv) {
    if (argc > 2 && b_hasattr(2, argv) == rt_false_v) return argv[2];
    return rt_getattr(argv[0], argv[1]);
}
V b_setattr(I argc, V *argv) { return rt_setattr(argv[0], argv[1], argv[2]); }
V b_callable(I argc, V *argv) { I t = tagof(argv[0]); return B(t == T_FUNC || t == T_BUILTIN || t == T_BOUND || t == T_CLASS); }

/* ---------------------------------------------------------------- method dispatch for builtin types */
#define M(s) (strcmp(nm, s) == 0)
static void argn(I argc, I lo, I hi, const char *nm) {
    if (argc < lo || argc > hi) thr("TypeError", "%s() takes %lld to %lld arguments", nm, (long long)lo, (long long)hi);
}
static I str_find(StrO *h, StrO *n, I start) {
    if (start < 0) start = 0;
    for (I i = start; i + n->len <= h->len; i++) if (memcmp(h->data + i, n->data, n->len) == 0) return i;
    return -1;
}
static V meth_str(V self, const char *nm, I argc, V *argv) {
    StrO *s = STR(self);
    if (M("join")) {
        V l = as_list(argv[0]);
        SB sb; sb_init(&sb);
        for (I i = 0; i < LST(l)->len; i++) {
            if (i) sb_add(&sb, s->data, s->len);
            V it = LST(l)->items[i];
            if (tagof(it) != T_STR) thr("TypeError", "sequence item %lld: expected str instance, %s found", (long long)i, tname(it));
            sb_add(&sb, STR(it)->data, STR(it)->len);
        }
        return sb_str(&sb);
    }
    if (M("split")) {
        V r = mklist(4);
        I maxs = argc > 1 ? toi(argv[1]) : -1;
        if (argc == 0 || argv[0] == NONE) {
            I i = 0;
            while (1) {
                while (i < s->len && isspace((unsigned char)s->data[i])) i++;
                if (i >= s->len) break;
                if (maxs == 0) { I e = s->len; while (e > i && isspace((unsigned char)s->data[e - 1])) e--; list_append(r, mkstr(s->data + i, e - i)); break; }
                I j = i;
                while (j < s->len && !isspace((unsigned char)s->data[j])) j++;
                list_append(r, mkstr(s->data + i, j - i));
                i = j;
                if (maxs > 0) maxs--;
            }
            return r;
        }
        StrO *sep = STR(argv[0]);
        if (sep->len == 0) thr("ValueError", "empty separator");
        I i = 0;
        while (1) {
            I j = (maxs == 0) ? -1 : str_find(s, sep, i);
            if (j < 0) { list_append(r, mkstr(s->data + i, s->len - i)); break; }
            list_append(r, mkstr(s->data + i, j - i));
            i = j + sep->len;
            if (maxs > 0) maxs--;
        }
        return r;
    }
    if (M("strip") || M("lstrip") || M("rstrip")) {
        const char *chars = argc > 0 && argv[0] != NONE ? STR(argv[0])->data : " \t\n\r\v\f";
        I a = 0, b = s->len;
        if (nm[0] != 'r') while (a < b && strchr(chars, s->data[a])) a++;
        if (nm[0] != 'l') while (b > a && strchr(chars, s->data[b - 1])) b--;
        return mkstr(s->data + a, b - a);
    }
    if (M("startswith") || M("endswith")) {
        int st = nm[0] == 's';
        V p = argv[0];
        V cands = tagof(p) == T_TUPLE ? p : 0;
        I nc = cands ? LST(cands)->len : 1;
        for (I i = 0; i < nc; i++) {
            StrO *x = STR(cands ? LST(cands)->items[i] : p);
            if (x->len > s->len) continue;
            if (st ? memcmp(s->data, x->data, x->len) == 0 : memcmp(s->data + s->len - x->len, x->data, x->len) == 0) return rt_true_v;
        }
        return rt_false_v;
    }
    if (M("find")) return MKINT(str_find(s, STR(argv[0]), argc > 1 ? toi(argv[1]) : 0));
    if (M("rfind")) {
        StrO *n = STR(argv[0]);
        for (I i = s->len - n->len; i >= 0; i--) if (memcmp(s->data + i, n->data, n->len) == 0) return MKINT(i);
        return MKINT(-1);
    }
    if (M("index")) {
        I r = str_find(s, STR(argv[0]), argc > 1 ? toi(argv[1]) : 0);
        if (r < 0) thr("ValueError", "substring not found");
        return MKINT(r);
    }
    if (M("count")) {
        StrO *n = STR(argv[0]); I c = 0, i = 0;
        if (n->len == 0) return MKINT(s->len + 1);
        while ((i = str_find(s, n, i)) >= 0) { c++; i += n->len; }
        return MKINT(c);
    }
    if (M("replace")) {
        StrO *o = STR(argv[0]), *n = STR(argv[1]);
        I maxc = argc > 2 ? toi(argv[2]) : -1;
        if (o->len == 0) thr("ValueError", "empty pattern in replace not supported");
        SB sb; sb_init(&sb);
        I i = 0;
        while (1) {
            I j = (maxc == 0) ? -1 : str_find(s, o, i);
            if (j < 0) { sb_add(&sb, s->data + i, s->len - i); break; }
            sb_add(&sb, s->data + i, j - i);
            sb_add(&sb, n->data, n->len);
            i = j + o->len;
            if (maxc > 0) maxc--;
        }
        return sb_str(&sb);
    }
    if (M("upper") || M("lower")) {
        char *buf = xmalloc(s->len + 1);
        for (I i = 0; i < s->len; i++) buf[i] = nm[0] == 'u' ? toupper((unsigned char)s->data[i]) : tolower((unsigned char)s->data[i]);
        return mkstr(buf, s->len);
    }
    if (M("capitalize")) {
        char *buf = xmalloc(s->len + 1);
        for (I i = 0; i < s->len; i++) buf[i] = i ? tolower((unsigned char)s->data[i]) : toupper((unsigned char)s->data[i]);
        return mkstr(buf, s->len);
    }
    if (M("isdigit") || M("isalpha") || M("isalnum") || M("isspace") || M("isupper") || M("islower")) {
        if (s->len == 0) return rt_false_v;
        int anycase = 0;
        for (I i = 0; i < s->len; i++) {
            unsigned char c = s->data[i];
            int ok = nm[2] == 'd' ? isdigit(c) : nm[2] == 'a' && nm[3] == 'l' && nm[4] == 'p' ? isalpha(c) : nm[2] == 'a' ? isalnum(c) : nm[2] == 's' ? isspace(c) : nm[2] == 'u' ? (isupper(c) || !isalpha(c)) : (islower(c) || !isalpha(c));
            if (isalpha(c)) anycase = 1;
            if (!ok) return rt_false_v;
        }
        if ((nm[2] == 'u' || nm[2] == 'l') && !anycase) return rt_false_v;
        return rt_true_v;
    }
    if (M("ljust") || M("rjust") || M("center")) {
        I w = toi(argv[0]);
        char fill = argc > 1 ? STR(argv[1])->data[0] : ' ';
        SB sb; sb_init(&sb);
        I padn = w > s->len ? w - s->len : 0;
        I l = nm[0] == 'r' ? padn : nm[0] == 'c' ? padn / 2 : 0;
        for (I i = 0; i < l; i++) sb_putc(&sb, fill);
        sb_add(&sb, s->data, s->len);
        for (I i = 0; i < padn - l; i++) sb_putc(&sb, fill);
        return sb_str(&sb);
    }
    if (M("zfill")) {
        I w = toi(argv[0]);
        SB sb; sb_init(&sb);
        I padn = w > s->len ? w - s->len : 0;
        I k = 0;
        if (s->len && (s->data[0] == '-' || s->data[0] == '+')) { sb_putc(&sb, s->data[0]); k = 1; }
        for (I i = 0; i < padn; i++) sb_putc(&sb, '0');
        sb_add(&sb, s->data + k, s->len - k);
        return sb_str(&sb);
    }
    if (M("splitlines")) {
        V r = mklist(4); I i = 0;
        while (i < s->len) {
            I j = i;
            while (j < s->len && s->data[j] != '\n') j++;
            list_append(r, mkstr(s->data + i, j - i));
            i = j + 1;
        }
        return r;
    }
    if (M("encode") || M("decode")) return self;
    if (M("format")) return str_format_method(self, argc, argv);
    thr("AttributeError", "'str' object has no attribute '%s'", nm);
}
static V meth_list(V self, const char *nm, I argc, V *argv) {
    ListO *l = LST(self);
    if (M("append")) { list_append(self, argv[0]); return NONE; }
    if (M("extend")) { V o = list_copy(argv[0]); for (I i = 0; i < LST(o)->len; i++) list_append(self, LST(o)->items[i]); return NONE; }
    if (M("pop")) {
        if (l->len == 0) thr("IndexError", "pop from empty list");
        I i = argc ? norm_index(argv[0], l->len, "pop") : l->len - 1;
        V r = l->items[i];
        memmove(l->items + i, l->items + i + 1, sizeof(V) * (l->len - i - 1));
        l->len--;
        return r;
    }
    if (M("insert")) {
        I i = toi(argv[0]);
        if (i < 0) { i += l->len; if (i < 0) i = 0; }
        if (i > l->len) i = l->len;
        list_append(self, NONE);
        memmove(l->items + i + 1, l->items + i, sizeof(V) * (l->len - 1 - i));
        l->items[i] = argv[1];
        return NONE;
    }
    if (M("remove")) {
        for (I i = 0; i < l->len; i++) if (rt_eq_i(l->items[i], argv[0])) {
            memmove(l->items + i, l->items + i + 1, sizeof(V) * (l->len - i - 1));
            l->len--;
            return NONE;
        }
        thr("ValueError", "list.remove(x): x not in list");
    }
    if (M("index")) {
        for (I i = 0; i < l->len; i++) if (rt_eq_i(l->items[i], argv[0])) return MKINT(i);
        thr("ValueError", "value is not in list");
    }
    if (M("count")) { I c = 0; for (I i = 0; i < l->len; i++) if (rt_eq_i(l->items[i], argv[0])) c++; return MKINT(c); }
    if (M("reverse")) {
        for (I i = 0, j = l->len - 1; i < j; i++, j--) { V t = l->items[i]; l->items[i] = l->items[j]; l->items[j] = t; }
        return NONE;
    }
    if (M("sort")) { list_sort(self); return NONE; }
    if (M("copy")) return list_copy(self);
    if (M("clear")) { l->len = 0; return NONE; }
    thr("AttributeError", "'list' object has no attribute '%s'", nm);
}
static V meth_tuple(V self, const char *nm, I argc, V *argv) {
    ListO *l = LST(self);
    if (M("index")) { for (I i = 0; i < l->len; i++) if (rt_eq_i(l->items[i], argv[0])) return MKINT(i); thr("ValueError", "tuple.index(x): x not in tuple"); }
    if (M("count")) { I c = 0; for (I i = 0; i < l->len; i++) if (rt_eq_i(l->items[i], argv[0])) c++; return MKINT(c); }
    thr("AttributeError", "'tuple' object has no attribute '%s'", nm);
}
static V meth_dict(V self, const char *nm, I argc, V *argv) {
    DictO *d = DCT(self);
    if (M("get")) { Ent *e = dict_get_e(d, argv[0]); return e ? e->v : (argc > 1 ? argv[1] : NONE); }
    if (M("keys")) return dict_keys(d);
    if (M("values")) { V l = mklist(d->n); for (I i = 0; i < d->used; i++) if (d->ents[i].k) list_append(l, d->ents[i].v); return l; }
    if (M("items")) { V l = mklist(d->n); for (I i = 0; i < d->used; i++) if (d->ents[i].k) list_append(l, tuple2(d->ents[i].k, d->ents[i].v)); return l; }
    if (M("pop")) {
        Ent *e = dict_get_e(d, argv[0]);
        if (!e) { if (argc > 1) return argv[1]; V r = rt_repr(argv[0]); thr("KeyError", "%s", STR(r)->data); }
        V v = e->v; dict_del(d, argv[0]); return v;
    }
    if (M("setdefault")) {
        Ent *e = dict_get_e(d, argv[0]);
        if (e) return e->v;
        V v = argc > 1 ? argv[1] : NONE;
        dict_set(d, argv[0], v);
        return v;
    }
    if (M("update")) {
        DictO *o = DCT(argv[0]);
        for (I i = 0; i < o->used; i++) if (o->ents[i].k) dict_set(d, o->ents[i].k, o->ents[i].v);
        return NONE;
    }
    if (M("copy")) { V r = dict_new(T_DICT); for (I i = 0; i < d->used; i++) if (d->ents[i].k) dict_set(DCT(r), d->ents[i].k, d->ents[i].v); return r; }
    if (M("clear")) { d->n = 0; d->used = 0; d->cap = 0; d->icap = 0; d->ents = NULL; d->idx = NULL; return NONE; }
    thr("AttributeError", "'dict' object has no attribute '%s'", nm);
}
static V meth_set(V self, const char *nm, I argc, V *argv) {
    DictO *d = DCT(self);
    if (M("add")) { dict_set(d, argv[0], NONE); return NONE; }
    if (M("discard")) { dict_del(d, argv[0]); return NONE; }
    if (M("remove")) { if (!dict_del(d, argv[0])) { V r = rt_repr(argv[0]); thr("KeyError", "%s", STR(r)->data); } return NONE; }
    if (M("copy")) { V r = dict_new(T_SET); for (I i = 0; i < d->used; i++) if (d->ents[i].k) dict_set(DCT(r), d->ents[i].k, NONE); return r; }
    if (M("update")) { V l = as_list(argv[0]); for (I i = 0; i < LST(l)->len; i++) dict_set(d, LST(l)->items[i], NONE); return NONE; }
    if (M("union")) return rt_or(self, argv[0]);
    if (M("intersection")) return rt_and(self, argv[0]);
    if (M("difference")) return rt_sub(self, argv[0]);
    thr("AttributeError", "'set' object has no attribute '%s'", nm);
}
static V meth_file(V self, const char *nm, I argc, V *argv) {
    FILE *f = ((FileO *)self)->f;
    if (M("read")) return file_read_all(f);
    if (M("readline")) return file_readline(f);
    if (M("readlines")) {
        V r = mklist(8);
        while (1) { V ln = file_readline(f); if (STR(ln)->len == 0) break; list_append(r, ln); }
        return r;
    }
    if (M("write")) {
        if (tagof(argv[0]) != T_STR) thr("TypeError", "write() argument must be str");
        if (f == stderr) fflush(stdout);
        fwrite(STR(argv[0])->data, 1, STR(argv[0])->len, f);
        return MKINT(STR(argv[0])->len);
    }
    if (M("flush")) { fflush(f); return NONE; }
    if (M("close")) { if (f != stdout && f != stderr && f != stdin) fclose(f); return NONE; }
    thr("AttributeError", "'file' object has no attribute '%s'", nm);
}
V rt_callmeth(V o, V name, I argc, V *argv) {
    const char *nm = STR(name)->data;
    switch (tagof(o)) {
    case T_INST: {
        InstO *in = (InstO *)o;
        V m = class_lookup(in->cls, name);
        if (m && (tagof(m) == T_FUNC || tagof(m) == T_BUILTIN)) {
            V buf[argc + 1];
            buf[0] = o;
            for (I i = 0; i < argc; i++) buf[i + 1] = argv[i];
            return rt_call(m, argc + 1, buf);
        }
        Ent *e = dict_get_e(DCT(in->attrs), name);
        if (e) return rt_call(e->v, argc, argv);
        if (m) return rt_call(m, argc, argv);
        break;
    }
    case T_CLASS: return rt_call(rt_getattr(o, name), argc, argv);
    case T_MODULE: return rt_call(rt_getattr(o, name), argc, argv);
    case T_STR: return meth_str(o, nm, argc, argv);
    case T_LIST: return meth_list(o, nm, argc, argv);
    case T_TUPLE: return meth_tuple(o, nm, argc, argv);
    case T_DICT: return meth_dict(o, nm, argc, argv);
    case T_SET: return meth_set(o, nm, argc, argv);
    case T_FILE: return meth_file(o, nm, argc, argv);
    }
    thr("AttributeError", "'%s' object has no attribute '%s'", tname(o), nm);
}
V rt_with_exit(V o) { if (tagof(o) == T_FILE) meth_file(o, "close", 0, NULL); return NONE; }

/* ---------------------------------------------------------------- builtin table (for names used as values) */
typedef struct { const char *name; Fn fn; } BEnt;
static BEnt btab[] = {
    {"len", b_len}, {"range", b_range}, {"int", b_int}, {"float", b_float}, {"str", b_str}, {"bool", b_bool},
    {"list", b_list}, {"tuple", b_tuple}, {"dict", b_dict}, {"set", b_set}, {"isinstance", b_isinstance},
    {"abs", b_abs}, {"min", b_min}, {"max", b_max}, {"sum", b_sum}, {"round", b_round}, {"sorted", b_sorted},
    {"reversed", b_reversed}, {"enumerate", b_enumerate}, {"zip", b_zip}, {"map", b_map}, {"filter", b_filter},
    {"any", b_any}, {"all", b_all}, {"chr", b_chr}, {"ord", b_ord}, {"hex", b_hex}, {"bin", b_bin}, {"oct", b_oct},
    {"repr", b_repr}, {"open", b_open}, {"input", b_input}, {"exit", b_exit}, {"quit", b_exit},
    {"divmod", b_divmod}, {"pow", b_pow}, {"hasattr", b_hasattr}, {"getattr", b_getattr}, {"setattr", b_setattr},
    {"callable", b_callable}, {"print", b_print}, {NULL, NULL}
};
V rt_getbuiltin(const char *name) {
    for (int i = 0; btab[i].name; i++) if (!strcmp(btab[i].name, name)) return mkbuiltin(btab[i].fn, btab[i].name);
    for (int i = 0; i < nexc; i++) if (!strcmp(exc_nm[i], name)) return exc_cls[i];
    thr("NameError", "name '%s' is not defined", name);
}

/* ---------------------------------------------------------------- init */
static void def_exc(const char *name, const char *parent) {
    V base = parent ? exc_by_name(parent) : NONE;
    V c = new_class(S(name), base);
    if (!parent) rt_class_set(c, K_init, mkbuiltin(b_exc_init, "__init__"));
    exc_nm[nexc] = name;
    exc_cls[nexc++] = c;
}
void rt_init(int argc, char **argv) {
    rt_none_v = (V)&none_o; rt_true_v = (V)&true_o; rt_false_v = (V)&false_o;
    K_args = S("args"); K_init = S("__init__"); K_str = S("__str__"); K_repr = S("__repr__");
    K_len = S("__len__"); K_getitem = S("__getitem__"); K_setitem = S("__setitem__"); K_name = S("__name__");
    def_exc("Exception", NULL);
    def_exc("ValueError", "Exception"); def_exc("TypeError", "Exception"); def_exc("NameError", "Exception");
    def_exc("AttributeError", "Exception"); def_exc("RuntimeError", "Exception"); def_exc("AssertionError", "Exception");
    def_exc("StopIteration", "Exception"); def_exc("OSError", "Exception"); def_exc("ArithmeticError", "Exception");
    def_exc("LookupError", "Exception"); def_exc("ImportError", "Exception"); def_exc("EOFError", "Exception");
    def_exc("IndexError", "LookupError"); def_exc("KeyError", "LookupError");
    def_exc("ZeroDivisionError", "ArithmeticError"); def_exc("OverflowError", "ArithmeticError");
    def_exc("NotImplementedError", "RuntimeError"); def_exc("FileNotFoundError", "OSError");
    def_exc("IOError", "OSError");
    setvbuf(stdout, NULL, _IOFBF, 1 << 16);
    sys_stdout = mkfile(stdout); sys_stderr = mkfile(stderr); sys_stdin = mkfile(stdin);
    sys_argv = mklist(argc);
    for (int i = 0; i < argc; i++) list_append(sys_argv, S(argv[i]));
}
