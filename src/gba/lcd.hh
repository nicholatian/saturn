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

#ifndef INC__LIBSATURN_GBA_LCD_HH
#define INC__LIBSATURN_GBA_LCD_HH

#include "gba/types.hh"

constexpr u16 kDispcntBgMode0    = 0x0;
constexpr u16 kDispcntBgMode1    = 0x1;
constexpr u16 kDispcntBgMode2    = 0x2;
constexpr u16 kDispcntBgMode3    = 0x3;
constexpr u16 kDispcntBgMode4    = 0x4;
constexpr u16 kDispcntBgMode5    = 0x5;
constexpr u16 kDispcntCgbMode    = 0x8;
constexpr u16 kDispcntFrameSel   = 0x10;
constexpr u16 kDispcntHblankIntv = 0x20;
constexpr u16 kDispcntObjVramDim = 0x40;
constexpr u16 kDispcntForceBlank = 0x80;
constexpr u16 kDispcntShowBg0    = 0x100;
constexpr u16 kDispcntShowBg1    = 0x200;
constexpr u16 kDispcntShowBg2    = 0x400;
constexpr u16 kDispcntShowBg3    = 0x800;
constexpr u16 kDispcntShowObj    = 0x1000;
constexpr u16 kDispcntShowWin0   = 0x2000;
constexpr u16 kDispcntShowWin1   = 0x4000;
constexpr u16 kDispcntShowObjWin = 0x8000;

u16* const  ioDispcnt   = reinterpret_cast<u16*>(0x4000000);
bool* const ioGreenswap = reinterpret_cast<bool*>(0x4000002);

constexpr u16 kDispstatVblank      = 0x1;
constexpr u16 kDispstatHblank      = 0x2;
constexpr u16 kDispstatVcounter    = 0x4;
constexpr u16 kDispstatVblankIrq   = 0x8;
constexpr u16 kDispstatHblankIrq   = 0x10;
constexpr u16 kDispstatVcounterIrq = 0x20;

constexpr u16 dispstatVcount( u16 vcount )
{
    return vcount << 8;
}

u16* const ioDispstat = reinterpret_cast<u16*>(0x4000004);

u8* const ioVcount = reinterpret_cast<u8*>(0x4000006);

struct IoBgcnt
{
    u16 priority   : 2;
    u16 imgSector  : 2;
    u16 unused     : 2;
    u16 mosaic     : 1;
    u16 palMode    : 1;
    u16 mapSector  : 5;
    u16 overflow   : 1;
    u16 screenSize : 2;
};

constexpr u16 bgcntPriority( u16 priority )
{
    return priority;
}

constexpr u16 bgcntImgSector( u16 sector )
{
    return sector << 2;
}

constexpr u16 kBgcntMosaic = 0x80;

constexpr u16 kBgcntPalMode4 = 0x0;
constexpr u16 kBgcntPalMode8 = 0x100;

constexpr u16 bgcntMapSector( u16 sector )
{
    return sector << 8;
}

constexpr u16 bgcntMapAddr( u16 address )
{
    return ((address - 0x6000000) >> 10) << 8;
}

constexpr u16 kBgcntOverflow = 0x2000;

enum class BgcntScreenSize : u16
{
    _256x256 = 0,
    _256x512 = 1,
    _512x256 = 2,
    _512x512 = 3
};

constexpr u16 bgcntScreenSize( BgcntScreenSize size )
{
    return static_cast<u16>(size) << 14;
}

u16* const ioBg0cnt = reinterpret_cast<u16*>(0x40000008);
u16* const ioBg1cnt = reinterpret_cast<u16*>(0x4000000A);
u16* const ioBg2cnt = reinterpret_cast<u16*>(0x4000000C);
u16* const ioBg3cnt = reinterpret_cast<u16*>(0x4000000E);

u16* const ioBg0hofs = reinterpret_cast<u16*>(0x40000010);
u16* const ioBg0vofs = reinterpret_cast<u16*>(0x40000012);
u16* const ioBg1hofs = reinterpret_cast<u16*>(0x40000014);
u16* const ioBg1vofs = reinterpret_cast<u16*>(0x40000016);
u16* const ioBg2hofs = reinterpret_cast<u16*>(0x40000018);
u16* const ioBg2vofs = reinterpret_cast<u16*>(0x4000001A);
u16* const ioBg3hofs = reinterpret_cast<u16*>(0x4000001C);
u16* const ioBg3vofs = reinterpret_cast<u16*>(0x4000001E);

struct IoBgfloat16
{
    u16 fractional : 8;
    u16 integer    : 7;
    u16 sign       : 1;
};

struct IoBgfloat32
{
    u32 fractional : 8;
    u32 integer    : 19;
    u32 sign       : 1;
    u32 unused     : 4;
};

IoBgfloat16* const ioBg2pa = reinterpret_cast<IoBgfloat16*>(0x4000020);
IoBgfloat16* const ioBg2pb = reinterpret_cast<IoBgfloat16*>(0x4000022);
IoBgfloat16* const ioBg2pc = reinterpret_cast<IoBgfloat16*>(0x4000024);
IoBgfloat16* const ioBg2pd = reinterpret_cast<IoBgfloat16*>(0x4000026);
IoBgfloat32* const ioBg2xL = reinterpret_cast<IoBgfloat32*>(0x4000028);
IoBgfloat32* const ioBg2xH = reinterpret_cast<IoBgfloat32*>(0x400002A);
IoBgfloat32* const ioBg2yL = reinterpret_cast<IoBgfloat32*>(0x400002C);
IoBgfloat32* const ioBg2yH = reinterpret_cast<IoBgfloat32*>(0x400002E);

IoBgfloat16* const ioBg3pa = reinterpret_cast<IoBgfloat16*>(0x4000030);
IoBgfloat16* const ioBg3pb = reinterpret_cast<IoBgfloat16*>(0x4000032);
IoBgfloat16* const ioBg3pc = reinterpret_cast<IoBgfloat16*>(0x4000034);
IoBgfloat16* const ioBg3pd = reinterpret_cast<IoBgfloat16*>(0x4000036);
IoBgfloat32* const ioBg3xL = reinterpret_cast<IoBgfloat32*>(0x4000038);
IoBgfloat32* const ioBg3xH = reinterpret_cast<IoBgfloat32*>(0x400003A);
IoBgfloat32* const ioBg3yL = reinterpret_cast<IoBgfloat32*>(0x400003C);
IoBgfloat32* const ioBg3yH = reinterpret_cast<IoBgfloat32*>(0x400003E);

struct IoWinH
{
    u8 left;
    u8 right;
};

IoWinH* const ioWin0H = reinterpret_cast<IoWinH*>(0x4000040);
IoWinH* const ioWin1H = reinterpret_cast<IoWinH*>(0x4000042);

struct IoWinV
{
    u8 top;
    u8 bottom;
};

IoWinV* const ioWin0V = reinterpret_cast<IoWinV*>(0x4000044);
IoWinV* const ioWin1V = reinterpret_cast<IoWinV*>(0x4000046);

struct IoWinIn
{
    u16 win0Bg0 : 1;
    u16 win0Bg1 : 1;
    u16 win0Bg2 : 1;
    u16 win0Bg3 : 1;
    u16 win0Obj : 1;
    u16 win0Eff : 1;
    u16 unused0 : 2;
    u16 win1Bg0 : 1;
    u16 win1Bg1 : 1;
    u16 win1Bg2 : 1;
    u16 win1Bg3 : 1;
    u16 win1Obj : 1;
    u16 win1Eff : 1;
    u16 unused1 : 2;
};

IoWinIn* const ioWinIn = reinterpret_cast<IoWinIn*>(0x4000048);

struct IoWinOut
{
    u16 outBg0    : 1;
    u16 outBg1    : 1;
    u16 outBg2    : 1;
    u16 outBg3    : 1;
    u16 outObj    : 1;
    u16 outEff    : 1;
    u16 unused0   : 2;
    u16 objwinBg0 : 1;
    u16 objwinBg1 : 1;
    u16 objwinBg2 : 1;
    u16 objwinBg3 : 1;
    u16 objwinObj : 1;
    u16 objwinEff : 1;
    u16 unused1   : 2;
};

IoWinOut* const ioWinOut = reinterpret_cast<IoWinOut*>(0x400004A);

struct IoMosaic
{
    u32 bgH    : 4;
    u32 bgV    : 4;
    u32 objH   : 4;
    u32 objV   : 4;
    u32 unused : 16;
};

IoMosaic* const ioMosaic = reinterpret_cast<IoMosaic*>(0x400004C);

struct IoBldcnt
{
    u16 bg0Target1  : 1;
    u16 bg1Target1  : 1;
    u16 bg2Target1  : 1;
    u16 bg3Target1  : 1;
    u16 objTarget1  : 1;
    u16 backTarget1 : 1;
    u16 colorEff    : 2;
    u16 bg0Target2  : 1;
    u16 bg1Target2  : 1;
    u16 bg2Target2  : 1;
    u16 bg3Target2  : 1;
    u16 objTarget2  : 1;
    u16 backTarget2 : 1;
};

IoBldcnt* const ioBldcnt = reinterpret_cast<IoBldcnt*>(0x4000050);

struct IoBldalpha
{
    u8 eva;
    u8 evb;
};

IoBldalpha* const ioBldalpha = reinterpret_cast<IoBldalpha*>(0x4000052);

struct IoBldy
{
    u8 evy;
};

IoBldy* const ioBldy = reinterpret_cast<IoBldy*>(0x4000054);

constexpr u32 imgSector( u8 addrbit )
{
    return (addrbit * 0x4000) + 0x6000000;
}

constexpr u32 mapSector( u8 addrbit )
{
    return (addrbit * 0x800) + 0x6000000;
}

constexpr u32 palSector( u16 slot )
{
    return (slot * 2) + 0x5000000;
}

struct ObjAttr0
{
    u16 yPos    : 8;
    u16 rotscal : 1;
    u16 dblDis  : 1;
    u16 objMode : 2;
    u16 mosaic  : 1;
    u16 palMode : 1;
    u16 shape   : 2;
};

struct ObjAttr1A
{
    u16 xPos        : 9;
    u16 roscalParam : 5;
    u16 objSize     : 2;
};

struct ObjAttr1B
{
    u16 xPos    : 9;
    u16 unused  : 3;
    u16 hFlip   : 1;
    u16 vFlip   : 1;
    u16 objSize : 2;
};

struct ObjAttr2
{
    u16 charName : 10;
    u16 priority : 2;
    u16 palNum   : 4;
};

#endif // INC__LIBSATURN_GBA_LCD_HH
