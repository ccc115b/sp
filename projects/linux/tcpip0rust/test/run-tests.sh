#!/bin/bash
# 完整測試：ping (ICMP) / echo (TCP) / 大流量 / HTTP / 主動 connect
# 在 --privileged 的容器內執行：bash test/run-tests.sh
cd "$(dirname "$0")/.."
STACK_IP=10.0.0.2
PEER_IP=10.0.0.1
BIN=target/debug/tcpip0rust

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILED=1; }
FAILED=0

kill_stack() { pkill -9 -x tcpip0rust 2>/dev/null; sleep 0.5; }

echo "== 0) 建網路環境 =="
kill_stack
bash test/setup-net.sh tap0 >/dev/null

echo "== 1) 啟動自製 protocol stack =="
timeout 40 $BIN --tap tap0 --ip $STACK_IP --mask 255.255.255.0 --http > stack.log 2>&1 &
STACK_PID=$!
sleep 1
grep -q "tcpip0rust starting" stack.log || { echo "[FAIL] stack 沒起來"; cat stack.log; exit 1; }
echo "  [PASS] stack up"

echo "== 2) ICMP ping =="
ping -c 3 -W 1 $STACK_IP 2>&1 | grep -q ", 0% packet loss" && pass "ping 0% loss" || fail "ping"

echo "== 3) TCP echo =="
OUT=$(printf "hello tcpip\n" | timeout 4 nc -w 3 $STACK_IP 9001 2>/dev/null)
[ "$OUT" = "hello tcpip" ] && pass "echo round-trip" || fail "echo ($OUT)"

echo "== 4) TCP 多段資料 (60KB > MTU) =="
if [ ! -s /tmp/blob_src.txt ]; then
  head -c 45000 /dev/urandom | base64 -w 0 > /tmp/blob_src.txt
fi
timeout 15 nc -w 8 $STACK_IP 9001 < /tmp/blob_src.txt > /tmp/blob_out.txt 2>/dev/null
cmp -s /tmp/blob_src.txt /tmp/blob_out.txt && pass "echo 60KB integrity" || fail "echo 60KB"

echo "== 5) 迷你 HTTP =="
C=$(curl -s -o /dev/null -w "%{http_code}" http://$STACK_IP:8080/)
[ "$C" = "200" ] && pass "HTTP 200" || fail "HTTP ($C)"

echo "== 6) stack 當 client (主動連線到 kernel 的 echo 服務) =="
timeout 15 python3 - "$PEER_IP" <<'EOF' > /tmp/srv.log 2>&1 &
import socket, threading, sys, time
s = socket.socket()
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
s.bind((sys.argv[1], 7000))
s.listen(5)
def h(c):
    d = c.recv(1024)
    c.sendall(b"REPLY:" + d)
    c.close()
end = time.time() + 12
n = 0
while time.time() < end and n < 5:
    try:
        c, _ = s.accept()
    except OSError:
        break
    n += 1
    threading.Thread(target=h, args=(c,)).start()
EOF
SRV_PID=$!
sleep 1
kill $STACK_PID 2>/dev/null
sleep 0.5
timeout 20 $BIN --tap tap0 --ip $STACK_IP --mask 255.255.255.0 --no-echo --connect=$PEER_IP:7000 > stack2.log 2>&1 &
STACK2_PID=$!
sleep 5
grep -q "REPLY:PING" stack2.log && pass "active connect + 收到回應" || fail "active connect"
kill $STACK2_PID $SRV_PID 2>/dev/null

echo
[ $FAILED -eq 0 ] && echo "ALL TESTS PASSED" || echo "SOME TESTS FAILED (看 stack.log 除錯)"
exit $FAILED
