//! 04-optimize 的共用執行環境（Rust no_std）
//!
//! 與 03-rust/rt.rs 相同的精神：不連結 libc，直接用 pk 的 write/exit
//! 系統呼叫。差別是這裡的重點在示範 LLVM 優化，所以每支 Rust 範例會先
//! 產生 LLVM IR（.ll），再經 opt 優化、llc 產生組語。

use core::arch::naked_asm;

const SYS_WRITE: usize = 64;
const SYS_EXIT: usize = 93;

#[unsafe(naked)]
#[no_mangle]
pub extern "C" fn _start() -> ! {
    naked_asm!(
        "la gp, __global_pointer$",
        "call main",
        "li a7, {exit}",
        "ecall",
        exit = const SYS_EXIT,
    )
}

#[inline(never)]
pub fn sys_write(fd: i32, buf: *const u8, len: usize) -> isize {
    let ret: isize;
    unsafe {
        core::arch::asm!(
            "ecall",
            inlateout("a0") fd as isize => ret,
            in("a1") buf,
            in("a2") len,
            in("a7") SYS_WRITE,
        );
    }
    ret
}

#[inline(never)]
pub fn print(s: &str) {
    sys_write(1, s.as_ptr(), s.len());
}

#[inline(never)]
pub fn print_i64(v: i64) {
    if v < 0 {
        print("-");
        print_u64(v.unsigned_abs());
    } else {
        print_u64(v as u64);
    }
}

#[inline(never)]
pub fn print_u64(mut v: u64) {
    if v == 0 {
        print("0");
        return;
    }
    let mut buf = [0u8; 20];
    let mut i = 20;
    while v > 0 {
        i -= 1;
        buf[i] = b'0' + (v % 10) as u8;
        v /= 10;
    }
    sys_write(1, buf[i..].as_ptr(), 20 - i);
}

#[panic_handler]
fn panic(_info: &core::panic::PanicInfo) -> ! {
    sys_write(1, b"panic!\n".as_ptr(), 7);
    unsafe {
        core::arch::asm!("ecall", in("a0") 134, in("a7") SYS_EXIT);
    }
    loop {}
}
