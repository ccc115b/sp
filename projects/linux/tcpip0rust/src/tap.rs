//! TAP 裝置 (/dev/net/tun)：拿到的是含 Ethernet 標頭的 L2 訊框
use std::fs::File;
use std::net::Ipv4Addr;
use std::os::fd::AsRawFd;

use crate::{log_e, log_i};

// linux/if_tun.h
const TUNSETIFF: libc_ulong = 0x4004_54ca; // _IOW('T', 202, int)：所有 Linux 架構同值
const IFF_TAP: libc_int = 0x0002;
const IFF_NO_PI: libc_int = 0x1000;

#[allow(non_camel_case_types)]
type libc_ulong = std::os::raw::c_ulong;
#[allow(non_camel_case_types)]
type libc_int = std::os::raw::c_int;
#[allow(non_camel_case_types)]

#[repr(C)]
struct IfReq {
    // ifr_name 16 bytes + union(只需要前段的 ifr_flags: u16)
    bytes: [u8; 64],
}

extern "C" {
    fn ioctl(fd: libc_int, request: libc_ulong, ...) -> libc_int;
    fn fcntl(fd: libc_int, cmd: libc_int, arg: libc_int) -> libc_int;
}

const F_SETFL: libc_int = 4;
const O_NONBLOCK: libc_int = 0o4000;

pub struct Tap {
    file: File,
    #[allow(dead_code)]
    name: String,
}

impl Tap {
    /// 開啟 TAP：IFF_TAP (L2) + IFF_NO_PI (去掉 4-byte 前置，直接吃原始 Ethernet 幀)
    pub fn open(name: &str) -> Option<Tap> {
        let file = match File::options().read(true).write(true).open("/dev/net/tun") {
            Ok(f) => f,
            Err(e) => {
                log_e!(
                    "open /dev/net/tun 失敗: {e}（容器需要 --privileged 或 --device /dev/net/tun + NET_ADMIN）"
                );
                return None;
            }
        };

        let mut ifr = IfReq { bytes: [0u8; 64] };
        let ifname = name.as_bytes();
        if ifname.len() >= 16 {
            log_e!("tap name 太長");
            return None;
        }
        ifr.bytes[..ifname.len()].copy_from_slice(ifname);
        let flags = IFF_TAP | IFF_NO_PI;
        ifr.bytes[16] = (flags & 0xff) as u8;
        ifr.bytes[17] = (flags >> 8) as u8;

        unsafe {
            if ioctl(file.as_raw_fd(), TUNSETIFF, &mut ifr as *mut IfReq) < 0 {
                let err = std::io::Error::last_os_error();
                log_e!("ioctl TUNSETIFF {name} 失敗: {err}");
                return None;
            }
            // 非阻塞：read 抽乾佇列空掉時回 EAGAIN，不卡死
            fcntl(file.as_raw_fd(), F_SETFL, O_NONBLOCK);
        }

        log_i!("tap opened: {name}");
        Some(Tap { file, name: name.into() })
    }

    /// 讀一個 Ethernet 幀；非阻塞下佇列空回 None
    pub fn read_frame(&self, buf: &mut [u8]) -> Option<usize> {
        use std::io::Read;
        match (&self.file).read(buf) {
            Ok(0) | Err(_) => None, // Err 含 EAGAIN
            Ok(n) => Some(n),
        }
    }

    pub fn write_frame(&self, mut buf: &[u8]) {
        use std::io::Write;
        while !buf.is_empty() {
            match (&self.file).write(buf) {
                Ok(0) => break,
                Ok(n) => buf = &buf[n..],
                Err(e) if e.raw_os_error() == Some(11) => continue, // EAGAIN 佇列滿就重試
                Err(_) => break,
            }
        }
    }
}

/// IP 字串 <-> Ipv4Addr
#[allow(dead_code)]
pub fn parse_ipv4(s: &str) -> Option<Ipv4Addr> {
    s.parse::<Ipv4Addr>().ok()
}
