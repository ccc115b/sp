// RV32I 虛擬機。記憶體 128KB 位於 0x0；MMIO 位於 0x1000_0000：
// 00 DIR | 04 OUT | 08 IN | 10+4*n PWM(n=0..7) | 40+4*n ADC(n=0..3)
// 80 UART_TX | 90 MICROS(唯讀) | 94 SLEEP_MS(寫入後暫停)
const RAM: usize = 128 * 1024;
const IO: u32 = 0x1000_0000;
struct Vm { x:[u32;32], pc:u32, ram:[u8;RAM], dir:u32, out:u32, inp:u32, pwm:[u32;8], adc:[u32;4],
            us:u32, wake:u32, sleeping:bool, halted:bool, tx:Vec<u8>, txh:usize }
static mut VM: Vm = Vm{ x:[0;32], pc:0, ram:[0;RAM], dir:0, out:0, inp:0, pwm:[0;8], adc:[0;4],
                        us:0, wake:0, sleeping:false, halted:false, tx:Vec::new(), txh:0 };
fn vm() -> &'static mut Vm { unsafe { &mut *core::ptr::addr_of_mut!(VM) } }

impl Vm {
    fn ld(&mut self, a:u32, n:usize) -> u32 {
        if a >= IO { return match a - IO {
            4 => self.out, 8 => (self.inp & !self.dir) | (self.out & self.dir), 0 => self.dir,
            0x10..=0x2c => self.pwm[((a-IO-0x10)/4) as usize],
            0x40..=0x4c => self.adc[((a-IO-0x40)/4) as usize],
            0x90 => self.us, _ => 0 } }
        let a = a as usize;
        if a + n > RAM { self.halted = true; return 0 }
        let mut v = 0u32; for i in 0..n { v |= (self.ram[a+i] as u32) << (8*i) } v
    }
    fn st(&mut self, a:u32, v:u32, n:usize) {
        if a >= IO { match a - IO {
            0 => self.dir = v,
            4 => { let c = self.out ^ v; for i in 0..8 { if (c>>i)&1 == 1 { self.pwm[i] = 0 } } self.out = v }
            0x10..=0x2c => self.pwm[((a-IO-0x10)/4) as usize] = v,
            0x80 => self.tx.push(v as u8),
            0x94 => { self.wake = self.us.wrapping_add(v.wrapping_mul(1000)); self.sleeping = true }
            _ => {} } return }
        let a = a as usize;
        if a + n > RAM { self.halted = true; return }
        for i in 0..n { self.ram[a+i] = (v >> (8*i)) as u8 }
    }
    fn step(&mut self) {
        let pc = self.pc; let i = self.ld(pc, 4);
        let op = i & 0x7f; let rd = ((i>>7)&31) as usize; let f3 = (i>>12)&7;
        let rs1 = self.x[((i>>15)&31) as usize]; let rs2 = self.x[((i>>20)&31) as usize];
        let imi = ((i as i32) >> 20) as u32;
        let alt = (i>>30)&1 == 1;
        let mut npc = pc.wrapping_add(4); let mut r: Option<u32> = None;
        match op {
            0x37 => r = Some(i & 0xffff_f000),
            0x17 => r = Some(pc.wrapping_add(i & 0xffff_f000)),
            0x6f => { let imm = (((i as i32)>>31) as u32)<<20 | (i&0xff000) | ((i>>9)&0x800) | ((i>>20)&0x7fe);
                      r = Some(npc); npc = pc.wrapping_add(imm) }
            0x67 => { r = Some(npc); npc = rs1.wrapping_add(imi) & !1 }
            0x63 => { let imm = (((i as i32)>>31) as u32)<<12 | ((i&0x80)<<4) | ((i>>20)&0x7e0) | ((i>>7)&0x1e);
                      let t = match f3 { 0=>rs1==rs2, 1=>rs1!=rs2, 4=>(rs1 as i32)<(rs2 as i32),
                                         5=>(rs1 as i32)>=(rs2 as i32), 6=>rs1<rs2, _=>rs1>=rs2 };
                      if t { npc = pc.wrapping_add(imm) } }
            0x03 => { let a = rs1.wrapping_add(imi);
                      r = Some(match f3 { 0=>self.ld(a,1) as i8 as i32 as u32, 1=>self.ld(a,2) as i16 as i32 as u32,
                                          2=>self.ld(a,4), 4=>self.ld(a,1), _=>self.ld(a,2) }) }
            0x23 => { let imm = (((i as i32)>>25) as u32)<<5 | ((i>>7)&31);
                      self.st(rs1.wrapping_add(imm), rs2, 1usize << f3) }
            0x13 => { let sh = imi & 31;
                      r = Some(match f3 { 0=>rs1.wrapping_add(imi), 2=>((rs1 as i32)<(imi as i32)) as u32,
                          3=>(rs1<imi) as u32, 4=>rs1^imi, 6=>rs1|imi, 7=>rs1&imi, 1=>rs1<<sh,
                          _=> if alt {((rs1 as i32)>>sh) as u32} else {rs1>>sh} }) }
            0x33 => { let sh = rs2 & 31;
                      r = Some(match f3 { 0=> if alt {rs1.wrapping_sub(rs2)} else {rs1.wrapping_add(rs2)},
                          1=>rs1<<sh, 2=>((rs1 as i32)<(rs2 as i32)) as u32, 3=>(rs1<rs2) as u32, 4=>rs1^rs2,
                          5=> if alt {((rs1 as i32)>>sh) as u32} else {rs1>>sh}, 6=>rs1|rs2, _=>rs1&rs2 }) }
            0x0f => {}
            _ => self.halted = true, // ecall/ebreak/非法指令
        }
        if let Some(v) = r { if rd != 0 { self.x[rd] = v } }
        self.pc = npc;
    }
}
#[no_mangle] pub extern "C" fn ram_ptr() -> *mut u8 { vm().ram.as_mut_ptr() }
#[no_mangle] pub extern "C" fn reset(entry:u32) { let v = vm(); v.x=[0;32]; v.pc=entry; v.dir=0; v.out=0; v.pwm=[0;8];
    v.us=0; v.sleeping=false; v.halted=false; v.tx.clear(); v.txh=0 }
#[no_mangle] pub extern "C" fn run(n:u32) -> u32 { let v = vm();
    for _ in 0..n { if v.halted { break }
        if v.sleeping { if (v.us.wrapping_sub(v.wake) as i32) >= 0 { v.sleeping = false } else { break } }
        v.step() } v.halted as u32 }
#[no_mangle] pub extern "C" fn set_time(us:u32) { vm().us = us }
#[no_mangle] pub extern "C" fn set_in(m:u32) { vm().inp = m }
#[no_mangle] pub extern "C" fn set_adc(c:u32, v:u32) { if c < 4 { vm().adc[c as usize] = v } }
#[no_mangle] pub extern "C" fn get_out() -> u32 { vm().out }
#[no_mangle] pub extern "C" fn get_dir() -> u32 { vm().dir }
#[no_mangle] pub extern "C" fn get_pwm(i:u32) -> u32 { vm().pwm[(i & 7) as usize] }
#[no_mangle] pub extern "C" fn tx_pop() -> i32 { let v = vm();
    if v.txh < v.tx.len() { v.txh += 1; v.tx[v.txh-1] as i32 } else { v.tx.clear(); v.txh = 0; -1 } }
