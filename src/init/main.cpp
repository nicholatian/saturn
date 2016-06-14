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
 *                                  Saturn                                   * 
 *  A low-level, general purpose application framework for the Nintendo GBA  * 
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

#include <gba/biosfunc.hpp>
#include <gba/memory.hpp>
#include <gba/display.hpp>
#include "init/main.hpp"
#include "misc/error.hpp"



/** ============================ F U N C T I O N ============================ *
 * 
 * TITLE:       Application entry point
 * DESCRIPTION: Declares the mainloop singleton, and begins its execution.
 * RETURNS:     Always 0.
 */

int main( )
{
    saturn::MainloopT mainloop;
    
    mainloop.begin( );
    
    return 0;
}



/** ============================ F U N C T I O N ============================ *
 * 
 * TITLE:       Mainloop singleton constructor
 * DESCRIPTION: Initialises object variables for use by the mainloop.
 */

saturn::MainloopT::MainloopT( )
{
    this->status   = ErrorT::Success;
    this->firstRun = true;
}



/** ============================ F U N C T I O N ============================ *
 * 
 * TITLE:       Mainloop singleton destructor
 * DESCRIPTION: Currently an empty stub.
 */

saturn::MainloopT::~MainloopT( )
{
    
}



/** ============================ F U N C T I O N ============================ *
 * 
 * TITLE:       The main loop executive
 * DESCRIPTION: Contains all of the code required to run the main loop.
 *              NOTE: This function will not return.
 */

void saturn::MainloopT::begin( )
{
    try
    {
        for(;;)
        {
            if(this->firstRun)
            {
                this->errSplash( saturn::ErrorT::BoundsError );
                
                this->firstRun = false;
                
                continue;
            }
            
            // Add the usual calls here, later
        }
    }
    catch(saturn::ErrorT err)
    {
        this->errSplash( err );
        
        bios_halt( );
    }
    catch(...)
    {
        bios_halt( );
    }
}



/** ============================ F U N C T I O N ============================ *
 * 
 * TITLE:       Error splash screen loader
 * DESCRIPTION: Fills the screen with a particular colour based on an error
 *              code given, numbered 1 through 15 in the enum `saturn:ErrorT`.
 * PARAMETER:   The error status given. This corresponds to the colour that the
 *              screen will be filled with, so take note.
 */

void saturn::MainloopT::errSplash( saturn::ErrorT err )
{
    u16 level = (u16)err;
    
    u16 vramFill = level | (level << 8u);
    
    for(u32 i = 0u; i < 0x9B00u; i += 1u)
    {
        ((u16*)MEM_VRAM)[i] = vramFill;
    }
    
    for(u32 i = 0u; i < 0x10u; i += 1u)
    {
        MEM_PAL[i] = (&colourErrorPal)[i];
    }
    
    REG_DISPCNT = REG_DISPCNT_BGMODE4 | REG_DISPCNT_BG2_ON;
}
