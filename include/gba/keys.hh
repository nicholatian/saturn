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

#ifndef GBA_KEYS_HH
#define GBA_KEYS_HH

#include "types.hh"

struct IoKeyinput
{
    u16 a      : 1;
    u16 b      : 1;
    u16 select : 1;
    u16 start  : 1;
    u16 right  : 1;
    u16 left   : 1;
    u16 up     : 1;
    u16 down   : 1;
    u16 r      : 1;
    u16 l      : 1;
    u16 unused : 6;
};

struct IoKeycnt
{
    u16 a        : 1;
    u16 b        : 1;
    u16 select   : 1;
    u16 start    : 1;
    u16 right    : 1;
    u16 left     : 1;
    u16 up       : 1;
    u16 down     : 1;
    u16 r        : 1;
    u16 l        : 1;
    u16 unused   : 4;
    u16 use_irq  : 1;
    u16 irq_cond : 1;
};

IoKeyinput* const  ioKeyinput = reinterpret_cast<IoKeyinput*>(0x4000130);
IoKeycnt* const    ioKeycnt   = reinterpret_cast<IoKeycnt*>(0x4000132);

#endif /* GBA_KEYS_HH */
