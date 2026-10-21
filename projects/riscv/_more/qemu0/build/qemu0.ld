ENTRY(_start)
SECTIONS {
  . = 0x80000000;
  .text   : { *(.text*) }
  .rodata : { *(.rodata*) }
  .data   : { *(.data*) *(.sdata*) }
  .bss    : { *(.bss*) *(.sbss*) *(COMMON) }
  /DISCARD/ : { *(.riscv.attributes) *(.comment) *(.note*) }
}
