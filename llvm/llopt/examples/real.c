#include <stdint.h>
int gcd(int a, int b) { while (b != 0) { int t = a % b; a = b; b = t; } return a; }
int fib(int n) { if (n < 2) return n; return fib(n - 1) + fib(n - 2); }
int collatz(int n) { int steps = 0; while (n != 1 && steps < 1000) { if (n % 2 == 0) n = n / 2; else n = 3 * n + 1; steps++; } return steps; }
int poly(int x) { int a = x * 4 + 3; int b = x * 4 + 3; int c = (a + b) * 1 + 0; return c - c + a * 8 + (x ? 1 : 1); }
int arr(int n) { int v[8]; for (int i = 0; i < 8; i++) v[i] = i * n; int s = 0; for (int i = 0; i < 8; i++) s += v[i]; return s; }
int sw(int x) { switch (x) { case 0: return 11; case 1: return 22; case 5: return x * 3; default: return -x; } }
int mix(unsigned x, int y) { unsigned u = x / 16 + x % 8; int k = (y << 3) >> 1; return (int)u + k + (y == y) + (x >= 0); }
