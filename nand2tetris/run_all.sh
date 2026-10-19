#!/bin/sh
set -e
cd "$(dirname "$0")"

./jack/run.sh
./vm-emu/run.sh
./vm2asm/run.sh
./hackasm/run.sh
./hackemu/run.sh
./os/run.sh

echo "全部通過。"
