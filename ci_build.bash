#!/bin/bash
set -e
export BUILD_NUMBER=13
export OPENVR_VERSION=1.23.7

export LWJGL_BUILD_TYPE=release/$VERSION
export LWJGL_BUILD_ARCH=arm64

# Build LWJGL 3
ant -version
ant init
ant \
  -Dbinding.remotery=false \
  -Dbinding.jawt=false \
  -Dbinding.nfd=false \
  -Dbinding.openvr=true \
  -Dplatform.linux=true \
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
  -Dbinding.openvr=true \
  -Dplatform.linux=true \
  -Dbuild.type=release/$VERSION \
  -Dbuild.revision=$BUILD_NUMBER \
  -Dbuild.version=$VERSION \
  -Dopenvr.version=$OPENVR_VERSION \
  -Djavadoc.skip=true \
  -Dnashorn.args="--no-deprecation-warning" \
  release
