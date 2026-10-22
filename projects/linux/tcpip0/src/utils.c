#include "utils.h"
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>

uint16_t cksum(const void *data, size_t len)
{
    const uint8_t *p = data;
    uint32_t sum = 0;
    for (size_t i = 0; i < len; i += 2) {
        uint16_t w = p[i] << 8;
        if (i + 1 < len)
            w |= p[i + 1];
        sum += w;
    }
    while (sum >> 16)
        sum = (sum & 0xffff) + (sum >> 16);
    return (uint16_t)(~sum);
}

/* 偽標頭 + 兩段資料 (TCP/UDP 的檢查和範圍) */
uint16_t cksum_pseudo(uint32_t src, uint32_t dst, uint8_t proto,
                      const void *a, size_t alen, const void *b, size_t blen)
{
    pseudo_hdr_t ph;
    ph.src = src;
    ph.dst = dst;
    ph.zero = 0;
    ph.proto = proto;
    ph.len = (uint16_t)(alen + blen);

    /* 偽標頭 6 個 16-bit words：srcHi,srcLo,dstHi,dstLo,zero|proto,len */
    uint32_t sum = (src >> 16) + (src & 0xffff)
                 + (dst >> 16) + (dst & 0xffff)
                 + ((uint32_t)ph.zero << 8 | ph.proto)
                 + (uint32_t)(uint16_t)(alen + blen);
    /* 第一段 */
    const uint8_t *pa = a;
    for (size_t i = 0; i < alen; i += 2) {
        uint16_t w = pa[i] << 8;
        if (i + 1 < alen)
            w |= pa[i + 1];
        sum += w;
    }
    /* 第二段 */
    const uint8_t *pb = b;
    for (size_t i = 0; i < blen; i += 2) {
        uint16_t w = pb[i] << 8;
        if (i + 1 < blen)
            w |= pb[i + 1];
        sum += w;
    }
    while (sum >> 16)
        sum = (sum & 0xffff) + (sum >> 16);
    return (uint16_t)(~sum);
}

void hexdump(const char *tag, const uint8_t *p, size_t n)
{
    if (!p || !n)
        return;
    fprintf(stderr, "%s (%zu bytes):\n", tag, n);
    for (size_t i = 0; i < n; i += 16) {
        fprintf(stderr, "  %04zx  ", i);
        for (size_t j = 0; j < 16; j++) {
            if (i + j < n)
                fprintf(stderr, "%02x ", p[i + j]);
            else
                fprintf(stderr, "   ");
            if (j == 7)
                fputc(' ', stderr);
        }
        fprintf(stderr, " |");
        for (size_t j = 0; i + j < n && j < 16; j++)
            fprintf(stderr, "%c", (p[i + j] >= 32 && p[i + j] < 127) ? p[i + j] : '.');
        fprintf(stderr, "|\n");
    }
}

uint64_t now_ms(void)
{
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return (uint64_t)tv.tv_sec * 1000 + tv.tv_usec / 1000;
}

void msleep(int ms)
{
    struct timespec ts = { .tv_sec = ms / 1000, .tv_nsec = (long)(ms % 1000) * 1000000L };
    nanosleep(&ts, NULL);
}
