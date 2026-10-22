#include "arp.h"
#include "ip.h"
#include "utils.h"
#include <stdio.h>
#include <string.h>
#include <arpa/inet.h>

#define ARP_TABLE_MAX   64
#define ARP_ENTRY_TTL   30000 /* ms */
#define ARP_RETRY_MS    1000

typedef struct {
    int      valid;
    uint32_t ip;    /* host order */
    uint8_t  mac[ETH_ALEN];
    uint64_t updated; /* ms */
    uint64_t probed;  /* last ARP request we sent (ms) */
} arp_entry_t;

static arp_entry_t tbl[ARP_TABLE_MAX];

/* 等待 ARP 解析的封包佇列 (IP 尚未解析完成時先把 payload 掛在這裡) */
#define ARPQ_MAX 16
typedef struct {
    int      valid;
    uint32_t dst_ip;
    uint16_t ethertype;
    uint8_t  payload[1500];
    size_t   len;
} arp_pending_t;

static arp_pending_t pendq[ARPQ_MAX];

static arp_entry_t *entry_find(uint32_t ip)
{
    for (int i = 0; i < ARP_TABLE_MAX; i++)
        if (tbl[i].valid && tbl[i].ip == ip)
            return &tbl[i];
    return NULL;
}

static arp_entry_t *entry_alloc(uint32_t ip)
{
    arp_entry_t *e = entry_find(ip);
    int oldest = 0;
    for (int i = 0; i < ARP_TABLE_MAX; i++) {
        if (!tbl[i].valid)
            return &tbl[i];
        if (tbl[i].updated < tbl[oldest].updated)
            oldest = i;
    }
    (void)e;
    return &tbl[oldest]; /* LRU 驅逐 */
}

static void arp_send(uint16_t op, uint32_t spa, const uint8_t sha[ETH_ALEN],
                     uint32_t tpa, const uint8_t tha[ETH_ALEN])
{
    uint8_t buf[sizeof(arp_pkt_t)];
    arp_pkt_t *pkt = (arp_pkt_t *)buf;
    memset(buf, 0, sizeof(buf));
    pkt->htype = htons(ARP_HW_ETHER);
    pkt->ptype = htons(0x0800);
    pkt->hlen = ETH_ALEN;
    pkt->plen = 4;
    pkt->op = htons(op);
    memcpy(pkt->sha, sha, ETH_ALEN);
    pkt->spa = htonl(spa);
    memcpy(pkt->tha, tha, ETH_ALEN);
    pkt->tpa = htonl(tpa);

    uint8_t bcast[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
    const uint8_t *dst = (op == ARP_OP_REPLY) ? tha : bcast;
    ethernet_send(dst, ETH_PROTO_ARP, buf, sizeof(buf));

    char s[16], t[16];
    ip_print(spa, s, sizeof(s));
    ip_print(tpa, t, sizeof(t));
    LOG_D("arp send op=%d spa=%s tpa=%s", op, s, t);
}


void arp_receive(const uint8_t src_mac[ETH_ALEN], const uint8_t *data, size_t len)
{
    (void)len;
    if (len < sizeof(arp_pkt_t))
        return;
    arp_pkt_t p;
    memcpy(&p, data, sizeof(p));
    p.htype = ntohs(p.htype);
    p.ptype = ntohs(p.ptype);
    p.op = ntohs(p.op);

    if (p.htype != ARP_HW_ETHER || p.ptype != 0x0800)
        return;

    p.spa = ntohl(p.spa);
    p.tpa = ntohl(p.tpa);

    /* 學 sender 的 (src_ip, src_mac) */
    arp_entry_t *e = entry_find(p.spa);
    if (!e)
        e = entry_alloc(p.spa);
    if (e) {
        e->valid = 1;
        e->ip = p.spa;
        memcpy(e->mac, p.sha, ETH_ALEN);
        e->updated = now_ms();
        LOG_D("arp learn %u -> %02x:%02x:%02x:%02x:%02x:%02x",
              p.spa, p.sha[0], p.sha[1], p.sha[2], p.sha[3], p.sha[4], p.sha[5]);
    }

    (void)src_mac;

    if (p.op == ARP_OP_REQUEST && p.tpa == g_netdev.ip) {
        /* 回覆它：我 = tpa 的主人 */
        arp_send(ARP_OP_REPLY, p.tpa, g_netdev.mac, p.spa, p.sha);
    }

    /* 有解析完成的 IP，就把 pending 的封包補送 */
    for (int i = 0; i < ARPQ_MAX; i++) {
        if (!pendq[i].valid)
            continue;
        uint8_t m[ETH_ALEN];
        if (arp_lookup(pendq[i].dst_ip, m)) {
            ethernet_send(m, pendq[i].ethertype, pendq[i].payload, pendq[i].len);
            pendq[i].valid = 0;
        }
    }
}

/* 0 = 尚未解析，1 = 已解析 (mac 已填) */
int arp_lookup(uint32_t dst_ip, uint8_t out_mac[ETH_ALEN])
{
    arp_entry_t *e = entry_find(dst_ip);
    if (e && now_ms() - e->updated < ARP_ENTRY_TTL) {
        memcpy(out_mac, e->mac, ETH_ALEN);
        return 1;
    }
    return 0;
}

void arp_request_async(uint32_t dst_ip)
{
    arp_entry_t *e = entry_find(dst_ip);
    uint64_t now = now_ms();
    if (e && e->probed != 0 && now - e->probed < ARP_RETRY_MS)
        return; /* 限速：1 秒內不重發 */

    uint8_t zero[ETH_ALEN] = {0};
    arp_send(ARP_OP_REQUEST, g_netdev.ip, g_netdev.mac, dst_ip, zero);

    if (!e)
        e = entry_alloc(dst_ip);
    e->valid = 1;
    e->ip = dst_ip;
    e->probed = now;
    e->updated = now; /* 未收到回應前，「年齡」也拿來節流重試 */
}

int arp_send_ip_packet(uint32_t dst_ip, uint16_t ethertype,
                       const uint8_t *payload, size_t len)
{
    uint8_t mac[ETH_ALEN];
    if (arp_lookup(dst_ip, mac)) {
        ethernet_send(mac, ethertype, payload, len);
        return 0;
    }
    /* 沒有 MAC：發 ARP 請求、排隊稍後再送 */
    arp_request_async(dst_ip);
    for (int i = 0; i < ARPQ_MAX; i++) {
        if (!pendq[i].valid) {
            pendq[i].valid = 1;
            pendq[i].dst_ip = dst_ip;
            pendq[i].ethertype = ethertype;
            if (len > sizeof(pendq[i].payload))
                len = sizeof(pendq[i].payload);
            memcpy(pendq[i].payload, payload, len);
            pendq[i].len = len;
            return -1; /* queued */
        }
    }
    return -2; /* queue 滿 */
}

void arp_tick(void)
{
    /* pending 封包：解析完成就送出；連續等待超過 1 秒就重發 ARP request */
    for (int i = 0; i < ARPQ_MAX; i++) {
        if (!pendq[i].valid)
            continue;
        uint8_t m[ETH_ALEN];
        if (arp_lookup(pendq[i].dst_ip, m)) {
            ethernet_send(m, pendq[i].ethertype, pendq[i].payload, pendq[i].len);
            pendq[i].valid = 0;
        }
        arp_request_async(pendq[i].dst_ip);
    }
}

void arp_dump(void)
{
    LOG_I("--- ARP table ---");
    char ipb[16], mb[20];
    for (int i = 0; i < ARP_TABLE_MAX; i++) {
        if (!tbl[i].valid)
            continue;
        ip_print(tbl[i].ip, ipb, sizeof(ipb));
        mac_print(tbl[i].mac, mb, sizeof(mb));
        LOG_I("  %s -> %s age=%llums", ipb, mb, (unsigned long long)(now_ms() - tbl[i].updated));
    }
}
