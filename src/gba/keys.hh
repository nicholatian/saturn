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

#ifndef INC__LIBSATURN_GBA_KEYS_HH
#define INC__LIBSATURN_GBA_KEYS_HH

#include "gba/types.hh"

constexpr u16 kKeyinputAPressed     = 0x1;
constexpr u16 kKeyinputBPressed     = 0x2;
constexpr u16 kKeyinputSelPressed   = 0x4;
constexpr u16 kKeyinputStartPressed = 0x8;
constexpr u16 kKeyinputRightPressed = 0x10;
constexpr u16 kKeyinputLeftPressed  = 0x20;
constexpr u16 kKeyinputUpPressed    = 0x40;
constexpr u16 kKeyinputDownPressed  = 0x80;
constexpr u16 kKeyinputRPressed     = 0x100;
constexpr u16 kKeyinputLPressed     = 0x200;

u16* const ioKeyinput = reinterpret_cast<u16*>(0x4000130);

constexpr u16 kKeycntAPressed     = 0x1;
constexpr u16 kKeycntBPressed     = 0x2;
constexpr u16 kKeycntSelPressed   = 0x4;
constexpr u16 kKeycntStartPressed = 0x8;
constexpr u16 kKeycntRightPressed = 0x10;
constexpr u16 kKeycntLeftPressed  = 0x20;
constexpr u16 kKeycntUpPressed    = 0x40;
constexpr u16 kKeycntDownPressed  = 0x80;
constexpr u16 kKeycntRPressed     = 0x100;
constexpr u16 kKeycntLPressed     = 0x200;
constexpr u16 kKeycntUseIrq       = 0x4000;
constexpr u16 kKeycntIrqCond      = 0x8000;

u16* const ioKeycnt   = reinterpret_cast<u16*>(0x4000132);

#endif // INC__LIBSATURN_GBA_KEYS_HH
