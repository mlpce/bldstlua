#!/usr/bin/env bash
set -e

# This script converts built project into the GEMDOS compatible 8.3 filenames
# and adds licenses and a readme.
# It then creates a zip file, adding the files with LF converted to CRLF.

if [ ! -f ./ziprel.sh ]; then
  echo "Error: Run in same directory as ./ziprel.sh"
  exit 1
fi

# Make 8.3 directory structure
rm -Rfv 8.3/STLUA*
mkdir -p 8.3/STLUA/BIN
mkdir -p 8.3/STLUA/DOC
mkdir -p 8.3/STLUA/LICENSE/SLINPUT
mkdir -p 8.3/STLUA/LICENSE/TOSBINDL
mkdir -p 8.3/STLUA/LICENSE/LUA

# Copy built executables
cp -v ../install/bin/lua.ttp 8.3/STLUA/BIN/LUA.TTP
cp -v ../install/bin/luac.ttp 8.3/STLUA/BIN/LUAC.TTP
cp -v ../install/revision.txt 8.3/STLUA/DOC/REVISION.TXT
cp -v ../doc/readme.txt 8.3/STLUA/DOC/README.TXT

# Copy licenses
cp -v ../../slinput/LICENSE 8.3/STLUA/LICENSE/SLINPUT/LICENSE.TXT
cp -v ../../tosbindl/LICENSE 8.3/STLUA/LICENSE/TOSBINDL/LICENSE.TXT
cp -v ../doc/license/lua/license 8.3/STLUA/LICENSE/LUA/LICENSE.TXT

# Check revision.txt to see if libcmini is used, and copy license
HAS_LIBCMINI=$(cat ../install/revision.txt | grep /libcmini)
if [ "$HAS_LIBCMINI" != "" ]; then
  mkdir -p 8.3/STLUA/LICENSE/LIBCMINI
  cp -v ../../libcmini/LICENSE.txt 8.3/STLUA/LICENSE/LIBCMINI/LICENSE.TXT
fi

# Zip up files, converting LF to CRLF
pushd 8.3
zip -l -r STLUA.ZIP STLUA
popd
