// recursion.c - 遞迴呼叫、多參數函式
// expect: fib(10)=55 fib(20)=6765
// expect: gcd(1071,462)=21 gcd(48,18)=6
// expect: pow(2,10)=1024 pow(3,0)=1
int fib(int n)
{
  if (n < 2) return n;
  return fib(n - 1) + fib(n - 2);
}

int gcd(int a, int b)
{
  if (b == 0) return a;
  return gcd(b, a % b);
}

int ipow(int b, int e)
{
  int r;
  r = 1;
  while (e > 0) {
    if (e % 2) r = r * b;
    b = b * b;
    e = e / 2;
  }
  return r;
}

int main()
{
  printf("fib(10)=%d fib(20)=%d\n", fib(10), fib(20));
  printf("gcd(1071,462)=%d gcd(48,18)=%d\n", gcd(1071, 462), gcd(48, 18));
  printf("pow(2,10)=%d pow(3,0)=%d\n", ipow(2, 10), ipow(3, 0));
  return 0;
}
