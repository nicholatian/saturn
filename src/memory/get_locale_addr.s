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

.file "src/gba/memory/get_locale_addr.s"
.ident "AS: (devkitARM release 45) 2.25.1"

.section .text

.balign 2
.thumb_func
.globl get_locale_addr

@@@ =========================== S U B R O U T I N E ===========================
@@
@@ TITLE:       Get memory locale address
@@ DESCRIPTION: Gets the starting address of a given locale depending on the
@@              value in R0.
@@
@@ PARAMETER: The ID of the locale to get. Possible values are:
@@              - 0: BIOS
@@              - 1: EWRAM
@@              - 2: IWRAM
@@              - 3: IO
@@              - 4: PAL
@@              - 5: VRAM
@@              - 6: OAM
@@              - 7: ROM
@@
@@ RETURNS: The starting address of the given memory locale.

get_locale_addr:
    PUSH    {LR}
    LSL     R0, R0, #29
    LSR     R0, R0, #29
    CMP     R0, #0
    BEQ     .Lreturn
    
    ADD     R0, R0, #1
    
.Lreturn:
    POP     {R1}
    BX      R1
