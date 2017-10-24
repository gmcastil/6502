#!/usr/bin/env bash

set -o errexit  # -e
set -o nounset  # -u
set -o pipefail
IFS=$'\n\t'

# Constructs a 64KB memory block for use in simulating the 6502
# processor core.  The only required parameter is a path to a readable
# .coe file containing the desired memory contents.

# The build script calls Vivado in batch mode with a Tcl script, which
# generates the IP block and extracts an EDIF netlist. Once this has
# been performed, the memory_sim.sh script can be run, which allows
# inspection of the contents of the generated IP. Alternatively, the
# proc_sim.sh can be run which simulates the processor coming out of
# reset, reading the reset vector, and then executing whatever program
# was loaded into the memory (i.e., the contents of the .coe file).

common="./common.sh"

if [[ -x "$common" ]]; then
    source $common
else
    echo "ERROR: $common missing or not executable." | $COLORIZE
    exit 1
fi

# Using positional arguments is a bit more involved in strict mode
coe_file=${1:-}
if [[ -z "$coe_file" ]]; then
    echo "Usage: $0 filename"
    exit 1
else
    coe_file=$(readlink -f "$coe_file")
fi

# Delete the old version, if it exists
if [[ -d "$BUILD_DIR" ]]; then
    rm -rf "$BUILD_DIR"
fi

mkdir -pv "$BUILD_DIR"

# Create the memory block and read out the EDIF netlist (from the Tcl script)
$vivado -verbose \
        -notrace \
        -mode batch -source memory_gen.tcl \
        -tclargs "$coe_file" | $COLORIZE

# The memory block is now located inside $BUILD_DIR/memory_block/
if [[ ! -f "$BUILD_DIR/memory_block/memory_block.edf" ]]; then
    echo "ERROR: Problem creating EDIF netlist" | $COLORIZE
    exit 1
fi
