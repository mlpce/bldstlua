# bldstlua

## Repo manifest and source code repositories

The source code repositories required to build, including this one (bldstlua)
can be obtained using the google repo tool. See the manifest repository at
https://github.com/mlpce/mnfstlua.

## build/gccbld.sh

Builds the console program lua.ttp with libcmini, slinput and tosbindl using
the toolchain files configured for m68k-atari-mint-gcc. To run the script,
first change to the 'build' directory before invoking ./gccbld.sh. The script
expects the directory layout to be the same as that provided by the 'repo sync'.

## Lua

Lua is licensed under the MIT license. For information about Lua and to view
its license see the [Lua website](https://www.lua.org/).

## libcmini

libcmini is licensed under the LGPL-2.1. For information about libcmini and to
view its license see the [libcmini github project](https://github.com/freemint/libcmini).

## m68k-atari-mint-gcc

For information about m68k-atari-mint-gcc see
[Vincent Rivière's m68k-atari-mint cross-tools website](http://vincent.riviere.free.fr/soft/m68k-atari-mint/).
