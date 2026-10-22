#![no_std]
use core::ptr::{read_volatile, write_volatile};
const B: usize = 0x1000_0000;
pub const INPUT: u32 = 0;
pub const OUTPUT: u32 = 1;
fn rd(o: usize) -> u32 { unsafe { read_volatile((B + o) as *const u32) } }
fn wr(o: usize, v: u32) { unsafe { write_volatile((B + o) as *mut u32, v) } }

pub fn pin_mode(p: u32, m: u32) { let d = rd(0); wr(0, if m == OUTPUT { d | 1 << p } else { d & !(1 << p) }) }
pub fn digital_write(p: u32, v: bool) { let o = rd(4); wr(4, if v { o | 1 << p } else { o & !(1 << p) }) }
pub fn digital_read(p: u32) -> bool { (rd(8) >> p) & 1 == 1 }
pub fn analog_write(p: u32, v: u32) { wr(0x10 + 4 * p as usize, 0x100 | (v & 255)) }
pub fn analog_read(ch: u32) -> u32 { rd(0x40 + 4 * ch as usize) }
pub fn delay(ms: u32) { wr(0x94, ms) }
pub fn millis() -> u32 { rd(0x90) / 1000 }
pub fn print(s: &str) { for b in s.bytes() { wr(0x80, b as u32) } }
pub fn println(s: &str) { print(s); wr(0x80, 10) }
pub fn print_u32(mut n: u32) {
    let mut b = [0u8; 10]; let mut i = 10;
    loop { i -= 1; b[i] = b'0' + (n % 10) as u8; n /= 10; if n == 0 { break } }
    for &c in &b[i..] { wr(0x80, c as u32) }
}

/// sketch!(setup, loop) 產生啟動碼 (_start)、入口與 panic handler
#[macro_export]
macro_rules! sketch { ($s:ident, $l:ident) => {
    core::arch::global_asm!(".section .text.init\n.globl _start\n_start:\n la sp, _stack_top\n call _entry");
    #[no_mangle] pub extern "C" fn _entry() -> ! { $s(); loop { $l() } }
    #[panic_handler] fn _panic(_: &core::panic::PanicInfo) -> ! { loop {} }
}}
