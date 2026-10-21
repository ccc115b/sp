//! 系統匯流排與週邊:DRAM、UART、CLINT、測試結束裝置。
//!
//! 記憶體配置(刻意與 QEMU `virt` 機器相近):
//!   0x0010_0000  test finisher(寫 0x5555 = 成功結束)
//!   0x0200_0000  CLINT(msip / mtimecmp / mtime)
//!   0x0c00_0000  PLIC(UART = IRQ 10,virtio = IRQ 1)
//!   0x1000_0000  UART(16550:收發、FIFO 旗標、IER / ISR 中斷)
//!   0x1000_1000  virtio-mmio 區塊裝置
//!   0x8000_0000  DRAM

use crate::plic::Plic;
use crate::virtio::VirtioBlk;
use std::collections::VecDeque;
use std::io::{Read, Write};
use std::sync::atomic::AtomicBool;
use std::sync::mpsc::{channel, Receiver};

/// Ctrl-A r 設定這個旗標,主迴圈看到後傾印暫存器(除錯用)。
pub static DUMP_REQUEST: AtomicBool = AtomicBool::new(false);

pub const DRAM_BASE: u64 = 0x8000_0000;
pub const UART_BASE: u64 = 0x1000_0000;
pub const UART_SIZE: u64 = 0x100;
pub const TEST_BASE: u64 = 0x10_0000;
pub const TEST_SIZE: u64 = 0x1000;
pub const CLINT_BASE: u64 = 0x0200_0000;
pub const CLINT_SIZE: u64 = 0x1_0000;
pub const PLIC_BASE: u64 = 0x0c00_0000;
pub const PLIC_SIZE: u64 = 0x400_0000;
pub const VIRTIO_BASE: u64 = 0x1000_1000;
pub const VIRTIO_SIZE: u64 = 0x1000;
pub const IRQ_VIRTIO: usize = 1;
pub const IRQ_UART: usize = 10;

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
    ier: u8,
    lcr: u8,
    dll: u8,
    dlh: u8,
    mcr: u8,
    thre_pending: bool,
    rx: VecDeque<u8>,
    stdin_rx: Option<Receiver<u8>>,
}

impl Uart {
    fn new(echo: bool) -> Self {
        Uart { echo, captured: Vec::new(), ier: 0, lcr: 0, dll: 0, dlh: 0, mcr: 0, thre_pending: false, rx: VecDeque::new(), stdin_rx: None }
    }

    /// 從外部餵入 UART 接收資料(測試用)。
    pub fn push_input(&mut self, data: &[u8]) {
        self.rx.extend(data.iter().copied());
    }

    /// 啟動背景執行緒讀取 stdin。按 Ctrl-A 再按 x 可結束 qemu0(與 QEMU 相同)。
    pub fn enable_stdin(&mut self) {
        let (tx, rx) = channel();
        self.stdin_rx = Some(rx);
        std::thread::spawn(move || {
            let mut buf = [0u8; 1];
            let mut ctrl_a = false;
            let mut stdin = std::io::stdin();
            while let Ok(1) = stdin.read(&mut buf) {
                let b = buf[0];
                if ctrl_a {
                    ctrl_a = false;
                    if b == b'x' {
                        eprintln!("\r\n[qemu0] Ctrl-A x:結束");
                        std::process::exit(0);
                    }
                    if b == b'r' {
                        DUMP_REQUEST.store(true, std::sync::atomic::Ordering::Relaxed);
                        continue;
                    }
                    if b != 1 && tx.send(1).is_err() {
                        break;
                    }
                } else if b == 1 {
                    ctrl_a = true;
                    continue;
                }
                if tx.send(b).is_err() {
                    break;
                }
            }
        });
    }

    fn poll(&mut self) {
        if let Some(r) = &self.stdin_rx {
            while let Ok(b) = r.try_recv() {
                self.rx.push_back(b);
            }
        }
    }

    fn irq(&self) -> bool {
        (self.ier & 1 != 0 && !self.rx.is_empty()) || (self.ier & 2 != 0 && self.thre_pending)
    }

    fn read(&mut self, off: u64) -> u64 {
        let dlab = self.lcr & 0x80 != 0;
        (match off {
            0 => if dlab { self.dll } else { self.rx.pop_front().unwrap_or(0) },
            1 => if dlab { self.dlh } else { self.ier },
            2 => {
                // ISR:RX 資料優先,其次 THR 空;讀取會清除 THRE 中斷
                if self.ier & 1 != 0 && !self.rx.is_empty() {
                    0xc4
                } else if self.ier & 2 != 0 && self.thre_pending {
                    self.thre_pending = false;
                    0xc2
                } else {
                    0xc1
                }
            }
            3 => self.lcr,
            4 => self.mcr,
            5 => 0x60 | (!self.rx.is_empty() as u8), // THR 空、傳送器空、RX 就緒
            6 => 0xb0,
            _ => 0,
        }) as u64
    }

    fn write(&mut self, off: u64, val: u64) {
        let v = val as u8;
        let dlab = self.lcr & 0x80 != 0;
        match off {
            0 if dlab => self.dll = v,
            0 => {
                if self.echo {
                    let mut out = std::io::stdout();
                    let _ = out.write_all(&[v]);
                    let _ = out.flush();
                } else {
                    self.captured.push(v);
                }
                self.thre_pending = true; // 字元立即送出,THR 隨即變空
            }
            1 if dlab => self.dlh = v,
            1 => {
                self.ier = v & 0x0f;
                if self.ier & 2 != 0 {
                    self.thre_pending = true; // 開啟 TX 中斷時 THR 本來就是空的
                }
            }
            2 => {
                if v & 2 != 0 {
                    self.rx.clear();
                }
            }
            3 => self.lcr = v,
            4 => self.mcr = v,
            _ => {}
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
    pub plic: Plic,
    pub virtio: VirtioBlk,
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
            uart: Uart::new(echo),
            clint: Clint { msip: 0, mtimecmp: u64::MAX, mtime: 0 },
            plic: Plic::new(),
            virtio: VirtioBlk::new(),
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

    /// 週期性呼叫:收集 stdin、更新各裝置送給 PLIC 的中斷線準位。
    pub fn poll(&mut self) {
        self.uart.poll();
        self.plic.set_level(IRQ_UART, self.uart.irq());
        self.plic.set_level(IRQ_VIRTIO, self.virtio.irq());
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
            let d = &self.dram[off..end];
            let v = match size {
                4 => u32::from_le_bytes(d.try_into().unwrap()) as u64,
                8 => u64::from_le_bytes(d.try_into().unwrap()),
                1 => d[0] as u64,
                2 => u16::from_le_bytes(d.try_into().unwrap()) as u64,
                _ => d.iter().enumerate().fold(0u64, |a, (i, &x)| a | (x as u64) << (8 * i)),
            };
            return Some(v);
        }
        if (UART_BASE..UART_BASE + UART_SIZE).contains(&addr) {
            return Some(self.uart.read(addr - UART_BASE));
        }
        if (CLINT_BASE..CLINT_BASE + CLINT_SIZE).contains(&addr) {
            return Some(self.clint.read(addr - CLINT_BASE, size));
        }
        if (PLIC_BASE..PLIC_BASE + PLIC_SIZE).contains(&addr) {
            return Some(self.plic.read(addr - PLIC_BASE));
        }
        if (VIRTIO_BASE..VIRTIO_BASE + VIRTIO_SIZE).contains(&addr) {
            return Some(self.virtio.read(addr - VIRTIO_BASE));
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
            self.dram[off..end].copy_from_slice(&val.to_le_bytes()[..size as usize]);
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
        if (PLIC_BASE..PLIC_BASE + PLIC_SIZE).contains(&addr) {
            self.plic.write(addr - PLIC_BASE, val);
            return Some(());
        }
        if (VIRTIO_BASE..VIRTIO_BASE + VIRTIO_SIZE).contains(&addr) {
            if self.virtio.write(addr - VIRTIO_BASE, val) {
                self.virtio.process(&mut self.dram, self.dram_base);
            }
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

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn uart_divisor_latch_does_not_print_and_thre_irq_clears_on_isr() {
        let mut b = Bus::new(1 << 20, false);
        b.store(UART_BASE + 3, 1, 0x80); // DLAB
        b.store(UART_BASE, 1, 3); // 除數,不是字元
        b.store(UART_BASE + 3, 1, 3);
        assert!(b.uart.captured.is_empty());
        b.store(UART_BASE + 1, 1, 0x03); // IER: RX + TX
        assert!(b.uart.irq()); // THR 為空 → TX 中斷
        assert_eq!(b.load(UART_BASE + 2, 1), Some(0xc2)); // ISR:THRE,讀取後清除
        assert!(!b.uart.irq());
        b.store(UART_BASE, 1, b'A' as u64);
        assert_eq!(b.uart.captured, b"A");
        b.uart.push_input(b"x");
        assert_eq!(b.load(UART_BASE + 5, 1).unwrap() & 1, 1); // LSR: RX ready
        assert_eq!(b.load(UART_BASE, 1), Some(b'x' as u64));
        assert_eq!(b.load(UART_BASE + 5, 1).unwrap() & 1, 0);
    }

    #[test]
    fn virtio_blk_read_request_via_dma() {
        use std::io::Write;
        let path = std::env::temp_dir().join("qemu0_virtio_test.img");
        let mut img = vec![0u8; 4096];
        img[512..520].copy_from_slice(b"SECTOR-1");
        std::fs::File::create(&path).unwrap().write_all(&img).unwrap();

        let mut b = Bus::new(1 << 20, false);
        b.virtio.attach(path.to_str().unwrap()).unwrap();
        assert_eq!(b.load(VIRTIO_BASE + 8, 4), Some(2)); // device id = block
        assert_eq!(b.load(VIRTIO_BASE + 0x100, 4), Some(8)); // 容量 8 個磁區
        let (desc, avail, used) = (DRAM_BASE + 0x1000, DRAM_BASE + 0x2000, DRAM_BASE + 0x3000);
        let (hdr, buf, st) = (DRAM_BASE + 0x4000, DRAM_BASE + 0x5000, DRAM_BASE + 0x6000);
        for (reg, v) in [(0x38, 8), (0x80, desc), (0x90, avail), (0xa0, used), (0x44, 1)] {
            b.store(VIRTIO_BASE + reg, 4, v);
        }
        // header:type=0(讀)、sector=1
        b.store(hdr, 4, 0);
        b.store(hdr + 8, 8, 1);
        for (i, (addr, len, flags, next)) in
            [(hdr, 16u64, 1u64, 1u64), (buf, 512, 1 | 2, 2), (st, 1, 2, 0)].into_iter().enumerate()
        {
            let d = desc + 16 * i as u64;
            b.store(d, 8, addr);
            b.store(d + 8, 4, len);
            b.store(d + 12, 2, flags);
            b.store(d + 14, 2, next);
        }
        b.store(avail + 4, 2, 0); // ring[0] = 描述子 0
        b.store(avail + 2, 2, 1); // idx = 1
        b.store(VIRTIO_BASE + 0x50, 4, 0); // QueueNotify
        assert_eq!(b.dram[0x5000..0x5008], *b"SECTOR-1");
        assert_eq!(b.dram[0x6000], 0); // status OK
        assert_eq!(b.load(used + 2, 2), Some(1)); // used.idx
        assert!(b.virtio.irq());
        b.store(VIRTIO_BASE + 0x64, 4, 1); // ACK
        assert!(!b.virtio.irq());
        let _ = std::fs::remove_file(path);
    }
}
