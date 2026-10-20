// fizzbuzz.c - while 迴圈、if/else if、取餘數
// expect: 1
// expect: 2
// expect: Fizz
// expect: 4
// expect: Buzz
// expect: Fizz
// expect: 7
// expect: 8
// expect: Fizz
// expect: Buzz
// expect: 11
// expect: Fizz
// expect: 13
// expect: 14
// expect: FizzBuzz
// expect: 16
// expect: 17
// expect: Fizz
// expect: 19
// expect: Buzz
int main()
{
  int i;
  i = 1;
  while (i <= 20) {
    if (i % 15 == 0) printf("FizzBuzz\n");
    else if (i % 3 == 0) printf("Fizz\n");
    else if (i % 5 == 0) printf("Buzz\n");
    else printf("%d\n", i);
    i = i + 1;
  }
  return 0;
}
