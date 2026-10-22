// Button：按鈕接 D2，按下時 D3 的 LED 亮起
#![no_std]
#![no_main]
use arduino::*;
fn setup() { pin_mode(2, INPUT); pin_mode(3, OUTPUT); }
fn main_loop() { digital_write(3, digital_read(2)); }
arduino::sketch!(setup, main_loop);
