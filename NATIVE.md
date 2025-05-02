# Lattice C native build instructions

2MB of memory is required to build.

## Generate zips and copy to Atari ST

Use `zipsrc.sh` from `slinput`, `tosbindl` and `lua` repositories to generate three zip files:
* SLINPUT.ZIP
* TOSBINDL.ZIP
* LUA.ZIP

Copy the zips into a directory on Atari ST eg `C:\BUILD`.

_Take care to only copy uppercase 8.3 filenames, if using e.g. VFAT on Linux to mount an SD card directly, as long file names cause problems on the Atari ST._

Directory layout:  
```
C:\BUILD\LUA.ZIP  
C:\BUILD\TOSBINDL.ZIP  
C:\BUILD\SLINPUT.ZIP  
```

## Unzip the zip files

Start a shell e.g. EMUCON2

Unzip each zip file within `C:\BUILD` using e.g. the `ZIPJR` program  
`ZIPJR -x -r *.ZIP`  

The zips will extract under the BUILD directory:
```
C:\BUILD\LUA\...  
C:\BUILD\TOSBINDL\...  
C:\BULID\SLINPUT\...
```

## Build the slinput library

Start `LC5.PRG` and load the `SLINPUT.PRJ` projected located at `SLINPUT\BUILD\TOS\LATTICEC\SLINPUT.PRJ` using `Project->Load` menu.

Then build using `Project->Make all` "SLINPUT".

## Copy slinput library and header

Copy the library `SLINPUT.LIB` and header file `INCLUDE\SLINPUT.H` into the Lua LATTICEC directory.

Destination directory layout:
```
C:\BUILD\LUA\BUILD\TOS\LATTICEC\INCLUDE\SLINPUT.H  
C:\BUILD\LUA\BUILD\TOS\LATTICEC\LUA.PRJ  
C:\BUILD\LUA\BUILD\TOS\LATTICEC\LUA54.PRJ  
C:\BUILD\LUA\BUILD\TOS\LATTICEC\SLINPUT.LIB  
C:\BUILD\LUA\BUILD\TOS\LATTICEC\STACKVAL.C  
```

## Build tbgemdos library

Before building the GEMDOS binding, three header files need to be copied from the LUA repository into the tosbindl LATTICEC directory.
* LUA.H
* LAUXLIB.H
* LUACONF.H

Destination directory layout:
```
C:\BUILD\TOSBINDL\BUILD\TOS\LATTICEC\LAUXLIB.H
C:\BUILD\TOSBINDL\BUILD\TOS\LATTICEC\LUA.H
C:\BUILD\TOSBINDL\BUILD\TOS\LATTICEC\LUACONF.H
C:\BUILD\TOSBINDL\BUILD\TOS\LATTICEC\TBGEMDOS.PRJ
C:\BUILD\TOSBINDL\BUILD\TOS\LATTICEC\TOSBINDL.PRJ
```

Start `LC5.PRG` and load the `TBGEMDOS.PRJ` project located at `TOSBINDL\BUILD\TOS\LATTICEC\TBGEMDOS.PRJ` using `Project->Load` menu.

Then build using `Project->Make all` "TBGEMDOS".

## Build tosbindl library

Start `LC5.PRG` and load the `TOSBINDL.PRJ` project located at `TOSBINDL\BUILD\TOS\LATTICEC\TOSBINDL.PRJ` using `Project->Load` menu.

Then build using `Project->Make all` "TOSBINDL".

## Copy the tbgemdos and tosbindl libraries and headers

Before building Lua, the libraries and header files for TOSBINDL need copying into the Lua LATTICEC directory.

* TBGEMDOS.LIB
* TOSBINDL.LIB
* SRC\GEMDOS\TBGEMDOS.H
* SRC\TOSBINDL.H

Destination directory layout:
```
C:\BUILD\LUA\BUILD\TOS\LATTICEC\INCLUDE\SLINPUT.H  
C:\BUILD\LUA\BUILD\TOS\LATTICEC\INCLUDE\TBGEMDOS.H  
C:\BUILD\LUA\BUILD\TOS\LATTICEC\INCLUDE\TOSBINDL.H  
C:\BUILD\LUA\BUILD\TOS\LATTICEC\LUA.PRJ  
C:\BUILD\LUA\BUILD\TOS\LATTICEC\LUA54.PRJ  
C:\BUILD\LUA\BUILD\TOS\LATTICEC\SLINPUT.LIB  
C:\BUILD\LUA\BUILD\TOS\LATTICEC\STACKVAL.C  
C:\BUILD\LUA\BUILD\TOS\LATTICEC\TBGEMDOS.LIB  
C:\BUILD\LUA\BUILD\TOS\LATTICEC\TOSBINDL.LIB  
```

## Build lua54 library

Start `LC5.PRG` and load the `LUA54.PRJ` project located at `LUA\BUILD\TOS\LATTICEC\LUA54.PRJ` using `Project->Load` menu.

Then build using `Project->Make all` "LUA54".

## Build lua.ttp

Start `LC5.PRG` and load the `LUA.PRJ` project located at `LUA\BUILD\TOS\LATTICEC\LUA.PRJ` using `Project->Load` menu.

Then build using `Project->Make all` "LUA".

Executable is created at `C:\BUILD\LUA\BUILD\TOS\LATTICEC\LUA.TTP`  
