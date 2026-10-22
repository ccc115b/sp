#!/bin/bash
# 在容器內建立測試環境：br0 同時接「我們的 stack (tap0)」與「kernel 端 (tap1 = 虛擬另一台主機)」
# kernel 的 10.0.0.1 在 br0 上，透過 bridge 與我們的 stack(10.0.0.2@tap0) 互通
# 用法： bash test/setup-net.sh   (需 root，即 --privileged 容器內)
set -e
STACK_IP=10.0.0.2
PEER_IP=10.0.0.1
TAP=${1:-tap0}

ip link del br0 2>/dev/null || true
ip tuntap del $TAP mode tap 2>/dev/null || true
ip tuntap del tap1 mode tap 2>/dev/null || true

# 兩張虛擬網卡：tap0 = 我們的 stack；tap1 = kernel「另一台主機」
ip tuntap add $TAP mode tap
ip tuntap add tap1 mode tap

ip link add br0 type bridge
ip link set $TAP master br0
ip link set tap1 master br0
ip link set br0 up
ip link set $TAP up
ip link set tap1 up
ip addr add $PEER_IP/24 dev br0

echo "--- net setup done: peer(kernel-side)=$PEER_IP on br0, stack-side tap=$TAP ---"
ip -brief addr show br0
ip -brief addr show $TAP
ip -brief addr show tap1
