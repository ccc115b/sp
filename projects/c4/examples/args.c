// args.c - argc / argv
// args: alpha 42
// expect: argc=3
// expect: argv[1]=alpha
// expect: argv[2]=42
// expect: len(alpha)=5 len(42)=2
int strlen(char *s)
{
  int n;
  n = 0;
  while (*s) { n = n + 1; s = s + 1; }
  return n;
}

int main(int argc, char **argv)
{
  int i;
  printf("argc=%d\n", argc);
  i = 1;
  while (i < argc) {
    printf("argv[%d]=%s\n", i, argv[i]);
    i = i + 1;
  }
  printf("len(%s)=%d len(%s)=%d\n", argv[1], strlen(argv[1]), argv[2], strlen(argv[2]));
  return 0;
}
