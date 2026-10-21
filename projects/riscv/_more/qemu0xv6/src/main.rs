//! qemu0 — 一個用 Rust 寫的微型 RISC-V (RV64IMA, M-mode) 模擬器。

use rvcore::bus::DRAM_BASE;
use rvcore::cpu::Cpu;
use rvcore::{demo, elf};
use std::process::exit;

const USAGE: &str = "\
qemu0 — tiny RISC-V (RV64IMA) emulator

用法: qemu0 [選項] [映像檔]

  映像檔      ELF64 (RISC-V) 或 raw binary(載入到 0x80000000)
  --demo      執行內建的 Hello World(未指定映像檔時的預設)
  --disk <img> 掛上 virtio 區塊裝置(xv6 的 fs.img;寫入會寫回檔案)
  -m <MB>     DRAM 大小,預設 128
  -n <N>      最多執行 N 個指令(預設無限制)
  -d          在 stderr 輸出每個指令的追蹤
  -h          顯示說明

裝置: UART 0x10000000(IRQ 10)· virtio-blk 0x10001000(IRQ 1)· PLIC 0x0c000000
      CLINT 0x02000000 · test finisher 0x100000 · DRAM 0x80000000
終端機輸入會送進 UART;Ctrl-A x 結束,Ctrl-A r 傾印暫存器(除錯)。";

fn main() {
    let mut mem_mb = 128usize;
    let mut max: Option<u64> = None;
    let mut trace = false;
    let mut image: Option<String> = None;
    let mut disk: Option<String> = None;

    let mut args = std::env::args().skip(1);
    while let Some(a) = args.next() {
        match a.as_str() {
            "-h" | "--help" => {
                println!("{USAGE}");
                return;
            }
            "-m" => mem_mb = args.next().and_then(|v| v.parse().ok()).unwrap_or_else(|| die("-m 需要數字")),
            "-n" => max = Some(args.next().and_then(|v| v.parse().ok()).unwrap_or_else(|| die("-n 需要數字"))),
            "-d" => trace = true,
            "--disk" => disk = Some(args.next().unwrap_or_else(|| die("--disk 需要檔名"))),
            "--demo" => image = None,
            s if s.starts_with('-') => die(&format!("未知選項 {s}\n\n{USAGE}")),
            s => image = Some(s.to_string()),
        }
    }

    let mut cpu = Cpu::new(mem_mb << 20, true);
    cpu.trace = trace;
    if let Some(d) = &disk {
        cpu.bus.virtio.attach(d).unwrap_or_else(|e| die(&e));
    }
    cpu.bus.uart.enable_stdin();

    let data = match &image {
        Some(path) => std::fs::read(path).unwrap_or_else(|e| die(&format!("無法讀取 {path}: {e}"))),
        None => demo::hello(),
    };
    if elf::is_elf(&data) {
        cpu.pc = elf::load(&data, &mut cpu.bus).unwrap_or_else(|e| die(&e));
    } else {
        cpu.bus.load_image(DRAM_BASE, &data).unwrap_or_else(|e| die(&e));
        cpu.pc = DRAM_BASE;
    }

    let code = run(&mut cpu, max);
    exit(code);
}

fn run(cpu: &mut Cpu, max: Option<u64>) -> i32 {
    loop {
        if rvcore::bus::DUMP_REQUEST.swap(false, std::sync::atomic::Ordering::Relaxed) {
            eprintln!();
            cpu.dump_regs();
        }
        if let Some(c) = cpu.bus.exit {
            return c;
        }
        if max.map_or(false, |m| cpu.instret >= m) {
            eprintln!("[qemu0] 已達指令上限");
            cpu.dump_regs();
            return 2;
        }
        if let Err(msg) = cpu.step() {
            eprintln!("[qemu0] 致命錯誤: {msg}");
            cpu.dump_regs();
            return 1;
        }
    }
}

fn die(msg: &str) -> ! {
    eprintln!("qemu0: {msg}");
    exit(64);
}

#[cfg(test)]
mod tests {
    use super::*;
    use rvcore::demo::*;

    fn machine(words: &[u32]) -> Cpu {
        let mut cpu = Cpu::new(1 << 20, false);
        let bytes: Vec<u8> = words.iter().flat_map(|w| w.to_le_bytes()).collect();
        cpu.bus.load_image(DRAM_BASE, &bytes).unwrap();
        cpu
    }

    #[test]
    fn hello_world() {
        let mut cpu = Cpu::new(1 << 20, false);
        cpu.bus.load_image(DRAM_BASE, &hello()).unwrap();
        assert_eq!(run(&mut cpu, Some(10_000)), 0);
        assert_eq!(cpu.bus.uart.captured, b"Hello from qemu0!\n");
    }

    #[test]
    fn signed_div_rem_and_edge_cases() {
        let mut cpu = machine(&[
            addi(5, 0, -7),                          // t0 = -7
            addi(6, 0, 2),                           // t1 = 2
            r_type(1, 6, 5, 4, 7, 0x33),             // div  t2 = -3
            r_type(1, 6, 5, 6, 28, 0x33),            // rem  t3 = -1
            r_type(1, 0, 5, 4, 29, 0x33),            // div by zero -> -1
            r_type(1, 6, 5, 0, 30, 0x33),            // mul  t5 = -14
        ]);
        for _ in 0..6 {
            cpu.step().unwrap();
        }
        assert_eq!(cpu.x[7] as i64, -3);
        assert_eq!(cpu.x[28] as i64, -1);
        assert_eq!(cpu.x[29], u64::MAX);
        assert_eq!(cpu.x[30] as i64, -14);
    }

    #[test]
    fn ecall_traps_to_mtvec() {
        // 設定 mtvec = 0x80000100 後 ecall,應跳到該位址且 mcause = 11。
        let mut cpu = machine(&[
            lui(5, 0x80000),                         // t0 = 0xffffffff80000000
            addi(5, 5, 0x100),
            i_type(0x73, 1, 0, 5, 0x305),            // csrw mtvec, t0
            0x0000_0073,                             // ecall
        ]);
        cpu.x[0] = 0;
        for _ in 0..4 {
            cpu.step().unwrap();
        }
        assert_eq!(cpu.pc, 0xffff_ffff_8000_0100);
    }
}
