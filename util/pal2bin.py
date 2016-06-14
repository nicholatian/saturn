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
from sys import argv, exit
from os import linesep
def getIndexes(string):
    rawindexes = string.split(',')
    expindexes = []
    for substr in rawindexes:
        if '-' in substr:
            rangepair = substr.split('-')
            if len(rangepair) != 2:
                raise Exception('Invalid range format; one dash please')
            start = int(rangepair[0], 0)
            end   = int(rangepair[1], 0)
            while(start < end):
                expindexes += [start]
                start += 1
            expindexes += [end]
        else:
            expindexes += [int(substr, 0)]
    return expindexes
def getHalfword(red, green, blue, is24):
    if red > 255 or green > 255 or blue > 255:
        raise Exception('Value provided to function too large')
    if is24:
        return ((blue >> 3) << 10) | ((green >> 3) << 5) | (red >> 3)
    else:
        return (blue << 10) | (green << 5) | red
def funcToHalfword(string, is24):
    values = string.replace(' ', '')[4:][:-1].split(',')
    if len(values) != 3:
        raise Exception('Wrong number of values provided to function:' + string)
    red   = int(values[0], 0)
    green = int(values[1], 0)
    blue  = int(values[2], 0)
    return getHalfword(red, green, blue, is24)
def hexToHalfword(string):
    from re import findall
    is24 = False
    if string.startswith('$$'):
        is24 = True
    elif not string.startswith('$'):
        raise Exception('Must provide symbolic length to hex parser, use $')
    string = string.replace('$', '')
    strlen = len(string)
    if not is24:
        # it’s simple, just return it
        return int(string, 16)
    elif strlen != 6:
        # we need the zeroes for proper splitting, since they’re assumed
        if strlen > 6:
            raise Exception('Too many digits found in hex literal')
        else:
            while strlen < 6:
                string  = '0' + string
                strlen += 1
    values = findall('..', string)
    # the count should be 3, we already checked before the split
    red   = int(values[0], 16)
    green = int(values[1], 16)
    blue  = int(values[2], 16)
    return getHalfword(red, green, blue, True)
def bytesToHalfword(string):
    values = string.replace(' ', '').split(',')
    if len(values) != 2:
        raise Exception('Must provide exactly two values as byte array')
    hi = int(values[0], 0)
    lo = int(values[1], 0)
    if hi > 255 or lo > 255:
        raise Exception('A byte provided was too large to fit')
    return (lo << 8) | hi
def main():
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
    palfile  = open(argv[1], 'r').read().split(linesep)
    indexArr = []
    values   = []
    for lnum, line in enumerate(palfile):
        if line == '':
            continue
        # Remove comments, anywhere they appear
        newline = ''
        for char in line:
            if char == '#':
                break
            else:
                newline += char
        if '=' not in newline:
            # not dealing with a pair, check it
            for char in newline:
                # only whitespace is permitted outside comments and pairs
                if char != ' ' and char != '\t':
                    raise Exception('Malformed syntax on line ' + str(lnum + 1))
            # don’t try to parse this, there’s nothing here
            continue
        pair = newline.split('=', 1)
        # Remove surrounding whitespace
        pair[0] = pair[0].replace(' ', '')
        pair[1] = pair[1].replace(' ', '')
        if pair[0] == '' or pair[1] == '':
            # either the key name or value (or both) are empty
            raise Exception('Bad key/value pair on line ' + str(lnum + 1))
        indexArr += [getIndexes(pair[0])]
        strval = pair[1]
        if strval.startswith('rgb'):
            values += [funcToHalfword(strval, True)]
        elif strval.startswith('gba'):
            values += [funcToHalfword(strval, False)]
        elif strval.startswith('$'):
            values += [hexToHalfword(strval)]
        elif ',' in strval:
            values += [bytesToHalfword(strval)]
        else:
            values += [int(strval, 0)]
        if values[-1] > 32767:
            # not a valid 15-bit colour
            raise Exception('Last value too high to be a 15-bit colour')
    maxnum = 0
    for indexes in indexArr:
        indexes.sort()
        highest = indexes[-1]
        if highest > maxnum:
            maxnum = highest
    output = bytearray(b'\x00\x00') * (maxnum + 1)
    for i, indexes in enumerate(indexArr):
        bytestrs          = [values[i] >> i2 & 0xFF for i2 in (8, 0)]
        for index in indexes:
            output[i * 2]     = bytestrs[1] # lo byte
            output[i * 2 + 1] = bytestrs[0] # hi byte
    open(argv[2], 'wb').write(output)

if __name__ == '__main__':
    main()
