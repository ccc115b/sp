/* vgpio.h - 虛擬 GPIO（經由 console 逸出序列與網頁溝通） */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
static void gpio_mode(int pin, int out) { printf("\033]7777;d %d %s\007", pin, out ? "out" : "in"); fflush(stdout); }
static void gpio_set(int pin, int v)    { printf("\033]7777;o %d %d\007", pin, !!v); fflush(stdout); }
static int  gpio_get(int pin)           { char b[32]; printf("\033]7777;q\007"); fflush(stdout);
                                          if (!fgets(b, sizeof b, stdin)) return 0; return (atol(b) >> pin) & 1; }
static void msleep(int ms)              { usleep(ms * 1000); }
