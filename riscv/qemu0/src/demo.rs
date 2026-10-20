//! 內建的迷你組譯器(只有幾個編碼函式)與 demo 程式,
//! 讓 qemu0 在沒有 RISC-V 工具鏈時也能展示。

#[allow(dead_code)]
pub fn i_type(op: u32, f3: u32, rd: u32, rs1: u32, imm: i32) -> u32 {
    ((imm as u32 & 0xfff) << 20) | (rs1 << 15) | (f3 << 12) | (rd << 7) | op
}
#[allow(dead_code)]
pub fn r_type(f7: u32, rs2: u32, rs1: u32, f3: u32, rd: u32, op: u32) -> u32 {
    (f7 << 25) | (rs2 << 20) | (rs1 << 15) | (f3 << 12) | (rd << 7) | op
}
pub fn s_type(f3: u32, rs2: u32, rs1: u32, imm: i32) -> u32 {
    let i = imm as u32;
    (((i >> 5) & 0x7f) << 25) | (rs2 << 20) | (rs1 << 15) | (f3 << 12) | ((i & 0x1f) << 7) | 0x23
}
pub fn addi(rd: u32, rs1: u32, imm: i32) -> u32 { i_type(0x13, 0, rd, rs1, imm) }
pub fn lbu(rd: u32, rs1: u32, imm: i32) -> u32 { i_type(0x03, 4, rd, rs1, imm) }
pub fn sb(rs2: u32, rs1: u32, imm: i32) -> u32 { s_type(0, rs2, rs1, imm) }
pub fn sw(rs2: u32, rs1: u32, imm: i32) -> u32 { s_type(2, rs2, rs1, imm) }
pub fn lui(rd: u32, imm20: u32) -> u32 { (imm20 << 12) | (rd << 7) | 0x37 }
pub fn auipc(rd: u32, imm20: u32) -> u32 { (imm20 << 12) | (rd << 7) | 0x17 }
pub fn beq(rs1: u32, rs2: u32, off: i32) -> u32 {
    let i = off as u32;
    (((i >> 12) & 1) << 31) | (((i >> 5) & 0x3f) << 25) | (rs2 << 20) | (rs1 << 15)
        | (((i >> 1) & 0xf) << 8) | (((i >> 11) & 1) << 7) | 0x63
}
pub fn jal(rd: u32, off: i32) -> u32 {
    let i = off as u32;
    (((i >> 20) & 1) << 31) | (((i >> 1) & 0x3ff) << 21) | (((i >> 11) & 1) << 20)
        | (((i >> 12) & 0xff) << 12) | (rd << 7) | 0x6f
}

const ZERO: u32 = 0;
const T0: u32 = 5;
const T1: u32 = 6;
const A0: u32 = 10;
const A1: u32 = 11;
const A2: u32 = 12;

/// Hello World:逐字元寫到 UART,最後寫 test finisher 結束。
pub fn hello() -> Vec<u8> {
    let msg = b"Hello from qemu0!\n\0";
    let code = [
        auipc(A1, 0),          // a1 = pc
        addi(A1, A1, 52),      // a1 = &msg(第 13 個字)
        lui(A0, 0x10000),      // a0 = 0x1000_0000 (UART)
        lbu(T0, A1, 0),        // loop: t0 = *a1
        beq(T0, ZERO, 16),     //       if t0 == 0 goto done
        sb(T0, A0, 0),         //       *uart = t0
        addi(A1, A1, 1),       //       a1++
        jal(ZERO, -16),        //       goto loop
        lui(A2, 0x100),        // done: a2 = 0x10_0000 (test finisher)
        lui(T1, 5),
        addi(T1, T1, 0x555),   // t1 = 0x5555
        sw(T1, A2, 0),         // 結束
        jal(ZERO, 0),          // 自旋
    ];
    let mut out: Vec<u8> = code.iter().flat_map(|w| w.to_le_bytes()).collect();
    out.extend_from_slice(msg);
    out
}
