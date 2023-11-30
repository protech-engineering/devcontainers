#!/bin/bash

# exit when any command fails
set -e

. assert.sh

assert_raises "true"

assert_end barearm