/* 按下 GPIO24 的按鈕，切換 GPIO17 的 LED */
#include "vgpio.h"
int main(void) {
    int last = 0, led = 0;
    gpio_mode(24, 0);
    gpio_mode(17, 1);
    for (;;) {
        int now = gpio_get(24);
        if (now && !last) { led = !led; gpio_set(17, led); }
        last = now;
        msleep(20);
    }
}
