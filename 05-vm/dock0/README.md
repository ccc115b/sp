# dock0

用 Rust 寫成的微型容器執行器（約 1,200 行，只依賴 `libc`）。

## 功能

| 類別 | 內容 |
|---|---|
| **Rootless** | User namespace（容器內 uid 0 ↔ 主機上的你），不需要 sudo |
| **隔離** | PID / Mount / UTS / IPC / Network namespace；`pivot_root` 換根 |
| **映像分層** | overlayfs：rootfs 當唯讀 lower，容器寫入進 upper，結束即丟棄 |
| **安全強化** | capabilities 縮減到 Docker 預設集、`no_new_privs`、seccomp 黑名單（含 clone 的 namespace flag 與 x32/32-bit 相容層）、遮蔽 `/proc/kcore` 等敏感路徑、`/proc/sys` 唯讀 |
| **終端機** | `-t` 配置 pty、轉送輸入輸出、同步視窗大小、本機終端 raw 模式 |
| **管理** | `-d` 背景執行、`ps`、`stop`、`logs [-f]`、`exec [-t]`（用 `setns` 進入既有容器） |
| **PID 1** | 內建 init：轉送訊號、回收殭屍行程 |
| **其他** | `-v` volume（可 `:ro`）、`-e`、`-w`、`--name`、`--net`、cgroup v2 的 `--mem/--pids/--cpus` |

## 建置與使用

```sh
cargo build --release

# 準備 rootfs —— 請用「執行 dock0 的同一個使用者」解開（見下方「注意」）
mkdir rootfs && docker export $(docker create alpine) | tar -x -C rootfs

./target/release/dock0 run -it ./rootfs /bin/sh
./target/release/dock0 run -d --name web -v $PWD/site:/srv:ro -w /srv ./rootfs /bin/httpd -f
./target/release/dock0 ps
./target/release/dock0 exec -it web /bin/sh
./target/release/dock0 logs -f web
./target/release/dock0 stop web
```

驗證：`tests/smoke.sh`（需要 `busybox-static` 與 `script`）。

## 注意（rootless 的限制）

1. **rootfs 的擁有者**：只對映了一組 uid/gid（你自己 → 容器內 root）。rootfs 必須整棵屬於你
   （uid *和* gid），否則 overlay copy-up 會得到 `Value too large for defined data type`，
   或在容器內看到 `nobody`。用 `sudo tar` 解出來的 rootfs 請 `sudo chown -R $USER:$(id -gn)`。
2. **容器內只有一個 uid**：`apt`、`su`、`adduser` 這類需要多 uid 的操作無法使用。要支援需用
   setuid 的 `newuidmap/newgidmap` 與 `/etc/subuid`（待做）。
3. **核心需求**：Linux 5.11+（user namespace 內的 overlayfs）。狀態目錄
   （`DOCK0_DIR`，預設 `~/.local/share/dock0`）必須在支援 xattr 的檔案系統上（ext4/xfs/btrfs；
   舊核心的 tmpfs 不行）。
4. **發行版設定**：若出現 `unshare(CLONE_NEWUSER)` 失敗，檢查
   `sysctl user.max_user_namespaces`、`kernel.unprivileged_userns_clone`，Ubuntu 24.04 另需
   `sysctl kernel.apparmor_restrict_unprivileged_userns=0`。
5. **資源限制**：只支援 cgroup v2，rootless 需要 cgroup 委派（systemd user slice）；
   做不到時會警告並略過，容器照常執行。
6. 日誌與狀態在容器結束時一併刪除；`stop` 先送 SIGTERM（由 init 轉給 app），10 秒後 SIGKILL。

## 已驗證 / 未驗證

在一台 Linux 6.18 / cgroup v1 的沙箱中以 root 與 `nobody` 兩種身分實測通過
（`tests/smoke.sh` 17 項）。**cgroup v2 的限制實際生效（含 OOM kill）與 Ubuntu 24.04 的
AppArmor 限制，尚未在真機驗證。**

## 之後可以做

多 uid 對映（newuidmap）、OCI image pull、veth + bridge 網路與 port mapping、
`--read-only` rootfs、可設定的 seccomp/capability profile、`dock0 commit`、以 `clap` 重寫 CLI。
