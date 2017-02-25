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

const os   = require('os')
const path = require('path')

const userconf = require('./userconf')
const uuid     = require('./uuid')
const walk     = require('./walk')

var exports = module.exports = {}

exports.metadata  = {}
exports.toolchain = {}

const tcPrefix = path.join(process.env.DEVKITARM, 'bin', 'arm-none-eabi-')

exports.metadata.title    = userconf.title
exports.metadata.filename = exports.metadata.title.replace(/\s+/g,
    '').toLowerCase()
exports.metadata.romCode  = 'C' + userconf.code + userconf.lang.toUpperCase()
exports.metadata.romMaker = '8J'

exports.debug = userconf.debug

exports.toolchain.assembler   = tcPrefix + 'as'
exports.toolchain.cCompiler   = tcPrefix + 'gcc'
exports.toolchain.cxxCompiler = tcPrefix + 'g++'
exports.toolchain.linker      = tcPrefix + 'ld'
exports.toolchain.archiver    = tcPrefix + 'ar'
exports.toolchain.objcopier   = tcPrefix + 'objcopy'
exports.toolchain.grit        = path.join(process.env.DEVKITARM, 'bin', 'grit')
exports.toolchain.gbafix      = path.join(process.env.DEVKITARM, 'bin',
    'gbafix')

exports.sysIncludes = []
exports.locIncludes = []
exports.libDirs     = []
exports.libs        = []

const _sysInc = userconf.includes.system
for(let i = 0; i < _sysInc.length; i++) {
    exports.sysIncludes = exports.sysIncludes.concat(['-isystem', _sysInc[i]])
}

const _locInc = userconf.includes.local
for(let i = 0; i < _locInc.length; i++) {
    exports.locIncludes = exports.locIncludes.concat(['-iquote', _locInc[i]])
}

const _libDirs = userconf.libraries.dirs
for(let i = 0; i < _libDirs.length; i++) {
    exports.libDirs = exports.libDirs.concat(['-L' + _libDirs[i]])
}

const _libs = userconf.libraries.files
for(let i = 0; i < _libs.length; i++) {
    exports.libs = exports.libs.concat(['-l' + _libs[i]])
}

const commonFlags = ['-mcpu=arm7tdmi', '-march=armv4t', '-mthumb',
    '-mthumb-interwork']
const cdbgFlags   = ['-O0', '-g', '-Wall', '-Wextra']
const crelFlags   = ['-O2']
const clikeFlags  = commonFlags.concat(['-c','-fPIC', '-fno-common',
    '-nodefaultlibs', '-nostdlib'], exports.sysIncludes, exports.locIncludes)

exports.sFlags = commonFlags.concat(['-acd', '-mlittle-endian', '-EL',
    '--fix-v4bx', '-meabi=5', '-mapcs-32'])

if(!!exports.debug) {
    exports.cFlags   = clikeFlags.concat(['-std=c11'], cdbgFlags)
    exports.cxxFlags = clikeFlags.concat(['-nostdinc++', '-std=c++14',
        '-fno-exceptions'], cdbgFlags)
} else {
    exports.cFlags   = clikeFlags.concat(['-std=c11'], crelFlags)
    exports.cxxFlags = clikeFlags.concat(['-nostdinc++', '-std=c++14',
        '-fno-exceptions'], crelFlags)
}

exports.library = userconf.library

if(!exports.library) {
    exports.arFlags = []
    exports.ldFlags = ['-T', 'util/gba.ld', '-nostdlib', '--whole-archive']
} else {
    exports.arFlags = ['-rucs', '--target=elf32-littlearm']
    exports.ldFlags = []
}

exports.ocpyFlags = ['-O', 'binary', exports.filename + '.elf',
    exports.filename + '.gba']
exports.fixFlags  = [exports.filename + '.gba', '-p',
    '-t' + exports.metadata.title, '-c' + exports.metadata.romCode,
    '-m' + exports.metadata.romMaker, '-v0']
exports.gritFlags = ['-m', '-fh!', '-gT70C8A8']

exports.buildDir = path.join(os.tmpdir(), 'saturn-buildtool')

exports.sources = []

for(let i = 0; i < userconf.srcDirs.length; i++) {
    exports.sources = exports.sources.concat(walk(userconf.srcDirs[i],
        /\.(asm|c|cc|cpp|cxx|c\+\+|s)$/))
}

exports.resource = {}

exports.resource.image = {
    tiled:  {
        unc: {
            '1bpp': [],
            '2bpp': [],
            '4bpp': [],
            '8bpp': []
        },
        lz77: {
            '1bpp': [],
            '2bpp': [],
            '4bpp': [],
            '8bpp': []
        },
        huff: {
            '1bpp': [],
            '2bpp': [],
            '4bpp': [],
            '8bpp': []
        },
        rle: {
            '1bpp': [],
            '2bpp': [],
            '4bpp': [],
            '8bpp': []
        }
    },
    bitmap: {
        unc: {
            '1bpp':  [],
            '2bpp':  [],
            '4bpp':  [],
            '8bpp':  [],
            '16bpp': []
        },
        lz77: {
            '1bpp':  [],
            '2bpp':  [],
            '4bpp':  [],
            '8bpp':  [],
            '16bpp': []
        },
        huff: {
            '1bpp':  [],
            '2bpp':  [],
            '4bpp':  [],
            '8bpp':  [],
            '16bpp': []
        },
        rle: {
            '1bpp':  [],
            '2bpp':  [],
            '4bpp':  [],
            '8bpp':  [],
            '16bpp': []
        }
    }
}

const imgDirs = userconf.resource.imageDirs

// Tiled or bitmap?
for(let key in imgDirs) {
    if(!imgDirs.hasOwnProperty(key)) {
        continue
    }
    // What compression?
    for(let key2 in imgDirs[key]) {
        if(!imgDirs[key].hasOwnProperty(key2)) {
            continue
        }
        // What colour depth?
        for(let key3 in imgDirs[key][key2]) {
            if(!imgDirs[key][key2].hasOwnProperty(key3)) {
                continue
            }
            const dirs = imgDirs[key][key2][key3]
            // Traverse the directory list
            for(let i = 0; i < dirs.length; i++) {
                exports.resource.image[key][key2][key3] =
                exports.resource.image[key][key2][key3].concat(walk(dirs[i],
                    // Not a perfect match, but should weed out most images
                    // that aren’t meant to be compiled
                    /(\.(16?|2|4|8)bpp)?(\.(lz|huf|rle))?\.(tn?|bn?)\.png$/))
            }
        }
    }
}
