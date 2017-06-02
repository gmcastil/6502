# Build script for synthesis of the memory module and wrapper files

set src_dir ../src/
set build_dir ../build/
set constraints_dir ../constraints/

set part xc7a35tcpg236-1

read_verilog "$src_dir/memc.v
              $src_dir/memory_block.v
              $src_dir/memory_top.v"

# Read constraints

# Synthesize design
synth_design -top memory_top.v -part $part
