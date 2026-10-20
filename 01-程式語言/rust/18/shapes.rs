// 18/shapes.rs — 對應 main.rs 的 `mod shapes;`
//
// 未標 pub 的項目只在這個模組內可見（模組是 Rust 的可見性邊界）

// pub 讓其他模組能使用
#[derive(Debug)]
pub struct Rectangle {
    pub width: f64, // 欄位也可以個別決定可見性
    pub height: f64,
}

impl Rectangle {
    // 關聯函式（建構）
    pub fn new(width: f64, height: f64) -> Self {
        Self { width, height }
    }

    pub fn area(&self) -> f64 {
        self.width * self.height
    }

    // 沒有 pub：只有 shapes 模組內部能呼叫
    fn aspect_ratio(&self) -> f64 {
        self.width / self.height
    }

    pub fn describe(&self) -> String {
        // 同一個模組內可以使用私有方法
        format!(
            "{} x {}（寬高比 {:.2}）",
            self.width,
            self.height,
            self.aspect_ratio()
        )
    }
}

// 沒有 pub，外面看不到（直接存取會編譯錯誤）
const SECRET_CODE: u32 = 42;

// 模組內的程式碼可以自由使用私有項目，再決定要不要對外公開
pub fn internal_code() -> u32 {
    SECRET_CODE
}
