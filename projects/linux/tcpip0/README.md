# tcpip0 — 從底層到上層手刻一個 TCP/IP Protocol Stack（C, Linux userspace）

在 userspace 用 **TUN/TAP 虛擬網卡**，沿著真實網路堆疊的分層，從 **Ethernet (L2)** 一路寫到
**TCP (L4)** 與**應用層**（Echo / 迷你 HTTP），並支援 **stack 當伺服器**以及**stack 當 client**。

```
+--------------------------------------------------------+
|  app 層    apps.c      echo server / mini-HTTP / client|  <- 應用層 (callback on_accept/on_data/on_close)
+--------------------------------------------------------+
|  tcp 層    tcp.c       握手、ACK、seq 重傳(RTO)、FIN、  |
|                        TIME_WAIT、RST、out-of-order 丟棄 |
+--------------------------------------------------------+
|  ip 層     ip.c        IPv4 檢查和、DF、分發到 L4       |
|  icmp 層   icmp.c      echo request/reply (ping)        |
|  udp 層    udp.c       最小解析 + 檢查和驗證            |
+--------------------------------------------------------+
|  arp 層    arp.c       ARP 表、request/reply、pending Q |
+--------------------------------------------------------+
|  eth 層    ethernet.c  訊框組裝/解析、廣播辨識          |
|  netdev    netdev.c    我們這台虛擬主機的 MAC + IP      |
|  tap.c                 /dev/net/tun (IFF_TAP|IFF_NO_PI) |
+--------------------------------------------------------+
|  utils.c   檢查和 / 偽標頭 / hexdump / log               |
|  main.c    poll()+timer 事件迴圈                         |
+--------------------------------------------------------+
```

## 這個 stack 會做什麼

| 層 | 能力 |
|---|---|
| L2 Ethernet | 幀組裝/解析、廣播幀辨識、interface MAC 自訂 |
| ARP | 學習表(TTL 30s)、request/reply 應答、送包前自動 ARP + pending queue 重試 |
| IPv4 | 標頭解析/檢查和、DF flag、依 proto 分發 (ICMP/UDP/TCP)、不支援轉發與分片重組 |
| ICMP | echo reply → `ping` 可通 |
| UDP | 檢查和驗證 + log（未提供服務） |
| TCP | 被動/主動建立連線、按序收發、ACK、RTO 指數退避重傳、FIN/CLOSE_WAIT/LAST_ACK/TIME_WAIT、RST、SYN 重傳回應 |
| app | TCP echo server、迷你 HTTP server、client 示範 |

## 檔案結構

```
src/
  main.c       poll() + 50ms timer 事件迴圈、參數解析
  tap.c        開啟 /dev/net/tun (TAP mode、非阻塞)
  netdev.c     虛擬網卡 (MAC + IP + MTU)
  ethernet.c   L2 收送
  arp.c        ARP 表 / pending queue / tick 重試
  ip.c         IPv4 收發與分發
  icmp.c       ping
  udp.c        UDP 最小支援
  tcp.c        自製 TCP 狀態機（本專案核心）
  apps.c       echo / HTTP / client_demo（示範如何寫應用）
  utils.c      Internet checksum、偽標頭 checksum、hexdump
test/
  setup-net.sh   在容器內建 br0 + 兩張 TAP（kernel 當對端）
  run-tests.sh   完整自動化測試（ping/echo/60KB/HTTP/connect）
Makefile         make / make debug (DEBUG 有逐包日誌)
run-in-docker.sh 宿主機一鍵開特權容器進專案
```

## 如何編譯與測試

### 建置
```bash
make          # release
make debug    # -DDEBUG：每層都有封包日誌（除錯必備）
```

### Docker 環境（推薦，搞砸了重開容器就好）

```bash
# Mac 上：
bash run-in-docker.sh                     # 建立特權容器
docker exec -it tcpip0-dev bash
cd /ccc/115a/sp/projects/linux/tcpip0
make debug
bash test/run-tests.sh                    # 一鍵全套測試
```

容器內的測試架構（`test/setup-net.sh`）：

```
        --- br0 (kernel bridge) 10.0.0.1/24 這是「對端主機」---
        |                    |
     tap1 (kernel 側 NIC)   tap0 (我們的 protocol stack 綁定 10.0.0.2)
```
所以 kernel 自己就是「另一台電腦」，`ping/curl/nc/python` 全是自己人，
我們的 stack 是 10.0.0.2 上的真實網路節點，彼此走 ARP/Ethernet/IP。
（容器 `--privileged` 時 br0 自帶 10.0.0.1；若用 --cap-add=NET_ADMIN 的方式亦同。）

### 手動跑
```bash
sudo ./debug --tap tap0 --ip 10.0.0.2 --mask 255.255.255.0 --http
# 另一個終端（同主機或 bridge）：
ping 10.0.0.2
curl http://10.0.0.2:8080/
echo hello | nc 10.0.0.2 9001
```

### stack 當 client 主動連線
```bash
# kernel 端開個 echo server
python3 -c "..." &   # 見 test/run-tests.sh 第 6 步
./debug --tap tap0 --ip 10.0.0.2 --mask 255.255.255.0 --no-echo --connect=10.0.0.1:7000
# log 內會出現 client recv ... REPLY:PING
```

## Debug

- `stack.log` 內 `[D]` 為封包層觀察（tcpdump 之於 tap0 也可以）：
  ```bash
  tcpdump -i tap0 -nn        # 看我們的幀
  tcpdump -i br0  -nn        # 看 bridge 內跨層的幀
  ```
- 抓下來可丟 Wireshark：
  ```bash
  tcpdump -i tap0 -w /shared/traffic.pcap
  # 宿主機：open traffic.pcap 或 wireshark
  # 得注意 TAP 實際給的是 L2 幀，Wireshark 可直接解。
  ```
- 觀察內部狀態：送 `SIGUSR1` 會印出 ARP 表與全部 TCP 連線狀態（`kill -USR1 <stack pid>`）

## 已知簡化 / 上限（可作為練習的下一步）

1. **out-of-order 一律丟棄**：不快取亂序段、不做重複 ACK 累計；靠對端 RTO 重傳。
2. **不支援 IP 分片重組**（收到分片直接丟），也不做路由轉發（非本機 IP 不 forward）。
3. **滑動窗口**：通告固定 16KB；不做 slow start / congestion control / RTT 自動調節。
4. send queue 為 go-back-n 風格：僅重送最舊未確認段。
5. listener 沒有半連線佇列 (backlog) 與 SYN flood 防護。
6. TIME_WAIT 固定 4 秒、不處理 simultaneous open/close 全分支。

可以自己動手加的方向：
- 實作 sliding window 與 RFC 6298 的 RTT 估算
- IP 分片重組 + 轉發 → 自動像台 router
- 加 UDP DNS client → 整條協定棧就能解析網域
- SYN 重送防護 / backlog 佇列
