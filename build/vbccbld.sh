#!/usr/bin/env bash
set -eE
trap 'echo Build failure' ERR

BUILD_VERSION="0.1.0-d"

# Toolchain int size (16 or 32)
TC_INT_SIZE=16

if [ ! -f ./vbccbld.sh ]; then
  echo "Error: Run in same directory as ./vbccbld.sh"
  exit 1
fi

BLDSTLUA_DIR=$(realpath $(pwd)/..)

# Install directory
BLDSTLUA_INSTALL_DIR=${BLDSTLUA_DIR}/install
mkdir -p ${BLDSTLUA_INSTALL_DIR}

# Generate revision information
REVISION_TEXT=${BLDSTLUA_INSTALL_DIR}/revision.txt
printf "Build version: %s\n" "${BUILD_VERSION}/${TC_INT_SIZE}" > ${REVISION_TEXT}
repo forall -c \
  'echo $REPO_PROJECT $REPO_RREV \
   $(git rev-parse --short HEAD) \
   $(git diff --exit-code --quiet HEAD || echo \(modified\))' >> ${REVISION_TEXT}

# Generate revision header
mkdir -p ${BLDSTLUA_INSTALL_DIR}/include
REVISION_HEADER=${BLDSTLUA_INSTALL_DIR}/include/revision.h

printf "#ifndef MLPCE_REVISION_HEADER_INCLUDED\n" > ${REVISION_HEADER}
printf "#define MLPCE_REVISION_HEADER_INCLUDED\n" >> ${REVISION_HEADER}
printf "#define MLPCE_BLDSTLUA_PRJ \"%s\"\n" "$(cat ${REVISION_TEXT} | grep /bldstlua | cut -d\  -f1)" >> ${REVISION_HEADER}
printf "#define MLPCE_BLDSTLUA_REV \"%s\"\n" "$(cat ${REVISION_TEXT} | grep /bldstlua | cut -d\  -f3)" >> ${REVISION_HEADER}
printf "#define MLPCE_LUA_PRJ \"%s\"\n" "$(cat ${REVISION_TEXT} | grep /lua | cut -d\  -f1)" >> ${REVISION_HEADER}
printf "#define MLPCE_LUA_REV \"%s\"\n" "$(cat ${REVISION_TEXT} | grep /lua | cut -d\  -f3)" >> ${REVISION_HEADER}
printf "#define MLPCE_SLINPUT_PRJ \"%s\"\n" "$(cat ${REVISION_TEXT} | grep /slinput | cut -d\  -f1)" >> ${REVISION_HEADER}
printf "#define MLPCE_SLINPUT_REV \"%s\"\n" "$(cat ${REVISION_TEXT} | grep /slinput | cut -d\  -f3)" >> ${REVISION_HEADER}
printf "#define MLPCE_TOSBINDL_PRJ \"%s\"\n" "$(cat ${REVISION_TEXT} | grep /tosbindl | cut -d\  -f1)" >> ${REVISION_HEADER}
printf "#define MLPCE_TOSBINDL_REV \"%s\"\n" "$(cat ${REVISION_TEXT} | grep /tosbindl | cut -d\  -f3)" >> ${REVISION_HEADER}
printf "#define MLPCE_BUILD_VERSION \"%s\"\n" "${BUILD_VERSION}" >> ${REVISION_HEADER}
printf "#endif\n" >> ${REVISION_HEADER}

# Build slinput
build_slinput() {
  pushd ${BLDSTLUA_DIR}/../slinput/build/tos/vbcc
  git clean -dfx

  cmake --toolchain ./vbcc${TC_INT_SIZE}.cmk \
    -D CMAKE_BUILD_TYPE=Release \
    -D CMAKE_INSTALL_PREFIX=${BLDSTLUA_INSTALL_DIR} \
    ../../..
  make install

  popd
}

# Build and install Lua. This will install the headers needed for tosbindl
build_lua() {
  pushd ${BLDSTLUA_DIR}/../lua/build/tos/vbcc
  git clean -dfx

  cmake --toolchain ./vbcc${TC_INT_SIZE}.cmk \
    -D CMAKE_BUILD_TYPE=Release \
    -D CMAKE_INSTALL_PREFIX=${BLDSTLUA_INSTALL_DIR} \
    -D MLPCE_ENABLED=ON \
    -D MLPCE_SLINPUT_ENABLED=ON \
    -D MLPCE_DEBUGLIB_ENABLED=OFF \
    -D MLPCE_IOLIB_ENABLED=OFF \
    -D MLPCE_MATHLIB_ENABLED=OFF \
    -D MLPCE_OSLIB_ENABLED=OFF \
    -D MLPCE_UTF8LIB_ENABLED=OFF \
    -D MLPCE_REVISION_HEADER_ENABLED=ON \
    -D MLPCE_ONELUA_ENABLED=OFF \
    ../../..
  make install

  popd
}

# Build tosbindl
build_tosbindl() {
  pushd ${BLDSTLUA_DIR}/../tosbindl/build/tos/vbcc
  git clean -dfx

  cmake --toolchain ./vbcc${TC_INT_SIZE}.cmk \
    -D CMAKE_BUILD_TYPE=Release \
    -D CMAKE_INSTALL_PREFIX=${BLDSTLUA_INSTALL_DIR} \
    ../../..
  make install

  popd
}

# Now build Lua with tosbindl enabled
build_lua_with_tosbindl() {
  pushd ${BLDSTLUA_DIR}/../lua/build/tos/vbcc

  cmake -D MLPCE_TOSBINDL_ENABLED=ON \
    ../../..
  make VERBOSE=1 install

  popd
}

build_slinput
build_lua
build_tosbindl
build_lua_with_tosbindl

cat ${REVISION_TEXT}
