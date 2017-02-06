/*****************************************************************************\
 *                                                                           * 
 *   .d8888b.          d8888 88888888888 888     888 8888888b.  888b    888  * 
 *  d88P  Y88b        d88888     888     888     888 888   Y88b 8888b   888  * 
 *  Y88b.            d88P888     888     888     888 888    888 88888b  888  * 
 *   "Y888b.        d88P 888     888     888     888 888   d88P 888Y88b 888  * 
 *      "Y88b.     d88P  888     888     888     888 8888888P"  888 Y88b888  * 
 *        "888    d88P   888     888     888     888 888 T88b   888  Y88888  * 
 *  Y88b  d88P   d8888888888     888     Y88b. .d88P 888  T88b  888   Y8888  * 
 *   "Y8888P"   d88P     888     888      "Y88888P"  888   T88b 888    Y888  * 
 *                                                                           * 
 *                                   Saturn                                  * 
 *     A general-purpose game engine for the Nintendo® Game Boy Advance™     * 
 *                                                                           * 
 *                       Copyright © 2016  Nicholatian                       * 
 *                                                                           * 
 *  Licensed under the Apache License, Version 2.0 (the “License”); you may  * 
 * not use this file except in compliance with the License. You may obtain a * 
 *                          copy of the  License at                          * 
 *                                                                           * 
 *                http://www.apache.org/licenses/LICENSE-2.0                 * 
 *                                                                           * 
 *    Unless required by applicable law or agreed to in writing, software    * 
 * distributed under the License is distributed on an “AS IS” BASIS, WITHOUT * 
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the  * 
 *  License for the specific language governing permissions and limitations  * 
 *                            under the  License.                            * 
 *                                                                           * 
\*****************************************************************************/

OUTPUT_ARCH(arm)

MEMORY
{
    bios    : ORIGIN = 0x00000000, LENGTH = 16k
    ewram   : ORIGIN = 0x02000000, LENGTH = 256k
    iwram   : ORIGIN = 0x03000000, LENGTH = 32k
    io      : ORIGIN = 0x04000000, LENGTH = 1k - 1
    pal     : ORIGIN = 0x05000000, LENGTH = 1k
    vram    : ORIGIN = 0x06000000, LENGTH = 96k
    oam     : ORIGIN = 0x07000000, LENGTH = 1k
    rom     : ORIGIN = 0x08000000, LENGTH = 32M
}

SECTIONS
{
    .text :
    {
        FILL (0xC046)
        
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
