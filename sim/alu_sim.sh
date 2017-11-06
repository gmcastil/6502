#!/usr/bin/env bash

set -o errexit  # -e
set -o nounset  # -u
set -o pipefail
IFS=$'\n\t'

# Make these available to the Tcl interpreter
export QUESTA_BIN="/opt/Altera/intelFPGA_pro/17.0/modelsim_ase/linux"
export XILINX_VIVADO="/opt/Xilinx/Vivado/2017.1"

sim_dir="./alu_lib"

if [[ -d "$sim_dir" ]]; then
    rm -rf "$sim_dir"
fi

vsim -c -do alu_sim.tcl
