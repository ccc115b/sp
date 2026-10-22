#pragma once
/* ip.h — IPv4 層：收包分發 + 送包 (含選路/檢查和) */
#include <stdint.h>
#include <stddef.h>
#include "ethernet.h"

#define IP_PROTO_ICMP   1
#define IP_PROTO_TCP    6
#define IP_PROTO_UDP    17

typedef struct {
    uint8_t  ver_ihl;   /* 版本(4) + 標頭長度(4)，單位為 4 bytes */
    uint8_t  tos;
    uint16_t total_len;
    uint16_t id;
    uint16_t flags_frag; /* DF/MF + 分片偏移 */
    uint8_t  ttl;
    uint8_t  proto;
    uint16_t cksum;
    uint32_t src;
    uint32_t dst;
} __attribute__((packed)) ip_hdr_t;

#define IP_HDR_MIN_LEN 20
#define IP_FLAG_DF     0x4000
#define IP_FLAG_MF     0x2000
#define IP_FRAG_OFF(x) (((x) & 0x1fff) * 8)

void ip_receive(const uint8_t src_mac[ETH_ALEN], const uint8_t *data, size_t len);

/* 送一個 IPv4 封包 (payload 已含传输层標頭，不含 IP 標頭) */
int  ip_send(uint32_t dst_ip, uint8_t proto, const uint8_t *payload, size_t len);

/* 判斷是不是我們自己的 IP */
int  ip_is_ours(uint32_t ip);
