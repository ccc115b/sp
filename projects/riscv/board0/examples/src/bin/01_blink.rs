// Blink：LED 接 D3，每秒閃爍一次
#![no_std]
#![no_main]
use arduino::*;
fn setup() { pin_mode(3, OUTPUT); }
fn main_loop() {
    digital_write(3, true);  delay(500);
    digital_write(3, false); delay(500);
}
arduino::sketch!(setup, main_loop);
