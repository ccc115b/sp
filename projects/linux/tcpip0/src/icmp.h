#pragma once
/* icmp.h — ping/pong */
#include <stdint.h>
#include <stddef.h>

#define ICMP_ECHO_REPLY   0
#define ICMP_DST_UNREACH  3
#define ICMP_ECHO_REQUEST 8

typedef struct {
    uint8_t  type;
    uint8_t  code;
    uint16_t cksum;
    uint16_t id;
    uint16_t seq;
} __attribute__((packed)) icmp_hdr_t;

void icmp_receive(uint32_t src_ip, uint32_t dst_ip, const uint8_t *data, size_t len);
