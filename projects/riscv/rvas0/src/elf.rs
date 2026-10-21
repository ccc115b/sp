use std::io::Write;

pub struct OutRel {
    pub off: u64,
    pub ty: u32,
    pub sym: u32,
    pub addend: i64,
}

pub struct OutSection {
    pub name: String,
    pub sh_type: u32,
    pub sh_flags: u64,
    pub entsize: u64,
    pub addralign: u64,
    pub data: Vec<u8>,
    pub relocs: Vec<OutRel>,
    pub rela_name: String,
}

pub struct OutSym {
    pub name: String,
    pub bind: u8,
    pub vis: u8,
    pub ty: u8,
    pub shndx: u32,
    pub value: u64,
    pub size: u64,
}

struct Shdr {
    name_off: u32,
    sh_type: u32,
    flags: u64,
    offset: u64,
    size: u64,
    link: u32,
    info: u32,
    addralign: u64,
    entsize: u64,
}

struct Blob {
    data: Vec<u8>,
    align: u64,
}

fn strtab_append(tab: &mut Vec<u8>, map: &mut std::collections::HashMap<String, u32>, s: &str) -> u32 {
    if let Some(o) = map.get(s) {
        return *o;
    }
    let off = tab.len() as u32;
    tab.extend_from_slice(s.as_bytes());
    tab.push(0);
    map.insert(s.to_string(), off);
    off
}

pub fn write_elf(
    path: &str,
    xlen: u8,
    e_flags: u32,
    secs: &[OutSection],
    syms: &[OutSym],
    first_global: u32,
    attrs: Option<Vec<u8>>,
) -> std::io::Result<()> {
    let is64 = xlen == 64;
    let syment = if is64 { 24 } else { 16 };
    let relent = if is64 { 24 } else { 12 };
    let rela_align = if is64 { 8 } else { 4 };

    let mut shstrtab: Vec<u8> = vec![0];
    let mut shstr_map = std::collections::HashMap::new();
    let mut strtab: Vec<u8> = vec![0];
    let mut str_map = std::collections::HashMap::new();

    let mut symtab: Vec<u8> = Vec::new();
    for s in syms {
        let name_off = strtab_append(&mut strtab, &mut str_map, &s.name);
        let info = (s.bind << 4) | (s.ty & 0xf);
        if is64 {
            symtab.extend_from_slice(&name_off.to_le_bytes());
            symtab.push(info);
            symtab.push(s.vis);
            symtab.extend_from_slice(&(s.shndx as u16).to_le_bytes());
            symtab.extend_from_slice(&s.value.to_le_bytes());
            symtab.extend_from_slice(&s.size.to_le_bytes());
        } else {
            symtab.extend_from_slice(&name_off.to_le_bytes());
            symtab.extend_from_slice(&(s.value as u32).to_le_bytes());
            symtab.extend_from_slice(&(s.size as u32).to_le_bytes());
            symtab.push(info);
            symtab.push(s.vis);
            symtab.extend_from_slice(&(s.shndx as u16).to_le_bytes());
        }
    }

    let _blobs: Vec<(String, Shdr, Blob)> = Vec::new();
    let symtab_idx;
    let strtab_idx;

    let mut idx = 1u32;
    let mut entries: Vec<(String, Shdr, Blob)> = Vec::new();
    for s in secs {
        let name_off = strtab_append(&mut shstrtab, &mut shstr_map, &s.name);
        entries.push((
            s.name.clone(),
            Shdr {
                name_off,
                sh_type: s.sh_type,
                flags: s.sh_flags,
                offset: 0,
                size: s.data.len() as u64,
                link: 0,
                info: 0,
                addralign: s.addralign.max(1),
                entsize: s.entsize,
            },
            Blob { data: if s.sh_type == 8 { Vec::new() } else { s.data.clone() }, align: s.addralign.max(1) },
        ));
        let this_idx = idx;
        idx += 1;
        if !s.relocs.is_empty() {
            let mut relbytes = Vec::new();
            for r in &s.relocs {
                if is64 {
                    relbytes.extend_from_slice(&r.off.to_le_bytes());
                    let info = ((r.sym as u64) << 32) | (r.ty as u64);
                    relbytes.extend_from_slice(&info.to_le_bytes());
                    relbytes.extend_from_slice(&r.addend.to_le_bytes());
                } else {
                    relbytes.extend_from_slice(&(r.off as u32).to_le_bytes());
                    let info = (r.sym << 8) | r.ty;
                    relbytes.extend_from_slice(&info.to_le_bytes());
                    relbytes.extend_from_slice(&(r.addend as i32).to_le_bytes());
                }
            }
            let rname_off = strtab_append(&mut shstrtab, &mut shstr_map, &s.rela_name);
            entries.push((
                s.rela_name.clone(),
                Shdr {
                    name_off: rname_off,
                    sh_type: 4,
                    flags: 0x40,
                    offset: 0,
                    size: relbytes.len() as u64,
                    link: 0,
                    info: this_idx,
                    addralign: rela_align,
                    entsize: relent,
                },
                Blob { data: relbytes, align: rela_align },
            ));
            idx += 1;
        }
    }
    if let Some(ab) = attrs {
        let name_off = strtab_append(&mut shstrtab, &mut shstr_map, ".riscv.attributes");
        entries.push((
            ".riscv.attributes".into(),
            Shdr {
                name_off,
                sh_type: 0x7000_0003,
                flags: 0,
                offset: 0,
                size: ab.len() as u64,
                link: 0,
                info: 0,
                addralign: 1,
                entsize: 0,
            },
            Blob { data: ab, align: 1 },
        ));
        idx += 1;
    }
    symtab_idx = idx;
    let symtab_name = strtab_append(&mut shstrtab, &mut shstr_map, ".symtab");
    entries.push((
        ".symtab".into(),
        Shdr {
            name_off: symtab_name,
            sh_type: 2,
            flags: 0,
            offset: 0,
            size: symtab.len() as u64,
            link: 0,
            info: first_global,
            addralign: if is64 { 8 } else { 4 },
            entsize: syment,
        },
        Blob { data: symtab, align: if is64 { 8 } else { 4 } },
    ));
    idx += 1;
    strtab_idx = idx;
    let strtab_name = strtab_append(&mut shstrtab, &mut shstr_map, ".strtab");
    entries.push((
        ".strtab".into(),
        Shdr {
            name_off: strtab_name,
            sh_type: 3,
            flags: 0,
            offset: 0,
            size: strtab.len() as u64,
            link: 0,
            info: 0,
            addralign: 1,
            entsize: 0,
        },
        Blob { data: strtab, align: 1 },
    ));
    idx += 1;
    let shstrtab_name = strtab_append(&mut shstrtab, &mut shstr_map, ".shstrtab");
    let shstr_idx = idx;
    entries.push((
        ".shstrtab".into(),
        Shdr {
            name_off: shstrtab_name,
            sh_type: 3,
            flags: 0,
            offset: 0,
            size: shstrtab.len() as u64,
            link: 0,
            info: 0,
            addralign: 1,
            entsize: 0,
        },
        Blob { data: shstrtab, align: 1 },
    ));

    let symtab_i = symtab_idx as usize - 1;
    let strtab_i = strtab_idx as usize - 1;
    for e in entries.iter_mut() {
        if e.1.sh_type == 4 {
            e.1.link = symtab_idx;
        }
        if e.1.sh_type == 2 {
            e.1.link = strtab_idx;
        }
    }
    let _ = symtab_i;
    let _ = strtab_i;

    let ehdr_size = if is64 { 64 } else { 52 };
    let shdr_size = if is64 { 64 } else { 40 };
    let mut out: Vec<u8> = Vec::new();
    out.resize(ehdr_size, 0);
    let mut shdrs: Vec<Shdr> = Vec::new();
    for (name, mut sh, blob) in entries {
        let align = blob.align.max(1);
        while out.len() as u64 % align != 0 {
            out.push(0);
        }
        sh.offset = out.len() as u64;
        out.extend_from_slice(&blob.data);
        let _ = name;
        shdrs.push(sh);
    }
    while out.len() % 8 != 0 {
        out.push(0);
    }
    let shoff = out.len() as u64;
    let shnum = shdrs.len() + 1;
    for _ in 0..shdr_size {
        out.push(0);
    }
    for sh in &shdrs {
        if is64 {
            out.extend_from_slice(&sh.name_off.to_le_bytes());
            out.extend_from_slice(&sh.sh_type.to_le_bytes());
            out.extend_from_slice(&sh.flags.to_le_bytes());
            out.extend_from_slice(&0u64.to_le_bytes());
            out.extend_from_slice(&sh.offset.to_le_bytes());
            out.extend_from_slice(&sh.size.to_le_bytes());
            out.extend_from_slice(&sh.link.to_le_bytes());
            out.extend_from_slice(&sh.info.to_le_bytes());
            out.extend_from_slice(&sh.addralign.to_le_bytes());
            out.extend_from_slice(&sh.entsize.to_le_bytes());
        } else {
            out.extend_from_slice(&sh.name_off.to_le_bytes());
            out.extend_from_slice(&sh.sh_type.to_le_bytes());
            out.extend_from_slice(&(sh.flags as u32).to_le_bytes());
            out.extend_from_slice(&0u32.to_le_bytes());
            out.extend_from_slice(&(sh.offset as u32).to_le_bytes());
            out.extend_from_slice(&(sh.size as u32).to_le_bytes());
            out.extend_from_slice(&sh.link.to_le_bytes());
            out.extend_from_slice(&sh.info.to_le_bytes());
            out.extend_from_slice(&(sh.addralign as u32).to_le_bytes());
            out.extend_from_slice(&(sh.entsize as u32).to_le_bytes());
        }
    }

    let mut eh = Vec::with_capacity(ehdr_size);
    eh.extend_from_slice(&[0x7f, b'E', b'L', b'F']);
    eh.push(if is64 { 2 } else { 1 });
    eh.push(1);
    eh.push(1);
    eh.push(0);
    eh.push(0);
    eh.extend_from_slice(&[0u8; 7]);
    eh.extend_from_slice(&1u16.to_le_bytes());
    eh.extend_from_slice(&243u16.to_le_bytes());
    eh.extend_from_slice(&1u32.to_le_bytes());
    if is64 {
        eh.extend_from_slice(&0u64.to_le_bytes());
        eh.extend_from_slice(&0u64.to_le_bytes());
        eh.extend_from_slice(&shoff.to_le_bytes());
        eh.extend_from_slice(&e_flags.to_le_bytes());
        eh.extend_from_slice(&(ehdr_size as u16).to_le_bytes());
        eh.extend_from_slice(&0u16.to_le_bytes());
        eh.extend_from_slice(&0u16.to_le_bytes());
        eh.extend_from_slice(&(shdr_size as u16).to_le_bytes());
        eh.extend_from_slice(&(shnum as u16).to_le_bytes());
        eh.extend_from_slice(&(shstr_idx as u16).to_le_bytes());
    } else {
        eh.extend_from_slice(&0u32.to_le_bytes());
        eh.extend_from_slice(&0u32.to_le_bytes());
        eh.extend_from_slice(&(shoff as u32).to_le_bytes());
        eh.extend_from_slice(&e_flags.to_le_bytes());
        eh.extend_from_slice(&(ehdr_size as u16).to_le_bytes());
        eh.extend_from_slice(&0u16.to_le_bytes());
        eh.extend_from_slice(&0u16.to_le_bytes());
        eh.extend_from_slice(&(shdr_size as u16).to_le_bytes());
        eh.extend_from_slice(&(shnum as u16).to_le_bytes());
        eh.extend_from_slice(&(shstr_idx as u16).to_le_bytes());
    }
    out[..ehdr_size].copy_from_slice(&eh);

    let mut f = std::fs::File::create(path)?;
    f.write_all(&out)?;
    Ok(())
}
