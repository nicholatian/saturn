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

#include "memory.hh"

#include "fatal.hh"
#include "gba/types.hh"
#include "lowbios.hh"



using saturn::u32;
using saturn::u16;
using saturn::u8;
using saturn::ptri;

using saturn::ErrorCat;
using saturn::ErrorEntry;
using saturn::ErrorEntrySystem;
using saturn::Error;



extern ptri _sat___ewram_start;



namespace
{
    constexpr u32 kHeapSize   = 0x40000;
    constexpr u32 kMaxAllocs  = 0x400;
    constexpr u32 kChunkSize  = 32;
    constexpr u32 kChunkSizeB = 5; // used for bit shift division
    constexpr u32 kHeapBlocks = kHeapSize / kChunkSize;

    void* const kHeapStart = reinterpret_cast<void*>(_sat___ewram_start);
    void* const kHeapEnd   = reinterpret_cast<void*>(_sat___ewram_start +
                                                     kHeapSize - 1);
    
    u32   blockCount;
    void* blocks[kMaxAllocs];
    u16   blockChunkCounts[kMaxAllocs];
}



/** ;============================ F U N C T I O N ============================ *
 * 
 * TITLE:       LoMem copy function
 * DESCRIPTION: This function wraps the AGB BIOS functions which implement
 *              efficient memory copying/filling functionality in order to
 *              provide better flexibility in payload sizing while maintaining
 *              as much of the efficiency of the BIOS functions as possible.
 *              CpuSet/CpuFastSet MUST copy data in blocks in order to be fast,
 *              which can be awkward for data which does not fit neatly in
 *              those blocks. To remedy this, we need to copy as much data as
 *              possible using CpuFastSet, then copying whatever leftovers that
 *              fit in CpuSet, and finally copying the remaining data by hand
 *              as words then dwords then bytes. See GBATek for details on how
 *              CpuSet and CpuFastSet operate.
 * 
 * PARAMETER: Source address to start copying from
 * PARAMETER: Size of source, in bytes.
 * PARAMETER: Destination to copy source to.
 * 
 */

saturn::Error saturn::lomem::copy( void* src, u32 srcSize, void* dst )
{
    // Check the bounds of the source and destination address
    
    if(!isReadable( src ) || !isWritable( dst ))
    {
        return Error( ErrorCat::System,
                      static_cast<ErrorEntry>(ErrorEntrySystem::OutOfRange)
            );
    }
    
    if(srcSize == 0 || srcSize > 0x40000)
    {
        return Error( ErrorCat::System, static_cast<ErrorEntry>(
                      ErrorEntrySystem::InvalidArgument
                          ) );
    }
    
    // We have four possible magnitudes of copying that can happen in this
    // endeavour, and we’ve assigned these magnitudes to the data by name.
    // There are:
    //   - Quadwords (32 bytes)
    //   - Words (4 bytes)
    //   - Halfwords (2 bytes)
    //   - Bytes
    // Quadwords are copied using the CpuFastSet BIOS function, words are
    // copied using the CpuSet BIOS function, and halfwords/bytes are copied
    // by the CPU manually.
    
    // Let’s calculate the sizes we need for the different copying phases
    const u32 qwordCt = (srcSize >> 5) << 5;
    const u32 wordCt  = ((srcSize >> 2) << 2) - (qwordCt << 3);
    const u32 hwordCt = ((srcSize >> 1) << 1) - (wordCt << 1);
    const u32 byteCt  = srcSize - (hwordCt << 1);
    
    // Phase 1:
    // Copy over all quadwords
    {
        // Divide qwordCt by 8 to get same count in words
        // No mode sentinel needed for copy operation
        const u32 mode = qwordCt >> 3;
        
        for(u32 i = 0; i < qwordCt; ++i)
        {
            _sat__bios_cpu_fast_set( src, dst, mode );
            
            src = reinterpret_cast<void*>(reinterpret_cast<ptri>(src) + 32);
            dst = reinterpret_cast<void*>(reinterpret_cast<ptri>(dst) + 32);
        }
    }
    
    // Phase 2:
    // Copy over all leftover words
    {
        // Word count can be passed as-is, we’re using 32-bit mode
        // Set bit 26 to signal that we want 32-bit mode
        const u32 mode = wordCt | 0x4000000;
        
        for(u32 i = 0; i < wordCt; ++i)
        {
            _sat__bios_cpu_set( src, dst, mode );
            
            src = reinterpret_cast<void*>(reinterpret_cast<ptri>(src) + 4);
            dst = reinterpret_cast<void*>(reinterpret_cast<ptri>(dst) + 4);
        }
    }
    
    // Phase 3:
    // Copy over all leftover halfwords
    for(u32 i = 0; i < hwordCt; ++i)
    {
        *reinterpret_cast<u16*>(dst) = *reinterpret_cast<u16*>(src);
        
        src = reinterpret_cast<void*>(reinterpret_cast<ptri>(src) + 2);
        dst = reinterpret_cast<void*>(reinterpret_cast<ptri>(dst) + 2);
    }
    
    // Phase 4:
    // Copy over all leftover bytes
    for(u32 i = 0; i < byteCt; ++i)
    {
        *reinterpret_cast<u8*>(dst) = *reinterpret_cast<u8*>(src);
        
        src = reinterpret_cast<void*>(reinterpret_cast<ptri>(src) + 1);
        dst = reinterpret_cast<void*>(reinterpret_cast<ptri>(dst) + 1);
    }
    
    return Error( );
}



saturn::Error saturn::himem::alloc( u32 size, void*& ret, bool clear )
{
    if(size == 0 || size > kHeapSize)
    {
        return Error( ErrorCat::System, static_cast<ErrorEntry>(
                          ErrorEntrySystem::InvalidArgument) );
    }
    
    // Calculate number of chunks needed
    // Usually we’ll want to round up to the nearest chunk after doing
    // floored division, so we get enough space
    bool roundUp = true;
    
    // See if the size is on a chunk boundary
    if((size >> kChunkSizeB) << kChunkSizeB == size)
    {
        // Yes, so don’t round up
        roundUp = false;
    }
    
    // Actually get the number of chunks
    const u32 chunkCount = (size >> kChunkSizeB) << (kChunkSizeB +
                                                     (roundUp ? 1 : 0));
    
    // Search for sufficient space in memory to allocate
    void* addr = nullptr;
    
    {
        auto err = getAddress( chunkCount, addr );
        if(err)
        {
            return err;
        }
    }
    
    // Shuffle through the allocation dictionary for a free slot
    u32  slot  = 0;
    bool found = false;
    
    while(slot < kMaxAllocs && blocks[slot] != nullptr)
    {
        ++slot;
    }
    
    if(slot >= kMaxAllocs)
    {
        saturn::fatal( FatalErr::HeapOverflow );
        // Never returns, only here to satisfy the compiler
        return Error( );
    }
    
    // Note the allocation
    blocks[slot]           = addr;
    blockChunkCounts[slot] = chunkCount;
    
    // If requested, clear the allocated memory
    if(clear)
    {
        const inflSize = chunkCount << kChunkSizeB;
        
        saturn::lomem::fill( 0, inflSize, addr );
    }
    
    // Hand the memory back to the caller
    ret = addr;
    
    return Error( ); // Success!
}



saturn::Error saturn::himem::dealloc( void* ptr )
{
    return Error( );
}
