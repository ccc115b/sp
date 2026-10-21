//! PLIC(平台層級中斷控制器),單 hart:context 0 = M-mode,context 1 = S-mode。
//! 暫存器配置與 QEMU `virt` 相同(priority / pending / enable / threshold / claim-complete)。

pub struct Plic {
    priority: [u32; 64],
    pending: u64,
    inflight: u64, // 已被 claim 但尚未 complete 的來源
    enable: [u64; 2],
    threshold: [u32; 2],
    out: [bool; 2], // 快取:各 context 是否有中斷要送給 CPU
}

impl Plic {
    pub fn new() -> Self {
        Plic { priority: [0; 64], pending: 0, inflight: 0, enable: [0; 2], threshold: [0; 2], out: [false; 2] }
    }

    fn recompute(&mut self) {
        for c in 0..2 {
            self.out[c] = self.best(c).is_some();
        }
    }

    /// 裝置回報中斷線的準位(level-triggered)。
    pub fn set_level(&mut self, src: usize, level: bool) {
        let bit = 1u64 << src;
        let old = self.pending;
        if level {
            if self.inflight & bit == 0 {
                self.pending |= bit;
            }
        } else {
            self.pending &= !bit;
        }
        if self.pending != old {
            self.recompute();
        }
    }

    fn best(&self, ctx: usize) -> Option<usize> {
        let mut best: Option<(u32, usize)> = None;
        for s in 1..64 {
            let bit = 1u64 << s;
            let p = self.priority[s];
            if self.pending & bit != 0 && self.enable[ctx] & bit != 0 && p > self.threshold[ctx] {
                if best.map_or(true, |(bp, _)| p > bp) {
                    best = Some((p, s));
                }
            }
        }
        best.map(|(_, s)| s)
    }

    /// 這個 context 是否有中斷要送給 CPU(對應 MEIP / SEIP)。
    pub fn ctx_pending(&self, ctx: usize) -> bool {
        self.out[ctx]
    }

    fn claim(&mut self, ctx: usize) -> u32 {
        match self.best(ctx) {
            Some(s) => {
                self.pending &= !(1u64 << s);
                self.inflight |= 1u64 << s;
                self.recompute();
                s as u32
            }
            None => 0,
        }
    }

    pub fn read(&mut self, off: u64) -> u64 {
        match off {
            0..=0xfff => *self.priority.get((off / 4) as usize).unwrap_or(&0) as u64,
            0x1000..=0x107f => ((self.pending >> (32 * ((off - 0x1000) / 4))) & 0xffff_ffff) as u64,
            0x2000..=0x20ff => {
                let ctx = ((off - 0x2000) / 0x80) as usize;
                let w = ((off - 0x2000) % 0x80) / 4;
                if ctx < 2 && w < 2 { (self.enable[ctx] >> (32 * w)) & 0xffff_ffff } else { 0 }
            }
            0x20_0000..=0x20_1fff => {
                let ctx = ((off - 0x20_0000) / 0x1000) as usize;
                match (off - 0x20_0000) % 0x1000 {
                    0 if ctx < 2 => self.threshold[ctx] as u64,
                    4 if ctx < 2 => self.claim(ctx) as u64,
                    _ => 0,
                }
            }
            _ => 0,
        }
    }

    pub fn write(&mut self, off: u64, val: u64) {
        self.write_reg(off, val);
        self.recompute();
    }

    fn write_reg(&mut self, off: u64, val: u64) {
        let v = val as u32;
        match off {
            0..=0xfff => {
                if let Some(p) = self.priority.get_mut((off / 4) as usize) {
                    *p = v & 7;
                }
            }
            0x2000..=0x20ff => {
                let ctx = ((off - 0x2000) / 0x80) as usize;
                let w = ((off - 0x2000) % 0x80) / 4;
                if ctx < 2 && w < 2 {
                    let sh = 32 * w;
                    self.enable[ctx] = (self.enable[ctx] & !(0xffff_ffffu64 << sh)) | ((v as u64) << sh);
                    self.enable[ctx] &= !1; // 來源 0 不存在
                }
            }
            0x20_0000..=0x20_1fff => {
                let ctx = ((off - 0x20_0000) / 0x1000) as usize;
                match (off - 0x20_0000) % 0x1000 {
                    0 if ctx < 2 => self.threshold[ctx] = v & 7,
                    4 if ctx < 2 => {
                        // complete
                        if v < 64 {
                            self.inflight &= !(1u64 << v);
                        }
                    }
                    _ => {}
                }
            }
            _ => {}
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn claim_complete_flow() {
        let mut p = Plic::new();
        p.write(4 * 10, 1); // priority[10] = 1
        p.write(0x2080, 1 << 10); // context 1(S-mode)啟用來源 10
        p.set_level(10, true);
        assert!(p.ctx_pending(1) && !p.ctx_pending(0));
        assert_eq!(p.read(0x20_1004), 10); // claim
        assert!(!p.ctx_pending(1)); // 已被 claim,不再重複送出
        p.set_level(10, true); // 裝置還在要求中斷,但尚未 complete
        assert!(!p.ctx_pending(1));
        p.write(0x20_1004, 10); // complete
        p.set_level(10, true);
        assert!(p.ctx_pending(1));
        p.write(0x20_1000, 1); // threshold = 1 → priority 1 被遮蔽
        assert!(!p.ctx_pending(1));
    }
}
