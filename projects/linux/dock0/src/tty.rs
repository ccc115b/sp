//! 偽終端機（pty）：配置、掛到子行程、在父行程與容器之間轉送資料
use crate::sys::{errno, on_signal, wait_pid, write_all};
use std::ffi::CStr;
use std::io;
use std::sync::atomic::{AtomicBool, Ordering};

pub struct Pty {
    pub master: i32,
    pub slave: i32,
    pub path: String,
}

/// 在主機端建立 pty，並事先開啟 slave。
/// 由父行程持有 slave 直到 fork 完成，可避免 master 在 slave 開啟前就報 HUP。
pub fn open_pty() -> io::Result<Pty> {
    unsafe {
        let m = libc::posix_openpt(libc::O_RDWR | libc::O_NOCTTY | libc::O_CLOEXEC);
        if m < 0 {
            return Err(io::Error::last_os_error());
        }
        if libc::grantpt(m) < 0 || libc::unlockpt(m) < 0 {
            return Err(io::Error::last_os_error());
        }
        let mut buf = [0 as libc::c_char; 128];
        if libc::ptsname_r(m, buf.as_mut_ptr(), buf.len()) != 0 {
            return Err(io::Error::last_os_error());
        }
        let s = libc::open(buf.as_ptr(), libc::O_RDWR | libc::O_NOCTTY);
        if s < 0 {
            return Err(io::Error::last_os_error());
        }
        let path = CStr::from_ptr(buf.as_ptr()).to_string_lossy().into_owned();
        Ok(Pty { master: m, slave: s, path })
    }
}

/// 在子行程中：成為 session leader，把 slave 設為控制終端並接到 stdin/out/err
pub fn attach(slave: i32) {
    unsafe {
        libc::setsid();
        libc::ioctl(slave, libc::TIOCSCTTY, 0);
        for fd in 0..3 {
            libc::dup2(slave, fd);
        }
        if slave > 2 {
            libc::close(slave);
        }
    }
}

static WINCH: AtomicBool = AtomicBool::new(false);
extern "C" fn on_winch(_: i32) {
    WINCH.store(true, Ordering::Relaxed);
}

fn copy_winsize(master: i32) {
    unsafe {
        let mut ws: libc::winsize = std::mem::zeroed();
        if libc::ioctl(0, libc::TIOCGWINSZ, &mut ws) == 0 {
            libc::ioctl(master, libc::TIOCSWINSZ, &ws);
        }
    }
}

/// 把本機終端切成 raw 模式，雙向轉送 stdin <-> pty master，直到容器端關閉。
/// 回傳子行程的 exit code。
pub fn relay(master: i32, child: i32) -> i32 {
    let mut saved: libc::termios = unsafe { std::mem::zeroed() };
    unsafe { libc::tcgetattr(0, &mut saved) };
    let mut raw = saved;
    unsafe {
        libc::cfmakeraw(&mut raw);
        libc::tcsetattr(0, libc::TCSANOW, &raw);
    }
    on_signal(libc::SIGWINCH, on_winch, 0); // 不加 SA_RESTART，讓 poll 被喚醒
    copy_winsize(master);

    let mut fds = [
        libc::pollfd { fd: 0, events: libc::POLLIN, revents: 0 },
        libc::pollfd { fd: master, events: libc::POLLIN, revents: 0 },
    ];
    let mut buf = [0u8; 4096];
    loop {
        if WINCH.swap(false, Ordering::Relaxed) {
            copy_winsize(master);
        }
        let r = unsafe { libc::poll(fds.as_mut_ptr(), 2, -1) };
        if r < 0 {
            if errno() == libc::EINTR { continue; }
            break;
        }
        if fds[0].revents & (libc::POLLIN | libc::POLLHUP) != 0 {
            let n = unsafe { libc::read(0, buf.as_mut_ptr() as *mut _, buf.len()) };
            if n > 0 {
                write_all(master, &buf[..n as usize]);
            } else {
                fds[0].fd = -1; // stdin 結束，不再監看
            }
        }
        if fds[1].revents & libc::POLLIN != 0 {
            let n = unsafe { libc::read(master, buf.as_mut_ptr() as *mut _, buf.len()) };
            if n <= 0 { break; }
            write_all(1, &buf[..n as usize]);
        } else if fds[1].revents & (libc::POLLHUP | libc::POLLERR) != 0 {
            break;
        }
    }
    unsafe { libc::tcsetattr(0, libc::TCSANOW, &saved) };
    wait_pid(child)
}
