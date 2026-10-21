//! RV64C(壓縮指令)解碼:把 16 位元指令展開成等價的 32 位元指令,
//! 之後由同一個 execute() 執行。不含浮點的 C.FLD / C.FSD 等(沒有 F/D 擴充)。

fn bit(c: u16, i: u32) -> u32 {
    ((c >> i) & 1) as u32
}
fn bits(c: u16, hi: u32, lo: u32) -> u32 {
    ((c >> lo) as u32) & ((1 << (hi - lo + 1)) - 1)
}
fn sext(v: u32, n: u32) -> i32 {
    ((v << (32 - n)) as i32) >> (32 - n)
}

fn i_enc(imm: i32, rs1: u32, f3: u32, rd: u32, op: u32) -> u32 {
    (((imm as u32) & 0xfff) << 20) | (rs1 << 15) | (f3 << 12) | (rd << 7) | op
}
fn r_enc(f7: u32, rs2: u32, rs1: u32, f3: u32, rd: u32, op: u32) -> u32 {
    (f7 << 25) | (rs2 << 20) | (rs1 << 15) | (f3 << 12) | (rd << 7) | op
}
fn s_enc(imm: i32, rs2: u32, rs1: u32, f3: u32) -> u32 {
    let u = imm as u32;
    (((u >> 5) & 0x7f) << 25) | (rs2 << 20) | (rs1 << 15) | (f3 << 12) | ((u & 0x1f) << 7) | 0x23
}
fn b_enc(imm: i32, rs2: u32, rs1: u32, f3: u32) -> u32 {
    let u = imm as u32;
    (((u >> 12) & 1) << 31) | (((u >> 5) & 0x3f) << 25) | (rs2 << 20) | (rs1 << 15) | (f3 << 12)
        | (((u >> 1) & 0xf) << 8) | (((u >> 11) & 1) << 7) | 0x63
}
fn j_enc(imm: i32, rd: u32) -> u32 {
    let u = imm as u32;
    (((u >> 20) & 1) << 31) | (((u >> 1) & 0x3ff) << 21) | (((u >> 11) & 1) << 20)
        | (((u >> 12) & 0xff) << 12) | (rd << 7) | 0x6f
}

/// 展開一條 16 位元指令;非法或不支援時回傳 None。
pub fn expand(c: u16) -> Option<u32> {
    let rd = bits(c, 11, 7);
    let rs2 = bits(c, 6, 2);
    let rdp = bits(c, 4, 2) + 8; // rd' / rs2'
    let rs1p = bits(c, 9, 7) + 8; // rs1' / rd'(CA / CB 格式)
    let imm6 = sext((bit(c, 12) << 5) | bits(c, 6, 2), 6);
    let shamt = (bit(c, 12) << 5) | bits(c, 6, 2);

    Some(match (c & 3, c >> 13) {
        // ---- 象限 0 ----
        (0, 0) => {
            let imm = (bits(c, 12, 11) << 4) | (bits(c, 10, 7) << 6) | (bit(c, 6) << 2) | (bit(c, 5) << 3);
            if imm == 0 {
                return None; // 全 0 指令與 nzuimm=0 皆為非法
            }
            i_enc(imm as i32, 2, 0, rdp, 0x13) // C.ADDI4SPN
        }
        (0, 2) => i_enc(((bits(c, 12, 10) << 3) | (bit(c, 6) << 2) | (bit(c, 5) << 6)) as i32, rs1p, 2, rdp, 0x03), // C.LW
        (0, 3) => i_enc(((bits(c, 12, 10) << 3) | (bits(c, 6, 5) << 6)) as i32, rs1p, 3, rdp, 0x03), // C.LD
        (0, 6) => s_enc(((bits(c, 12, 10) << 3) | (bit(c, 6) << 2) | (bit(c, 5) << 6)) as i32, rdp, rs1p, 2), // C.SW
        (0, 7) => s_enc(((bits(c, 12, 10) << 3) | (bits(c, 6, 5) << 6)) as i32, rdp, rs1p, 3), // C.SD

        // ---- 象限 1 ----
        (1, 0) => i_enc(imm6, rd, 0, rd, 0x13), // C.ADDI / C.NOP
        (1, 1) => {
            if rd == 0 {
                return None;
            }
            i_enc(imm6, rd, 0, rd, 0x1b) // C.ADDIW
        }
        (1, 2) => i_enc(imm6, 0, 0, rd, 0x13), // C.LI
        (1, 3) => {
            if rd == 2 {
                // C.ADDI16SP
                let imm = sext(
                    (bit(c, 12) << 9) | (bit(c, 6) << 4) | (bit(c, 5) << 6) | (bits(c, 4, 3) << 7) | (bit(c, 2) << 5),
                    10,
                );
                if imm == 0 {
                    return None;
                }
                i_enc(imm, 2, 0, 2, 0x13)
            } else {
                // C.LUI
                if imm6 == 0 {
                    return None;
                }
                (((imm6 as u32) & 0xfffff) << 12) | (rd << 7) | 0x37
            }
        }
        (1, 4) => match bits(c, 11, 10) {
            0 => i_enc(shamt as i32, rs1p, 5, rs1p, 0x13),          // C.SRLI
            1 => i_enc((shamt | 0x400) as i32, rs1p, 5, rs1p, 0x13), // C.SRAI
            2 => i_enc(imm6, rs1p, 7, rs1p, 0x13),                  // C.ANDI
            _ => {
                let f = bits(c, 6, 5);
                if bit(c, 12) == 0 {
                    match f {
                        0 => r_enc(0x20, rdp, rs1p, 0, rs1p, 0x33), // C.SUB
                        1 => r_enc(0, rdp, rs1p, 4, rs1p, 0x33),    // C.XOR
                        2 => r_enc(0, rdp, rs1p, 6, rs1p, 0x33),    // C.OR
                        _ => r_enc(0, rdp, rs1p, 7, rs1p, 0x33),    // C.AND
                    }
                } else {
                    match f {
                        0 => r_enc(0x20, rdp, rs1p, 0, rs1p, 0x3b), // C.SUBW
                        1 => r_enc(0, rdp, rs1p, 0, rs1p, 0x3b),    // C.ADDW
                        _ => return None,
                    }
                }
            }
        },
        (1, 5) => {
            // C.J
            let imm = sext(
                (bit(c, 12) << 11) | (bit(c, 11) << 4) | (bits(c, 10, 9) << 8) | (bit(c, 8) << 10)
                    | (bit(c, 7) << 6) | (bit(c, 6) << 7) | (bits(c, 5, 3) << 1) | (bit(c, 2) << 5),
                12,
            );
            j_enc(imm, 0)
        }
        (1, f @ (6 | 7)) => {
            // C.BEQZ / C.BNEZ
            let imm = sext(
                (bit(c, 12) << 8) | (bits(c, 11, 10) << 3) | (bits(c, 6, 5) << 6) | (bits(c, 4, 3) << 1) | (bit(c, 2) << 5),
                9,
            );
            b_enc(imm, 0, rs1p, if f == 6 { 0 } else { 1 })
        }

        // ---- 象限 2 ----
        (2, 0) => i_enc(shamt as i32, rd, 1, rd, 0x13), // C.SLLI
        (2, 2) => {
            if rd == 0 {
                return None;
            }
            i_enc(((bit(c, 12) << 5) | (bits(c, 6, 4) << 2) | (bits(c, 3, 2) << 6)) as i32, 2, 2, rd, 0x03) // C.LWSP
        }
        (2, 3) => {
            if rd == 0 {
                return None;
            }
            i_enc(((bit(c, 12) << 5) | (bits(c, 6, 5) << 3) | (bits(c, 4, 2) << 6)) as i32, 2, 3, rd, 0x03) // C.LDSP
        }
        (2, 4) => {
            if bit(c, 12) == 0 {
                if rs2 == 0 {
                    if rd == 0 {
                        return None;
                    }
                    i_enc(0, rd, 0, 0, 0x67) // C.JR
                } else {
                    r_enc(0, rs2, 0, 0, rd, 0x33) // C.MV
                }
            } else if rs2 == 0 {
                if rd == 0 {
                    0x0010_0073 // C.EBREAK
                } else {
                    i_enc(0, rd, 0, 1, 0x67) // C.JALR
                }
            } else {
                r_enc(0, rs2, rd, 0, rd, 0x33) // C.ADD
            }
        }
        (2, 6) => s_enc(((bits(c, 12, 9) << 2) | (bits(c, 8, 7) << 6)) as i32, rs2, 2, 2), // C.SWSP
        (2, 7) => s_enc(((bits(c, 12, 10) << 3) | (bits(c, 9, 7) << 6)) as i32, rs2, 2, 3), // C.SDSP
        _ => return None,
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn known_encodings() {
        assert_eq!(expand(0x8082), Some(0x0000_8067)); // c.ret      → jalr x0, 0(ra)
        assert_eq!(expand(0x0505), Some(0x0015_0513)); // c.addi a0,1 → addi a0,a0,1
        assert_eq!(expand(0x4515), Some(0x0050_0513)); // c.li a0,5  → addi a0,x0,5
        assert_eq!(expand(0x85aa), Some(0x00a0_05b3)); // c.mv a1,a0 → add a1,x0,a0
        assert_eq!(expand(0x1141), Some(0xff01_0113)); // c.addi sp,-16
        assert_eq!(expand(0xe406), Some(0x0011_3423)); // c.sdsp ra,8(sp)
        assert_eq!(expand(0x6402), Some(0x0001_3403)); // c.ldsp s0,0(sp)
        assert_eq!(expand(0x9002), Some(0x0010_0073)); // c.ebreak
        assert_eq!(expand(0x0000), None); // 全 0 為非法指令
    }
}
