#pragma once
/* tcp.h — 自製 TCP：被動開啟(伺服器)、主動開啟(客戶端)、資料收送、確認/重傳、關閉 */
#include <stdint.h>
#include <stddef.h>

typedef struct {
    uint16_t sport; /* 本端 port (network order) */
    uint16_t dport;
    uint32_t seq;
    uint32_t ack;
    uint8_t  doff4; /* 標頭長度/4 << 4，只用基本 20 bytes */
    uint8_t  flags;
    uint16_t win;
    uint16_t cksum;
    uint16_t urg;
} __attribute__((packed)) tcp_hdr_t;

#define TCP_HDR_MIN_LEN 20

/* TH_* flags */
#define TH_FIN 0x01
#define TH_SYN 0x02
#define TH_RST 0x04
#define TH_PSH 0x08
#define TH_ACK 0x10

/* control block 狀態 (簡化版狀態機) */
#define TCB_FREE        0
#define TCB_SYN_SENT    1
#define TCB_SYN_RCVD    2
#define TCB_ESTABLISHED 3
#define TCB_FIN_WAIT1   4
#define TCB_FIN_WAIT2   5
#define TCB_TIME_WAIT   6
#define TCB_LAST_ACK    7
#define TCB_CLOSED      8
#define TCB_CLOSE_WAIT  9

typedef struct tcp_conn tcp_conn_t;

/* 應用層 callback 介面 */
typedef struct {
    void (*on_accept)(tcp_conn_t *conn, uint32_t peer_ip, uint16_t peer_port,
                      uint16_t local_port);
    void (*on_data)(tcp_conn_t *conn, const uint8_t *data, size_t len);
    void (*on_close)(tcp_conn_t *conn); /* 對端 FIN/RST，應用端可在此呼叫 tcp_close */
} tcp_app_t;

typedef struct {
    int        in_use;
    uint16_t   port; /* network order */
    tcp_app_t  app;
} tcp_lsnr_t;

/* 送出後等待確認的 segment */
typedef struct {
    uint8_t  flags;
    uint8_t  sent;   /* 是否已送出至少一次 */
    uint32_t seq;
    uint32_t len;
    uint32_t retried;
    uint64_t tx_ms;
    uint8_t  data[1500];
} tcp_seg_t;

struct tcp_conn {
    int      in_use;
    uint8_t  state; /* TCB_* */

    uint32_t peer_ip;   /* host order */
    uint16_t peer_port; /* network order */
    uint16_t lport;     /* network order */

    /* 發送端 */
    uint32_t iss;
    uint32_t snd_una; /* 未確認的最小序號 */
    uint32_t snd_nxt; /* 下一個要配置的序號 */
    uint32_t peer_wind;

    /* 接收端 */
    uint32_t rcv_nxt;

    tcp_app_t app;

#define TCBQ_MAX 48
    tcp_seg_t sndq[TCBQ_MAX];
    uint32_t  sndq_n;

    uint64_t opened_ms;
    uint8_t  app_closed; /* 應用已呼叫 tcp_close */
};

/* 綁定 port 監聽 (伺服器被動開啟) */
const tcp_lsnr_t *tcp_listen(uint16_t port_host, const tcp_app_t *app);

/* 主動連線 (非同步；資料可以先送，會排隊) */
void tcp_connect(uint32_t dst_ip, uint16_t dst_port_host, const tcp_app_t *app);

/* 送資料 (未確認前會自動重傳) */
int tcp_write(tcp_conn_t *conn, const uint8_t *data, uint32_t len);

/* 送 FIN 並進入關閉流程 */
void tcp_close(tcp_conn_t *conn);

/* 由主迴圈呼叫：重傳 + 狀態清理 */
void tcp_tick(void);

/* 收到一個 TCP 段 (由 ip.c 呼叫) */
void tcp_receive(uint32_t src_ip, uint32_t dst_ip, const uint8_t *data, size_t len);

void tcp_dump(void);
