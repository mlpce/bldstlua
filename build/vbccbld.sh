#!/usr/bin/env bash
set -eE
trap 'echo Build failure' ERR

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
    -D MLPCE_DEBUGLIB_ENABLED=OFF \
    -D MLPCE_IOLIB_ENABLED=OFF \
    -D MLPCE_MATHLIB_ENABLED=OFF \
    -D MLPCE_OSLIB_ENABLED=OFF \
    -D MLPCE_UTF8LIB_ENABLED=OFF \
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
