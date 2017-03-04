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

#include "fatal.hh"

#include <gba/lcd.hh>
#include <gba/memory.hh>
#include <gba/types.hh>



extern "C" void _sat__stack_overflow( )
{
    saturn::fatal( saturn::Error::StackOverflow );
}



void saturn::fatal( saturn::Error err )
{
    const u16 level    = static_cast<u16>(err);
    const u16 vramFill = level | (level << 8);
    
    for(u32 i = 0; i < 0x9B00; ++i)
    {
        segVramBg[i] = vramFill;
    }
    
    for(u32 i = 0; i < 0x10; ++i)
    {
        segPalBg[i] = (&colourErrorPal)[i];
    }
    
    *ioDispcnt = kDispcntBgMode4 | kDispcntShowBg2;
    
    for(;;);
}
