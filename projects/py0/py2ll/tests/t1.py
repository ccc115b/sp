def fact(n):
    if n <= 1:
        return 1
    return n * fact(n - 1)

def fib(n):
    a, b = 0, 1
    for i in range(n):
        a, b = b, a + b
    return a

print("fact(10) =", fact(10))
print("fact(20) =", fact(20))
print("fib(30) =", fib(30))
print([fib(i) for i in range(10)])
