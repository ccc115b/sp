#include <stdio.h>
#include <string.h>
#include <stdint.h>
typedef struct { int a, b; char tag[12]; long big[4]; } S;
typedef int (*op_t)(int, int);
static int add(int a, int b) { return a + b; }
static int mul(int a, int b) { return a * b; }
static int apply(op_t f, int x, int y) { return f(x, y); }
S copy(S s) { S t = s; t.a += 1; return t; }
int ten(int a,int b,int c,int d,int e,int f,int g,int h,int i,int j){ return a+b*2+c*3+d*4+e*5+f*6+g*7+h*8+i*9+j*10; }
int bigframe(int n) { int buf[5000]; for (int i = 0; i < 5000; i++) buf[i] = i ^ n; int s = 0; for (int i = 0; i < 5000; i += 7) s += buf[i]; return s; }
uint8_t u8(uint8_t x) { return x * 3 + 200; }
int16_t s16(int16_t x) { return x * x; }
int64_t mix(int64_t a, uint32_t b, int8_t c) { return a * (int64_t)b - c + (a >> 3) + (int64_t)((uint64_t)a >> 60); }
int cls(int c) { switch (c) { case 'a': return 1; case 'b': return 2; case 'z': return 26; case 100: return 7; default: return 0; } }
int main(void) {
  S s = {1, 2, "hi", {10, 20, 30, 40}}; S t = copy(s);
  printf("%d %d %s %ld\n", t.a, t.b, t.tag, t.big[3]);
  printf("%d %d\n", apply(add, 3, 4), apply(mul, 3, 4));
  printf("%d %d\n", ten(1,2,3,4,5,6,7,8,9,10), bigframe(5));
  printf("%d %d %ld\n", u8(100), s16(300), (long)mix(-123456789012345L, 4000000000u, -5));
  printf("%d %d %d %d\n", cls('a'), cls('z'), cls(100), cls(5));
  uint32_t x = 0xdeadbeef; printf("%u %d %u\n", x >> 4, (int)x >> 4, x * 2654435761u);
  return 0;
}
