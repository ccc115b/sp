//! pk 風格系統呼叫。
//!
//! 真實的 spike 執行 M-mode 的 pk(proxy kernel),使用者的 ecall 會陷到
//! pk,pk 再代為執行系統呼叫。spike0 把這個角色簡化成「直接在主控台處理」:
//! ecall 時讀 a7 = 系統呼叫編號、a0..a5 = 參數、回傳值放 a0。
//!
//! 編號與 Linux RISC-V / pk 相同。

use crate::bus::Bus;

// Linux RISC-V 系統呼叫編號(節錄)
pub const SYS_GETCWD: u64 = 17;
pub const SYS_READ: u64 = 63;
pub const SYS_WRITE: u64 = 64;
pub const SYS_EXIT: u64 = 93;
pub const SYS_EXIT_GROUP: u64 = 94;
pub const SYS_GETPID: u64 = 172;
pub const SYS_UNAME: u64 = 160;
pub const SYS_BRK: u64 = 214;
pub const SYS_CLOCK_GETTIME: u64 = 113;

/// 系統呼叫處理結果。
pub enum Syscall {
    /// 已完成,回傳值要寫回 a0
    Ret(i64),
    /// 程式要求結束
    Exit(i32),
    /// 未知/未實作:讓上層報錯(模擬「pk 沒有這個系統呼叫」)
    Unimplemented,
}

pub struct SysState {
    /// brk 目前的上界(堆積尾端)
    pub brk: u64,
    /// 已配置給堆積的起始位址
    pub heap_base: u64,
    /// 程式碼結尾(由 ELF 載入時設定)
    pub program_end: u64,
}

impl SysState {
    pub fn new() -> Self {
        SysState {
            brk: 0,
            heap_base: 0,
            program_end: 0,
        }
    }
}

/// 處理一次 ecall。
pub fn dispatch(nr: u64, args: [u64; 6], state: &mut SysState, bus: &mut Bus) -> Syscall {
    match nr {
        SYS_WRITE => {
            let fd = args[0] as i32;
            let buf = args[1];
            let len = args[2];
            if fd != 1 && fd != 2 {
                return Syscall::Ret(-1); // 只支援 stdout / stderr
            }
            let bytes = bus.read_bytes(buf, len);
            bus.write_console(&bytes);
            Syscall::Ret(len as i64)
        }
        SYS_READ => {
            // 沒有輸入裝置,回傳 EOF
            Syscall::Ret(0)
        }
        SYS_EXIT | SYS_EXIT_GROUP => Syscall::Exit(args[0] as i32),
        SYS_BRK => {
            let req = args[0];
            if req == 0 {
                return Syscall::Ret(state.brk as i64);
            }
            let limit = crate::bus::DRAM_BASE + bus.dram.len() as u64;
            if req >= state.heap_base && req < limit {
                state.brk = req;
            }
            Syscall::Ret(state.brk as i64)
        }
        SYS_CLOCK_GETTIME => {
            // 只支援 CLOCK_MONOTONIC(1),寫回秒數與奈秒
            let tp = args[1];
            let now = std::time::SystemTime::now()
                .duration_since(std::time::UNIX_EPOCH)
                .unwrap_or_default();
            let _ = bus.store(tp, 8, now.as_secs());
            let _ = bus.store(tp + 8, 8, now.subsec_nanos() as u64);
            Syscall::Ret(0)
        }
        SYS_GETPID => Syscall::Ret(1),
        SYS_GETCWD => {
            // 寫回 "/\0"
            let _ = bus.store(args[0], 1, b'/' as u64);
            let _ = bus.store(args[0] + 1, 1, 0);
            Syscall::Ret(1)
        }
        SYS_UNAME => {
            // 填一個假的 utsname:sysname / nodename / release ...
            let buf = args[0];
            let put = |bus: &mut Bus, off: u64, s: &str| {
                for (i, b) in s.bytes().chain(std::iter::once(0)).enumerate() {
                    let _ = bus.store(buf + off + i as u64, 1, b as u64);
                }
            };
            put(bus, 0, "Linux");       // sysname[65]
            put(bus, 65, "spike0");     // nodename[65]
            put(bus, 130, "6.0.0");     // release[65]
            put(bus, 195, "spike0");    // version[65]
            put(bus, 260, "riscv64");   // machine[65]
            put(bus, 325, "localhost"); // domainname[65]
            Syscall::Ret(0)
        }
        _ => Syscall::Unimplemented,
    }
}
