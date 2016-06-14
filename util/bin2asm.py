#!/usr/bin/env python3
# -*- coding: UTF-8 -*-
###############################################################################
##                                                                           ##
##   .d8888b.          d8888 88888888888 888     888 8888888b.  888b    888  ##
##  d88P  Y88b        d88888     888     888     888 888   Y88b 8888b   888  ##
##  Y88b.            d88P888     888     888     888 888    888 88888b  888  ##
##   "Y888b.        d88P 888     888     888     888 888   d88P 888Y88b 888  ##
##      "Y88b.     d88P  888     888     888     888 8888888P"  888 Y88b888  ##
##        "888    d88P   888     888     888     888 888 T88b   888  Y88888  ##
##  Y88b  d88P   d8888888888     888     Y88b. .d88P 888  T88b  888   Y8888  ##
##   "Y8888P"   d88P     888     888      "Y88888P"  888   T88b 888    Y888  ##
##                                                                           ##
##                                  Saturn                                   ##
##  A low-level, general purpose application framework for the Nintendo GBA  ##
##                                                                           ##
##                       Copyright © 2016  Nicholatian                       ##
##                                                                           ##
##  Licensed under the Apache License, Version 2.0 (the “License”); you may  ##
## not use this file except in compliance with the License. You may obtain a ##
##                          copy of the  License at                          ##
##                                                                           ##
##                http://www.apache.org/licenses/LICENSE-2.0                 ##
##                                                                           ##
##    Unless required by applicable law or agreed to in writing, software    ##
## distributed under the License is distributed on an “AS IS” BASIS, WITHOUT ##
## WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the  ##
##  License for the specific language governing permissions and limitations  ##
##                            under the  License.                            ##
##                                                                           ##
###############################################################################
def run(command):
    import subprocess
    try:
        return subprocess.check_output(command).decode()
    except subprocess.CalledProcessError as e:
        print(e.output.decode(), file=stderr)
        exit(1)

def main():
    from sys import argv, exit
    i     = 1
    files = []
    argc  = len(argv)
    if argc == 1:
        raise Exception('No input files provided')
    elif argv[1] == '-h' or argv[1] == '--help':
        print('Usage:')
        print('    ')
        print('  $ binary.py <input> [...]')
        print('    Takes input files and prints out their GNU ASM equivalents.')
        print('  $ binary.py -h')
        print('    Prints this message and exits.')
        print('')
        exit(0)
    while(i < argc):
        files += [argv[i]]
        i += 1

    newstring = '\n'
    for infile in files:
        buf_ = open(infile, 'rb').read()
        ## Here’s some special logic for ensuring we get the desired effects
        ## during the sequence for the title screen. Could be modularized but eh
        buf = None
        if infile.endswith('titlescreen_pal.bin'):
            buf = b'\x00\x00' + buf_[2:]
        else:
            buf = buf_
        symname = run(['env', 'python3', 'util/namemod.py', '-a', infile])[:-1]
        # format the byte array as GNU assembly
        newstring += '.balign 4, 0\n\n'
        newstring += '.globl ' + symname + '\n'
        newstring += symname + ':\n    .byte '
        linecounter = 0
        for byte in buf:
            strbyte = hex(byte).upper()
            if byte < 0x10:
                strbyte = strbyte.replace('0X', '0X0')
            if linecounter == 11:
                newstring  += '\n    .byte ' + strbyte + ', '
                linecounter = 1
            else:
                newstring   += strbyte + ', '
                linecounter += 1
        newstring = newstring.replace('X', 'x').replace(', \n', '\n')[:-2] + '\n\n'
    print(newstring[:-2])

if __name__ == '__main__':
    main()
