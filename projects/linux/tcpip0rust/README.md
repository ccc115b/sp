# tcpip0 — userspace TCP/IP stack (Rust 版)

由底層到應用層手刻的 userspace TCP/IP stack：TAP → Ethernet → ARP → IPv4 → ICMP/UDP/TCP → echo/HTTP/主動 client。
行程靠 TUN/TAP 收送 Ethernet 幀，不使用 socket API、不使用任何外部 crate（只用 std）。

對應的 C 版在 `../tcpip0/`（實作邏輯與測試法相同）。

## 架構

```
          main (事件迴圈 + timer)
           └── stack::Stack { nd, arp, tcp }   ←─ 所有網路狀態集中一處
                 │            ↑
 ethernet ──分發── ARP    icmp/udp ←─ ip ──分發── tcp
 (L2 收送)   │            └──────┴── ip::send ──┐
             └── 資料面單執行緒：reader thread 只讀 TAP 幀丟 channel ──┘
```

- `tap.rs`：ioctl(TUNSETIFF) 打開 TAP 裝置（`IFF_TAP|IFF_NO_PI`）、非阻塞讀寫
- `ethernet.rs`：L2 幀組裝/分解、廣播識別、分發到 ARP/IP
- `arp.rs`：IP↔MAC 表（TTL 30s）、查不到先排 pending 佇列（16 條）+ ARP request 限速重發
- `ip.rs`：收包檢查和/DST 過濾/分發、送包組 header（DF、TTL 64、增量 IP ID）
- `icmp.rs`：echo request → echo reply（ping 通）
- `udp.rs`：最小 UDP 收發
- `tcp.rs`：TCP 狀態機。主動/被動開啟、重傳（RTO 二倍退避，500ms×2^n）、MSS 分段、FIN/TIME_WAIT、RST；狀態：SYN_SENT/SYN_RCVD/ESTABLISHED/FIN_WAIT1/2/TIME_WAIT/LAST_ACK/CLOSE_WAIT
- `apps.rs`：echo server（9001）、迷你 HTTP（8080）、主動 client（寫 PING 收 REPLY）
- 借用策略：每個函式「短借用讀欄位 → 組段（純參數）→ 送出 → 再短借用更新」，
  讓 apps 的 callback 可以重入呼叫 `tcp::write()/close()`。

## 編譯與測試

```
cargo build                      # 編譯 target/debug/tcpip0rust
bash test/run-tests.sh           # 需 root（privileged 容器）
```

Mac 宿主機上：

```
bash run-in-docker.sh            # 建特權容器 + 編譯 + 全套測試
```

測試內容（test/run-tests.sh）：ICMP ping 3 發 3 中、TCP echo round-trip、
60KB 多 MSS echo 完整比對、HTTP 200、stack 主動 connect 到 kernel 等的 echo server。

## 手動使用

```
target/debug/tcpip0rust --tap tap0 --ip 10.0.0.2 --mask 255.255.255.0 --http
```

- `--tap tap0`          TAP 裝置名（需先存在：`ip tuntap add tap0 mode tap`）
- `--ip/--mask`         本機 IP/mask
- `--no-echo`           關掉 echo server（預設開，port 9001）
- `--http`              開啟迷你 HTTP server（預設關，port 8080）
- `--connect=ip:port`   主動連線：送 `PING\n`，收到的字元串原印回 stderr
- `--echo-port/--http-port` 換 port
- 平常會列 INFO；`--connect` 幀層的 debug 記錄在 debug build（`cargo build`）會出現 [D] 行

容器內典型布置：br0 上掛 tap0（本 stack, 10.0.0.2）與 tap1，kernel 的 10.0.0.1 在 br0 上；
詳見 test/setup-net.sh。

## 實作重點與限制

- 零外部 crate：TUN/TAP 靠 std::os::unix 直 ioctl；DNS/socket API 一律不碰
- 檢查和：IP／TCP（偽標頭）／ICMP 都重算驗證，TCP 收包不生效即棄
- seq 算術可繞回（wrap-around 比較），SYN/FIN 各佔 1 序號（C 版曾出錯之處）
- ARP 解析未完成時：packet 排隊；`tick()` 每秒限速重發一次 request，解掉就補送
- 限制：IP 不支援分片重組；TCP 只用固定 16KB window、無 SACK；MSS 定 1460；
  conn 上限 32 條（新 SYN 沒空位會被靜默丟）；對端不響應 ACK 則 RTO 重發至 2^n 退避上限
