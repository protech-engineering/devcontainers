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

# Python is not supported
# assert "arm-none-eabi-gdb -batch -ex 'python print(\"OK\")'" "OK"

assert_end barearm