#pragma once
/* utils.h — 共用工具：檢查和、hexdump、時間、日誌 */
#define _DEFAULT_SOURCE
#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <time.h>
#include <sys/time.h>

#define LOG_I(fmt, ...) fprintf(stderr, "[I] " fmt "\n", ##__VA_ARGS__)
#define LOG_W(fmt, ...) fprintf(stderr, "[W] " fmt "\n", ##__VA_ARGS__)
#define LOG_E(fmt, ...) fprintf(stderr, "[E] " fmt "\n", ##__VA_ARGS__)

#ifdef DEBUG
#define LOG_D(fmt, ...) fprintf(stderr, "[D] " fmt "\n", ##__VA_ARGS__)
#else
#define LOG_D(fmt, ...) do {} while (0)
#endif

uint16_t cksum(const void *data, size_t len);

/* TCP/UDP 計算檢查和用的偽標頭 */
typedef struct {
    uint32_t src;
    uint32_t dst;
    uint8_t  zero;
    uint8_t  proto;
    uint16_t len;
} __attribute__((packed)) pseudo_hdr_t;

uint16_t cksum_pseudo(uint32_t src, uint32_t dst, uint8_t proto,
                      const void *payload, size_t len, const void *first_half, size_t first_len);

void hexdump(const char *tag, const uint8_t *p, size_t n);
uint64_t now_ms(void);
void msleep(int ms);
