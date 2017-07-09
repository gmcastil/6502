#!/usr/bin/env bash

set -o errexit  # -e
set -o nounset  # -u
set -o pipefail
IFS=$'\n\t'

# Simulates the 64KB memory block created by the memory_gen.sh script
# using the testbench in /6502/src/

common="./common.sh"

if [[ -x "$common" ]]; then
    source $common
else
    echo "ERROR: $common missing or not executable." | $COLORIZE
    exit 1
fi

ip_dir="$WORKING_DIR/memory_block/"

coe_file=${1:-}
if [[ -z "$coe_file" ]]; then
    echo "Usage: $0 filename"
    exit 1
else
    coe_file=`realpath $coe_file`
fi

# Make sure that the IP has been generated and if so, create a directory
# to start doing simulation
ip_dir="$WORKING_DIR/memory_block/"
if [[ ! -d $ip_dir ]]; then
    echo "ERROR: Nothing found in $ip_dir"
    exit 1
else
    # Remove any existing sim directory and make a new one
    if [[ -d "$ip_dir/memory_block_sim/" ]]; then
        rm -rf "$ip_dir/memory_block_sim/"
    fi
    mkdir -pv "$WORKING_DIR/memory_block_sim/"
fi

$vivado -verbose \
        -mode batch \
        -source memory_sim.tcl \
        -tclargs $coe_file | $COLORIZE
