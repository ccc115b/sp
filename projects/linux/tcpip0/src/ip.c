#include "ip.h"
#include "arp.h"
#include "icmp.h"
#include "tcp.h"
#include "udp.h"
#include "utils.h"
#include <string.h>
#include <arpa/inet.h>

int ip_is_ours(uint32_t ip)
{
    return ip == g_netdev.ip;
}

void ip_receive(const uint8_t src_mac[ETH_ALEN], const uint8_t *data, size_t len)
{
    if (len < IP_HDR_MIN_LEN)
        return;

    ip_hdr_t hdr;
    memcpy(&hdr, data, sizeof(hdr));

    size_t hl = (hdr.ver_ihl & 0x0f) * 4;
    if (hl < IP_HDR_MIN_LEN || hl > len)
        return;
    if (hdr.ver_ihl >> 4 != 4)
        return;

    /* 檢查和要先清零成原值算 */
    ip_hdr_t zeroed = hdr;
    uint16_t rx_cksum = ntohs(hdr.cksum);
    zeroed.cksum = 0;
    if (cksum(&zeroed, hl) != rx_cksum) {
        LOG_D("ip: bad checksum, drop");
        return;
    }

    if (ntohs(hdr.total_len) > len)
        return;
    size_t plen = ntohs(hdr.total_len) - hl;
    const uint8_t *payload = data + hl;

    if (!ip_is_ours(ntohl(hdr.dst))) {
        LOG_D("ip: not for us (dst %x)", ntohl(hdr.dst));
        return;
    }

    (void)src_mac;

    /* 分片只有第一片有傳輸層標頭，這裡只處理不分片 / 第一片 */
    uint16_t frag = ntohs(hdr.flags_frag);
    if (frag & (IP_FLAG_MF | 0x1fff)) {
        LOG_D("ip: fragmented datagram unsupported, drop");
        return;
    }

    uint8_t proto = hdr.proto;
    switch (proto) {
    case IP_PROTO_ICMP:
        icmp_receive(ntohl(hdr.src), ntohl(hdr.dst), payload, plen);
        break;
    case IP_PROTO_UDP:
        udp_receive(ntohl(hdr.src), ntohl(hdr.dst), payload, plen);
        break;
    case IP_PROTO_TCP:
        tcp_receive(ntohl(hdr.src), ntohl(hdr.dst), payload, plen);
        break;
    default:
        LOG_D("ip: unknown proto %u", proto);
    }
}

int ip_send(uint32_t dst_ip, uint8_t proto, const uint8_t *payload, size_t len)
{
    uint8_t buf[sizeof(ip_hdr_t) + 2048];
    ip_hdr_t *h = (ip_hdr_t *)buf;
    static uint16_t id_counter;

    len = len > 2048 ? 2048 : len;
    memset(buf, 0, sizeof(*h));
    h->ver_ihl = 0x45;
    h->tos = 0;
    h->total_len = htons((uint16_t)(sizeof(*h) + len));
    h->id = htons(id_counter++);
    h->flags_frag = htons(IP_FLAG_DF); /* 不分片：超過 MTU 的直接丟掉回報 */
    h->ttl = 64;
    h->proto = proto;
    h->src = htonl(g_netdev.ip);
    h->dst = htonl(dst_ip);
    h->cksum = htons(cksum(buf, sizeof(*h)));
    memcpy(buf + sizeof(*h), payload, len);

    return arp_send_ip_packet(dst_ip, ETH_PROTO_IP, buf, sizeof(*h) + len);
}
