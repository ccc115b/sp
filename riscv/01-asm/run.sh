riscv64-unknown-elf-gcc -nostdlib -nostartfiles $1.s -o $1
spike pk $1
echo $?