// AnalogReadSerial：讀 A0 的可變電阻，印到序列埠，並控制 D3 亮度
#![no_std]
#![no_main]
use arduino::*;
fn setup() { pin_mode(3, OUTPUT); println("AnalogReadSerial start"); }
fn main_loop() {
    let v = analog_read(0);
    print("A0 = "); print_u32(v); println("");
    analog_write(3, v / 4);
    delay(200);
}
arduino::sketch!(setup, main_loop);
