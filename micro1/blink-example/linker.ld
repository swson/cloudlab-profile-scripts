ENTRY(reset_handler)

MEMORY
{
    FLASH (rx)  : ORIGIN = 0x10000000, LENGTH = 2048K
    RAM   (rwx) : ORIGIN = 0x20000000, LENGTH = 256K
}

__stack_top = ORIGIN(RAM) + LENGTH(RAM);

SECTIONS
{
    .boot2 ORIGIN(FLASH) : {
        KEEP(*(.boot2))
    } > FLASH

    .vectors ORIGIN(FLASH) + 0x100 : {
        KEEP(*(.vectors))
    } > FLASH

    .text : {
        *(.text*)
        *(.rodata*)
    } > FLASH

    __data_load_start = LOADADDR(.data);

    .data : {
        __data_start = .;
        *(.data*)
        __data_end = .;
    } > RAM AT > FLASH

    .bss : {
        __bss_start = .;
        *(.bss*)
        *(COMMON)
        __bss_end = .;
    } > RAM
}
