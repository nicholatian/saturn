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

.file "src/main.s"
.ident "AS: (devkitARM release 45) 2.25.1"

.set initted, 0x3000000
.set initted_sz, 0x1

.section .text

.balign 2
.globl main
.thumb_func

@@@ =========================== S U B R O U T I N E ===========================
@@
@@ TITLE:       Main application function
@@ DESCRIPTION: Performs all of the initial program logic for the application.
@@
@@ FOOTNOTE: This function does not return.

main:
    PUSH    {LR}
    
.Lloop:
    LDR     R0, =initted
    LDRB    R0, [R0]
    CMP     R0, #0
    BEQ     .Lfirst_run
    B       .Lloop
    
.Lfirst_run:
    MOV     R0, #0xF
    LDR     R1, =err_splash
    BL      .Llinker
    MOV     R0, #1
    LDR     R1, =initted
    STRB    R0, [R1]
    
.Llinker:
    BX      R1

.pool
