//! 極簡 ELF64(小端、RISC-V)載入器:只處理 PT_LOAD 區段。

use crate::bus::Bus;

fn u16le(d: &[u8], o: usize) -> Result<u64, String> {
    d.get(o..o + 2).map(|b| u16::from_le_bytes([b[0], b[1]]) as u64).ok_or_else(|| "ELF 檔案被截斷".to_string())
}
fn u32le(d: &[u8], o: usize) -> Result<u64, String> {
    d.get(o..o + 4).map(|b| u32::from_le_bytes(b.try_into().unwrap()) as u64).ok_or_else(|| "ELF 檔案被截斷".to_string())
}
fn u64le(d: &[u8], o: usize) -> Result<u64, String> {
    d.get(o..o + 8).map(|b| u64::from_le_bytes(b.try_into().unwrap())).ok_or_else(|| "ELF 檔案被截斷".to_string())
}

pub fn is_elf(d: &[u8]) -> bool {
    d.len() >= 4 && &d[0..4] == b"\x7fELF"
}

pub struct Segment {
    pub off: u64,
    pub vaddr: u64,
    pub paddr: u64,
    pub filesz: u64,
    pub memsz: u64,
}

pub struct Info {
    pub entry: u64,
    pub phoff: u64,
    pub phentsize: u64,
    pub phnum: u64,
    pub segments: Vec<Segment>,
    pub has_interp: bool,
}

/// 解析 ELF64/RISC-V 標頭與 PT_LOAD 區段。
pub fn parse(d: &[u8]) -> Result<Info, String> {
    if !is_elf(d) {
        return Err("不是 ELF 檔".into());
    }
    if d.get(4) != Some(&2) || d.get(5) != Some(&1) {
        return Err("只支援 64 位元小端 ELF (rv64)".into());
    }
    if u16le(d, 18)? != 243 {
        return Err("e_machine 不是 RISC-V (243)".into());
    }
    let entry = u64le(d, 24)?;
    let phoff = u64le(d, 32)?;
    let phentsize = u16le(d, 54)?;
    let phnum = u16le(d, 56)?;
    let mut segments = Vec::new();
    let mut has_interp = false;
    for i in 0..phnum as usize {
        let ph = phoff as usize + i * phentsize as usize;
        match u32le(d, ph)? {
            1 => segments.push(Segment {
                off: u64le(d, ph + 8)?,
                vaddr: u64le(d, ph + 16)?,
                paddr: u64le(d, ph + 24)?,
                filesz: u64le(d, ph + 32)?,
                memsz: u64le(d, ph + 40)?,
            }),
            3 => has_interp = true,
            _ => {}
        }
    }
    Ok(Info { entry, phoff, phentsize, phnum, segments, has_interp })
}

/// 依 p_paddr 載入 ELF(裸機用)並回傳進入點。
pub fn load(d: &[u8], bus: &mut Bus) -> Result<u64, String> {
    let info = parse(d)?;
    for s in &info.segments {
        let (o, n) = (s.off as usize, s.filesz as usize);
        let seg = d.get(o..o + n).ok_or("區段超出檔案範圍")?;
        bus.load_image(s.paddr, seg)?;
        // memsz > filesz 的部分(.bss)已由 DRAM 初始為 0。
    }
    Ok(info.entry)
}

/// 在 .symtab 中尋找符號位址(例如 `__global_pointer$`)。檔案被 strip 時回傳 None。
pub fn find_symbol(d: &[u8], name: &str) -> Option<u64> {
    let shoff = u64le(d, 40).ok()? as usize;
    let shentsize = u16le(d, 58).ok()? as usize;
    let shnum = u16le(d, 60).ok()? as usize;
    for i in 0..shnum {
        let sh = shoff + i * shentsize;
        if u32le(d, sh + 4).ok()? != 2 {
            continue; // 不是 SHT_SYMTAB
        }
        let sym_off = u64le(d, sh + 24).ok()? as usize;
        let sym_size = u64le(d, sh + 32).ok()? as usize;
        let link = u32le(d, sh + 40).ok()? as usize;
        let str_sh = shoff + link * shentsize;
        let str_off = u64le(d, str_sh + 24).ok()? as usize;
        for j in 0..sym_size / 24 {
            let sym = sym_off + j * 24;
            let name_off = str_off + u32le(d, sym).ok()? as usize;
            let bytes = d.get(name_off..)?;
            let end = bytes.iter().position(|&b| b == 0)?;
            if &bytes[..end] == name.as_bytes() {
                return u64le(d, sym + 8).ok();
            }
        }
    }
    None
}
