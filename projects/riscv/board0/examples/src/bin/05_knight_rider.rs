// Knight Rider：四顆 LED 接 D0~D3，來回掃描
#![no_std]
#![no_main]
use arduino::*;
fn setup() { for p in 0..4 { pin_mode(p, OUTPUT); } }
fn step(p: u32) { digital_write(p, true); delay(100); digital_write(p, false); }
fn main_loop() {
    for p in 0..4 { step(p); }
    for p in (1..3).rev() { step(p); }
}
arduino::sketch!(setup, main_loop);
