counter = 0
LOG = []

def bump(k):
    global counter
    counter += k
    LOG.append(counter)

def find(xs, t):
    for i, x in enumerate(xs):
        if x == t:
            break
    else:
        return -1
    return i

def try_return(n):
    for i in range(10):
        try:
            if i == n:
                return "ret%d" % i
            if i % 2 == 0:
                continue
            if i > 6:
                break
        finally:
            LOG.append(-i)
    return "done"

def depth(n):
    if n == 0:
        return 0
    return 1 + depth(n - 1)

def collatz(n):
    steps = 0
    while n != 1:
        n = n // 2 if n % 2 == 0 else 3 * n + 1
        steps += 1
    return steps

class Stack:
    def __init__(self):
        self.items = []
    def push(self, x):
        self.items.append(x)
    def pop(self):
        if not self.items:
            raise IndexError("pop from empty stack")
        return self.items.pop()
    def __len__(self):
        return len(self.items)

class Vec:
    def __init__(self, x, y):
        self.x = x
        self.y = y
    def __eq__(self, o):
        return self.x == o.x and self.y == o.y
    def __repr__(self):
        return "Vec(%d, %d)" % (self.x, self.y)

bump(3); bump(4)
print(counter, LOG)
print(find([1, 2, 3], 3), find([1, 2, 3], 9))
print(try_return(3), try_return(99), LOG[-5:])
print(depth(900))
total = 0
for n in range(1, 30000):
    total += collatz(n)
print("collatz total", total)

s = Stack()
for i in range(3):
    s.push(i * i)
print(len(s), s.pop(), s.pop(), s.pop())
try:
    s.pop()
except IndexError as e:
    print("err:", e)
print(Vec(1, 2) == Vec(1, 2), Vec(1, 2) == Vec(2, 1), [Vec(0, 0)], str(Vec(3, 4)))

a = {1, 2, 3}; b = {3, 4}
print(sorted(a | b), sorted(a & b), sorted(a - b), len(a))
d = {"x": 1, "y": 2}
for k in d:
    print(k, d[k], end="; ")
print()
del d["x"]
print(d, list(d.keys()), list(d.values()))
n = 0
while n < 3:
    n += 1
else:
    print("while-else", n)
print([i * j for i in range(3) for j in range(3) if i != j])
print("%5d|%-5d|%05.1f|%x|%c" % (42, 42, 3.14159, 255, 65))
print("{} {:>4} {:.3f}".format("a", 7, 2.0))
print(str(12) + "!", repr("it's"), 'a\tb', "nl\\n", len("tab\t"), ord("A"), chr(97))
words = ["banana", "apple", "cherry"]
words.sort()
print(words, words[::-1])
x = [3, 1, 2]
x.reverse(); x.insert(0, 9); x.extend([7, 7]); x.remove(7)
print(x, x.index(2), x.count(7), x.pop(0), x)
print(int("ff", 16), hex(255), bin(5), 10 ** 18, -2 ** 2, ~5, 5 ^ 3)
print(divmod(17, 5), 17 // -5, 17 % -5, 2 ** -1, 9 ** 0.5)
