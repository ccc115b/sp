// 17 - 生命週期（lifetime）
//
// 編譯：rustc --edition 2021 17/lifetimes.rs -o lifetimes
// 執行：./lifetimes
//
// 生命週期標註「不會」改變資料能活多久，
// 只是告訴編譯器：多個參照之間的生命週期有什麼關係。

fn main() {
    let string1 = String::from("long");
    let string2 = String::from("longer");
    let result = longest(string1.as_str(), string2.as_str());
    println!("較長的是「{result}」"); // result 借用了 string2

    // 下面這行若拿到 string1 剛好被釋放後使用，編譯器就會擋下來
    println!("string1 = {string1}, string2 = {string2}");

    // 擁有資料的結構體：必須標註內部參照的生命週期
    let text = String::from("以前有一艘船，船上有個人……");
    let excerpt = Excerpt::new(&text);
    println!("摘錄：{}", excerpt.first_line);
    println!("層級 = {}", excerpt.level());
    // excerpt 的生命週期不能超過 text（否則會指向已釋放的記憶體）

    // 與生命週期無關的函式：編譯器自己推斷得出來，不用標
    println!("字元數 = {}", count_chars("hello"));

    // 'static：活到程式結束為止（例如程式碼裡的字串字面值）
    let s: &'static str = "我會活到程式結束";
    println!("{s}");

    // 陷阱：函式不能回傳「函式內建資料」的參照
    // fn bad() -> &str {
    //     let s = String::from("hi");
    //     &s        // ← 去掉這整段的註解會編譯錯誤：missing lifetime specifier
    // }              //   因為 s 結束作用域就被釋放，回傳值會變成懸空指標
    let ok = first_word(&text);
    println!("first_word = {ok:?}");
}

// 'a 是生命週期參數（不是泛型型別）：
// 回傳值的壽命 = 兩個輸入中「較短」的那一個
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
}

// 標註：回傳值至少能活到輸入的資料還在的時候
fn first_word(text: &str) -> Option<&str> {
    // 這裡只有單一輸入生命週期，依規則會自動套用到回傳值
    text.split_whitespace().next()
}

#[derive(Debug)]
struct Excerpt<'a> {
    first_line: &'a str,
}

impl<'a> Excerpt<'a> {
    // 第三個省略規則：有 &self 的方法，回傳值會拿到 &self 的生命週期
    fn new(text: &'a str) -> Self {
        Excerpt {
            first_line: text,
        }
    }

    fn level(&self) -> i32 {
        3 // 不回傳參照，不需要標註
    }
}

fn count_chars(s: &str) -> usize {
    s.chars().count()
}
