//! bytecode 反組譯器：把 Code attribute 還原成 `javap -c` 風格的文字。
//!
//! 與直譯器不同，此模組涵蓋完整的標準 opcode 表（含尚未支援執行的
//! long/double、物件、switch、例外等指令）。

use crate::classfile::{ClassFile, Const, Method};
use crate::Res;

// ───────────────────────── opcode 表 ─────────────────────────

#[derive(Clone, Copy, PartialEq)]
enum Fmt {
    Plain,           // 無 operands
    Local,           // u8 區域變數索引
    Byte,            // i8 常數（bipush）
    Atype,           // u8 newarray 類別
    Short,           // i16 常數（sipush）
    Cp1,             // u8 constant pool 索引（ldc）
    Cp2,             // u16 constant pool 索引
    Br,              // i16 跳位偏移
    Br4,             // i32 跳位偏移
    Iinc,            // u8 索引 + i8 增量
    InvokeInterface, // u16 索引 + u8 個數 + 0
    InvokeDynamic,   // u16 索引 + 0 + 0
    MultiANew,       // u16 索引 + u8 維度
    TableSwitch,
    LookupSwitch,
    Wide,
}

/// 查表：opcode → (mnemonic, operand 格式)；未知 opcode 回傳 None。
fn decode(op: u8) -> Option<(&'static str, Fmt)> {
    use Fmt::*;
    Some(match op {
        0x00 => ("nop", Plain),
        0x01 => ("aconst_null", Plain),
        0x02 => ("iconst_m1", Plain),
        0x03 => ("iconst_0", Plain),
        0x04 => ("iconst_1", Plain),
        0x05 => ("iconst_2", Plain),
        0x06 => ("iconst_3", Plain),
        0x07 => ("iconst_4", Plain),
        0x08 => ("iconst_5", Plain),
        0x09 => ("lconst_0", Plain),
        0x0a => ("lconst_1", Plain),
        0x0b => ("fconst_0", Plain),
        0x0c => ("fconst_1", Plain),
        0x0d => ("fconst_2", Plain),
        0x0e => ("dconst_0", Plain),
        0x0f => ("dconst_1", Plain),
        0x10 => ("bipush", Byte),
        0x11 => ("sipush", Short),
        0x12 => ("ldc", Cp1),
        0x13 => ("ldc_w", Cp2),
        0x14 => ("ldc2_w", Cp2),
        0x15 => ("iload", Local),
        0x16 => ("lload", Local),
        0x17 => ("fload", Local),
        0x18 => ("dload", Local),
        0x19 => ("aload", Local),
        0x1a..=0x1d => (["iload_0", "iload_1", "iload_2", "iload_3"][(op - 0x1a) as usize], Plain),
        0x1e..=0x21 => (["lload_0", "lload_1", "lload_2", "lload_3"][(op - 0x1e) as usize], Plain),
        0x22..=0x25 => (["fload_0", "fload_1", "fload_2", "fload_3"][(op - 0x22) as usize], Plain),
        0x26..=0x29 => (["dload_0", "dload_1", "dload_2", "dload_3"][(op - 0x26) as usize], Plain),
        0x2a..=0x2d => (["aload_0", "aload_1", "aload_2", "aload_3"][(op - 0x2a) as usize], Plain),
        0x2e => ("iaload", Plain),
        0x2f => ("laload", Plain),
        0x30 => ("faload", Plain),
        0x31 => ("daload", Plain),
        0x32 => ("aaload", Plain),
        0x33 => ("baload", Plain),
        0x34 => ("caload", Plain),
        0x35 => ("saload", Plain),
        0x36 => ("istore", Local),
        0x37 => ("lstore", Local),
        0x38 => ("fstore", Local),
        0x39 => ("dstore", Local),
        0x3a => ("astore", Local),
        0x3b..=0x3e => (["istore_0", "istore_1", "istore_2", "istore_3"][(op - 0x3b) as usize], Plain),
        0x3f..=0x42 => (["lstore_0", "lstore_1", "lstore_2", "lstore_3"][(op - 0x3f) as usize], Plain),
        0x43..=0x46 => (["fstore_0", "fstore_1", "fstore_2", "fstore_3"][(op - 0x43) as usize], Plain),
        0x47..=0x4a => (["dstore_0", "dstore_1", "dstore_2", "dstore_3"][(op - 0x47) as usize], Plain),
        0x4b..=0x4e => (["astore_0", "astore_1", "astore_2", "astore_3"][(op - 0x4b) as usize], Plain),
        0x4f => ("iastore", Plain),
        0x50 => ("lastore", Plain),
        0x51 => ("fastore", Plain),
        0x52 => ("dastore", Plain),
        0x53 => ("aastore", Plain),
        0x54 => ("bastore", Plain),
        0x55 => ("castore", Plain),
        0x56 => ("sastore", Plain),
        0x57 => ("pop", Plain),
        0x58 => ("pop2", Plain),
        0x59 => ("dup", Plain),
        0x5a => ("dup_x1", Plain),
        0x5b => ("dup_x2", Plain),
        0x5c => ("dup2", Plain),
        0x5d => ("dup2_x1", Plain),
        0x5e => ("dup2_x2", Plain),
        0x5f => ("swap", Plain),
        0x60 => ("iadd", Plain),
        0x61 => ("ladd", Plain),
        0x62 => ("fadd", Plain),
        0x63 => ("dadd", Plain),
        0x64 => ("isub", Plain),
        0x65 => ("lsub", Plain),
        0x66 => ("fsub", Plain),
        0x67 => ("dsub", Plain),
        0x68 => ("imul", Plain),
        0x69 => ("lmul", Plain),
        0x6a => ("fmul", Plain),
        0x6b => ("dmul", Plain),
        0x6c => ("idiv", Plain),
        0x6d => ("ldiv", Plain),
        0x6e => ("fdiv", Plain),
        0x6f => ("ddiv", Plain),
        0x70 => ("irem", Plain),
        0x71 => ("lrem", Plain),
        0x72 => ("frem", Plain),
        0x73 => ("drem", Plain),
        0x74 => ("ineg", Plain),
        0x75 => ("lneg", Plain),
        0x76 => ("fneg", Plain),
        0x77 => ("dneg", Plain),
        0x78 => ("ishl", Plain),
        0x79 => ("lshl", Plain),
        0x7a => ("ishr", Plain),
        0x7b => ("lshr", Plain),
        0x7c => ("iushr", Plain),
        0x7d => ("lushr", Plain),
        0x7e => ("iand", Plain),
        0x7f => ("land", Plain),
        0x80 => ("ior", Plain),
        0x81 => ("lor", Plain),
        0x82 => ("ixor", Plain),
        0x83 => ("lxor", Plain),
        0x84 => ("iinc", Iinc),
        0x85 => ("i2l", Plain),
        0x86 => ("i2f", Plain),
        0x87 => ("i2d", Plain),
        0x88 => ("l2i", Plain),
        0x89 => ("l2f", Plain),
        0x8a => ("l2d", Plain),
        0x8b => ("f2i", Plain),
        0x8c => ("f2l", Plain),
        0x8d => ("f2d", Plain),
        0x8e => ("d2i", Plain),
        0x8f => ("d2l", Plain),
        0x90 => ("d2f", Plain),
        0x91 => ("i2b", Plain),
        0x92 => ("i2c", Plain),
        0x93 => ("i2s", Plain),
        0x94 => ("lcmp", Plain),
        0x95 => ("fcmpl", Plain),
        0x96 => ("fcmpg", Plain),
        0x97 => ("dcmpl", Plain),
        0x98 => ("dcmpg", Plain),
        0x99 => ("ifeq", Br),
        0x9a => ("ifne", Br),
        0x9b => ("iflt", Br),
        0x9c => ("ifge", Br),
        0x9d => ("ifgt", Br),
        0x9e => ("ifle", Br),
        0x9f => ("if_icmpeq", Br),
        0xa0 => ("if_icmpne", Br),
        0xa1 => ("if_icmplt", Br),
        0xa2 => ("if_icmpge", Br),
        0xa3 => ("if_icmpgt", Br),
        0xa4 => ("if_icmple", Br),
        0xa5 => ("if_acmpeq", Br),
        0xa6 => ("if_acmpne", Br),
        0xa7 => ("goto", Br),
        0xa8 => ("jsr", Br),
        0xa9 => ("ret", Local),
        0xaa => ("tableswitch", TableSwitch),
        0xab => ("lookupswitch", LookupSwitch),
        0xac => ("ireturn", Plain),
        0xad => ("lreturn", Plain),
        0xae => ("freturn", Plain),
        0xaf => ("dreturn", Plain),
        0xb0 => ("areturn", Plain),
        0xb1 => ("return", Plain),
        0xb2 => ("getstatic", Cp2),
        0xb3 => ("putstatic", Cp2),
        0xb4 => ("getfield", Cp2),
        0xb5 => ("putfield", Cp2),
        0xb6 => ("invokevirtual", Cp2),
        0xb7 => ("invokespecial", Cp2),
        0xb8 => ("invokestatic", Cp2),
        0xb9 => ("invokeinterface", InvokeInterface),
        0xba => ("invokedynamic", InvokeDynamic),
        0xbb => ("new", Cp2),
        0xbc => ("newarray", Atype),
        0xbd => ("anewarray", Cp2),
        0xbe => ("arraylength", Plain),
        0xbf => ("athrow", Plain),
        0xc0 => ("checkcast", Cp2),
        0xc1 => ("instanceof", Cp2),
        0xc2 => ("monitorenter", Plain),
        0xc3 => ("monitorexit", Plain),
        0xc4 => ("wide", Wide),
        0xc5 => ("multianewarray", MultiANew),
        0xc6 => ("ifnull", Br),
        0xc7 => ("ifnonnull", Br),
        0xc8 => ("goto_w", Br4),
        0xc9 => ("jsr_w", Br4),
        0xca => ("breakpoint", Plain),
        0xfe => ("impdep1", Plain),
        0xff => ("impdep2", Plain),
        _ => return None,
    })
}

/// 指令總長度（opcode + 固定長度 operands；switch / wide 另行處理）。
fn instr_len(fmt: Fmt) -> usize {
    use Fmt::*;
    match fmt {
        Plain => 1,
        Local | Byte | Atype | Cp1 => 2,
        Short | Cp2 | Br | Iinc => 3,
        Br4 | InvokeInterface | InvokeDynamic | MultiANew => 5,
        Wide | TableSwitch | LookupSwitch => 0, // 特殊指令
    }
}

// ───────────────────────── 型別／修飾字 ─────────────────────────

/// 把單一字元 descriptor 轉成 Java 型別名稱。
fn type_char(c: u8) -> &'static str {
    match c {
        b'V' => "void",
        b'Z' => "boolean",
        b'B' => "byte",
        b'C' => "char",
        b'S' => "short",
        b'I' => "int",
        b'J' => "long",
        b'F' => "float",
        b'D' => "double",
        _ => "?",
    }
}

/// 解析單一 descriptor（自 `i` 開始），回傳 (顯示名稱, 結束位置)。
fn parse_type(d: &str, i: usize) -> (String, usize) {
    let b = d.as_bytes();
    match b.get(i) {
        Some(&c) if c != b'L' && c != b'[' => (type_char(c).to_string(), i + 1),
        Some(b'[') => {
            let (t, j) = parse_type(d, i + 1);
            (format!("{t}[]"), j)
        }
        Some(b'L') => {
            let mut j = i + 1;
            while j < b.len() && b[j] != b';' {
                j += 1;
            }
            (d[i + 1..j].replace('/', "."), j + 1)
        }
        _ => ("?".into(), i),
    }
}

/// `(ILjava/lang/String;)V` → 回傳型別與參數列表。
fn method_types(desc: &str) -> (String, String) {
    let mut params = vec![];
    let mut i = 1;
    while i < desc.len() && desc.as_bytes()[i] != b')' {
        let (t, j) = parse_type(desc, i);
        params.push(t);
        i = j;
    }
    let ret = parse_type(desc, (i + 1).min(desc.len())).0;
    (ret, params.join(", "))
}

/// access_flags → 修飾字。kind：0 = class、1 = field、2 = method。
fn access_str(f: u16, kind: u8) -> String {
    let mut out: Vec<&str> = vec![];
    let mut add = |mask: u16, name: &'static str| {
        if f & mask != 0 {
            out.push(name);
        }
    };
    add(0x0001, "public");
    if kind != 0 {
        add(0x0002, "private");
        add(0x0004, "protected");
    }
    add(0x0008, "static");
    add(0x0010, "final");
    match kind {
        1 => add(0x0020, "volatile"),
        2 => add(0x0020, "synchronized"),
        _ => {}
    }
    if kind == 2 {
        add(0x0100, "native");
    }
    add(0x0400, "abstract");
    add(0x1000, "synthetic");
    if kind == 0 {
        add(0x0200, "interface");
        add(0x2000, "annotation");
        add(0x4000, "enum");
    }
    out.join(" ")
}

// ───────────────────────── constant pool 註解 ─────────────────────────

/// constant 的描述文字（不含 `#idx // ` 前綴）。
fn const_desc(cf: &ClassFile, idx: u16) -> String {
    match cf.cp.get(idx as usize) {
        None => "<index out of range>".into(),
        Some(Const::Utf8(s)) => format!("Utf8 {s}"),
        Some(Const::Int(v)) => format!("int {v}"),
        Some(Const::Str(u)) => match cf.utf8(*u) {
            Ok(s) => format!("String {s}"),
            Err(_) => "bad String".into(),
        },
        Some(Const::Class(u)) => match cf.class_name(*u) {
            Ok(s) => format!("class {s}"),
            Err(_) => "bad Class".into(),
        },
        Some(Const::Ref { tag, class, nt }) => {
            let kind = match tag {
                9 => "Field",
                10 => "Method",
                _ => "InterfaceMethod",
            };
            let cn = cf.class_name(*class).unwrap_or("?");
            match cf.cp.get(*nt as usize) {
                Some(Const::NameType { name, desc }) => {
                    let n = cf.utf8(*name).unwrap_or("?");
                    let d = cf.utf8(*desc).unwrap_or("?");
                    format!("{kind} {cn}.{n}:{d}")
                }
                _ => format!("{kind} {cn}"),
            }
        }
        Some(Const::NameType { name, desc }) => {
            let n = cf.utf8(*name).unwrap_or("?");
            let d = cf.utf8(*desc).unwrap_or("?");
            format!("NameAndType {n}:{d}")
        }
        Some(Const::Other(tag)) => format!("(constant pool tag {tag})"),
    }
}

fn array_type(t: u8) -> &'static str {
    match t {
        4 => "boolean",
        5 => "char",
        6 => "float",
        7 => "double",
        8 => "byte",
        9 => "short",
        10 => "int",
        11 => "long",
        _ => "?",
    }
}

// ───────────────────────── 反組譯 ─────────────────────────

/// 將整個 class file 反組譯成 `javap -c` 風格文字。
pub fn disassemble(cf: &ClassFile) -> Res<String> {
    let mut o = String::new();
    let cls = access_str(cf.access, 0);
    o.push_str(&format!(
        "{} class {} extends {} {{\n",
        if cls.is_empty() { "/*flags*/" } else { &cls },
        cf.name,
        cf.super_name
    ));

    for f in &cf.fields {
        let (ty, _) = parse_type(&f.desc, 0);
        let fl = access_str(f.access, 1);
        o.push_str(&format!(
            "  {}{}{} {};\n",
            fl,
            if fl.is_empty() { "" } else { " " },
            ty,
            f.name
        ));
    }
    if !cf.fields.is_empty() {
        o.push('\n');
    }

    for m in &cf.methods {
        disasm_method(&mut o, cf, m);
        o.push('\n');
    }
    o.push_str("}\n");
    Ok(o)
}

/// 從 `start` 讀一個 big-endian i32；越界回傳 None。
fn read_i32(code: &[u8], start: usize) -> Option<i32> {
    let b = code.get(start..start + 4)?;
    Some(
        ((b[0] as i32) << 24) | ((b[1] as i32) << 16) | ((b[2] as i32) << 8) | b[3] as i32,
    )
}

fn disasm_method(o: &mut String, cf: &ClassFile, m: &Method) {
    let (ret, params) = method_types(&m.desc);
    let fl = access_str(m.access, 2);
    o.push_str(&format!(
        "  {}{}{} {}({});\n",
        fl,
        if fl.is_empty() { "" } else { " " },
        ret,
        m.name,
        params
    ));
    if m.code.is_empty() {
        o.push_str("    // <no Code: native/abstract>\n");
        return;
    }
    o.push_str("    Code:\n");

    let code = &m.code;
    let mut pc = 0usize;
    while pc < code.len() {
        let op = code[pc];
        let Some((name, fmt)) = decode(op) else {
            o.push_str(&format!("{pc:5}: <unknown opcode 0x{op:02x}>\n"));
            pc += 1;
            continue;
        };

        // ── switch：多行輸出 ──
        if matches!(fmt, Fmt::TableSwitch | Fmt::LookupSwitch) {
            if disasm_switch(o, pc, name, fmt, code).is_none() {
                o.push_str(&format!("{pc:5}: {name:<15} // <truncated>\n"));
            }
            return;
        }

        // ── wide：前綴修飾下一個指令 ──
        if fmt == Fmt::Wide {
            let (ops, len) = match code.get(pc + 1) {
                Some(0x84) if pc + 6 <= code.len() => {
                    let n = ((code[pc + 2] as u16) << 8) | code[pc + 3] as u16;
                    let c = ((code[pc + 4] as i16) << 8) | code[pc + 5] as i16;
                    (format!("iinc {n} {c}"), 6)
                }
                Some(&ext) if pc + 4 <= code.len() => match decode(ext) {
                    Some((n, _)) => {
                        let idx = ((code[pc + 2] as u16) << 8) | code[pc + 3] as u16;
                        (format!("{n} {idx}"), 4)
                    }
                    None => (format!("<unknown 0x{ext:02x}>"), 2),
                },
                Some(&ext) => (format!("<unknown 0x{ext:02x}>"), 2),
                None => ("<truncated>".into(), 1),
            };
            o.push_str(&format!("{pc:5}: wide {ops:<19}\n"));
            pc += len;
            continue;
        }

        // ── 固定長度指令 ──
        let len = instr_len(fmt);
        if pc + len > code.len() {
            o.push_str(&format!(
                "{pc:5}: {name:<24} // <truncated instruction>\n"
            ));
            return;
        }
        let b = |i: usize| code[pc + i];
        let u2 = |i: usize| ((b(i) as u16) << 8) | b(i + 1) as u16;
        let (mut ops, mut comment) = (String::new(), String::new());
        match fmt {
            Fmt::Plain => {}
            Fmt::Local => ops = b(1).to_string(),
            Fmt::Byte => ops = (b(1) as i8).to_string(),
            Fmt::Atype => {
                ops = array_type(b(1)).to_string();
            }
            Fmt::Short => ops = (u2(1) as i16).to_string(),
            Fmt::Cp1 => {
                let idx = b(1) as u16;
                ops = format!("#{idx}");
                comment = format!("// {}", const_desc(cf, idx));
            }
            Fmt::Cp2 => {
                let idx = u2(1);
                ops = format!("#{idx}");
                comment = format!("// {}", const_desc(cf, idx));
            }
            Fmt::Br | Fmt::Br4 => {
                let off = if fmt == Fmt::Br {
                    u2(1) as i16 as i32
                } else {
                    read_i32(code, pc + 1).unwrap_or(0)
                };
                ops = (pc as i64 + off as i64).to_string();
            }
            Fmt::Iinc => ops = format!("{}, {}", b(1), b(2) as i8),
            Fmt::InvokeInterface | Fmt::InvokeDynamic => {
                let idx = u2(1);
                ops = if fmt == Fmt::InvokeInterface {
                    format!("#{idx}  {}", b(3))
                } else {
                    format!("#{idx}")
                };
                comment = format!("// {}", const_desc(cf, idx));
            }
            Fmt::MultiANew => {
                let idx = u2(1);
                ops = format!("#{idx}  {}", b(3));
                comment = format!("// {}", const_desc(cf, idx));
            }
            Fmt::TableSwitch | Fmt::LookupSwitch | Fmt::Wide => unreachable!(),
        }
        let instr = if ops.is_empty() {
            name.to_string()
        } else {
            format!("{name} {ops}")
        };
        o.push_str(&format!("{pc:5}: {instr:<24}{comment}\n"));
        pc += len;
    }
}

/// 輸出 tableswitch / lookupswitch 的多行區塊。
fn disasm_switch(
    o: &mut String,
    pc: usize,
    name: &str,
    fmt: Fmt,
    code: &[u8],
) -> Option<()> {
    // opcode 後補 0 個位元組，使 default 以 4-byte 對齊
    let mut p = pc + 1;
    while !p.is_multiple_of(4) {
        p += 1;
    }
    let default = read_i32(code, p)?;
    p += 4;
    o.push_str(&format!(
        "{pc:5}: {name:<15} // default -> {}\n",
        pc as i64 + default as i64
    ));
    if fmt == Fmt::TableSwitch {
        let low = read_i32(code, p)?;
        let high = read_i32(code, p + 4)?;
        p += 8;
        if high < low {
            return Some(());
        }
        for k in 0..=high - low {
            let off = read_i32(code, p)?;
            p += 4;
            o.push_str(&format!(
                "           {:>12} -> {}\n",
                low + k,
                pc as i64 + off as i64
            ));
        }
    } else {
        let npairs = read_i32(code, p)?;
        p += 4;
        for _ in 0..npairs {
            let k = read_i32(code, p)?;
            let off = read_i32(code, p + 4)?;
            p += 8;
            o.push_str(&format!(
                "           {:>12} -> {}\n",
                k,
                pc as i64 + off as i64
            ));
        }
    }
    Some(())
}
