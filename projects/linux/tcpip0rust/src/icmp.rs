//! icmp — echo request -> echo reply（讓 `ping` 通）
use std::net::Ipv4Addr;

use crate::ip;
use crate::stack::Stack;
use crate::utils::cksum;
use crate::log_d;

pub const ECHO_REPLY: u8 = 0;
pub const ECHO_REQUEST: u8 = 8;

pub const HDR_LEN: usize = 8;

#[allow(clippy::needless_range_loop)]
pub fn receive(st: &mut Stack, src: Ipv4Addr, dst: Ipv4Addr, data: &[u8]) {
    let _ = dst;
    if data.len() < HDR_LEN {
        return;
    }
    let typ = data[0];
    let id = u16::from_be_bytes([data[4], data[5]]);
    let seq = u16::from_be_bytes([data[6], data[7]]);

    if typ == ECHO_REQUEST {
        let mut tmp = data.to_vec();
        tmp[2..4].copy_from_slice(&[0, 0]);
        let rx = u16::from_be_bytes([data[2], data[3]]);
        if cksum(&tmp) != rx {
            log_d!("icmp: 檢查和失敗，丟包");
            return;
        }
        tmp[0] = ECHO_REPLY;
        let ck = cksum(&tmp);
        tmp[2..4].copy_from_slice(&ck.to_be_bytes());
        log_d!("icmp: echo request from {src} id={id} seq={seq} -> 回覆");
        ip::send(st, src, ip::PROTO_ICMP, &tmp);
    }
}
