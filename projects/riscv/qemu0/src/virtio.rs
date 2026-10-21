//! virtio-mmio(version 2 / modern)區塊裝置。直接對 DRAM 做 DMA。
//! 暫存器與 vring 格式依 virtio 1.x 規格,可被 xv6 與 Linux 的驅動使用。

use std::fs::{File, OpenOptions};
use std::os::unix::fs::FileExt;

const NUM_MAX: u32 = 16;

pub struct VirtioBlk {
    disk: Vec<u8>,
    file: Option<File>,
    dev_feat_sel: u32,
    drv_feat_sel: u32,
    status: u32,
    queue_sel: u32,
    queue_num: u32,
    ready: bool,
    desc: u64,
    avail: u64,
    used: u64,
    last_avail: u16,
    int_status: u32,
}

impl VirtioBlk {
    pub fn new() -> Self {
        VirtioBlk {
            disk: Vec::new(), file: None, dev_feat_sel: 0, drv_feat_sel: 0, status: 0, queue_sel: 0,
            queue_num: 0, ready: false, desc: 0, avail: 0, used: 0, last_avail: 0, int_status: 0,
        }
    }

    /// 掛上磁碟映像。寫入會即時寫回檔案(與 QEMU 預設行為相同)。
    pub fn attach(&mut self, path: &str) -> Result<(), String> {
        let f = OpenOptions::new().read(true).write(true).open(path).map_err(|e| format!("無法開啟磁碟映像 {path}: {e}"))?;
        self.disk = std::fs::read(path).map_err(|e| format!("無法讀取 {path}: {e}"))?;
        self.file = Some(f);
        Ok(())
    }

    pub fn attached(&self) -> bool {
        self.file.is_some()
    }

    pub fn irq(&self) -> bool {
        self.int_status != 0
    }

    fn reset(&mut self) {
        self.status = 0;
        self.ready = false;
        self.queue_num = 0;
        self.last_avail = 0;
        self.int_status = 0;
    }

    pub fn read(&self, off: u64) -> u64 {
        let cap = (self.disk.len() / 512) as u64;
        (match off {
            0x000 => 0x7472_6976,
            0x004 => 2,
            0x008 => if self.attached() { 2 } else { 0 }, // 2 = block;0 = 沒有裝置
            0x00c => 0x554d_4551,
            0x010 => if self.dev_feat_sel == 1 { 1 } else { 0 }, // VIRTIO_F_VERSION_1
            0x034 => NUM_MAX as u64,
            0x044 => self.ready as u64,
            0x060 => self.int_status as u64,
            0x070 => self.status as u64,
            0x0fc => 0,
            0x100 => cap & 0xffff_ffff,
            0x104 => cap >> 32,
            _ => 0,
        }) & 0xffff_ffff
    }

    /// 回傳 true 代表驅動按了 QueueNotify,呼叫端要接著呼叫 process()。
    pub fn write(&mut self, off: u64, val: u64) -> bool {
        let v = val as u32;
        let set_lo = |x: &mut u64, v: u32| *x = (*x & !0xffff_ffff) | v as u64;
        let set_hi = |x: &mut u64, v: u32| *x = (*x & 0xffff_ffff) | ((v as u64) << 32);
        match off {
            0x014 => self.dev_feat_sel = v,
            0x024 => self.drv_feat_sel = v,
            0x030 => self.queue_sel = v,
            0x038 => self.queue_num = v.min(NUM_MAX),
            0x044 => self.ready = v & 1 != 0 && self.queue_sel == 0,
            0x050 => return v == 0 && self.ready,
            0x064 => self.int_status &= !v,
            0x070 => {
                if v == 0 { self.reset() } else { self.status = v }
            }
            0x080 => set_lo(&mut self.desc, v),
            0x084 => set_hi(&mut self.desc, v),
            0x090 => set_lo(&mut self.avail, v),
            0x094 => set_hi(&mut self.avail, v),
            0x0a0 => set_lo(&mut self.used, v),
            0x0a4 => set_hi(&mut self.used, v),
            _ => {}
        }
        false
    }

    /// 處理 avail ring 中所有新請求,並更新 used ring 與中斷狀態。
    pub fn process(&mut self, dram: &mut [u8], base: u64) {
        let n = self.queue_num as u64;
        if !self.ready || n == 0 {
            return;
        }
        loop {
            let Some(avail_idx) = rd16(dram, base, self.avail + 2) else { return };
            if avail_idx == self.last_avail {
                break;
            }
            let slot = (self.last_avail as u64) % n;
            let Some(head) = rd16(dram, base, self.avail + 4 + 2 * slot) else { return };

            // 走訪 descriptor chain:(addr, len, flags)
            let mut chain: Vec<(u64, u32, u16)> = Vec::new();
            let mut i = head as u64;
            for _ in 0..NUM_MAX {
                let d = self.desc + 16 * i;
                let (Some(addr), Some(len), Some(flags), Some(next)) =
                    (rd64(dram, base, d), rd32(dram, base, d + 8), rd16(dram, base, d + 12), rd16(dram, base, d + 14))
                else { return };
                chain.push((addr, len, flags));
                if flags & 1 == 0 {
                    break;
                }
                i = next as u64;
            }

            let mut status = 0u8; // 0 OK, 1 IOERR, 2 UNSUPP
            let mut written = 0u32;
            if chain.len() >= 3 {
                let (hdr, _, _) = chain[0];
                let ty = rd32(dram, base, hdr).unwrap_or(u32::MAX);
                let mut off = rd64(dram, base, hdr + 8).unwrap_or(u64::MAX).wrapping_mul(512);
                match ty {
                    0 | 1 => {
                        for &(addr, len, _) in &chain[1..chain.len() - 1] {
                            let (o, l) = (off as usize, len as usize);
                            let a = addr.wrapping_sub(base) as usize;
                            let ok = o.checked_add(l).map_or(false, |e| e <= self.disk.len())
                                && a.checked_add(l).map_or(false, |e| e <= dram.len());
                            if !ok {
                                status = 1;
                                break;
                            }
                            if ty == 0 {
                                dram[a..a + l].copy_from_slice(&self.disk[o..o + l]);
                                written += len;
                            } else {
                                self.disk[o..o + l].copy_from_slice(&dram[a..a + l]);
                                if let Some(f) = &self.file {
                                    let _ = f.write_at(&self.disk[o..o + l], off);
                                }
                            }
                            off += len as u64;
                        }
                    }
                    4 => {} // FLUSH
                    _ => status = 2,
                }
                let (saddr, _, _) = chain[chain.len() - 1];
                if let Some(b) = (saddr.checked_sub(base)).and_then(|a| dram.get_mut(a as usize)) {
                    *b = status;
                    written += 1;
                }
            }

            // used ring:{id u32, len u32}
            let Some(uidx) = rd16(dram, base, self.used + 2) else { return };
            let e = self.used + 4 + 8 * ((uidx as u64) % n);
            wr32(dram, base, e, head as u32);
            wr32(dram, base, e + 4, written);
            wr16(dram, base, self.used + 2, uidx.wrapping_add(1));
            self.last_avail = self.last_avail.wrapping_add(1);
            self.int_status |= 1;
        }
    }
}

fn slice(dram: &[u8], base: u64, addr: u64, n: usize) -> Option<&[u8]> {
    let o = addr.checked_sub(base)? as usize;
    dram.get(o..o.checked_add(n)?)
}
fn rd16(d: &[u8], b: u64, a: u64) -> Option<u16> { slice(d, b, a, 2).map(|s| u16::from_le_bytes(s.try_into().unwrap())) }
fn rd32(d: &[u8], b: u64, a: u64) -> Option<u32> { slice(d, b, a, 4).map(|s| u32::from_le_bytes(s.try_into().unwrap())) }
fn rd64(d: &[u8], b: u64, a: u64) -> Option<u64> { slice(d, b, a, 8).map(|s| u64::from_le_bytes(s.try_into().unwrap())) }
fn wr(d: &mut [u8], b: u64, a: u64, v: &[u8]) {
    if let Some(o) = a.checked_sub(b) {
        let o = o as usize;
        if let Some(s) = d.get_mut(o..o + v.len()) {
            s.copy_from_slice(v);
        }
    }
}
fn wr16(d: &mut [u8], b: u64, a: u64, v: u16) { wr(d, b, a, &v.to_le_bytes()) }
fn wr32(d: &mut [u8], b: u64, a: u64, v: u32) { wr(d, b, a, &v.to_le_bytes()) }
