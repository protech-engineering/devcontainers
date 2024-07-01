#!/bin/bash

# exit when any command fails
set -e

. assert.sh

# Nordic tools
assert_raises "nrfutil version"
assert_raises "ble-serial --help"
assert_raises "which JLinkExe"
assert_raises "nrfjprog --version"

assert_end barearmgui