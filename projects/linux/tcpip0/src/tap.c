#include "tap.h"
#include "utils.h"
#include <fcntl.h>
#include <string.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <linux/if.h>
#include <linux/if_tun.h>

/* 開啟 TAP 裝置：IFF_TAP 表 L2 (Ethernet) 訊框；
   IFF_NO_PI 移除 tun 前置 4 bytes 的額外標頭，讓我們直接處理原始 Ethernet 幀 */
int tap_open(const char *name)
{
    int fd = open("/dev/net/tun", O_RDWR);
    if (fd < 0) {
        LOG_E("open /dev/net/tun: %m (需要 --privileged 或 --device /dev/net/tun + NET_ADMIN)");
        return -1;
    }

    struct ifreq ifr;
    memset(&ifr, 0, sizeof(ifr));
    ifr.ifr_flags = IFF_TAP | IFF_NO_PI;
    strncpy(ifr.ifr_name, name ? name : "tap0", IFNAMSIZ - 1);
    if (ioctl(fd, TUNSETIFF, &ifr) < 0) {
        LOG_E("ioctl TUNSETIFF %s: %m", name);
        close(fd);
        return -1;
    }
    /* 非阻塞：事件迴圈會 poll()，read 抽乾佇列時不能卡死 */
    fcntl(fd, F_SETFL, O_NONBLOCK);
    setsockopt(fd, SOL_SOCKET, SO_RCVBUF, &(int){4 << 20}, sizeof(int)); /* 失敗就算了 */
    return fd;
}

int tap_read(int fd, uint8_t *buf, size_t size)
{
    return (int)read(fd, buf, size);
}

int tap_write(int fd, const uint8_t *buf, size_t len)
{
    return (int)write(fd, buf, len);
}
