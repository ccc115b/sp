//! 系統匯流排:單一平坦的 DRAM 視窗 + 主控台輸出。
//!
//! spike0 刻意採用「pk 的模型」:沒有 UART / CLINT / test finisher 等
//! MMIO 週邊,使用者程式的輸出入一律透過 ecall 系統呼叫(syscall.rs)。
//!
//! 真實 spike 有多層記憶體(0x1000 boot ROM、0x8000_0000 pk、程式被 pk
//! 載到低位址 0x10000、堆疊在高位址...)。spike0 把它簡化成一個可調整
//! 起點的平坦視窗,足以容納工具鏈預設連結位址(0x10000)到堆疊為止。

use std::io::Write;

/// 真實 spike 的 DRAM 起點(僅作預設參考)
pub const DRAM_BASE: u64 = 0x8000_0000;

pub struct Bus {
    /// 這個平坦視窗的起始實體位址
    pub base: u64,
    pub dram: Vec<u8>,
    /// 主控台是否即時回顯(否則把輸出收集到 captured,方便測試)
    pub echo: bool,
    pub captured: Vec<u8>,
}

impl Bus {
    /// 建立涵蓋 [base, base+size) 的記憶體。
    pub fn new(base: u64, size: usize, echo: bool) -> Self {
        Bus {
            base,
            dram: vec![0; size],
            echo,
            captured: Vec::new(),
        }
    }

    fn in_range(&self, addr: u64, size: u64) -> Option<usize> {
        if addr < self.base {
            return None;
        }
        let off = (addr - self.base) as usize;
        let end = off.checked_add(size as usize)?;
        if end > self.dram.len() {
            return None;
        }
        Some(off)
    }

    pub fn load_image(&mut self, addr: u64, data: &[u8]) -> Result<(), String> {
        let end = addr.checked_add(data.len() as u64).ok_or("位址溢位")?;
        if addr < self.base || end > self.base + self.dram.len() as u64 {
            return Err(format!(
                "映像檔 [{:#x}, {:#x}) 超出記憶體範圍 [{:#x}, {:#x}),請用 -m 增加記憶體",
                addr,
                end,
                self.base,
                self.base + self.dram.len() as u64
            ));
        }
        let off = (addr - self.base) as usize;
        self.dram[off..off + data.len()].copy_from_slice(data);
        Ok(())
    }

    pub fn load(&self, addr: u64, size: u64) -> Option<u64> {
        let off = self.in_range(addr, size)?;
        let mut v = 0u64;
        for i in 0..size as usize {
            v |= (self.dram[off + i] as u64) << (8 * i);
        }
        Some(v)
    }

    pub fn store(&mut self, addr: u64, size: u64, val: u64) -> Option<()> {
        let off = self.in_range(addr, size)?;
        for i in 0..size as usize {
            self.dram[off + i] = (val >> (8 * i)) as u8;
        }
        Some(())
    }

    /// 記憶體上界(不含),可用來放堆疊/堆積。
    pub fn top(&self) -> u64 {
        self.base + self.dram.len() as u64
    }

    pub fn read_bytes(&self, addr: u64, len: u64) -> Vec<u8> {
        let mut out = Vec::with_capacity(len as usize);
        for i in 0..len {
            out.push(self.load(addr.wrapping_add(i), 1).unwrap_or(0) as u8);
        }
        out
    }

    pub fn write_console(&mut self, bytes: &[u8]) {
        if self.echo {
            let mut out = std::io::stdout();
            let _ = out.write_all(bytes);
            let _ = out.flush();
        } else {
            self.captured.extend_from_slice(bytes);
        }
    }
}
