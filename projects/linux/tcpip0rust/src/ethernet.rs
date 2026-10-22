//! ethernet — L2 (Ethernet) 訊框收送層：分解/組裝幀、廣播辨識、分發到 ARP/IP
use std::net::Ipv4Addr;

use crate::netdev::NetDev;
use crate::stack::Stack;
use crate::ip;

pub const MAC_LEN: usize = 6;
pub const HDR_LEN: usize = 14;
pub const PROTO_ARP: u16 = 0x0806;
pub const PROTO_IP: u16 = 0x0800;

pub const BCST_MAC: [u8; MAC_LEN] = [0xff; MAC_LEN];

#[derive(Clone, Copy, PartialEq, Eq, Debug)]
pub struct Mac(pub [u8; MAC_LEN]);

impl std::fmt::Display for Mac {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "{:02x}:{:02x}:{:02x}:{:02x}:{:02x}:{:02x}",
            self.0[0], self.0[1], self.0[2], self.0[3], self.0[4], self.0[5]
        )
    }
}

/// 收到一個幀（main 呼叫）：解析 header、過濾非我們的幀、分發
pub fn receive(st: &mut Stack, frame: &[u8]) {
    if frame.len() < HDR_LEN {
        return;
    }
    let dst = Mac(frame[0..6].try_into().unwrap());
    let src = Mac(frame[6..12].try_into().unwrap());
    let etype = u16::from_be_bytes([frame[12], frame[13]]);

    if dst != Mac(st.nd.mac) && dst != Mac(BCST_MAC) {
        return;
    }
    let payload = &frame[HDR_LEN..];

    match etype {
        PROTO_ARP => {
            let (nd, arp_state) = crate::stack::split_arp(st);
            arp_state.receive_packet(nd, payload);
        }
        PROTO_IP => ip::receive(st, src, payload),
        _ => crate::log_d!("eth: 忽略 ethertype 0x{etype:04x}"),
    }
}

/// 送一個 L2 幀（只需要本機網卡；不借 Stack）
pub fn send(nd: &NetDev, dst: Mac, ethertype: u16, payload: &[u8]) {
    let mut frame = Vec::with_capacity(HDR_LEN + payload.len());
    frame.extend_from_slice(&dst.0);
    frame.extend_from_slice(&nd.mac);
    frame.extend_from_slice(&ethertype.to_be_bytes());
    frame.extend_from_slice(payload);
    nd.tap.write_frame(&frame);
}

#[allow(dead_code)]
fn unused(_: Ipv4Addr) {}
