# ll2rv

LLVM IR (.ll) → RISC-V 64 (RV64GC, LP64) assembly (.s)，無外部依賴。

    cargo build --release
    ./target/release/ll2rv examples/fib.ll -o fib.s
    riscv64-linux-gnu-gcc -static fib.s -o fib && qemu-riscv64 ./fib

限制：不支援浮點、向量、i128、聚合值 load/store、動態 alloca、variadic 函式定義。
