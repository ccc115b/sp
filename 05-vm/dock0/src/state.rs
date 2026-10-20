//! 容器狀態目錄：<base>/containers/<id>/{meta,log,upper,work,merged}
use crate::sys::errno;
use std::path::{Path, PathBuf};
use std::{env, fs, io::Read};

pub fn base() -> PathBuf {
    if let Ok(d) = env::var("DOCK0_DIR") {
        if !d.is_empty() {
            return d.into();
        }
    }
    match env::var("HOME") {
        Ok(h) if !h.is_empty() => PathBuf::from(h).join(".local/share/dock0"),
        _ => PathBuf::from("/var/tmp/dock0"),
    }
}

pub fn ctr_dir(id: &str) -> PathBuf {
    base().join("containers").join(id)
}

pub fn valid_name(s: &str) -> bool {
    !s.is_empty() && s.len() <= 64 && s.chars().all(|c| c.is_ascii_alphanumeric() || c == '-' || c == '_')
}

pub fn new_id() -> String {
    let mut b = [0u8; 6];
    if let Ok(mut f) = fs::File::open("/dev/urandom") {
        let _ = f.read_exact(&mut b);
    }
    b.iter().map(|x| format!("{x:02x}")).collect()
}

pub fn alive(pid: i32) -> bool {
    pid > 0 && (unsafe { libc::kill(pid, 0) } == 0 || errno() == libc::EPERM)
}

pub fn now() -> u64 {
    std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).map(|d| d.as_secs()).unwrap_or(0)
}

#[derive(Default)]
pub struct Meta {
    pub pid: i32,
    pub cmd: String,
    pub cgroup: String,
    pub workdir: String,
    pub env: Vec<String>,
    pub started: u64,
}

impl Meta {
    pub fn save(&self, dir: &Path) {
        let mut s = format!(
            "pid={}\ncmd={}\ncgroup={}\nworkdir={}\nstarted={}\n",
            self.pid,
            self.cmd.replace('\n', " "),
            self.cgroup,
            self.workdir,
            self.started
        );
        for e in &self.env {
            s.push_str(&format!("env={}\n", e.replace('\n', " ")));
        }
        let tmp = dir.join("meta.tmp");
        if fs::write(&tmp, s).is_ok() {
            let _ = fs::rename(&tmp, dir.join("meta"));
        }
    }

    pub fn load(dir: &Path) -> Option<Meta> {
        let text = fs::read_to_string(dir.join("meta")).ok()?;
        let mut m = Meta::default();
        for line in text.lines() {
            let (k, v) = line.split_once('=')?;
            match k {
                "pid" => m.pid = v.parse().ok()?,
                "cmd" => m.cmd = v.into(),
                "cgroup" => m.cgroup = v.into(),
                "workdir" => m.workdir = v.into(),
                "started" => m.started = v.parse().unwrap_or(0),
                "env" => m.env.push(v.into()),
                _ => {}
            }
        }
        Some(m)
    }
}

/// 列出執行中的容器；順便清掉已死亡的殘留目錄
pub fn list() -> Vec<(String, Meta)> {
    let mut out = vec![];
    let Ok(rd) = fs::read_dir(base().join("containers")) else { return out };
    for e in rd.flatten() {
        let id = e.file_name().to_string_lossy().into_owned();
        let Some(m) = Meta::load(&e.path()) else { continue }; // 尚在啟動中
        if alive(m.pid) {
            out.push((id, m));
        } else {
            let _ = fs::remove_dir_all(e.path());
        }
    }
    out.sort_by_key(|(_, m)| m.started);
    out
}
