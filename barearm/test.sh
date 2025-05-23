#!/bin/bash

# exit when any command fails
set -e

. assert.sh

# Test toolchain components
assert_raises "arm-none-eabi-gcc --version"
assert_raises "arm-none-eabi-gdb --version"
assert_raises "arm-none-eabi-objcopy --version"
assert_raises "make --version"
assert_raises "cmake --version"

# Test tools
assert_raises "bear --version"
assert_raises "picocom --help"
assert_raises "clangd --version"

# Test programming tools
assert_raises "pyocd --version"
assert_raises "openocd --version"
assert_raises "openocd -c 'adapter driver dummy' -c 'shutdown'"
assert_raises "st-util --version"
assert_raises "st-flash --version"
assert_raises "STM32_Programmer_CLI --version"

# Test orbuculum
assert_raises "orbcat --version" 255
assert_raises "orbtop --version" 234

# Test gdb
assert "arm-none-eabi-gdb-py -batch -ex 'python print(\"OK\")'" "OK"
# Test all pyocd packs have been downloaded
assert "find ~/.local/share/cmsis-pack-manager/ -type d -empty | wc -l" "0"

assert_end barearm
