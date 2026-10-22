# RISC-V 虛擬開發板（C 範例版）

瀏覽器內執行 RISC-V Linux（Fabrice Bellard 的 TinyEMU / JSLinux 預編譯版），用網頁上的 LED、按鈕與 40 pin 腳位圖操作 C 程式。**不需要建置即可使用。**

## 使用
1. 在此資料夾執行 `./serve.sh`（或 `python3 -m http.server 8000`）。XHR 需要 HTTP，直接雙擊 index.html 不行。
2. 開啟 http://localhost:8000/ ，等狀態顯示「Linux 已啟動」。
3. 選範例，按「執行」。按鈕可用滑鼠按住（GPIO 24、25），輸入腳也可在腳位圖上點擊切換。「停止」會送出 Ctrl-C。

## 六個範例（src/）
閃爍 LED、按鈕切換 LED、紅綠燈、二進位計數器、SOS 摩斯電碼、跑馬燈。腳位編號對應樹莓派 BCM：LED 在 17、27、22、23，按鈕在 24、25。

## C API（src/vgpio.h）
`gpio_mode(pin, out)`、`gpio_set(pin, v)`、`gpio_get(pin)`、`msleep(ms)`

原理：程式用 console 逸出序列 `ESC ] 7777 ; ... BEL` 回報 GPIO 狀態，網頁攔截後更新畫面；讀按鈕時由網頁把狀態當作一行文字回送給程式。不需修改模擬器或核心。

## 修改或新增範例
網頁上的原始碼是唯讀的，因為 guest 裡沒有編譯器。要改程式：編輯 `src/N_name.c`，執行 `./build.sh`（需要 `gcc`、`gcc-riscv64-linux-gnu`、`e2fsprogs`），它會重新編譯、寫入 `/bin/c_name`、重新切分 `root-riscv64/`。新增範例後，網頁的清單需同步更新 `index.html` 內的 `EX`。

## 驗證狀態
- 已驗證：六個範例在原生版 TinyEMU 上以相同的 rootfs 執行，GPIO 事件與按鈕回應正確；`root-riscv64/` 區塊檔串接後與映像完全一致；網頁的攔截與送指令邏輯用 Node 以模擬物件測過。
- 未驗證：在真實瀏覽器（WASM）內的完整流程。若終端機無法啟動，先檢查瀏覽器主控台與伺服器 log。
- 限制：核心為 Linux 4.15（2018），靜態執行檔每個約 475 KB；Linux 執行時請勿在終端機手動輸入，以免與按鈕回送的資料混在一起。

## 授權
TinyEMU / JSLinux 為 MIT 授權（見 LICENSE-TinyEMU-MIT.txt）。映像內含 BusyBox（GPL）。
