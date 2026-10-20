//! 系統匯流排與週邊:DRAM、UART、CLINT、測試結束裝置。
//!
//! 記憶體配置(刻意與 QEMU `virt` 機器相近):
//!   0x0010_0000  test finisher(寫 0x5555 = 成功結束)
//!   0x0200_0000  CLINT(msip / mtimecmp / mtime)
//!   0x1000_0000  UART(只實作 THR 與 LSR)
//!   0x8000_0000  DRAM

use std::io::Write;

pub const DRAM_BASE: u64 = 0x8000_0000;
pub const UART_BASE: u64 = 0x1000_0000;
pub const UART_SIZE: u64 = 0x100;
pub const TEST_BASE: u64 = 0x10_0000;
pub const TEST_SIZE: u64 = 0x1000;
pub const CLINT_BASE: u64 = 0x0200_0000;
pub const CLINT_SIZE: u64 = 0x1_0000;

fn mask(size: u64) -> u64 {
    if size >= 8 {
        u64::MAX
    } else {
        (1u64 << (size * 8)) - 1
    }
}

pub struct Uart {
    echo: bool,
    pub captured: Vec<u8>,
}

impl Uart {
    fn read(&self, off: u64) -> u64 {
        match off {
            5 => 0x60, // LSR: THR 空、傳送器空
            _ => 0,
        }
    }
    fn write(&mut self, off: u64, val: u64) {
        if off == 0 {
            let b = val as u8;
            if self.echo {
                let mut out = std::io::stdout();
                let _ = out.write_all(&[b]);
                let _ = out.flush();
            } else {
                self.captured.push(b);
            }
        }
    }
}

pub struct Clint {
    pub msip: u32,
    pub mtimecmp: u64,
    pub mtime: u64,
}

impl Clint {
    fn read(&self, off: u64, size: u64) -> u64 {
        let (v, base) = match off {
            0..=3 => (self.msip as u64, 0),
            0x4000..=0x4007 => (self.mtimecmp, 0x4000),
            0xBFF8..=0xBFFF => (self.mtime, 0xBFF8),
            _ => return 0,
        };
        (v >> ((off - base) * 8)) & mask(size)
    }
    fn write(&mut self, off: u64, size: u64, val: u64) {
        let (old, base) = match off {
            0..=3 => (self.msip as u64, 0),
            0x4000..=0x4007 => (self.mtimecmp, 0x4000),
            0xBFF8..=0xBFFF => (self.mtime, 0xBFF8),
            _ => return,
        };
        let sh = (off - base) * 8;
        let m = mask(size) << sh;
        let new = (old & !m) | ((val << sh) & m);
        match base {
            0 => self.msip = new as u32,
            0x4000 => self.mtimecmp = new,
            _ => self.mtime = new,
        }
    }
}

pub struct Bus {
    pub dram: Vec<u8>,
    /// DRAM 起始位址。qemu0 固定 0x8000_0000;spike0 依 ELF 的 vaddr 動態決定。
    pub dram_base: u64,
    pub uart: Uart,
    pub clint: Clint,
    /// 由 test finisher 設定;主迴圈看到就結束模擬。
    pub exit: Option<i32>,
}

impl Bus {
    pub fn new(mem_bytes: usize, echo: bool) -> Self {
        Self::with_base(DRAM_BASE, mem_bytes, echo)
    }

    pub fn with_base(base: u64, mem_bytes: usize, echo: bool) -> Self {
        Bus {
            dram: vec![0; mem_bytes],
            dram_base: base,
            uart: Uart { echo, captured: Vec::new() },
            clint: Clint { msip: 0, mtimecmp: u64::MAX, mtime: 0 },
            exit: None,
        }
    }

    /// 把映像檔內容複製進 DRAM。
    pub fn load_image(&mut self, addr: u64, data: &[u8]) -> Result<(), String> {
        let end = addr.checked_add(data.len() as u64).ok_or("位址溢位")?;
        if addr < self.dram_base || end > self.dram_base + self.dram.len() as u64 {
            return Err(format!(
                "映像檔 [{:#x}, {:#x}) 超出 DRAM 範圍,請用 -m 增加記憶體",
                addr, end
            ));
        }
        let off = (addr - self.dram_base) as usize;
        self.dram[off..off + data.len()].copy_from_slice(data);
        Ok(())
    }

    /// 以 guest 位址取得 DRAM 內的唯讀位元組區段(user-mode 模擬用)。
    pub fn slice(&self, addr: u64, len: usize) -> Option<&[u8]> {
        let off = addr.checked_sub(self.dram_base)? as usize;
        self.dram.get(off..off.checked_add(len)?)
    }

    pub fn slice_mut(&mut self, addr: u64, len: usize) -> Option<&mut [u8]> {
        let off = addr.checked_sub(self.dram_base)? as usize;
        self.dram.get_mut(off..off.checked_add(len)?)
    }

    pub fn load(&mut self, addr: u64, size: u64) -> Option<u64> {
        if addr >= self.dram_base {
            let off = (addr - self.dram_base) as usize;
            let end = off.checked_add(size as usize)?;
            if end > self.dram.len() {
                return None;
            }
            let mut v = 0u64;
            for i in 0..size as usize {
                v |= (self.dram[off + i] as u64) << (8 * i);
            }
            return Some(v);
        }
        if (UART_BASE..UART_BASE + UART_SIZE).contains(&addr) {
            return Some(self.uart.read(addr - UART_BASE));
        }
        if (CLINT_BASE..CLINT_BASE + CLINT_SIZE).contains(&addr) {
            return Some(self.clint.read(addr - CLINT_BASE, size));
        }
        if (TEST_BASE..TEST_BASE + TEST_SIZE).contains(&addr) {
            return Some(0);
        }
        None
    }

    pub fn store(&mut self, addr: u64, size: u64, val: u64) -> Option<()> {
        if addr >= self.dram_base {
            let off = (addr - self.dram_base) as usize;
            let end = off.checked_add(size as usize)?;
            if end > self.dram.len() {
                return None;
            }
            for i in 0..size as usize {
                self.dram[off + i] = (val >> (8 * i)) as u8;
            }
            return Some(());
        }
        if (UART_BASE..UART_BASE + UART_SIZE).contains(&addr) {
            self.uart.write(addr - UART_BASE, val);
            return Some(());
        }
        if (CLINT_BASE..CLINT_BASE + CLINT_SIZE).contains(&addr) {
            self.clint.write(addr - CLINT_BASE, size, val);
            return Some(());
        }
        if (TEST_BASE..TEST_BASE + TEST_SIZE).contains(&addr) {
            let v = val & 0xffff;
            if v == 0x5555 || v == 0x7777 {
                self.exit = Some(0);
            } else if v == 0x3333 {
                let code = (val >> 16) as i32;
                self.exit = Some(if code == 0 { 1 } else { code });
            }
            return Some(());
        }
        None
    }
}
