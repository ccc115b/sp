// strings.c - char* 字串處理：strlen/strcmp/strcpy/strcat/大小寫/原地反轉
// expect: len=5 hello
// expect: cmp eq=0 lt=-1 gt=111
// expect: rev=gfedcba len=7
// expect: cat=hello, world
// expect: upper=HELLO, WORLD
int strlen(char *s)
{
  int n;
  n = 0;
  while (*s) { n = n + 1; s = s + 1; }
  return n;
}

int strcmp(char *a, char *b)
{
  while (*a && *a == *b) { a = a + 1; b = b + 1; }
  return *a - *b;
}

int strcpy(char *d, char *s)
{
  char *r;
  r = d;
  while (*s) { *d = *s; d = d + 1; s = s + 1; }
  *d = 0;
  return r;
}

int strcat(char *d, char *s)
{
  d = d + strlen(d);
  strcpy(d, s);
  return d;
}

int upper(char *s)
{
  char *r; char c;
  r = s;
  while (*s) {
    c = *s;
    if (c >= 'a' && c <= 'z') *s = c - 'a' + 'A';
    s = s + 1;
  }
  return r;
}

int main()
{
  char *s; char *buf; int i; int j; char c;

  s = "hello";
  printf("len=%d %s\n", strlen(s), s);
  printf("cmp eq=%d lt=%d gt=%d\n",
         strcmp(s, "hello"), strcmp(s, "hellp"), strcmp(s, "hell"));

  buf = malloc(32);
  strcpy(buf, "abcdefg");
  i = 0; j = strlen(buf) - 1;
  while (i < j) {
    c = buf[i]; buf[i] = buf[j]; buf[j] = c;
    i = i + 1; j = j - 1;
  }
  printf("rev=%s len=%d\n", buf, strlen(buf));

  strcpy(buf, "hello");
  strcat(buf, ", world");
  printf("cat=%s\n", buf);

  upper(buf);
  printf("upper=%s\n", buf);

  free(buf);
  return 0;
}
