// Fade：D3 的 LED 用 PWM 做呼吸燈
#![no_std]
#![no_main]
use arduino::*;
fn setup() { pin_mode(3, OUTPUT); }
fn main_loop() {
    let mut b = 0;
    while b <= 255 { analog_write(3, b); delay(15); b += 5; }
    while b > 0 { b -= 5; analog_write(3, b); delay(15); }
}
arduino::sketch!(setup, main_loop);
