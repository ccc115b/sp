#include "vgpio.h"
int main(void) {
    gpio_mode(17, 1);
    for (;;) {
        gpio_set(17, 1); msleep(500);
        gpio_set(17, 0); msleep(500);
    }
}
