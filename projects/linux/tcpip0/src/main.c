/* main.c — 事件迴圈 + 參數解析 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <poll.h>
#include <errno.h>
#include <signal.h>

#include "netdev.h"
#include "ethernet.h"
#include "arp.h"
#include "ip.h"
#include "icmp.h"
#include "tcp.h"
#include "tap.h"
#include "apps.h"
#include "utils.h"

#define FRAME_BUF MAX_FRAME

static volatile sig_atomic_t g_stop;

static void handle_sig(int sig)
{
    (void)sig;
    g_stop = 1;
}

static void handle_usr1(int sig)
{
    (void)sig;
    arp_dump();
    tcp_dump();
}

int main(int argc, char **argv)
{
    LOG_I("tcpip stack starting...");
    const char *tapname = "tap0";
    const char *ipstr   = "10.0.0.2";
    const char *maskstr = "255.255.255.0";

    const char *connect_to = NULL; /* host:port 主動連線示範 */
    uint16_t echo_port   = 9001;
    uint16_t http_port   = 8080;
    int      echo_on     = 1;
    int      http_on     = 0;

    for (int i = 1; i < argc; i++) {
        const char *a = argv[i];
        if (!strcmp(a, "--tap") && i + 1 < argc)
            tapname = argv[++i];
        else if (!strcmp(a, "--ip") && i + 1 < argc)
            ipstr = argv[++i];
        else if (!strcmp(a, "--mask") && i + 1 < argc)
            maskstr = argv[++i];
        else if (!strcmp(a, "--no-echo"))
            echo_on = 0;
        else if (!strcmp(a, "--http") || !strcmp(a, "--http=on"))
            http_on = 1;
        else if (!strncmp(a, "--connect=", 10))
            connect_to = a + 10;
        else if (!strcmp(a, "--echo-port") && i + 1 < argc)
            echo_port = (uint16_t)atoi(argv[++i]);
        else if (!strcmp(a, "--http-port") && i + 1 < argc)
            http_port = (uint16_t)atoi(argv[++i]);
        else {
            fprintf(stderr,
                    "usage: %s [--tap tap0] [--ip 10.0.0.2] [--mask 255.255.255.0]\n"
                    "         [--no-echo] [--http] [--connect=1.2.3.4:port] [--echo-port N] [--http-port N]\n",
                    argv[0]);
            return 1;
        }
    }

    if (netdev_init(tapname, ipstr, maskstr) < 0)
        return 1;

    signal(SIGINT, handle_sig);
    signal(SIGTERM, handle_sig);
    signal(SIGUSR1, handle_usr1);

    if (echo_on)
        app_echo_init(echo_port);
    if (http_on)
        app_http_init(http_port);

    if (connect_to) {
        char hoststr[64];
        strncpy(hoststr, connect_to, sizeof(hoststr) - 1);
        hoststr[sizeof(hoststr) - 1] = 0;
        char *colon = strchr(hoststr, ':');
        if (!colon) {
            LOG_E("--connect expecting ip:port");
            return 1;
        }
        *colon = 0;
        uint32_t dip;
        if (ip_parse(hoststr, &dip) < 0) {
            LOG_E("bad --connect ip %s", hoststr);
            return 1;
        }
        app_client_demo(dip, (uint16_t)atoi(colon + 1));
    }

    uint8_t frame[FRAME_BUF];
    uint64_t last_tick = now_ms();
    while (!g_stop) {
        struct pollfd pfd = { .fd = g_netdev.fd, .events = POLLIN };
        int n = poll(&pfd, 1, 50); /* 50ms 一輪，像 timer */
        if (n < 0) {
            if (errno == EINTR)
                continue;
            LOG_E("poll error: %m");
            break;
        }
        if (n > 0 && (pfd.revents & POLLIN)) {
            /* 一次讀光所有 frame */
            for (int i = 0; i < 32; i++) {
                int r = tap_read(g_netdev.fd, frame, sizeof(frame));
                if (r <= 0)
                    break;
                ethernet_receive(frame, (size_t)r);
            }
        }
        uint64_t now = now_ms();
        if (now - last_tick >= 50) {
            last_tick = now;
            arp_tick();
            tcp_tick();
        }
    }

    LOG_I("tcpip stack stopped.");
    return 0;
}
