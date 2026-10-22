#!/usr/bin/env bash
# dock0 煙霧測試：需要 busybox-static 與 util-linux 的 script
# 用法: tests/smoke.sh [path/to/dock0]
set -u
D=${1:-./target/release/dock0}
T=$(mktemp -d); export DOCK0_DIR=$T/state
R=$T/rootfs; mkdir -p $R/{bin,proc,dev,tmp,etc,sys,root,data}
cp "$(command -v busybox)" $R/bin/ && for c in sh ls ps cat echo hostname id sleep grep stty tty; do ln -sf busybox $R/bin/$c; done
echo lower > $R/etc/hello
pass=0; fail=0
ok() { if [ "$2" = "$3" ]; then pass=$((pass+1)); echo "  ok   $1"; else fail=$((fail+1)); echo "  FAIL $1 (got '$3', want '$2')"; fi; }

ok "hostname"            demo  "$($D run --host demo $R /bin/hostname)"
ok "PID namespace"       "1"   "$($D run $R /bin/sh -c 'ps | head -2 | tail -1 | cut -c1-5 | tr -d " "')"
ok "overlay 隔離"         lower "$($D run $R /bin/sh -c 'echo x > /etc/hello'; cat $R/etc/hello)"
ok "exit code"           42    "$($D run $R /bin/sh -c 'exit 42'; echo $?)"
ok "NoNewPrivs"          1     "$($D run $R /bin/sh -c 'grep NoNewPrivs /proc/self/status' | tr -dc 0-9)"
ok "seccomp filter"      2     "$($D run $R /bin/sh -c 'grep Seccomp: /proc/self/status' | tr -dc 0-9)"
ok "capability 集合"      a80425fb "$($D run $R /bin/sh -c 'grep CapEff /proc/self/status' | awk '{print $2}' | sed 's/^0*//')"
ok "/proc/sys 唯讀"       1     "$($D run $R /bin/sh -c 'echo x > /proc/sys/kernel/hostname 2>/dev/null; echo $?')"
ok "網路隔離 (只有 lo)"    lo    "$($D run $R /bin/sh -c 'cat /proc/net/dev' | tail -n +3 | cut -d: -f1 | tr -d ' \n')"
mkdir $T/vol; echo hi > $T/vol/f
ok "volume ro"           1     "$($D run -v $T/vol:/data:ro $R /bin/sh -c 'echo x > /data/g 2>/dev/null; echo $?')"
ok "env/workdir"         "bar /data" "$($D run -e FOO=bar -w /data $R /bin/sh -c 'echo $FOO $(pwd)')"

$D run -d --name smoke $R /bin/sleep 60 >/dev/null; sleep 0.5
ok "ps 看得到"           smoke "$($D ps | awk 'NR==2{print $1}')"
ok "exec 看得到 init"     1     "$($D exec smoke /bin/sh -c 'ps | head -2 | tail -1 | cut -c1-5 | tr -d " "')"
ok "exec exit code"      7     "$($D exec smoke /bin/sh -c 'exit 7'; echo $?)"
$D stop smoke >/dev/null
ok "stop 後清乾淨"        ""    "$(ls $DOCK0_DIR/containers)"

if command -v script >/dev/null; then
  out=$( (sleep 1; printf 'stty size; exit 5\n') | script -qec "stty rows 30 cols 100; $D run -t $R /bin/sh; echo rc=\$?" /dev/null | tr -d '\r')
  ok "tty winsize"       1  "$(echo "$out" | grep -c '^30 100$')"
  ok "tty exit code"     1  "$(echo "$out" | grep -c '^rc=5$')"
fi
rm -rf "$T"; echo "pass=$pass fail=$fail"; [ $fail -eq 0 ]
