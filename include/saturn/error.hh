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

#ifndef INC__LIBSATURN_ERROR_HH
#define INC__LIBSATURN_ERROR_HH



namespace saturn
{
    enum class ErrorCat : saturn::u32
    {
        Success = 0,
        Unknown,
        System,
        Video,
        Audio,
        IO,
        Network,
        Emu
    };
    
    using ErrorEntry = saturn::u32;
    
    enum class ErrorEntrySystem : saturn::u32
    {
        Success = 0,
        Unknown,
        LogicError,
        InvalidArgument,
        DomainError,
        LengthError,
        OutOfRange,
        RuntimeError,
        RangeError,
        OverflowError,
        UnderflowError
    };
    
    enum class ErrorEntryVideo : saturn::u32
    {
        Success = 0,
        Unknown,
        VramExhausted,
        OamExhausted
    };
    
    enum class ErrorEntryAudio : saturn::u32
    {
        
    };
    
    enum class ErrorEntryIO : saturn::u32
    {
        
    };
    
    enum class ErrorEntryNetwork : saturn::u32
    {
        
    };
    
    enum class ErrorEntryEmu : saturn::u32
    {
        
    };
    
    enum class ErrorEntryUnknown : saturn::u32
    {
        
    };
    
    class Error
    {
    public:
        Error( )
            : raw(0x0)
            { }
        Error( ErrorCat category, ErrorEntry entry )
            : raw((static_cast<saturn::u32>(category) & 0xFFF)
                  | (static_cast<saturn::u32>(entry) & 0xFFFFF))
            { }
        ~Error( ) { }
        
        bool operator!( )
        {
            return raw == 0;
        }
        
        saturn::u32 operator~( )
        {
            return raw;
        }
        
        bool operator==( Error err )
        {
            return raw == err.raw;
        }
        
        bool operator!=( Error err )
        {
            return raw != err.raw;
        }
        
    private:
        const saturn::u32 raw;
    };
}



#endif // INC__LIBSATURN_ERROR_HH
