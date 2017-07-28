#!/usr/bin/env bash

# Sim the processor and associated operations - assumes installation of Vivado
# 2017.1 is installed in /opt/

vivado_root="/opt/Xilinx/Vivado/2017.1/bin/"
vivado=$vivado_root/vivado
xvlog=$vivado_root/xvlog
xsim=$vivado_root/xsim

root_dir="../"
src_dir="$root_dir/src/"

if [[ ! -d $vivado_root ]]; then
    echo "Vivado Design Suite not found at $vivado_root."
    return 1
fi

# Read in source code and test bench

# Run simulator
