#!/bin/bash
# 在 Docker 中建立可測試 TUN/TAP 的開發容器並進入專案目錄
# 用法（Mac 宿主機上）： bash run-in-docker.sh
# 若 /dev/net/tun 不存在或無 NET_ADMIN，本腳本會建立「特權」容器
set -e

NAME=tcpip0-dev
IMG=mydevvm:latest   # 若沒有這個 image 就改用 03-docker 構建的 image 名稱（見下方 dig）

if ! docker image inspect $IMG >/dev/null 2>&1; then
  echo "[*] mydevvm 不存在，直接用 ubuntu:24.04 構建 (apt 裝 iproute2 等)"
  cat <<'EOF' | docker build -t tcpip0-base - 2>/dev/null
FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gdb iproute2 net-tools iputils-ping tcpdump curl \
    python3 netcat-openbsd && rm -rf /var/lib/apt/lists/*
CMD ["sleep","infinity"]
EOF
  IMG=tcpip0-base
fi

if docker ps -a --format '{{.Names}}' | grep -qx $NAME; then
  docker rm -f $NAME >/dev/null
fi

echo "[*] 建立 --privileged 容器 $NAME (可建 TUN/TAP、改路由)"
echo "[*] /dev/net/tun 已掛進容器；共享目錄 /ccc"

docker run -d --name $NAME --privileged \
  -v /Users/Shared/ccc:/ccc --entrypoint sleep $IMG infinity

echo "[*] 進容器："
echo "    docker exec -it $NAME bash"
echo "    cd /ccc/115a/sp/projects/linux/tcpip0"
echo "    make && make debug"
echo "    bash test/run-tests.sh   # 全套自動測試"
