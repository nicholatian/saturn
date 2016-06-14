#!/usr/bin/env python3
# -*- coding: UTF-8 -*-
###############################################################################
##                                                                           ##
##  _/_/_/_/_/  _/_/_/    _/_/_/  _/      _/  _/_/_/  _/_/_/_/_/  _/      _/ ##
##     _/      _/    _/    _/    _/_/    _/    _/        _/        _/  _/    ##
##    _/      _/_/_/      _/    _/  _/  _/    _/        _/          _/       ##
##   _/      _/    _/    _/    _/    _/_/    _/        _/          _/        ##
##  _/      _/    _/  _/_/_/  _/      _/  _/_/_/      _/          _/         ##
##                                                                           ##
##                                  Trinity                                  ##
##                           OFFICIAL  Source Code                           ##
##                                                                           ##
##                  Copyright © 2014-2016 Alexander Nicholi                  ##
##                           All rights  reserved.                           ##
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
