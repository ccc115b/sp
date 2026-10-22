#include "vgpio.h"
int main(void) {
    int d[9] = {200, 200, 200, 600, 600, 600, 200, 200, 200};
    gpio_mode(17, 1);
    for (;;) {
        for (int i = 0; i < 9; i++) {
            gpio_set(17, 1); msleep(d[i]);
            gpio_set(17, 0); msleep(200);
        }
        msleep(1000);
    }
}
