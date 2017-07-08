#!/usr/bin/env bash

set -o errexit  # -e
set -o nounset  # -u
set -o pipefail
IFS=$'\n\t'

export SRC_DIR="../src/"
export WORKING_DIR="./working/"
export LOG_DIR="$WORKING_DIR/logs/"
export REPORT_DIR="$WORKING_DIR/reports/"

vivado="/opt/Xilinx/Vivado/2017.1/bin/vivado"

# Using positional arguments is a bit more involved in strict mode
coe_file=${1:-}
if [[ -z "$coe_file" ]]; then
    echo "Usage: $0 filename"
    exit 1
else
    coe_file=`realpath $coe_file`
fi

if [[ -d $WORKING_DIR ]]; then
    rm -rf $WORKING_DIR
fi

mkdir -pv $WORKING_DIR

# Build the memory block using the Block Memory Generator inside
# Vivado
$vivado -notrace -verbose -mode batch -source memory.tcl -tclargs $coe_file | ./severity.py

# The memory block is now located inside $WORKING_DIR/memory_block/
