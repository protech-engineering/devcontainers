#!/bin/bash

# exit when any command fails
set -e

. assert.sh

# Test tools
assert_raises "clangd --version"

assert_end zephyr