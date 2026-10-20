// arith.c - 算術、位元、比較、三元運算子、遞增遞減、一元運算
// 注意：c4 的 printf 最多支援 format + 5 個參數
// expect: a+b=10 a-b=2 a*b=24 a/b=1 a%b=2
// expect: a<<1=12 a>>1=3 a|b=6 a&b=4 a^b=2
// expect: -a=-6 ~a=-7 !a=0 !z=1
// expect: a<b=0 a>b=1 a==b=0 a!=b=1 a<=b=0
// expect: a>=b=1 cond=yes y=100
// expect: post 5 6 pre 8 7
int main()
{
  int a; int b; int z; int i; int y;
  a = 6; b = 4; z = 0;

  printf("a+b=%d a-b=%d a*b=%d a/b=%d a%%b=%d\n", a + b, a - b, a * b, a / b, a % b);
  printf("a<<1=%d a>>1=%d a|b=%d a&b=%d a^b=%d\n", a << 1, a >> 1, a | b, a & b, a ^ b);
  printf("-a=%d ~a=%d !a=%d !z=%d\n", -a, ~a, !a, !z);
  printf("a<b=%d a>b=%d a==b=%d a!=b=%d a<=b=%d\n", a < b, a > b, a == b, a != b, a <= b);
  printf("a>=b=%d cond=%s y=%d\n", a >= b, (a > b) ? "yes" : "no", (a > b) ? 100 : 200);

  i = 5;
  printf("post %d %d pre %d %d\n", i++, i++, ++i, --i);

  y = (a > b) ? 100 : 200;
  if (y != 100) return 1;
  return 0;
}
