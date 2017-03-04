#!/usr/bin/env node
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

'use strict'

const chproc = require('child_process')
const endl   = require('os').EOL
const fs     = require('fs')
const path   = require('path')

const colour = require('../colour')

const cfg = require('../config')

const getIndexes = (string) => {
    const groups = string.split(',')
    let   ret    = []
    for(let i = 0; i < groups.length; i++) {
        if(groups[i].match(/^[^\-]\-[^\-]$/)) {
            const parts = groups[i].split('-')
            const start = parseInt(parts[0], 0)
            const end   = parseInt(parts[1], 0)
            for(let i2 = start; i2 < end; i2++) {
                ret.push(i2)
            }
        } else if(groups[i].match(/[^\-]/g)) {
            ret.push(parseInt(groups[i], 0))
        } else {
            console.error('Malformed syntax for colour indexes: ' + groups)
            return []
        }
    }
    return ret
};

const getValue = (string) => {
    const valueArrToGBA = (str, strValues) => {
        const r = parseInt(strValues[0], 0)
        const g = parseInt(strValues[1], 0)
        const b = parseInt(strValues[2], 0)
        if(str.startsWith('gba')) {
            var maxVal = 0x1F
        } else {
            var maxVal = 0xFF
        }
        if(r > maxVal || g > maxVal || b > maxVal) {
            console.error('Invalid colour: ' + str)
            return 0x0000
        }
        if(str.startsWith('gba')) {
            return r | (g << 5) | (b << 10)
        } else {
            return (r >> 3) | ((g >> 3) << 5) | ((b >> 3) << 10)
        }
    };
    if(string.match(/^(gba|rgb)\(((0(x[0-9A-Fa-f]+|o[[0-7]+]|b[[01]+))|[0-9]+),((0(x[0-9A-Fa-f]+|o[[0-7]+]|b[[01]+))|[0-9]+),((0(x[0-9A-Fa-f]+|o[[0-7]+]|b[[01]+))|[0-9]+)\)$/)) {
        const strValues = string.replace(/^(gba|rgb)\(/, '').replace(/\)$/,
            '').split(',')
        return valueArrToGBA(string, strValues)
    } else if(string.match(/^\$[0-7][0-9A-Fa-f]{3}$/)) {
        return parseInt(string.replace('$', ''), 16)
    } else if(string.match(/^\$\$[0-9A-Fa-f]{6}$/)) {
        const str = string.replace('$$', '')
        const r   = '0x' + str.replace(/....$/, '')
        const g   = '0x' + str.replace(/..$/, '').replace(/^../, '')
        const b   = '0x' + str.replace(/^..../, '')
        return valueArrToGBA('rgb', [r, g, b])
    } else {
        console.error('Invalid colour: ' + string)
        return 0x0000
    }
};

module.exports = (file) => {
    console.log('Converting'.red + '      ' + file.grey + '...')
    const lines = fs.readFileSync(file, 'utf8').replace('\r', '').split('\n')
    let   out   = []
    // Parse the input file and save it as a list of colour values
    for(let i = 0; i < lines.length; i++) {
        const lnum = i + 1
        const line = lines[i].replace(/#.*$/, '').replace(/\s+/g, '')
        if(line.match(/^\s*$/)) {
            continue
        }
        if(!line.match(/^[^=]+=[^=]+$/)) {
            console.error('Malformed syntax on line ' + lnum.toString() + '!')
            return
        }
        const pair    = line.split('=')
        const indexes = getIndexes(pair[0])
        const value   = getValue(pair[1])
        if(value > 32767) {
            console.error('Invalid colour on line ' + lnum.toString() + '!')
            return
        }
        for(let i2 = 0; i2 < indexes.length; i2++) {
            out[indexes[i2]] = value
        }
    }
    // Convert the saved values to assembly text
    let sym = file.replace(/.*\//g, '').replace(/[^\w_]/g, '_').replace(
        '_npal', '') + 'Pal'
    let asm = '.file "' + file + '"' + endl + '.ident "AS: (devkitARM release'
        + '46) 2.27"' + endl + endl + '.section .rodata' + endl + '.balign 4,'
        + ' 0xFF' + endl + '.globl ' + sym + endl + sym + ':' + endl + '    '
        + endl
    for(let i = 0; i < out.length; i++) {
        if(out[i] == undefined) {
            continue
        }
        asm += '    .hword ' + out[i].toString() + endl
    }
    const asmFile = path.join(cfg.buildDir, 'data', 'npal',
        file.replace(/.*\//g, '')).replace(/\.npal$/, '.s')
    fs.writeFileSync(asmFile, asm, 'utf8')
    try {
        const opts = cfg.sFlags.concat(['-o', asmFile.replace(/\.s$/, '.o'),
            asmFile])
        chproc.execFileSync(cfg.toolchain.assembler, opts, {
            cwd: process.cwd(),
            encoding: 'utf8'
        })
    } catch(err) {
        console.error('The assembler returned a nonzero exit code!'.red.bold)
        console.error(err.message)
    }
};
