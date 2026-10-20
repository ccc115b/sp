// 18 - 模組（module）與檔案拆分
//
// 編譯：rustc --edition 2021 18/main.rs -o modules_demo
// 執行：./modules_demo
//
// 這個資料夾有三個檔案：
//   18/main.rs      → 宣告 mod shapes; / mod utils;
//   18/shapes.rs    → 對應 mod shapes;
//   18/utils.rs     → 對應 mod utils;（裡面還有巢狀模組）
//
// rustc 會依 mod 名稱去找同資料夾的 <名字>.rs（或是 <名字>/mod.rs）

mod shapes; // 引入 shapes.rs，這個模組預設是「私有的」
mod utils; // 引入 utils.rs

use shapes::Rectangle;
use utils::print_info;

fn main() {
    let r = Rectangle::new(3.0, 4.0);
    println!("{r:?}");
    print_info("長方形", &r);

    // 私有項目：main.rs 看不到 shapes 裡沒標 pub 的東西
    // println!("{:?}", shapes::SECRET_CODE); // ← 取消註解會編譯錯誤
    // 但模組可以用一個 pub 函式「選擇性」曝露它
    println!("shapes 的內部代碼 = {}", shapes::internal_code());

    // 巢狀模組：用路徑存取
    println!("3 的平方 = {}", utils::math::square(3.0));
    println!("3 的立方 = {}", utils::math::cube(3.0));
    println!("PI = {:.5}", utils::PI);

    // 模組內的私有函式
    println!("四捨五入 3.14159 = {}", utils::round(3.14159));
}
