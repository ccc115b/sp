// hello.c - 最基本的 printf 與字串輸出
// expect: hello, world!
// expect: 42 = 42
int main()
{
  printf("hello, world!\n");
  printf("%d = %d\n", 42, 42);
  return 0;
}
