#include "netdev.h"
#include "tap.h"
#include "utils.h"
#include <stdio.h>
#include <string.h>
#include <arpa/inet.h>

netdev_t g_netdev;

void ip_print(uint32_t ip, char *out, size_t n)
{
    snprintf(out, n, "%u.%u.%u.%u", (ip >> 24) & 0xff, (ip >> 16) & 0xff,
             (ip >> 8) & 0xff, ip & 0xff);
}

int ip_parse(const char *str, uint32_t *out)
{
    struct in_addr a;
    if (inet_pton(AF_INET, str, &a) != 1)
        return -1;
    *out = ntohl(a.s_addr);
    return 0;
}

int netdev_init(const char *tapname, const char *ip_str, const char *mask_str)
{
    /* TAP 裝置的 MAC 用固定前綴 + 接口名，方便辨識 */
    memset(&g_netdev, 0, sizeof(g_netdev));
    g_netdev.mac[0] = 0x52; /* local administrated */
    g_netdev.mac[1] = 0x05;
    g_netdev.mac[2] = 0xc2;
    g_netdev.mac[3] = 0x99;
    g_netdev.mac[4] = 0x01;
    g_netdev.mac[5] = 0x42;

    int fd = tap_open(tapname);
    if (fd < 0)
        return -1;
    g_netdev.fd = fd;

    if (ip_parse(ip_str, &g_netdev.ip) < 0) {
        LOG_E("bad ip: %s", ip_str);
        return -1;
    }
    if (ip_parse(mask_str, &g_netdev.netmask) < 0) {
        g_netdev.netmask = 0xffffff00;
    }
    if (g_netdev.netmask == 0xffffffff)
        return -1;

    char ipbuf[16], macbuf[24];
    uint32_t mask = g_netdev.netmask;
    snprintf(ipbuf, sizeof(ipbuf), "%s/%u", ip_str,
             __builtin_popcount(mask));
    ip_print(g_netdev.ip, ipbuf, sizeof(ipbuf));
    snprintf(macbuf, sizeof(macbuf), "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x",
             g_netdev.mac[0], g_netdev.mac[1], g_netdev.mac[2],
             g_netdev.mac[3], g_netdev.mac[4], g_netdev.mac[5]);

    LOG_I("netdev up: tap=%s ip=%s/%u mac=%s, netmask=0x%08x",
          tapname, ipbuf, __builtin_popcount(mask), macbuf, mask);
    return 0;
}

int netdev_send(const uint8_t *frame, size_t len)
{
    int r = tap_write(g_netdev.fd, frame, len);
    if (r < 0)
        LOG_D("netdev_send write: %m (len=%zu)", len);
    return r;
}
