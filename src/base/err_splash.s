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

.file "src/base/err_splash.s"
.ident "AS: (devkitARM release 45) 2.25.1"

.section .text

.balign 2
.globl err_splash
.thumb_func

@@@ =========================== S U B R O U T I N E ===========================
@@ FUNCTION: void err_splash( u8 type )
@@
@@ TITLE:       Display error splash
@@ DESCRIPTION: Displays an error screen using a splash image, and then halts
@@              the CPU.
@@
@@ PARAMETER: The type of error to display, if applicable. 0 means unspecified.
@@
@@ FOOTNOTE: This function does not return.

err_splash:
    PUSH    {R4,LR}
    LSL     R0, R0, #28
    LSR     R0, R0, #28
    
    @ Prepare the tools we need to copy
    LSL     R4, R0, #8
    ORR     R0, R4
    MOV     R1, #0
    MOV     R2, #0x9B  @ ~LDR R1, =0x9B00
    LSL     R2, R2, #8 @
    MOV     R3, #6      @ ~LDR R2, =0x6000000
    LSL     R3, R3, #24 @
    
    @ Copy over the pixel data into VRAM
.Lloop:
    STRH    R0, [R3,R1]
    ADD     R1, R1, #1
    CMP     R1, R2
    BCC     .Lloop
    
    @ Load the error splash palette
    LDR     R0, =colour_error_pal
    MOV     R1, #5      @ ~LDR R1, =0x5000000
    LSL     R1, R1, #24 @
    LDRH    R2, [R0,#0x0]
    STRH    R2, [R1,#0x0]
    LDRH    R2, [R0,#0x2]
    STRH    R2, [R1,#0x2]
    LDRH    R2, [R0,#0x4]
    STRH    R2, [R1,#0x4]
    LDRH    R2, [R0,#0x6]
    STRH    R2, [R1,#0x6]
    LDRH    R2, [R0,#0x8]
    STRH    R2, [R1,#0x8]
    LDRH    R2, [R0,#0xA]
    STRH    R2, [R1,#0xA]
    LDRH    R2, [R0,#0xC]
    STRH    R2, [R1,#0xC]
    LDRH    R2, [R0,#0xE]
    STRH    R2, [R1,#0xE]
    LDRH    R2, [R0,#0x10]
    STRH    R2, [R1,#0x10]
    LDRH    R2, [R0,#0x12]
    STRH    R2, [R1,#0x12]
    LDRH    R2, [R0,#0x14]
    STRH    R2, [R1,#0x14]
    LDRH    R2, [R0,#0x16]
    STRH    R2, [R1,#0x16]
    LDRH    R2, [R0,#0x18]
    STRH    R2, [R1,#0x18]
    LDRH    R2, [R0,#0x1A]
    STRH    R2, [R1,#0x1A]
    LDRH    R2, [R0,#0x1C]
    STRH    R2, [R1,#0x1C]
    LDRH    R2, [R0,#0x1E]
    STRH    R2, [R1,#0x1E]
    
    @ Load DISPCNT
    MOV     R0, #4      @ ~LDR R0, =0x4000000
    LSL     R0, R0, #24 @
    @ Switch to BG Mode 4
    MOV     R1, #4
    @ Enable BG2
    LSL     R2, R1, #8 @ neat little trick here to load the other bits
    ORR     R1, R2
    
    @ Flip the light switch on
    STRH    R1, [R0]
    
.Lreturn:
    POP     {R0}
    BX      R0
    
.Llinker:
    BX      R1
