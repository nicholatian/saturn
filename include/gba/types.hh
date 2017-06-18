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

#ifndef INC__LIBSATURN_GBA_TYPES_HH
#define INC__LIBSATURN_GBA_TYPES_HH

namespace saturn
{

using u8   = unsigned char;
using u16  = unsigned short;
using u32  = unsigned int;
using s8   = signed char;
using s16  = signed short;
using s32  = signed int;

using fu8  = u32;
using fu16 = u32;
using fu32 = u32;
using fs8  = s32;
using fs16 = s32;
using fs32 = s32;

using lu8  = u32;
using lu16 = u32;
using lu32 = u32;
using ls8  = s32;
using ls16 = s32;
using ls32 = s32;

using vu8   = volatile u8;
using vu16  = volatile u16;
using vu32  = volatile u32;
using vumax = volatile umax;
using vs8   = volatile s8;
using vs16  = volatile s16;
using vs32  = volatile s32;
using vsmax = volatile smax;

using vfu8  = volatile u32;
using vfu16 = volatile u32;
using vfu32 = volatile u32;
using vfs8  = volatile s32;
using vfs16 = volatile s32;
using vfs32 = volatile s32;

using vlu8  = volatile u32;
using vlu16 = volatile u32;
using vlu32 = volatile u32;
using vls8  = volatile s32;
using vls16 = volatile s32;
using vls32 = volatile s32;

template<int s> struct _tmp_ptri;
template<> struct _tmp_ptri<2> { using type = u16; };
template<> struct _tmp_ptri<4> { using type = u32; };

if constexpr( sizeof(void*) <= 4)
{
    using umax = unsigned int;
    using smax = signed int;
}
else
{
    using u64   = unsigned long long;
    using umax  = unsigned long long;
    using s64   = signed long long;
    using smax  = signed long long;
    using fu64  = u64;
    using fs64  = s64;
    using lu64  = u64;
    using ls64  = s64;
    using vu64  = volatile u64;
    using vs64  = volatile s64;
    using vfu64 = volatile u64;
    using vfs64 = volatile s64;
    using vlu64 = volatile u64;
    using vls64 = volatile s64;
    
    template<> struct _tmp_ptri<8> { using type = u64; };
}

using ptri = typename _tmp_ptri<sizeof(void*)>::type;

}

#endif // INC__LIBSATURN_GBA_TYPES_HH
