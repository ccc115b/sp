pub const EXT_I: u32 = 1 << 0;
pub const EXT_M: u32 = 1 << 1;
pub const EXT_A: u32 = 1 << 2;
pub const EXT_F: u32 = 1 << 3;
pub const EXT_D: u32 = 1 << 4;
pub const EXT_C: u32 = 1 << 5;
pub const EXT_ZICSR: u32 = 1 << 6;
pub const EXT_ZIFENCEI: u32 = 1 << 7;

pub const EF_RISCV_RVC: u32 = 0x0001;
pub const EF_RISCV_FLOAT_ABI_SOFT: u32 = 0x0000;
pub const EF_RISCV_FLOAT_ABI_SINGLE: u32 = 0x0002;
pub const EF_RISCV_FLOAT_ABI_DOUBLE: u32 = 0x0004;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Mabi {
    Soft,
    Single,
    Double,
}

pub struct IsaSpec {
    pub xlen: u8,
    pub exts: u32,
}

fn skip_version(b: &[u8], mut i: usize) -> usize {
    if i < b.len() && b[i].is_ascii_digit() {
        while i < b.len() && b[i].is_ascii_digit() {
            i += 1;
        }
        if i + 1 < b.len() && b[i] == b'p' && b[i + 1].is_ascii_digit() {
            i += 2;
            while i < b.len() && b[i].is_ascii_digit() {
                i += 1;
            }
        }
    }
    i
}

pub fn parse_isa(s: &str) -> Result<IsaSpec, String> {
    let s = s.trim();
    let lower = s.to_ascii_lowercase();
    let b = lower.as_bytes();
    if b.len() < 4 || &b[..2] != b"rv" {
        return Err(format!("invalid march string '{}': must start with rv32/rv64", s));
    }
    let (xlen, mut i) = if b[2] == b'3' && b[3] == b'2' {
        (32u8, 4usize)
    } else if b[2] == b'6' && b[3] == b'4' {
        (64u8, 4usize)
    } else {
        return Err(format!("invalid march string '{}': expected rv32 or rv64", s));
    };
    let mut exts = EXT_I;
    let mut seen_z = false;
    while i < b.len() {
        if b[i] == b'_' {
            i += 1;
            let start = i;
            while i < b.len() && b[i].is_ascii_alphabetic() {
                i += 1;
            }
            let name = &lower[start..i];
            i = skip_version(b, i);
            if name.is_empty() {
                return Err(format!("invalid march string '{}'", s));
            }
            match name {
                "zicsr" => exts |= EXT_ZICSR,
                "zifencei" => exts |= EXT_ZIFENCEI,
                "i" => exts |= EXT_I,
                "g" => exts |= EXT_M | EXT_A | EXT_F | EXT_D | EXT_ZICSR | EXT_ZIFENCEI,
                "m" => exts |= EXT_M,
                "a" => exts |= EXT_A,
                "f" => exts |= EXT_F,
                "d" => exts |= EXT_D,
                "c" => exts |= EXT_C,
                _ => {}
            }
            seen_z = seen_z || !matches!(name, "i" | "g" | "m" | "a" | "f" | "d" | "c");
            continue;
        }
        let c = b[i] as char;
        i = skip_version(b, i + 1);
        if seen_z {
            return Err(format!("invalid march string '{}': single letter extension after z extension", s));
        }
        match c {
            'i' => exts |= EXT_I,
            'e' => return Err("rv32e is not supported".into()),
            'g' => exts |= EXT_M | EXT_A | EXT_F | EXT_D | EXT_ZICSR | EXT_ZIFENCEI,
            'm' => exts |= EXT_M,
            'a' => exts |= EXT_A,
            'f' => exts |= EXT_F,
            'd' => exts |= EXT_D,
            'c' => exts |= EXT_C,
            'q' | 'h' | 'v' | 'p' | 'b' | 'j' | 'l' | 'n' | 's' | 'u' | 'x' | 'k' => {
                return Err(format!("unsupported extension '{}' in march string", c));
            }
            _ => return Err(format!("invalid march string '{}'", s)),
        }
    }
    Ok(IsaSpec { xlen, exts })
}

pub fn parse_mabi(s: &str, xlen: u8) -> Result<Mabi, String> {
    let m = match s {
        "ilp32" | "lp64" => Mabi::Soft,
        "ilp32f" | "lp64f" => Mabi::Single,
        "ilp32d" | "lp64d" => Mabi::Double,
        "ilp32e" => return Err("rv32e ABI (ilp32e) is not supported".into()),
        _ => return Err(format!("unsupported -mabi '{}'", s)),
    };
    let m64 = s.starts_with("lp64");
    if (xlen == 64) != m64 {
        return Err(format!("-mabi '{}' does not match -march xlen {}", s, xlen));
    }
    Ok(m)
}

pub fn e_flags(rvc: bool, mabi: Mabi) -> u32 {
    let mut f = 0u32;
    if rvc {
        f |= EF_RISCV_RVC;
    }
    f |= match mabi {
        Mabi::Soft => EF_RISCV_FLOAT_ABI_SOFT,
        Mabi::Single => EF_RISCV_FLOAT_ABI_SINGLE,
        Mabi::Double => EF_RISCV_FLOAT_ABI_DOUBLE,
    };
    f
}
