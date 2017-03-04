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

#include "himem.hh"

#include "gba/types.hh"



constexpr u32 kHeapSize  = 0x40000;
constexpr u32 kMaxAllocs = 0x400;

void* const kHeapStart = reinterpret_cast<void*>(0x2000000);
void* const kHeapEnd   = reinterpret_cast<void*>(
    reinterpret_cast<u32>(kHeapStart) + kHeapSize - 1);

namespace
{

void* blockEndSentinel;
u32   blockCount;
u32   blockSizes[kMaxAllocs];
void* blocks[kMaxAllocs];

}

void* saturn::himem::alloc( u32 size )
{
    if(size == 0)
    {
        saturn::fatal( saturn::Error::LengthError );
    }
    
    if(size > kHeapSize)
    {
        saturn::fatal( saturn::Error::HeapOverflow );
    }
    
    // Search for free slot in block metadata
    u32 freeSlot = 0;
    
    while(blocks[freeSlot] != nullptr)
    {
        ++freeSlot;
    }
    
    // Find free space in EWRAM
    void* lastEnd = kHeapStart;
    
    for(u32 i = 0; i < blockEndSentinel; ++i)
    {
        if(blocks[i] == nullptr)
        {
            continue;
        }
        
        // Check if there is enough space in between allocs
        if(blocks[i] - lastEnd > size)
        {
            break;
        }
        else
        {
            lastEnd = blocks[i] + reinterpret_cast<void*>(blockSizes[i]);
        }
    }
    
    blocks[freeSlot]     = lastEnd;
    blockSizes[freeSlot] = size;
    
    ++blockCount;
    
    return lastEnd;
}



void saturn::himem::dealloc( void* ptr )
{
    
}
