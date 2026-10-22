//! 共用工具：Internet 檢查和、hexdump、時間
#![allow(dead_code)]

use std::time::{SystemTime, UNIX_EPOCH};

/// Internet checksum（RFC 1071）：資料視為 big-endian 16-bit words 加總後取反。
/// 注意：輸入長度為奇數時按 RFC 補零。
pub fn cksum(data: &[u8]) -> u16 {
    let mut sum: u32 = 0;
    let mut i = 0;
    while i < data.len() {
        let hi = (data[i] as u32) << 8;
        let lo = if i + 1 < data.len() { data[i + 1] as u32 } else { 0 };
        sum += hi | lo;
        i += 2;
    }
    while sum >> 16 != 0 {
        sum = (sum & 0xffff) + (sum >> 16);
    }
    !(sum as u16)
}

/// TCP / UDP 用的偽標頭檢查和：src, dst, zero, proto, len + 兩段資料
pub fn cksum_pseudo(src: u32, dst: u32, proto: u8, a: &[u8], b: &[u8]) -> u16 {
    let mut sum: u32 = (src >> 16) + (src & 0xffff) + (dst >> 16) + (dst & 0xffff)
        + ((0u32) << 8 | proto as u32)
        + (a.len() + b.len()) as u32;
    sum += pseudo_left(a);
    sum += pseudo_left(b);
    while sum >> 16 != 0 {
        sum = (sum & 0xffff) + (sum >> 16);
    }
    !(sum as u16)
}

fn pseudo_left(data: &[u8]) -> u32 {
    let mut sum: u32 = 0;
    let mut i = 0;
    while i < data.len() {
        let hi = (data[i] as u32) << 8;
        let lo = if i + 1 < data.len() { data[i + 1] as u32 } else { 0 };
        sum += hi | lo;
        i += 2;
    }
    sum
}

pub fn now_ms() -> u64 {
    SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .map(|d| d.as_millis() as u64)
        .unwrap_or(0)
}

pub fn hexdump(tag: &str, p: &[u8]) {
    if p.is_empty() {
        return;
    }
    eprintln!("[D] {tag} ({} bytes):", p.len());
    for (i, chunk) in p.chunks(16).enumerate() {
        let hex: String = chunk
            .iter()
            .map(|b| format!("{b:02x}"))
            .collect::<Vec<_>>()
            .join(" ");
        let ascii: String = chunk
            .iter()
            .map(|&b| {
                if (32..127).contains(&b) {
                    b as char
                } else {
                    '.'
                }
            })
            .collect();
        eprintln!("    {i:04x}  {hex:<48} |{ascii}|");
    }
}

#[macro_export]
macro_rules! log_i {
    ($($arg:tt)*) => { eprintln!("[I] {}", format_args!($($arg)*)) };
}
#[macro_export]
macro_rules! log_w {
    ($($arg:tt)*) => { eprintln!("[W] {}", format_args!($($arg)*)) };
}
#[macro_export]
macro_rules! log_e {
    ($($arg:tt)*) => { eprintln!("[E] {}", format_args!($($arg)*)) };
}

#[cfg(debug_assertions)]
#[macro_export]
macro_rules! log_d {
    ($($arg:tt)*) => { eprintln!("[D] {}", format_args!($($arg)*)) };
}
#[cfg(not(debug_assertions))]
#[macro_export]
macro_rules! log_d {
    ($($arg:tt)*) => {{}};
}
