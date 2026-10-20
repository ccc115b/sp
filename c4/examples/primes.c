// primes.c - malloc/memset/free、char* 篩法求質數
// expect: 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47
// expect: count=15
int main()
{
  char *sieve;
  int n; int i; int j; int count;

  n = 50;
  sieve = malloc(n);
  memset(sieve, 1, n);

  i = 2;
  while (i < n) {
    if (sieve[i]) {
      j = i + i;
      while (j < n) { sieve[j] = 0; j = j + i; }
    }
    i = i + 1;
  }

  count = 0;
  i = 2;
  while (i < n) {
    if (sieve[i]) {
      if (count) printf(" ");
      printf("%d", i);
      count = count + 1;
    }
    i = i + 1;
  }
  printf("\ncount=%d\n", count);

  free(sieve);
  return 0;
}
