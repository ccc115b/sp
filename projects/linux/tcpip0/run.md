```sh
(.venv) cccuser@cccimacdeiMac tcpip0 % docker exec -it tcpip0-dev bash

root@81d01b60f186:/ccc# cd /ccc/115a/sp/projects/linux/tcpip0
root@81d01b60f186:/ccc/115a/sp/projects/linux/tcpip0# make debug
gcc -Wall -Wextra -std=c99 -g -O2 -o tcpip src/apps.c src/arp.c src/ethernet.c src/icmp.c src/ip.c src/main.c src/netdev.c src/tap.c src/tcp.c src/udp.c src/utils.c
gcc -Wall -Wextra -std=c99 -g -O0 -DDEBUG -o debug src/apps.c src/arp.c src/ethernet.c src/icmp.c src/ip.c src/main.c src/netdev.c src/tap.c src/tcp.c src/udp.c src/utils.c
root@81d01b60f186:/ccc/115a/sp/projects/linux/tcpip0# ./bash test/run-tests.sh
bash: ./bash: No such file or directory
root@81d01b60f186:/ccc/115a/sp/projects/linux/tcpip0# bash test/run-te
sts.sh
== 0) 建網路環境 ==
== 1) 啟動自製 protocol stack ==
  [PASS] stack up
== 2) ICMP ping ==
  [PASS] ping 0% loss
== 3) TCP echo ==
timeout: failed to run command 'nc': No such file or directory
  [FAIL] echo ()
== 4) TCP 多段資料 (60KB > MTU) ==
timeout: failed to run command 'nc': No such file or directory
  [FAIL] echo 60KB
== 5) 迷你 HTTP ==
  [PASS] HTTP 200
== 6) stack 當 client (主動連線到 kernel 的 echo 服務) ==
  [PASS] active connect + 收到回應

SOME TESTS FAILED (看 stack.log 除錯：DEBUG 版有封包層級日誌)
```