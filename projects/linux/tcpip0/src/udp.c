#include "udp.h"
#include "ip.h"
#include "utils.h"
#include <string.h>
#include <arpa/inet.h>

void udp_receive(uint32_t src_ip, uint32_t dst_ip, const uint8_t *data, size_t len)
{
    if (len < sizeof(udp_hdr_t))
        return;

    udp_hdr_t h;
    memcpy(&h, data, sizeof(h));

    /* UDP 檢查和：為 0 表示送端沒算，不是錯誤 */
    if (h.cksum != 0) {
        uint16_t rx = ntohs(h.cksum);
        udp_hdr_t z = h;
        z.cksum = 0;
        if (cksum_pseudo(src_ip, dst_ip, IP_PROTO_UDP, &z, sizeof(z),
                         data + sizeof(h), len - sizeof(h)) != rx) {
            LOG_D("udp: bad checksum, drop");
            return;
        }
    }

    (void)dst_ip;
    char sb[16], db[16];
    ip_print(src_ip, sb, sizeof(sb));
    ip_print(dst_ip, db, sizeof(db));
    LOG_D("udp: %s:%u -> %s:%u len=%u (本棧未提供 UDP 服務，僅記錄)",
          sb, ntohs(h.sport), db, ntohs(h.dport), ntohs(h.len));
}
