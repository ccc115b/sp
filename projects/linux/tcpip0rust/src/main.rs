//! main.rs — 事件迴圈 + 參數解析
//! 架構：reader thread 阻塞讀 TAP 幀丟進 channel；
//!       主執行緒 recv_timeout 兼夾 timer，每 >=50ms 跑 tick（ARP + TCP 重傳）。
mod apps;
mod arp;
mod ethernet;
mod icmp;
mod ip;
mod netdev;
mod stack;
mod tap;
mod tcp;
mod udp;
mod utils;

use std::net::Ipv4Addr;
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::mpsc;
use std::sync::Arc;
use std::time::Duration;

static G_STOP: AtomicBool = AtomicBool::new(false);
static G_DUMP: AtomicBool = AtomicBool::new(false);

extern "C" fn on_sigint(_: std::os::raw::c_int) {
    G_STOP.store(true, Ordering::SeqCst);
}
extern "C" fn on_sigusr1(_: std::os::raw::c_int) {
    G_DUMP.store(true, Ordering::SeqCst);
}

unsafe fn install_signal_handlers() {
    extern "C" {
        fn signal(sig: std::os::raw::c_int, handler: usize) -> usize;
    }
    signal(2, on_sigint as *const () as usize); // SIGINT
    signal(15, on_sigint as *const () as usize); // SIGTERM
    signal(10, on_sigusr1 as *const () as usize); // SIGUSR1 -> dump 狀態
}

struct Args {
    tap: String,
    ip: Ipv4Addr,
    mask: Ipv4Addr,
    echo_on: bool,
    http_on: bool,
    echo_port: u16,
    http_port: u16,
    connect: Option<(Ipv4Addr, u16)>,
}

fn parse_args(argv: &[String]) -> Option<Args> {
    let mut a = Args {
        tap: "tap0".into(),
        ip: "10.0.0.2".parse().unwrap(),
        mask: "255.255.255.0".parse().unwrap(),
        echo_on: true,
        http_on: false,
        echo_port: 9001,
        http_port: 8080,
        connect: None,
    };
    let mut i = 0;
    while i < argv.len() {
        let arg = argv[i].as_str();
        match arg {
            "--tap" | "--ip" | "--mask" | "--mask?" => {
                if i + 1 >= argv.len() {
                    return None;
                }
                match arg {
                    "--tap" => a.tap = argv[i + 1].clone(),
                    "--ip" => a.ip = argv[i + 1].parse().ok()?,
                    _ => a.mask = argv[i + 1].parse().ok()?,
                }
                i += 2;
            }
            "--no-echo" => {
                a.echo_on = false;
                i += 1;
            }
            "--http" => {
                a.http_on = true;
                i += 1;
            }
            "--echo-port" | "--http-port" => {
                if i + 1 >= argv.len() {
                    return None;
                }
                let v: u16 = argv[i + 1].parse().ok()?;
                if arg == "--echo-port" {
                    a.echo_port = v;
                } else {
                    a.http_port = v;
                }
                i += 2;
            }
            _ if arg.starts_with("--connect=") => {
                let s = &arg["--connect=".len()..];
                let (addr, port) = s.split_once(':')?;
                a.connect = Some((addr.parse().ok()?, port.parse().ok()?));
                i += 1;
            }
            _ => {
                eprintln!(
                    "usage: {} [--tap tap0] [--ip 10.0.0.2] [--mask 255.255.255.0]\n            [--no-echo] [--http] [--connect=ip:port] [--echo-port N] [--http-port N]",
                    argv.first().map(|s| s.as_str()).unwrap_or("tcpip0rust")
                );
                return None;
            }
        }
    }
    Some(a)
}

fn main() {
    log_i!("tcpip0rust starting...");
    let args = match parse_args(&std::env::args().collect::<Vec<_>>()[1..]) {
        Some(a) => a,
        None => std::process::exit(1),
    };
    unsafe { install_signal_handlers() }

    let Some(nd) = netdev::NetDev::new(&args.tap, args.ip, args.mask) else {
        log_e!("netdev 初始化失敗");
        std::process::exit(1);
    };

    // reader thread：把 TAP 幀丟 channel
    let (tx, rx) = mpsc::channel::<Vec<u8>>();
    let tap = Arc::clone(&nd.tap);
    std::thread::Builder::new()
        .name("tap-reader".into())
        .spawn(move || {
            let mut buf = vec![0u8; 2048];
            while !G_STOP.load(Ordering::SeqCst) {
                match tap.read_frame(&mut buf) {
                    Some(n) => {
                        if tx.send(buf[..n].to_vec()).is_err() {
                            break;
                        }
                    }
                    None => std::thread::sleep(Duration::from_millis(2)),
                }
            }
        })
        .unwrap();

    let mut stack = stack::Stack::new(nd);

    apps::listen_all(&mut stack, args.echo_on, args.echo_port, args.http_on, args.http_port);
    if let Some((dst, port)) = args.connect {
        apps::connect_client(&mut stack, dst, port);
    }

    let mut last_tick = utils::now_ms();
    loop {
        if G_STOP.load(Ordering::SeqCst) {
            break;
        }
        if G_DUMP.swap(false, Ordering::SeqCst) {
            stack.arp.dump();
        }
        match rx.recv_timeout(Duration::from_millis(20)) {
            Ok(frame) => ethernet::receive(&mut stack, &frame),
            Err(mpsc::RecvTimeoutError::Timeout) => {}
            Err(mpsc::RecvTimeoutError::Disconnected) => break,
        }
        let now = utils::now_ms();
        if now - last_tick >= 50 {
            last_tick = now;
            stack.tick();
        }
    }

    log_i!("tcpip0rust 停止.");
}
