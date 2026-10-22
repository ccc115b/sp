//! arp — 位址解析：IP <-> MAC。表、pending 佇列、限速重試
use std::net::Ipv4Addr;
use std::time::{Duration, Instant};

use crate::ethernet::{send, Mac, BCST_MAC, MAC_LEN, PROTO_ARP, PROTO_IP};
use crate::netdev::NetDev;
use crate::{log_d, log_i};

const HW_ETHER: u16 = 1;
const OP_REQUEST: u16 = 1;
const OP_REPLY: u16 = 2;

const ENTRY_TTL_MS: u64 = 30_000;
const RETRY_MS: u64 = 1_000;
const TABLE_MAX: usize = 64;
const PENDQ_MAX: usize = 16;

#[derive(Clone, Copy, Debug)]
pub struct Entry {
    pub ip: Ipv4Addr,
    pub mac: Mac,
    updated: Instant,
    probed: Option<Instant>,
}

#[derive(Clone)]
pub struct Pending {
    pub dst_ip: Ipv4Addr,
    pub packet: Vec<u8>,
}

pub struct ArpState {
    entries: Vec<Entry>,
    pending: Vec<Pending>,
}

impl Default for ArpState {
    fn default() -> Self {
        ArpState { entries: Vec::new(), pending: Vec::new() }
    }
}

#[allow(dead_code)]
struct Wire {
    op: u16,
    sha: Mac,
    spa: Ipv4Addr,
    tha: Mac,
    tpa: Ipv4Addr,
}

fn parse(p: &[u8]) -> Option<Wire> {
    if p.len() < 28
        || u16::from_be_bytes([p[0], p[1]]) != HW_ETHER
        || u16::from_be_bytes([p[2], p[3]]) != 0x0800
        || p[4] != MAC_LEN as u8
        || p[5] != 4
    {
        return None;
    }
    Some(Wire {
        op: u16::from_be_bytes([p[6], p[7]]),
        sha: Mac(p[8..14].try_into().unwrap()),
        spa: Ipv4Addr::from([p[14], p[15], p[16], p[17]]),
        tha: Mac(p[18..24].try_into().unwrap()),
        tpa: Ipv4Addr::from([p[24], p[25], p[26], p[27]]),
    })
}

fn build(op: u16, sha: Mac, spa: Ipv4Addr, tha: Mac, tpa: Ipv4Addr) -> [u8; 28] {
    let mut b = [0u8; 28];
    b[0..2].copy_from_slice(&HW_ETHER.to_be_bytes());
    b[2..4].copy_from_slice(&0x0800u16.to_be_bytes());
    b[4] = MAC_LEN as u8;
    b[5] = 4;
    b[6..8].copy_from_slice(&op.to_be_bytes());
    b[8..14].copy_from_slice(&sha.0);
    b[14..18].copy_from_slice(&spa.octets());
    b[18..24].copy_from_slice(&tha.0);
    b[24..28].copy_from_slice(&tpa.octets());
    b
}

impl ArpState {
    fn find(&self, ip: Ipv4Addr) -> Option<&Entry> {
        self.entries.iter().find(|e| e.ip == ip)
    }

    fn _upsert(&mut self, ip: Ipv4Addr, mac: Option<Mac>, probed: bool) {
        let now = Instant::now();
        if let Some(e) = self.entries.iter_mut().find(|e| e.ip == ip) {
            if let Some(m) = mac {
                e.mac = m;
                e.updated = now;
            }
            if probed {
                e.probed = Some(now);
            }
            return;
        }
        if self.entries.len() >= TABLE_MAX {
            if let Some((i, _)) = self.entries.iter().enumerate().min_by_key(|(_, e)| e.updated) {
                self.entries.swap_remove(i);
            }
        }
        self.entries.push(Entry {
            ip,
            mac: mac.unwrap_or(Mac([0; MAC_LEN])),
            updated: now,
            probed: probed.then_some(now),
        });
    }

    fn lookup(&self, ip: Ipv4Addr) -> Option<Mac> {
        let e = self.find(ip)?;
        (e.updated.elapsed() < Duration::from_millis(ENTRY_TTL_MS)).then_some(e.mac)
    }

    fn request_async(&mut self, nd: &NetDev, dst_ip: Ipv4Addr) {
        if let Some(e) = self.find(dst_ip) {
            if let Some(p) = e.probed {
                if p.elapsed() < Duration::from_millis(RETRY_MS) {
                    return; // 限速：1 秒內不重發
                }
            }
        }
        let pkt = build(OP_REQUEST, Mac(nd.mac), nd.ip, Mac([0; MAC_LEN]), dst_ip);
        send(nd, Mac(BCST_MAC), PROTO_ARP, &pkt);
        log_d!("arp send op=1 spa={} tpa={dst_ip}", nd.ip);
        self._upsert(dst_ip, None, true);
    }

    fn flush_pending(&mut self, nd: &NetDev) {
        for i in (0..self.pending.len()).rev() {
            if let Some(m) = self.lookup(self.pending[i].dst_ip) {
                let p = self.pending.remove(i);
                send(nd, m, PROTO_IP, &p.packet);
            }
        }
    }

    /// 收到一個 ARP 封包（ethernet::receive 呼叫）
    pub fn receive_packet(&mut self, nd: &NetDev, data: &[u8]) {
        let Some(a) = parse(data) else { return };
        log_d!("arp recv op={} spa={} tpa={}", a.op, a.spa, a.tpa);

        // 1) 學 sender 的 (ip, mac)
        self._upsert(a.spa, Some(a.sha), false);

        // 2) 有人問我們 -> 回 reply
        if a.op == OP_REQUEST && a.tpa == nd.ip {
            let pkt = build(OP_REPLY, Mac(nd.mac), nd.ip, a.sha, a.spa);
            send(nd, a.sha, PROTO_ARP, &pkt);
            log_d!("arp send op=2 spa={} tpa={}", nd.ip, a.spa);
        }

        // 3) 有新解的位址 -> 補送 pending
        self.flush_pending(nd);
    }

    /// 送 L3 封包：先 ARP；解析不到就排隊（回 false = 尚未出網）
    pub fn send_ip_packet(&mut self, nd: &NetDev, dst_ip: Ipv4Addr, packet: &[u8]) -> bool {
        if let Some(m) = self.lookup(dst_ip) {
            send(nd, m, PROTO_IP, packet);
            true
        } else {
            self.request_async(nd, dst_ip);
            if self.pending.len() < PENDQ_MAX {
                self.pending.push(Pending { dst_ip, packet: packet.to_vec() });
            } else {
                log_d!("arp: pending 佇列滿，丟包");
            }
            false
        }
    }

    /// 主迴圈定期呼叫：pending 補送 + ARP request 限速重發
    pub fn tick(&mut self, nd: &NetDev) {
        self.flush_pending(nd);
        let targets: Vec<Ipv4Addr> = self.pending.iter().map(|p| p.dst_ip).collect();
        for ip in targets {
            self.request_async(nd, ip);
        }
    }

    pub fn dump(&self) {
        log_i!("--- ARP table ---");
        for e in &self.entries {
            log_i!(
                "  {} {} est_age={:?}ms",
                e.ip,
                e.mac,
                e.updated.elapsed().as_millis()
            );
        }
    }
}

#[allow(dead_code)]
fn unused_tha(_: Mac) {}
