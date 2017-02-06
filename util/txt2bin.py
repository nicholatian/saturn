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
##     A general-purpose game engine for the Nintendo® Game Boy Advance™     ##
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
from sys import argv, exit
from os import path
def main():
    table = { ' ': 0x00, '\\e': 0x1B, 'é': 0x1B, '[d]': 0x2A, '&': 0x2D,
    '+': 0x2E, '[Lv]': 0x34, '=': 0x35, ';': 0x36, '[PK]': 0x53, '[MN]': 0x54,
    '[PO]': 0x55, '[KE]': 0x56, '[BL]': 0x56, '[OC]': 0x57, '[K]': 0x58,
    '%': 0x5B, '(': 0x5C, ')': 0x5D, '[U]': 0x79, '[D]': 0x7A, '[L]': 0x7B,
    '[R]': 0x7C, '0': 0xA1, '1': 0xA2, '2': 0xA3, '3': 0xA4, '4': 0xA5,
    '5': 0xA6, '6': 0xA7, '7': 0xA8, '8': 0xA9, '9': 0xAA, '!': 0xAB,
    '?': 0xAC, '.': 0xAD, '-': 0xAE, '[.]': 0xB0, '…': 0xB0, '“': 0xB1,
    '"': 0xB1, '”': 0xB2, '["]': 0xB2, '‘': 0xB3, '’': 0xB4, '[\']': 0xB3,
    '\'': 0xB4, '[m]': 0xB5, '[f]': 0xB6, '$': 0xB7, ',': 0xB8, '[x]': 0xB9,
    '/': 0xBA, 'A': 0xBB, 'B': 0xBC, 'C': 0xBD, 'D': 0xBE, 'E': 0xBF,
    'F': 0xC0, 'G': 0xC1, 'H': 0xC2, 'I': 0xC3, 'J': 0xC4, 'K': 0xC5,
    'L': 0xC6, 'M': 0xC7, 'N': 0xC8, 'O': 0xC9, 'P': 0xCA, 'Q': 0xCB,
    'R': 0xCC, 'S': 0xCD, 'T': 0xCE, 'U': 0xCF, 'V': 0xD0, 'W': 0xD1,
    'X': 0xD2, 'Y': 0xD3, 'Z': 0xD4, 'a': 0xD5, 'b': 0xD6, 'c': 0xD7,
    'd': 0xD8, 'e': 0xD9, 'f': 0xDA, 'g': 0xDB, 'h': 0xDC, 'i': 0xDD,
    'j': 0xDE, 'k': 0xDF, 'l': 0xE0, 'm': 0xE1, 'n': 0xE2, 'o': 0xE3,
    'p': 0xE4, 'q': 0xE5, 'r': 0xE6, 's': 0xE7, 't': 0xE8, 'u': 0xE9,
    'v': 0xEA, 'w': 0xEB, 'x': 0xEC, 'y': 0xED, 'z': 0xEE, ':': 0xF0,
    '\\l': 0xFA, '\\p': 0xFB, '\\c': 0xFC, '\\v': 0xFD, '\\n': 0xFE,
    '\\0': 0xFF, '\\x': 0xFF }
    i = 2
    if '-h' in argv or '--help' in argv:
        print('Usage:')
        print('    ')
        print('  $ poketext.py <input> <output>')
        print('    Takes input files and prints out their GNU ASM equivalents.')
        print('  $ poketext.py -h')
        print('    Prints this message and exits.')
        print('')
        exit(0)
    elif len(argv) == 1:
        raise Exception('No input file provided')
    elif len(argv) == 2:
        raise Exception('No output file provided')
    elif len(argv) > 3:
        raise Exception('Too many files provided')
    ourstring  = open(argv[1], 'r').read()
    inbrace    = False
    ctrlchar   = False
    hexcount   = 0
    bracebuf   = ''
    pokebuf    = []
    hexbuf     = ''
    # first strip all newlines out
    linestring = ourstring.replace('\r', '').replace('\n', '')
    # parse all of the characters from the input string
    for char in linestring:
        if hexcount >= 2:
            hexbuf   += char
            pokebuf += [int(hexbuf, 16)]
            hexbuf   = ''
            hexcount = 0
            ctrlchar = False
        elif hexcount > 0:
            hexbuf   += char
            hexcount += 1
        elif char == '[':
            if inbrace:
                raise Exception('Multi bracing is invalid in Pokétext')
            bracebuf += char
            inbrace = True
        elif char == ']':
            if not inbrace:
                raise Exception('Lone closing brace found')
            bracebuf += char
            inbrace = False
            thischar = table[bracebuf]
            bracebuf = ''
            pokebuf += [thischar]
        elif char == '\\':
            if ctrlchar:
                raise Exception('Backslash is not valid on its own')
            ctrlchar = True
        elif inbrace:
            bracebuf += char
        elif ctrlchar:
            if char == 'h':
                hexcount = 1
            else:
                thischar = table['\\' + char]
                pokebuf += [thischar]
                ctrlchar = False
        else:
            thischar = table[char]
            pokebuf += [thischar]
    # Add string terminator
    pokebuf += [0xFF]
    open(argv[2], 'wb').write(bytes(pokebuf))

if __name__ == '__main__':
    main()
