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

const fs   = require('fs')
const os   = require('os')
const endl = os.EOL

const colour = require('./buildtool/colour')

let didClean = false

const rmrf = (path) => {
    var files = []
    if( fs.existsSync(path) ) {
        files = fs.readdirSync(path)
        files.forEach(function(file,index){
            var curPath = path + "/" + file
            if(fs.lstatSync(curPath).isDirectory()) { // recurse
                rmrf(curPath)
            } else { // delete file
                fs.unlinkSync(curPath)
            }
        })
        fs.rmdirSync(path)
    }
};

const clean = () => {
    console.log('Cleaning'.white + ' the build files'.grey + '...')
    const path = require('path')
    rmrf(path.join(os.tmpdir(), 'saturn-buildtool'))
    return 0
};

const main = (args) => {
    console.log('Saturn Build Tool'.bold.underline.white + endl)
    if(args.length < 3) {
        console.error('Too few arguments provided to buildtool. Exiting...')
        return -2
    } else if(args.length > 3) {
        console.error('Too many arguments provided to buildtool. Exiting...')
        return -3
    } else if(args[2] === '--clean') {
        didClean = true
        return clean()
    }
    const intrv = setInterval(() => {
        if(foreman.allDone()) {
            clearInterval(intrv)
            foreman.cleanupWorkers()
            return
        }
    }, 50)
    const path    = require('path')
    const cfg     = require('./buildtool/config')
    const foreman = require('./buildtool/foreman')
    const mkdirp  = require('./buildtool/mkdirp')
    mkdirp.sync(path.join(cfg.buildDir, 'code'), 0o755)
    mkdirp.sync(path.join(cfg.buildDir, 'data', 'image'), 0o755)
    mkdirp.sync(path.join(cfg.buildDir, 'data', 'text'), 0o755)
    mkdirp.sync(path.join(cfg.buildDir, 'data', 'npal'), 0o755)
    mkdirp.sync(path.join(cfg.buildDir, 'data', 'blob'), 0o755)
    for(let i = 0; i < cfg.sources.length; i++) {
        foreman.queueCode(cfg.sources[i])
    }
    const images = cfg.resource.image
    // Tiled or bitmap?
    for(let key in images) {
        if(!images.hasOwnProperty(key)) {
            continue
        }
        // What compression?
        for(let key2 in images[key]) {
            if(!images[key].hasOwnProperty(key2)) {
                continue
            }
            // What colour depth?
            for(let key3 in images[key][key2]) {
                if(!images[key][key2].hasOwnProperty(key3)) {
                    continue
                }
                const files = images[key][key2][key3]
                // Traverse the file list
                for(let i = 0; i < files.length; i++) {
                    foreman.queueImage(files[i])
                }
            }
        }
    }
    return 0
};

const finishup = () => {
    const path   = require('path')
    const chproc = require('child_process')
    const cfg    = require('./buildtool/config')
    const walk   = require('./buildtool/walk')
    console.log('Linking'.magenta + '         ' + cfg.metadata.filename.grey +
        ' binary'.grey + '...')
    if(!!cfg.library) {
        const options = cfg.arFlags.concat([path.join(process.cwd(),
            cfg.metadata.filename) + '.a'], walk( path.join(cfg.buildDir,
            'code'), /\.o$/), walk(path.join(cfg.buildDir, 'data'), /\.o$/))
        chproc.execFileSync(cfg.toolchain.archiver, options, {
            cwd: process.cwd(),
            encoding: 'utf8'
        })
    } else {
        console.log('Generating      ' + cfg.metadata.filename.grey +
            '.elf'.grey + '...')
        const options = cfg.ldFlags.concat([cfg.libDirs, '-o', path.join(process.cwd(),
            cfg.metadata.filename) + '.elf'], walk( path.join(cfg.buildDir,
            'code'), /\.o$/), walk(path.join(cfg.buildDir, 'data'), /\.o$/),
            cfg.libs)
        chproc.execFileSync(cfg.toolchain.linker, options, {
            cwd: process.cwd(),
            encoding: 'utf8'
        })
    }
    if(!cfg.library) {
        console.log('Generating      ' + cfg.metadata.filename.grey +
            '.gba'.grey + '...')
        chproc.execFileSync(cfg.toolchain.objcopier, cfg.ocpyFlags, {
            cwd: process.cwd(),
            encoding: 'utf8'
        })
        console.log('Fixing'.grey + '          ' + cfg.metadata.filename.grey +
            '.gba'.grey + '...')
        chproc.execFileSync(cfg.toolchain.gbafix, cfg.fixFlags, {
            cwd: process.cwd(),
            encoding: 'utf8'
        })
    }
};

if(require.main === module) {
    const code = main(process.argv)
    if(!!didClean) {
        process.exit(code)
    }
    const foreman = require('./buildtool/foreman')
    const intrv   = setInterval(() => {
        if(foreman.allExited()) {
            clearInterval(intrv)
            finishup()
            if(foreman.failed()) {
                console.log(endl + 'Compilation failed'.underline.red)
                process.exit(-1)
                return
            }
            console.log(endl + 'Compilation complete'.underline.green)
            process.exit(code)
            return
        }
    }, 50)
}
