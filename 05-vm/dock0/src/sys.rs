//! 對 libc 的小型封裝
use std::ffi::CString;
use std::os::raw::{c_int, c_ulong, c_void};
use std::path::Path;
use std::{fs, io, process, ptr};

pub fn die(msg: &str) -> ! {
    eprintln!("dock0: {msg}");
    process::exit(1);
}

pub fn cs(s: &str) -> CString {
    CString::new(s).unwrap_or_else(|_| die("字串中含有 NUL 字元"))
}

pub fn errno() -> i32 {
    io::Error::last_os_error().raw_os_error().unwrap_or(0)
}

/// 把 libc 的負數回傳值轉成帶上下文的錯誤
pub fn check(ret: i64, what: &str) -> io::Result<()> {
    if ret < 0 {
        let e = io::Error::last_os_error();
        Err(io::Error::new(e.kind(), format!("{what}: {e}")))
    } else {
        Ok(())
    }
}

pub fn mount(src: &str, dst: &str, fstype: &str, flags: c_ulong, data: &str) -> io::Result<()> {
    let (s, d, t, o) = (cs(src), cs(dst), cs(fstype), cs(data));
    let datap: *const c_void = if data.is_empty() { ptr::null() } else { o.as_ptr() as *const c_void };
    let ret = unsafe { libc::mount(s.as_ptr(), d.as_ptr(), t.as_ptr(), flags, datap) };
    check(ret as i64, &format!("mount {dst}"))
}

pub fn bind(src: &str, dst: &str) -> io::Result<()> {
    mount(src, dst, "", libc::MS_BIND | libc::MS_REC, "")
}

/// 取得掛載點目前已有的 nosuid/nodev/noexec 等旗標。
/// 在 user namespace 內 remount 時必須保留這些「被鎖定」的旗標，否則會 EPERM。
fn inherited_flags(path: &str) -> c_ulong {
    let p = cs(path);
    let mut st: libc::statvfs = unsafe { std::mem::zeroed() };
    if unsafe { libc::statvfs(p.as_ptr(), &mut st) } < 0 {
        return 0;
    }
    let f = st.f_flag as c_ulong;
    let mut r = 0;
    if f & 2 != 0 { r |= libc::MS_NOSUID; }
    if f & 4 != 0 { r |= libc::MS_NODEV; }
    if f & 8 != 0 { r |= libc::MS_NOEXEC; }
    if f & 1024 != 0 { r |= libc::MS_NOATIME; }
    if f & 2048 != 0 { r |= libc::MS_NODIRATIME; }
    r
}

/// 把已經 bind 好的掛載點改成唯讀
pub fn make_ro(path: &str) -> io::Result<()> {
    let flags = libc::MS_REMOUNT | libc::MS_BIND | libc::MS_RDONLY | inherited_flags(path);
    mount("none", path, "", flags, "")
}

/// 建立空檔案（含父目錄），作為 bind mount 的目標
pub fn touch(path: &str) -> io::Result<()> {
    if let Some(p) = Path::new(path).parent() {
        fs::create_dir_all(p)?;
    }
    fs::OpenOptions::new().create(true).write(true).truncate(false).open(path).map(|_| ())
}

pub fn write_all(fd: c_int, mut buf: &[u8]) -> bool {
    while !buf.is_empty() {
        let n = unsafe { libc::write(fd, buf.as_ptr() as *const c_void, buf.len()) };
        if n < 0 {
            if errno() == libc::EINTR { continue; }
            return false;
        }
        buf = &buf[n as usize..];
    }
    true
}

pub fn exit_code(st: i32) -> i32 {
    if libc::WIFEXITED(st) {
        libc::WEXITSTATUS(st)
    } else if libc::WIFSIGNALED(st) {
        128 + libc::WTERMSIG(st)
    } else {
        1
    }
}

pub fn wait_pid(pid: i32) -> i32 {
    loop {
        let mut st = 0;
        let r = unsafe { libc::waitpid(pid, &mut st, 0) };
        if r < 0 {
            if errno() == libc::EINTR { continue; }
            return 1;
        }
        return exit_code(st);
    }
}

pub fn on_signal(sig: c_int, f: extern "C" fn(c_int), flags: c_int) {
    unsafe {
        let mut sa: libc::sigaction = std::mem::zeroed();
        sa.sa_sigaction = f as usize;
        sa.sa_flags = flags;
        libc::sigemptyset(&mut sa.sa_mask);
        libc::sigaction(sig, &sa, ptr::null_mut());
    }
}
