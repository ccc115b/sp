#include "vgpio.h"
int main(void) {
    int pins[4] = {17, 27, 22, 23};
    for (int b = 0; b < 4; b++) gpio_mode(pins[b], 1);
    for (;;) {
        for (int n = 0; n < 16; n++) {
            for (int b = 0; b < 4; b++) gpio_set(pins[b], (n >> b) & 1);
            msleep(300);
        }
    }
}
