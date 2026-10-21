```
(.venv) ccc@teacherdeiMac qemu1xv6 % ./spike.sh examples/fib.s
[1/3] riscv64-unknown-elf-gcc fib.s -> fib
[2/3] cargo build --release
[3/3] spike0 fib
0
1
1
2
3
5
8
13
21
34
55
89
144
233
377
```
