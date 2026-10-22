#include "tcp.h"
#include "ip.h"
#include "netdev.h"
#include "utils.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <arpa/inet.h>

#define TCP_MSS          1460   /* MTU 1500 - IP 20 - TCP 20 */
#define TCP_DEF_WINDOW   16384  /* 我們通告的接收視窗 */
#define TCP_INIT_RTO     500    /* 首次重傳等待 ms */
#define TCP_MAX_RETRY    8
#define TCP_TIME_WAIT_MS 4000   /* 簡化的 2*MSL */

#define CONNS_MAX 32
#define LISTEN_MAX 8

static tcp_conn_t conns[CONNS_MAX];
static tcp_lsnr_t lsnrs[LISTEN_MAX];
static uint16_t   ephemeral_port = 39999;

static const char *state_name(uint8_t s)
{
    switch (s) {
    case TCB_SYN_SENT:    return "SYN_SENT";
    case TCB_SYN_RCVD:    return "SYN_RCVD";
    case TCB_ESTABLISHED: return "ESTABLISHED";
    case TCB_FIN_WAIT1:   return "FIN_WAIT1";
    case TCB_FIN_WAIT2:   return "FIN_WAIT2";
    case TCB_TIME_WAIT:   return "TIME_WAIT";
    case TCB_LAST_ACK:    return "LAST_ACK";
    case TCB_CLOSE_WAIT:  return "CLOSE_WAIT";
    case TCB_CLOSED:      return "CLOSED";
    default:              return "FREE";
    }
}

/* seq 比較 (會繞回，用帶號差值) */
static int seq_lt(uint32_t a, uint32_t b) { return (int32_t)(a - b) < 0; }
static int seq_le(uint32_t a, uint32_t b) { return (int32_t)(a - b) <= 0; }

static uint32_t rand_isn(void)
{
    static int seeded;
    if (!seeded) {
        srand((unsigned)(getpid() * 1103515245u) + (unsigned)time(NULL));
        seeded = 1;
    }
    return (uint32_t)rand() << 16 | (uint32_t)(rand() & 0xffff) | 0x10000000u;
}

static tcp_conn_t *conn_alloc(void)
{
    for (int i = 0; i < CONNS_MAX; i++) {
        if (!conns[i].in_use) {
            memset(&conns[i], 0, sizeof(conns[i]));
            conns[i].in_use = 1;
            conns[i].state = TCB_FREE;
            return &conns[i];
        }
    }
    return NULL;
}

static tcp_conn_t *conn_find(uint32_t peer_ip, uint16_t peer_port_net, uint16_t lport_net)
{
    for (int i = 0; i < CONNS_MAX; i++) {
        tcp_conn_t *c = &conns[i];
        if (c->in_use && c->state != TCB_FREE &&
            c->peer_ip == peer_ip && c->peer_port == peer_port_net &&
            c->lport == lport_net)
            return c;
    }
    return NULL;
}

static tcp_lsnr_t *listen_find(uint16_t lport_net)
{
    for (int i = 0; i < LISTEN_MAX; i++)
        if (lsnrs[i].in_use && lsnrs[i].port == lport_net)
            return &lsnrs[i];
    return NULL;
}

static uint32_t seg_end(const tcp_seg_t *s)
{
    return s->seq + s->len + ((s->flags & TH_SYN) ? 1 : 0) + ((s->flags & TH_FIN) ? 1 : 0);
}

/* 把已完全確認的段從佇列移除 */
static void dequeue_acked(tcp_conn_t *c)
{
    while (c->sndq_n > 0 && seq_le(seg_end(&c->sndq[0]), c->snd_una)) {
        memmove(c->sndq, c->sndq + 1, sizeof(tcp_seg_t) * (c->sndq_n - 1));
        c->sndq_n--;
    }
}

/* ---------- 發送 ---------- */

static void tcp_send_segment(tcp_conn_t *c, uint8_t flags, uint32_t seq,
                             const uint8_t *data, size_t len)
{
    uint8_t buf[TCP_HDR_MIN_LEN + 1500];
    tcp_hdr_t *h = (tcp_hdr_t *)buf;
    memset(buf, 0, sizeof(buf));

    h->sport = c->lport;
    h->dport = c->peer_port;
    h->seq = htonl(seq);
    /* 還在送 SYN、沒收到對端 ack 前的段，ack 值設 0 */
    h->ack = htonl(c->rcv_nxt);
    if (c->state == TCB_SYN_SENT && !c->rcv_nxt)
        h->ack = 0;
    h->doff4 = 5 << 4;
    h->flags = flags;
    h->win = htons(TCP_DEF_WINDOW);
    if (len)
        memcpy(buf + TCP_HDR_MIN_LEN, data, len);
    h->cksum = htons(cksum_pseudo(g_netdev.ip, c->peer_ip, IP_PROTO_TCP,
                                  buf, TCP_HDR_MIN_LEN + len, NULL, 0));

    if (ip_send(c->peer_ip, IP_PROTO_TCP, buf, TCP_HDR_MIN_LEN + len) < 0)
        LOG_W("tcp: ip_send queued (等待 ARP resolve)");

    char pb[16];
    ip_print(c->peer_ip, pb, sizeof(pb));
    LOG_D("tcp >>> :%u -> %s:%u flags=%s%s%s seq=%u ack=%u len=%zu state=%s",
          ntohs(c->lport), pb, ntohs(c->peer_port),
          flags & TH_SYN ? "S" : "", flags & TH_ACK ? "A" : "",
          flags & TH_FIN ? "F" : flags & TH_RST ? "R" : flags & TH_PSH ? "P" : "",
          seq, ntohl(h->ack), len, state_name(c->state));
}

/* 送出佇列中尚未送過的段 */
static void flush_unsent(tcp_conn_t *c)
{
    for (uint32_t i = 0; i < c->sndq_n; i++) {
        tcp_seg_t *seg = &c->sndq[i];
        if (seg->sent)
            continue;
        if (seg->flags & TH_SYN)
            seg->seq = c->iss;
        tcp_send_segment(c, seg->flags, seg->seq, seg->data, seg->len);
        seg->sent = 1;
        seg->tx_ms = now_ms();
    }
}

/* 重送最久未確認的段 (go-back-n 風格只看佇列第 0 個) */
static void tick_retransmit(tcp_conn_t *c)
{
    if (c->sndq_n == 0)
        return;
    tcp_seg_t *seg = &c->sndq[0];
    uint64_t rto = (uint64_t)TCP_INIT_RTO << (seg->retried > 5 ? 5 : seg->retried);
    if (now_ms() - seg->tx_ms >= rto) {
        if (seg->retried >= TCP_MAX_RETRY) {
            LOG_W("tcp: retry exhausted (state=%s), abort", state_name(c->state));
            if (c->app.on_close)
                c->app.on_close(c);
            c->in_use = 0;
            return;
        }
        seg->retried++;
        seg->tx_ms = now_ms();
        LOG_D("tcp: RTO timeout, retransmit seq=%u try=%u", seg->seq, seg->retried);
        tcp_send_segment(c, seg->flags, seg->seq, seg->data, seg->len);
    }
}

static int tcp_enqueue(tcp_conn_t *c, uint8_t flags, const uint8_t *data, uint32_t len)
{
    if (c->sndq_n >= TCBQ_MAX)
        return -1;
    tcp_seg_t *seg = &c->sndq[c->sndq_n++];
    memset(seg, 0, sizeof(*seg));
    seg->flags = flags;
    seg->seq = c->snd_nxt;
    if (flags & TH_SYN)
        c->snd_nxt += 1;
    if (len) {
        seg->len = len;
        memcpy(seg->data, data, len);
        c->snd_nxt += len;
    }
    if (flags & TH_FIN)
        c->snd_nxt += 1;
    return 0;
}

void tcp_tick(void)
{
    for (int i = 0; i < CONNS_MAX; i++) {
        tcp_conn_t *c = &conns[i];
        if (!c->in_use)
            continue;
        if (c->state == TCB_TIME_WAIT) {
            if (now_ms() - c->opened_ms > TCP_TIME_WAIT_MS) {
                LOG_D("tcp: TIME_WAIT expired, free");
                c->in_use = 0;
            }
            continue;
        }
        if (c->state == TCB_FREE)
            continue;
        tick_retransmit(c);
    }
}

/* ---------- 對外 API ---------- */

const tcp_lsnr_t *tcp_listen(uint16_t port_host, const tcp_app_t *app)
{
    for (int i = 0; i < LISTEN_MAX; i++) {
        if (!lsnrs[i].in_use) {
            memset(&lsnrs[i], 0, sizeof(lsnrs[i]));
            lsnrs[i].in_use = 1;
            lsnrs[i].port = htons(port_host);
            lsnrs[i].app = *app;
            LOG_I("tcp: listen on port %u", port_host);
            return &lsnrs[i];
        }
    }
    LOG_E("tcp: no free listener slot");
    return NULL;
}

void tcp_connect(uint32_t dst_ip, uint16_t dst_port_host, const tcp_app_t *app)
{
    tcp_conn_t *c = conn_alloc();
    if (!c) {
        LOG_E("tcp: no free conn");
        return;
    }
    ephemeral_port = ephemeral_port < 61000 ? ephemeral_port + 1 : 40000;

    c->state = TCB_SYN_SENT;
    c->peer_ip = dst_ip;
    c->peer_port = htons(dst_port_host);
    c->lport = htons(ephemeral_port);
    c->iss = rand_isn();
    c->snd_una = c->iss;
    c->snd_nxt = c->iss; /* enqueue(SYN) 時會自己 +1 */
    c->rcv_nxt = 0;
    c->peer_wind = 4096;
    c->opened_ms = now_ms();
    c->app = *app;

    tcp_enqueue(c, TH_SYN, NULL, 0);
    flush_unsent(c);
}

int tcp_write(tcp_conn_t *c, const uint8_t *data, uint32_t len)
{
    if (!c || !c->in_use || c->state == TCB_CLOSED || c->state == TCB_FREE)
        return -1;
    /* SYN_SENT/SYN_RCVD 階段的資料也可以排 (會自動等握手後再送) */

    uint32_t sent = 0;
    while (sent < len) {
        uint32_t chunk = (len - sent > TCP_MSS) ? TCP_MSS : (len - sent);
        if (tcp_enqueue(c, TH_ACK | TH_PSH, data + sent, chunk) < 0) {
            LOG_W("tcp: send queue full, truncated");
            break;
        }
        sent += chunk;
    }
    /* ESTABLISHED 後的 flush；SYN 階段的要到 handshake 完成才 flush */
    if (c->state == TCB_ESTABLISHED || c->state == TCB_CLOSE_WAIT)
        flush_unsent(c);
    return (int)sent;
}

void tcp_close(tcp_conn_t *c)
{
    if (!c || !c->in_use || c->app_closed)
        return;
    c->app_closed = 1;
    switch (c->state) {
    case TCB_ESTABLISHED:
        tcp_enqueue(c, TH_FIN | TH_ACK, NULL, 0);
        c->state = TCB_FIN_WAIT1;
        flush_unsent(c);
        break;
    case TCB_CLOSE_WAIT:
        tcp_enqueue(c, TH_FIN | TH_ACK, NULL, 0);
        c->state = TCB_LAST_ACK;
        flush_unsent(c);
        break;
    case TCB_SYN_RCVD:
    case TCB_SYN_SENT:
        c->in_use = 0;
        break;
    default:
        c->in_use = 0;
        break;
    }
}

void tcp_dump(void)
{
    LOG_I("--- TCP conns ---");
    for (int i = 0; i < CONNS_MAX; i++) {
        tcp_conn_t *c = &conns[i];
        if (!c->in_use || c->state == TCB_FREE)
            continue;
        LOG_I("  [%s:%u -> :%u] %-12s una=%u nxt=%u rcv=%u queued=%u",
              inet_ntoa((struct in_addr){htonl(c->peer_ip)}), ntohs(c->peer_port),
              ntohs(c->lport), state_name(c->state),
              c->snd_una, c->snd_nxt, c->rcv_nxt, c->sndq_n);
    }
}

/* ---------- 接收 ---------- */

static void send_pure_ack(tcp_conn_t *c)
{
    tcp_send_segment(c, TH_ACK, c->snd_nxt, NULL, 0);
}

static void process_ack(tcp_conn_t *c, uint32_t ack)
{
    if (!seq_lt(c->snd_una, ack) || !seq_le(ack, c->snd_nxt))
        return;
    c->snd_una = ack;
    dequeue_acked(c);
}

static void send_rst_for(uint32_t src_ip, uint16_t sport_net, uint16_t dport_net,
                         uint32_t seq, size_t plen)
{
    uint8_t rst[TCP_HDR_MIN_LEN];
    tcp_hdr_t *rh = (tcp_hdr_t *)rst;
    memset(rst, 0, sizeof(rst));
    rh->sport = dport_net;
    rh->dport = sport_net;
    rh->seq = 0;
    rh->ack = htonl(seq + plen + 1);
    rh->doff4 = (5 << 4);
    rh->flags = TH_RST | TH_ACK;
    rh->cksum = htons(cksum_pseudo(g_netdev.ip, src_ip, IP_PROTO_TCP,
                                   rst, sizeof(rst), NULL, 0));
    ip_send(src_ip, IP_PROTO_TCP, rst, sizeof(rst));
    LOG_D("tcp: no listener -> RST");
}

static void handle_rst(tcp_conn_t *c)
{
    LOG_D("tcp: RST received, aborting");
    if (c->app.on_close)
        c->app.on_close(c);
    c->in_use = 0;
}

void tcp_receive(uint32_t src_ip, uint32_t dst_ip, const uint8_t *data, size_t len)
{
    (void)dst_ip;
    if (len < TCP_HDR_MIN_LEN)
        return;

    tcp_hdr_t h;
    memcpy(&h, data, TCP_HDR_MIN_LEN);
    size_t hl = (h.doff4 >> 4) * 4;
    if (hl < TCP_HDR_MIN_LEN || hl > len)
        return;

    /* 檢查和 */
    uint16_t rx = ntohs(h.cksum);
    if (rx != 0) {
        uint8_t tmp[TCP_HDR_MIN_LEN + 1500];
        size_t pl = len > sizeof(tmp) ? sizeof(tmp) : len;
        memcpy(tmp, data, pl);
        ((tcp_hdr_t *)tmp)->cksum = 0;
        if (cksum_pseudo(src_ip, dst_ip, IP_PROTO_TCP, (const uint8_t *)tmp, pl, NULL, 0) != rx) {
            LOG_D("tcp: bad checksum, drop");
            return;
        }
    }

    uint16_t sport = h.sport; /* 對端來源 port (net) */
    uint16_t dport = h.dport; /* 本地端口 (net) */
    uint32_t seq = ntohl(h.seq);
    uint32_t ack = ntohl(h.ack);
    uint8_t flags = h.flags;
    size_t plen = len - hl;

    { /* log */
        char sb[16];
        ip_print(src_ip, sb, sizeof(sb));
        LOG_D("tcp <<< %s:%u -> :%u flags=%s%s%s seq=%u ack=%u len=%zu",
              sb, ntohs(sport), ntohs(dport),
              flags & TH_SYN ? "S" : "", flags & TH_ACK ? "A" : "",
              flags & TH_FIN ? "F" : flags & TH_RST ? "R" : "",
              seq, ack, plen);
    }

    tcp_conn_t *c = conn_find(src_ip, sport, dport);

    /* 新連入 (SYN 且無 ACK) */
    if ((flags & TH_SYN) && !(flags & TH_ACK)) {
        if (c) {
            if (c->state == TCB_SYN_RCVD && seq + 1 == c->rcv_nxt) {
                /* 對端 retransmit SYN -> 重送我們的 SYN|ACK */
                flush_unsent(c);
            } else {
                send_pure_ack(c);
            }
            return;
        }

        tcp_lsnr_t *l = listen_find(dport);
        if (!l) {
            send_rst_for(src_ip, sport, dport, seq, plen);
            return;
        }

        c = conn_alloc();
        if (!c)
            return;
        c->state = TCB_SYN_RCVD;
        c->peer_ip = src_ip;
        c->peer_port = sport;
        c->lport = dport;
        c->iss = rand_isn();
        c->snd_una = c->iss;
        c->snd_nxt = c->iss; /* enqueue(SYN) 時會自己 +1 */
        c->rcv_nxt = seq + 1;
        c->peer_wind = ntohs(h.win) ? ntohs(h.win) : 4096;
        c->opened_ms = now_ms();
        c->app = l->app;

        tcp_enqueue(c, TH_SYN | TH_ACK, NULL, 0);
        flush_unsent(c);
        LOG_D("tcp: new incoming connection SYN|ACK sent");
        return;
    }

    if (!c) {
        LOG_D("tcp: no matching conn, ignore");
        return;
    }

    if (flags & TH_RST) {
        handle_rst(c);
        return;
    }

    /* TIME_WAIT 收到重送 FIN -> 再回個 ACK */
    if (c->state == TCB_TIME_WAIT) {
        if (flags & TH_FIN)
            send_pure_ack(c);
        return;
    }

    /* ACK 推進 */
    if (flags & TH_ACK)
        process_ack(c, ack);

    /* 狀態推進 */
    switch (c->state) {
    case TCB_SYN_RCVD:
        c->state = TCB_ESTABLISHED;
        c->peer_wind = ntohs(h.win) ? ntohs(h.win) : 4096;
        c->opened_ms = now_ms();
        if (c->app.on_accept)
            c->app.on_accept(c, src_ip, ntohs(sport), ntohs(dport));
        flush_unsent(c);
        break;
    case TCB_SYN_SENT:
        /* active open：SYN|ACK */
        if ((flags & TH_SYN) && (flags & TH_ACK)) {
            c->rcv_nxt = seq + 1;
            c->peer_wind = ntohs(h.win) ? ntohs(h.win) : 4096;
            c->state = TCB_ESTABLISHED;
            send_pure_ack(c);
            if (c->app.on_accept)
                c->app.on_accept(c, src_ip, ntohs(sport), ntohs(c->lport));
            flush_unsent(c);
        }
        return;
    case TCB_FIN_WAIT1:
        if (c->sndq_n == 0)
            c->state = TCB_FIN_WAIT2;
        break;
    case TCB_LAST_ACK:
        if (c->sndq_n == 0) {
            c->in_use = 0; /* 我們的 FIN 已被確認 */
            return;
        }
        break;
    default:
        break;
    }

    /* 資料 (僅按序；亂序依賴重傳，見 README 限制) */
    if (plen > 0) {
        uint32_t data_first = seq;
        if (data_first == c->rcv_nxt) {
            c->rcv_nxt += plen;
            if (c->app.on_data)
                c->app.on_data(c, data + hl, plen);
        } else if (seq_lt(data_first, c->rcv_nxt) && seq_lt(c->rcv_nxt, data_first + plen)) {
            size_t off = c->rcv_nxt - data_first;
            c->rcv_nxt = data_first + plen;
            if (c->app.on_data)
                c->app.on_data(c, data + hl + off, plen - off);
        } else if (seq_lt(c->rcv_nxt, data_first)) {
            LOG_D("tcp: out-of-order drop (rcv_nxt=%u got=%u)", c->rcv_nxt, data_first);
        }
        /* 舊的重複資料：不處理 */
        send_pure_ack(c);
    }

    if (c->state == TCB_TIME_WAIT) /* 收資料途中被改掉 */
        return;

    if (flags & TH_FIN) {
        uint32_t fin_seq = seq + plen;
        /* FIN 應該緊接在已收資料之後 */
        if (fin_seq + 1 == c->rcv_nxt || (plen == 0 && fin_seq == c->rcv_nxt)) {
            c->rcv_nxt = fin_seq + 1;
            send_pure_ack(c);
        switch (c->state) {
        case TCB_ESTABLISHED:
            /* 對端關閉，進入 CLOSE_WAIT，通知應用層 (可選擇再呼叫 tcp_close) */
            c->state = TCB_CLOSE_WAIT;
            if (c->app.on_close)
                c->app.on_close(c);
            break;
        case TCB_FIN_WAIT1:
            case TCB_FIN_WAIT2:
                c->state = TCB_TIME_WAIT;
                c->opened_ms = now_ms();
                if (c->app.on_close)
                    c->app.on_close(c);
                break;
            default:
                break;
            }
        } else {
            send_pure_ack(c); /* 亂序 FIN -> 立即回 ACK 讓對端重送 */
        }
        return;
    }
}
