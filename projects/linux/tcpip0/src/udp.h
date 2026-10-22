#pragma once
/* udp.h — 最小 UDP：收包丟日志 + 選配回 echo */
#include <stdint.h>
#include <stddef.h>

typedef struct {
    uint16_t sport;
    uint16_t dport;
    uint16_t len;
    uint16_t cksum;
} __attribute__((packed)) udp_hdr_t;

void udp_receive(uint32_t src_ip, uint32_t dst_ip, const uint8_t *data, size_t len);
