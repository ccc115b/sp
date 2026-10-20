# 03 － 基本型別與運算（types.rs）

## 這課你將學會

- 認識 Rust 的四大基本型別：整數、浮點數、布林、字元
- 理解「Rust 不會自動做數值型別轉換」，以及 `as` 怎麼用
- 知道整數溢位（overflow）在 debug / release 下的不同行為

## 核心觀念

1. **整數分有號與無號**，大小用位元數標示：`i8/i16/i32/i64/i128/isize`、`u8...u128/usize`。
   預設是 `i32`；`usize` 是「位元組為單位的平台大小」，常用在索引。
2. **浮點**：`f32`、`f64`（預設）。IEEE 754，除以 0 不會 panic，會得到 `inf`。
3. **`char` 是 Unicode 字元，固定 4 bytes**，不是 1 byte；單引號 `'` 包起來。
4. **型別轉換必須明寫 `as`**：編譯器不會像 C 那樣偷偷轉，避免精度悄悄流失。
5. **溢位**：常數超出範圍在編譯期就報錯；執行期的溢位在 debug 版（`rustc` 預設）會 panic，release 版（`-O`）會回繞。

## 編譯與執行

```bash
rustc --edition 2021 03/types.rs -o types
./types
```

或：`./run_all.sh 03`

## 逐步解讀

### 1. 型別大小與範圍

```rust
let small: u8 = 255;              // u8 最小 0、最大 255
// let too_big: u8 = 256;         // ← 拿掉註解，編譯期就報錯
```

常數溢位不用等到執行，編譯器直接擋下。

### 2. 執行期溢位

```rust
// let overflow = small + 1;       // ← 拿掉註解再編譯執行
```

會看到 `attempt to add with overflow`（debug 模式 panic）。試著加 `-O` 編譯：

```bash
rustc --edition 2021 -O 03/types.rs -o types_o && ./types_o
```

`u8` 的 255 + 1 會「回繞」成 0。這就是為什麼要小心無號運算。

### 3. 字元與 Unicode

```rust
let heart = '❤';
let cjk = '語';
std::mem::size_of::<char>()   // 永遠是 4
```

字串 `String`/`&str` 則是 UTF-8 編碼，每個字元佔 1~4 bytes（第 09 課會詳談）。

### 4. 型別轉換

```rust
let a: i32 = 42;
let b = a as f64;        // i32 -> f64
let c: u8 = 100;
let d = a + c as i32;    // 先把 c 轉成 i32 才能相加
```

**順序很重要**：`a + c as i32` 等於 `a + (c as i32)`。
若寫 `let x = a as u8 + c;` 會先轉換再相加，可能發生不可預期的截斷。

### 5. 整數除法會捨去

```rust
7 / 2    // 3（不是 3.5）
7.0 / 2.0 // 3.5
```

## 動手試試看

1. 印出各種型別的最大值（提示：`u8::MAX`、`i32::MAX` 寫成 `println!("{}", u8::MAX)`）。
2. 把 `1.0 / 0.0` 改成 `0.0 / 0.0`，看看是什麼（`NaN`，而且 `NaN != NaN`）。
3. 算算 `255_u8 as i8` 是多少？為什麼？
4. 用 `as` 把 `-1_i32` 轉成 `u32`，結果合理嗎？

## 故意犯錯

| 寫法 | 結果 |
|------|------|
| `let x: u8 = 256;` | 編譯期 `literal out of range` |
| `let s = 1 + 1.0;` | `mismatched types`（整數不能直接加小數） |
| `let t: bool = 1;` | `expected bool, found integer`（不像 C 可用 1 當 true） |

## 檢查點

- [ ] 預設的整數型別與浮點型別各是什麼？
- [ ] `'A'` 和 `"A"` 差在哪？各佔幾 bytes？
- [ ] 為什麼 `1 + 1.0` 不能編譯？該怎麼改？
- [ ] debug 與 release 版本的溢位行為差在哪？

下一課：[04/control_flow.rs － 條件判斷](../04/README.md)
