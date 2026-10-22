#pragma once
/* tap.h — TAP 虛擬網卡 (/dev/net/tun)，拿到的是含 Ethernet 標頭的 L2 訊框 */
#include <stdint.h>
#include <stddef.h>
int tap_open(const char *name); /* 回傳 fd，失敗傳 -1 */
int tap_read(int fd, uint8_t *buf, size_t size);
int tap_write(int fd, const uint8_t *buf, size_t len);
