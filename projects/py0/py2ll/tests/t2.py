import sys

class Animal:
    count = 0
    def __init__(self, name, legs=4):
        self.name = name
        self.legs = legs
    def speak(self):
        return self.name + " makes a sound"
    def __str__(self):
        return "Animal(" + self.name + ")"

class Dog(Animal):
    def speak(self):
        return self.name + " barks"

class MyErr(Exception):
    pass

def bubble(xs):
    n = len(xs)
    for i in range(n):
        for j in range(n - 1 - i):
            if xs[j] > xs[j + 1]:
                xs[j], xs[j + 1] = xs[j + 1], xs[j]
    return xs

def qsort(xs):
    if len(xs) <= 1:
        return xs
    p = xs[0]
    return qsort([x for x in xs[1:] if x < p]) + [p] + qsort([x for x in xs[1:] if x >= p])

def risky(n):
    if n == 0:
        raise MyErr("zero!")
    return 10 // n

animals = [Animal("cat"), Dog("rex")]
for a in animals:
    print(a.speak(), "|", a, "|", a.legs)

print(bubble([5, 2, 9, 1, 5, 6]))
print(qsort([3, 1, 4, 1, 5, 9, 2, 6, 5, 3]))
d = {}
for w in "the quick brown fox jumps over the lazy dog the end".split():
    d[w] = d.get(w, 0) + 1
print(sorted(d.items()))
print(d["the"], len(d), "fox" in d, "cow" in d)

for v in [2, 0]:
    try:
        print("risky", risky(v))
    except MyErr as e:
        print("caught", e)
    finally:
        print("finally", v)
try:
    x = 1 // 0
except ZeroDivisionError as e:
    print("zde:", e)
try:
    [1, 2][5]
except IndexError as e:
    print("idx:", e)
try:
    {}["k"]
except KeyError as e:
    print("key:", e)

name = "world"; n = 3.14159
print(f"hello {name}! {n:.2f} {n!r} {3 + 4:>5}|{'ab':<4}|{255:x}")
print("%s is %d years, %.1f%%" % ("Bob", 42, 99.5))
s = "Hello, World"
print(s[1:5], s[::-1], s.upper(), s.lower(), s.find("World"), s.replace("l", "L"))
print(", ".join(["a", "b", "c"]), "a,b,c".split(","), "  pad ".strip() + "|")
print(7 // 2, -7 // 2, 7 % 3, -7 % 3, 2 ** 10, 7 / 2, 1 << 5, 0xff & 0x0f)
print(1.5 + 2, 10 / 4, 1e3, 0.1 + 0.2, float("2.5"), int("42") + 1, round(2.675, 2))
print(min(3, 1, 2), max([4, 8, 2]), sum([1, 2, 3]), abs(-5), len("abc"))
print(list(range(0, 10, 3)), list(range(5, 0, -2)), tuple([1, 2]), (1,), [])
print(list(zip([1, 2, 3], "abc")), list(enumerate(["x", "y"])))
print(1 < 2 < 3, 3 > 2 > 2, not 0, None is None, 5 in [1, 5], "a" not in "xyz")
i = 0
while True:
    i += 1
    if i == 3:
        continue
    if i > 5:
        break
    print("i", i, end=" ")
print()
sq = lambda x: x * x
print(sq(7), isinstance(3, int), isinstance("s", str), isinstance(animals[1], Animal))
t = (1, "two", 3.0)
a, b, c = t
print(a, b, c, t, {1, 2, 3} == {3, 2, 1})
sys.stderr.write("to stderr\n")
print(sys.argv[1:] if len(sys.argv) > 1 else "noargs")
