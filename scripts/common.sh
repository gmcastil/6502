#!/usr/bin/env bash

# Some common environment variables, paths, and function definitions.  It is
# intended that this script is sourced by every other Bash script in the
# project

# Common paths and directories for scripting
export SRC_DIR="../src/"
export WORKING_DIR="./working/"
export LOG_DIR="$WORKING_DIR/logs/"
export REPORT_DIR="$WORKING_DIR/reports/"

# Common executable paths
export xilinx="/opt/Xilinx/Vivado/2017.1/bin/"
export vivado="$xilinx/vivado"
export xvlog="$xilinx/xvlog"
export xelab="$xilinx/xelab"
export xsim="$xilinx/xsim"

export COLORIZE="./severity.py"
