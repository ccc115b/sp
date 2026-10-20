//! jvm0 函式庫 — 依功能拆成數個模組：
//!
//!   * [`classfile`]：`.class` 檔解析（constant pool、欄位、方法、Code attribute）
//!   * [`vm`]：bytecode 直譯器（執行）
//!   * [`disasm`]：bytecode 反組譯器（列出 opcode 與 operands）
//!
//! 二進位檔 `jvm0`（`main.rs`）只負責命令列參數與檔案讀寫。

pub mod classfile;
pub mod disasm;
pub mod vm;

/// 統一的錯誤型別：以字串描述的例外／診斷訊息。
pub type Res<T> = Result<T, String>;
