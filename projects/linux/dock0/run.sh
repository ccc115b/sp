cargo build --release

# 準備 rootfs —— 請用「執行 dock0 的同一個使用者」解開（見下方「注意」）
mkdir rootfs && docker export $(docker create alpine) | tar -x -C rootfs

./target/release/dock0 run -it ./rootfs /bin/sh
./target/release/dock0 run -d --name web -v $PWD/site:/srv:ro -w /srv ./rootfs /bin/httpd -f
./target/release/dock0 ps
./target/release/dock0 exec -it web /bin/sh
./target/release/dock0 logs -f web
./target/release/dock0 stop web