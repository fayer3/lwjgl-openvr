#!/bin/bash
set -e
export BUILD_NUMBER=10
export OPENVR_VERSION=1.3.22

export LWJGL_BUILD_TYPE=release/$VERSION
export LWJGL_BUILD_ARCH=arm64

# build dyncall
# remove previous instance if there
rm -rf dyncall

git clone https://github.com/LWJGL-CI/dyncall
cd dyncall
CC=aarch64-linux-gnu-gcc AS=aarch64-linux-gnu-gcc ./configure
CC=aarch64-linux-gnu-gcc AS=aarch64-linux-gnu-gcc make
# exit dyncall
cd ..

# copy libs
mkdir -p ./bin/libs/linux/arm64
cp ./dyncall/dyncall/libdyncall_s.a ./bin/libs/linux/arm64
cp ./dyncall/dyncallback/libdyncallback_s.a ./bin/libs/linux/arm64
cp ./dyncall/dynload/libdynload_s.a ./bin/libs/linux/arm64


# Build LWJGL 3
ant -version
ant init

ant \
  -Dbinding.remotery=false \
  -Dbinding.jawt=false \
  -Dbinding.nfd=false \
  -Dbinding.glfw=false \
  -Dbinding.bgfx=false \
  -Dbinding.opus=false \
  -Dbinding.assimp=false \
  -Dbinding.openal=false \
  -Dbinding.jemalloc=false \
  -Dbinding.openvr=true \
  -Dplatform.linux=true \
  -Dlwjgl.arch=arm64 \
  -Dbuild.type=release/$VERSION \
  -Dbuild.revision=$BUILD_NUMBER \
  -Dbuild.version=$VERSION \
  -Dopenvr.version=$OPENVR_VERSION \
  -Djavadoc.skip=true \
  -Dnashorn.args="--no-deprecation-warning" \
  compile-templates generate compile compile-native

# release offline, since we want our library
export LWJGL_BUILD_OFFLINE=true
ant \
  -Dbinding.remotery=false \
  -Dbinding.jawt=false \
  -Dbinding.nfd=false \
  -Dbinding.glfw=false \
  -Dbinding.bgfx=false \
  -Dbinding.opus=false \
  -Dbinding.assimp=false \
  -Dbinding.openal=false \
  -Dbinding.jemalloc=false \
  -Dbinding.openvr=true \
  -Dplatform.linux=true \
  -Dlwjgl.arch=arm64 \
  -Dbuild.type=release/$VERSION \
  -Dbuild.revision=$BUILD_NUMBER \
  -Dbuild.version=$VERSION \
  -Dopenvr.version=$OPENVR_VERSION \
  -Djavadoc.skip=true \
  -Dnashorn.args="--no-deprecation-warning" \
  release
