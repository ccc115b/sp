// rust0 runtime: text output buffer, string helpers, keyword table,
// source file loading, argv access, error reporting and the C main wrapper.
// Build with main (for lli):   clang -c rt.c -o rt.o ; clang -S -emit-llvm rt.c -o rt.ll
// Build without main (for the rustc-hosted stage0): clang -DR0_NO_MAIN -c rt.c -o rt0.o
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern void r0fn_main(void);

// ---- growing output buffer ----
static char* OUT = 0;
static long  OLEN = 0;
static long  OCAP = 0;

static void oreserve(long need) {
  if (OUT && OLEN + need <= OCAP) return;
  long nc = OCAP ? OCAP : 65536;
  while (nc < OLEN + need) nc *= 2;
  char* nb = (char*)malloc((size_t)nc);
  memcpy(nb, OUT, (size_t)OLEN);
  free(OUT);
  OUT = nb;
  OCAP = nc;
}

static void oput(const char* s) {
  long l = (long)strlen(s);
  oreserve(l);
  memcpy(OUT + OLEN, s, (size_t)l);
  OLEN += l;
}

static void oputc(char c) {
  oreserve(1);
  OUT[OLEN] = c;
  OLEN += 1;
}

void r0_write(const char* s) { oput(s); }

void r0_wch(long c) { oputc((char)c); }

void r0_writeint(long v) {
  char b[32];
  snprintf(b, sizeof(b), "%ld", v);
  oput(b);
}

// Write the BODY of an LLVM string constant: unescape the writer's escapes,
// re-escape " and \ as \22 / \5C for the .ll textual form. Quotes not added.
void r0_wstrlit(const char* base, long off, long len) {
  const char* p = base + off;
  long i = 0;
  while (i < len) {
    unsigned char c = (unsigned char)p[i];
    if (c == '\\' && i + 1 < len) {
      unsigned char n = (unsigned char)p[i + 1];
      if (n == 'n') { oputc('\n'); i += 2; continue; }
      if (n == 't') { oputc('\t'); i += 2; continue; }
      if (n == 'r') { oputc('\r'); i += 2; continue; }
      if (n == '0') { oputc('\0'); i += 2; continue; }
      if (n == '\\') { oputc('\\'); i += 2; continue; }
      if (n == '"') { oputc('"'); i += 2; continue; }
      // unknown escape: keep both bytes
    }
    if (c == '"') { oput("\\22"); i++; continue; }
    if (c == '\\') { oput("\\5C"); i++; continue; }
    oputc((char)c);
    i++;
  }
}

// Decoded length of a raw source string-literal body (every \X counts as 1).
long r0_strlen2(const char* base, long off, long len) {
  const char* p = base + off;
  long n = 0, i = 0;
  while (i < len) {
    if (p[i] == '\\' && i + 1 < len) { n++; i += 2; }
    else { n++; i++; }
  }
  return n;
}

// ---- program output (stdout) ----
void r0_print(const char* s) { fputs(s, stdout); }

void r0_printint(long v) { printf("%ld", v); }

// ---- source byte access ----
long r0_b(const char* p, long i) { return (long)(unsigned char)p[i]; }

long r0_sp_eq(const char* s, long a1, long l1, long a2, long l2) {
  if (l1 != l2) return 0;
  return memcmp(s + a1, s + a2, (size_t)l1) == 0;
}

// ---- keyword / special-method recognition (no strings in the subset) ----
static const char* KWS[] = {
  "fn","let","mut","return","if","else","while","for","in","break","continue",
  "struct","const","extern","true","false","unsafe","i64","bool","usize","u8","as"
};
static const long NKEYS = (long)(sizeof(KWS) / sizeof(KWS[0]));

long r0_kw(const char* s, long st, long ln, long k) {
  if (k < 0 || k >= NKEYS) return 0;
  const char* w = KWS[k];
  long wl = (long)strlen(w);
  if (wl != ln) return 0;
  return memcmp(s + st, w, (size_t)wl) == 0;
}

static const char* MTS[] = { "as_ptr" };

long r0_mt(const char* s, long st, long ln, long k) {
  if (k < 0 || k >= (long)(sizeof(MTS) / sizeof(MTS[0]))) return 0;
  const char* w = MTS[k];
  long wl = (long)strlen(w);
  if (wl != ln) return 0;
  return memcmp(s + st, w, (size_t)wl) == 0;
}

long r0_parseint(const char* base, long off, long len) {
  char b[80];
  long n = len < 79 ? len : 79;
  memcpy(b, base + off, (size_t)n);
  b[n] = 0;
  return (long)strtoll(b, 0, 10);
}

// zero a region (used to initialize arrays/structs en bloc)
void r0_zf(char* p, long bytes) { memset(p, 0, (size_t)bytes); }

// ---- source file loading ----
static char* SRC = 0;
static long  SRCN = 0;

void r0_load(const char* path) {
  FILE* f = fopen(path, "rb");
  if (!f) { fprintf(stderr, "rust0 error: cannot open %s\n", path); exit(1); }
  fseek(f, 0, SEEK_END);
  long n = ftell(f);
  fseek(f, 0, SEEK_SET);
  char* b = (char*)malloc((size_t)n + 1);
  long got = (long)fread(b, 1, (size_t)n, f);
  fclose(f);
  b[got] = 0;
  SRC = b;
  SRCN = got;
}

const char* r0_srcp(void) { return SRC; }
long         r0_srclen(void) { return SRCN; }

// ---- save emitted text ----
void r0_save(const char* path) {
  FILE* f = fopen(path, "wb");
  if (!f) { fprintf(stderr, "rust0 error: cannot write %s\n", path); exit(1); }
  if (OUT) fwrite(OUT, 1, (size_t)OLEN, f);
  fclose(f);
}

// ---- diagnostics ----
void r0_pc(const char* msg, long row) {
  fprintf(stderr, "rust0 error: %s (line %ld)\n", msg, row);
  exit(1);
}

void r0_wchd(long c) { putc((int)c, stderr); }
void r0_wchd2(long c) { fprintf(stderr, "%ld", c); }

void r0_panic(const char* msg) {
  fprintf(stderr, "rust0 error: %s\n", msg);
  exit(1);
}

// ---- argv plumbing ----
// The rustc-hosted stage0 binary uses Rust's own main, so rt0.o must not
// define one; argv is recovered lazily.  When hosted by lli (rt.ll) main()
// shifts argv left by one so the compiler always sees [compiler, in, out].
static char** R0ARGV = 0;
static int    R0ARGC = 0;

#ifdef __APPLE__
#include <crt_externs.h>
static void r0getargs(void) {
  if (R0ARGV != 0) { return; }
  R0ARGC = *_NSGetArgc();
  R0ARGV = *_NSGetArgv();
}
#else
#include <unistd.h>
#include <fcntl.h>
static char  r0cmdbuf[16384];
static char* r0cmdbav[256];
static void r0getargs(void) {
  if (R0ARGV != 0) { return; }
  int f = open("/proc/self/cmdline", O_RDONLY);
  if (f < 0) { return; }
  long n = read(f, r0cmdbuf, (long)sizeof(r0cmdbuf) - 1);
  close(f);
  if (n <= 0) { return; }
  r0cmdbuf[n] = 0;
  int c = 0;
  char* p = r0cmdbuf;
  char* end = r0cmdbuf + n;
  while (p < end && c < 255) {
    r0cmdbav[c] = p;
    c = c + 1;
    while (*p != 0 && p < end) { p = p + 1; }
    p = p + 1;
  }
  R0ARGC = c;
  R0ARGV = r0cmdbav;
}
#endif

long r0_argc(void) { r0getargs(); return (long)R0ARGC; }
const char* r0_arg(long i) { r0getargs(); return R0ARGV[i]; }

#ifndef R0_NO_MAIN
int main(int argc, char** argv) {
  R0ARGC = argc;
  R0ARGV = argv;
  r0fn_main();
  return 0;
}
#endif
