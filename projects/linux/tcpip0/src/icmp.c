#include "icmp.h"
#include "ip.h"
#include "utils.h"
#include <string.h>
#include <arpa/inet.h>

void icmp_receive(uint32_t src_ip, uint32_t dst_ip, const uint8_t *data, size_t len)
{
    (void)dst_ip;
    if (len < sizeof(icmp_hdr_t))
        return;

    icmp_hdr_t h;
    memcpy(&h, data, sizeof(h));
    uint16_t rx = ntohs(h.cksum);

    /* 檢查和範圍 = 整個 ICMP 訊息 (標頭 + payload) */
    uint8_t tmp[1500];
    size_t n = len > sizeof(tmp) ? sizeof(tmp) : len;
    memcpy(tmp, data, n);
    ((icmp_hdr_t *)tmp)->cksum = 0;
    if (cksum(tmp, n) != rx) {
        LOG_D("icmp: bad checksum");
        return;
    }

    if (h.type == ICMP_ECHO_REQUEST) {
        /* echo request -> 原封不動地 echo reply 回去 (type 改 0) */
        uint8_t out[1500];
        memcpy(out, data, len);
        out[0] = ICMP_ECHO_REPLY;
        icmp_hdr_t *o = (icmp_hdr_t *)out;
        o->cksum = 0;
        o->cksum = htons(cksum(out, len));        char buf[16];
        ip_print(src_ip, buf, sizeof(buf));
        LOG_D("icmp: echo request from %s id=%u seq=%u -> replying", buf, ntohs(h.id), ntohs(h.seq));
        ip_send(src_ip, IP_PROTO_ICMP, out, len);
    }
}
