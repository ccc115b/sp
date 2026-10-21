// sort.c - int* 陣列、插入排序、由大到小、線性搜尋
// expect: asc: 1 2 3 4 5 6 7 8 9
// expect: desc: 9 8 7 6 5 4 3 2 1
// expect: search 7 -> index 6
// expect: sum=45 min=1 max=9
int main()
{
  int *a; int n; int i; int j; int t; int sum; int min; int max; int idx;

  n = 9;
  a = malloc(n * sizeof(int));
  a[0] = 9; a[1] = 3; a[2] = 7; a[3] = 1; a[4] = 5;
  a[5] = 2; a[6] = 8; a[7] = 4; a[8] = 6;

  i = 1;
  while (i < n) {
    t = a[i];
    j = i - 1;
    while (j >= 0 && a[j] > t) {
      a[j + 1] = a[j];
      j = j - 1;
    }
    a[j + 1] = t;
    i = i + 1;
  }

  printf("asc:");
  i = 0;
  while (i < n) { printf(" %d", a[i]); i = i + 1; }
  printf("\n");

  printf("desc:");
  i = n - 1;
  while (i >= 0) { printf(" %d", a[i]); i = i - 1; }
  printf("\n");

  idx = -1;
  i = 0;
  while (i < n) { if (a[i] == 7) idx = i; i = i + 1; }
  printf("search 7 -> index %d\n", idx);

  sum = 0; min = a[0]; max = a[0];
  i = 0;
  while (i < n) {
    sum = sum + a[i];
    if (a[i] < min) min = a[i];
    if (a[i] > max) max = a[i];
    i = i + 1;
  }
  printf("sum=%d min=%d max=%d\n", sum, min, max);

  free(a);
  return 0;
}
