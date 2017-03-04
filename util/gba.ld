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
 *                     Copyright © 2016-2017 Nicholatian                     * 
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

ENTRY(_sat__start)

MEMORY
{
    ewram   : ORIGIN = 0x2000000, LENGTH = 256k
    iwram   : ORIGIN = 0x3000000, LENGTH = 32k
    rom     : ORIGIN = 0x8000000, LENGTH = 32M
    sram    : ORIGIN = 0xE000000, LENGTH = 64k
}

_sat___text_start  = ORIGIN(rom);
_sat___ewram_start = ORIGIN(ewram);
_sat___iwram_start = ORIGIN(iwram);
_sat___sram_start  = ORIGIN(sram);

SECTIONS
{
    . = _sat___text_start;
    _sat___init_start = .;
    
    .init :
    {
        *(.init);
        *(.fini);
        . = ALIGN(4);
    } >rom
    
    _sat___init_end  = .;
    _sat___init_size = SIZEOF(.init);
    
    .text :
    {
        *(.text);
        *(.ctors);
        *(.dtors);
        *(.rodata);
        . = ALIGN(4);
    } >rom
    
    _sat___text_end  = .;
    _sat___text_size = SIZEOF(.text);
    
    . = _sat___iwram_start;
    
    /* Load code from ROM into IWRAM */
    .iwram :
    {
        _sat___iwram_load = LOADADDR(.iwram);
        
        *(.iwram);
        . = ALIGN(4);
    } >iwram AT >rom
    
    _sat___iwram_end  = .;
    /* This is NOT the size of the IWRAM memory region! */
    _sat___iwram_size = SIZEOF(.iwram);
    _sat___bss_start  = .;
    
    /* Earmark memory for uninitialised variables */
    .bss :
    {
        *(.bss);
        . = ALIGN(4);
        
        _sat___end = .;
    } >iwram
    
    _sat___bss_end         = .;
    _sat___bss_size        = SIZEOF(.bss);
    _sat___iwram_total     = _sat___iwram_size + _sat___bss_size;
    _sat___iwram_total_end = ORIGIN(iwram) + _sat___iwram_total;
    
    . = _sat___sram_start;
    
    .sram :
    {
        *(.sram);
        
        . = ALIGN(4);
        _sat___sram_end = .;
    } >sram
    
    _sat___sram_size = SIZEOF(.sram);
}
