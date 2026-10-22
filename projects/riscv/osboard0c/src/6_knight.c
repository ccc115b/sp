#include "vgpio.h"
int main(void) {
    int pins[4] = {17, 27, 22, 23};
    int seq[6] = {0, 1, 2, 3, 2, 1};
    for (int b = 0; b < 4; b++) gpio_mode(pins[b], 1);
    for (;;) {
        for (int i = 0; i < 6; i++) {
            gpio_set(pins[seq[i]], 1); msleep(120);
            gpio_set(pins[seq[i]], 0);
        }
    }
}
