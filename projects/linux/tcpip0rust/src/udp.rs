//! udp — 最小支援：檢查和 + 記 log（本棧未提供 UDP 服務）
use std::net::Ipv4Addr;

use crate::ip;
use crate::log_d;
use crate::stack::Stack;
use crate::utils::cksum_pseudo;

pub const HDR_LEN: usize = 8;

pub fn receive(st: &mut Stack, src: Ipv4Addr, dst: Ipv4Addr, data: &[u8]) {
    let _ = st;
    if data.len() < HDR_LEN {
        return;
    }
    let sport = u16::from_be_bytes([data[0], data[1]]);
    let dport = u16::from_be_bytes([data[2], data[3]]);
    let len = u16::from_be_bytes([data[4], data[5]]) as usize;

    if data[6..8] != [0, 0] {
        // 檢查和範圍 = 偽標頭 + header + payload
        let rx = u16::from_be_bytes([data[6], data[7]]);
        let mut tmp = data[..len.min(data.len())].to_vec();
        tmp[6..8].copy_from_slice(&[0, 0]);
        if cksum_pseudo(src.to_bits(), dst.to_bits(), ip::PROTO_UDP, &tmp, &[]) != rx {
            log_d!("udp: 檢查和失敗，丟包");
            return;
        }
    }
    log_d!("udp: {src}:{sport} -> {dst}:{dport} len={len}（本棧未提供 UDP 服務，僅記錄）");
}
