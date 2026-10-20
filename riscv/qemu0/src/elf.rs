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

/// 載入 ELF 並回傳進入點。
pub fn load(d: &[u8], bus: &mut Bus) -> Result<u64, String> {
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
    let phoff = u64le(d, 32)? as usize;
    let phentsize = u16le(d, 54)? as usize;
    let phnum = u16le(d, 56)? as usize;
    for i in 0..phnum {
        let ph = phoff + i * phentsize;
        if u32le(d, ph)? != 1 {
            continue; // 不是 PT_LOAD
        }
        let off = u64le(d, ph + 8)? as usize;
        let paddr = u64le(d, ph + 24)?;
        let filesz = u64le(d, ph + 32)? as usize;
        let seg = d.get(off..off + filesz).ok_or("區段超出檔案範圍")?;
        bus.load_image(paddr, seg)?;
        // memsz > filesz 的部分(.bss)已由 DRAM 初始為 0。
    }
    Ok(entry)
}
