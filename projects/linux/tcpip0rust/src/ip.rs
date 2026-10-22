//! ip — IPv4 層：收包分發 + 送包（檢查和、DF）
use std::net::Ipv4Addr;

use crate::ethernet::Mac;
use crate::stack::Stack;
use crate::utils::cksum;
use crate::{icmp, tcp, udp};
use crate::log_d;

pub const PROTO_ICMP: u8 = 1;
pub const PROTO_TCP: u8 = 6;
pub const PROTO_UDP: u8 = 17;

pub const HDR_MIN: usize = 20;
pub const FLAG_DF: u16 = 0x4000;
pub const FLAG_MF: u16 = 0x2000;

struct Parsed {
    hl: usize,
    total: usize,
    frag: u16,
    proto: u8,
    src: Ipv4Addr,
    dst: Ipv4Addr,
}

fn parse(p: &[u8]) -> Option<Parsed> {
    if p.len() < HDR_MIN {
        return None;
    }
    if p[0] >> 4 != 4 {
        return None;
    }
    let hl = ((p[0] & 0x0f) as usize) * 4;
    if hl < HDR_MIN || hl > p.len() {
        return None;
    }
    let total = u16::from_be_bytes([p[2], p[3]]) as usize;
    if total > p.len() {
        return None;
    }
    Some(Parsed {
        hl,
        total,
        frag: u16::from_be_bytes([p[6], p[7]]),
        proto: p[9],
        src: Ipv4Addr::from([p[12], p[13], p[14], p[15]]),
        dst: Ipv4Addr::from([p[16], p[17], p[18], p[19]]),
    })
}

/// 收到一個 IPv4 封包（ethernet::receive 呼叫）
pub fn receive(st: &mut Stack, _src_mac: Mac, data: &[u8]) {
    let Some(p) = parse(data) else { return };

    // 檢查和：整個 header（先清零重算）
    let mut tmp = data[..p.hl].to_vec();
    tmp[10..12].copy_from_slice(&[0, 0]);
    let rx = u16::from_be_bytes([data[10], data[11]]);
    if cksum(&tmp) != rx {
        log_d!("ip: 檢查和失敗，丟包");
        return;
    }

    // 分片（只有第一片有完整 L4 標頭）；本棧不支持重組
    if p.frag & (FLAG_MF | 0x1fff) != 0 {
        log_d!("ip: 分片未支援，丟包");
        return;
    }

    if st.nd.ip != p.dst {
        let dst2 = p.dst;
        log_d!("ip: 不是我們的（dst={dst2}），丟包");
        return;
    }

    let payload = &data[p.hl..p.total];
    match p.proto {
        PROTO_ICMP => icmp::receive(st, p.src, p.dst, payload),
        PROTO_UDP => udp::receive(st, p.src, p.dst, payload),
        PROTO_TCP => tcp::receive(st, p.src, p.dst, payload),
        other => log_d!("ip: 未知 proto={other}"),
    }
}

/// 送 IPv4 封包（payload = 完整傳輸層 PDU）。
/// 經 ARP 解析 MAC；回傳 false 表示已進 ARP pending（此包還未上網）
pub fn send(st: &mut Stack, dst: Ipv4Addr, proto: u8, payload: &[u8]) -> bool {
    let ip_len = HDR_MIN + payload.len();
    let mut packet = vec![0u8; ip_len];
    packet[0] = 0x45;
    packet[2..4].copy_from_slice(&(ip_len as u16).to_be_bytes());
    packet[4..6].copy_from_slice(&next_id().to_be_bytes());
    packet[6..8].copy_from_slice(&FLAG_DF.to_be_bytes());
    packet[8] = 64; // TTL
    packet[9] = proto;
    packet[12..16].copy_from_slice(&st.nd.ip.octets());
    packet[16..20].copy_from_slice(&dst.octets());
    let ck = cksum(&packet[..HDR_MIN]);
    packet[10..12].copy_from_slice(&ck.to_be_bytes());
    packet[HDR_MIN..].copy_from_slice(payload);

    let Stack { nd, arp, .. } = st;
    arp.send_ip_packet(nd, dst, &packet)
}

fn next_id() -> u16 {
    static ID: std::sync::atomic::AtomicU16 = std::sync::atomic::AtomicU16::new(1);
    ID.fetch_add(1, std::sync::atomic::Ordering::Relaxed)
}
