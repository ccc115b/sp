#pragma once
/* ethernet.h — Ethernet (L2) 訊框收送層 */
#include <stdint.h>
#include <stddef.h>
#include <arpa/inet.h>
#include "netdev.h"

#define ETH_ALEN          6
#define ETH_HDR_LEN       14
#define ETH_PROTO_ARP     0x0806
#define ETH_PROTO_IP      0x0800

/* Ethernet 標頭 */
typedef struct {
    uint8_t  dst[ETH_ALEN];
    uint8_t  src[ETH_ALEN];
    uint16_t type;
} __attribute__((packed)) eth_hdr_t;

void ethernet_receive(const uint8_t *frame, size_t len);
int  ethernet_send(const uint8_t dst_mac[ETH_ALEN], uint16_t type,
                   const uint8_t *payload, size_t len);
void mac_print(const uint8_t *m, char *out, size_t n);
int  mac_cmp(const uint8_t *a, const uint8_t *b);
