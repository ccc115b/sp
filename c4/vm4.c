// vm4.c - C4 Virtual Machine
#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <unistd.h>
#include <fcntl.h>

#define int long long

// opcodes (含 OPEN, CREA, READ, WRIT)
enum { LEA ,IMM ,JMP ,JSR ,BZ  ,BNZ ,ENT ,ADJ ,LEV ,LI  ,LC  ,SI  ,SC  ,PSH ,
       OR  ,XOR ,AND ,EQ  ,NE  ,LT  ,GT  ,LE  ,GE  ,SHL ,SHR ,ADD ,SUB ,MUL ,DIV ,MOD ,
       OPEN,CREA,READ,WRIT,CLOS,PRTF,MALC,FREE,MSET,MCMP,EXIT };

void dump_asm(int *text, int text_words, char *src, int *line_info)
{
  int *pc = text;
  char *lp = src;
  int cur_line = 1;

  while (pc < text + text_words) {
    int l = line_info[pc - text];
    while (cur_line <= l && *lp) {
      char *nxt = strchr(lp, '\n');
      if (!nxt) nxt = lp + strlen(lp); else nxt++;
      printf("%d: %.*s", (int)cur_line, (int)(nxt - lp), lp);
      lp = nxt;
      cur_line++;
    }

    int op = *pc;
    printf("%8.4s", &"LEA ,IMM ,JMP ,JSR ,BZ  ,BNZ ,ENT ,ADJ ,LEV ,LI  ,LC  ,SI  ,SC  ,PSH ,"
                     "OR  ,XOR ,AND ,EQ  ,NE  ,LT  ,GT  ,LE  ,GE  ,SHL ,SHR ,ADD ,SUB ,MUL ,DIV ,MOD ,"
                     "OPEN,CREA,READ,WRIT,CLOS,PRTF,MALC,FREE,MSET,MCMP,EXIT,"[op * 5]);
    pc++;
    if (op <= ADJ) {
      printf(" %d\n", (int)*pc);
      pc++;
    } else {
      printf("\n");
    }
  }
}

#undef int
int main(int argc, char **argv)
#define int long long
{
  int src = 0, debug = 0;
  int poolsz = 256 * 1024;
  int fd;

  --argc; ++argv;
  if (argc > 0 && **argv == '-' && (*argv)[1] == 's') { src = 1; --argc; ++argv; }
  if (argc > 0 && **argv == '-' && (*argv)[1] == 'd') { debug = 1; --argc; ++argv; }
  if (argc < 1) { printf("usage: vm4 [-s] [-d] binary.c4b [args...]\n"); return -1; }

  if ((fd = open(*argv, 0)) < 0) { printf("could not open(%s)\n", *argv); return -1; }

  int header[6];
  if (read(fd, (char *)header, sizeof(header)) != sizeof(header)) { printf("bad header\n"); return -1; }
  if (header[0] != 0x43344243) { printf("invalid c4 bytecode file\n"); return -1; }

  int main_off    = header[1];
  int text_words  = header[2];
  int data_bytes  = header[3];
  int rel_count   = header[4];
  int src_len     = header[5];

  int *text  = malloc(poolsz);
  char *data = malloc(poolsz);
  int *stack = malloc(poolsz);
  int *rel   = malloc(rel_count * sizeof(int));
  int *lines = malloc(text_words * sizeof(int));
  char *source = malloc(src_len + 1);

  memset(text, 0, poolsz);
  memset(data, 0, poolsz);
  memset(stack, 0, poolsz);

  read(fd, (char *)text, text_words * sizeof(int));
  read(fd, data, data_bytes);
  read(fd, (char *)rel, rel_count * sizeof(int));
  read(fd, (char *)lines, text_words * sizeof(int));
  read(fd, source, src_len);
  source[src_len] = 0;
  close(fd);

  if (src) {
    dump_asm(text, text_words, source, lines);
    return 0;
  }

  // 重定位資料指標
  for (int i = 0; i < rel_count; i++) {
    int idx = rel[i] - 1;
    text[idx] = (int)(data + text[idx]);
  }

  // 重定位跳躍指令
  int *p_code = text;
  while (p_code < text + text_words) {
    int op = *p_code++;
    if (op <= ADJ) {
      if (op == JMP || op == JSR || op == BZ || op == BNZ) {
        *p_code = (int)(text + *p_code - 1);
      }
      p_code++;
    }
  }

  int *pc = text + main_off - 1;
  int *sp = (int *)((int)stack + poolsz);
  int *bp = sp;
  int a = 0, cycle = 0;
  int i, *t;

  *--sp = EXIT;
  *--sp = PSH; t = sp;
  *--sp = argc;
  *--sp = (int)argv;
  *--sp = (int)t;

  while (1) {
    i = *pc++; ++cycle;
    if (debug) {
      printf("%d> %.4s", (int)cycle,
        &"LEA ,IMM ,JMP ,JSR ,BZ  ,BNZ ,ENT ,ADJ ,LEV ,LI  ,LC  ,SI  ,SC  ,PSH ,"
         "OR  ,XOR ,AND ,EQ  ,NE  ,LT  ,GT  ,LE  ,GE  ,SHL ,SHR ,ADD ,SUB ,MUL ,DIV ,MOD ,"
         "OPEN,CREA,READ,WRIT,CLOS,PRTF,MALC,FREE,MSET,MCMP,EXIT,"[i * 5]);
      if (i <= ADJ) printf(" %d\n", (int)*pc); else printf("\n");
    }
    if      (i == LEA) a = (int)(bp + *pc++);
    else if (i == IMM) a = *pc++;
    else if (i == JMP) pc = (int *)*pc;
    else if (i == JSR) { *--sp = (int)(pc + 1); pc = (int *)*pc; }
    else if (i == BZ)  pc = a ? pc + 1 : (int *)*pc;
    else if (i == BNZ) pc = a ? (int *)*pc : pc + 1;
    else if (i == ENT) { *--sp = (int)bp; bp = sp; sp = sp - *pc++; }
    else if (i == ADJ) sp = sp + *pc++;
    else if (i == LEV) { sp = bp; bp = (int *)*sp++; pc = (int *)*sp++; }
    else if (i == LI)  a = *(int *)a;
    else if (i == LC)  a = *(char *)a;
    else if (i == SI)  *(int *)*sp++ = a;
    else if (i == SC)  a = *(char *)*sp++ = a;
    else if (i == PSH) *--sp = a;

    else if (i == OR)  a = *sp++ |  a;
    else if (i == XOR) a = *sp++ ^  a;
    else if (i == AND) a = *sp++ &  a;
    else if (i == EQ)  a = *sp++ == a;
    else if (i == NE)  a = *sp++ != a;
    else if (i == LT)  a = *sp++ <  a;
    else if (i == GT)  a = *sp++ >  a;
    else if (i == LE)  a = *sp++ <= a;
    else if (i == GE)  a = *sp++ >= a;
    else if (i == SHL) a = *sp++ << a;
    else if (i == SHR) a = *sp++ >> a;
    else if (i == ADD) a = *sp++ +  a;
    else if (i == SUB) a = *sp++ -  a;
    else if (i == MUL) a = *sp++ *  a;
    else if (i == DIV) a = *sp++ /  a;
    else if (i == MOD) a = *sp++ %  a;

    // 兩參數經典 Unix API
    else if (i == OPEN) a = open((char *)sp[1], *sp);
    else if (i == CREA) a = creat((char *)sp[1], *sp);
    else if (i == READ) a = read(sp[2], (char *)sp[1], *sp);
    else if (i == WRIT) a = write(sp[2], (char *)sp[1], *sp);
    else if (i == CLOS) a = close(*sp);
    else if (i == PRTF) { t = sp + pc[1]; a = printf((char *)t[-1], t[-2], t[-3], t[-4], t[-5], t[-6]); }
    else if (i == MALC) a = (int)malloc(*sp);
    else if (i == FREE) free((void *)*sp);
    else if (i == MSET) a = (int)memset((char *)sp[2], sp[1], *sp);
    else if (i == MCMP) a = memcmp((char *)sp[2], (char *)sp[1], *sp);
    else if (i == EXIT) { if (debug) printf("exit(%d) cycle = %d\n", (int)*sp, (int)cycle); return *sp; }
    else { printf("unknown instruction = %d! cycle = %d\n", (int)i, (int)cycle); return -1; }
  }
}