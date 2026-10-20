// 18/utils.rs — 對應 main.rs 的 `mod utils;`

use super::shapes::Rectangle; // 用 super 找「上一層」的 shapes 模組

// pub const：其他模組可以用 utils::PI 存取
pub const PI: f64 = 3.14159265358979;

/// 公開的工具函式（/// 開頭是文件註解，會出現在 rustdoc）
pub fn print_info(name: &str, r: &Rectangle) {
    println!("[{name}] {}", r.describe());
    println!("[{name}] 面積 = {:.2}", r.area());
}

// 沒有 pub：只有 utils 模組內部能呼叫
fn clamp(v: f64, min: f64, max: f64) -> f64 {
    if v < min {
        min
    } else if v > max {
        max
    } else {
        v
    }
}

pub fn round(v: f64) -> f64 {
    // 模組內部可以自由使用私有函式
    (clamp(v, 0.0, 10.0) * 100.0).round() / 100.0
}

// 巢狀模組：也可以直接寫在同一個檔案裡
pub mod math {
    pub fn square(x: f64) -> f64 {
        x * x
    }

    pub fn cube(x: f64) -> f64 {
        x * x * x
    }
}
