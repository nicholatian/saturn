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

//#include "memory.hh"



/** ============================ F U N C T I O N ============================ *
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


void saturn::lomem::copy( void* src, u32 srcSize, void* dst )
{
    // These are all used verbatim by the copy loops
    
    // sblockCount = srcSize / 32
    const u32 sblockCount = srcSize >> 5;
    // blockCount = (srcSize / 8) - (sblockCount * 4)
    const u32 blockCount  = (srcSize >> 3) - (sblockCount << 2);
    // wordCount = (srcSize / 4) - (sblockCount * 8) - (blockCount * 2)
    const u32 wordCount   = (srcSize >> 2) - (sblockCount << 3) -
        (blockCount << 1);
    // dwordCount = (srcSize / 2) - (sblockCount * 16) - (blockCount * 4) *
    //              (wordCount * 2)
    const u32 dwordCount  = (srcSize >> 1) - (sblockCount << 4) -
        (blockCount << 2) - (wordCount << 1);
    // dwordCount = srcSize - (sblockCount * 32) - (blockCount * 8) *
    //              (wordCount * 4) - (dwordCount * 2)
    const u32 byteCount   = srcSize - (sblockCount << 5) - (blockCount << 3) -
        (wordCount << 2) - (dwordCount << 1);
    
    // number of bytes to copy, sblocks only
    const u32 sblockBytes = sblockCount << 5;
    
    for(u32 i = 0; i < sblockCount; ++i)
    {
        _sat__cpu_fast_set( src, dst, sBlockBytes );
    }
    
    // repositioned source address
    const void* src2       = (void*)(((u32)src) + sblockBytes);
    // same for dest
    const void* dst2       = (void*)(((u32)dst) + sblockBytes);
    // number of bytes to copy, blocks only
    const u32   blockBytes = blockCount << 3;
    
    for(u32 i = 0; i < blockCount; ++i)
    {
        _sat__cpu_set( source, dest, blockBytes );
    }
    
    
}
*/
