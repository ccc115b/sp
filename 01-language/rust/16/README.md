# 16 － 泛型 Generics 與特徵 Trait（generics_traits.rs）

## 這課你將學會

- 用泛型寫「一種型別通用的程式碼」
- 定義 trait、為型別實作 trait、寫預設實作
- trait bound：`<T: Summary>` 是什麼意思
- `impl Trait`（靜態分派）與 `dyn Trait`（動態分派）的差別

## 核心觀念

1. **泛型 = 型別的參數化**：`fn largest<T>(items: &[T]) -> &T` 寫一次，`i32`/`f64` 都能用。
2. **trait = 定義「型別該有哪些能力」**（類似其他語言的 interface）。
   想讓型別會做什麼，就為它 `impl` 對應的 trait。
3. **trait bound**：`T: PartialOrd` 表示「`T` 必須有比較大小的能力」——泛型不是什麼型別都能用，要符合能力。
4. **有 body 的 trait 方法 = 預設實作**，實作者可以不改或覆寫。
5. **兩種套用 trait 的方式**：

   | 寫法 | 決定時機 | 效能 | 適用 |
   |------|---------|------|------|
   | `impl Shape` / `<T: Shape>` | 編譯期（單態化） | 零成本，直接呼叫 | 型別已知時 |
   | `&dyn Shape` / `Box<dyn Shape>` | 執行期（vtable） | 一次間接呼叫 | 要放不同型別在同一个容器 |

## 編譯與執行

```bash
rustc --edition 2021 16/generics_traits.rs -o generics_traits
./generics_traits
```

或：`./run_all.sh 16`

## 逐步解讀

### 1. 泛型函式與 trait bound

```rust
fn largest<T: PartialOrd>(items: &[T]) -> &T {
    let mut biggest = &items[0];
    for item in &items[1..] {
        if item > biggest { biggest = item; }
    }
    biggest
}
```

`<T: PartialOrd>` 是重點：如果沒有這個 bound，`item > biggest` 會編譯不過，因為編譯器不知道 `T` 能不能比大小。
（04 課寫過「巢狀 if 找最大值」，這裡用迭代器 + 泛型一次搞定。）

### 2. 泛型型別

```rust
struct Point<T> { x: T, y: T }

let p1 = Point { x: 1, y: 2 };        // Point<i32>
let p2 = Point { x: 1.0, y: 2.5 };    // Point<f64>
```

**同一個 struct 的 `x` 和 `y` 必須是同一個 `T`**（想不同要寫兩個參數 `Point<T, U>`）。

```rust
impl<T: std::fmt::Debug> Point<T> {
    fn describe(&self) { ... }
}
```

代表「所有 `Debug` 的 `Point<T>` 都有 `describe`」。

### 3. 定義與實作 trait

```rust
trait Summary {
    fn summarize(&self) -> String;              // 必須實作
    fn preview(&self) -> String {                // 預設實作
        format!("{}……（預覽）", self.summarize())
    }
}

impl Summary for Point<i32> {
    fn summarize(&self) -> String { format!("座標點 ({}, {})", self.x, self.y) }
}
```

`preview` 我們沒有實作，但呼叫時自動有——因為 trait 提供了預設版本。

```rust
fn print_summary<T: Summary>(item: &T) { ... }   // 泛型 + bound
fn print_summary(item: &impl Summary) { ... }    // 等價簡寫
```

### 4. trait object（動態分派）

```rust
let shapes: Vec<Box<dyn Shape>> = vec![
    Box::new(Circle { radius: 1.0 }),
    Box::new(Square { side: 2.0 }),
];
for shape in &shapes { shape.area(); }
```

**為什麼要用 `Box`？** 因為 `Vec` 裡的元素大小要一樣，而 `Circle` 和 `Square` 大小不同。
`Box<dyn Shape>` 統一成「指標 + 型別資訊」，執行期再依實際型別呼叫 `area`。

> 對比：`impl Shape` 是編譯期把型別寫死（每個型別一份機器碼）；`dyn Shape` 是執行期查表。前者快、後者靈活。

## 動手試試看

1. 把 `largest<T: PartialOrd>` 的 bound 拿掉，看編譯器怎麼抱怨（訊息會指出 `>` 需要 `PartialOrd`）。
2. 給 `Summary` 加一個需要實作的方法，例如 `fn author(&self) -> String;`，會看到哪些型別漏了。
3. 新增 `struct Triangle { a: f64, b: f64, c: f64 }` 實作 `Shape`，加進 `shapes` 的 `Vec`。
4. 把 `print_summary(&p1)` 改成 `fn print_summary(item: &impl Summary)` 寫法。
5. 把 `Point<i32>` 的 `impl Summary` 改成 `impl Summary for Point<f64>`，看呼叫處是否還能編譯。
6. 想一想：`String` 是怎麼印出 `Display` 的？（提示：`println!("{}", s)` 也是 trait——`Display`）

## 故意犯錯

| 寫法 | 結果 |
|------|------|
| `fn largest<T>(items: &[T]) -> &T { if a > b ... }` | `T` doesn't implement `PartialOrd` |
| `let v: Vec<Shape> = ...`（trait 沒有大小） | `the size for values of type dyn Shape cannot be known` → 要用 `Box<dyn Shape>` |
| `impl Summary for Point<f64>` 之後呼叫 `p1.summarize()`（p1 是 i32） | `Summary is not implemented for Point<i32>` |

## 檢查點

- [ ] 泛型和「寫兩份重複程式碼」的差別？編譯後會變成什麼？
- [ ] `T: PartialOrd` 這段在限制什麼？拿掉會怎樣？
- [ ] trait 的「必須實作」與「預設實作」怎麼寫？
- [ ] `impl Shape` 與 `dyn Shape` 何時用哪個？各付出什麼代價？
- [ ] 為什麼 `Vec<Circle>` 不能直接轉成 `Vec<dyn Shape>`？

下一課：[17/lifetimes.rs － 生命週期](../17/README.md)
