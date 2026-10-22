/* apps.c — 建構在自製 TCP 之上的應用層：Echo / HTTP */
#include "apps.h"
#include "utils.h"
#include "netdev.h"
#include <stdio.h>
#include <string.h>

/* ---------------- Echo 伺服器 ---------------- */

static void echo_on_accept(tcp_conn_t *c, uint32_t peer_ip, uint16_t peer_port,
                           uint16_t local_port)
{
    (void)c;
    char buf[16];
    ip_print(peer_ip, buf, sizeof(buf));
    LOG_I("echo: new conn %s:%u -> :%u", buf, peer_port, local_port);
}

static void echo_on_data(tcp_conn_t *c, const uint8_t *data, size_t len)
{
    /* echo: 收到什麼就原樣送回 */
    tcp_write(c, data, (uint32_t)len);
}

static void echo_on_close(tcp_conn_t *c)
{
    LOG_I("echo: peer closed, closing our side");
    tcp_close(c);
}

void app_echo_init(uint16_t port)
{
    static const tcp_app_t echo_app = {
        .on_accept = echo_on_accept,
        .on_data = echo_on_data,
        .on_close = echo_on_close,
    };
    const tcp_lsnr_t *r = tcp_listen(port, &echo_app);
    (void)r;
}

/* ---------------- 迷你 HTTP 伺服器 ---------------- */

static void http_on_accept(tcp_conn_t *c, uint32_t peer_ip, uint16_t peer_port,
                           uint16_t local_port)
{
    (void)c;
    char buf[16];
    ip_print(peer_ip, buf, sizeof(buf));
    LOG_I("http: new conn %s:%u -> :%u", buf, peer_port, local_port);
}

static void http_on_data(tcp_conn_t *c, const uint8_t *data, size_t len)
{
    (void)len;
    /* 收完請求的第一段就回覆 (示範用，不解析) */
    if (strstr((const char *)data, "HTTP")) {
        static const char body[] = "<h1>hello from tcpip</h1>\n";
        char resp[512];
        int n = snprintf(resp, sizeof(resp),
                         "HTTP/1.0 200 OK\r\n"
                         "Content-Type: text/html; charset=utf-8\r\n"
                         "Content-Length: %zu\r\n"
                         "Connection: close\r\n"
                         "\r\n"
                         "%s",
                         sizeof(body) - 1, body);
        tcp_write(c, (const uint8_t *)resp, (uint32_t)n);
        tcp_close(c);
        LOG_I("http: 200 OK sent");
    }
}

static void http_on_close(tcp_conn_t *c)
{
    tcp_close(c);
}

void app_http_init(uint16_t port)
{
    static const tcp_app_t http_app = {
        .on_accept = http_on_accept,
        .on_data = http_on_data,
        .on_close = http_on_close,
    };
    const tcp_lsnr_t *r = tcp_listen(port, &http_app);
    (void)r;
}

/* ---------------- 主動連線示範 (stack 當 client) ---------------- */

static void client_on_accept(tcp_conn_t *c, uint32_t peer_ip, uint16_t peer_port, uint16_t lport)
{
    char buf[16];
    ip_print(peer_ip, buf, sizeof(buf));
    LOG_I("client: connected -> %s:%u (lport=%u)", buf, peer_port, lport);
    tcp_write(c, (const uint8_t *)"PING\n", 5);
}

static void client_on_data(tcp_conn_t *c, const uint8_t *data, size_t len)
{
    fprintf(stderr, "client recv %zu bytes: %.*s\n", len, (int)len, data);
    tcp_close(c);
}

static void client_on_close(tcp_conn_t *c)
{
    LOG_I("client: done");
    tcp_close(c);
}

void app_client_demo(uint32_t dst_ip, uint16_t dst_port)
{
    static const tcp_app_t client_app = {
        .on_accept = client_on_accept,
        .on_data = client_on_data,
        .on_close = client_on_close,
    };
    tcp_connect(dst_ip, dst_port, &client_app);
    LOG_I("client: connecting (SYN sent)");
}
