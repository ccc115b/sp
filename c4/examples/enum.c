// enum.c - enum 定義（含指定值）
// expect: RED=0 GREEN=1 BLUE=10 GOLD=11
// expect: isBLUE=1 isRED=0
enum { RED, GREEN, BLUE = 10, GOLD };

int main()
{
  int c;
  printf("RED=%d GREEN=%d BLUE=%d GOLD=%d\n", RED, GREEN, BLUE, GOLD);
  c = BLUE;
  printf("isBLUE=%d isRED=%d\n", c == BLUE, c == RED);
  return 0;
}
