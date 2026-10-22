#include "vgpio.h"
int main(void) {
    int red = 17, yellow = 27, green = 22;
    gpio_mode(red, 1); gpio_mode(yellow, 1); gpio_mode(green, 1);
    for (;;) {
        gpio_set(green, 1);  msleep(2000); gpio_set(green, 0);
        gpio_set(yellow, 1); msleep(800);  gpio_set(yellow, 0);
        gpio_set(red, 1);    msleep(2000); gpio_set(red, 0);
    }
}
