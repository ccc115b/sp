# RISC-V 虛擬開發板：Linux 端與 TinyEMU 端

> 狀態：**未編譯、未開機驗證**。網頁（index.html）的 Demo 模式已可操作；以下 C 與 Buildroot 設定是依 TinyEMU 與 Linux 的介面寫成，第一次編譯時 API 名稱可能需微調。

## 1. TinyEMU：新增 MMIO GPIO 裝置

暫存器（基底 `0x40009000`，32 腳，腳位編號 = 樹莓派 BCM 編號）：

| 偏移 | 名稱 | 說明 |
|---|---|---|
| 0x0 | DAT | 讀：輸出腳回傳鎖存值，輸入腳回傳外部電位；寫：設定輸出鎖存 |
| 0x4 | DIROUT | 1 = 輸出 |

新增 `vgpio.c`（內容見 `vgpio_device.c`），在 `riscv_machine.c` 的 `riscv_machine_init()` 呼叫 `vgpio_init(s->mem_map)`，並在 `riscv_build_fdt()` 加入：

```c
static const uint32_t reg[8] = {0,0x40009000,0,4, 0,0x40009004,0,4};
fdt_begin_node_num(s, "gpio", 0x40009000);
fdt_prop_str(s, "compatible", "brcm,bcm6345-gpio");
fdt_prop(s, "reg-names", "dat\0dirout", 11);
fdt_prop_tab_u32(s, "reg", (uint32_t *)reg, 8);
fdt_prop(s, "gpio-controller", NULL, 0);
fdt_prop_u32(s, "#gpio-cells", 2);
fdt_end_node(s);
```

`compatible = "brcm,bcm6345-gpio"` 會讓 Linux 的通用 `gpio-mmio` 驅動接手，所以不用自己寫核心驅動。

WASM 版加入 Emscripten 匯出：`-s EXPORTED_FUNCTIONS=_vgpio_get_out,_vgpio_get_dir,_vgpio_set_in,...`。網頁偵測到 `Module._vgpio_get_out` 就自動切到真實後端，並需自行提供 `window.vmSend(text)` 把文字送進 TinyEMU 的 console。

## 2. Buildroot（riscv64）

以 `qemu_riscv64_virt_defconfig` 為基礎，加入：

```
BR2_PACKAGE_QUICKJS=y            # JS 執行環境（qjs）
BR2_PACKAGE_RISCV_PK=y          # bbl，TinyEMU 傳統啟動路徑
BR2_TARGET_ROOTFS_CPIO=y
BR2_ROOTFS_OVERLAY="board/vboard/overlay"
```

核心 fragment：

```
CONFIG_GPIOLIB=y
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_SYSFS=y
```

## 3. Guest 端 `vgpio.js`（放進 overlay，例如 `/root/vgpio.js`）

範例是純 JavaScript，使用 `Pin` 與 `sleep`。網頁 Demo 模式直接在瀏覽器執行；接上 Linux 時，由 QuickJS 以 ES module 執行（支援 top-level await），GPIO 走 sysfs，不需額外套件：

```js
import * as std from 'std';
import * as os from 'os';

const G = '/sys/class/gpio';
const chip = os.readdir(G)[0].filter(n => n.startsWith('gpiochip'))[0];
const base = parseInt(std.loadFile(`${G}/${chip}/base`));

const put = (path, s) => { const f = std.open(path, 'w'); f.puts(String(s)); f.close(); };

globalThis.sleep = ms => new Promise(r => os.setTimeout(r, ms));
globalThis.Pin = (n, mode = 'in') => {
  const p = `${G}/gpio${base + n}`;
  if (os.stat(p)[1] !== 0) put(`${G}/export`, base + n);
  put(`${p}/direction`, mode === 'out' ? 'out' : 'in');
  return {
    value(v) {
      if (v === undefined) return parseInt(std.loadFile(`${p}/value`));
      put(`${p}/value`, v ? 1 : 0);
      return v;
    },
  };
};
```

網頁在真實模式下會把程式存成 `main.js`（開頭加上 `import './vgpio.js'`），再執行 `qjs -m main.js`。

以上 Linux 端內容同樣**未經編譯與開機驗證**；sysfs GPIO 已被標為過時，最小驗證階段先用它，之後可換成 libgpiod。
