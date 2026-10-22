/* vgpio_device.c - 放進 TinyEMU 原始碼目錄，並加入 Makefile 的物件清單 */
#include <stdint.h>
#include "iomem.h"
#ifdef __EMSCRIPTEN__
#include <emscripten.h>
#else
#define EMSCRIPTEN_KEEPALIVE
#endif

#define VGPIO_BASE 0x40009000

static uint32_t g_out, g_dir, g_in;

static uint32_t vgpio_read(void *opaque, uint32_t off, int size_log2)
{
    switch (off) {
    case 0: return (g_out & g_dir) | (g_in & ~g_dir);
    case 4: return g_dir;
    }
    return 0;
}

static void vgpio_write(void *opaque, uint32_t off, uint32_t val, int size_log2)
{
    if (off == 0) g_out = val;
    else if (off == 4) g_dir = val;
}

void vgpio_init(PhysMemoryMap *map)
{
    cpu_register_device(map, VGPIO_BASE, 8, NULL,
                        vgpio_read, vgpio_write, DEVIO_SIZE32);
}

/* 給網頁 JS 讀寫的介面 */
EMSCRIPTEN_KEEPALIVE uint32_t vgpio_get_out(void) { return g_out; }
EMSCRIPTEN_KEEPALIVE uint32_t vgpio_get_dir(void) { return g_dir; }
EMSCRIPTEN_KEEPALIVE void vgpio_set_in(uint32_t m) { g_in = m; }
