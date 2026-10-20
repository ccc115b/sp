# 13 － 標準集合：Vec、String、HashMap（collections.rs）

## 這課你將學會

- `Vec<T>`：可變長度的串列
- `String`：可變的 UTF-8 文字，以及它和 `&str` 的分工
- `HashMap<K, V>`：鍵值對應，以及最常見的「計數」寫法
- 存取元素的「安全版」與「會 panic 版」

## 核心觀念

1. **`Vec<T>` = 堆積上的連續陣列**，長度可變。建立用 `Vec::new()` 或巨集 `vec![...]`。
2. **兩種存取**：
   - `v[i]` → 越界就 **panic**
   - `v.get(i)` → 回傳 `Option<&T>`，越界是 `None`，安全
3. **`String` 的三兄弟**（學 Rust 必記）：
   - `String`：可擁有、可變、堆上
   - `&str`：借用、不可變（字面值就是 `&str`）
   - `char`：單一字元（4 bytes）
4. **`String + &str` 會吃掉左邊的 `String`**，這是 07 課「move」的規則又出現了。
5. **`HashMap` 讀取回傳 `Option<V>`**，因為 key 可能不存在——Rust 沒有回傳 null 的 API。
6. **`entry().or_insert()` 是「有就拿、沒有就建」的原子寫法**。

## 編譯與執行

```bash
rustc --edition 2021 13/collections.rs -o collections
./collections
```

或：`./run_all.sh 13`

## 逐步解讀

### 1. Vec 建立與存取

```rust
let mut v: Vec<i32> = Vec::new();
v.push(1);
let mut v2 = vec![4, 5, 6];    // 巨集，較常見
v2.extend([7, 8, 9]);

println!("v[0] = {}", v[0]);        // 直接索引
println!("{:?}", v.get(1));          // Some(2)
println!("{:?}", v.get(99));         // None
// println!("{}", v[99]);            // ← 拿掉註解會 panic
```

### 2. 迭代與修改

```rust
for n in &v { print!("{n} "); }      // 借用每個元素
for n in &mut v { *n *= 2; }         // 可變借用，*n 解引用後才能改
```

### 3. String 操作

```rust
let mut s = String::new();
s.push_str("Hello");   // 整段字串用 push_str
s.push(' ');           // 單一字元用 push
let s2 = String::from("世界");
s.push('&');
s.push_str(&s2);       // 傳 &s2，s2 還能用

s.len();               // bytes 數
s.chars().count();     // 字元數
s.to_uppercase();
s.split(|c: char| ...); // 依條件切割
```

### 4. 萬用的計數寫法

```rust
let mut count: HashMap<&str, i32> = HashMap::new();
for word in text.split_whitespace() {
    *count.entry(word).or_insert(0) += 1;
}
```

一行拆解：
1. `entry(word)` → 取得「這個 key 的入口」（可變借用）
2. `.or_insert(0)` → 沒有就插入 0，回傳 `&mut i32`
3. `*... += 1` → 解引用後加 1

這個模式在第 20 課的小專案還會再用一次。

## 動手試試看

1. 把 `v2.extend([7, 8, 9])` 改成 `v2.push(10)` 試試。
2. 寫一個程式：讀入一串以空白分隔的成績（寫死字串即可），算平均與最高分（用 `iter().max()`）。
3. 把 `scores` 的值型別改成 `Vec<String>`，練習「一個 key 對應多個值」。
4. 寫 `fn merge(a: &HashMap<String,i32>, b: &HashMap<String,i32>) -> HashMap<String,i32>`，把兩份分數相加。
5. 用 `entry().or_insert_with(|| ...)` 把「統計」改成「記錄所有出現過的字」（值改成 `Vec<String>`）。

## 故意犯錯

| 寫法 | 結果 |
|------|------|
| `let v = vec![1,2]; v.push(3);` | `cannot borrow as mutable, as it is not declared as mutable`（少了 `mut`） |
| `let a: Vec<i32> = Vec::new();` 但從未 push | 可以編譯，但 `a[0]` 會 panic（空串列） |
| `s1 + s2`（兩個 String 相加） | 可以，但 `s1` 被移轉；要再用就得 `clone()` |
| `scores.get("Red").unwrap()` | key 不存在 → panic |

## 檢查點

- [ ] `v[i]` 和 `v.get(i)` 回傳的型別與失敗行為差在哪？
- [ ] `String`、`&str`、`char` 三者差在哪？什麼時候用哪個？
- [ ] `s.push(' ')` 與 `s.push_str(" ")` 差在哪？參數型別是什麼？
- [ ] `*count.entry(word).or_insert(0) += 1` 中每一個符號各在做什麼？
- [ ] 為什麼 `HashMap::get` 不直接回傳 `V`？

下一課：[14/iterators.rs － 迭代器](../14/README.md)
