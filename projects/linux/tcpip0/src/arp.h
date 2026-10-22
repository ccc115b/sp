#pragma once
/* arp.h — ARP 表 + 解析出 IP 對應的 MAC (L2/L3 之間的橋樑) */
#include <stdint.h>
#include <stddef.h>
#include "ethernet.h"

#define ARP_HW_ETHER   1
#define ARP_OP_REQUEST 1
#define ARP_OP_REPLY   2

typedef struct {
    uint16_t htype;
    uint16_t ptype;
    uint8_t  hlen;
    uint8_t  plen;
    uint16_t op;
    uint8_t  sha[ETH_ALEN];
    uint32_t spa; /* sender protocol addr, host order */
    uint8_t  tha[ETH_ALEN];
    uint32_t tpa; /* target protocol addr, host order */
} __attribute__((packed)) arp_pkt_t;

void arp_receive(const uint8_t src_mac[ETH_ALEN], const uint8_t *data, size_t len);

/* L3 → L2 解析：查得到就回填 mac 並回傳 1，否則回傳 0 */
int  arp_lookup(uint32_t dst_ip, uint8_t out_mac[ETH_ALEN]);

/* 帶 IP 封包出去：先做 ARP 解析，沒導通就排隊等 wave */
int  arp_send_ip_packet(uint32_t dst_ip, uint16_t ethertype,
                        const uint8_t *payload, size_t len);

void arp_tick(void); /* 預留時效/重試用 */
void arp_dump(void);
