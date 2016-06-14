#!/usr/bin/env make
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

# Program settings
PROGRAM   := saturn
GAMETITLE := SATURN
GAMECODE  := CSTE
GAMEMAKER := 8J # “General Entertainment”

# General
CFILES   := $(shell find src/ -type f -name '*.c')
CXXFILES := $(shell find src/ -type f -name '*.cpp')
SFILES   := $(shell find src/ -type f -name '*.s')
INCDIRS  := -I$(DEVKITARM)/arm-none-eabi/include \
            -I$(DEVKITPRO)/libgba/include -I$(DEVKITPRO)/libnich/include
LIBDIRS  := -L$(DEVKITARM)/arm-none-eabi/lib/thumb -L$(DEVKITPRO)/libgba/lib \
            -L$(DEVKITARM)/lib/gcc/arm-none-eabi/5.3.0/thumb

# System utilities
AS   := arm-none-eabi-as
CC   := arm-none-eabi-gcc
CXX  := arm-none-eabi-g++
LD   := arm-none-eabi-ld
OCPY := arm-none-eabi-objcopy
GFX  := grit
FIX  := gbafix
PY   := /usr/bin/env python3

# Local utilities
BIN2ASM := $(PY) util/bin2asm.py
TXT2BIN := $(PY) util/txt2bin.py
PAL2BIN := $(PY) util/pal2bin.py
NAMEMOD := $(PY) util/namemod.py

SFLAGS   := -acd -mcpu=arm7tdmi -march=armv4t -mthumb -mthumb-interwork -I \
$(INCLUDEDIR) -mlittle-endian -EL --fix-v4bx -meabi=5 -mapcs-32
CXXFLAGS := -std=c++14 -fauto-inc-dec -fcompare-elim -fcprop-registers -fdce \
-fdefer-pop -fdelayed-branch -fdse -fguess-branch-probability \
-fif-conversion2 -fif-conversion -fipa-pure-const -fipa-profile \
-fipa-reference -fmerge-constants -fsplit-wide-types -ftree-bit-ccp \
-ftree-builtin-call-dce -ftree-ccp -ftree-ch -ftree-copyrename -ftree-dce \
-ftree-dominator-opts -ftree-dse -ftree-forwprop -ftree-fre -ftree-phiprop \
-ftree-sra -ftree-pta -ftree-ter -funit-at-a-time -fomit-frame-pointer \
-fthread-jumps -falign-functions -falign-jumps -falign-loops -falign-labels \
-fcaller-saves -fcrossjumping -fcse-follow-jumps -fcse-skip-blocks \
-fdelete-null-pointer-checks -fdevirtualize -fexpensive-optimizations -fgcse \
-fgcse-lm -finline-small-functions -findirect-inlining -fipa-sra \
-foptimize-sibling-calls -fpeephole2 -fregmove -freorder-blocks \
-freorder-functions -frerun-cse-after-loop -fsched-interblock -fsched-spec \
-fschedule-insns -fschedule-insns2 -fstrict-aliasing -fstrict-overflow \
-ftree-switch-conversion -ftree-tail-merge -ftree-pre -ftree-vrp \
-funswitch-loops -fpredictive-commoning -fgcse-after-reload \
-ftree-slp-vectorize -fvect-cost-model -fipa-cp-clone -ffast-math \
-fno-protect-parens -fstack-arrays -fforward-propagate \
-finline-functions-called-once -fmodulo-sched -fmodulo-sched-allow-regmoves \
-fgcse-sm -fgcse-las -fconserve-stack $(INCDIRS) -iquote src -mthumb \
-mthumb-interwork -O2 -c -w -fno-enforce-eh-specs -ffor-scope \
-fno-gnu-keywords -fno-nonansi-builtins -nostdinc++ -nodefaultlibs -nostdlib \
-fno-common -mcpu=arm7tdmi -march=armv4t
LDFLAGS  := -T etc/gba_cart.ld $(LIBDIRS)
GFXFLAGS := -m -ftb -fh!

# use this for globbing onto sources
# $(shell find <dir>/ -type f -name '*.<ext>')

# Tile-based images, normal reductions
IMAGES4T   := $(shell find data/image/ -type f -name '*.4bpp.t.png')
IMAGES4TLZ := $(shell find data/image/ -type f -name '*.4bpp.lz.t.png')
IMAGES8T   := $(shell find data/image/ -type f -name '*.8bpp.t.png')
IMAGES8TLZ := $(shell find data/image/ -type f -name '*.8bpp.lz.t.png')

# Tile-based images, no reduction performed
IMAGES4TN   := $(shell find data/image/ -type f -name '*.4bpp.tn.png')
IMAGES4TNLZ := $(shell find data/image/ -type f -name '*.4bpp.lz.tn.png')
IMAGES8TN   := $(shell find data/image/ -type f -name '*.8bpp.tn.png')
IMAGES8TNLZ := $(shell find data/image/ -type f -name '*.8bpp.lz.tn.png')

# Bitmap images, normal reductions
IMAGES4B   := $(shell find data/image/ -type f -name '*.4bpp.b.png')
IMAGES4BLZ := $(shell find data/image/ -type f -name '*.4bpp.lz.b.png')
IMAGES8B   := $(shell find data/image/ -type f -name '*.8bpp.b.png')
IMAGES8BLZ := $(shell find data/image/ -type f -name '*.8bpp.lz.b.png')

POKETEXTS := $(shell find data/text/ -type f -name '*.snip')
PALETTES  := $(shell find data/image/ -type f -name '*.npal')
BINARIES  := $(shell find data/other/ -type f -name '*.bin')

.PHONY: all csrc cxxsrc images imagesb imagest images4b images4blz images8b \
	images8blz images4t images4tlz images8t images8tlz poketext palettes \
	assemble link copybin fix clean

all: csrc cxxsrc images poketexts palettes assemble link copybin fix

csrc:
	@mkdir -p bin/code
	@for SRCFILE in $(CFILES) ; do \
		NEWNAME=`$(NAMEMOD) -fem $$SRCFILE` ; \
		$(CC) $(CFLAGS) -o bin/code/$$NEWNAME.o $$SRCFILE ; \
	done

cxxsrc:
	@mkdir -p bin/code
	@for SRCFILE in $(CXXFILES) ; do \
		NEWNAME=`$(NAMEMOD) -fem $$SRCFILE` ; \
		$(CC) $(CXXFLAGS) -o bin/code/$$NEWNAME.o $$SRCFILE ; \
	done

images: imagesb imagestn imagest

imagesb: images4b images4blz images8b images8blz

imagestn: images4tn images4tnlz images8tn images8tnlz

imagest: images4t images4tlz images8t images8tlz

images4b:
	@mkdir -p bin/data/image
	@for CURIMG in $(IMAGES4B) ; do \
		BNAME=`$(NAMEMOD) -l $$CURIMG` ; \
		ANAME=`$(NAMEMOD) -a $$CURIMG` ; \
		echo ".file \"$$CURIMG\"" > bin/temp.s ; \
		echo '.ident "AS: (devkitARM release 45) 2.25.1"' >> bin/temp.s ; \
		$(GFX) $$CURIMG $(GFXFLAGS) -obin/$$BNAME.x.bin -gb -gz! -mz! \
		-gB4 ; \
		mv bin/$$BNAME.img.bin bin/$${ANAME}_img.bin ; \
		mv bin/$$BNAME.pal.bin bin/$${ANAME}_pal.bin ; \
		$(BIN2ASM) bin/$${ANAME}_img.bin >> bin/temp.s ; \
		$(BIN2ASM) bin/$${ANAME}_pal.bin >> bin/temp.s ; \
		$(AS) $(ASFLAGS) bin/temp.s -o bin/data/image/$$BNAME.o ; \
		rm bin/temp.s bin/$${ANAME}_img.bin bin/$${ANAME}_pal.bin ; \
	done

images4blz:
	@mkdir -p bin/data/image
	@for CURIMG in $(IMAGES4BLZ) ; do \
		BNAME=`$(NAMEMOD) -l $$CURIMG` ; \
		ANAME=`$(NAMEMOD) -a $$CURIMG` ; \
		echo ".file \"$$CURIMG\"" > bin/temp.s ; \
		echo '.ident "AS: (devkitARM release 45) 2.25.1"' >> bin/temp.s ; \
		$(GFX) $$CURIMG $(GFXFLAGS) -obin/$$BNAME.x.bin -gb -gzl -mzl \
		-gB4 ; \
		mv bin/$$BNAME.img.bin bin/$${ANAME}_img.bin ; \
		mv bin/$$BNAME.pal.bin bin/$${ANAME}_pal.bin ; \
		$(BIN2ASM) bin/$${ANAME}_img.bin >> bin/temp.s ; \
		$(BIN2ASM) bin/$${ANAME}_pal.bin >> bin/temp.s ; \
		$(AS) $(ASFLAGS) bin/temp.s -o bin/data/image/$$BNAME.o ; \
		rm bin/temp.s bin/$${ANAME}_img.bin bin/$${ANAME}_pal.bin ; \
	done

images8b:
	@mkdir -p bin/data/image
	@for CURIMG in $(IMAGES8B) ; do \
		BNAME=`$(NAMEMOD) -l $$CURIMG` ; \
		ANAME=`$(NAMEMOD) -a $$CURIMG` ; \
		echo ".file \"$$CURIMG\"" > bin/temp.s ; \
		echo '.ident "AS: (devkitARM release 45) 2.25.1"' >> bin/temp.s ; \
		$(GFX) $$CURIMG $(GFXFLAGS) -obin/$$BNAME.x.bin -gb -gz! -mz! \
		-gB8 ; \
		mv bin/$$BNAME.img.bin bin/$${ANAME}_img.bin ; \
		mv bin/$$BNAME.pal.bin bin/$${ANAME}_pal.bin ; \
		$(BIN2ASM) bin/$${ANAME}_img.bin >> bin/temp.s ; \
		$(BIN2ASM) bin/$${ANAME}_pal.bin >> bin/temp.s ; \
		$(AS) $(ASFLAGS) bin/temp.s -o bin/data/image/$$BNAME.o ; \
		rm bin/temp.s bin/$${ANAME}_img.bin bin/$${ANAME}_pal.bin ; \
	done

images8blz:
	@mkdir -p bin/data/image
	@for CURIMG in $(IMAGES8BLZ) ; do \
		BNAME=`$(NAMEMOD) -l $$CURIMG` ; \
		ANAME=`$(NAMEMOD) -a $$CURIMG` ; \
		echo ".file \"$$CURIMG\"" > bin/temp.s ; \
		echo '.ident "AS: (devkitARM release 45) 2.25.1"' >> bin/temp.s ; \
		$(GFX) $$CURIMG $(GFXFLAGS) -obin/$$BNAME.x.bin -gb -gzl -mzl \
		-gB8 ; \
		mv bin/$$BNAME.img.bin bin/$${ANAME}_img.bin ; \
		mv bin/$$BNAME.pal.bin bin/$${ANAME}_pal.bin ; \
		$(BIN2ASM) bin/$${ANAME}_img.bin >> bin/temp.s ; \
		$(BIN2ASM) bin/$${ANAME}_pal.bin >> bin/temp.s ; \
		$(AS) $(ASFLAGS) bin/temp.s -o bin/data/image/$$BNAME.o ; \
		rm bin/temp.s bin/$${ANAME}_img.bin bin/$${ANAME}_pal.bin ; \
	done

images4tn:
	@mkdir -p bin/data/image
	@for CURIMG in $(IMAGES4TN) ; do \
		BNAME=`$(NAMEMOD) -l $$CURIMG` ; \
		ANAME=`$(NAMEMOD) -a $$CURIMG` ; \
		echo ".file \"$$CURIMG\"" > bin/temp.s ; \
		echo '.ident "AS: (devkitARM release 45) 2.25.1"' >> bin/temp.s ; \
		$(GFX) $$CURIMG $(GFXFLAGS) -obin/$$BNAME.x.bin -mR! -gz! -mz! \
		-gB4 ; \
		mv bin/$$BNAME.img.bin bin/$${ANAME}_img.bin ; \
		mv bin/$$BNAME.map.bin bin/$${ANAME}_map.bin ; \
		mv bin/$$BNAME.pal.bin bin/$${ANAME}_pal.bin ; \
		$(BIN2ASM) bin/$${ANAME}_img.bin >> bin/temp.s ; \
		$(BIN2ASM) bin/$${ANAME}_map.bin >> bin/temp.s ; \
		$(BIN2ASM) bin/$${ANAME}_pal.bin >> bin/temp.s ; \
		$(AS) $(ASFLAGS) bin/temp.s -o bin/data/image/$$BNAME.o ; \
		rm bin/temp.s bin/$${ANAME}_img.bin bin/$${ANAME}_map.bin \
		bin/$${ANAME}_pal.bin ; \
	done

images4tnlz:
	@mkdir -p bin/data/image
	@for CURIMG in $(IMAGES4TNLZ) ; do \
		BNAME=`$(NAMEMOD) -l $$CURIMG` ; \
		ANAME=`$(NAMEMOD) -a $$CURIMG` ; \
		echo ".file \"$$CURIMG\"" > bin/temp.s ; \
		echo '.ident "AS: (devkitARM release 45) 2.25.1"' >> bin/temp.s ; \
		$(GFX) $$CURIMG $(GFXFLAGS) -obin/$$BNAME.x.bin -mR! -gzl -mzl -gB4 ; \
		mv bin/$$BNAME.img.bin bin/$${ANAME}_img.bin ; \
		mv bin/$$BNAME.map.bin bin/$${ANAME}_map.bin ; \
		mv bin/$$BNAME.pal.bin bin/$${ANAME}_pal.bin ; \
		$(BIN2ASM) bin/$${ANAME}_img.bin >> bin/temp.s ; \
		$(BIN2ASM) bin/$${ANAME}_map.bin >> bin/temp.s ; \
		$(BIN2ASM) bin/$${ANAME}_pal.bin >> bin/temp.s ; \
		$(AS) $(ASFLAGS) bin/temp.s -o bin/data/image/$$BNAME.o ; \
		rm bin/temp.s bin/$${ANAME}_img.bin bin/$${ANAME}_map.bin \
		bin/$${ANAME}_pal.bin ; \
	done

images8tn:
	@mkdir -p bin/data/image
	@for CURIMG in $(IMAGES8TN) ; do \
		BNAME=`$(NAMEMOD) -l $$CURIMG` ; \
		ANAME=`$(NAMEMOD) -a $$CURIMG` ; \
		echo ".file \"$$CURIMG\"" > bin/temp.s ; \
		echo '.ident "AS: (devkitARM release 45) 2.25.1"' >> bin/temp.s ; \
		$(GFX) $$CURIMG $(GFXFLAGS) -obin/$$BNAME.x.bin -mR! -gz! -mz! \
		-gB8 ; \
		mv bin/$$BNAME.img.bin bin/$${ANAME}_img.bin ; \
		mv bin/$$BNAME.map.bin bin/$${ANAME}_map.bin ; \
		mv bin/$$BNAME.pal.bin bin/$${ANAME}_pal.bin ; \
		$(BIN2ASM) bin/$${ANAME}_img.bin >> bin/temp.s ; \
		$(BIN2ASM) bin/$${ANAME}_map.bin >> bin/temp.s ; \
		$(BIN2ASM) bin/$${ANAME}_pal.bin >> bin/temp.s ; \
		$(AS) $(ASFLAGS) bin/temp.s -o bin/data/image/$$BNAME.o ; \
		rm bin/temp.s bin/$${ANAME}_img.bin bin/$${ANAME}_map.bin \
		bin/$${ANAME}_pal.bin ; \
	done

images8tnlz:
	@mkdir -p bin/data/image
	@for CURIMG in $(IMAGES8TNLZ) ; do \
		BNAME=`$(NAMEMOD) -l $$CURIMG` ; \
		ANAME=`$(NAMEMOD) -a $$CURIMG` ; \
		echo ".file \"$$CURIMG\"" > bin/temp.s ; \
		echo '.ident "AS: (devkitARM release 45) 2.25.1"' >> bin/temp.s ; \
		$(GFX) $$CURIMG $(GFXFLAGS) -obin/$$BNAME.x.bin -mR! -gzl -mzl \
		-gB8 ; \
		mv bin/$$BNAME.img.bin bin/$${ANAME}_img.bin ; \
		mv bin/$$BNAME.map.bin bin/$${ANAME}_map.bin ; \
		mv bin/$$BNAME.pal.bin bin/$${ANAME}_pal.bin ; \
		$(BIN2ASM) bin/$${ANAME}_img.bin >> bin/temp.s ; \
		$(BIN2ASM) bin/$${ANAME}_map.bin >> bin/temp.s ; \
		$(BIN2ASM) bin/$${ANAME}_pal.bin >> bin/temp.s ; \
		$(AS) $(ASFLAGS) bin/temp.s -o bin/data/image/$$BNAME.o ; \
		rm bin/temp.s bin/$${ANAME}_img.bin bin/$${ANAME}_map.bin \
		bin/$${ANAME}_pal.bin ; \
	done

images4t:
	@mkdir -p bin/data/image
	@for CURIMG in $(IMAGES4T) ; do \
		BNAME=`$(NAMEMOD) -l $$CURIMG` ; \
		ANAME=`$(NAMEMOD) -a $$CURIMG` ; \
		echo ".file \"$$CURIMG\"" > bin/temp.s ; \
		echo '.ident "AS: (devkitARM release 45) 2.25.1"' >> bin/temp.s ; \
		$(GFX) $$CURIMG $(GFXFLAGS) -obin/$$BNAME.x.bin -mRtf -gz! -mz! \
		-gB4 ; \
		mv bin/$$BNAME.img.bin bin/$${ANAME}_img.bin ; \
		mv bin/$$BNAME.map.bin bin/$${ANAME}_map.bin ; \
		mv bin/$$BNAME.pal.bin bin/$${ANAME}_pal.bin ; \
		$(BIN2ASM) bin/$${ANAME}_img.bin >> bin/temp.s ; \
		$(BIN2ASM) bin/$${ANAME}_map.bin >> bin/temp.s ; \
		$(BIN2ASM) bin/$${ANAME}_pal.bin >> bin/temp.s ; \
		$(AS) $(ASFLAGS) bin/temp.s -o bin/data/image/$$BNAME.o ; \
		rm bin/temp.s bin/$${ANAME}_img.bin bin/$${ANAME}_map.bin \
		bin/$${ANAME}_pal.bin ; \
	done

images8t:
	@mkdir -p bin/data/image
	@for CURIMG in $(IMAGES8T) ; do \
		BNAME=`$(NAMEMOD) -l $$CURIMG` ; \
		ANAME=`$(NAMEMOD) -a $$CURIMG` ; \
		echo ".file \"$$CURIMG\"" > bin/temp.s ; \
		echo '.ident "AS: (devkitARM release 45) 2.25.1"' >> bin/temp.s ; \
		$(GFX) $$CURIMG $(GFXFLAGS) -obin/$$BNAME.x.bin -mRtf -gz! -mz! \
		-gB8 ; \
		mv bin/$$BNAME.img.bin bin/$${ANAME}_img.bin ; \
		mv bin/$$BNAME.map.bin bin/$${ANAME}_map.bin ; \
		mv bin/$$BNAME.pal.bin bin/$${ANAME}_pal.bin ; \
		$(BIN2ASM) bin/$${ANAME}_img.bin >> bin/temp.s ; \
		$(BIN2ASM) bin/$${ANAME}_map.bin >> bin/temp.s ; \
		$(BIN2ASM) bin/$${ANAME}_pal.bin >> bin/temp.s ; \
		$(AS) $(ASFLAGS) bin/temp.s -o bin/data/image/$$BNAME.o ; \
		rm bin/temp.s bin/$${ANAME}_img.bin bin/$${ANAME}_map.bin \
		bin/$${ANAME}_pal.bin ; \
	done

images4tlz:
	@mkdir -p bin/data/image
	@for CURIMG in $(IMAGES4TLZ) ; do \
		BNAME=`$(NAMEMOD) -l $$CURIMG` ; \
		ANAME=`$(NAMEMOD) -a $$CURIMG` ; \
		echo ".file \"$$CURIMG\"" > bin/temp.s ; \
		echo '.ident "AS: (devkitARM release 45) 2.25.1"' >> bin/temp.s ; \
		$(GFX) $$CURIMG $(GFXFLAGS) -obin/$$BNAME.x.bin -mRtf -gzl -mzl \
		-gB4 ; \
		mv bin/$$BNAME.img.bin bin/$${ANAME}_img.bin ; \
		mv bin/$$BNAME.map.bin bin/$${ANAME}_map.bin ; \
		mv bin/$$BNAME.pal.bin bin/$${ANAME}_pal.bin ; \
		$(BIN2ASM) bin/$${ANAME}_img.bin >> bin/temp.s ; \
		$(BIN2ASM) bin/$${ANAME}_map.bin >> bin/temp.s ; \
		$(BIN2ASM) bin/$${ANAME}_pal.bin >> bin/temp.s ; \
		$(AS) $(ASFLAGS) bin/temp.s -o bin/data/image/$$BNAME.o ; \
		rm bin/temp.s bin/$${ANAME}_img.bin bin/$${ANAME}_map.bin \
		bin/$${ANAME}_pal.bin ; \
	done

images8tlz:
	@mkdir -p bin/data/image
	@for CURIMG in $(IMAGES8TLZ) ; do \
		BNAME=`$(NAMEMOD) -l $$CURIMG` ; \
		ANAME=`$(NAMEMOD) -a $$CURIMG` ; \
		echo ".file \"$$CURIMG\"" > bin/temp.s ; \
		echo '.ident "AS: (devkitARM release 45) 2.25.1"' >> bin/temp.s ; \
		$(GFX) $$CURIMG $(GFXFLAGS) -obin/$$BNAME.x.bin -mRtf -gzl -mzl \
		-gB8 ; \
		mv bin/$$BNAME.img.bin bin/$${ANAME}_img.bin ; \
		mv bin/$$BNAME.map.bin bin/$${ANAME}_map.bin ; \
		mv bin/$$BNAME.pal.bin bin/$${ANAME}_pal.bin ; \
		$(BIN2ASM) bin/$${ANAME}_img.bin >> bin/temp.s ; \
		$(BIN2ASM) bin/$${ANAME}_map.bin >> bin/temp.s ; \
		$(BIN2ASM) bin/$${ANAME}_pal.bin >> bin/temp.s ; \
		$(AS) $(ASFLAGS) bin/temp.s -o bin/data/image/$$BNAME.o ; \
		rm bin/temp.s bin/$${ANAME}_img.bin bin/$${ANAME}_map.bin \
		bin/$${ANAME}_pal.bin ; \
	done

poketexts:
	@mkdir -p bin/data/text
	@for SNIPPET in $(POKETEXTS) ; do \
		BNAME=`$(NAMEMOD) -l $$SNIPPET` ; \
		echo ".file \"$$SNIPPET\"" > bin/temp.s ; \
		echo '.ident "AS: (devkitARM release 45) 2.25.1"' >> bin/temp.s ; \
		$(TXT2BIN) $$SNIPPET bin/$$BNAME.bin ; \
		$(BIN2ASM) bin/$$BNAME.bin >> bin/temp.s ; \
		$(AS) $(ASFLAGS) bin/temp.s -o bin/data/text/$$BNAME.o ; \
		rm bin/$$BNAME.bin bin/temp.s ; \
	done

palettes:
	@mkdir -p bin/data/image
	@for PALETTE in $(PALETTES) ; do \
		BNAME=`$(NAMEMOD) -l $$PALETTE` ; \
		echo ".file \"$$PALETTE\"" > bin/temp.s ; \
		echo '.ident "AS: (devkitARM release 45) 2.25.1"' >> bin/temp.s ; \
		$(PAL2BIN) $$PALETTE bin/$$BNAME.bin ; \
		$(BIN2ASM) bin/$$BNAME.bin >> bin/temp.s ; \
		$(AS) $(ASFLAGS) bin/temp.s -o bin/data/image/$$BNAME.o ; \
		cp bin/temp.s bin/temp2.s ; \
		rm bin/$$BNAME.bin bin/temp.s ; \
	done

assemble:
	@mkdir -p bin/code
	@for SFILE in $(SFILES) ; do \
		MANGLED=`$(NAMEMOD) -fem $$SFILE` ; \
		$(AS) $(ASFLAGS) $$SFILE -o bin/code/$$MANGLED.o ; \
	done

link:
	@$(LD) $(LDFLAGS) -e j_rom_start -o bin/$(PROGRAM).elf \
	bin/code/init+boot.s.o bin/code/init+bios.s.o \
	`find bin/code/ -type f -name '*.cpp.o'` -lstdc++ \
	`find bin/code/ -type f -name '*.c.o'` -lgcc -lc -lsysbase -lc \
	`find bin/data/ -type f -name '*.o'`

fix:
	@$(OCPY) -O binary bin/$(PROGRAM).elf bin/$(PROGRAM).gba
	@$(FIX) bin/$(PROGRAM).gba -p "-t$(GAMETITLE)" -c$(GAMECODE) \
	-m$(GAMEMAKER) -v0
	@#$(INSERT) etc/hook.list bin/$(PROGRAM).elf bin/$(PROGRAM).gba

clean:
	@rm -rf bin
