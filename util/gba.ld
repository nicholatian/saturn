
OUTPUT_ARCH(arm)

ENTRY(__start)

MEMORY
{
    ewram   : ORIGIN = 0x2000000, LENGTH = 256k
    iwram   : ORIGIN = 0x3000000, LENGTH = 32k
    io      : ORIGIN = 0x4000000, LENGTH = 1k - 1
    pal     : ORIGIN = 0x5000000, LENGTH = 1k
    vram    : ORIGIN = 0x6000000, LENGTH = 96k
    oam     : ORIGIN = 0x7000000, LENGTH = 1k
    rom     : ORIGIN = 0x8000000, LENGTH = 32M
}

SECTIONS
{
    .text :
    {
        FILL (0xABCD)
        
        __text_start = . ;
        *(.init)
        *(.text)
        *(.ctors)
        *(.dtors)
        *(.rodata)
        *(.fini)
        *(.data)
        *(COMMON)
        __text_end  = . ;
        
        __bss_start__ = . ;
        *(.bss)
        __bss_end__ = . ;
        _end = __bss_end__ ;
        __end__ = __bss_end__ ;
    } >rom = 0xFF
}
