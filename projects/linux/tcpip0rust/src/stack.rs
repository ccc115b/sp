//! stack — 把所有網路狀態收在一個 struct，資料面單執行緒，borrow checker 友善
use crate::arp::ArpState;
use crate::netdev::NetDev;
use crate::tcp::{self, TcpState};

pub struct Stack {
    pub nd: NetDev,
    pub arp: ArpState,
    pub tcp: TcpState,
}

impl Stack {
    pub fn new(nd: NetDev) -> Stack {
        Stack { nd, arp: ArpState::default(), tcp: TcpState::new() }
    }

    /// 每個 timer tick：ARP 補送 + TCP 重傳
    pub fn tick(&mut self) {
        self.arp.tick(&mut self.nd);
        tcp::tick(self);
    }
}

/// 把 &mut Stack 拆成 (&mut nd, &mut arp) 的等價借用（同時存取兩個欄位）
pub fn split_arp(st: &mut Stack) -> (&mut NetDev, &mut ArpState) {
    (&mut st.nd, &mut st.arp)
}
