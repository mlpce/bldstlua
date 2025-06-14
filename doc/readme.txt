LUA.TTP is a build of the Lua 5.4 standalone interpreter with some adaptations
for the Atari ST computer. It has been compiled with LUA_32BITS set to 1, i.e.
32 bit Lua integers and 32 bit Lua floating point numbers.

For information about Lua see the project website at https://www.lua.org/

The source code used to build LUA.TTP can be found on GitHub. At the program
interactive prompt, type about() and enter to get information about the GitHub
projects and repository revisions used during the build.

LUAC.TTP is a build of the Lua compiler. It is used to convert Lua scripts
into Lua bytecode. It is not necessary to compile Lua scripts before running
them, LUA.TTP will do that automatically. However precompiling scripts into
bytecode means they will load more quickly. Precompiled chunks are not
portable across different architectures, e.g. if sizeof(int) is different.

LUAB.TTP is a cut down version of Lua without the parser or interactive prompt.
As such it can only be used to run precompiled Lua bytecode. The bytecode file
to run is passed on the command line.

The following Lua libraries have been included in the build:
  coroutine, package, string, table.

The following Lua libraries have been excluded from the build:
  debug, io, math, os, utf8

Additionally, this build includes a GEMDOS binding targetting the GEMDOS
functions available in TOS 1.X. For information about the binding, see the
README.md at https://github.com/mlpce/tosbindl.

This build of Lua uses the environment variable PATH to find packages. If the
Lua module being loaded is not found there then a search is also made relative
to the current directory. On TOS the desktop sets the environment PATH
according to the boot drive so usually A:\ or C:\, however it is possible to
customise PATH using e.g. an AUTO folder program. Multiple paths can be added
to PATH using the ';' delimiter.

If the environment variable PATH is not found, or it is empty, then the
current drive is used for the search path. At the interactive prompt, type
package.path to see the search path Lua is using.

 Example: When 'PATH=A:\':
  A:\lua\?.lua;A:\lua\?\init.lua;.\?.lua;.\?\init.lua

 Example: When 'PATH=C:\;C:\script':
  C:\lua\?.lua;C:\lua\?\init.lua;C:\script\lua\?.lua;
  C:\script\lua\?\init.lua;.\?.lua;.\?\init.lua

 Example: When PATH is missing or empty:
  \lua\?.lua;\lua\?\init.lua;.\?lua;.\?\init.lua

Further reading

Lua 5.4 reference manual:
https://www.lua.org/manual/5.4/
Man pages for original PUC-Rio Lua:
https://www.lua.org/manual/5.4/lua.html
https://www.lua.org/manual/5.4/luac.html
