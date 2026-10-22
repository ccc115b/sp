//! tcp — 自製 TCP 狀態機（Rust 版）
//!
//! 借用策略：每個函式短借用讀欄位 → 組段（純參數）→ 送出 → 再短借用後處理。
//! 這讓 apps callback 可重入呼叫 `write()` / `close()` 不會雙重借用。
use std::net::Ipv4Addr;

use crate::apps::{self, AppKind};
use crate::ip;
use crate::stack::Stack;
use crate::utils::{cksum_pseudo, now_ms};
use crate::{log_d, log_i, log_w};

/* 段 flags */
pub const TH_FIN: u8 = 0x01;
pub const TH_SYN: u8 = 0x02;
pub const TH_RST: u8 = 0x04;
pub const TH_PSH: u8 = 0x08;
pub const TH_ACK: u8 = 0x10;

pub const HDR_MIN: usize = 20;
pub const MSS: usize = 1460;
pub const DEF_WINDOW: u16 = 16384;
pub const INIT_RTO_MS: u64 = 500;
pub const MAX_RETRY: u32 = 8;
pub const TIME_WAIT_MS: u64 = 4000;
pub const CONNS_MAX: usize = 32;
pub const LISTEN_MAX: usize = 8;
pub const SEGQ_MAX: usize = 48;

#[derive(Clone, Copy, PartialEq, Eq, Debug)]
pub enum State {
    SynSent,
    SynRcvd,
    Established,
    FinWait1,
    FinWait2,
    TimeWait,
    LastAck,
    CloseWait,
}

impl State {
    pub fn name(self) -> &'static str {
        match self {
            State::SynSent => "SYN_SENT",
            State::SynRcvd => "SYN_RCVD",
            State::Established => "ESTABLISHED",
            State::FinWait1 => "FIN_WAIT1",
            State::FinWait2 => "FIN_WAIT2",
            State::TimeWait => "TIME_WAIT",
            State::LastAck => "LAST_ACK",
            State::CloseWait => "CLOSE_WAIT",
        }
    }
}

/* 送出後等確認的段；tx_ms == 0 表示尚未發過 */
#[derive(Clone)]
struct Seg {
    flags: u8,
    seq: u32,
    retried: u32,
    tx_ms: u64,
    data: Vec<u8>,
}

pub struct Tcb {
    pub state: State,
    peer_ip: Ipv4Addr,
    peer_port: u16, // host order
    lport: u16,     // host order
    iss: u32,
    snd_una: u32,
    snd_nxt: u32,
    rcv_nxt: u32,
    pub kind: AppKind,
    segq: Vec<Seg>,
    opened_ms: u64,
    app_closed: bool,
}

impl Tcb {
    /// 段佔用的序號數：SYN 佔 1、FIN 佔 1、data 佔 len
    fn used(&self, s: &Seg) -> u32 {
        let mut u = s.data.len() as u32;
        if s.flags & TH_SYN != 0 {
            u += 1;
        }
        if s.flags & TH_FIN != 0 {
            u += 1;
        }
        u
    }
    fn seg_end(&self, s: &Seg) -> u32 {
        s.seq + self.used(s)
    }
}

#[derive(Clone, Copy)]
pub struct Listener {
    pub lport: u16, // host order
    pub kind: AppKind,
}

pub struct TcpState {
    conns: Vec<Option<Tcb>>,
    listeners: Vec<Option<Listener>>,
    ephemeral: u16,
}

impl TcpState {
    pub fn new() -> TcpState {
        TcpState {
            conns: (0..CONNS_MAX).map(|_| None).collect(),
            listeners: vec![None; LISTEN_MAX],
            // 隨機起始：避免連續重跑時打到對端 TIME_WAIT 的舊 4-tuple
            ephemeral: 40_000 + (now_ms() as u16 % 20_000),
        }
    }

    pub fn listen(&mut self, port: u16, kind: AppKind) -> bool {
        if self.listeners.iter().flatten().any(|l| l.lport == port) {
            log_w!("tcp port {port} 已被監聽");
            return false;
        }
        match self.listeners.iter().position(|l| l.is_none()) {
            Some(slot) => {
                self.listeners[slot] = Some(Listener { lport: port, kind });
                log_i!("tcp listen on {port}");
                true
            }
            None => {
                log_w!("tcp 沒有空的 listener 位");
                false
            }
        }
    }

    fn find_listener(&self, lport: u16) -> Option<Listener> {
        self.listeners.iter().flatten().copied().find(|l| l.lport == lport)
    }
}

/* ---------- seq 算術（可繞回） ---------- */
fn seq_lt(a: u32, b: u32) -> bool {
    (a.wrapping_sub(b) as i32) < 0
}
fn seq_le(a: u32, b: u32) -> bool {
    (a.wrapping_sub(b) as i32) <= 0
}

fn rand_isn() -> u32 {
    (std::process::id() as u32)
        .wrapping_mul(1_103_515_245)
        .wrapping_add(now_ms() as u32)
        | 0x1000_0000
}

/* ---------- 發送 ---------- */

/// 送前抄下的欄位快照
struct Snap {
    peer_ip: Ipv4Addr,
    lport: u16,
    peer_port: u16,
    ack: u32, // rcv_nxt（還沒收到任何對端 ack 前為 0）
    state: State,
}

fn snap(st: &Stack, ci: usize) -> Option<Snap> {
    let c = st.tcp.conns.get(ci)?.as_ref()?;
    Some(Snap {
        peer_ip: c.peer_ip,
        lport: c.lport,
        peer_port: c.peer_port,
        ack: if c.rcv_nxt == 0 { 0 } else { c.rcv_nxt },
        state: c.state,
    })
}

/// 組一個完整 TCP 段（純參數、無借用、含檢查和）
fn build_segment(our_ip: Ipv4Addr, s: Snap, flags: u8, seq: u32, data: &[u8]) -> Vec<u8> {
    let mut buf = vec![0u8; HDR_MIN + data.len()];
    buf[0..2].copy_from_slice(&s.lport.to_be_bytes());
    buf[2..4].copy_from_slice(&s.peer_port.to_be_bytes());
    buf[4..8].copy_from_slice(&seq.to_be_bytes());
    buf[8..12].copy_from_slice(&s.ack.to_be_bytes());
    buf[12] = 5 << 4;
    buf[13] = flags;
    buf[14..16].copy_from_slice(&DEF_WINDOW.to_be_bytes());
    buf[HDR_MIN..].copy_from_slice(data);
    let ck = cksum_pseudo(our_ip.to_bits(), s.peer_ip.to_bits(), ip::PROTO_TCP, &buf, &[]);
    buf[16..18].copy_from_slice(&ck.to_be_bytes());
    buf
}

fn dbg_flags(flags: u8) -> String {
    let mut f = String::new();
    for (bit, ch) in [
        (TH_SYN, 'S'),
        (TH_FIN, 'F'),
        (TH_RST, 'R'),
        (TH_ACK, 'A'),
        (TH_PSH, 'P'),
    ] {
        if flags & bit != 0 {
            f.push(ch);
        }
    }
    if f.is_empty() {
        f.push('-');
    }
    f
}

/// 送一個包到網路上（純參數 + 選配把該段標成已送出）
fn send_out(
    st: &mut Stack,
    ci: usize,
    flags: u8,
    seq: u32,
    data: &[u8],
    mark: Option<usize>,
) {
    let Some(s) = snap(st, ci) else { return };
    let (dst, lport, peer_port, ack, state_name) =
        (s.peer_ip, s.lport, s.peer_port, s.ack, s.state.name());
    log_d!(
        "tcp >>> :{} -> {}:{} [{}] seq={} ack={} len={} state={}",
        lport,
        dst,
        peer_port,
        dbg_flags(flags),
        seq,
        ack,
        data.len(),
        state_name
    );
    let buf = build_segment(st.nd.ip, s, flags, seq, data);
    ip::send(st, dst, ip::PROTO_TCP, &buf);
    if let Some(i) = mark {
        if let Some(c) = st.tcp.conns[ci].as_mut() {
            if let Some(seg) = c.segq.get_mut(i) {
                seg.tx_ms = now_ms(); /* 這也代表「已送出」*/
            }
        }
    }
}

/// 送純 ACK（不進重傳佇列：丟了對端會再問）
fn send_pure_ack(st: &mut Stack, ci: usize) {
    let seq = st.tcp.conns[ci].as_ref().unwrap().snd_nxt;
    send_out(st, ci, TH_ACK, seq, &[], None);
}

/// 沒人監聽又收到 SYN：按 RFC 793 送 RST（ack = 對端 seq + 佔用序號數）
fn send_rst(st: &mut Stack, our_ip: Ipv4Addr, peer_ip: Ipv4Addr, our_port: u16, peer_port: u16, ack: u32) {
    log_d!("tcp >>> :{} -> {}:{} [RA] len=0（無監聽者，回 RST）", our_port, peer_ip, peer_port);
    let mut buf = vec![0u8; HDR_MIN];
    buf[0..2].copy_from_slice(&our_port.to_be_bytes());
    buf[2..4].copy_from_slice(&peer_port.to_be_bytes());
    buf[8..12].copy_from_slice(&ack.to_be_bytes());
    buf[12] = 5 << 4;
    buf[13] = TH_RST | TH_ACK;
    buf[14..16].copy_from_slice(&DEF_WINDOW.to_be_bytes());
    let ck = cksum_pseudo(our_ip.to_bits(), peer_ip.to_bits(), ip::PROTO_TCP, &buf, &[]);
    buf[16..18].copy_from_slice(&ck.to_be_bytes());
    ip::send(st, peer_ip, ip::PROTO_TCP, &buf);
}

/// 把一個段加進送出佇列，並前進 snd_nxt
fn enq(st: &mut Stack, ci: usize, flags: u8, data: &[u8]) -> bool {
    let Some(c) = st.tcp.conns[ci].as_mut() else { return false };
    if c.segq.len() >= SEGQ_MAX {
        log_w!("tcp 送出佇列滿");
        return false;
    }
    let mut alloc = data.len() as u32;
    if flags & TH_SYN != 0 {
        alloc += 1;
    }
    if flags & TH_FIN != 0 {
        alloc += 1;
    }
    let seg = Seg {
        flags,
        seq: c.snd_nxt,
        retried: 0,
        tx_ms: 0,
        data: data.to_vec(),
    };
    c.snd_nxt = c.snd_nxt.wrapping_add(alloc);
    c.segq.push(seg);
    true
}

/// 握手完成（之後的 data 才可以送）
fn handshaked_for_send(state: State, has_syn: bool) -> bool {
    has_syn
        || matches!(
            state,
            State::Established | State::FinWait1 | State::FinWait2 | State::LastAck | State::CloseWait
        )
}

/// 送出佇列中尚未發出的段
fn flush_unsent(st: &mut Stack, ci: usize) {
    let backlog: Vec<(usize, u8, u32, Vec<u8>)> = {
        let Some(c) = st.tcp.conns[ci].as_ref() else { return };
        c.segq
            .iter()
            .enumerate()
            .filter(|(_, s)| s.tx_ms == 0)
            .map(|(i, s)| {
                let seq = if s.flags & TH_SYN != 0 { c.iss } else { s.seq };
                (i, s.flags, seq, s.data.clone())
            })
            .collect()
    };
    for (i, flags, seq, data) in backlog {
        let cur_state = st.tcp.conns[ci].as_ref().unwrap().state;
        if !handshaked_for_send(cur_state, flags & TH_SYN != 0) {
            continue; // 握手完成後再送
        }
        send_out(st, ci, flags, seq, &data, Some(i));
    }
}

/// 把已全確認的段從佇列移除
fn dequeue_acked(st: &mut Stack, ci: usize) {
    loop {
        let drop_it = {
            let Some(c) = st.tcp.conns[ci].as_ref() else { return };
            c.segq
                .first()
                .map(|s| seq_le(c.seg_end(s), c.snd_una))
                .unwrap_or(false)
        };
        if !drop_it {
            return;
        }
        st.tcp.conns[ci].as_mut().unwrap().segq.remove(0);
    }
}

/* ---------- 對外 API ---------- */

/// 伺服器：監聽 port
pub fn listen(st: &mut Stack, port: u16, kind: AppKind) -> bool {
    st.tcp.listen(port, kind)
}

/// 主動連線（非同步）：先送 SYN；資料可以先行排隊
pub fn connect(st: &mut Stack, dst: Ipv4Addr, dport: u16, kind: AppKind) {
    // 找空的槽
    let Some(ci) = (0..CONNS_MAX).find(|i| st.tcp.conns[*i].is_none()) else {
        log_w!("tcp 沒空位");
        return;
    };
    st.tcp.ephemeral = if st.tcp.ephemeral < 61000 { st.tcp.ephemeral + 1 } else { 40000 };
    let iss = rand_isn();
    st.tcp.conns[ci] = Some(Tcb {
        state: State::SynSent,
        peer_ip: dst,
        peer_port: dport,
        lport: st.tcp.ephemeral,
        iss,
        snd_una: iss,
        snd_nxt: iss,
        rcv_nxt: 0,
        kind,
        segq: Vec::new(),
        opened_ms: now_ms(),
        app_closed: false,
    });
    enq(st, ci, TH_SYN, &[]);
    flush_unsent(st, ci);
    log_d!("tcp: 主動連線 {}:{}（iss={iss}）", dst, dport);
}

/// 送資料（回送進佇列的長度）
pub fn write(st: &mut Stack, ci: usize, data: &[u8]) -> usize {
    let pushed = {
        let Some(c) = st.tcp.conns.get_mut(ci).and_then(|c| c.as_mut()) else {
            return 0;
        };
        let allowed = matches!(
            c.state,
            State::Established | State::SynRcvd | State::SynSent | State::CloseWait
        );
        if !allowed || c.app_closed {
            return 0;
        }
        let mut sent = 0usize;
        while sent < data.len() {
            let end = (sent + MSS).min(data.len());
            let piece = &data[sent..end];
            if c.segq.len() >= SEGQ_MAX {
                log_w!("tcp 送出佇列滿，截斷");
                break;
            }
            let seg = Seg {
                flags: TH_ACK | TH_PSH,
                seq: c.snd_nxt,
                retried: 0,
                tx_ms: 0,
                data: piece.to_vec(),
            };
            c.snd_nxt = c.snd_nxt.wrapping_add(seg.data.len() as u32);
            c.segq.push(seg);
            sent = end;
        }
        sent
    }; // c 的借用到此結束
    if pushed > 0 {
        flush_unsent(st, ci);
    }
    pushed
}

/// 我這端要關（送 FIN）
pub fn close(st: &mut Stack, ci: usize) {
    let (was_est, was_cw, was_early) = {
        let Some(c) = st.tcp.conns[ci].as_mut() else { return };
        if c.app_closed {
            return;
        }
        c.app_closed = true;
        (c.state == State::Established,
         c.state == State::CloseWait,
         matches!(c.state, State::SynRcvd | State::SynSent))
    };
    if was_early {
        // 握手未完成：直接放棄
        st.tcp.conns[ci] = None;
        return;
    }
    if was_est {
        enq(st, ci, TH_FIN | TH_ACK, &[]);
        st.tcp.conns[ci].as_mut().unwrap().state = State::FinWait1;
    } else if was_cw {
        enq(st, ci, TH_FIN | TH_ACK, &[]);
        st.tcp.conns[ci].as_mut().unwrap().state = State::LastAck;
    }
    flush_unsent(st, ci);
}

/* ---------- 接收 ---------- */

/// 收到一個 TCP 段
pub fn receive(st: &mut Stack, src: Ipv4Addr, dst: Ipv4Addr, data: &[u8]) {
    let _ = dst;
    if data.len() < HDR_MIN {
        return;
    }
    let hl = ((data[12] >> 4) as usize) * 4;
    if hl < HDR_MIN || hl > data.len() {
        return;
    }

    /* 檢查和（偽標頭 + 整段；cksum 先清零） */
    let rx = u16::from_be_bytes([data[16], data[17]]);
    if rx != 0 {
        let mut tmp = data.to_vec();
        tmp[16..18].copy_from_slice(&[0, 0]);
        if cksum_pseudo(src.to_bits(), dst.to_bits(), ip::PROTO_TCP, &tmp, &[]) != rx {
            log_d!("tcp: 檢查和失敗，丟包");
            return;
        }
    }

    let sport = u16::from_be_bytes([data[0], data[1]]); // 對端 port
    let dport = u16::from_be_bytes([data[2], data[3]]); // 我們的 port
    let seg_seq = u32::from_be_bytes([data[4], data[5], data[6], data[7]]);
    let seg_ack = u32::from_be_bytes([data[8], data[9], data[10], data[11]]);
    let flags = data[13];
    let payload = &data[hl..];
    let has_syn = flags & TH_SYN != 0;
    let has_ack = flags & TH_ACK != 0;
    let has_fin = flags & TH_FIN != 0;
    let has_rst = flags & TH_RST != 0;

    log_d!(
        "tcp <<< {src}:{sport} -> :{dport} [{}] seq={} ack={} len={}",
        dbg_flags(flags),
        seg_seq,
        seg_ack,
        payload.len()
    );

    let ci = find_conn(st, src, sport, dport);

    /* 新連入的 SYN */
    if has_syn && !has_ack {
        if let Some(ci) = ci {
            // 已有連線：看是不是 retransmit 的 SYN
            let (is_retx_syn, seg_flags, seg_iss) = {
                let c = st.tcp.conns[ci].as_ref().unwrap();
                (
                    c.state == State::SynRcvd
                        && seg_seq + 1 == c.rcv_nxt
                        && c.segq.first().map(|s| s.flags & TH_SYN != 0).unwrap_or(false),
                    c.segq.first().map(|s| s.flags).unwrap_or(TH_SYN | TH_ACK),
                    c.iss,
                )
            };
            if is_retx_syn {
                // 立即重送我們的 SYN|ACK
                send_out(st, ci, seg_flags, seg_iss, &[], None);
            } else {
                send_pure_ack(st, ci);
            }
            return;
        }

        let Some(listener) = st.tcp.find_listener(dport) else {
            send_rst(st, st.nd.ip, src, dport, sport, seg_seq + payload.len() as u32 + 1);
            return;
        };
        let Some(new_ci) = (0..CONNS_MAX).find(|i| st.tcp.conns[*i].is_none()) else {
            return; // 沒空位
        };
        let iss = rand_isn();
        st.tcp.conns[new_ci] = Some(Tcb {
            state: State::SynRcvd,
            peer_ip: src,
            peer_port: sport,
            lport: dport,
            iss,
            snd_una: iss,
            snd_nxt: iss,
            rcv_nxt: seg_seq + 1,
            kind: listener.kind,
            segq: Vec::new(),
            opened_ms: now_ms(),
            app_closed: false,
        });
        enq(st, new_ci, TH_SYN | TH_ACK, &[]);
        flush_unsent(st, new_ci);
        log_d!("tcp: 新連線 SYN|ACK 完成 (iss={iss})");
        return;
    }

    let Some(ci) = ci else {
        log_d!("tcp: 無匹配連線（可能 TIME_WAIT），忽略");
        return;
    };

    if has_rst {
        log_d!("tcp: 收到 RST，中止連線");
        let kind = st.tcp.conns[ci].as_ref().unwrap().kind;
        apps::on_close(st, kind, ci);
        st.tcp.conns[ci] = None;
        return;
    }

    let state = st.tcp.conns[ci].as_ref().unwrap().state;
    if state == State::TimeWait {
        if has_fin {
            send_pure_ack(st, ci); // 對端重送 FIN，配合回覆
        }
        return;
    }

    /* ACK 推進 */
    if has_ack {
        process_ack(st, ci, seg_ack);
    }

    /* 狀態機轉移 */
    let state = st.tcp.conns[ci].as_ref().unwrap().state;
    match state {
        State::SynRcvd => {
            // 三方握手完成
            st.tcp.conns[ci].as_mut().unwrap().state = State::Established;
            let kind = st.tcp.conns[ci].as_ref().unwrap().kind;
            let (peer_ip, peer_port, lport) = {
                let c = st.tcp.conns[ci].as_ref().unwrap();
                (c.peer_ip, c.peer_port, c.lport)
            };
            apps::on_accept(st, kind, ci, peer_ip, peer_port, lport);
            flush_unsent(st, ci);
        }
        State::SynSent => {
            // 主動開啟收到 SYN|ACK
            if has_syn && has_ack {
                {
                    let c = st.tcp.conns[ci].as_mut().unwrap();
                    c.rcv_nxt = seg_seq + 1;
                    c.state = State::Established;
                }
                send_pure_ack(st, ci);
                let kind = st.tcp.conns[ci].as_ref().unwrap().kind;
                let (peer_ip, peer_port, lport) = {
                    let c = st.tcp.conns[ci].as_ref().unwrap();
                    (c.peer_ip, c.peer_port, c.lport)
                };
                apps::on_accept(st, kind, ci, peer_ip, peer_port, lport);
                flush_unsent(st, ci);
            }
            return;
        }
        State::FinWait1 => {
            // 我們的 FIN 已確認？
            if st.tcp.conns[ci].as_ref().unwrap().segq.is_empty() {
                st.tcp.conns[ci].as_mut().unwrap().state = State::FinWait2;
            }
        }
        State::LastAck => {
            // 我們的 FIN 已確認 -> 收工
            if st.tcp.conns[ci].as_ref().unwrap().segq.is_empty() {
                st.tcp.conns[ci] = None;
            }
            return;
        }
        _ => {}
    }

    let state = st.tcp.conns[ci].as_ref().unwrap().state;
    if state == State::SynRcvd || state == State::SynSent {
        return; // 握手還沒完成，資料下次再說
    }

    /* 資料（按序；亂序丟包寄望對端 RTO 重送） */
    if !payload.is_empty() {
        let rcv_nxt = st.tcp.conns[ci].as_ref().unwrap().rcv_nxt;
        let kind = st.tcp.conns[ci].as_ref().unwrap().kind;
        if seg_seq == rcv_nxt {
            st.tcp.conns[ci].as_mut().unwrap().rcv_nxt = rcv_nxt.wrapping_add(payload.len() as u32);
            let data2 = payload.to_vec();
            apps::on_data(st, kind, ci, &data2);
        } else if seq_lt(seg_seq, rcv_nxt) && seq_lt(rcv_nxt, seg_seq + payload.len() as u32) {
            // 部分重疊：略掉已收過的開頭
            let off = rcv_nxt.wrapping_sub(seg_seq) as usize;
            st.tcp.conns[ci].as_mut().unwrap().rcv_nxt = rcv_nxt.wrapping_add((payload.len() - off) as u32);
            let tail = payload[off..].to_vec();
            apps::on_data(st, kind, ci, &tail);
        } else if seq_lt(rcv_nxt, seg_seq) {
            log_d!("tcp: 亂序丟包 (rcv_nxt={rcv_nxt} got={seg_seq})");
        }
        send_pure_ack(st, ci);
    }

    if st.tcp.conns[ci].as_ref().unwrap().state == State::TimeWait {
        return;
    }

    /* FIN */
    if has_fin {
        let fin_seq = seg_seq + payload.len() as u32;
        let rcv_nxt = st.tcp.conns[ci].as_ref().unwrap().rcv_nxt;
        let accepted = fin_seq + 1 == rcv_nxt || (payload.is_empty() && fin_seq == rcv_nxt);
        if accepted {
            st.tcp.conns[ci].as_mut().unwrap().rcv_nxt = fin_seq + 1;
            send_pure_ack(st, ci);
            let state = st.tcp.conns[ci].as_ref().unwrap().state;
            match state {
                State::Established => {
                    st.tcp.conns[ci].as_mut().unwrap().state = State::CloseWait;
                    let kind = st.tcp.conns[ci].as_ref().unwrap().kind;
                    apps::on_close(st, kind, ci);
                }
                State::FinWait1 | State::FinWait2 => {
                    {
                        let c = st.tcp.conns[ci].as_mut().unwrap();
                        c.state = State::TimeWait;
                        c.opened_ms = now_ms();
                    }
                    let kind = st.tcp.conns[ci].as_ref().unwrap().kind;
                    apps::on_close(st, kind, ci);
                }
                _ => {}
            }
        } else {
            send_pure_ack(st, ci); // 亂序 FIN：請對端再送
        }
        return;
    }
}

/* ---------- 工具 ---------- */

fn find_conn(st: &Stack, src: Ipv4Addr, sport: u16, dport: u16) -> Option<usize> {
    st.tcp.conns.iter().position(|c| {
        c.as_ref()
            .is_some_and(|c| c.peer_ip == src && c.peer_port == sport && c.lport == dport)
    })
}

fn process_ack(st: &mut Stack, ci: usize, ack: u32) {
    let advance = {
        let c = st.tcp.conns[ci].as_ref().unwrap();
        seq_lt(c.snd_una, ack) && seq_le(ack, c.snd_nxt)
    };
    if !advance {
        return;
    }
    st.tcp.conns[ci].as_mut().unwrap().snd_una = ack;
    dequeue_acked(st, ci);
}

/* ---------- tick：重傳 + 回收 ---------- */

pub fn tick(st: &mut Stack) {
    for ci in 0..CONNS_MAX {
        let Some((state, opened_ms)) = st.tcp.conns[ci].as_ref().map(|c| (c.state, c.opened_ms)) else {
            continue;
        };
        if state == State::TimeWait {
            if now_ms().saturating_sub(opened_ms) > TIME_WAIT_MS {
                log_d!("tcp: TIME_WAIT 到期，回收");
                st.tcp.conns[ci] = None;
            }
            continue;
        }
        let Some(head) = st.tcp.conns[ci]
            .as_ref()
            .and_then(|c| c.segq.first().map(|s| (s.tx_ms, s.retried)))
        else {
            continue;
        };
        let (tx, retried) = head;
        let rto = (INIT_RTO_MS) << (retried.min(5) as u64);
        if tx == 0 {
            continue; // 未送出過（等握手）
        }
        if now_ms().saturating_sub(tx) < rto {
            continue;
        }
        if retried >= MAX_RETRY {
            log_w!("tcp: 重傳耗盡（state={}）中止", state.name());
            let kind = st.tcp.conns[ci].as_ref().unwrap().kind;
            apps::on_close(st, kind, ci);
            st.tcp.conns[ci] = None;
            continue;
        }

        // 重送佇列開頭
        let (flags, seq, data) = {
            let c = st.tcp.conns[ci].as_ref().unwrap();
            let s = c.segq.first().unwrap();
            (
                s.flags,
                if s.flags & TH_SYN != 0 { c.iss } else { s.seq },
                s.data.clone(),
            )
        };
        {
            let c = st.tcp.conns[ci].as_mut().unwrap();
            let s = c.segq.first_mut().unwrap();
            s.retried += 1;
            s.tx_ms = now_ms();
            log_d!("tcp: RTO 到期，重送 seq={seq}（第 {} 次）", s.retried);
        }
        let our_ip = st.nd.ip;
        let buf = {
            let s = snap(st, ci).unwrap();
            build_segment(our_ip, s, flags, seq, &data)
        };
        let dst = st.tcp.conns[ci].as_ref().unwrap().peer_ip;
        log_d!(
            "tcp >>> (RTO) [{}] seq={} len={}",
            dbg_flags(flags),
            seq,
            data.len()
        );
        ip::send(st, dst, ip::PROTO_TCP, &buf);
    }
}
