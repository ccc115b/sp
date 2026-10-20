//! dock0 — 微型容器執行器（Linux only）
//!
//! rootless（user namespace）+ overlayfs + capabilities 縮減 + seccomp + pty + exec

mod run;
mod sec;
mod state;
mod sys;
mod tty;

use run::Opts;
use std::io::{Read, Write};
use std::vec::IntoIter;
use std::{env, fs, process, thread, time::Duration};
use sys::die;

const USAGE: &str = "\
dock0 — 微型容器執行器

用法:
  dock0 run  [選項] <rootfs> <cmd> [args...]
  dock0 exec [-t] [-e K=V] [-w DIR] [--no-seccomp] <id> <cmd> [args...]
  dock0 ps
  dock0 stop <id>
  dock0 logs [-f] <id>

run 選項:
  -t, --tty          配置偽終端機（互動式 shell 用，可寫成 -it）
  -d, --detach       背景執行，印出容器 id
      --name NAME    指定容器名稱（預設為隨機 id）
  -e KEY=VAL         設定環境變數（可重複）
  -w DIR             容器內的工作目錄（預設 /）
  -v SRC:DST[:ro]    bind mount 主機目錄（可重複）
      --mem MB       記憶體上限
      --pids N       行程數上限
      --cpus X       CPU 上限，例如 0.5
      --host NAME    容器 hostname（預設 dock0）
      --net          共用主機網路（預設隔離）
      --no-overlay   不使用 overlayfs（直接修改 rootfs）
      --no-seccomp   停用 seccomp 過濾（除錯用）

環境變數: DOCK0_DIR 指定狀態/寫入層目錄（預設 ~/.local/share/dock0）";

fn usage() -> ! {
    eprintln!("{USAGE}");
    process::exit(2);
}

fn val(it: &mut IntoIter<String>) -> String {
    it.next().unwrap_or_else(|| usage())
}

fn num<T: std::str::FromStr>(s: String) -> T {
    s.parse().unwrap_or_else(|_| usage())
}

fn parse_run(it: &mut IntoIter<String>) -> Opts {
    let mut o = Opts {
        rootfs: String::new(),
        cmd: vec![],
        host: "dock0".into(),
        name: None,
        mem_mb: None,
        pids: None,
        cpus: None,
        share_net: false,
        tty: false,
        detach: false,
        env: vec![],
        workdir: "/".into(),
        volumes: vec![],
        no_seccomp: false,
        no_overlay: false,
    };
    while let Some(arg) = it.next() {
        match arg.as_str() {
            "--tty" => o.tty = true,
            "--detach" => o.detach = true,
            "--name" => o.name = Some(val(it)),
            "-e" => o.env.push(val(it)),
            "-w" => o.workdir = val(it),
            "-v" => {
                let spec = val(it);
                let p: Vec<&str> = spec.split(':').collect();
                match p.as_slice() {
                    [s, d] => o.volumes.push((s.to_string(), d.to_string(), false)),
                    [s, d, "ro"] => o.volumes.push((s.to_string(), d.to_string(), true)),
                    [s, d, "rw"] => o.volumes.push((s.to_string(), d.to_string(), false)),
                    _ => usage(),
                }
            }
            "--mem" => o.mem_mb = Some(num(val(it))),
            "--pids" => o.pids = Some(num(val(it))),
            "--cpus" => o.cpus = Some(num(val(it))),
            "--host" => o.host = val(it),
            "--net" => o.share_net = true,
            "--no-overlay" => o.no_overlay = true,
            "--no-seccomp" => o.no_seccomp = true,
            s if s.len() > 1 && s.starts_with('-') && !s.starts_with("--") && s[1..].chars().all(|c| "tid".contains(c)) => {
                for c in s[1..].chars() {
                    match c {
                        't' => o.tty = true,
                        'd' => o.detach = true,
                        _ => {} // -i：stdin 本來就是開著的
                    }
                }
            }
            s if s.starts_with('-') => usage(),
            _ => {
                o.rootfs = arg;
                o.cmd = it.by_ref().collect();
                break;
            }
        }
    }
    if o.rootfs.is_empty() || o.cmd.is_empty() {
        usage();
    }
    o
}

fn cmd_exec(mut it: IntoIter<String>) -> ! {
    let (mut tty, mut seccomp, mut envs, mut wd) = (false, true, vec![], None);
    let mut id = None;
    while let Some(a) = it.next() {
        match a.as_str() {
            "-t" | "-it" | "--tty" => tty = true,
            "-i" => {}
            "-e" => envs.push(val(&mut it)),
            "-w" => wd = Some(val(&mut it)),
            "--no-seccomp" => seccomp = false,
            s if s.starts_with('-') => usage(),
            _ => {
                id = Some(a);
                break;
            }
        }
    }
    let cmd: Vec<String> = it.collect();
    match id {
        Some(id) if !cmd.is_empty() => run::exec(&id, cmd, tty, envs, wd, seccomp),
        _ => usage(),
    }
}

fn ago(secs: u64) -> String {
    match secs {
        s if s < 60 => format!("{s}s"),
        s if s < 3600 => format!("{}m", s / 60),
        s if s < 86400 => format!("{}h", s / 3600),
        s => format!("{}d", s / 86400),
    }
}

fn cmd_ps() {
    println!("{:<14} {:<8} {:<6} COMMAND", "CONTAINER", "PID", "UP");
    let now = state::now();
    for (id, m) in state::list() {
        println!("{:<14} {:<8} {:<6} {}", id, m.pid, ago(now.saturating_sub(m.started)), m.cmd);
    }
}

fn cmd_stop(mut it: IntoIter<String>) {
    let id = val(&mut it);
    let m = state::Meta::load(&state::ctr_dir(&id)).unwrap_or_else(|| die(&format!("找不到容器 {id}")));
    unsafe { libc::kill(m.pid, libc::SIGTERM) };
    for _ in 0..100 {
        if !state::alive(m.pid) {
            break;
        }
        thread::sleep(Duration::from_millis(100));
    }
    if state::alive(m.pid) {
        unsafe { libc::kill(m.pid, libc::SIGKILL) };
    }
    println!("{id}");
}

fn cmd_logs(it: IntoIter<String>) {
    let (mut follow, mut id) = (false, None);
    for a in it {
        if a == "-f" { follow = true } else { id = Some(a) }
    }
    let id = id.unwrap_or_else(|| usage());
    let path = state::ctr_dir(&id).join("log");
    let mut f = fs::File::open(&path).unwrap_or_else(|_| die("找不到日誌（容器不存在，或不是用 -d 啟動）"));
    let mut buf = Vec::new();
    loop {
        buf.clear();
        let _ = f.read_to_end(&mut buf);
        let mut out = std::io::stdout();
        let _ = out.write_all(&buf);
        let _ = out.flush();
        if !follow || !path.exists() {
            break;
        }
        thread::sleep(Duration::from_millis(200));
    }
}

fn main() {
    let mut a: Vec<String> = env::args().skip(1).collect();
    if a.is_empty() {
        usage();
    }
    let sub = a.remove(0);
    let mut it = a.into_iter();
    match sub.as_str() {
        "run" => run::run(parse_run(&mut it)),
        "exec" => cmd_exec(it),
        "ps" => cmd_ps(),
        "stop" => cmd_stop(it),
        "logs" => cmd_logs(it),
        _ => usage(),
    }
}
