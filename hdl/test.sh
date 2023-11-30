#!/bin/bash

# exit when any command fails
set -e

. assert.sh

# Synthesis
assert_raises "yosys --version"

# Place and route
assert_raises "nextpnr-generic --version"
assert_raises "nextpnr-ice40 --version"
assert_raises "nextpnr-ecp5 --version"
assert_raises "nextpnr-nexus --version"

# Trellis tools
assert_raises "ecpbram --help"
assert_raises "ecpmulti --help"
assert_raises "ecppack --version"
assert_raises "ecppll --help"
assert_raises "ecpunpack --help"

# Simulation
assert_raises "ghdl --version"
assert_raises "iverilog -V"
assert_raises "vvp -V"

# Programming tools
assert_raises "openocd --version"
assert_raises "openocd -c 'adapter driver dummy' -c 'shutdown'"
assert_raises "openFPGALoader --Version"

assert_end hdl