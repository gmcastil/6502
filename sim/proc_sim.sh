#!/usr/bin/env bash

set -o errexit  # -e
set -o nounset  # -u
set -o pipefail
IFS=$'\n\t'

sim_dir="./proc_lib/"

if [[ -d $sim_dir ]]; then
    rm -rf $sim_dir
fi

vsim -c -do proc_sim.tcl
