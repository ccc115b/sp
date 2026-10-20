//! 容器的建立（run）與進入（exec）
use crate::state::{self, Meta};
use crate::sys::*;
use crate::{sec, tty};
use std::os::fd::AsRawFd;
use std::os::unix::process::CommandExt;
use std::path::{Path, PathBuf};
use std::process::{self, Command};
use std::sync::atomic::{AtomicI32, Ordering};
use std::{env, fs, io};

pub struct Opts {
    pub rootfs: String,
    pub cmd: Vec<String>,
    pub host: String,
    pub name: Option<String>,
    pub mem_mb: Option<u64>,
    pub pids: Option<u64>,
    pub cpus: Option<f64>,
    pub share_net: bool,
    pub tty: bool,
    pub detach: bool,
    pub env: Vec<String>,
    pub workdir: String,
    pub volumes: Vec<(String, String, bool)>,
    pub no_seccomp: bool,
    pub no_overlay: bool,
}

// ---------- 訊號轉送 ----------

static CHILD: AtomicI32 = AtomicI32::new(0);

extern "C" fn forward(sig: i32) {
    let c = CHILD.load(Ordering::Relaxed);
    if c > 0 {
        unsafe { libc::kill(c, sig) };
    }
}

fn install_forwarders(child: i32, sigs: &[i32]) {
    CHILD.store(child, Ordering::Relaxed);
    for s in sigs {
        on_signal(*s, forward, libc::SA_RESTART);
    }
}

const HOST_SIGS: [i32; 4] = [libc::SIGINT, libc::SIGTERM, libc::SIGHUP, libc::SIGQUIT];

// ---------- 環境變數 ----------

fn build_env(host: Option<&str>, extra: &[String]) -> Vec<(String, String)> {
    let mut v: Vec<(String, String)> = vec![
        ("PATH".into(), "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin".into()),
        ("HOME".into(), "/root".into()),
        ("TERM".into(), env::var("TERM").unwrap_or_else(|_| "xterm".into())),
    ];
    if let Some(h) = host.filter(|h| !h.is_empty()) {
        v.push(("HOSTNAME".into(), h.into()));
    }
    for e in extra {
        if let Some((k, val)) = e.split_once('=') {
            v.retain(|(kk, _)| kk != k);
            v.push((k.into(), val.into()));
        }
    }
    v
}

fn exec_cmd(cmd: &[String], env: Vec<(String, String)>, workdir: &str) -> ! {
    let err = Command::new(&cmd[0])
        .args(&cmd[1..])
        .env_clear()
        .envs(env)
        .current_dir(workdir)
        .exec(); // 成功就不會返回
    eprintln!("dock0: 無法執行 {}：{err}", cmd[0]);
    process::exit(127);
}

// ---------- cgroup v2（盡力而為） ----------

/// 只寫入「已存在」的檔案；在非 cgroupfs（例如 cgroup v1 的 tmpfs）上不會誤建檔案
fn cg_write(path: &Path, val: &str) -> io::Result<()> {
    use std::io::Write;
    fs::OpenOptions::new().write(true).open(path)?.write_all(val.as_bytes())
}

fn setup_cgroup(id: &str, pid: i32, o: &Opts) -> Option<PathBuf> {
    if o.mem_mb.is_none() && o.pids.is_none() && o.cpus.is_none() {
        return None;
    }
    let root = PathBuf::from("/sys/fs/cgroup");
    if !root.join("cgroup.controllers").exists() {
        eprintln!("dock0: 警告：此系統不是 cgroup v2，略過資源限制");
        return None;
    }
    let _ = cg_write(&root.join("cgroup.subtree_control"), "+memory +pids +cpu");
    let dir = root.join(format!("dock0-{id}"));
    if let Err(e) = fs::create_dir(&dir) {
        eprintln!("dock0: 警告：無法建立 cgroup（{e}），略過資源限制（rootless 需要 cgroup 委派）");
        return None;
    }
    let mut limits: Vec<(&str, String)> = vec![];
    if let Some(mb) = o.mem_mb {
        limits.push(("memory.max", (mb * 1024 * 1024).to_string()));
        limits.push(("memory.swap.max", "0".into()));
    }
    if let Some(n) = o.pids {
        limits.push(("pids.max", n.to_string()));
    }
    if let Some(c) = o.cpus {
        limits.push(("cpu.max", format!("{} 100000", (c * 100000.0) as u64)));
    }
    for (f, v) in limits {
        if let Err(e) = cg_write(&dir.join(f), &v) {
            eprintln!("dock0: 警告：無法設定 {f}：{e}");
        }
    }
    if let Err(e) = cg_write(&dir.join("cgroup.procs"), &pid.to_string()) {
        eprintln!("dock0: 警告：無法加入 cgroup：{e}");
    }
    Some(dir)
}

// ---------- 容器內：建立 rootfs ----------

fn setup_root(o: &Opts, dir: &Path, rootfs: &str, console: Option<&str>) -> io::Result<()> {
    // 不讓任何掛載事件傳播回主機
    mount("none", "/", "", libc::MS_REC | libc::MS_PRIVATE, "")?;

    // 1) 新的根目錄：overlayfs（lower = 唯讀 image，upper = 容器寫入層）
    let root: String = if o.no_overlay {
        bind(rootfs, rootfs)?;
        rootfs.to_string()
    } else {
        let (u, w, m) = (dir.join("upper"), dir.join("work"), dir.join("merged"));
        for d in [&u, &w, &m] {
            fs::create_dir_all(d)?;
        }
        let m = m.to_string_lossy().into_owned();
        let opts = format!("lowerdir={rootfs},upperdir={},workdir={}", u.display(), w.display());
        mount("overlay", &m, "overlay", 0, &opts)
            .map_err(|e| io::Error::new(e.kind(), format!("{e}（需要 Linux 5.11+，且 {} 要在支援 xattr 的檔案系統上）", dir.display())))?;
        m
    };
    let p = |s: &str| format!("{root}{s}");
    for d in ["/proc", "/sys", "/dev", "/tmp", "/etc"] {
        let _ = fs::create_dir_all(p(d));
    }

    // 2) /proc、/sys、/dev
    let sec_flags = libc::MS_NOSUID | libc::MS_NODEV | libc::MS_NOEXEC;
    mount("proc", &p("/proc"), "proc", sec_flags, "")?;
    let _ = mount("sysfs", &p("/sys"), "sysfs", sec_flags | libc::MS_RDONLY, ""); // --net 時會失敗，無妨
    mount("tmpfs", &p("/dev"), "tmpfs", libc::MS_NOSUID | libc::MS_STRICTATIME, "mode=755,size=65536k")?;

    // user namespace 內不能 mknod，所以把主機的裝置檔 bind 進來
    for n in ["null", "zero", "full", "random", "urandom", "tty"] {
        let t = p(&format!("/dev/{n}"));
        touch(&t)?;
        mount(&format!("/dev/{n}"), &t, "", libc::MS_BIND, "")?;
    }
    let _ = fs::create_dir_all(p("/dev/pts"));
    let _ = mount("devpts", &p("/dev/pts"), "devpts", libc::MS_NOSUID | libc::MS_NOEXEC, "newinstance,ptmxmode=0666,mode=0620");
    let _ = fs::create_dir_all(p("/dev/shm"));
    let _ = mount("tmpfs", &p("/dev/shm"), "tmpfs", sec_flags, "mode=1777,size=65536k");
    for (link, target) in [
        ("/dev/ptmx", "pts/ptmx"), ("/dev/fd", "/proc/self/fd"), ("/dev/stdin", "/proc/self/fd/0"),
        ("/dev/stdout", "/proc/self/fd/1"), ("/dev/stderr", "/proc/self/fd/2"),
    ] {
        let _ = std::os::unix::fs::symlink(target, p(link));
    }
    if let Some(c) = console {
        let t = p("/dev/console");
        if touch(&t).is_ok() {
            let _ = mount(c, &t, "", libc::MS_BIND, "");
        }
    }
    mount("tmpfs", &p("/tmp"), "tmpfs", libc::MS_NOSUID | libc::MS_NODEV, "mode=1777")?;
    if o.share_net {
        let t = p("/etc/resolv.conf");
        if touch(&t).is_ok() {
            let _ = bind("/etc/resolv.conf", &t);
        }
    }

    // 3) 使用者指定的 volume
    for (src, dst, ro) in &o.volumes {
        let t = p(dst);
        if fs::metadata(src)?.is_dir() {
            fs::create_dir_all(&t)?;
        } else {
            touch(&t)?;
        }
        bind(src, &t)?;
        if *ro {
            make_ro(&t)?;
        }
    }

    // 4) 遮蔽敏感路徑（盡力而為）
    for f in ["/proc/kcore", "/proc/sysrq-trigger", "/proc/timer_list", "/proc/sched_debug", "/proc/keys"] {
        let _ = mount("/dev/null", &p(f), "", libc::MS_BIND, "");
    }
    for d in ["/proc/bus", "/proc/fs", "/proc/irq", "/proc/sys"] {
        let t = p(d);
        if bind(&t, &t).is_ok() {
            let _ = make_ro(&t);
        }
    }
    let _ = mount("tmpfs", &p("/sys/firmware"), "tmpfs", libc::MS_RDONLY, "size=0");

    // 5) pivot_root(".", ".") 再把舊根卸掉（不需要額外的 .old 目錄）
    env::set_current_dir(&root)?;
    let dot = cs(".");
    check(unsafe { libc::syscall(libc::SYS_pivot_root, dot.as_ptr(), dot.as_ptr()) }, "pivot_root")?;
    check(unsafe { libc::umount2(dot.as_ptr(), libc::MNT_DETACH) } as i64, "umount 舊根")?;
    env::set_current_dir("/")
}

/// 容器內的 PID 1：轉送訊號、回收殭屍行程，app 結束時一起結束
fn init_loop(app: i32) -> ! {
    install_forwarders(app, &[HOST_SIGS[0], HOST_SIGS[1], HOST_SIGS[2], HOST_SIGS[3], libc::SIGUSR1, libc::SIGUSR2]);
    let mut code = 0;
    loop {
        let mut st = 0;
        let r = unsafe { libc::waitpid(-1, &mut st, 0) };
        if r < 0 {
            if errno() == libc::EINTR { continue; }
            break; // ECHILD
        }
        if r == app {
            code = exit_code(st);
            break;
        }
    }
    process::exit(code); // PID 1 結束，核心會殺掉 namespace 內其餘行程
}

fn child_main(o: &Opts, dir: &Path, rootfs: &str, pty: Option<&tty::Pty>, sync_rd: i32) -> ! {
    unsafe { libc::prctl(libc::PR_SET_PDEATHSIG, libc::SIGKILL as libc::c_ulong, 0, 0, 0) };
    if let Some(p) = pty {
        unsafe { libc::close(p.master) };
    }
    // 等父行程把我們放進 cgroup
    let mut b = [0u8; 1];
    unsafe {
        libc::read(sync_rd, b.as_mut_ptr() as *mut _, 1);
        libc::close(sync_rd);
    }

    let mut flags = libc::CLONE_NEWNS | libc::CLONE_NEWUTS | libc::CLONE_NEWIPC;
    if !o.share_net {
        flags |= libc::CLONE_NEWNET;
    }
    if let Err(e) = check(unsafe { libc::unshare(flags) } as i64, "unshare") {
        die(&e.to_string());
    }
    let h = cs(&o.host);
    unsafe { libc::sethostname(h.as_ptr(), o.host.len()) };

    if let Err(e) = setup_root(o, dir, rootfs, pty.map(|p| p.path.as_str())) {
        die(&format!("設定 rootfs 失敗：{e}"));
    }
    sec::harden(!o.no_seccomp);

    match unsafe { libc::fork() } {
        -1 => die("fork 失敗"),
        0 => {
            if let Some(p) = pty {
                tty::attach(p.slave);
            }
            exec_cmd(&o.cmd, build_env(Some(&o.host), &o.env), &o.workdir)
        }
        app => {
            if let Some(p) = pty {
                unsafe { libc::close(p.slave) };
            }
            init_loop(app)
        }
    }
}

// ---------- 父行程 ----------

fn enter_userns(euid: u32, egid: u32) -> io::Result<()> {
    check(unsafe { libc::unshare(libc::CLONE_NEWUSER) } as i64, "unshare(CLONE_NEWUSER)")?;
    let w = |f: &str, s: String| {
        fs::write(format!("/proc/self/{f}"), s).map_err(|e| io::Error::new(e.kind(), format!("寫入 {f}: {e}")))
    };
    w("setgroups", "deny".into())?;
    w("gid_map", format!("0 {egid} 1"))?;
    w("uid_map", format!("0 {euid} 1"))
}

fn detach_stdio(dir: &Path) {
    unsafe { libc::setsid() };
    if let Ok(null) = fs::File::open("/dev/null") {
        unsafe { libc::dup2(null.as_raw_fd(), 0) };
    }
    if let Ok(log) = fs::OpenOptions::new().create(true).append(true).open(dir.join("log")) {
        unsafe {
            libc::dup2(log.as_raw_fd(), 1);
            libc::dup2(log.as_raw_fd(), 2);
        }
    }
}

pub fn run(o: Opts) -> ! {
    let euid = unsafe { libc::geteuid() };
    let egid = unsafe { libc::getegid() };

    let rootfs = fs::canonicalize(&o.rootfs)
        .unwrap_or_else(|e| die(&format!("找不到 rootfs {}：{e}", o.rootfs)))
        .to_string_lossy()
        .into_owned();
    if o.tty && o.detach {
        die("-t 與 -d 不能同時使用");
    }
    if o.tty && unsafe { libc::isatty(0) } != 1 {
        die("-t 需要標準輸入是終端機");
    }

    let id = o.name.clone().unwrap_or_else(state::new_id);
    if !state::valid_name(&id) {
        die("名稱只能包含英數字、- 與 _");
    }
    let dir = state::ctr_dir(&id);
    if dir.exists() {
        die(&format!("容器 {id} 已存在"));
    }
    fs::create_dir_all(&dir).unwrap_or_else(|e| die(&format!("無法建立 {}：{e}", dir.display())));
    let dir = fs::canonicalize(&dir).unwrap_or(dir);
    if rootfs.contains([',', ':']) || dir.to_string_lossy().contains([',', ':']) {
        die("路徑不可包含 ',' 或 ':'（overlayfs 選項限制）");
    }

    // -d：先 fork 讓前景行程印出 id 就離開，背景行程繼續當 supervisor
    if o.detach {
        match unsafe { libc::fork() } {
            -1 => die("fork 失敗"),
            0 => detach_stdio(&dir),
            _ => {
                println!("{id}");
                process::exit(0);
            }
        }
    }

    if let Err(e) = enter_userns(euid, egid) {
        die(&format!("{e}\n提示：請確認核心允許 unprivileged user namespace\n  （sysctl user.max_user_namespaces、kernel.unprivileged_userns_clone、kernel.apparmor_restrict_unprivileged_userns）"));
    }
    if let Err(e) = check(unsafe { libc::unshare(libc::CLONE_NEWPID) } as i64, "unshare(CLONE_NEWPID)") {
        die(&e.to_string());
    }

    let pty = if o.tty {
        Some(tty::open_pty().unwrap_or_else(|e| die(&format!("建立 pty 失敗：{e}"))))
    } else {
        None
    };

    let mut fds = [0i32; 2];
    if unsafe { libc::pipe(fds.as_mut_ptr()) } < 0 {
        die("pipe 失敗");
    }

    match unsafe { libc::fork() } {
        -1 => die("fork 失敗"),
        0 => {
            unsafe { libc::close(fds[1]) };
            child_main(&o, &dir, &rootfs, pty.as_ref(), fds[0]);
        }
        child => {
            unsafe { libc::close(fds[0]) };
            if let Some(p) = &pty {
                unsafe { libc::close(p.slave) }; // 子行程已繼承
            }
            let cg = setup_cgroup(&id, child, &o);
            Meta {
                pid: child,
                cmd: o.cmd.join(" "),
                cgroup: cg.as_ref().map(|c| c.to_string_lossy().into_owned()).unwrap_or_default(),
                workdir: o.workdir.clone(),
                env: o.env.clone(),
                started: state::now(),
            }
            .save(&dir);
            unsafe {
                libc::write(fds[1], b"1".as_ptr() as *const _, 1);
                libc::close(fds[1]);
            }

            install_forwarders(child, &HOST_SIGS);
            let code = match &pty {
                Some(p) => tty::relay(p.master, child),
                None => wait_pid(child),
            };

            if let Some(cg) = cg {
                let _ = cg_write(&cg.join("cgroup.kill"), "1");
                let _ = fs::remove_dir(cg);
            }
            let _ = fs::remove_dir_all(&dir);
            process::exit(code);
        }
    }
}

// ---------- exec：進入執行中的容器 ----------

pub fn exec(id: &str, cmd: Vec<String>, tty_on: bool, extra_env: Vec<String>, workdir: Option<String>, seccomp: bool) -> ! {
    let dir = state::ctr_dir(id);
    let m = Meta::load(&dir).unwrap_or_else(|| die(&format!("找不到容器 {id}")));
    if !state::alive(m.pid) {
        die(&format!("容器 {id} 已經停止"));
    }
    if tty_on && unsafe { libc::isatty(0) } != 1 {
        die("-t 需要標準輸入是終端機");
    }
    // 先加入容器的 cgroup，之後 fork 出來的子行程會繼承
    if !m.cgroup.is_empty() {
        let _ = cg_write(Path::new(&format!("{}/cgroup.procs", m.cgroup)), "0");
    }

    // 在加入任何 namespace 之前先把所有 fd 開好（user 必須最先加入）
    let order = [
        ("user", libc::CLONE_NEWUSER), ("ipc", libc::CLONE_NEWIPC), ("uts", libc::CLONE_NEWUTS),
        ("net", libc::CLONE_NEWNET), ("pid", libc::CLONE_NEWPID), ("mnt", libc::CLONE_NEWNS),
    ];
    let mut nss = vec![];
    for (n, flag) in order {
        let theirs = format!("/proc/{}/ns/{n}", m.pid);
        if fs::read_link(format!("/proc/self/ns/{n}")).ok() == fs::read_link(&theirs).ok() {
            continue; // 已經在同一個 namespace（例如 run --net 共用主機網路）
        }
        let c = cs(&theirs);
        let fd = unsafe { libc::open(c.as_ptr(), libc::O_RDONLY | libc::O_CLOEXEC) };
        if fd < 0 {
            die(&format!("無法開啟 {theirs}：{}", io::Error::last_os_error()));
        }
        nss.push((n, flag, fd));
    }
    let pty = if tty_on {
        Some(tty::open_pty().unwrap_or_else(|e| die(&format!("建立 pty 失敗：{e}"))))
    } else {
        None
    };
    for (n, flag, fd) in &nss {
        if let Err(e) = check(unsafe { libc::setns(*fd, *flag) } as i64, &format!("setns({n})")) {
            die(&e.to_string());
        }
        unsafe { libc::close(*fd) };
    }

    match unsafe { libc::fork() } {
        -1 => die("fork 失敗"),
        0 => {
            if let Some(p) = &pty {
                unsafe { libc::close(p.master) };
                tty::attach(p.slave);
            }
            sec::harden(seccomp);
            let host = fs::read_to_string("/proc/sys/kernel/hostname").unwrap_or_default();
            let mut e = m.env.clone();
            e.extend(extra_env);
            let wd = workdir.unwrap_or_else(|| if m.workdir.is_empty() { "/".into() } else { m.workdir.clone() });
            exec_cmd(&cmd, build_env(Some(host.trim()), &e), &wd)
        }
        child => {
            if let Some(p) = &pty {
                unsafe { libc::close(p.slave) };
            }
            install_forwarders(child, &HOST_SIGS);
            let code = match &pty {
                Some(p) => tty::relay(p.master, child),
                None => wait_pid(child),
            };
            process::exit(code);
        }
    }
}
