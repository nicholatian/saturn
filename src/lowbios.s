@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@                                                                           @@
@@   .d8888b.          d8888 88888888888 888     888 8888888b.  888b    888  @@
@@  d88P  Y88b        d88888     888     888     888 888   Y88b 8888b   888  @@
@@  Y88b.            d88P888     888     888     888 888    888 88888b  888  @@
@@   "Y888b.        d88P 888     888     888     888 888   d88P 888Y88b 888  @@
@@      "Y88b.     d88P  888     888     888     888 8888888P"  888 Y88b888  @@
@@        "888    d88P   888     888     888     888 888 T88b   888  Y88888  @@
@@  Y88b  d88P   d8888888888     888     Y88b. .d88P 888  T88b  888   Y8888  @@
@@   "Y8888P"   d88P     888     888      "Y88888P"  888   T88b 888    Y888  @@
@@                                                                           @@
@@                                   Saturn                                  @@
@@     A general-purpose game engine for the Nintendo® Game Boy Advance™     @@
@@                                                                           @@
@@                       Copyright © 2016  Nicholatian                       @@
@@                                                                           @@
@@  Licensed under the Apache License, Version 2.0 (the “License”); you may  @@
@@ not use this file except in compliance with the License. You may obtain a @@
@@                          copy of the  License at                          @@
@@                                                                           @@
@@                http://www.apache.org/licenses/LICENSE-2.0                 @@
@@                                                                           @@
@@    Unless required by applicable law or agreed to in writing, software    @@
@@ distributed under the License is distributed on an “AS IS” BASIS, WITHOUT @@
@@ WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the  @@
@@  License for the specific language governing permissions and limitations  @@
@@                            under the  License.                            @@
@@                                                                           @@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

.file "src/bios.s"
.ident "AS: (devkitARM release 46) 2.27"

.section .text
.balign  2, 0
.code    16

@ === SoftReset [00h] =================================================
@ DECL: void _sat__bios_soft_reset();
@ DESC: 
.balign 2, 0
.global _sat__bios_soft_reset
.thumb_func

_sat__bios_soft_reset:
    SWI     0x00
    BX      LR

@ === RegisterRamReset [01h] ==========================================
@ DECL: void _sat__bios_register_ram_reset(u32 flags);
@ DESC: 
.balign 2, 0
.global _sat__bios_register_ram_reset
.thumb_func

_sat__bios_register_ram_reset:
    SWI     0x01
    BX      LR

@ === Halt [02h] ======================================================
@ DECL: void _sat__bios_halt();
@ DESC: 
.balign 2, 0
.global _sat__bios_halt
.thumb_func

_sat__bios_halt:
    SWI     0x02
    BX      LR

@ === Stop [03h] ======================================================
@ DECL: void _sat__bios_stop();
@ DESC: 
.balign 2, 0
.global _sat__bios_stop
.thumb_func

_sat__bios_stop:
    SWI     0x03
    BX      LR

@ === IntrWait [04h] ==================================================
@ DECL: void _sat__bios_intr_wait(u32 flagClear, u32 irq);
@ DESC: 
.balign 2, 0
.global _sat__bios_intr_wait
.thumb_func

_sat__bios_intr_wait:
    SWI     0x04
    BX      LR

@ === VBlankIntrWait [05h] ============================================
@ DECL: void _sat__bios_vblank_intr_wait();
@ DESC: 
.balign 2, 0
.global _sat__bios_vblank_intr_wait
.thumb_func

_sat__bios_vblank_intr_wait:
    SWI     0x05
    BX      LR

@ === Div [06h] =======================================================
@ DECL: s32 _sat__bios_div(s32 num, s32 den);
@ DESC: 
.balign 2, 0
.global _sat__bios_div
.thumb_func

_sat__bios_div:
    SWI     0x06
    BX      LR

@ === DivArm [07h] ====================================================
@ DECL: s32 _sat__bios_div_arm(s32 den, s32 num);
@ DESC: 
.balign 2, 0
.global _sat__bios_div_arm
.thumb_func

_sat__bios_div_arm:
    SWI     0x07
    BX      LR

@ === Sqrt [08h] ======================================================
@ DECL: u32 _sat__bios_sqrt(u32 num);
@ DESC: 
.balign 2, 0
.global _sat__bios_sqrt
.thumb_func

_sat__bios_sqrt:
    SWI     0x08
    BX      LR

@ === ArcTan [09h] ====================================================
@ DECL: s16 _sat__bios_arc_tan(s16 dydx);
@ DESC: 
.balign 2, 0
.global _sat__bios_arc_tan
.thumb_func

_sat__bios_arc_tan:
    SWI     0x09
    BX      LR

@ === ArcTan2 [0Ah] ===================================================
@ DECL: s16 _sat__bios_arc_tan2(s16 x, s16 y);
@ DESC: 
.balign 2, 0
.global _sat__bios_arc_tan2
.thumb_func

_sat__bios_arc_tan2:
    SWI     0x0A
    BX      LR

@ === CpuSet [0Bh] ====================================================
@ DECL: void _sat__bios_cpu_set(const void *src, void *dst, u32 mode);
@ DESC: 
.balign 2, 0
.global _sat__bios_cpu_set
.thumb_func

_sat__bios_cpu_set:
    SWI     0x0B
    BX      LR

@ === CpuFastSet [0Ch] ================================================
@ DECL: void _sat__bios_cpu_fast_set(const void *src, void *dst, u32 mode);
@ DESC: 
.balign 2, 0
.global _sat__bios_cpu_fast_set
.thumb_func

_sat__bios_cpu_fast_set:
    SWI     0x0C
    BX      LR

@ === BgAffineSet [0Eh] ===============================================
@ DECL: void _sat__bios_bg_affine_set(const BgAffineSource *src, BgAffineDest *dst, s32 num);
@ DESC: 
.balign 2, 0
.global _sat__bios_bg_affine_set
.thumb_func

_sat__bios_bg_affine_set:
    SWI     0x0E
    BX      LR

@ === ObjAffineSet [0Fh] ==============================================
@ DECL: void _sat__bios_obj_affine_set(const ObjAffineSource *src, void *dst, s32 num, s32 offset);
@ DESC: 
.balign 2, 0
.global _sat__bios_obj_affine_set
.thumb_func

_sat__bios_obj_affine_set:
    SWI     0x0F
    BX      LR

@ === BitUnPack [10h] =================================================
@ DECL: void _sat__bios_bit_unpack(const void *src, void *dst, BUP *bup);
@ DESC: 
.balign 2, 0
.global _sat__bios_bit_unpack
.thumb_func

_sat__bios_bit_unpack:
    SWI     0x10
    BX      LR

@ === LZ77UnCompWram [11h] ============================================
@ DECL: void _sat__bios_lzss_decomp_wram(const void *src, void *dst);
@ DESC: 
.balign 2, 0
.global _sat__bios_lzss_decomp_wram
.thumb_func

_sat__bios_lzss_decomp_wram:
    SWI     0x11
    BX      LR

@ === LZ77UnCompVram [12h] ============================================
@ DECL: void _sat__bios_lzss_decomp_vram(const void *src, void *dst);
@ DESC: 
.balign 2, 0
.global _sat__bios_lzss_decomp_vram
.thumb_func

_sat__bios_lzss_decomp_vram:
    SWI     0x12
    BX      LR

@ === HuffUnComp [13h] ================================================
@ DECL: void _sat__bios_huff_decomp(const void *src, void *dst);
@ DESC: 
.balign 2, 0
.global _sat__bios_huff_decomp
.thumb_func

_sat__bios_huff_decomp:
    SWI     0x13
    BX      LR

@ === RLUnCompWram [14h] ==============================================
@ DECL: void _sat__bios_rl_decomp_wram(const void *src, void *dst);
@ DESC: 
.balign 2, 0
.global _sat__bios_rl_decomp_wram
.thumb_func

_sat__bios_rl_decomp_wram:
    SWI     0x14
    BX      LR

@ === RLUnCompVram [15h] ==============================================
@ DECL: void _sat__bios_rl_decomp_vram(const void *src, void *dst);
@ DESC: 
.balign 2, 0
.global _sat__bios_rl_decomp_vram
.thumb_func

_sat__bios_rl_decomp_vram:
    SWI     0x15
    BX      LR

@ === Diff8bitUnFilterWram [16h] ======================================
@ DECL: void _sat__bios_diff_8bit_unfilter_wram(const void *src, void *dst);
@ DESC: 
.balign 2, 0
.global _sat__bios_diff_8bit_unfilter_wram
.thumb_func

_sat__bios_diff_8bit_unfilter_wram:
    SWI     0x16
    BX      LR

@ === Diff8bitUnFilterVram [17h] ======================================
@ DECL: void _sat__bios_diff_8bit_unfilter_vram(const void *src, void *dst);
@ DESC: 
.balign 2, 0
.global _sat__bios_diff_8bit_unfilter_vram
.thumb_func

_sat__bios_diff_8bit_unfilter_vram:
    SWI     0x17
    BX      LR

@ === Diff16bitUnFilter [18h] =========================================
@ DECL: void _sat__bios_diff_16bit_unfilter(const void *src, void *dst);
@ DESC: 
.balign 2, 0
.global _sat__bios_diff_16bit_unfilter
.thumb_func

_sat__bios_diff_16bit_unfilter:
    SWI     0x18
    BX      LR

@ === SoundBias [19h] =================================================
@ DECL: void _sat__bios_sound_bias(u32 bias);
@ DESC: 
.balign 2, 0
.global _sat__bios_sound_bias
.thumb_func

_sat__bios_sound_bias:
    SWI     0x19
    BX      LR

@ === SoundDriverInit [1Ah] ===========================================
@ DECL: void _sat__bios_sound_driver_init(void *src);
@ DESC: 
@    .balign 2
@    .global _sat__bios_sound_driver_init
@    .thumb_func

@_sat__bios_sound_driver_init:
@    SWI     0x1A
@    BX      LR

@ === SoundDriverMode [1Bh] ===========================================
@ DECL: void _sat__bios_sound_driver_mode(u32 mode);
@ DESC: 
@    .balign 2
@    .global _sat__bios_sound_driver_mode
@    .thumb_func

@_sat__bios_sound_driver_mode:
@    SWI     0x1B
@    BX      LR

@ === SoundDriverMain [1Ch] ===========================================
@ DECL: void _sat__bios_sound_driver_main();
@ DESC: 
@    .balign 2
@    .global _sat__bios_sound_driver_main
@    .thumb_func

@_sat__bios_sound_driver_main:
@    SWI     0x1C
@    BX      LR

@ === SoundDriverVSync [1Dh] ==========================================
@ DECL: void _sat__bios_sound_driver_vsync();
@ DESC: 
@    .balign 2
@    .global _sat__bios_sound_driver_vsync
@    .thumb_func

@_sat__bios_sound_driver_vsync:
@    SWI     0x1D
@    BX      LR

@ === SoundChannelClear [1Eh] =========================================
@ DECL: void _sat__bios_sound_channel_clear();
@ DESC: 
@    .balign 2
@    .global _sat__bios_sound_channel_clear
@    .thumb_func

@_sat__bios_sound_channel_clear:
@    SWI     0x1E
@    BX      LR

@ === MidiKey2Freq [1Fh] ==============================================
@ DECL: u32 _sat__bios_midi_key_to_freq(void *wa, u8 mk, u8 fp);
@ DESC: 
.balign 2, 0
.global _sat__bios_midi_key_to_freq
.thumb_func

_sat__bios_midi_key_to_freq:
    SWI     0x1F
    BX      LR

@ === MultiBoot [25h] =================================================
@ DECL: s32 _sat__bios_multi_boot(MultiBootParam* mb, u32 mode);
@ DESC: 
.balign 2, 0
.global _sat__bios_multi_boot
.thumb_func

_sat__bios_multi_boot:
    SWI     0x25
    BX      LR

@ === SoundDriverVSyncOff [28h] =======================================
@ DECL: void _sat__bios_sound_driver_vsync_off();
@ DESC: 
@    .balign 2
@    .global _sat__bios_sound_driver_vsync_off
@    .thumb_func

@_sat__bios_sound_driver_vsync_off:
@    SWI     0x28
@    BX      LR

@ === SoundDriverVSyncOn [29h] ========================================
@ DECL: void _sat__bios_sound_driver_vsync_on();
@ DESC: 
@    .balign 2
@    .global _sat__bios_sound_driver_vsync_on
@    .thumb_func

@_sat__bios_sound_driver_vsync_on:
@    SWI     0x29
@    BX      LR

@ EOF
