//! # llopt — 純 Rust 的 LLVM IR (.ll) 文字層級優化器
//!
//! 用法：
//! ```text
//! llopt <input.ll> <output.ll> [-v]
//! llopt <input.ll> -o <output.ll> [--verbose]
//! ```
//! 輸入、輸出都是人類可讀的 LLVM IR 文字檔（.ll）。
//! 本程式只用標準函式庫，不需要安裝 LLVM。
//!
//! ## 實作的優化技巧（Pass）
//!
//! | # | 技巧 | 說明 |
//! |---|------|------|
//! | 1 | **常數摺疊 Constant Folding** | 兩個運算元都是常數 → 編譯期直接算出結果。`add i32 2, 3` → `5` |
//! | 2 | **代數化簡 Algebraic Simplification** | 利用恆等式：`x+0=x`、`x*1=x`、`x*0=0`、`x-x=0`、`x&x=x`、`icmp eq x,x = true` … |
//! | 3 | **強度削減 Strength Reduction** | 以便宜指令取代昂貴指令：`mul x,8`→`shl x,3`、`udiv x,8`→`lshr x,3`、`urem x,8`→`and x,7` |
//! | 4 | **運算元正規化 Canonicalization** | 交換律運算讓常數永遠在右邊，`icmp` 常數在左則交換述詞；讓其他 pass 與 CSE 只需處理一種形式 |
//! | 5 | **常數/複製傳播 Constant & Copy Propagation** | 1~3 產生「v 等於某值」後，把所有使用 v 的地方直接換成該值（SSA 下只需改寫 use） |
//! | 6 | **共同子運算式消除 CSE (Local Value Numbering)** | 同一基本區塊內，相同運算且運算元相同 → 重用第一次的結果（加法/乘法等交換律運算會先排序運算元） |
//! | 7 | **Store→Load 轉送 (Store-to-Load Forwarding)** | 對「位址不外洩」的 `alloca`：區塊內 `store v, p` 之後的 `load p` 直接用 `v`（簡化版 mem2reg） |
//! | 8 | **死 alloca / 死 store 消除** | 轉送後若 `alloca` 再也沒有被 load，就把它與所有 store 一起刪除 |
//! | 9 | **Phi 化簡** | 所有來源值都相同的 `phi`（忽略自我參照）→ 直接用該值 |
//! | 10 | **分支摺疊 Branch Folding** | `br i1 true, A, B` → `br A`；`br c, A, A` → `br A`；並同步修正目標區塊的 phi |
//! | 11 | **不可達區塊移除 Unreachable Block Elimination** | 從 entry 做 DFS，沒走到的區塊全部刪除，並清掉其他 phi 中對應的來源 |
//! | 12 | **基本區塊合併 Block Merging** | `A: ... br B`，且 B 只有 A 一個前驅 → 把 B 併進 A（消除無謂跳轉，也暴露更多局部優化機會） |
//! | 13 | **死碼消除 DCE** | 結果沒人使用、且沒有副作用的指令 → 刪除（反覆執行直到不動點） |
//!
//! 所有 Pass 會反覆迭代直到「不動點」：一個 pass 的結果常常讓另一個 pass 有新的機會
//! （例如：常數摺疊 → 分支摺疊 → 區塊不可達 → 區塊合併 → 更多 CSE / DCE）。
//!
//! ## 為什麼可以安全地做這些事？
//! LLVM IR 是 **SSA（靜態單一賦值）** 形式：每個 `%x` 只會被定義一次，
//! 因此「把 `%x` 的所有使用處換成另一個值」永遠是語意等價的，這是 1、2、5、6、7、9 的基礎。
//!
//! ## 已知限制（刻意保持簡單，方便閱讀）
//! * 只處理整數 (`i1`~`i64`) 與指標的常見指令；浮點、向量、聚合型別原樣保留。
//! * CSE 與 Store→Load 轉送只在單一基本區塊內進行（沒有 dominator tree）。
//! * 沒有跨區塊 mem2reg、迴圈優化、內聯。
//! * 含例外處理（invoke / landingpad / callbr / indirectbr …）的函式會原封不動輸出。

use std::collections::{BTreeMap, HashMap, HashSet};
use std::{env, fs, process};

// ───────────────────────────── 技巧名稱（用於統計與 -v 輸出） ─────────────────────────────

const T_FOLD: &str = "常數摺疊 (Constant Folding)";
const T_ALG: &str = "代數化簡 (Algebraic Simplification)";
const T_STR: &str = "強度削減 (Strength Reduction)";
const T_CANON: &str = "運算元正規化 (Canonicalization)";
const T_CSE: &str = "共同子運算式消除 (CSE)";
const T_FWD: &str = "Store→Load 轉送 (Store-to-Load Forwarding)";
const T_DEADALLOCA: &str = "死 alloca/store 消除 (Dead Alloca Elimination)";
const T_PHI: &str = "Phi 化簡 (Phi Simplification)";
const T_BR: &str = "分支摺疊 (Branch Folding)";
const T_UNREACH: &str = "不可達區塊移除 (Unreachable Block Elimination)";
const T_MERGE: &str = "基本區塊合併 (Block Merging)";
const T_DCE: &str = "死碼消除 (Dead Code Elimination)";

/// 為隱含（未命名）的 entry 區塊暫時使用的標籤，輸出前會被改回數字編號。
const ENTRY: &str = "__entry__";

struct Stats {
    counts: BTreeMap<&'static str, usize>,
    verbose: bool,
}

impl Stats {
    fn hit(&mut self, tech: &'static str, detail: impl AsRef<str>) {
        *self.counts.entry(tech).or_insert(0) += 1;
        if self.verbose {
            eprintln!("  [{tech}] {}", detail.as_ref());
        }
    }
}

// ───────────────────────────── 詞法小工具 ─────────────────────────────
//
// 我們不做完整的 LLVM IR 解析器，而是「以文字為真相來源」：
// 每條指令保留為字串，需要分析時才 parse 成 `Kind`，需要改寫時才產生新文字。
// 這樣不認得的指令（call、getelementptr、浮點…）可以原樣保留，不會壞掉。

fn is_ident_char(c: u8) -> bool {
    c.is_ascii_alphanumeric() || matches!(c, b'.' | b'_' | b'$' | b'-')
}

/// `s[pos]` 必須是 '%'，回傳該 local 名稱的結束位置（不含）。支援 `%"quoted name"`。
fn local_end(s: &str, pos: usize) -> usize {
    let b = s.as_bytes();
    let mut j = pos + 1;
    if j < b.len() && b[j] == b'"' {
        j += 1;
        while j < b.len() && b[j] != b'"' {
            j += 1;
        }
        return (j + 1).min(b.len());
    }
    while j < b.len() && is_ident_char(b[j]) {
        j += 1;
    }
    j
}

/// 走訪字串中所有 `%name`（跳過 "..." 字串常值），以 (起, 迄) 位置回呼。
fn for_each_local(s: &str, mut f: impl FnMut(usize, usize)) {
    let b = s.as_bytes();
    let mut i = 0;
    while i < b.len() {
        match b[i] {
            b'"' => {
                i += 1;
                while i < b.len() && b[i] != b'"' {
                    i += 1;
                }
                i += 1;
            }
            b'%' => {
                let e = local_end(s, i);
                if e > i + 1 {
                    f(i, e);
                }
                i = e.max(i + 1);
            }
            _ => i += 1,
        }
    }
}

fn locals_in(s: &str) -> Vec<String> {
    let mut v = Vec::new();
    for_each_local(s, |a, b| v.push(s[a..b].to_string()));
    v
}

/// 同時替換多個 local 名稱（一次掃描，所以 `%5→%4, %6→%5` 這種互換不會連鎖）。
fn replace_locals(s: &str, map: &HashMap<String, String>) -> String {
    let mut out = String::with_capacity(s.len());
    let mut last = 0;
    for_each_local(s, |a, b| {
        if let Some(r) = map.get(&s[a..b]) {
            out.push_str(&s[last..a]);
            out.push_str(r);
            last = b;
        }
    });
    out.push_str(&s[last..]);
    out
}

/// `%x = add ...` → (Some("%x"), "add ...")；沒有定義者 → (None, 原字串)
fn split_def(s: &str) -> (Option<&str>, &str) {
    if s.starts_with('%') {
        let e = local_end(s, 0);
        if let Some(r) = s[e..].trim_start().strip_prefix('=') {
            return (Some(&s[..e]), r.trim_start());
        }
    }
    (None, s)
}

/// 取第一個以空白分隔的 token 與其後剩餘字串。
fn tok(s: &str) -> (&str, &str) {
    let s = s.trim_start();
    match s.find(char::is_whitespace) {
        Some(i) => (&s[..i], s[i..].trim_start()),
        None => (s, ""),
    }
}

/// 去掉行尾的 metadata 附註，例如 `, !dbg !12`、`, !tbaa !5`。
fn strip_meta(s: &str) -> &str {
    match s.find(", !") {
        Some(i) => s[..i].trim_end(),
        None => s.trim_end(),
    }
}

/// 一個單一 token 的運算元（常數或 %name），不能含空白。
fn operand(s: &str) -> Option<String> {
    let s = s.trim();
    if s.is_empty() || s.contains(char::is_whitespace) {
        None
    } else {
        Some(s.to_string())
    }
}

/// 後面接著 label 名稱（`%name` 去掉 `%`）。
fn succs(t: &str) -> Vec<String> {
    let mut v = Vec::new();
    for (i, _) in t.match_indices("label %") {
        let p = i + 6;
        let e = local_end(t, p);
        v.push(t[p + 1..e].to_string());
    }
    v
}

// ───────────────────────────── 整數常數工具 ─────────────────────────────

fn int_bits(t: &str) -> Option<u32> {
    t.strip_prefix('i')?
        .parse::<u32>()
        .ok()
        .filter(|b| (1..=64).contains(b))
}

fn scalar_ty(t: &str) -> bool {
    int_bits(t).is_some()
        || t == "ptr"
        || (t.ends_with('*') && !t.starts_with(['{', '<', '[', '(']) && !t.contains(' '))
}

fn mask(bits: u32) -> u128 {
    (1u128 << bits) - 1
}

fn to_signed(v: u128, bits: u32) -> i128 {
    if v & (1u128 << (bits - 1)) != 0 {
        v as i128 - (1i128 << bits)
    } else {
        v as i128
    }
}

/// 常數運算元 → 以 `bits` 位元遮罩後的無號值。
fn const_of(s: &str, bits: u32) -> Option<u128> {
    match s {
        "true" => Some(1),
        "false" => Some(0),
        _ => {
            let v: i128 = s.parse().ok()?;
            Some((v as u128) & mask(bits))
        }
    }
}

fn fmt_const(v: u128, bits: u32) -> String {
    if bits == 1 {
        (if v & 1 == 1 { "true" } else { "false" }).to_string()
    } else {
        to_signed(v & mask(bits), bits).to_string()
    }
}

/// 編譯期求值二元運算。遇到會產生 UB / poison 的情形（除以 0、移位過大、INT_MIN/-1）一律不摺疊。
fn eval_bin(op: &str, x: u128, y: u128, bits: u32) -> Option<u128> {
    let m = mask(bits);
    Some(match op {
        "add" => x.wrapping_add(y) & m,
        "sub" => x.wrapping_sub(y) & m,
        "mul" => x.wrapping_mul(y) & m,
        "and" => x & y,
        "or" => x | y,
        "xor" => x ^ y,
        "udiv" if y != 0 => x / y,
        "urem" if y != 0 => x % y,
        "sdiv" | "srem" => {
            let (sx, sy) = (to_signed(x, bits), to_signed(y, bits));
            if sy == 0 || (sx == -(1i128 << (bits - 1)) && sy == -1) {
                return None;
            }
            let r = if op == "sdiv" { sx / sy } else { sx % sy };
            (r as u128) & m
        }
        "shl" if y < bits as u128 => (x << y as u32) & m,
        "lshr" if y < bits as u128 => x >> y as u32,
        "ashr" if y < bits as u128 => ((to_signed(x, bits) >> y as u32) as u128) & m,
        _ => return None,
    })
}

fn eval_icmp(pred: &str, x: u128, y: u128, bits: u32) -> Option<bool> {
    let (sx, sy) = (to_signed(x, bits), to_signed(y, bits));
    Some(match pred {
        "eq" => x == y,
        "ne" => x != y,
        "ugt" => x > y,
        "uge" => x >= y,
        "ult" => x < y,
        "ule" => x <= y,
        "sgt" => sx > sy,
        "sge" => sx >= sy,
        "slt" => sx < sy,
        "sle" => sx <= sy,
        _ => return None,
    })
}

fn swap_pred(p: &str) -> Option<&'static str> {
    Some(match p {
        "eq" => "eq",
        "ne" => "ne",
        "ugt" => "ult",
        "uge" => "ule",
        "ult" => "ugt",
        "ule" => "uge",
        "sgt" => "slt",
        "sge" => "sle",
        "slt" => "sgt",
        "sle" => "sge",
        _ => return None,
    })
}

// ───────────────────────────── 指令的結構化檢視 ─────────────────────────────

#[derive(Debug, Clone)]
enum Kind {
    Bin { op: String, flags: String, ty: String, a: String, b: String },
    Icmp { pred: String, ty: String, a: String, b: String },
    Select { c: String, ty: String, a: String, b: String },
    Phi { ty: String, inc: Vec<(String, String)> }, // (值, 前驅區塊名稱[不含 %])
    Load { ty: String, ptr: String },
    Store { ty: String, val: String, ptr: String },
    Alloca,
    Br { target: String },
    CondBr { cond: String, t: String, f: String },
    Other,
}

const BINOPS: [&str; 13] = [
    "add", "sub", "mul", "udiv", "sdiv", "urem", "srem", "and", "or", "xor", "shl", "lshr", "ashr",
];

/// 解析「`%x = ` 之後」的指令本體（或沒有結果值的指令全文）。解析不了就是 `Other`。
fn parse(rest: &str) -> Kind {
    let s = strip_meta(rest);
    let (op, r) = tok(s);
    let k = match op {
        o if BINOPS.contains(&o) => parse_bin(op, r),
        "icmp" => parse_icmp(r),
        "select" => parse_select(r),
        "phi" => parse_phi(r),
        "load" => parse_load(r),
        "store" => parse_store(r),
        "alloca" => Some(Kind::Alloca),
        "br" => parse_br(r),
        _ => None,
    };
    k.unwrap_or(Kind::Other)
}

fn two_operands(r: &str) -> Option<(String, String)> {
    let p: Vec<&str> = r.split(',').collect();
    if p.len() != 2 {
        return None;
    }
    Some((operand(p[0])?, operand(p[1])?))
}

fn parse_bin(op: &str, r: &str) -> Option<Kind> {
    let mut flags: Vec<&str> = Vec::new();
    let (mut ty, mut r) = tok(r);
    while matches!(ty, "nsw" | "nuw" | "exact" | "disjoint") {
        flags.push(ty);
        (ty, r) = tok(r);
    }
    int_bits(ty)?;
    let (a, b) = two_operands(r)?;
    Some(Kind::Bin { op: op.into(), flags: flags.join(" "), ty: ty.into(), a, b })
}

fn parse_icmp(r: &str) -> Option<Kind> {
    let (pred, r) = tok(r);
    let (ty, r) = tok(r);
    if !scalar_ty(ty) || swap_pred(pred).is_none() {
        return None;
    }
    let (a, b) = two_operands(r)?;
    Some(Kind::Icmp { pred: pred.into(), ty: ty.into(), a, b })
}

fn parse_select(r: &str) -> Option<Kind> {
    let p: Vec<&str> = r.split(',').collect();
    if p.len() != 3 {
        return None;
    }
    let (cty, c) = tok(p[0]);
    let (t1, a) = tok(p[1]);
    let (t2, b) = tok(p[2]);
    if cty != "i1" || t1 != t2 || !scalar_ty(t1) {
        return None;
    }
    Some(Kind::Select { c: operand(c)?, ty: t1.into(), a: operand(a)?, b: operand(b)? })
}

fn parse_phi(r: &str) -> Option<Kind> {
    let (ty, mut rem) = tok(r);
    if ty.is_empty() || ty.starts_with(['[', '{', '<', '(']) {
        return None;
    }
    let mut inc = Vec::new();
    while let Some(st) = rem.find('[') {
        let en = rem[st..].find(']')? + st;
        let parts: Vec<&str> = rem[st + 1..en].split(',').collect();
        if parts.len() != 2 {
            return None;
        }
        let v = operand(parts[0])?;
        let l = parts[1].trim().strip_prefix('%')?;
        inc.push((v, l.to_string()));
        rem = &rem[en + 1..];
    }
    if inc.is_empty() {
        None
    } else {
        Some(Kind::Phi { ty: ty.into(), inc })
    }
}

fn parse_load(r: &str) -> Option<Kind> {
    let p: Vec<&str> = r.split(',').collect();
    if p.len() < 2 {
        return None;
    }
    let ty = p[0].trim(); // "volatile i32" / "atomic i32" 含空白 → scalar_ty 失敗 → Other
    if !scalar_ty(ty) {
        return None;
    }
    let (_pty, ptr) = tok(p[1]);
    Some(Kind::Load { ty: ty.into(), ptr: operand(ptr)? })
}

fn parse_store(r: &str) -> Option<Kind> {
    let p: Vec<&str> = r.split(',').collect();
    if p.len() < 2 {
        return None;
    }
    let (ty, val) = tok(p[0]);
    if !scalar_ty(ty) {
        return None;
    }
    let (_pty, ptr) = tok(p[1]);
    Some(Kind::Store { ty: ty.into(), val: operand(val)?, ptr: operand(ptr)? })
}

fn parse_br(r: &str) -> Option<Kind> {
    if let Some(l) = r.strip_prefix("label") {
        return Some(Kind::Br { target: l.trim().strip_prefix('%')?.to_string() });
    }
    let p: Vec<&str> = r.split(',').collect();
    if p.len() != 3 {
        return None;
    }
    let (cty, c) = tok(p[0]);
    if cty != "i1" {
        return None;
    }
    let lab = |s: &str| -> Option<String> {
        Some(s.trim().strip_prefix("label")?.trim().strip_prefix('%')?.to_string())
    };
    Some(Kind::CondBr { cond: operand(c)?, t: lab(p[1])?, f: lab(p[2])? })
}

fn fl(flags: &str) -> String {
    if flags.is_empty() { String::new() } else { format!(" {flags}") }
}

fn render_phi(dst: &str, ty: &str, inc: &[(String, String)]) -> String {
    let body: Vec<String> = inc.iter().map(|(v, l)| format!("[ {v}, %{l} ]")).collect();
    format!("{dst} = phi {ty} {}", body.join(", "))
}

// ───────────────────────────── 函式 / 基本區塊 ─────────────────────────────

struct Block {
    label: String, // 不含 '%'、不含 ':'
    insts: Vec<String>,
}

struct Func {
    header: String,
    blocks: Vec<Block>,
    implicit_entry: bool, // entry 區塊沒有寫標籤
}

impl Func {
    /// SSA 的核心操作：把所有使用 `from` 的地方換成 `to`。
    fn replace_uses(&mut self, from: &str, to: &str) {
        let mut m = HashMap::new();
        m.insert(from.to_string(), to.to_string());
        for b in &mut self.blocks {
            for i in &mut b.insts {
                if i.contains(from) {
                    *i = replace_locals(i, &m);
                }
            }
        }
    }
}

// ───────────────────────────── Pass 1~5：局部化簡（摺疊 / 代數 / 強度 / 正規化 / 傳播） ─────────────────────────────

enum Simpl {
    /// 此指令的結果恆等於某個值 → 刪除指令並把所有使用處換成該值（常數/複製傳播）
    Replace(String),
    /// 以較好的形式重寫此指令
    Rewrite(String),
}

fn simplify(dst: &str, k: &Kind) -> Option<(Simpl, &'static str)> {
    use Simpl::*;
    match k {
        Kind::Bin { op, flags, ty, a, b } => {
            let bits = int_bits(ty)?;
            let m = mask(bits);
            let (ca, cb) = (const_of(a, bits), const_of(b, bits));

            // (1) 常數摺疊
            if let (Some(x), Some(y)) = (ca, cb) {
                if let Some(r) = eval_bin(op, x, y, bits) {
                    return Some((Replace(fmt_const(r, bits)), T_FOLD));
                }
            }
            // (4) 正規化：交換律運算，常數放右邊
            let commutative = matches!(op.as_str(), "add" | "mul" | "and" | "or" | "xor");
            if commutative && ca.is_some() && cb.is_none() {
                let t = format!("{dst} = {op}{} {ty} {b}, {a}", fl(flags));
                return Some((Rewrite(t), T_CANON));
            }
            // (2) 代數恆等式（右運算元為常數）
            if let Some(y) = cb {
                let zero = || Replace(fmt_const(0, bits));
                let same = || Replace(a.clone());
                let r = match op.as_str() {
                    "add" | "sub" | "or" | "xor" | "shl" | "lshr" | "ashr" if y == 0 => Some(same()),
                    "mul" | "and" if y == 0 => Some(zero()),
                    "mul" | "udiv" | "sdiv" if y == 1 => Some(same()),
                    "and" if y == m => Some(same()),
                    "or" if y == m => Some(Replace(fmt_const(m, bits))),
                    "urem" | "srem" if y == 1 => Some(zero()),
                    _ => None,
                };
                if let Some(r) = r {
                    return Some((r, T_ALG));
                }
                // (3) 強度削減：2 的冪
                if y >= 2 && y.is_power_of_two() {
                    let kbit = fmt_const(y.trailing_zeros() as u128, bits);
                    let t = match op.as_str() {
                        "mul" => Some(format!("{dst} = shl {ty} {a}, {kbit}")),
                        "udiv" => Some(format!("{dst} = lshr {ty} {a}, {kbit}")),
                        "urem" => Some(format!("{dst} = and {ty} {a}, {}", fmt_const(y - 1, bits))),
                        _ => None,
                    };
                    if let Some(t) = t {
                        return Some((Rewrite(t), T_STR));
                    }
                }
            }
            // (2) 相同運算元
            if a == b {
                match op.as_str() {
                    "sub" | "xor" => return Some((Replace(fmt_const(0, bits)), T_ALG)),
                    "and" | "or" => return Some((Replace(a.clone()), T_ALG)),
                    _ => {}
                }
            }
            None
        }
        Kind::Icmp { pred, ty, a, b } => {
            let bits = int_bits(ty);
            let (ca, cb) = match bits {
                Some(bt) => (const_of(a, bt), const_of(b, bt)),
                None => (None, None),
            };
            if let (Some(bt), Some(x), Some(y)) = (bits, ca, cb) {
                let r = eval_icmp(pred, x, y, bt)?;
                return Some((Replace(fmt_const(r as u128, 1)), T_FOLD));
            }
            if a == b {
                let r = match pred.as_str() {
                    "eq" | "ule" | "uge" | "sle" | "sge" => true,
                    _ => false,
                };
                return Some((Replace(fmt_const(r as u128, 1)), T_ALG));
            }
            if ca.is_some() && cb.is_none() {
                let t = format!("{dst} = icmp {} {ty} {b}, {a}", swap_pred(pred)?);
                return Some((Rewrite(t), T_CANON));
            }
            if let (Some(bt), Some(y)) = (bits, cb) {
                let m = mask(bt);
                let r = match (pred.as_str(), y) {
                    ("ult", 0) => Some(false), // 無號數不可能 < 0
                    ("uge", 0) => Some(true),
                    ("ugt", v) if v == m => Some(false), // 不可能 > 最大值
                    ("ule", v) if v == m => Some(true),
                    _ => None,
                };
                if let Some(r) = r {
                    return Some((Replace(fmt_const(r as u128, 1)), T_ALG));
                }
            }
            None
        }
        Kind::Select { c, ty, a, b } => {
            if a == b {
                return Some((Replace(a.clone()), T_ALG));
            }
            match c.as_str() {
                "true" => return Some((Replace(a.clone()), T_FOLD)),
                "false" => return Some((Replace(b.clone()), T_FOLD)),
                _ => {}
            }
            if ty == "i1" && a == "true" && b == "false" {
                return Some((Replace(c.clone()), T_ALG));
            }
            None
        }
        _ => None,
    }
}

fn pass_simplify(func: &mut Func, st: &mut Stats) -> bool {
    let mut changed = false;
    for bi in 0..func.blocks.len() {
        let mut i = 0;
        while i < func.blocks[bi].insts.len() {
            let text = func.blocks[bi].insts[i].clone();
            let (dst, rest) = split_def(&text);
            if let Some(dst) = dst {
                if let Some((action, tech)) = simplify(dst, &parse(rest)) {
                    match action {
                        Simpl::Replace(v) if v != dst => {
                            st.hit(tech, format!("{text}   ⟹   {dst} ≡ {v}"));
                            func.blocks[bi].insts.remove(i);
                            func.replace_uses(dst, &v); // 常數/複製傳播
                            changed = true;
                            continue;
                        }
                        Simpl::Rewrite(t) => {
                            st.hit(tech, format!("{text}   ⟹   {t}"));
                            func.blocks[bi].insts[i] = t;
                            changed = true;
                        }
                        _ => {}
                    }
                }
            }
            i += 1;
        }
    }
    changed
}

// ───────────────────────────── Pass 6：區塊內 CSE（Local Value Numbering） ─────────────────────────────

/// 為「純函數式」指令算出一個 key：key 相同 ⟺ 一定算出相同的值。
fn cse_key(rest: &str) -> Option<String> {
    match parse(rest) {
        Kind::Bin { op, flags, ty, a, b } => {
            let (a, b) = if matches!(op.as_str(), "add" | "mul" | "and" | "or" | "xor") && a > b {
                (b, a) // 交換律：排序運算元，`add a,b` 與 `add b,a` 得到同一個 key
            } else {
                (a, b)
            };
            Some(format!("bin|{op}|{flags}|{ty}|{a}|{b}"))
        }
        Kind::Icmp { pred, ty, a, b } => Some(format!("icmp|{pred}|{ty}|{a}|{b}")),
        Kind::Select { c, ty, a, b } => Some(format!("sel|{ty}|{c}|{a}|{b}")),
        Kind::Other => {
            let (op, _) = tok(rest);
            matches!(
                op,
                "getelementptr" | "zext" | "sext" | "trunc" | "bitcast" | "ptrtoint" | "inttoptr"
                    | "extractvalue" | "insertvalue"
            )
            .then(|| format!("raw|{}", rest.trim()))
        }
        _ => None, // load / alloca / phi / call ... 不能 CSE
    }
}

fn pass_cse(func: &mut Func, st: &mut Stats) -> bool {
    let mut changed = false;
    for bi in 0..func.blocks.len() {
        let mut seen: HashMap<String, String> = HashMap::new();
        let mut i = 0;
        while i < func.blocks[bi].insts.len() {
            let text = func.blocks[bi].insts[i].clone();
            let (dst, rest) = split_def(&text);
            if let Some(dst) = dst {
                if let Some(key) = cse_key(rest) {
                    if let Some(prev) = seen.get(&key).cloned() {
                        st.hit(T_CSE, format!("{text}   ⟹   重用 {prev}"));
                        func.blocks[bi].insts.remove(i);
                        func.replace_uses(dst, &prev);
                        changed = true;
                        continue;
                    }
                    seen.insert(key, dst.to_string());
                }
            }
            i += 1;
        }
    }
    changed
}

// ───────────────────────────── Pass 7~8：Store→Load 轉送、死 alloca 消除 ─────────────────────────────

fn pass_mem(func: &mut Func, st: &mut Stats) -> bool {
    let mut changed = false;

    // (a) 收集所有 alloca，並做簡單的「逃逸分析」：
    //     只有「每一次出現都是 load/store 的位址運算元」的 alloca，其內容才只會被我們看得到的指令改變。
    let mut allocas: HashSet<String> = HashSet::new();
    for b in &func.blocks {
        for t in &b.insts {
            if let (Some(d), r) = split_def(t) {
                if matches!(parse(r), Kind::Alloca) {
                    allocas.insert(d.to_string());
                }
            }
        }
    }
    let mut escaped: HashSet<String> = HashSet::new();
    for b in &func.blocks {
        for t in &b.insts {
            let (_, r) = split_def(t);
            let k = parse(r);
            for name in locals_in(r) {
                if !allocas.contains(&name) {
                    continue;
                }
                let ok = match &k {
                    Kind::Load { ptr, .. } => *ptr == name,
                    Kind::Store { val, ptr, .. } => *ptr == name && *val != name, // 把位址本身存出去 = 逃逸
                    _ => false, // 傳給 call、gep、bitcast、volatile 存取… 一律視為逃逸
                };
                if !ok {
                    escaped.insert(name);
                }
            }
        }
    }
    let mut tracked: Vec<String> = allocas.difference(&escaped).cloned().collect();
    tracked.sort();
    let tracked_set: HashSet<&String> = tracked.iter().collect();

    // (b) 區塊內 Store→Load 轉送：記住「這個 alloca 目前裝的值」
    for bi in 0..func.blocks.len() {
        let mut known: HashMap<String, (String, String)> = HashMap::new(); // ptr -> (型別, 值)
        let mut i = 0;
        while i < func.blocks[bi].insts.len() {
            let text = func.blocks[bi].insts[i].clone();
            let (dst, rest) = split_def(&text);
            match parse(rest) {
                Kind::Store { ty, val, ptr } if tracked_set.contains(&ptr) => {
                    known.insert(ptr, (ty, val));
                }
                Kind::Load { ty, ptr } if tracked_set.contains(&ptr) => {
                    let dst = dst.unwrap_or_default().to_string();
                    let hit = known.get(&ptr).filter(|(t, _)| *t == ty).map(|(_, v)| v.clone());
                    if let Some(v) = hit {
                        st.hit(T_FWD, format!("{text}   ⟹   {dst} ≡ {v}"));
                        func.blocks[bi].insts.remove(i);
                        func.replace_uses(&dst, &v);
                        changed = true;
                        continue;
                    }
                    known.insert(ptr, (ty, dst)); // 之後的 load 可重用這次 load 的結果
                }
                _ => {}
            }
            i += 1;
        }
    }

    // (c) 沒有任何 load 的 alloca：它存的東西永遠沒人讀 → 連同所有 store 一起刪除
    for p in &tracked {
        let has_load = func.blocks.iter().flat_map(|b| &b.insts).any(|t| {
            matches!(parse(split_def(t).1), Kind::Load { ptr, .. } if ptr == *p)
        });
        if has_load {
            continue;
        }
        for b in &mut func.blocks {
            b.insts.retain(|t| {
                let (d, r) = split_def(t);
                let dead = d == Some(p.as_str())
                    || matches!(parse(r), Kind::Store { ptr, .. } if ptr == *p);
                if dead {
                    st.hit(T_DEADALLOCA, format!("刪除 {t}"));
                    changed = true;
                }
                !dead
            });
        }
    }
    changed
}

// ───────────────────────────── Pass 9：Phi 化簡 ─────────────────────────────

fn pass_phi(func: &mut Func, st: &mut Stats) -> bool {
    let mut changed = false;
    for bi in 0..func.blocks.len() {
        let mut i = 0;
        while i < func.blocks[bi].insts.len() {
            let text = func.blocks[bi].insts[i].clone();
            if let (Some(dst), rest) = split_def(&text) {
                if let Kind::Phi { inc, .. } = parse(rest) {
                    // 忽略自我參照（迴圈 phi 常見：%x = phi [%init, %pre], [%x, %latch]）
                    let mut uniq: Option<&String> = None;
                    let mut ok = true;
                    for (v, _) in &inc {
                        if v == dst {
                            continue;
                        }
                        match uniq {
                            None => uniq = Some(v),
                            Some(u) if u == v => {}
                            _ => {
                                ok = false;
                                break;
                            }
                        }
                    }
                    if let (true, Some(u)) = (ok, uniq) {
                        let u = u.clone();
                        st.hit(T_PHI, format!("{text}   ⟹   {dst} ≡ {u}"));
                        func.blocks[bi].insts.remove(i);
                        func.replace_uses(dst, &u);
                        changed = true;
                        continue;
                    }
                }
            }
            i += 1;
        }
    }
    changed
}

// ───────────────────────────── Pass 10~12：CFG 化簡 ─────────────────────────────

/// 修正目標區塊的 phi：移除來自 `from` 的來源。
/// `once=true` 只在「同一前驅有 ≥2 筆重複來源」時移除一筆（對應 `br c, X, X` 變成 `br X`）。
fn phi_remove(func: &mut Func, target: &str, from: &str, once: bool) {
    let Some(b) = func.blocks.iter_mut().find(|b| b.label == target) else { return };
    for t in &mut b.insts {
        let (d, r) = split_def(t);
        let (Some(d), Kind::Phi { ty, mut inc }) = (d, parse(r)) else { continue };
        let n = inc.iter().filter(|(_, l)| l == from).count();
        if n == 0 || (once && n < 2) {
            continue;
        }
        if once {
            let pos = inc.iter().position(|(_, l)| l == from).unwrap();
            inc.remove(pos);
        } else {
            inc.retain(|(_, l)| l != from);
        }
        *t = render_phi(d, &ty, &inc);
    }
}

fn fold_branches(func: &mut Func, st: &mut Stats) -> bool {
    let mut changed = false;
    for bi in 0..func.blocks.len() {
        let Some(last) = func.blocks[bi].insts.last().cloned() else { continue };
        let me = func.blocks[bi].label.clone();
        let Kind::CondBr { cond, t, f } = parse(&last) else { continue };
        let (keep, dropped) = if t == f {
            (t.clone(), None)
        } else {
            match cond.as_str() {
                "true" => (t.clone(), Some(f.clone())),
                "false" => (f.clone(), Some(t.clone())),
                _ => continue,
            }
        };
        let new = format!("br label %{keep}");
        st.hit(T_BR, format!("{last}   ⟹   {new}"));
        *func.blocks[bi].insts.last_mut().unwrap() = new;
        match dropped {
            Some(d) => phi_remove(func, &d, &me, false),
            None => phi_remove(func, &keep, &me, true),
        }
        changed = true;
    }
    changed
}

fn remove_unreachable(func: &mut Func, st: &mut Stats) -> bool {
    let idx: HashMap<String, usize> =
        func.blocks.iter().enumerate().map(|(i, b)| (b.label.clone(), i)).collect();
    let mut seen = vec![false; func.blocks.len()];
    let mut stack = vec![0usize];
    seen[0] = true;
    while let Some(i) = stack.pop() {
        if let Some(t) = func.blocks[i].insts.last() {
            for s in succs(t) {
                if let Some(&j) = idx.get(&s) {
                    if !seen[j] {
                        seen[j] = true;
                        stack.push(j);
                    }
                }
            }
        }
    }
    if seen.iter().all(|&s| s) {
        return false;
    }
    let mut removed: HashSet<String> = HashSet::new();
    let mut k = 0;
    func.blocks.retain(|b| {
        let keep = seen[k];
        k += 1;
        if !keep {
            st.hit(T_UNREACH, format!("刪除區塊 %{}（{} 條指令）", b.label, b.insts.len()));
            removed.insert(b.label.clone());
        }
        keep
    });
    // 其他區塊 phi 中來自已刪除區塊的來源也要移除
    for b in &mut func.blocks {
        for t in &mut b.insts {
            let (d, r) = split_def(t);
            let (Some(d), Kind::Phi { ty, mut inc }) = (d, parse(r)) else { continue };
            let before = inc.len();
            inc.retain(|(_, l)| !removed.contains(l));
            if inc.len() != before {
                *t = render_phi(d, &ty, &inc);
            }
        }
    }
    true
}

fn merge_one(func: &mut Func, st: &mut Stats) -> bool {
    // 前驅「邊」數（與 LLVM 一致：switch / br 多條邊指向同一區塊就算多次）
    let mut preds: HashMap<String, usize> = HashMap::new();
    for b in &func.blocks {
        if let Some(t) = b.insts.last() {
            for s in succs(t) {
                *preds.entry(s).or_default() += 1;
            }
        }
    }
    for ai in 0..func.blocks.len() {
        let Some(last) = func.blocks[ai].insts.last() else { continue };
        let Kind::Br { target } = parse(last) else { continue };
        if target == func.blocks[ai].label || preds.get(&target) != Some(&1) {
            continue;
        }
        let Some(bi) = func.blocks.iter().position(|b| b.label == target) else { continue };
        if bi == 0 {
            continue; // entry 不能被合併掉
        }
        // B 開頭的 phi 因為只有一個前驅，每個都只有 1 筆來源，等價於 copy
        let mut phi_map: HashMap<String, String> = HashMap::new();
        let mut npk = 0;
        let mut ok = true;
        for t in &func.blocks[bi].insts {
            match split_def(t) {
                (Some(d), r) => match parse(r) {
                    Kind::Phi { inc, .. } => {
                        if inc.len() != 1 {
                            ok = false;
                            break;
                        }
                        phi_map.insert(d.to_string(), inc[0].0.clone());
                        npk += 1;
                    }
                    _ => break,
                },
                _ => break,
            }
        }
        if !ok {
            continue;
        }
        let a_label = func.blocks[ai].label.clone();
        st.hit(T_MERGE, format!("把 %{target} 併入 %{a_label}"));
        let b = func.blocks.remove(bi);
        let ai = if bi < ai { ai - 1 } else { ai };
        let mut rename = phi_map; // phi → 其唯一來源值
        rename.insert(format!("%{target}"), format!("%{a_label}")); // 後繼 phi 中的來源區塊名稱 B → A
        func.blocks[ai].insts.pop(); // 拿掉 `br label %B`
        func.blocks[ai].insts.extend(b.insts.into_iter().skip(npk));
        for blk in &mut func.blocks {
            for t in &mut blk.insts {
                *t = replace_locals(t, &rename);
            }
        }
        return true;
    }
    false
}

fn pass_cfg(func: &mut Func, st: &mut Stats) -> bool {
    let mut changed = fold_branches(func, st);
    changed |= remove_unreachable(func, st);
    while merge_one(func, st) {
        changed = true;
    }
    changed
}

// ───────────────────────────── Pass 13：死碼消除 ─────────────────────────────

/// 沒有副作用（不寫記憶體、不 trap 到影響外界、不是 terminator）→ 結果沒人用就能刪。
fn is_removable(rest: &str) -> bool {
    let (op, r) = tok(rest);
    match op {
        "load" => {
            let (t, _) = tok(r);
            !matches!(t, "volatile" | "atomic")
        }
        "add" | "sub" | "mul" | "udiv" | "sdiv" | "urem" | "srem" | "and" | "or" | "xor" | "shl"
        | "lshr" | "ashr" | "icmp" | "fcmp" | "select" | "phi" | "getelementptr" | "zext" | "sext"
        | "trunc" | "bitcast" | "ptrtoint" | "inttoptr" | "extractvalue" | "insertvalue"
        | "alloca" | "freeze" | "fadd" | "fsub" | "fmul" | "fdiv" | "frem" | "fneg" | "fpext"
        | "fptrunc" | "fptoui" | "fptosi" | "uitofp" | "sitofp" => true,
        _ => false,
    }
}

fn pass_dce(func: &mut Func, st: &mut Stats) -> bool {
    let mut changed = false;
    loop {
        let mut used: HashSet<String> = HashSet::new();
        for b in &func.blocks {
            for t in &b.insts {
                for n in locals_in(split_def(t).1) {
                    used.insert(n);
                }
            }
        }
        let mut removed = 0;
        for b in &mut func.blocks {
            b.insts.retain(|t| {
                let (d, r) = split_def(t);
                if let Some(d) = d {
                    if !used.contains(d) && is_removable(r) {
                        st.hit(T_DCE, format!("刪除 {t}"));
                        removed += 1;
                        return false;
                    }
                }
                true
            });
        }
        if removed == 0 {
            break;
        }
        changed = true; // 刪掉一條指令可能讓它的運算元也變成死碼 → 再跑一輪
    }
    changed
}

// ───────────────────────────── 重新編號未命名的值 ─────────────────────────────
//
// clang 預設輸出 `%0 %1 %2 ...` 這種「未命名值」，LLVM 要求它們必須從 0 連續編號。
// 我們刪掉指令後會出現缺號，所以輸出前要重新編號（包含未命名的 entry 區塊本身也佔一個號碼）。

fn header_start(header: &str) -> u64 {
    let Some(at) = header.find('@') else { return 0 };
    let hb = header.as_bytes();
    let mut j = at + 1;
    if j < hb.len() && hb[j] == b'"' {
        j += 1;
        while j < hb.len() && hb[j] != b'"' {
            j += 1;
        }
        j += 1;
    } else {
        while j < hb.len() && is_ident_char(hb[j]) {
            j += 1;
        }
    }
    if j >= hb.len() || hb[j] != b'(' {
        return 0;
    }
    // 找對應的 ')' 並以頂層逗號切出每個參數
    let (mut depth, mut start, mut params) = (0i32, j + 1, Vec::new());
    for (k, c) in header[j..].char_indices() {
        let k = j + k;
        match c {
            '(' | '[' | '{' | '<' => depth += 1,
            ')' | ']' | '}' | '>' => {
                depth -= 1;
                if depth == 0 {
                    params.push(&header[start..k]);
                    break;
                }
            }
            ',' if depth == 1 => {
                params.push(&header[start..k]);
                start = k + 1;
            }
            _ => {}
        }
    }
    let mut next = 0u64;
    for p in params {
        let p = p.trim();
        if p.is_empty() || p == "..." {
            continue;
        }
        let last = p.split_whitespace().last().unwrap_or("");
        let named = last.starts_with('%') && !last.contains(['(', ')', '*', ',']);
        if named {
            if let Ok(n) = last[1..].parse::<u64>() {
                next = n + 1;
            }
        } else {
            next += 1;
        }
    }
    next
}

fn renumber(func: &mut Func) {
    let mut next = header_start(&func.header);
    let mut map: HashMap<String, String> = HashMap::new();
    let implicit = func.implicit_entry;
    for (bi, b) in func.blocks.iter_mut().enumerate() {
        let numeric = !b.label.is_empty() && b.label.bytes().all(|c| c.is_ascii_digit());
        if (bi == 0 && implicit) || numeric {
            map.insert(format!("%{}", b.label), format!("%{next}"));
            b.label = next.to_string();
            next += 1;
        }
        for t in &b.insts {
            if let (Some(d), _) = split_def(t) {
                if d[1..].bytes().all(|c| c.is_ascii_digit()) {
                    map.insert(d.to_string(), format!("%{next}"));
                    next += 1;
                }
            }
        }
    }
    for b in &mut func.blocks {
        for t in &mut b.insts {
            *t = replace_locals(t, &map);
        }
    }
}

// ───────────────────────────── 解析 / 輸出 / 主流程 ─────────────────────────────

const UNSUPPORTED: [&str; 8] = [
    "indirectbr", "callbr", "landingpad", "invoke ", "catchswitch", "cleanuppad", "catchpad",
    "blockaddress",
];

fn parse_func(header: &str, body: &[&str]) -> Option<Func> {
    if body.iter().any(|l| UNSUPPORTED.iter().any(|k| l.contains(k))) {
        return None;
    }
    let mut blocks: Vec<Block> = Vec::new();
    let mut implicit = false;
    let mut pending: Option<String> = None; // 多行 switch 先合併成一行
    for line in body {
        let t = line.trim();
        if t.is_empty() || t.starts_with(';') {
            continue;
        }
        let code = if t.contains('"') { t } else { t.split(';').next().unwrap().trim() };
        if code.is_empty() {
            continue;
        }
        if let Some(p) = pending.as_mut() {
            p.push(' ');
            p.push_str(code);
            if code == "]" {
                let full = pending.take().unwrap();
                blocks.last_mut()?.insts.push(full);
            }
            continue;
        }
        if code.ends_with(':') && !code.contains(" = ") {
            blocks.push(Block { label: code[..code.len() - 1].to_string(), insts: vec![] });
            continue;
        }
        if blocks.is_empty() {
            blocks.push(Block { label: ENTRY.into(), insts: vec![] });
            implicit = true;
        }
        if code.ends_with('[') {
            pending = Some(code.to_string());
        } else {
            blocks.last_mut()?.insts.push(code.to_string());
        }
    }
    if blocks.is_empty() || pending.is_some() {
        return None;
    }
    let mut f = Func { header: header.to_string(), blocks, implicit_entry: implicit };
    if implicit {
        // 原檔中若有 phi 以數字引用隱含 entry，改成暫時名稱
        let n = header_start(header);
        let m = HashMap::from([(format!("%{n}"), format!("%{ENTRY}"))]);
        for b in &mut f.blocks {
            for t in &mut b.insts {
                *t = replace_locals(t, &m);
            }
        }
    }
    Some(f)
}

fn print_func(f: &Func, out: &mut Vec<String>) {
    out.push(f.header.clone());
    for (i, b) in f.blocks.iter().enumerate() {
        if i > 0 {
            out.push(String::new());
        }
        if !(i == 0 && f.implicit_entry) {
            out.push(format!("{}:", b.label));
        }
        for t in &b.insts {
            out.push(format!("  {t}"));
        }
    }
    out.push("}".into());
}

fn optimize_func(func: &mut Func, st: &mut Stats) {
    // 迭代到不動點：每個 pass 的成果常會替其他 pass 製造新機會
    for _ in 0..64 {
        let mut changed = false;
        changed |= pass_simplify(func, st); // 1~5
        changed |= pass_cse(func, st); // 6
        changed |= pass_mem(func, st); // 7~8
        changed |= pass_phi(func, st); // 9
        changed |= pass_cfg(func, st); // 10~12
        changed |= pass_dce(func, st); // 13
        if !changed {
            break;
        }
    }
    renumber(func);
}

fn optimize_module(src: &str, verbose: bool) -> (String, Stats) {
    let mut st = Stats { counts: BTreeMap::new(), verbose };
    let lines: Vec<&str> = src.lines().collect();
    let mut out: Vec<String> = Vec::new();
    let mut i = 0;
    while i < lines.len() {
        let line = lines[i];
        let tl = line.trim();
        if tl.starts_with("define ") && tl.ends_with('{') {
            let mut j = i + 1;
            while j < lines.len() && lines[j].trim() != "}" {
                j += 1;
            }
            let body = &lines[i + 1..j.min(lines.len())];
            match parse_func(line, body) {
                Some(mut f) => {
                    if verbose {
                        eprintln!("▶ 優化 {}", tl);
                    }
                    optimize_func(&mut f, &mut st);
                    print_func(&f, &mut out);
                }
                None => {
                    if verbose {
                        eprintln!("▶ 略過（含不支援的指令）{}", tl);
                    }
                    out.extend(lines[i..=j.min(lines.len() - 1)].iter().map(|s| s.to_string()));
                }
            }
            i = j + 1;
        } else {
            out.push(line.to_string());
            i += 1;
        }
    }
    let mut text = out.join("\n");
    text.push('\n');
    (text, st)
}

fn usage() -> ! {
    eprintln!("用法: llopt <input.ll> <output.ll> [-v|--verbose]\n      llopt <input.ll> -o <output.ll> [-v]");
    process::exit(2);
}

fn main() {
    let mut verbose = false;
    let mut pos: Vec<String> = Vec::new();
    let mut out_path: Option<String> = None;
    let mut it = env::args().skip(1);
    while let Some(a) = it.next() {
        match a.as_str() {
            "-v" | "--verbose" => verbose = true,
            "-o" => out_path = Some(it.next().unwrap_or_else(|| usage())),
            "-h" | "--help" => usage(),
            _ => pos.push(a),
        }
    }
    let input = pos.first().cloned().unwrap_or_else(|| usage());
    let output = out_path
        .or_else(|| pos.get(1).cloned())
        .unwrap_or_else(|| input.strip_suffix(".ll").unwrap_or(&input).to_string() + ".opt.ll");

    let src = fs::read_to_string(&input).unwrap_or_else(|e| {
        eprintln!("無法讀取 {input}: {e}");
        process::exit(1);
    });
    let before = src.lines().filter(|l| !l.trim().is_empty() && !l.trim().starts_with(';')).count();
    let (text, st) = optimize_module(&src, verbose);

    let mut report = String::from("; ──── llopt 優化摘要 ────\n");
    if st.counts.is_empty() {
        report.push_str(";   (沒有可套用的優化)\n");
    }
    for (k, v) in &st.counts {
        report.push_str(&format!(";   {k}: {v} 次\n"));
    }
    let final_text = format!("{report}{text}");
    let after = text.lines().filter(|l| !l.trim().is_empty() && !l.trim().starts_with(';')).count();

    fs::write(&output, &final_text).unwrap_or_else(|e| {
        eprintln!("無法寫入 {output}: {e}");
        process::exit(1);
    });

    eprintln!("完成：{input} → {output}（非空白行 {before} → {after}）");
    for (k, v) in &st.counts {
        eprintln!("  {k}: {v} 次");
    }
}

// ───────────────────────────── 測試 ─────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    fn opt(body: &str) -> String {
        let src = format!("define i32 @f(i32 %n) {{\n{body}\n}}\n");
        optimize_module(&src, false).0
    }

    #[test]
    fn folds_and_propagates() {
        let o = opt("entry:\n  %a = add i32 2, 3\n  %b = mul i32 %a, 4\n  ret i32 %b");
        assert!(o.contains("ret i32 20"), "{o}");
    }

    #[test]
    fn strength_reduction() {
        let o = opt("entry:\n  %a = mul i32 %n, 8\n  %b = urem i32 %a, 4\n  ret i32 %a");
        assert!(o.contains("shl i32 %n, 3"), "{o}");
        assert!(!o.contains("urem"), "{o}");
    }

    #[test]
    fn cse_commutative() {
        let o = opt("entry:\n  %a = add i32 %n, 5\n  %b = add i32 5, %n\n  %c = mul i32 %a, %b\n  ret i32 %c");
        assert_eq!(o.matches("add").count(), 1, "{o}");
        assert!(o.contains("mul i32 %a, %a"), "{o}");
    }

    #[test]
    fn branch_fold_and_merge() {
        let o = opt("entry:\n  br i1 true, label %t, label %e\nt:\n  br label %m\ne:\n  br label %m\nm:\n  %r = phi i32 [ 1, %t ], [ 2, %e ]\n  ret i32 %r");
        assert!(o.contains("ret i32 1"), "{o}");
        assert!(!o.contains("br "), "{o}");
    }

    #[test]
    fn renumbers_unnamed_values() {
        // 未命名的 entry 區塊本身佔用 %1，所以第一個指令結果是 %2
        let src = "define i32 @f(i32 %0) {\n  %2 = add i32 %0, 0\n  %3 = mul i32 %2, %2\n  ret i32 %3\n}\n";
        let o = optimize_module(src, false).0;
        assert!(o.contains("%2 = mul i32 %0, %0"), "{o}");
        // 有名字的 entry 則不佔號碼
        let src = "define i32 @f(i32 %0) {\nentry:\n  %1 = add i32 %0, 0\n  %2 = mul i32 %1, %1\n  ret i32 %2\n}\n";
        let o = optimize_module(src, false).0;
        assert!(o.contains("%1 = mul i32 %0, %0"), "{o}");
    }
}
