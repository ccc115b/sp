//! 安全強化：丟棄 capabilities、no_new_privs、seccomp 黑名單
use crate::sys::die;
use std::fs;

/// 保留的 capabilities（與 Docker 預設相同）
const KEEP_CAPS: [u32; 14] = [
    0,  // CHOWN
    1,  // DAC_OVERRIDE
    3,  // FOWNER
    4,  // FSETID
    5,  // KILL
    6,  // SETGID
    7,  // SETUID
    8,  // SETPCAP
    10, // NET_BIND_SERVICE
    13, // NET_RAW
    18, // SYS_CHROOT
    27, // MKNOD
    29, // AUDIT_WRITE
    31, // SETFCAP
];

#[repr(C)]
struct CapHeader { version: u32, pid: i32 }
#[repr(C)]
#[derive(Clone, Copy)]
struct CapData { effective: u32, permitted: u32, inheritable: u32 }

fn drop_caps() {
    let last: u32 = fs::read_to_string("/proc/sys/kernel/cap_last_cap")
        .ok()
        .and_then(|s| s.trim().parse().ok())
        .unwrap_or(40);
    unsafe {
        // 先清 ambient，再縮小 bounding set（exec 後 root 取得的權限不會超過它）
        libc::prctl(47 /* PR_CAP_AMBIENT */, 4 /* CLEAR_ALL */, 0, 0, 0);
        for cap in 0..=last {
            if !KEEP_CAPS.contains(&cap) {
                libc::prctl(libc::PR_CAPBSET_DROP, cap as libc::c_ulong, 0, 0, 0);
            }
        }
    }
    // 目前行程本身（例如 PID 1 init）的 effective/permitted 也縮小
    let mask: u64 = KEEP_CAPS.iter().fold(0, |m, c| m | (1u64 << c));
    let (lo, hi) = (mask as u32, (mask >> 32) as u32);
    let hdr = CapHeader { version: 0x2008_0522, pid: 0 }; // _LINUX_CAPABILITY_VERSION_3
    let data = [
        CapData { effective: lo, permitted: lo, inheritable: 0 },
        CapData { effective: hi, permitted: hi, inheritable: 0 },
    ];
    unsafe { libc::syscall(libc::SYS_capset, &hdr as *const CapHeader, data.as_ptr()) };
}

// ---------- seccomp ----------

#[cfg(target_arch = "x86_64")]
const AUDIT_ARCH: u32 = 0xC000_003E;
#[cfg(target_arch = "aarch64")]
const AUDIT_ARCH: u32 = 0xC000_00B7;

const BPF_LD_W_ABS: u16 = 0x20;
const BPF_JEQ_K: u16 = 0x15;
const BPF_JSET_K: u16 = 0x45;
const BPF_RET_K: u16 = 0x06;

const RET_KILL: u32 = 0x8000_0000; // SECCOMP_RET_KILL_PROCESS
const RET_ALLOW: u32 = 0x7fff_0000;
const RET_EPERM: u32 = 0x0005_0000 | 1;
const RET_ENOSYS: u32 = 0x0005_0000 | 38;

/// 一旦 clone 帶有這些 flag 就拒絕（防止容器內再建立 namespace）
const CLONE_NS_MASK: u32 = 0x7E02_0000;

fn denied() -> Vec<libc::c_long> {
    #[allow(unused_mut)]
    let mut v = vec![
        libc::SYS_kexec_load, libc::SYS_kexec_file_load,
        libc::SYS_init_module, libc::SYS_finit_module, libc::SYS_delete_module,
        libc::SYS_ptrace, libc::SYS_process_vm_readv, libc::SYS_process_vm_writev,
        libc::SYS_keyctl, libc::SYS_add_key, libc::SYS_request_key,
        libc::SYS_bpf, libc::SYS_perf_event_open, libc::SYS_userfaultfd,
        libc::SYS_reboot, libc::SYS_swapon, libc::SYS_swapoff, libc::SYS_acct,
        libc::SYS_settimeofday, libc::SYS_quotactl,
        libc::SYS_mount, libc::SYS_umount2, libc::SYS_pivot_root,
        libc::SYS_unshare, libc::SYS_setns, libc::SYS_open_by_handle_at,
        libc::SYS_move_mount, libc::SYS_open_tree, libc::SYS_fsopen,
        libc::SYS_fsconfig, libc::SYS_fsmount, libc::SYS_fspick, libc::SYS_mount_setattr,
    ];
    #[cfg(target_arch = "x86_64")]
    v.extend([libc::SYS_iopl, libc::SYS_ioperm]);
    v
}

fn stmt(code: u16, k: u32) -> libc::sock_filter {
    libc::sock_filter { code, jt: 0, jf: 0, k }
}
fn jump(code: u16, k: u32, jt: u8, jf: u8) -> libc::sock_filter {
    libc::sock_filter { code, jt, jf, k }
}

fn build_filter() -> Vec<libc::sock_filter> {
    let deny = denied();
    let n = deny.len();
    let mut p = vec![
        stmt(BPF_LD_W_ABS, 4),               // A = seccomp_data.arch
        jump(BPF_JEQ_K, AUDIT_ARCH, 1, 0),   // 架構正確就跳過下一行
        stmt(BPF_RET_K, RET_KILL),           // 其他架構（如 32 位元相容層）直接殺掉
        stmt(BPF_LD_W_ABS, 0),               // A = syscall number
    ];
    #[cfg(target_arch = "x86_64")]
    {
        p.push(jump(BPF_JSET_K, 0x4000_0000, 0, 1)); // x32 ABI
        p.push(stmt(BPF_RET_K, RET_KILL));
    }
    // 之後的版面（相對於黑名單起點）：
    //   [0..n)  JEQ 各被禁 syscall  -> ERRNO
    //   n       JEQ clone   -> CLONECHK
    //   n+1     JEQ clone3  -> ENOSYS
    //   n+2     ALLOW
    //   n+3     CLONECHK: A = args[0]
    //   n+4     JSET mask   -> ERRNO
    //   n+5     ALLOW
    //   n+6     ENOSYS
    //   n+7     ERRNO(EPERM)
    for (i, nr) in deny.iter().enumerate() {
        p.push(jump(BPF_JEQ_K, *nr as u32, (n - i + 6) as u8, 0));
    }
    p.push(jump(BPF_JEQ_K, libc::SYS_clone as u32, 2, 0));
    p.push(jump(BPF_JEQ_K, libc::SYS_clone3 as u32, 4, 0));
    p.push(stmt(BPF_RET_K, RET_ALLOW));
    p.push(stmt(BPF_LD_W_ABS, 16));
    p.push(jump(BPF_JSET_K, CLONE_NS_MASK, 2, 0));
    p.push(stmt(BPF_RET_K, RET_ALLOW));
    p.push(stmt(BPF_RET_K, RET_ENOSYS));
    p.push(stmt(BPF_RET_K, RET_EPERM));
    p
}

fn install_seccomp() {
    let filter = build_filter();
    let prog = libc::sock_fprog { len: filter.len() as u16, filter: filter.as_ptr() as *mut _ };
    let r = unsafe {
        libc::prctl(libc::PR_SET_SECCOMP, 2 /* SECCOMP_MODE_FILTER */, &prog as *const _ as libc::c_ulong, 0, 0)
    };
    if r < 0 {
        die(&format!("安裝 seccomp 失敗：{}", std::io::Error::last_os_error()));
    }
}

/// 在 exec 使用者程式之前呼叫
pub fn harden(seccomp: bool) {
    drop_caps();
    if unsafe { libc::prctl(libc::PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0) } < 0 {
        die("設定 no_new_privs 失敗");
    }
    if seccomp {
        install_seccomp();
    }
}
