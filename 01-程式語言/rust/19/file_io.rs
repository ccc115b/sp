// 19 - 檔案輸出輸入、命令列參數、標準輸入
//
// 編譯：rustc --edition 2021 19/file_io.rs -o file_io
// 執行：./file_io
//       ./file_io 額外的參數
//
// 提醒：執行後會在目前資料夾產生 example_output.txt

use std::env;
use std::fs::{self, OpenOptions};
use std::io::{self, BufRead, BufReader, Write};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    // ---- 命令列參數 ----
    // args()[0] 是程式本身的路徑，真正的參數從 [1] 開始
    let args: Vec<String> = env::args().collect();
    println!("程式：{}", args[0]);
    println!("其他參數：{:?}", &args[1..]);
    if let Some(first) = args.get(1) {
        println!("第一個參數是：{first}");
    } else {
        println!("（沒有額外參數）");
    }

    // ---- 寫入檔案（覆寫）----
    let path = "example_output.txt";
    fs::write(path, "第一行\n第二行\n第三行\n")?;
    println!("已寫入 {path}");

    // ---- 逐行讀取 ----
    println!("--- 逐行讀取 ---");
    let file = fs::File::open(path)?;
    let reader = BufReader::new(file); // 有緩衝，效能較好
    for (index, line) in reader.lines().enumerate() {
        // lines() 產生的每個元素都是 Result<String, io::Error>
        println!("{}: {}", index + 1, line?);
    }

    // ---- 一次讀成一個字串 ----
    let content = fs::read_to_string(path)?;
    println!(
        "共 {} bytes，{} 行，{} 個字元",
        content.len(),
        content.lines().count(),
        content.chars().count()
    );

    // ---- 追加寫入 ----
    let mut file = OpenOptions::new()
        .append(true) // 不覆寫
        .open(path)?;
    writeln!(file, "第四行")?; // write! / writeln! 巨集
    println!("已追加第四行");

    // ---- 從標準輸入讀一行 ----
    print!("請輸入你的名字：");
    io::stdout().flush()?; // print! 不會自動換行，需手動 flush 才會立刻顯示
    let mut name = String::new();
    io::stdin().read_line(&mut name)?;
    if name.trim().is_empty() {
        println!("（沒輸入東西）");
    } else {
        println!("你好，{}！", name.trim());
    }

    // ---- 額外：把檔案當作資料來源（檔案不存在時的錯誤處理）----
    match fs::read_to_string("不存在的檔案.txt") {
        Ok(text) => println!("意外讀到了：{text}"),
        Err(e) => println!("預期中的錯誤（{}）：{e}", e.kind()),
    }

    println!("完成！可以打開 {path} 看看內容");
    Ok(())
}
