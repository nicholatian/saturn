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
const os     = require('os')
const path   = require('path')

const cfg = require('./config')

var exports = module.exports = {}

let usedWorkers = 0
let startCount  = 0
let doneCount   = 0
let exitCount   = 0
let failCount   = 0

const cpuCount   = os.cpus().length
let   workers    = []
let   nextWorker = 0

exports.cleanupWorkers = () => {
    for(let i = 0; i < workers.length; i++) {
        workers[i].send({ die: true })
    }
};

exports.allDone = () => {
    if(doneCount >= startCount) {
        return true
    }
    return false
};

exports.allExited = () => {
    if(exports.allDone() && exitCount >= usedWorkers) {
        return true
    }
    return false
};

exports.failed = () => {
    if(failCount > 0) {
        return true
    } else {
        return false
    }
};

const getWorker = () => {
    // Check if we’ve maxed out our CPU
    if(workers.length >= cpuCount) {
        // Reset the revolver if it’s too high
        if(nextWorker >= workers.length) {
            nextWorker = 0
        }
        // Return an existing worker
        return nextWorker++
    }
    // Spawn a new worker and return it, we don’t have enough
    workers[nextWorker] = chproc.fork(path.join(process.cwd(), 'util',
        'buildtool', 'worker.js'), [process.argv[2]], {
        cwd: process.cwd()
    })
    workers[nextWorker].on('message', (m) => {
        if(m.done === true) {
            doneCount++
        }
    })
    workers[nextWorker].on('exit', (code, signal) => {
        exitCount++
        if(code !== 0) {
            failCount++
        }
    })
    return nextWorker++
}

const queueExec = (opts) => {
    const id = getWorker()
    workers[id].on('exit', exports.allDone)
    workers[id].send(opts)
    startCount++
    if(usedWorkers < 4) {
        usedWorkers++
    }
};

exports.queueCode = (src) => {
    if(src.match(/\.c$/)) {
        var srcType = 'c'
    } else if(src.match(/\.(cc|cpp|cxx|c\+\+)$/)) {
        var srcType = 'cpp'
    } else if(src.match(/\.(asm|s)$/)) {
        var srcType = 'asm'
    } else {
        console.error('Error: Invalid source file placed in queue: ' + src)
        return
    }
    queueExec({ file: src, type: srcType, debug: cfg.debug })
};

exports.queuePalette = (src) => {
    if(!src.match(/\.npal$/)) {
        console.error('Error: Invalid source file placed in queue: ' + src)
        return
    }
    queueExec({ file: src, type: 'npal' })
};

exports.queueImage = (src) => {
    if(!src.match(/\.png$/)) {
        console.error('Cannot queue image that is not a PNG!')
        return
    }
    if(src.match(/\.1bpp\.[\.\w]+$/)) {
        var depth = 1
    } else if(src.match(/\.2bpp\.[\.\w]+$/)) {
        var depth = 2
    } else if(src.match(/\.4bpp\.[\.\w]+$/)) {
        var depth = 4
    } else if(src.match(/\.8bpp\.[\.\w]+$/)) {
        var depth = 8
    } else if(src.match(/\.bn?\.png$/)) { // Is it a bitmap?
        var depth = 16
    } else {
        console.error('Invalid bit depth specified in file name!')
        return
    }
    if(src.match(/\.lz\.[\.\w]+$/)) {
        var algo = 'lz77'
    } else if(src.match(/\.huf\.[\.\w]+$/)) {
        var algo = 'huff'
    } else if(src.match(/\.rle\.[\.\w]+$/)) {
        var algo = 'rle'
    } else {
        var algo = 'unc'
    }
    if(src.match(/\.t\.png$/)) {
        var tiled  = true
        var reduce = true
    } else if(src.match(/\.tn\.png$/)) {
        var tiled  = true
        var reduce = false
    } else if(src.match(/\.b\.png$/)) {
        var tiled  = false
        var reduce = true
    } else if(src.match(/\.bn\.png$/)) {
        var tiled  = false
        var reduce = false
    }
    queueExec({ file: src, type: 'image', depth: depth, tiled: tiled,
        algo: algo, reduce: reduce })
};
