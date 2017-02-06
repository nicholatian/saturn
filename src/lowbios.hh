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

#ifndef GBA_BIOS_HH
#define GBA_BIOS_HH

#include <gba/types.hh>



extern "C"
{

void bios_soft_reset( );

void bios_register_ram_reset( u32 flags );

void bios_halt( );

void bios_stop( );

void bios_intr_wait( u32 flag_clear, u32 irq );

void bios_vblank_intr_wait( );

void bios_div( s32 num, s32 den );

void bios_div_arm( s32 den, s32 num );

void bios_sqrt( u32 num );

void bios_arc_tan( s16 dydx );

void bios_arc_tan2( s16 x, s16 y );

void bios_cpu_set( const void* src, void* dst, u32 mode );

void bios_cpu_fast_set( const void* src, void* dst, u32 mode );

void bios_bg_affine_set( const void* src, void* dst, s32 num );

void bios_obj_affine_set( const void* src, void* dst, s32 num,
    s32 offset );

void bios_bit_unpack( const void* src, void* dst, void* bup );

void bios_lzss_decomp_wram( const void* src, void* dst );

void bios_lzss_decomp_vram( const void* src, void* dst );

void bios_huff_decomp( const void* src, void* dst );

void bios_rl_decomp_wram( const void* src, void* dst );

void bios_rl_decomp_vram( const void* src, void* dst );

void bios_diff_8bit_unfilter_wram( const void* src, void* dst );

void bios_diff_8bit_unfilter_vram( const void* src, void* dst );

void bios_diff_16bit_unfilter( const void* src, void* dst );

void bios_sound_bias( u32 bias );

void bios_midi_key_to_freq( void* wa, u8 mk, u8 fp );

void bios_multi_boot( void* mb_param, u32 mode );

}



#endif // GBA_BIOS_HH
