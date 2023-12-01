#!/bin/bash

# exit when any command fails
set -e

. assert.sh

# Load emscripten
. /opt/emsdk-3.1.5/emsdk_env.sh

# Build tools
assert_raises "gcc --version"
assert_raises "x86_64-w64-mingw32-gcc --version"
assert_raises "emcc --version"

assert_end barearmgui