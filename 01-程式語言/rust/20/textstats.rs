// 20 - 小專案：文字統計工具（綜合運用）
//
// 程式：讀取文字檔案，統計行數、字數、字元數、位元組數，
//       並列出最常出現的 5 個字詞。
//
// 編譯：rustc --edition 2021 20/textstats.rs -o textstats
// 執行：./textstats 20/textstats.rs
//       ./textstats README.md 20/textstats.rs   （多個檔案會加總）
//
// 綜合了：Result 錯誤處理、struct、impl、HashMap、迭代器、閉包、命令列參數

use std::collections::HashMap;
use std::env;
use std::fs;

#[derive(Default, Debug)]
struct Stats {
    lines: usize,
    words: usize,
    chars: usize,
    bytes: usize,
    top_words: HashMap<String, usize>,
}

impl Stats {
    // 把另一份統計結果併入自己（多檔加總）
    fn merge(&mut self, other: &Stats) {
        self.lines += other.lines;
        self.words += other.words;
        self.chars += other.chars;
        self.bytes += other.bytes;
        for (word, count) in &other.top_words {
            *self.top_words.entry(word.clone()).or_insert(0) += count;
        }
    }

    // 取出前 n 名（依次數由多到少）
    fn top(&self, n: usize) -> Vec<(String, usize)> {
        let mut list: Vec<(String, usize)> = self
            .top_words
            .iter()
            .map(|(w, c)| (w.clone(), *c))
            .collect();
        list.sort_by(|a, b| b.1.cmp(&a.1).then(a.0.cmp(&b.0)));
        list.truncate(n);
        list
    }

    // 印出表格
    fn table(&self) -> String {
        let mut out = String::new();
        out.push_str(&format!("  行數 {:>8}\n", self.lines));
        out.push_str(&format!("  字數 {:>8}\n", self.words));
        out.push_str(&format!("  字元 {:>8}\n", self.chars));
        out.push_str(&format!("  位元組 {:>6}\n", self.bytes));
        out.push_str("  常見字詞：\n");
        for (word, count) in self.top(5) {
            out.push_str(&format!("    {:>4}  {}\n", count, word));
        }
        out
    }
}

fn main() {
    let args: Vec<String> = env::args().skip(1).collect();

    if args.is_empty() {
        eprintln!("用法：textstats <檔案> [更多檔案...]");
        eprintln!("例如：textstats README.md 20/textstats.rs");
        std::process::exit(2); // 2 代表「用法錯誤」的慣例退出碼
    }

    let mut total = Stats::default();
    let mut failed = false;

    for path in &args {
        match analyze(path) {
            Ok(stats) => {
                println!("=== {path} ===");
                print!("{}", stats.table());
                total.merge(&stats);
            }
            Err(e) => {
                eprintln!("!! 讀取 {path} 失敗：{e}");
                failed = true;
            }
        }
    }

    if args.len() > 1 {
        println!("=== 全部合計 ===");
        print!("{}", total.table());
    }

    if failed {
        std::process::exit(1); // 有檔案失敗，回傳非 0
    }
}

fn analyze(path: &str) -> Result<Stats, std::io::Error> {
    let text = fs::read_to_string(path)?;

    let mut stats = Stats {
        lines: text.lines().count(),
        words: text.split_whitespace().count(),
        chars: text.chars().count(),
        bytes: text.len(),
        top_words: HashMap::new(),
    };

    // 以字母/數字為界切出字詞，轉成小寫後統計
    for raw in text.split(|c: char| !c.is_alphanumeric()) {
        if raw.is_empty() {
            continue;
        }
        let word = raw.to_lowercase();
        if word.chars().count() > 1 {
            // 篩掉單一字元，讓結果比較有意義
            *stats.top_words.entry(word).or_insert(0) += 1;
        }
    }

    Ok(stats)
}
