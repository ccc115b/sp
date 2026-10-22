#pragma once
/* apps.h — 示範應用層：Echo 伺服器 + 迷你 HTTP 伺服器 */
#include "tcp.h"

void app_echo_init(uint16_t port);
void app_http_init(uint16_t port);
void app_client_demo(uint32_t dst_ip, uint16_t dst_port); /* 主動連線示範 (echo 到對端) */
