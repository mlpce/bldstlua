#!/usr/bin/env bash
set -eE
trap 'echo Build failure' ERR

BUILD_VERSION=$(cat buildver.txt)

# Toolchain int size (16 or 32)
TC_INT_SIZE=16

if [ ! -f ./gccbld.sh ]; then
  echo "Error: Run in same directory as ./gccbld.sh"
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
printf "#define MLPCE_LIBCMINI_PRJ \"%s\"\n" "$(cat ${REVISION_TEXT} | grep /libcmini | cut -d\  -f1)" >> ${REVISION_HEADER}
printf "#define MLPCE_LIBCMINI_REV \"%s\"\n" "$(cat ${REVISION_TEXT} | grep /libcmini | cut -d\  -f3)" >> ${REVISION_HEADER}
printf "#define MLPCE_LUA_PRJ \"%s\"\n" "$(cat ${REVISION_TEXT} | grep /lua | cut -d\  -f1)" >> ${REVISION_HEADER}
printf "#define MLPCE_LUA_REV \"%s\"\n" "$(cat ${REVISION_TEXT} | grep /lua | cut -d\  -f3)" >> ${REVISION_HEADER}
printf "#define MLPCE_SLINPUT_PRJ \"%s\"\n" "$(cat ${REVISION_TEXT} | grep /slinput | cut -d\  -f1)" >> ${REVISION_HEADER}
printf "#define MLPCE_SLINPUT_REV \"%s\"\n" "$(cat ${REVISION_TEXT} | grep /slinput | cut -d\  -f3)" >> ${REVISION_HEADER}
printf "#define MLPCE_TOSBINDL_PRJ \"%s\"\n" "$(cat ${REVISION_TEXT} | grep /tosbindl | cut -d\  -f1)" >> ${REVISION_HEADER}
printf "#define MLPCE_TOSBINDL_REV \"%s\"\n" "$(cat ${REVISION_TEXT} | grep /tosbindl | cut -d\  -f3)" >> ${REVISION_HEADER}
printf "#define MLPCE_BUILD_VERSION \"%s\"\n" "${BUILD_VERSION}" >> ${REVISION_HEADER}
printf "#endif\n" >> ${REVISION_HEADER}

# VARs for LIBCMINI installation locations
LIBCMINI_INCLUDE_PATH=${BLDSTLUA_INSTALL_DIR}/libcmini/include
LIBCMINI_LIBRARY_PATH=${BLDSTLUA_INSTALL_DIR}/libcmini/lib
LIBCMINI_STARTUP_PATH=${BLDSTLUA_INSTALL_DIR}/libcmini/startup

# Build libcmini
build_libcmini() {
  pushd ${BLDSTLUA_DIR}/../libcmini
  git clean -dfx

  make -C contrib/linea install
  make clean
  echo "CFLAGS+=-DSTDIO_MAP_NEWLINE" > Make.config.local
  VERBOSE=yes make PREFIX_FOR_INCLUDE=${LIBCMINI_INCLUDE_PATH} \
    PREFIX_FOR_LIB=${LIBCMINI_LIBRARY_PATH} \
    PREFIX_FOR_STARTUP=${LIBCMINI_STARTUP_PATH} install

  popd
}

# Build slinput
build_slinput() {
  pushd ${BLDSTLUA_DIR}/../slinput/build/tos/gcc
  git clean -dfx

  cmake --toolchain ./gcc${TC_INT_SIZE}.cmk \
    -D CMAKE_BUILD_TYPE=MinSizeRel \
    -D CMAKE_INSTALL_PREFIX=${BLDSTLUA_INSTALL_DIR} \
    -D LIBCMINI_ENABLED=ON \
    ../../..
  make install

  popd
}

# Build and install Lua. This will install the headers needed for tosbindl
build_lua() {
  pushd ${BLDSTLUA_DIR}/../lua/build/tos/gcc
  git clean -dfx

  cmake --toolchain ./gcc${TC_INT_SIZE}.cmk \
    -D CMAKE_BUILD_TYPE=MinSizeRel \
    -D CMAKE_INSTALL_PREFIX=${BLDSTLUA_INSTALL_DIR} \
    -D LIBCMINI_ENABLED=ON \
    -D MLPCE_ENABLED=ON \
    -D MLPCE_SLINPUT_ENABLED=ON \
    -D MLPCE_DEBUGLIB_ENABLED=OFF \
    -D MLPCE_IOLIB_ENABLED=OFF \
    -D MLPCE_MATHLIB_ENABLED=OFF \
    -D MLPCE_OSLIB_ENABLED=OFF \
    -D MLPCE_UTF8LIB_ENABLED=OFF \
    -D MLPCE_REVISION_HEADER_ENABLED=ON \
    -D MLPCE_ONELUA_ENABLED=ON \
    ../../..
  make install

  popd
}

# Build tosbindl
build_tosbindl() {
  pushd ${BLDSTLUA_DIR}/../tosbindl/build/tos/gcc
  git clean -dfx

  cmake --toolchain ./gcc${TC_INT_SIZE}.cmk \
    -D CMAKE_BUILD_TYPE=MinSizeRel \
    -D CMAKE_INSTALL_PREFIX=${BLDSTLUA_INSTALL_DIR} \
    ../../..
  make install

  popd
}

# Now build Lua with tosbindl enabled
build_lua_with_tosbindl() {
  pushd ${BLDSTLUA_DIR}/../lua/build/tos/gcc

  cmake -D MLPCE_TOSBINDL_ENABLED=ON \
    ../../..
  make VERBOSE=1 install

  popd
}

build_libcmini
build_slinput
build_lua
build_tosbindl
build_lua_with_tosbindl

cat ${REVISION_TEXT}
