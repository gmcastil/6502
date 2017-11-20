#!/usr/bin/env bash

set -o errexit  # -e
set -o nounset  # -u
set -o pipefail
IFS=$'\n\t'

# For now, just make sure that it's been called with a valid prefix
if [[ "$#" -eq 0 ]]; then
    echo "Usage: proc_sim <mode>"
    exit 1
else
    mode="${1:-}"
fi

# Make these available to the Tcl interpreter
export QUESTA_PATH="/opt/Altera/intelFPGA_pro/17.0/modelsim_ase/linux"
export XILINX_VIVADO="/opt/Xilinx/Vivado/2017.1"

# Require a memory_block simulation model to exist before continuing
# memory_dir="../build/memory_block"
# if [[ ! -f "$memory_dir/memory_block.v" ]]; then
#     echo "ERROR: No block RAM simulation model found."
#     exit 1
# fi

sim_dir=./"$mode"_lib/
if [[ -d "$sim_dir" ]]; then
    rm -rf "$sim_dir"
fi

echo "INFO: Creating simulation directory $(pwd -P)/$sim_dir"
mkdir -p "$sim_dir"

# Look for the appropriate simulation .asm file to use

# Compile the .asm file into a .mif

# Move the .mif into the /sim directory

vsim -c -do "$mode"_sim.tcl
