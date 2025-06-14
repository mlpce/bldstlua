# bldstlua

This repository contains shell scripts for building Lua for the Atari ST.
Additionally the build requires an already installed cmake and cross compilation
environment.

## Source code repositories

The source code repositories required to build, including this one (bldstlua)
can be obtained using the google repo tool. See the manifest repository at
https://github.com/mlpce/mnfstlua for instructions.

## build/gccbld.sh

Builds the console program lua.ttp with libcmini, slinput and tosbindl, luab.ttp and luac.ttp, using
the toolchain files configured for m68k-atari-mint-gcc.

To run the script, first change to the 'build' directory before invoking ./gccbld.sh. The script
expects the directory layout to be the same as that provided by the 'repo sync'.

## build/vbccbld.sh

Builds the console program lua.ttp with slinput and tosbindl, luab.ttp and luac.ttp, using the toolchain files configured for vbcc.

To run the script, first change to the 'build'
directory before invoking ./vbccbld.sh. The script expects the directory layout
to be the same as that provided by the 'repo sync'.

## build/ziprel.sh

After running gccbld.sh or vbccbld.sh, ziprel.sh can be used to generate a zip file at build/8.3/STLUA.ZIP. The zip contains LUA.TTP, LUAB.TTP, LUAC.TTP, license files, a short README.TXT and REVISION.TXT. The latter contains the repo names and revisions used during the build. The zip file contains filenames in uppercase 8.3 format, suitable for copying to an Atari ST.

## Lattice C native build

The Lattice C build is not scripted and needs to be done manually. See the [native build instructions](build/NATIVE.md).

## Lua

Lua is licensed under the MIT license. For information about Lua and to view its license see the [Lua website](https://www.lua.org/).

## libcmini

libcmini is licensed under the LGPL-2.1. For information about libcmini and to view its license see the [libcmini github project](https://github.com/freemint/libcmini).

## m68k-atari-mint-gcc

For information about m68k-atari-mint-gcc see
[Vincent Rivière's m68k-atari-mint cross-tools website](http://vincent.riviere.free.fr/soft/m68k-atari-mint/).

## vbcc

For information about vbcc see [Dr. Barthelmann´s compiler page](http://www.compilers.de/vbcc.html)
