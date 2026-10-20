//! 03-rust 的共用執行環境（runtime）
//!
//! RISC-V 裸機（bare metal）沒有 libc，pk（proxy kernel）透過 ecall 提供
//! 最基本的系統呼叫。這裡實作：
//!   - `_start`：程式進入點，呼叫 main 後用 exit 系統呼叫結束
//!   - `print` 系列：write 系統呼叫 + 自己做的整數／浮點格式化
//!   - `#[panic_handler]`：Rust 要求 no_std 程式必須提供

use core::arch::naked_asm;

/// pk 的 Linux 風格系統呼叫編號
const SYS_WRITE: usize = 64;
const SYS_EXIT: usize = 93;

/// 程式進入點：pk 設好堆疊後跳到 ELF entry（就是這個 _start）
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

/// write(2) 系統呼叫：把 buf 的 len 個位元組寫到 fd（1 = stdout）
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

/// exit 系統呼叫：結束程式並回傳狀態碼
#[inline(never)]
pub fn sys_exit(code: i32) -> ! {
    unsafe {
        core::arch::asm!(
            "ecall",
            in("a0") code,
            in("a7") SYS_EXIT,
        );
    }
    loop {}
}

/// 輸出字串
#[inline(never)]
pub fn print(s: &str) {
    sys_write(1, s.as_ptr(), s.len());
}

/// 輸出一串位元組
#[inline(never)]
pub fn print_bytes(buf: &[u8]) {
    sys_write(1, buf.as_ptr(), buf.len());
}

/// 輸出十進位無號整數
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
    print_bytes(&buf[i..]);
}

/// 輸出十進位有號整數
#[inline(never)]
pub fn print_i64(v: i64) {
    if v < 0 {
        print("-");
        print_u64(v.unsigned_abs());
    } else {
        print_u64(v as u64);
    }
}

/// 輸出浮點數，固定印 digits 位小數（四捨五入）
///
/// 做法：先乘上 10^digits 取整數，再把這個整數拆成整數部分與小數部分
#[inline(never)]
pub fn print_f64(v: f64, digits: u32) {
    if v < 0.0 {
        print("-");
        print_f64(-v, digits);
        return;
    }
    let mut scale: u64 = 1;
    for _ in 0..digits {
        scale *= 10;
    }
    let n = (v * scale as f64 + 0.5) as u64;
    print_u64(n / scale);
    print(".");
    let mut buf = core::mem::MaybeUninit::<[u8; 20]>::uninit();
    let buf = unsafe { &mut *buf.as_mut_ptr() };
    let mut i = digits as usize;
    let mut frac = n % scale;
    while i > 0 {
        i -= 1;
        buf[i] = b'0' + (frac % 10) as u8;
        frac /= 10;
    }
    print_bytes(&buf[..digits as usize]);
}

#[panic_handler]
fn panic(_info: &core::panic::PanicInfo) -> ! {
    print("panic!\n");
    sys_exit(134);
}
