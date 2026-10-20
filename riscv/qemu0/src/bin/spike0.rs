//! spike0 — 類似 `spike pk` 的 user-mode 執行器。
//!
//! 直接在目前的 OS 上執行靜態連結的 RISC-V (rv64ima) Linux ELF:
//!     spike0 ./a.out arg1 arg2
//!
//! 作法:用 rvcore 的 CPU 直譯指令;遇到 `ecall` 時不走 trap,
//! 而是依 RISC-V Linux ABI(a7 = 系統呼叫編號,a0..a5 = 參數,回傳值放 a0)
//! 轉成主機 OS 的操作(proxy syscall),就像 pk 把系統呼叫代理給 host 一樣。

#[cfg(not(unix))]
fn main() {
    eprintln!("spike0 目前只支援 Unix 主機(Linux / macOS)");
    std::process::exit(1);
}

#[cfg(unix)]
fn main() {
    imp::main();
}

#[cfg(unix)]
mod imp {
    use rvcore::bus::Bus;
    use rvcore::cpu::Cpu;
    use rvcore::elf;
    use std::collections::HashSet;
    use std::fs::{File, OpenOptions};
    use std::io::{Read, Seek, SeekFrom, Write};
    use std::mem::ManuallyDrop;
    use std::os::unix::fs::{FileExt, MetadataExt};
    use std::os::unix::io::{FromRawFd, IntoRawFd};
    use std::process::exit;
    use std::time::{Instant, SystemTime, UNIX_EPOCH};

    const USAGE: &str = "\
spike0 — 在目前 OS 上直接執行 RISC-V (rv64ima) 靜態 ELF,功能類似 `spike pk`

用法: spike0 [選項] <program> [參數...]

  -m <MB>   堆積/mmap 可用記憶體,預設 256
  -n <N>    最多執行 N 個指令
  -e        把主機環境變數傳給程式(預設為空)
  -s        追蹤系統呼叫(stderr)
  -d        追蹤每個指令(stderr)
  --stat    結束時印出執行的指令數
  -h        顯示說明

支援:靜態連結、-march=rv64ima -mabi=lp64 的程式(不含 C / F / D 擴充)。";

    const ENOSYS: i64 = 38;
    const EBADF: i64 = 9;
    const ENOMEM: i64 = 12;
    const EFAULT: i64 = 14;
    const EINVAL: i64 = 22;
    const ENOTTY: i64 = 25;

    const PAGE: u64 = 4096;
    const STACK_SIZE: u64 = 8 << 20;

    fn die(msg: &str) -> ! {
        eprintln!("spike0: {msg}");
        exit(64);
    }

    fn page_up(x: u64) -> u64 {
        (x + PAGE - 1) & !(PAGE - 1)
    }

    fn errno(e: &std::io::Error) -> i64 {
        e.raw_os_error().unwrap_or(5) as i64
    }

    struct Proc {
        cpu: Cpu,
        brk_start: u64,
        brk: u64,
        mmap_next: u64,
        rng: u64,
        start: Instant,
        fds: HashSet<i32>,
        trace_sys: bool,
    }

    fn host_file(fd: i32) -> ManuallyDrop<File> {
        // 呼叫端已確認 fd 屬於 guest 可用的集合。
        ManuallyDrop::new(unsafe { File::from_raw_fd(fd) })
    }

    pub fn main() {
        let mut mem_mb = 256u64;
        let mut max: Option<u64> = None;
        let mut pass_env = false;
        let mut trace_sys = false;
        let mut trace_insn = false;
        let mut stat = false;
        let mut prog_args: Vec<String> = Vec::new();

        let mut it = std::env::args().skip(1);
        while let Some(a) = it.next() {
            match a.as_str() {
                "-h" | "--help" => {
                    println!("{USAGE}");
                    return;
                }
                "-m" => mem_mb = it.next().and_then(|v| v.parse().ok()).unwrap_or_else(|| die("-m 需要數字")),
                "-n" => max = Some(it.next().and_then(|v| v.parse().ok()).unwrap_or_else(|| die("-n 需要數字"))),
                "-e" => pass_env = true,
                "-s" => trace_sys = true,
                "-d" => trace_insn = true,
                "--stat" => stat = true,
                s if s.starts_with('-') => die(&format!("未知選項 {s}\n\n{USAGE}")),
                _ => {
                    prog_args.push(a);
                    prog_args.extend(it.by_ref());
                    break;
                }
            }
        }
        if prog_args.is_empty() {
            eprintln!("{USAGE}");
            exit(64);
        }

        let path = prog_args[0].clone();
        let data = std::fs::read(&path).unwrap_or_else(|e| die(&format!("無法讀取 {path}: {e}")));
        let info = elf::parse(&data).unwrap_or_else(|e| die(&format!("{path}: {e}")));
        if info.has_interp {
            die("不支援動態連結的程式,請用 -static 重新連結");
        }
        if info.segments.is_empty() {
            die("ELF 沒有可載入的區段");
        }

        // 位址空間:[base, base+total) 的一塊連續記憶體,
        //   | ELF 區段 | brk 堆積 → ...   ← mmap | 堆疊 8MB |
        let base = info.segments.iter().map(|s| s.vaddr).min().unwrap() & !(PAGE - 1);
        let image_end = page_up(info.segments.iter().map(|s| s.vaddr + s.memsz).max().unwrap());
        let total = (image_end - base) + (mem_mb << 20) + STACK_SIZE;
        let top = base + total;

        let mut cpu = Cpu::new(0, false);
        cpu.bus = Bus::with_base(base, total as usize, false);
        cpu.trace = trace_insn;
        for s in &info.segments {
            let (o, n) = (s.off as usize, s.filesz as usize);
            let seg = data.get(o..o + n).unwrap_or_else(|| die("區段超出檔案範圍"));
            cpu.bus.load_image(s.vaddr, seg).unwrap_or_else(|e| die(&e));
        }

        // AT_PHDR:找出包含 program header table 的區段
        let phdr = info
            .segments
            .iter()
            .find(|s| s.off <= info.phoff && info.phoff < s.off + s.filesz)
            .map(|s| s.vaddr + (info.phoff - s.off))
            .unwrap_or(0);

        let envs: Vec<String> = if pass_env {
            std::env::vars().map(|(k, v)| format!("{k}={v}")).collect()
        } else {
            Vec::new()
        };
        let sp = setup_stack(&mut cpu, top, &prog_args, &envs, &info, phdr);
        cpu.x[2] = sp;
        // 連結器 relaxation 會產生以 gp 為基底的定址;真實的 crt0 會自行設定 gp,
        // 這裡直接依符號表代勞,讓不帶 crt0 的純組語也能跑。
        if let Some(gp) = elf::find_symbol(&data, "__global_pointer$") {
            cpu.x[3] = gp;
        }
        cpu.pc = info.entry;

        let mut p = Proc {
            cpu,
            brk_start: image_end,
            brk: image_end,
            mmap_next: top - STACK_SIZE,
            rng: 0x2545_F491_4F6C_DD1D,
            start: Instant::now(),
            fds: [0, 1, 2].into_iter().collect(),
            trace_sys,
        };

        let code = p.run(max);
        if stat {
            eprintln!("[spike0] 共執行 {} 個指令", p.cpu.instret);
        }
        exit(code);
    }

    /// 建立 Linux 風格的初始堆疊:argc, argv[], NULL, envp[], NULL, auxv[]。
    fn setup_stack(cpu: &mut Cpu, top: u64, args: &[String], envs: &[String], info: &elf::Info, phdr: u64) -> u64 {
        let mut sp = top;
        let mut push = |cpu: &mut Cpu, data: &[u8]| -> u64 {
            sp -= data.len() as u64;
            cpu.bus.slice_mut(sp, data.len()).unwrap().copy_from_slice(data);
            sp
        };
        let mut push_str = |cpu: &mut Cpu, s: &str| -> u64 {
            let mut v = s.as_bytes().to_vec();
            v.push(0);
            push(cpu, &v)
        };
        let env_ptrs: Vec<u64> = envs.iter().map(|s| push_str(cpu, s)).collect();
        let arg_ptrs: Vec<u64> = args.iter().map(|s| push_str(cpu, s)).collect();
        let random = push_str(cpu, "0123456789abcdef"); // AT_RANDOM 的 16 位元組(含結尾 NUL)
        let platform = push_str(cpu, "rv64ima");
        let sp = sp; // push 閉包借用結束

        let aux: [(u64, u64); 12] = [
            (3, phdr),           // AT_PHDR
            (4, info.phentsize), // AT_PHENT
            (5, info.phnum),     // AT_PHNUM
            (6, PAGE),           // AT_PAGESZ
            (9, info.entry),     // AT_ENTRY
            (11, 1000),          // AT_UID
            (12, 1000),          // AT_EUID
            (13, 1000),          // AT_GID
            (14, 1000),          // AT_EGID
            (15, platform),      // AT_PLATFORM
            (25, random),        // AT_RANDOM
            (0, 0),              // AT_NULL
        ];
        let words = 1 + arg_ptrs.len() + 1 + env_ptrs.len() + 1 + aux.len() * 2;
        let start = (sp - words as u64 * 8) & !15;
        let mut cur = start;
        let mut put = |cpu: &mut Cpu, v: u64| {
            cpu.bus.store(cur, 8, v).unwrap();
            cur += 8;
        };
        put(cpu, args.len() as u64);
        for a in &arg_ptrs {
            put(cpu, *a);
        }
        put(cpu, 0);
        for e in &env_ptrs {
            put(cpu, *e);
        }
        put(cpu, 0);
        for (k, v) in aux {
            put(cpu, k);
            put(cpu, v);
        }
        start
    }

    impl Proc {
        fn run(&mut self, max: Option<u64>) -> i32 {
            loop {
                if max.map_or(false, |m| self.cpu.instret >= m) {
                    eprintln!("[spike0] 已達指令上限");
                    self.cpu.dump_regs();
                    return 2;
                }
                let pc = self.cpu.pc;
                // 0x00000073 = ecall:攔截並由 host 代理
                if self.cpu.bus.load(pc, 4) == Some(0x73) {
                    self.cpu.instret += 1;
                    if let Some(code) = self.syscall() {
                        return code;
                    }
                    self.cpu.pc = pc + 4;
                    continue;
                }
                if let Err(msg) = self.cpu.step() {
                    eprintln!("[spike0] 程式發生例外而終止: {msg}");
                    self.cpu.dump_regs();
                    return 1;
                }
            }
        }

        // ---------- guest 記憶體輔助 ----------
        fn cstr(&self, addr: u64) -> Option<String> {
            let mut v = Vec::new();
            for i in 0..4096u64 {
                let b = self.cpu.bus.slice(addr + i, 1)?[0];
                if b == 0 {
                    return Some(String::from_utf8_lossy(&v).into_owned());
                }
                v.push(b);
            }
            None
        }

        fn put_bytes(&mut self, addr: u64, data: &[u8]) -> bool {
            match self.cpu.bus.slice_mut(addr, data.len()) {
                Some(d) => {
                    d.copy_from_slice(data);
                    true
                }
                None => false,
            }
        }

        fn put_u64s(&mut self, addr: u64, vals: &[u64]) -> bool {
            let b: Vec<u8> = vals.iter().flat_map(|v| v.to_le_bytes()).collect();
            self.put_bytes(addr, &b)
        }

        fn valid_fd(&self, fd: u64) -> Option<i32> {
            let fd = fd as i64;
            if fd >= 0 && self.fds.contains(&(fd as i32)) {
                Some(fd as i32)
            } else {
                None
            }
        }

        fn next_rand(&mut self) -> u64 {
            let mut x = self.rng;
            x ^= x << 13;
            x ^= x >> 7;
            x ^= x << 17;
            self.rng = x;
            x
        }

        fn alloc_mmap(&mut self, len: u64) -> Option<u64> {
            let len = page_up(len.max(1));
            let new = self.mmap_next.checked_sub(len)?;
            if new < self.brk {
                return None;
            }
            self.mmap_next = new;
            Some(new)
        }

        // ---------- 系統呼叫 ----------
        /// 回傳 Some(exit_code) 表示程式結束。
        fn syscall(&mut self) -> Option<i32> {
            let n = self.cpu.x[17];
            let a: [u64; 6] = [
                self.cpu.x[10], self.cpu.x[11], self.cpu.x[12],
                self.cpu.x[13], self.cpu.x[14], self.cpu.x[15],
            ];
            if n == 93 || n == 94 {
                if self.trace_sys {
                    eprintln!("[sys] exit({})", a[0] as i32);
                }
                return Some(a[0] as i32 & 0xff);
            }
            let ret: i64 = self.dispatch(n, a);
            if self.trace_sys {
                eprintln!("[sys] {}({:#x}, {:#x}, {:#x}) = {}", name(n), a[0], a[1], a[2], ret);
            }
            self.cpu.x[10] = ret as u64;
            None
        }

        fn dispatch(&mut self, n: u64, a: [u64; 6]) -> i64 {
            match n {
                29 => -ENOTTY, // ioctl
                56 => self.sys_openat(a),
                57 => match self.valid_fd(a[0]) {
                    Some(fd) if fd > 2 => {
                        self.fds.remove(&fd);
                        drop(unsafe { File::from_raw_fd(fd) });
                        0
                    }
                    Some(_) => 0,
                    None => -EBADF,
                },
                62 => self.sys_lseek(a),
                63 => self.sys_read(a),
                64 => self.sys_write(a),
                66 => self.sys_writev(a),
                80 => self.sys_fstat(a),
                96 => 1, // set_tid_address
                99 => 0, // set_robust_list
                113 => self.sys_clock_gettime(a),
                131 => {
                    eprintln!("[spike0] 程式呼叫 tgkill,視為 abort");
                    exit(134)
                }
                134 | 135 => 0, // rt_sigaction / rt_sigprocmask
                160 => self.sys_uname(a),
                169 => self.sys_gettimeofday(a),
                172 => std::process::id() as i64,
                173 => 1,
                174..=177 => 1000,
                178 => 1,
                214 => self.sys_brk(a),
                215 => 0, // munmap(位址空間在結束時整塊釋放)
                222 => self.sys_mmap(a),
                226 | 233 => 0, // mprotect / madvise
                261 => 0,       // prlimit64
                278 => self.sys_getrandom(a),
                _ => {
                    if self.trace_sys {
                        eprintln!("[spike0] 未支援的 syscall {n}(回傳 ENOSYS)");
                    }
                    -ENOSYS
                }
            }
        }

        fn sys_openat(&mut self, a: [u64; 6]) -> i64 {
            let Some(path) = self.cstr(a[1]) else { return -EFAULT };
            let flags = a[2];
            let acc = flags & 3;
            let mut o = OpenOptions::new();
            o.read(acc == 0 || acc == 2);
            if acc == 1 || acc == 2 {
                o.write(true);
            }
            if flags & 0o2000 != 0 {
                o.append(true);
            }
            if flags & 0o100 != 0 {
                if flags & 0o200 != 0 {
                    o.create_new(true);
                } else {
                    o.create(true);
                }
            }
            if flags & 0o1000 != 0 {
                o.truncate(true);
            }
            match o.open(&path) {
                Ok(f) => {
                    let fd = f.into_raw_fd();
                    self.fds.insert(fd);
                    fd as i64
                }
                Err(e) => -errno(&e),
            }
        }

        fn sys_lseek(&mut self, a: [u64; 6]) -> i64 {
            let Some(fd) = self.valid_fd(a[0]) else { return -EBADF };
            let pos = match a[2] {
                0 => SeekFrom::Start(a[1]),
                1 => SeekFrom::Current(a[1] as i64),
                2 => SeekFrom::End(a[1] as i64),
                _ => return -EINVAL,
            };
            match host_file(fd).seek(pos) {
                Ok(p) => p as i64,
                Err(e) => -errno(&e),
            }
        }

        fn sys_read(&mut self, a: [u64; 6]) -> i64 {
            let Some(fd) = self.valid_fd(a[0]) else { return -EBADF };
            let Some(buf) = self.cpu.bus.slice_mut(a[1], a[2] as usize) else { return -EFAULT };
            match host_file(fd).read(buf) {
                Ok(n) => n as i64,
                Err(e) => -errno(&e),
            }
        }

        fn sys_write(&mut self, a: [u64; 6]) -> i64 {
            let Some(fd) = self.valid_fd(a[0]) else { return -EBADF };
            let Some(buf) = self.cpu.bus.slice(a[1], a[2] as usize) else { return -EFAULT };
            match host_file(fd).write(buf) {
                Ok(n) => n as i64,
                Err(e) => -errno(&e),
            }
        }

        fn sys_writev(&mut self, a: [u64; 6]) -> i64 {
            let Some(fd) = self.valid_fd(a[0]) else { return -EBADF };
            let mut total = 0i64;
            for i in 0..a[2] {
                let Some(iov) = self.cpu.bus.slice(a[1] + i * 16, 16) else { return -EFAULT };
                let base = u64::from_le_bytes(iov[0..8].try_into().unwrap());
                let len = u64::from_le_bytes(iov[8..16].try_into().unwrap()) as usize;
                let Some(buf) = self.cpu.bus.slice(base, len) else { return -EFAULT };
                match host_file(fd).write(buf) {
                    Ok(n) => {
                        total += n as i64;
                        if n < len {
                            break;
                        }
                    }
                    Err(e) => return if total > 0 { total } else { -errno(&e) },
                }
            }
            total
        }

        fn sys_fstat(&mut self, a: [u64; 6]) -> i64 {
            let Some(fd) = self.valid_fd(a[0]) else { return -EBADF };
            let m = match host_file(fd).metadata() {
                Ok(m) => m,
                Err(e) => return -errno(&e),
            };
            // RISC-V Linux 的 struct stat(128 位元組)
            let mut b = [0u8; 128];
            let mut w = |off: usize, v: u64, len: usize| b[off..off + len].copy_from_slice(&v.to_le_bytes()[..len]);
            w(0, m.dev(), 8);
            w(8, m.ino(), 8);
            w(16, m.mode() as u64, 4);
            w(20, m.nlink(), 4);
            w(24, m.uid() as u64, 4);
            w(28, m.gid() as u64, 4);
            w(32, m.rdev(), 8);
            w(48, m.size(), 8);
            w(56, m.blksize(), 4);
            w(64, m.blocks(), 8);
            w(72, m.atime() as u64, 8);
            w(80, m.atime_nsec() as u64, 8);
            w(88, m.mtime() as u64, 8);
            w(96, m.mtime_nsec() as u64, 8);
            w(104, m.ctime() as u64, 8);
            w(112, m.ctime_nsec() as u64, 8);
            if self.put_bytes(a[1], &b) { 0 } else { -EFAULT }
        }

        fn sys_clock_gettime(&mut self, a: [u64; 6]) -> i64 {
            let (s, ns) = if a[0] == 0 {
                let d = SystemTime::now().duration_since(UNIX_EPOCH).unwrap_or_default();
                (d.as_secs(), d.subsec_nanos() as u64)
            } else {
                let d = self.start.elapsed();
                (d.as_secs() + 1000, d.subsec_nanos() as u64)
            };
            if self.put_u64s(a[1], &[s, ns]) { 0 } else { -EFAULT }
        }

        fn sys_gettimeofday(&mut self, a: [u64; 6]) -> i64 {
            let d = SystemTime::now().duration_since(UNIX_EPOCH).unwrap_or_default();
            if a[0] == 0 || self.put_u64s(a[0], &[d.as_secs(), d.subsec_micros() as u64]) { 0 } else { -EFAULT }
        }

        fn sys_uname(&mut self, a: [u64; 6]) -> i64 {
            let mut b = vec![0u8; 65 * 6];
            for (i, s) in ["Linux", "spike0", "6.0.0-spike0", "#1", "riscv64", "(none)"].iter().enumerate() {
                b[i * 65..i * 65 + s.len()].copy_from_slice(s.as_bytes());
            }
            if self.put_bytes(a[0], &b) { 0 } else { -EFAULT }
        }

        fn sys_brk(&mut self, a: [u64; 6]) -> i64 {
            let want = a[0];
            if want >= self.brk_start && want <= self.mmap_next {
                if want > self.brk {
                    // 擴張的部分先清零(可能被先前的 brk 縮小後使用過)
                    let (from, to) = (self.brk, want);
                    if let Some(s) = self.cpu.bus.slice_mut(from, (to - from) as usize) {
                        s.fill(0);
                    }
                }
                self.brk = want;
            }
            self.brk as i64
        }

        fn sys_mmap(&mut self, a: [u64; 6]) -> i64 {
            let (addr, len, flags, fd, off) = (a[0], a[1], a[3], a[4] as i64, a[5]);
            if len == 0 {
                return -EINVAL;
            }
            let addr = if flags & 0x10 != 0 {
                // MAP_FIXED
                if self.cpu.bus.slice(addr, len as usize).is_none() {
                    return -ENOMEM;
                }
                addr
            } else {
                match self.alloc_mmap(len) {
                    Some(p) => p,
                    None => return -ENOMEM,
                }
            };
            let Some(region) = self.cpu.bus.slice_mut(addr, len as usize) else { return -ENOMEM };
            region.fill(0);
            if flags & 0x20 == 0 && fd >= 0 {
                // 檔案映射:以 private 方式複製檔案內容
                let Some(hfd) = self.valid_fd(fd as u64) else { return -EBADF };
                let region = self.cpu.bus.slice_mut(addr, len as usize).unwrap();
                let _ = host_file(hfd).read_at(region, off);
            }
            addr as i64
        }

        fn sys_getrandom(&mut self, a: [u64; 6]) -> i64 {
            let len = a[1] as usize;
            let bytes: Vec<u8> = (0..len).map(|_| self.next_rand() as u8).collect();
            if self.put_bytes(a[0], &bytes) { len as i64 } else { -EFAULT }
        }
    }

    fn name(n: u64) -> &'static str {
        match n {
            29 => "ioctl", 56 => "openat", 57 => "close", 62 => "lseek", 63 => "read",
            64 => "write", 66 => "writev", 80 => "fstat", 96 => "set_tid_address",
            99 => "set_robust_list", 113 => "clock_gettime", 134 => "rt_sigaction",
            135 => "rt_sigprocmask", 160 => "uname", 169 => "gettimeofday",
            172 => "getpid", 173 => "getppid", 174..=177 => "getuid", 178 => "gettid",
            214 => "brk", 215 => "munmap", 222 => "mmap", 226 => "mprotect",
            233 => "madvise", 261 => "prlimit64", 278 => "getrandom",
            _ => "syscall",
        }
    }
}
