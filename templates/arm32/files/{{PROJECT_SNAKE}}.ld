/* The memory map of the board being emulated: MPS2 AN385 runs code from zero
 * and has its SRAM at 0x20000000. This lives in the project rather than the
 * image so that changing the map does not mean rebuilding a container. */
MEMORY
{
  FLASH (rx)  : ORIGIN = 0x00000000, LENGTH = 4M
  RAM   (rwx) : ORIGIN = 0x20000000, LENGTH = 4M
}

SECTIONS
{
  /* KEEP, because nothing references the vector table by name and the linker
   * would otherwise garbage-collect the one thing the chip needs at zero. */
  .text : { KEEP(*(.vectors)) *(.text*) *(.rodata*) } > FLASH
  .data : { *(.data*) } > RAM
  .bss  : { *(.bss*) *(COMMON) } > RAM

  _stack_top = ORIGIN(RAM) + LENGTH(RAM);
}
