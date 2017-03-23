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

#ifndef INC__LIBSATURN_FATAL_HH
#define INC__LIBSATURN_FATAL_HH

#include "gba/types.hh"



extern saturn::u16 colourErrorPal;



namespace saturn
{
    enum class FatalErr
    {
        Success       = 0x0, // Success, yay!
        LogicError    = 0x1, // Logical program failure
        LengthError   = 0x2, // Bad length (declaration)
        Unassigned3   = 0x3,
        RangeError    = 0x4, // Bad length (operation)
        Unassigned5   = 0x5,
        Underflow     = 0x6, // Floating point madness
        Unassigned7   = 0x7,
        Overflow      = 0x8, // Signed integer madness
        HardwareFault = 0x9, // Something bad happened outside software
        StackOverflow = 0xA, // Lower limit of the stack reached
        BoundsError   = 0xB, // Accessing memory regions that don’t exist
        NullReference = 0xC, // Dereferencing would lead to BIOS
        HeapOverflow  = 0xD, // All EWRAM is exhausted
        UnassignedE   = 0xE,
        UnknownError  = 0xF  // For when none of the others make sense
    };
    
    void fatal( FatalErr err );
}



#endif // INC__LIBSATURN_FATAL_HH
