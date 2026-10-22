//! netdev — 我們這台「虛擬機器」的網卡（MAC + IP + TAP）
#![allow(dead_code)]
use std::net::Ipv4Addr;
use std::sync::Arc;

use crate::tap::Tap;

pub const MTU: usize = 1500;
pub const MAX_FRAME: usize = MTU + 18;

pub struct NetDev {
    pub mac: [u8; 6],
    pub ip: Ipv4Addr,
    pub netmask: Ipv4Addr,
    pub tap: Arc<Tap>,
}

impl NetDev {
    pub fn new(tapname: &str, ip: Ipv4Addr, netmask: Ipv4Addr) -> Option<NetDev> {
        let tap = Arc::new(Tap::open(tapname)?);
        // TAP 裝置的 MAC 用固定前綴方便辨識（locally administered）
        let mut mac = [0x52u8, 0x05, 0xc2, 0x99, 0x01, 0x42];
        mac[5] ^= (ip.to_bits() & 0xff) as u8;
        Some(NetDev { mac, ip, netmask, tap })
    }
}
