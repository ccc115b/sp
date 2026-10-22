#include "ethernet.h"
#include "arp.h"
#include "ip.h"
#include "utils.h"
#include <stdio.h>
#include <string.h>
#include <arpa/inet.h>

void mac_print(const uint8_t *m, char *out, size_t n)
{
    snprintf(out, n, "%02x:%02x:%02x:%02x:%02x:%02x",
             m[0], m[1], m[2], m[3], m[4], m[5]);
}

int mac_cmp(const uint8_t *a, const uint8_t *b)
{
    return memcmp(a, b, ETH_ALEN);
}

static const uint8_t bcast_mac[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};

void ethernet_receive(const uint8_t *frame, size_t len)
{
    if (len < ETH_HDR_LEN)
        return;

    eth_hdr_t hdr;
    memcpy(&hdr, frame, sizeof(hdr));
    uint16_t type = ntohs(hdr.type);

    /* 只處理送到我們 MAC 的幀 (或廣播) */
    if (mac_cmp(hdr.dst, g_netdev.mac) != 0 && mac_cmp(hdr.dst, bcast_mac) != 0)
        return;

    const uint8_t *payload = frame + ETH_HDR_LEN;
    size_t plen = len - ETH_HDR_LEN;

    switch (type) {
    case ETH_PROTO_ARP:
        arp_receive(hdr.src, payload, plen);
        break;
    case ETH_PROTO_IP:
        ip_receive(hdr.src, payload, plen);
        break;
    default:
        LOG_D("eth: ignore type 0x%04x", type);
    }
}

int ethernet_send(const uint8_t dst_mac[ETH_ALEN], uint16_t type,
                  const uint8_t *payload, size_t len)
{
    uint8_t frame[ETH_HDR_LEN + 2048];
    eth_hdr_t hdr;
    memcpy(hdr.dst, dst_mac, ETH_ALEN);
    memcpy(hdr.src, g_netdev.mac, ETH_ALEN);
    hdr.type = htons(type);
    memcpy(frame, &hdr, sizeof(hdr));
    memcpy(frame + sizeof(hdr), payload, len);
    return netdev_send(frame, sizeof(hdr) + len);
}
