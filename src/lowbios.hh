/// -*- coding: utf-8; mode: C++; indent-tabs-mode: nil; c-basic-offset: 4 -*-
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

#ifndef INC__LIBSATURN_LOWBIOS_HH
#define INC__LIBSATURN_LOWBIOS_HH

#include <gba/types.hh>



extern "C"
{

void _sat__bios_soft_reset( );

void _sat__bios_register_ram_reset( saturn::u32 flags );

void _sat__bios_halt( );

void _sat__bios_stop( );

void _sat__bios_intr_wait( saturn::u32 flag_clear, saturn::u32 irq );

void _sat__bios_vblank_intr_wait( );

saturn::s32 _sat__bios_div( saturn::s32 num, saturn::s32 den );

saturn::s32 _sat__bios_div_arm( saturn::s32 den, saturn::s32 num );

saturn::u32 _sat__bios_sqrt( saturn::u32 num );

saturn::u32 _sat__bios_arc_tan( saturn::s16 dydx );

saturn::u32 _sat__bios_arc_tan2( saturn::s16 x, saturn::s16 y );

void _sat__bios_cpu_set( const void* src, void* dst, saturn::u32 mode );

void _sat__bios_cpu_fast_set( const void* src, void* dst, saturn::u32 mode );

void _sat__bios_bg_affine_set( const void* src, void* dst, saturn::s32 num );

void _sat__bios_obj_affine_set( const void* src, void* dst, saturn::s32 num,
    saturn::s32 offset );

void _sat__bios_bit_unpack( const void* src, void* dst, void* bup );

void _sat__bios_lzss_decomp_wram( const void* src, void* dst );

void _sat__bios_lzss_decomp_vram( const void* src, void* dst );

void _sat__bios_huff_decomp( const void* src, void* dst );

void _sat__bios_rl_decomp_wram( const void* src, void* dst );

void _sat__bios_rl_decomp_vram( const void* src, void* dst );

void _sat__bios_diff_8bit_unfilter_wram( const void* src, void* dst );

void _sat__bios_diff_8bit_unfilter_vram( const void* src, void* dst );

void _sat__bios_diff_16bit_unfilter( const void* src, void* dst );

void _sat__bios_sound_bias( saturn::u32 bias );

void _sat__bios_midi_key_to_freq( void* wa, saturn::u8 mk, saturn::u8 fp );

void _sat__bios_multi_boot( void* mb_param, saturn::u32 mode );

}



#endif // INC__LIBSATURN_LOWBIOS_HH
