# 01-hello-jack：最小 Jack 編譯器

> 本版支援的語法以 EBNF 記於 [`EBNF.md`](EBNF.md)。

把一個最簡單的 Jack 類別編譯成 VM 指令檔。這是整個 `jack/` 系列的骨幹，
後面 11 個版本都是在這個骨架上逐步加功能。

## 支援範圍

| 項目 | 說明 |
| --- | --- |
| `class C { ... }` | 一個檔一個類別，檔名 = 類別名 |
| `function t f() { ... }` | 僅函式，無參數、無區域變數 |
| `return;` | 補成 `push constant 0` + `return` |
| `return 42;` | `push constant 42` + `return` |

尚不支援：`var` / `let` / `do` / `if` / `while` / 方法 / 欄位 / 陣列 / 字串。

## 檔案

| 檔 | 用途 |
| --- | --- |
| `main.rs` | 編譯器（tokenizer + parser + emitter，單一檔） |
| `Hello.jack` | 測試輸入 |
| `expected/Hello.vm` | 期望輸出（golden file） |
| `run.sh` | 編譯 + 執行 + 比對 |

## 程式流程

```
Hello.jack
   │  tokenize()   字串 → Vec<Token>（已跳過空白與 // /* */ 註解、記錄行號）
   ▼
 tokens
   │  Parser::parse_class()   遞迴下降，邊解析邊產生字串
   ▼
 VM 程式碼
   │  fs::write()
   ▼
Hello.vm
```

## 執行

```sh
./run.sh
```

輸出 `01-hello-jack OK` 即表示編譯結果與 `expected/Hello.vm` 完全一致。

單獨使用：

```sh
rustc --edition 2021 main.rs -o out/jackc
./out/jackc Hello.jack out/Hello.vm   # 指定輸出
./out/jackc Hello.jack                # 省略時輸出 Hello.vm
```

## 輸入 / 輸出

輸入 `Hello.jack`：

```jack
class Hello {
    function void main() {
        return;
    }

    function int answer() {
        return 42;
    }
}
```

輸出 `expected/Hello.vm`：

```
function Hello.main 0
push constant 0
return
function Hello.answer 0
push constant 42
return
```

## 錯誤處理

解析失敗時印出 `line N: 訊息` 並以狀態碼 1 結束：

```
$ ./out/jackc /tmp/Bad.jack
line 3: 此版本的算式只支援整數常數
```

## 要點

- **單趟編譯**：沒有 AST，`parse_*()` 一邊看 Token 一邊把 VM 指令丟進 `String`。
- **Token 自帶行號**：`Token { kind, line }`，為 `10-errors` 的錯誤訊息預先鋪路。
- **`Kind` 列舉**已含字串常數，雖然 01 的 parser 還不收，但 tokenizer 已能切出來。
