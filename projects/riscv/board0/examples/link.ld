ENTRY(_start)
MEMORY { RAM (rwx) : ORIGIN = 0, LENGTH = 128K }
SECTIONS {
  .text   : { *(.text.init) *(.text .text.*) } > RAM
  .rodata : { *(.rodata .rodata.*) } > RAM
  .data   : { *(.data .data.* .sdata .sdata.*) } > RAM
  .bss    : { *(.bss .bss.* .sbss .sbss.*) } > RAM
  _stack_top = ORIGIN(RAM) + LENGTH(RAM);
  /DISCARD/ : { *(.eh_frame) *(.eh_frame_hdr) }
}
