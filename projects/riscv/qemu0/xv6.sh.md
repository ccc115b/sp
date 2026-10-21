
```
(.venv) ccc@teacherdeiMac qemu1xv6 % ./xv6.sh
[1/4] git clone xv6-riscv
Cloning into '/Users/ccc/Desktop/ccc/115a/sp/riscv/qemu1xv6/build/xv6-riscv'...
remote: Enumerating objects: 89, done.
remote: Counting objects: 100% (89/89), done.
remote: Compressing objects: 100% (81/81), done.
remote: Total 89 (delta 4), reused 23 (delta 4), pack-reused 0 (from 0)
Receiving objects: 100% (89/89), 90.86 KiB | 1.07 MiB/s, done.
Resolving deltas: 100% (4/4), done.
[2/4] 編譯 xv6(預設 rv64gc)
riscv64-unknown-elf-ld: warning: kernel/kernel has a LOAD segment with RWX permissions
riscv64-unknown-elf-ld: warning: user/_forktest has a LOAD segment with RWX permissions
[3/4] qemu0 已是最新
[4/4] 開機(約 10 秒;Ctrl-A x 結束)

xv6 kernel is booting

init: starting sh
$ ls
.              1 1 1024
..             1 1 1024
README         2 2 2441
cat            2 3 36816
echo           2 4 35648
forktest       2 5 17512
grep           2 6 40264
init           2 7 36112
kill           2 8 35592
ln             2 9 35400
ls             2 10 38952
mkdir          2 11 35632
rm             2 12 35624
sh             2 13 58696
stressfs       2 14 36504
usertests      2 15 203072
grind          2 16 51880
wc             2 17 37720
zombie         2 18 34992
logstress      2 19 37568
forphan        2 20 36432
dorphan        2 21 35896
sync           2 22 35048
console        3 23 0
$ wc README
48 336 2441 README
$ cat README | grep xv6
xv6 is a re-implementation of Dennis Ritchie's and Ken Thompson's Unix
Version 6 (v6).  xv6 loosely follows the structure and style of v6,
xv6 is inspired by John Lions's Commentary on UNIX 6th Edition (Peer
(kaashoek,rtm@mit.edu).  The main purpose of xv6 is as a teaching
$ exit
exec exit failed
$ 
[qemu0] Ctrl-A x:結束
```
