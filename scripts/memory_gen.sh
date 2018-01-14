#!/usr/bin/env bash

# Constructs a 64KB memory block for use in simulating the 6502
# processor core.  The only required parameter is a path to a readable
# .coe file containing the desired memory contents.

set -o errexit  # -e
set -o nounset  # -u
set -o pipefail
IFS=$' \n\t'

# External environment needs to specify Xilinx tools location
vivado="$XILINX_VIVADO/bin/vivado"

build_dir="../build"

# Require a coefficients file to be provided
coe_file=${1:-}
if [[ -z "$coe_file" ]]; then
    echo "Usage: $0 [COE_FILE]"
    exit 1
else
    coe_file=$(readlink -f "$coe_file")
fi

# Delete the old version, if it exists
if [[ -d "$build_dir" ]]; then
    rm -rf "$build_dir"
fi
mkdir -pv "$build_dir"

# Create the memory block
$vivado -verbose \
        -notrace \
        -mode batch -source memory_gen.tcl \
        -tclargs "$coe_file"

# The memory block is now located inside $build_dir/memory_block/
if [[ ! -f "$build_dir/memory_block/memory_block.edf" ]]; then
    echo "ERROR: Problem creating EDIF netlist"
    exit 1
fi

# Check for location of other output products
