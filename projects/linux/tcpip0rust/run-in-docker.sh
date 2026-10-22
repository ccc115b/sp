#!/bin/bash
# 在 Docker 中建立可測試 TUN/TAP 的特權容器並跑 Rust 版全套測試
# 用法（Mac 宿主機上）： bash run-in-docker.sh
set -e
NAME=tcpip-test
IMG=mydevvm:latest
PROJ=/ccc/115a/sp/projects/linux/tcpip0rust

if ! docker image inspect $IMG >/dev/null 2>&1; then
  echo "[*] mydevvm 不存在，用 ubuntu:24.04 構建（含 rustc + 測試工具）"
  cat <<'EOF' | docker build -t tcpip0-base - 2>/dev/null
FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential rustc cargo iproute2 net-tools iputils-ping tcpdump \
    curl python3 netcat-openbsd && rm -rf /var/lib/apt/lists/*
CMD ["sleep","infinity"]
EOF
  IMG=tcpip0-base
fi

if ! docker ps --format '{{.Names}}' | grep -qx $NAME; then
  docker rm -f $NAME >/dev/null 2>&1 || true
  echo "[*] 建立 --privileged 容器 $NAME（可建 TUN/TAP）"
  docker run -d --name $NAME --privileged \
    -v /Users/Shared/ccc:/ccc --workdir /ccc $IMG sleep infinity
fi

echo "[*] 編譯 + 全套測試："
docker exec $NAME bash -c "cd $PROJ && cargo build 2>&1 | tail -1 && bash test/run-tests.sh"
