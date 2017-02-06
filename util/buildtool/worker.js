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

const chproc = require('child_process')
const path   = require('path')

const cfg    = require('./config')
const colour = require('./colour')

const cc = (file, debug) => {
    try {
        console.log('Compiling'.cyan + '       ' + file.grey + '...')
        const options = cfg.cFlags.concat(['-o', path.join(cfg.buildDir,
            'code', file.replace(/\//g, '+')) + '.o', file])
        chproc.execFileSync(cfg.toolchain.cCompiler, options, {
            cwd: process.cwd(),
            encoding: 'utf8'
        })
    } catch(err) {
        console.error('The C compiler exited with a nonzero code!'.red.bold)
        console.error(err.message)
    }
};

const cxx = (file, debug) => {
    try {
        console.log('Compiling'.blue + '       ' + file.grey + '...')
        const options = cfg.cxxFlags.concat(['-o', path.join(cfg.buildDir,
            'code', file.replace(/\//g, '+')) + '.o', file])
        chproc.execFileSync(cfg.toolchain.cxxCompiler, options, {
            cwd: process.cwd(),
            encoding: 'utf8'
        })
    } catch(err) {
        console.error('The C++ compiler exited with a nonzero code!'.red.bold)
        console.error(err.message)
    }
};

const as = (file) => {
    try {
        console.log('Assembling'.green + '      ' + file.grey + '...')
        const options = cfg.sFlags.concat(['-o', path.join(cfg.buildDir,
            'code', file.replace(/\//g, '+')) + '.o', file])
        chproc.execFileSync(cfg.toolchain.assembler, options, {
            cwd: process.cwd(),
            encoding: 'utf8'
        })
    } catch(err) {
        console.error('The assembler exited with a nonzero code!'.red.bold)
        console.error(err.message)
    }
};

const grit = (file, depth, tiled, algo, reduce) => {
    let flags = []
    if(algo === 'lz77') {
        flags.push('-Zl')
    } else if(algo === 'huff') {
        flags.push('-Zh')
    } else if(algo === 'rle') {
        flags.push('-Zr')
    } else if(algo === 'unc') {
        flags.push('-Z!')
    } else {
        console.error('Invalid compression algorithm passed to grit!'.red.bold)
        return
    }
    if(depth !== 1 && depth !== 2 && depth !== 4 && depth !== 8 &&
    depth !== 16) {
        console.error('Invalid bit depth passed to grit!'.red.bold)
        return
    }
    flags.push('-gB' + depth.toString())
    if(depth === 16 || !tiled) {
        flags.push('-gb')
    } else {
        flags.push('-gt')
    }
    if(reduce) {
        flags.push('-mRtf')
    } else {
        flags.push('-mR!')
    }
    flags.push('-o' + path.join(cfg.buildDir, 'data', 'image',
        file.replace(/.*\//g, '')) + '.s')
    try {
        console.log('Transmogrifying'.yellow + ' ' + file.grey + '...')
        const options = cfg.gritFlags.concat(flags, [file.replace(/.*\//g,
            '')])
        chproc.execFileSync(cfg.toolchain.grit, options, {
            cwd: process.cwd(),
            encoding: 'utf8'
        })
        const opts2 = cfg.sFlags.concat(['-o', path.join(cfg.buildDir, 'data',
            'image', file.replace(/.*\//g, '')) + '.o', path.join(cfg.buildDir,
            'data', 'image', file.replace(/.*\//g, '')) + '.s'])
        chproc.execFileSync(cfg.toolchain.assembler, opts2, {
            cwd: process.cwd(),
            encoding: 'utf8'
        })
    } catch(err) {
        console.error('Grit returned a nonzero exit code!'.red.bold)
        console.error(err.message)
    }
};

process.on('message', (m) => {
    if(m.die === true) {
        process.exit(0)
    }
    if(m.type === 'c') {
        cc(m.file, m.debug)
        process.send({ done: true })
    } else if(m.type === 'cpp') {
        cxx(m.file, m.debug)
        process.send({ done: true })
    } else if(m.type === 'asm') {
        as(m.file)
        process.send({ done: true })
    } else if(m.type === 'image') {
        grit(m.file, m.depth, m.tiled, m.algo, m.reduce)
        process.send({ done: true })
    } else {
        console.error('Unsupported input for worker node!'.red.bold)
        process.exit(1)
    }
})
