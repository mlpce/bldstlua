LUA.PRG is a build of the Lua 5.5 standalone interpreter with some adaptations
for the Atari ST computer. It has been compiled with LUA_32BITS set to 1, i.e.
32 bit Lua integers and 32 bit Lua floating point numbers.

For information about Lua see the project website at https://www.lua.org/

The source code used to build LUA.PRG can be found on GitHub. At the program
interactive prompt, type about() and enter to get information about the GitHub
projects and repository revisions used during the build.

LUAC.TTP is a build of the Lua compiler. It is used to convert Lua scripts
into Lua bytecode. It is not necessary to compile Lua scripts before running
them, LUA.PRG will do that automatically. However precompiling scripts into
bytecode means they will load more quickly. The bytecode can also be stripped
to remove debug information, saving runtime memory. Precompiled chunks are not
portable across different architectures, e.g. if sizeof(int) is different.

LUAB.PRG is a cut down version of Lua without the parser or interactive
prompt, and therefore a smaller executable file size. It can only be used to
run precompiled Lua bytecode. The bytecode file to run is passed on the
command line.

The following Lua libraries have been included in the build:
  coroutine, package, string, table.

The following Lua libraries have been excluded from the build:
  io, math, os, utf8

LUA.PRG also contains the Lua debug library. This is useful for tracebacks if
a script raises an error.

Additionally, this build includes a GEMDOS/Trap #2 binding targeting the
functions available in TOS 1.X. For information about the binding, see the
README.md at https://github.com/mlpce/tosbindl.

This build of Lua uses the environment variable PATH to find packages. If the
Lua module being loaded is not found relative to the current directory, a
search is made using the PATH environment variable. On TOS the desktop sets
the environment PATH according to the boot drive so usually A:\ or C:\,
however it is possible to customise PATH using e.g. an AUTO folder program.
Multiple paths can be added to PATH using the ';' delimiter.

If the environment variable PATH is not found, or it is empty, then the
current drive is used for the search path.

Example: When 'PATH=A:\':
 .\?.lua;.\?\init.lua;A:\lua\?.lua;A:\lua\?\init.lua;

Example: When 'PATH=C:\;C:\script':
 .\?.lua;.\?\init.lua;C:\lua\?.lua;C:\lua\?\init.lua;C:\script\lua\?.lua;
 C:\script\lua\?\init.lua;

Example: When PATH is missing or empty:
 .\?.lua;.\?\init.lua;\lua\?.lua;\lua\?\init.lua;

Checking paths relative to the current directory first (e.g. .\?.lua) means
a program can override system installed modules with modules belonging to the
program.

At the interactive prompt, type package.path to see the search path Lua is
using. If a script needs different behaviour for finding packages, it can set
package.path itself.

Further reading

Lua 5.5 reference manual:
https://www.lua.org/manual/5.5/
Man pages for original PUC-Rio Lua:
https://www.lua.org/manual/5.5/lua.html
https://www.lua.org/manual/5.5/luac.html
