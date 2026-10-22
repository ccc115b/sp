#pragma once
/* netdev.h — 我們這台「虛擬機器」的網卡設定 (MAC + IP) */
#include <stdint.h>
#include <stddef.h>

#define NETDEV_MTU 1500
#define MAX_FRAME (NETDEV_MTU + 18) /* MTU + header + cks (不含 TUN 額外) */

typedef struct {
    uint8_t  mac[6];
    uint32_t ip;
    uint32_t netmask;
    uint32_t gateway;
    int      fd; /* TAP 設備 */
} netdev_t;

extern netdev_t g_netdev;

int  netdev_init(const char *tapname, const char *ip, const char *netmask_str);
int  netdev_send(const uint8_t *frame, size_t len); /* 完整 Ethernet 幀送出 */
void netdev_handle_frame(void);                     /* input tap frame -> ethernet_receive */

/* ip 字串 <-> endian 轉換 */
int  ip_parse(const char *str, uint32_t *out);
void ip_print(uint32_t ip, char *out, size_t outlen);
