// symbols：符號表（class 層 static/field 與 function 層 arg/local）。
use std::collections::HashMap;

#[derive(Clone, Copy, PartialEq)]
pub enum Seg {
    Static,
    Field,
    Arg,
    Local,
}

impl Seg {
    pub fn vm(self) -> &'static str {
        match self {
            Seg::Static => "static",
            Seg::Field => "this",
            Seg::Arg => "argument",
            Seg::Local => "local",
        }
    }
}

pub struct Symbols {
    class_map: HashMap<String, (Seg, usize, String)>,
    fn_map: HashMap<String, (Seg, usize, String)>,
    n_statics: usize,
    pub n_fields: usize,
    n_args: usize,
    pub n_locals: usize,
}

impl Symbols {
    pub fn new_class() -> Symbols {
        Symbols {
            class_map: HashMap::new(),
            fn_map: HashMap::new(),
            n_statics: 0,
            n_fields: 0,
            n_args: 0,
            n_locals: 0,
        }
    }

    // 每個 subroutine 開始時清空 function 層；method 預留 argument 0 給 this
    pub fn begin_fn(&mut self, is_method: bool) {
        self.fn_map.clear();
        self.n_args = if is_method { 1 } else { 0 };
        self.n_locals = 0;
    }

    pub fn declare(&mut self, name: &str, seg: Seg, typ: &str) -> Result<usize, String> {
        let (map, counter) = match seg {
            Seg::Static => (&mut self.class_map, &mut self.n_statics),
            Seg::Field => (&mut self.class_map, &mut self.n_fields),
            Seg::Arg => (&mut self.fn_map, &mut self.n_args),
            Seg::Local => (&mut self.fn_map, &mut self.n_locals),
        };
        if map.contains_key(name) {
            return Err(format!("變數 {} 重複宣告", name));
        }
        let idx = *counter;
        *counter += 1;
        map.insert(name.to_string(), (seg, idx, typ.to_string()));
        Ok(idx)
    }

    // function 層優先（可遮蔽 class 層）
    pub fn lookup(&self, name: &str) -> Option<(Seg, usize, String)> {
        self.fn_map.get(name).or_else(|| self.class_map.get(name)).cloned()
    }
}
