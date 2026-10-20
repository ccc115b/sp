# 17 － 生命週期 Lifetime（lifetimes.rs）

## 這課你將學會

- 認識 `'a` 這種生命週期標註語法
- **生命週期不是在決定「能活多久」**，而是在描述「多個參照之間的關係」
- 省略規則（elision rules）：什麼時候不用自己標
- `'static` 是什麼

## 核心觀念（先讀三遍這一段）

> **標註生命週期不會改變資料實際活多久。**
> 它只是告訴編譯器：「回傳值的壽命跟哪個輸入有關」，讓編譯器有足夠資訊去檢查懸空指標（dangling reference）。

1. **`&'a str` 讀作「生命週期是 `'a` 的字串切片」**。`'a` 是一個代號，代表某段時間。
2. **`fn longest<'a>(x: &'a str, y: &'a str) -> &'a str`** 的意思是：
   「回傳值會活到 `x` 與 `y` 中**較短的那個**結束為止」。
3. **其實你平常都在用生命週期，只是編譯器幫你推斷了**（這叫省略規則）。
4. **`'static` = 活到程式結束**：字面值 `"hi"` 就是 `&'static str`。

## 編譯與執行

```bash
rustc --edition 2021 17/lifetimes.rs -o lifetimes
./lifetimes
```

或：`./run_all.sh 17`

## 逐步解讀

### 1. 為什麼需要標註

```rust
fn longest(x: &str, y: &str) -> &str {   // ← 沒標，編譯器不知道回傳誰的
    if x.len() > y.len() { x } else { y }
}
```

編譯器會問：**回傳的字串到底能活多久？** 比較短的那個輸入被釋放後，回傳值還能用嗎？
加上標註就是回答這個問題：

```rust
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() { x } else { y }
}
```

這是在做**型別系統上的約束**，執行期完全沒有任何額外成本（生命週期只存在於編譯期）。

### 2. 結構體持有參照時必須標

```rust
struct Excerpt<'a> {
    first_line: &'a str,
}

let text = String::from("以前有一艘船……");
let excerpt = Excerpt::new(&text);
```

意思是：`excerpt` 的存活時間**不能超過 `text`**，否則它會指向已被釋放的記憶體。
你沒辦法寫 `struct Excerpt { first_line: &str }`——編譯器一定會要求 `'a`。

### 3. 什麼時候可以省略（省略規則）

編譯器會在以下情況自動推斷，大多數函式都不用寫 `'a`：

1. 每個輸入參數各得到一個生命週期
2. **只有一個輸入生命週期時**，直接套用到所有輸出
3. 方法有 `&self` 時，`self` 的生命週期套用到所有輸出

```rust
fn first_word(text: &str) -> Option<&str> { ... }   // 規則 2 → 不用標
fn count_chars(s: &str) -> usize { ... }            // 不回傳參照 → 更不用標
fn level(&self) -> i32 { 3 }                        // 不回傳參照 → 不用標
```

### 4. 陷阱：不能回傳函式內建的參照

```rust
// fn bad() -> &str {
//     let s = String::from("hi");
//     &s      // ← 拿掉註解：missing lifetime specifier
// }
```

`s` 離開作用域就被釋放，回傳它會造成懸空指標。編譯器要求你標生命週期，而你根本標不出合法的——因為**它真的不合法**。

### 5. 'static

```rust
let s: &'static str = "我會活到程式結束";
```

字串字面值被嵌在執行檔裡，天然就是 `'static`。

## 動手試試看

1. 把 `longest` 的 `<'a>` 與內部的 `'a` 全部拿掉，讀編譯器的錯誤訊息（`missing lifetime specifier` / `returns a value referencing data owned by the current function`）。
2. 寫 `fn first<'a>(x: &'a str, y: &'a str) -> &'a str { x }`，並故意讓 `x` 在函式內被建立再回傳 → 編譯器會擋。
3. 把 `struct Excerpt<'a>` 的 `<'a>` 拿掉，看錯誤要求。
4. 加一個函式 `fn shorter<'a>(x: &'a str, y: &'a str) -> &'a str`（回傳較短的）。
5. 想一想：`fn f(s: &str) -> usize` 需要標生命週期嗎？為什麼？

## 故意犯錯

| 寫法 | 結果 |
|------|------|
| `fn f(x: &str, y: &str) -> &str { if ... {x} else {y} }` | `missing lifetime specifier` |
| `struct S { r: &str }` | 一律要求 `S<'a>`（struct 必須比參照活得久） |
| 回傳函式內 `String` 的 `&` | `cannot return value referencing local variable` |

## 檢查點

- [ ] 用一句話說明生命週期標註在「描述」什麼（不是在「指定」什麼）？
- [ ] `'a` 會在執行期做任何事嗎？
- [ ] 省略規則的第 2 條是什麼？
- [ ] `'static` 代表什麼？哪些東西天生就是 `'static`？
- [ ] 為什麼 `longest` 需要標註、`count_chars` 不用？

**核心語法到此告一段落（01–17）。剩下三課：把程式拆成多檔、讀寫檔案、做一個小專案。**

下一課：[18/main.rs － 模組與多檔案](../18/README.md)
