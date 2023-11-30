#!/bin/bash

# exit when any command fails
set -e

. assert.sh

# Test toolchain components
assert_raises "xtensa-esp32-elf-gcc --version"
assert_raises "xtensa-esp32-elf-gdb --version"
assert_raises "xtensa-esp32-elf-objcopy --version"
assert_raises "make --version"
assert_raises "ninja --version"
assert_raises "cmake --version"

# Test tools
assert_raises "idf.py --version"
assert_raises "clangd --version"

# Test programming tools
assert_raises "openocd --version"

assert_end esp