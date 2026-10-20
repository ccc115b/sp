# 07 － 所有權 Ownership（ownership.rs）

> 這課是整本教材最重要的一页。建議讀三遍：第一遍看懂輸出、第二遍逐行對照、第三遍合上書自己重寫。

## 這課你將學會

- Rust 的三條所有權規則
- 什麼是 move（移轉）、什麼是 Copy（複製）
- 為什麼有些變數「用過就不能再用了」
- 所有權如何讓 Rust 在**沒有垃圾回收**的情況下自動管理記憶體

## 核心觀念：三條規則

1. Rust 中每個值都有一個**擁有者（owner）**
2. 同一時間**只能有一個**擁有者
3. 擁有者**離開作用域**時，值會被自動丟棄（drop）

這三條規則背後的動機：C 的手動 `free` 會 double-free、memory leak；Java/Python 的垃圾回收會有執行期成本與延遲。Rust 選擇「**編譯期**就把記憶體問題解決掉」。

## 編譯與執行

```bash
rustc --edition 2021 07/ownership.rs -o ownership
./ownership
```

或：`./run_all.sh 07`

## 逐步解讀

### 1. move：堆積資料的所有權會移轉

```rust
let s1 = String::from("hello");
let s2 = s1;   // 所有權從 s1 移轉到 s2

// println!("s1 = {s1}");   // ← 取消註解：borrow of moved value
println!("s2 = {s2}");
```

一個 `String` 內部大致是這樣：

```
        ┌───────┐         ┌──────────────────┐
  s1 →  │ ptr   │ ──────→ │ 'h''e''l''l''o'  │  （堆積）
        │ len   │         └──────────────────┘
        │ cap   │
        └───────┘
```

`let s2 = s1;` 之後指標內容被搬給 `s2`。如果兩個變數都能用，結束時就會釋放兩次（double free）。所以 Rust 讓 **`s1` 從此失效**。

請把第 16 行的註解拿掉，讀完整的錯誤訊息——它會指出 `s1` 是在哪一行宣告的。

### 2. Copy：標量型別直接複製

```rust
let a = 42;
let b = a;                      // 複製，不是移轉
println!("a = {a}, b = {b}");   // 兩個都還能用
```

`i32` 這種「小而簡單、放得進暫存器」的型別實作了 `Copy` trait，賦值時直接複製位元，所以不影響原變數。**預設規則：堆積上的資料（`String`、`Vec`）會 move，純數值會 Copy。**

### 3. 傳進函式 = 移轉

```rust
let s = String::from("hi");
takes_ownership(s);        // s 的所有權進了函式
// println!("{s}");        // ← 不能再用

let n = 5;
makes_copy(n);             // 傳的是副本
println!("n 還在：{n}");   // 5
```

函式結束時 `s` 離開作用域 → 第 3 條規則 → `String` 被自動釋放，不需要手動 `free`。

### 4. 回傳值可以交還所有權

```rust
let s3 = gives_ownership();
let s4 = take_and_give_back(s3);
// println!("{s3}");       // ← s3 已經移轉出去
println!("s4 = {s4}");
```

這正是「移來移去很麻煩」的證據：每次把字串傳給函式，都要擔心還能不能用。**下一課的「借用」就是解法。**

### 5. 作用域結束自動釋放

`main` 結束時，還活著的所有變數都會被依序釋放——你完全沒寫任何釋放程式碼。

## 動手試試看

1. 依序把第 16、27、38 行的註解拿掉，**每一行都讀一遍錯誤訊息**，寫下編譯器指出了哪一行。
2. 寫一個小程式：宣告 `let a = String::from("x"); let b = a; let c = b;`，印出 `c`，並註解掉 `a`、`b` 觀察。
3. 嘗試讓 `Vec<String>` 也 move 一次，確認規則相同。
4. 宣告一個 `let flag = true;` 傳進函式後還能不能用？為什麼？
5. 思考題：為什麼 `let s2 = s1;` 不用加 `mut` 就能成功？

## 故意犯錯

| 寫法 | 結果 |
|------|------|
| `let s2 = s1; println!("{s1}");` | `borrow of moved value: s1` |
| `takes_ownership(s);` 後印 `s` | `value borrowed here after move` |
| 嘗試手動 `free(s)` | 沒有這個函式——Rust 沒有手動釋放記憶體的 API |

## 檢查點（很重要）

- [ ] 三條所有權規則請背出來。
- [ ] `String` 賦值給另一個變數時會發生什麼？`i32` 呢？為什麼不同？
- [ ] 函式參數收下 `String` 後，呼叫端還能用那個變數嗎？
- [ ] 「作用域結束會自動釋放」解決了 C 的什麼問題？比垃圾回收好在哪？
- [ ] 如果沒有所有權系統，Rust 要怎麼避免 double free？

下一課：[08/references.rs － 參照與借用](../08/README.md)
