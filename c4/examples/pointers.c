// pointers.c - 指標運算、sizeof、取址/解參考、全域變數、char/int 混用
// expect: sizeof int=8 char=1 ptr=8
// expect: *p=10 p[1]=20 p[2]=30
// expect: q-p=2 *q=30
// expect: *c=x c[1]=y chr=z
// expect: d-c=2
// expect: g=100 gc=Z
int g;
char gc;

int main()
{
  int *p; int *q; char *c; char *d;

  printf("sizeof int=%d char=%d ptr=%d\n", sizeof(int), sizeof(char), sizeof(int *));

  p = malloc(3 * sizeof(int));
  *p = 10; *(p + 1) = 20; *(p + 2) = 30;
  printf("*p=%d p[1]=%d p[2]=%d\n", *p, p[1], p[2]);

  q = p;
  q = q + 2;
  printf("q-p=%d *q=%d\n", q - p, *q);
  free(p);

  c = malloc(4);
  c[0] = 120; c[1] = 121; c[2] = 122; c[3] = 0;
  d = c + 2;
  printf("*c=%c c[1]=%c chr=%c\n", *c, c[1], *d);
  printf("d-c=%d\n", d - c);
  free(c);

  g = 100;
  gc = 'Z';
  printf("g=%d gc=%c\n", g, gc);
  return 0;
}
