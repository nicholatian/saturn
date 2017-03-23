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

#ifndef INC__LIBSATURN_MEMORY_HH
#define INC__LIBSATURN_MEMORY_HH

#include "gba/types.hh"
#include "error.hh"


namespace saturn
{
    namespace lomem
    {
        saturn::Error copy( void* src, saturn::ptri srcSize, void* dst );

        inline bool isWritable( void* ptr )
        {
            const saturn::ptri val = reinterpret_cast<saturn::ptri>(ptr);
            
            if((val >= 0x2000000 && val < 0x2040000)
               || (val >= 0x3000000 && val < 0x3008000)
               || (val >= 0x4000000 && val < 0x4000FFF) // not a typo
               || (val >= 0x5000000 && val < 0x5000400)
               || (val >= 0x6000000 && val < 0x6018000)
               || (val >= 0x7000000 && val < 0x7000400)
               || (val >= 0xE000000 && val < 0xE010000))
            {
                return true;
            }
            
            return false;
        }
        
        inline bool isReadable( void* ptr )
        {
            const saturn::ptri val = reinterpret_cast<saturn::ptri>(ptr);
            
            if(isWritable( ptr ) || (val >= 0x8000000 && val < 0x9000000))
            {
                return true;
            }
            
            return false;
        }
    }
    
    namespace himem
    {
        saturn::Error alloc( saturn::ptri size, void*& ptr,
                             bool clear = false );
        
        saturn::Error dealloc( void* ptr );
        
        saturn::Error realloc( void*& ptr, saturn::ptri size );
    }
}

#endif // INC__LIBSATURN_MEMORY_HH
