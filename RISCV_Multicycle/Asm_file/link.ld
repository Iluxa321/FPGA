OUTPUT_ARCH(riscv)
ENTRY(_start)
OUTPUT_FORMAT("elf32-littleriscv", "elf32-littleriscv",
	      "elf32-littleriscv")
OUTPUT_ARCH(riscv)
MEMORY
{
    FLASH(rx) :ORIGIN = 0x00000000, LENGTH = 10K
    RAM(rwx) :ORIGIN = 0x0020000, LENGTH = 1K
}

_stack_size = 256;
_estack = ORIGIN(RAM) + LENGTH(RAM);

/* STARTUP(output/startup.o) */

SECTIONS
{
    .text :
    {
        . = ALIGN(4);
        output/startup.o(.text)
        *(.text)
        . = ALIGN(4);
    }> FLASH
    _etext = LOADADDR(.data);
    .data :
    {   
        . = ALIGN(4);
        _sdata = .;
        *(.data)
        . = ALIGN(4);
        _edata = .;
    }> RAM AT > FLASH
    .bss :
    {
        . = ALIGN(4);
        _sbss = .;
        *(.bss)
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;
    }> RAM
   
}
