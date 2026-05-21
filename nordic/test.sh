#!/bin/bash

# exit when any command fails
set -e

. assert.sh

# Test tools
assert_raises "clangd --version"
assert_raises "nrfutil --version"
assert_raises "west --version"

# Nordic SDK environment
assert_raises "test -n \"\$NRFUTIL_HOME\" && test -d \"\$NRFUTIL_HOME\""
assert_raises "test -n \"\$ZEPHYR_SDK_INSTALL_DIR\" && test -d \"\$ZEPHYR_SDK_INSTALL_DIR\""
assert_raises "command -v JLinkExe"
assert_raises "nrfutil list | grep -q device"

assert_end zephyr