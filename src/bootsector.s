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
@@                 A minimal kernel for the Game Boy Advance                 @@
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

.file "src/bootsector.s"
.ident "AS: (devkitARM release 46) 2.27"

@@
@@ ROM jump opcode
@@

.section .init
.balign 4, 0
.arm
.globl _sat__start

_sat__start:
    
    B       _sat__rom_start

@@
@@ ROM header information
@@ - This is MANDATORY for all ROMs on hardware!
@@

@ Nintendo logo/character data (8000004h)
.byte 0x24, 0xFF, 0xAE, 0x51, 0x69, 0x9A, 0xA2, 0x21, 0x3D, 0x84
.byte 0x82, 0x0A, 0x84, 0xE4, 0x09, 0xAD, 0x11, 0x24, 0x8B, 0x98
.byte 0xC0, 0x81, 0x7F, 0x21, 0xA3, 0x52, 0xBE, 0x19, 0x93, 0x09
.byte 0xCE, 0x20, 0x10, 0x46, 0x4A, 0x4A, 0xF8, 0x27, 0x31, 0xEC
.byte 0x58, 0xC7, 0xE8, 0x33, 0x82, 0xE3, 0xCE, 0xBF, 0x85, 0xF4
.byte 0xDF, 0x94, 0xCE, 0x4B, 0x09, 0xC1, 0x94, 0x56, 0x8A, 0xC0
.byte 0x13, 0x72, 0xA7, 0xFC, 0x9F, 0x84, 0x4D, 0x73, 0xA3, 0xCA
.byte 0x9A, 0x61, 0x58, 0x97, 0xA3, 0x27, 0xFC, 0x03, 0x98, 0x76
.byte 0x23, 0x1D, 0xC7, 0x61, 0x03, 0x04, 0xAE, 0x56, 0xBF, 0x38
.byte 0x84, 0x00, 0x40, 0xA7, 0x0E, 0xFD, 0xFF, 0x52, 0xFE, 0x03
.byte 0x6F, 0x95, 0x30, 0xF1, 0x97, 0xFB, 0xC0, 0x85, 0x60, 0xD6
.byte 0x80, 0x25, 0xA9, 0x63, 0xBE, 0x03, 0x01, 0x4E, 0x38, 0xE2
.byte 0xF9, 0xA2, 0x34, 0xFF, 0xBB, 0x3E, 0x03, 0x44, 0x78, 0x00
.byte 0x90, 0xCB, 0x88, 0x11, 0x3A, 0x94, 0x65, 0xC0, 0x7C, 0x63
.byte 0x87, 0xF0, 0x3C, 0xAF, 0xD6, 0x25, 0xE4, 0x8B, 0x38, 0x0A
.byte 0xAC, 0x72, 0x21, 0xD4, 0xF8, 0x07

@ Game Title (80000A0h)
.ascii "SATURN\0\0\0\0\0\0"

@ Game code (80000ACh)
.ascii "CSAE"

@ Maker code (80000B0h)
.ascii "8J"

@ Fixed value (80000B2h)
.byte 0x96

@ Main unit code (80000B3h)
.byte 0x00

@ Device type (80000B4h)
.byte 0x00

@ Reserved area (0 Fixed | 7Byte) (80000B5h)
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

@ Software version No (80000BCh)
.byte 0x00

@ Complement check (80000BDh)
.byte 0xA6

@ Reserved area (0 Fixed | 2Byte) (80000BEh)
.byte 0x00, 0x00

@@
@@ ROM startup routine
@@

.globl _sat__rom_start
.balign 4, 0
.arm

_sat__rom_start:
    
    BL      .Linit_iwram
    BL      .Linit_ioregs
    MOV     R0, #0x12         @ Switch to IRQ mode
    MSR     CPSR, R0
    LDR     SP, =0x3007FA0
    MOV     R0, #0x1F         @ Switch to system mode
    MSR     CPSR, R0
    LDR     R1, =0x3007FFC    @ Set IRQ handler address (32-bit ARM mode)
    LDR     R0, =.Lirq_handler
    STR     R0, [R1]
    LDR     SP, =0x3007E40
    LDR     R1, =main         @ Start & switch to thumb-1 mode
    MOV     LR, PC
    BX      R1
    B       _sat__rom_start   @ Reset

.pool

.Linit_iwram:
    
    LDR     R0, =_sat___iwram_load
    LDR     R1, =_sat___iwram_start
    LDR     R2, =_sat___iwram_size
    LSR     R2, R2, #2
    MOV     R3, #0x4000000
    ORR     R2, R3
    @SWI     0xB
    BX      LR

.pool

.Linit_ioregs:
    BX      LR

@@
@@ Interrupt Branch Process (Table Lookup)
@@

@.section .iwram

.balign 4, 0
.arm

.Lirq_handler:
    
    MOV     R0, #0x4000000
    ADD     R0, #0x200
    @ Disable IME to prevent nested interrupts
    MOV     R1, #0
    STR     R1, [R0]
    @ Check if we have a stack overflow
    MOV     R2, #0x1F @ Switch to System mode
    MSR     CPSR, R2  @
    MOV     R3, SP
    MOV     R2, #0x12 @ Switch back to Interrupt mode
    MSR     CPSR, R2  @
    LDR     R2, =_sat___iwram_total_end
    @ Is the system SP lower than the end of occupied IWRAM?
    CMP     R3, R2
    BCC     .Lstack_overflow
    @ Check IF to see which interrupt(s) were triggered
    LDRH    R2, [R0,#8]
    LDR     R1, =_sat__hyper
    
    AND     R3, R2, #0x2000
    BNE     .Lhandle_gamepak
    AND     R3, R2, #0x0
    BNE     .Lhandle_vblank
    AND     R3, R2, #0x1
    BNE     .Lhandle_hblank
    AND     R3, R2, #0x1000
    BNE     .Lhandle_keypad
    BX      LR
    
.Lstack_overflow:
    LDR     R0, =_sat__stack_overflow @ Point of no return.
    BX      R0
    
.pool

.Lhandle_gamepak:
.Lhandle_keypad:
    STRH    R3, [R2] @ Acknowledge IRQ as handled
    LSR     R3, R3, #10 @ Convert IF bit to hyper bit
    B       .Lfinish_handle
    
.Lhandle_hblank:
.Lhandle_vblank:
    STRH    R3, [R2] @ Acknowledge IRQ as handled
    ADD     R3, R3, #1 @ Convert IF bit to hyper bit
    
.Lfinish_handle:
    LDR     R0, [R1] @ Get previous value of hyper
    ORR     R3, R0
    STR     R3, [R1] @ Place in newly set bit
    BX      LR
