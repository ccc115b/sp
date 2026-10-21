//! `.class` 檔解析：constant pool、欄位、方法與 Code attribute。

use crate::Res;

#[derive(Clone)]
pub enum Const {
    Utf8(String),
    Int(i32),
    Str(u16),
    Class(u16),
    Ref { tag: u8, class: u16, nt: u16 }, // Field(9)/Method(10)/InterfaceMethod(11) ref
    NameType { name: u16, desc: u16 },
    Other(u8), // 目前用不到的項目（long/double/float/invokedynamic…），保留原 tag
}

pub struct Field {
    pub name: String,
    pub desc: String,
    pub access: u16,
}

pub struct Method {
    pub name: String,
    pub desc: String,
    pub access: u16,
    pub max_stack: usize,
    pub max_locals: usize,
    pub code: Vec<u8>,
    pub nargs: usize,
}

pub struct ClassFile {
    pub cp: Vec<Const>,
    pub access: u16,
    pub name: String,
    pub super_name: String,
    pub fields: Vec<Field>,
    pub methods: Vec<Method>,
}

struct Reader<'a> {
    d: &'a [u8],
    p: usize,
}

impl<'a> Reader<'a> {
    fn bytes(&mut self, n: usize) -> Res<&'a [u8]> {
        let end = self.p.checked_add(n).filter(|&e| e <= self.d.len());
        let end = end.ok_or("unexpected end of class file")?;
        let s = &self.d[self.p..end];
        self.p = end;
        Ok(s)
    }
    fn u1(&mut self) -> Res<u8> {
        Ok(self.bytes(1)?[0])
    }
    fn u2(&mut self) -> Res<u16> {
        let b = self.bytes(2)?;
        Ok(u16::from_be_bytes([b[0], b[1]]))
    }
    fn u4(&mut self) -> Res<u32> {
        let b = self.bytes(4)?;
        Ok(u32::from_be_bytes([b[0], b[1], b[2], b[3]]))
    }
}

/// 計算 descriptor 的參數個數（每個參數佔一個 slot；不支援 long/double）。
fn count_args(desc: &str) -> Res<usize> {
    let b = desc.as_bytes();
    let (mut i, mut n) = (1, 0);
    while i < b.len() && b[i] != b')' {
        match b[i] {
            b'I' | b'Z' | b'B' | b'C' | b'S' => i += 1,
            b'J' | b'D' | b'F' => return Err(format!("unsupported type in {desc}")),
            b'L' => {
                while b[i] != b';' {
                    i += 1;
                }
                i += 1;
            }
            b'[' => {
                while b[i] == b'[' {
                    i += 1;
                }
                if b[i] == b'L' {
                    while b[i] != b';' {
                        i += 1;
                    }
                }
                i += 1;
            }
            c => return Err(format!("bad descriptor char '{}'", c as char)),
        }
        n += 1;
    }
    Ok(n)
}

impl ClassFile {
    pub fn utf8(&self, i: u16) -> Res<&str> {
        match self.cp.get(i as usize) {
            Some(Const::Utf8(s)) => Ok(s),
            _ => Err(format!("constant #{i} is not Utf8")),
        }
    }
    pub fn class_name(&self, i: u16) -> Res<&str> {
        match self.cp.get(i as usize) {
            Some(Const::Class(n)) => self.utf8(*n),
            _ => Err(format!("constant #{i} is not Class")),
        }
    }
    /// 解析 Fieldref / Methodref / InterfaceMethodref → (類別, 名稱, descriptor)
    pub fn member(&self, i: u16) -> Res<(&str, &str, &str)> {
        match self.cp.get(i as usize) {
            Some(Const::Ref { class, nt, .. }) => match self.cp.get(*nt as usize) {
                Some(Const::NameType { name, desc }) => {
                    Ok((self.class_name(*class)?, self.utf8(*name)?, self.utf8(*desc)?))
                }
                _ => Err("bad NameAndType".into()),
            },
            _ => Err(format!("constant #{i} is not a member ref")),
        }
    }
    pub fn find_method(&self, name: &str, desc: &str) -> Option<usize> {
        self.methods.iter().position(|m| m.name == name && m.desc == desc)
    }

    pub fn parse(data: &[u8]) -> Res<ClassFile> {
        let mut r = Reader { d: data, p: 0 };
        if r.u4()? != 0xCAFE_BABE {
            return Err("not a class file (bad magic)".into());
        }
        r.u2()?; // minor
        r.u2()?; // major

        let n = r.u2()? as usize;
        let mut cp = vec![Const::Other(0); n];
        let mut i = 1;
        while i < n {
            let mut extra = 0;
            let tag = r.u1()?;
            let c = match tag {
                1 => {
                    let len = r.u2()? as usize;
                    Const::Utf8(String::from_utf8_lossy(r.bytes(len)?).into_owned())
                }
                3 => Const::Int(r.u4()? as i32),
                4 => { r.u4()?; Const::Other(tag) }
                5 | 6 => { r.u4()?; r.u4()?; extra = 1; Const::Other(tag) }
                7 => Const::Class(r.u2()?),
                8 => Const::Str(r.u2()?),
                9..=11 => Const::Ref { tag, class: r.u2()?, nt: r.u2()? },
                12 => Const::NameType { name: r.u2()?, desc: r.u2()? },
                15 => { r.u1()?; r.u2()?; Const::Other(tag) }
                16 | 19 | 20 => { r.u2()?; Const::Other(tag) }
                17 | 18 => { r.u4()?; Const::Other(tag) }
                t => return Err(format!("unknown constant pool tag {t}")),
            };
            cp[i] = c;
            i += 1 + extra;
        }

        let mut cf = ClassFile {
            cp,
            access: r.u2()?,
            name: String::new(),
            super_name: String::new(),
            fields: vec![],
            methods: vec![],
        };
        let this = r.u2()?;
        cf.name = cf.class_name(this)?.to_string();
        let super_idx = r.u2()?;
        cf.super_name = if super_idx == 0 {
            "<none>".into()
        } else {
            cf.class_name(super_idx)?.to_string()
        };
        let ifaces = r.u2()? as usize;
        r.bytes(ifaces * 2)?;

        // fields
        for _ in 0..r.u2()? {
            let access = r.u2()?;
            let name = cf.utf8(r.u2()?)?.to_string();
            let desc = cf.utf8(r.u2()?)?.to_string();
            for _ in 0..r.u2()? {
                r.u2()?;
                let len = r.u4()? as usize;
                r.bytes(len)?;
            }
            cf.fields.push(Field { name, desc, access });
        }

        // methods
        for _ in 0..r.u2()? {
            let access = r.u2()?;
            let name = cf.utf8(r.u2()?)?.to_string();
            let desc = cf.utf8(r.u2()?)?.to_string();
            let mut m = Method {
                nargs: count_args(&desc).unwrap_or(0),
                name, desc, access, max_stack: 0, max_locals: 0, code: vec![],
            };
            for _ in 0..r.u2()? {
                let an = cf.utf8(r.u2()?)?.to_string();
                let len = r.u4()? as usize;
                let body = r.bytes(len)?;
                if an == "Code" {
                    let mut s = Reader { d: body, p: 0 };
                    m.max_stack = s.u2()? as usize;
                    m.max_locals = s.u2()? as usize;
                    let clen = s.u4()? as usize;
                    m.code = s.bytes(clen)?.to_vec();
                }
            }
            cf.methods.push(m);
        }
        Ok(cf)
    }
}
