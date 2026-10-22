//! apps — 建構在自製 TCP 之上的應用層：Echo / 迷你 HTTP / 主動 client 示範
//! callback 收 `(st, ci)`；需要對 TCP/對連線操作再呼叫 tcp::write/close。
use std::net::Ipv4Addr;

use crate::tcp;
use crate::stack::Stack;
use crate::{log_i, log_w};

#[derive(Clone, Copy, PartialEq, Eq, Debug)]
pub enum AppKind {
    Echo,
    Http,
    Client,
}

/* ---------------- listener 註冊 ---------------- */

pub fn listen_all(
    st: &mut Stack,
    echo_on: bool,
    echo_port: u16,
    http_on: bool,
    http_port: u16,
) {
    if echo_on && !tcp::listen(st, echo_port, AppKind::Echo) {
        log_w!("echo listen 失敗");
    }
    if http_on && !tcp::listen(st, http_port, AppKind::Http) {
        log_w!("http listen 失敗");
    }
}

pub fn connect_client(st: &mut Stack, dst: Ipv4Addr, dst_port: u16) {
    tcp::connect(st, dst, dst_port, AppKind::Client);
    log_i!("client: 呼出連線（SYN 已送）");
}

/* ---------------- TCP 事件分發 ---------------- */

pub fn on_accept(st: &mut Stack, kind: AppKind, ci: usize, peer_ip: Ipv4Addr, peer_port: u16, lport: u16) {
    match kind {
        AppKind::Echo => log_i!("echo: 新連線 {peer_ip}:{peer_port} -> :{lport}"),
        AppKind::Http => log_i!("http: 新連線 {peer_ip}:{peer_port} -> :{lport}"),
        AppKind::Client => {
            log_i!("client: 已連線到 {peer_ip}:{peer_port}（本端 :{lport}）");
            tcp::write(st, ci, b"PING\n");
        }
    }
}

pub fn on_data(st: &mut Stack, kind: AppKind, ci: usize, data: &[u8]) {
    match kind {
        AppKind::Echo => {
            // echo：收到什麼就原樣送回
            tcp::write(st, ci, data);
        }
        AppKind::Http => {
            // 收到請求（示範版不解析）就回個固定網頁
            if data.windows(4).any(|w| w == b"HTTP") {
                let body = "<h1>hello from tcpip0rust</h1>\n";
                let resp = format!(
                    "HTTP/1.0 200 OK\r\nContent-Type: text/html; charset=utf-8\r\n\
                     Content-Length: {}\r\nConnection: close\r\n\r\n{}",
                    body.len(),
                    body
                );
                tcp::write(st, ci, resp.as_bytes());
                tcp::close(st, ci);
                log_i!("http: 200 OK 已回");
            }
        }
        AppKind::Client => {
            eprintln!("client 收到 {} bytes: {}", data.len(), String::from_utf8_lossy(data));
            tcp::close(st, ci);
        }
    }
}

pub fn on_close(st: &mut Stack, kind: AppKind, ci: usize) {
    match kind {
        AppKind::Echo => {
            log_i!("echo: 對端關閉，跟著關閉");
            tcp::close(st, ci);
        }
        AppKind::Http => {
            tcp::close(st, ci);
        }
        AppKind::Client => {
            tcp::close(st, ci);
            log_i!("client: 完成");
        }
    }
}
