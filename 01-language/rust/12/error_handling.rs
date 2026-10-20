// 12 - 錯誤處理：panic 與 Result
//
// 編譯：rustc --edition 2021 12/error_handling.rs -o error_handling
// 執行：./error_handling

use std::fs::{self, File};
use std::io::{self, ErrorKind, Read};

fn main() {
    // ================= 1) panic：不可恢復的錯誤 =================
    // panic 會中止程式並印出訊息與堆疊（RUST_BACKTRACE=1 可看堆疊）
    // let v = vec![1, 2, 3];
    // let _x = v[99]; // ← 取消註解：index out of bounds
    // panic!("自訂的錯誤訊息"); // ← 取消註解

    // ================= 2) Result<T, E>：可恢復的錯誤 =================
    // Result 也是一個 enum：Ok(T) 或 Err(E)
    match read_first_line("這個檔案一定不存在.txt") {
        Ok(text) => println!("讀到了：{text}"),
        Err(e) => println!("預期中的錯誤：{e}"),
    }

    // ================= 3) 依錯誤種類分別處理 =================
    match File::open("也不存在.txt") {
        Ok(_f) => println!("開啟成功"),
        Err(e) if e.kind() == ErrorKind::NotFound => {
            println!("檔案不存在 → 可以自動建立");
        }
        Err(e) => println!("其他錯誤：{e}"),
    }

    // ================= 4) unwrap / expect：直接解開 =================
    // Err 就會 panic，適合在「不該失敗」或原型階段使用
    let ok: Result<i32, String> = Ok(42);
    println!("{}", ok.expect("這應該是 Ok"));
    // let bad: Result<i32, String> = Err("炸了".into());
    // bad.unwrap(); // ← 取消註解會 panic
    // bad.expect("這應該是 Ok"); // ← 同上，且會印出自訂訊息

    // 不想 panic 的替代寫法（這些方法會「拿走」self，所以要再用一次得先 clone）
    let missing: Result<i32, String> = Err("找不到".into());
    println!("unwrap_or = {}", missing.clone().unwrap_or(0));
    println!(
        "unwrap_or_else = {}",
        missing.unwrap_or_else(|e| {
            println!("（收到錯誤：{e}）");
            -1
        })
    );

    // ================= 5) ? 運算子：錯誤往上傳 =================
    // ? 會在 Ok 時取出值，在 Err 時直接把錯誤 return 給呼叫者
    match run() {
        Ok(total) => println!("run 成功，總和 = {total}"),
        Err(e) => println!("run 失敗：{e}"),
    }

    // ================= 6) 讓使用者看得到錯誤，但程式正常收尾 =================
    if let Err(e) = do_work() {
        eprintln!("失敗了：{e}"); // eprintln! 印到 stderr
        println!("→ 改用預設值繼續執行");
        // 若要讓 shell 知道失敗，可以：
        // eprintln!("失敗了：{e}");
        // std::process::exit(1); // 回傳非 0 代表失敗
    }
}

fn read_first_line(path: &str) -> Result<String, io::Error> {
    // File::open 回傳 Result<File, io::Error>；? 會把 Err 直接傳回去
    let mut file = File::open(path)?;
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;
    Ok(contents.lines().next().unwrap_or("").to_string())
}

fn parse_number(s: &str) -> Result<i32, std::num::ParseIntError> {
    s.parse::<i32>() // 字串解析成整數，失敗會回傳 Err
}

fn run() -> Result<i32, Box<dyn std::error::Error>> {
    // Box<dyn Error> 可以「統一」各種不同錯誤型別（需要 From 轉換，? 會自動做）
    let a = parse_number("10")?;
    let b = parse_number("20")?;
    Ok(a + b)
}

fn do_work() -> Result<String, io::Error> {
    let text = fs::read_to_string("不存在的資料.txt")?;
    Ok(text)
}
