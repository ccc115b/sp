// c4.c - C in four functions (Self-compiling Compiler)
#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <unistd.h>
#include <fcntl.h>

#define int long long

char *p, *lp,     // current position in source code
     *data, *data_base; // data/bss pointer
char *src_code;   // copy of source code

int *e, *le, *text_base, // current position in emitted code
    *id,          // currently parsed identifier
    *sym,         // symbol table (simple list of identifiers)
    tk,           // current token
    ival,         // current token value
    ty,           // current expression type
    loc,          // local variable offset
    line,         // current line number
    src;          // print source and assembly flag

int *line_info;   // line number mapping for each emitted word
int *rel_data, *rd_p; // relocation list for data addresses
int src_len;

// tokens and classes
enum {
  Num = 128, Fun, Sys, Glo, Loc, Id,
  Char, Else, Enum, If, Int, Return, Sizeof, While,
  Assign, Cond, Lor, Lan, Or, Xor, And, Eq, Ne, Lt, Gt, Le, Ge, Shl, Shr, Add, Sub, Mul, Div, Mod, Inc, Dec, Brak
};

// opcodes (含 OPEN, CREA, READ, WRIT)
enum { LEA ,IMM ,JMP ,JSR ,BZ  ,BNZ ,ENT ,ADJ ,LEV ,LI  ,LC  ,SI  ,SC  ,PSH ,
       OR  ,XOR ,AND ,EQ  ,NE  ,LT  ,GT  ,LE  ,GE  ,SHL ,SHR ,ADD ,SUB ,MUL ,DIV ,MOD ,
       OPEN,CREA,READ,WRIT,CLOS,PRTF,MALC,FREE,MSET,MCMP,EXIT };

// types
enum { CHAR, INT, PTR };

// identifier offsets
enum { Tk, Hash, Name, Class, Type, Val, HClass, HType, HVal, Idsz };

void emit(int val)
{
  *++e = val;
  line_info[e - text_base] = line;
}

void mark_data_reloc(int *pos)
{
  *rd_p++ = pos - text_base;
}

void next()
{
  char *pp;

  while ((tk = *p)) {
    ++p;
    if (tk == '\n') {
      if (src) {
        printf("%d: %.*s", line, (int)(p - lp), lp);
        lp = p;
        while (le < e) {
          printf("%8.4s", &"LEA ,IMM ,JMP ,JSR ,BZ  ,BNZ ,ENT ,ADJ ,LEV ,LI  ,LC  ,SI  ,SC  ,PSH ,"
                           "OR  ,XOR ,AND ,EQ  ,NE  ,LT  ,GT  ,LE  ,GE  ,SHL ,SHR ,ADD ,SUB ,MUL ,DIV ,MOD ,"
                           "OPEN,CREA,READ,WRIT,CLOS,PRTF,MALC,FREE,MSET,MCMP,EXIT,"[*++le * 5]);
          if (*le <= ADJ) printf(" %d\n", *++le); else printf("\n");
        }
      }
      ++line;
    }
    else if (tk == '#') {
      while (*p != 0 && *p != '\n') ++p;
    }
    else if ((tk >= 'a' && tk <= 'z') || (tk >= 'A' && tk <= 'Z') || tk == '_') {
      pp = p - 1;
      while ((*p >= 'a' && *p <= 'z') || (*p >= 'A' && *p <= 'Z') || (*p >= '0' && *p <= '9') || *p == '_')
        tk = tk * 147 + *p++;
      tk = (tk << 6) + (p - pp);
      id = sym;
      while (id[Tk]) {
        if (tk == id[Hash] && !memcmp((char *)id[Name], pp, p - pp)) { tk = id[Tk]; return; }
        id = id + Idsz;
      }
      id[Name] = (int)pp;
      id[Hash] = tk;
      tk = id[Tk] = Id;
      return;
    }
    else if (tk >= '0' && tk <= '9') {
      if ((ival = tk - '0')) { while (*p >= '0' && *p <= '9') ival = ival * 10 + *p++ - '0'; }
      else if (*p == 'x' || *p == 'X') {
        while ((tk = *++p) && ((tk >= '0' && tk <= '9') || (tk >= 'a' && tk <= 'f') || (tk >= 'A' && tk <= 'F')))
          ival = ival * 16 + (tk & 15) + (tk >= 'A' ? 9 : 0);
      }
      else { while (*p >= '0' && *p <= '7') ival = ival * 8 + *p++ - '0'; }
      tk = Num;
      return;
    }
    else if (tk == '/') {
      if (*p == '/') {
        ++p;
        while (*p != 0 && *p != '\n') ++p;
      }
      else {
        tk = Div;
        return;
      }
    }
    else if (tk == '\'' || tk == '"') {
      pp = data;
      while (*p != 0 && *p != tk) {
        if ((ival = *p++) == '\\') {
          if ((ival = *p++) == 'n') ival = '\n';
        }
        if (tk == '"') *data++ = ival;
      }
      ++p;
      if (tk == '"') ival = (int)pp; else tk = Num;
      return;
    }
    else if (tk == '=') { if (*p == '=') { ++p; tk = Eq; } else tk = Assign; return; }
    else if (tk == '+') { if (*p == '+') { ++p; tk = Inc; } else tk = Add; return; }
    else if (tk == '-') { if (*p == '-') { ++p; tk = Dec; } else tk = Sub; return; }
    else if (tk == '!') { if (*p == '=') { ++p; tk = Ne; } return; }
    else if (tk == '<') { if (*p == '=') { ++p; tk = Le; } else if (*p == '<') { ++p; tk = Shl; } else tk = Lt; return; }
    else if (tk == '>') { if (*p == '=') { ++p; tk = Ge; } else if (*p == '>') { ++p; tk = Shr; } else tk = Gt; return; }
    else if (tk == '|') { if (*p == '|') { ++p; tk = Lor; } else tk = Or; return; }
    else if (tk == '&') { if (*p == '&') { ++p; tk = Lan; } else tk = And; return; }
    else if (tk == '^') { tk = Xor; return; }
    else if (tk == '%') { tk = Mod; return; }
    else if (tk == '*') { tk = Mul; return; }
    else if (tk == '[') { tk = Brak; return; }
    else if (tk == '?') { tk = Cond; return; }
    else if (tk == '~' || tk == ';' || tk == '{' || tk == '}' || tk == '(' || tk == ')' || tk == ']' || tk == ',' || tk == ':') return;
  }
}

void expr(int lev)
{
  int t, *d;

  if (!tk) { printf("%d: unexpected eof in expression\n", line); exit(-1); }
  else if (tk == Num) { emit(IMM); emit(ival); next(); ty = INT; }
  else if (tk == '"') {
    emit(IMM); mark_data_reloc(e + 1); emit(ival); next();
    while (tk == '"') next();
    data = (char *)((int)data + sizeof(int) & -sizeof(int)); ty = PTR;
  }
  else if (tk == Sizeof) {
    next(); if (tk == '(') next(); else { printf("%d: open paren expected in sizeof\n", line); exit(-1); }
    ty = INT; if (tk == Int) next(); else if (tk == Char) { next(); ty = CHAR; }
    while (tk == Mul) { next(); ty = ty + PTR; }
    if (tk == ')') next(); else { printf("%d: close paren expected in sizeof\n", line); exit(-1); }
    emit(IMM); emit((ty == CHAR) ? sizeof(char) : sizeof(int));
    ty = INT;
  }
  else if (tk == Id) {
    d = id; next();
    if (tk == '(') {
      next();
      t = 0;
      while (tk != ')') { expr(Assign); emit(PSH); ++t; if (tk == ',') next(); }
      next();
      if (d[Class] == Sys) emit(d[Val]);
      else if (d[Class] == Fun) { emit(JSR); emit(d[Val]); }
      else { printf("%d: bad function call\n", line); exit(-1); }
      if (t) { emit(ADJ); emit(t); }
      ty = d[Type];
    }
    else if (d[Class] == Num) { emit(IMM); emit(d[Val]); ty = INT; }
    else {
      if (d[Class] == Loc) { emit(LEA); emit(loc - d[Val]); }
      else if (d[Class] == Glo) { emit(IMM); mark_data_reloc(e + 1); emit(d[Val]); }
      else { printf("%d: undefined variable\n", line); exit(-1); }
      emit(((ty = d[Type]) == CHAR) ? LC : LI);
    }
  }
  else if (tk == '(') {
    next();
    if (tk == Int || tk == Char) {
      t = (tk == Int) ? INT : CHAR; next();
      while (tk == Mul) { next(); t = t + PTR; }
      if (tk == ')') next(); else { printf("%d: bad cast\n", line); exit(-1); }
      expr(Inc);
      ty = t;
    }
    else {
      expr(Assign);
      if (tk == ')') next(); else { printf("%d: close paren expected\n", line); exit(-1); }
    }
  }
  else if (tk == Mul) {
    next(); expr(Inc);
    if (ty > INT) ty = ty - PTR; else { printf("%d: bad dereference\n", line); exit(-1); }
    emit((ty == CHAR) ? LC : LI);
  }
  else if (tk == And) {
    next(); expr(Inc);
    if (*e == LC || *e == LI) --e; else { printf("%d: bad address-of\n", line); exit(-1); }
    ty = ty + PTR;
  }
  else if (tk == '!') { next(); expr(Inc); emit(PSH); emit(IMM); emit(0); emit(EQ); ty = INT; }
  else if (tk == '~') { next(); expr(Inc); emit(PSH); emit(IMM); emit(-1); emit(XOR); ty = INT; }
  else if (tk == Add) { next(); expr(Inc); ty = INT; }
  else if (tk == Sub) {
    next(); emit(IMM);
    if (tk == Num) { emit(-ival); next(); } else { emit(-1); emit(PSH); expr(Inc); emit(MUL); }
    ty = INT;
  }
  else if (tk == Inc || tk == Dec) {
    t = tk; next(); expr(Inc);
    if (*e == LC) { *e = PSH; emit(LC); }
    else if (*e == LI) { *e = PSH; emit(LI); }
    else { printf("%d: bad lvalue in pre-increment\n", line); exit(-1); }
    emit(PSH);
    emit(IMM); emit((ty > PTR) ? sizeof(int) : sizeof(char));
    emit((t == Inc) ? ADD : SUB);
    emit((ty == CHAR) ? SC : SI);
  }
  else { printf("%d: bad expression\n", line); exit(-1); }

  while (tk >= lev) {
    t = ty;
    if (tk == Assign) {
      next();
      if (*e == LC || *e == LI) *e = PSH; else { printf("%d: bad lvalue in assignment\n", line); exit(-1); }
      expr(Assign); emit(((ty = t) == CHAR) ? SC : SI);
    }
    else if (tk == Cond) {
      next();
      emit(BZ); emit(0); d = e;
      expr(Assign);
      if (tk == ':') next(); else { printf("%d: conditional missing colon\n", line); exit(-1); }
      *d = (int)(e + 3); emit(JMP); emit(0); d = e;
      expr(Cond);
      *d = (int)(e + 1);
    }
    else if (tk == Lor) { next(); emit(BNZ); emit(0); d = e; expr(Lan); *d = (int)(e + 1); ty = INT; }
    else if (tk == Lan) { next(); emit(BZ);  emit(0); d = e; expr(Or);  *d = (int)(e + 1); ty = INT; }
    else if (tk == Or)  { next(); emit(PSH); expr(Xor); emit(OR);  ty = INT; }
    else if (tk == Xor) { next(); emit(PSH); expr(And); emit(XOR); ty = INT; }
    else if (tk == And) { next(); emit(PSH); expr(Eq);  emit(AND); ty = INT; }
    else if (tk == Eq)  { next(); emit(PSH); expr(Lt);  emit(EQ);  ty = INT; }
    else if (tk == Ne)  { next(); emit(PSH); expr(Lt);  emit(NE);  ty = INT; }
    else if (tk == Lt)  { next(); emit(PSH); expr(Shl); emit(LT);  ty = INT; }
    else if (tk == Gt)  { next(); emit(PSH); expr(Shl); emit(GT);  ty = INT; }
    else if (tk == Le)  { next(); emit(PSH); expr(Shl); emit(LE);  ty = INT; }
    else if (tk == Ge)  { next(); emit(PSH); expr(Shl); emit(GE);  ty = INT; }
    else if (tk == Shl) { next(); emit(PSH); expr(Add); emit(SHL); ty = INT; }
    else if (tk == Shr) { next(); emit(PSH); expr(Add); emit(SHR); ty = INT; }
    else if (tk == Add) {
      next(); emit(PSH); expr(Mul);
      if ((ty = t) > PTR) { emit(PSH); emit(IMM); emit(sizeof(int)); emit(MUL);  }
      emit(ADD);
    }
    else if (tk == Sub) {
      next(); emit(PSH); expr(Mul);
      if (t > PTR && t == ty) { emit(SUB); emit(PSH); emit(IMM); emit(sizeof(int)); emit(DIV); ty = INT; }
      else if ((ty = t) > PTR) { emit(PSH); emit(IMM); emit(sizeof(int)); emit(MUL); emit(SUB); }
      else emit(SUB);
    }
    else if (tk == Mul) { next(); emit(PSH); expr(Inc); emit(MUL); ty = INT; }
    else if (tk == Div) { next(); emit(PSH); expr(Inc); emit(DIV); ty = INT; }
    else if (tk == Mod) { next(); emit(PSH); expr(Inc); emit(MOD); ty = INT; }
    else if (tk == Inc || tk == Dec) {
      if (*e == LC) { *e = PSH; emit(LC); }
      else if (*e == LI) { *e = PSH; emit(LI); }
      else { printf("%d: bad lvalue in post-increment\n", line); exit(-1); }
      emit(PSH); emit(IMM); emit((ty > PTR) ? sizeof(int) : sizeof(char));
      emit((tk == Inc) ? ADD : SUB);
      emit((ty == CHAR) ? SC : SI);
      emit(PSH); emit(IMM); emit((ty > PTR) ? sizeof(int) : sizeof(char));
      emit((tk == Inc) ? SUB : ADD);
      next();
    }
    else if (tk == Brak) {
      next(); emit(PSH); expr(Assign);
      if (tk == ']') next(); else { printf("%d: close bracket expected\n", line); exit(-1); }
      if (t > PTR) { emit(PSH); emit(IMM); emit(sizeof(int)); emit(MUL);  }
      else if (t < PTR) { printf("%d: pointer type expected\n", line); exit(-1); }
      emit(ADD);
      emit(((ty = t - PTR) == CHAR) ? LC : LI);
    }
    else { printf("%d: compiler error tk=%d\n", line, tk); exit(-1); }
  }
}

void stmt()
{
  int *a, *b;

  if (tk == If) {
    next();
    if (tk == '(') next(); else { printf("%d: open paren expected\n", line); exit(-1); }
    expr(Assign);
    if (tk == ')') next(); else { printf("%d: close paren expected\n", line); exit(-1); }
    emit(BZ); emit(0); b = e;
    stmt();
    if (tk == Else) {
      *b = (int)(e + 3); emit(JMP); emit(0); b = e;
      next();
      stmt();
    }
    *b = (int)(e + 1);
  }
  else if (tk == While) {
    next();
    a = e + 1;
    if (tk == '(') next(); else { printf("%d: open paren expected\n", line); exit(-1); }
    expr(Assign);
    if (tk == ')') next(); else { printf("%d: close paren expected\n", line); exit(-1); }
    emit(BZ); emit(0); b = e;
    stmt();
    emit(JMP); emit((int)a);
    *b = (int)(e + 1);
  }
  else if (tk == Return) {
    next();
    if (tk != ';') expr(Assign);
    emit(LEV);
    if (tk == ';') next(); else { printf("%d: semicolon expected\n", line); exit(-1); }
  }
  else if (tk == '{') {
    next();
    while (tk != '}') stmt();
    next();
  }
  else if (tk == ';') {
    next();
  }
  else {
    expr(Assign);
    if (tk == ';') next(); else { printf("%d: semicolon expected\n", line); exit(-1); }
  }
}

#undef int
int main(int argc, char **argv)
#define int long long
{
  int fd, outfd, bt, ty, poolsz, *idmain;
  int i, *p_code, *cur_rd;
  int text_words, data_bytes, main_off;
  int *hdr;
  char *infile, *outfile;

  infile = 0;
  outfile = "a.c4b";

  --argc; ++argv;
  while (argc > 0) {
    if (!memcmp(*argv, "-s", 3)) { src = 1; --argc; ++argv; }
    else if (!memcmp(*argv, "-o", 3) && argc > 1) { outfile = argv[1]; argc = argc - 2; argv = argv + 2; }
    else if (!infile) { infile = *argv; --argc; ++argv; }
    else { outfile = *argv; --argc; ++argv; }
  }

  if (!infile) { printf("usage: c4 [-s] [-o outfile] infile.c [outfile.bc]\n"); return -1; }

  if ((fd = open(infile, 0)) < 0) { printf("could not open(%s)\n", infile); return -1; }

  poolsz = 256*1024;
  if (!(sym = malloc(poolsz))) { printf("could not malloc(%d) symbol area\n", poolsz); return -1; }
  if (!(text_base = le = e = malloc(poolsz))) { printf("could not malloc(%d) text area\n", poolsz); return -1; }
  if (!(data_base = data = malloc(poolsz))) { printf("could not malloc(%d) data area\n", poolsz); return -1; }
  line_info = malloc(poolsz);
  rel_data = malloc(poolsz);
  rd_p = rel_data;

  memset(sym,       0, poolsz);
  memset(text_base, 0, poolsz);
  memset(data_base, 0, poolsz);
  memset(line_info, 0, poolsz);

  p = "char else enum if int return sizeof while "
      "open creat read write close printf malloc free memset memcmp exit void main";
  i = Char; while (i <= While) { next(); id[Tk] = i++; }
  i = OPEN; while (i <= EXIT) { next(); id[Class] = Sys; id[Type] = INT; id[Val] = i++; }
  next(); id[Tk] = Char;
  next(); idmain = id;

  if (!(lp = p = malloc(poolsz))) { printf("could not malloc(%d) source area\n", poolsz); return -1; }
  if ((src_len = read(fd, p, poolsz-1)) <= 0) { printf("read() returned %d\n", src_len); return -1; }
  p[src_len] = 0;
  close(fd);

  src_code = malloc(src_len + 1);
  i = 0; while (i <= src_len) { src_code[i] = p[i]; i++; }

  line = 1;
  next();
  while (tk) {
    bt = INT;
    if (tk == Int) next();
    else if (tk == Char) { next(); bt = CHAR; }
    else if (tk == Enum) {
      next();
      if (tk != '{') next();
      if (tk == '{') {
        next();
        i = 0;
        while (tk != '}') {
          if (tk != Id) { printf("%d: bad enum identifier %d\n", line, tk); return -1; }
          next();
          if (tk == Assign) {
            next();
            if (tk != Num) { printf("%d: bad enum initializer\n", line); return -1; }
            i = ival;
            next();
          }
          id[Class] = Num; id[Type] = INT; id[Val] = i++;
          if (tk == ',') next();
        }
        next();
      }
    }
    while (tk != ';' && tk != '}') {
      ty = bt;
      while (tk == Mul) { next(); ty = ty + PTR; }
      if (tk != Id) { printf("%d: bad global declaration\n", line); return -1; }
      if (id[Class]) { printf("%d: duplicate global definition\n", line); return -1; }
      next();
      id[Type] = ty;
      if (tk == '(') {
        id[Class] = Fun;
        id[Val] = (int)(e + 1);
        next(); i = 0;
        while (tk != ')') {
          ty = INT;
          if (tk == Int) next();
          else if (tk == Char) { next(); ty = CHAR; }
          while (tk == Mul) { next(); ty = ty + PTR; }
          if (tk != Id) { printf("%d: bad parameter declaration\n", line); return -1; }
          if (id[Class] == Loc) { printf("%d: duplicate parameter definition\n", line); return -1; }
          id[HClass] = id[Class]; id[Class] = Loc;
          id[HType]  = id[Type];  id[Type] = ty;
          id[HVal]   = id[Val];   id[Val] = i++;
          next();
          if (tk == ',') next();
        }
        next();
        if (tk != '{') { printf("%d: bad function definition\n", line); return -1; }
        loc = ++i;
        next();
        while (tk == Int || tk == Char) {
          bt = (tk == Int) ? INT : CHAR;
          next();
          while (tk != ';') {
            ty = bt;
            while (tk == Mul) { next(); ty = ty + PTR; }
            if (tk != Id) { printf("%d: bad local declaration\n", line); return -1; }
            if (id[Class] == Loc) { printf("%d: duplicate local definition\n", line); return -1; }
            id[HClass] = id[Class]; id[Class] = Loc;
            id[HType]  = id[Type];  id[Type] = ty;
            id[HVal]   = id[Val];   id[Val] = ++i;
            next();
            if (tk == ',') next();
          }
          next();
        }
        emit(ENT); emit(i - loc);
        while (tk != '}') stmt();
        emit(LEV);
        id = sym;
        while (id[Tk]) {
          if (id[Class] == Loc) {
            id[Class] = id[HClass];
            id[Type] = id[HType];
            id[Val] = id[HVal];
          }
          id = id + Idsz;
        }
      }
      else {
        id[Class] = Glo;
        id[Val] = (int)data;
        data = data + sizeof(int);
      }
      if (tk == ',') next();
    }
    next();
  }

  if (!idmain[Val]) { printf("main() not defined\n"); return -1; }

  text_words = e - text_base;
  data_bytes = data - data_base;
  main_off = (int *)idmain[Val] - text_base;

  p_code = text_base + 1;
  while (p_code <= e) {
    i = *p_code++;
    if (i <= ADJ) {
      if (i == JMP || i == JSR || i == BZ || i == BNZ) {
        *p_code = (int *) *p_code - text_base;
      }
      p_code++;
    }
  }

  cur_rd = rel_data;
  while (cur_rd < rd_p) {
    text_base[*cur_rd] = (char *)text_base[*cur_rd] - data_base;
    cur_rd++;
  }

  if ((outfd = creat(outfile, 438)) < 0) { printf("could not open output file %s\n", outfile); return -1; }

  hdr = malloc(6 * sizeof(int));
  hdr[0] = 0x43344243;
  hdr[1] = main_off;
  hdr[2] = text_words;
  hdr[3] = data_bytes;
  hdr[4] = rd_p - rel_data;
  hdr[5] = src_len;

  write(outfd, (char *)hdr, 6 * sizeof(int));
  write(outfd, (char *)(text_base + 1), text_words * sizeof(int));
  write(outfd, data_base, data_bytes);
  write(outfd, (char *)rel_data, (rd_p - rel_data) * sizeof(int));
  write(outfd, (char *)(line_info + 1), text_words * sizeof(int));
  write(outfd, src_code, src_len);
  close(outfd);

  return 0;
}