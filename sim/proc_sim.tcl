# Running a simulation

# Some important parameters
set src_dir "../src/"
set includes_dir "../src/includes/"
set xilinx_vivado "/opt/Xilinx/Vivado/2017.1/"
set memory_dir "../build/memory_block/"

# Create the working design library
vlib proc_lib

# Compile the design units into the design library

# The Xilinx global has to be compiled outside for some reason
vlog \
   -work proc_lib \
   -l glbl.log \
   $xilinx_vivado/data/verilog/src/glbl.v

vlog \
   -work proc_lib \
   -novopt \
   -l memory_block.log \
   -y $xilinx_vivado/data/verilog/src/unisims/ \
   -y $xilinx_vivado/data/verilog/src/unifast/ \
   -y $xilinx_vivado/data/verilog/src/unimacro/ \
   +libext+.v \
   +libext+.vh \
   $memory_dir/memory_block_funcsim.v \
   $memory_dir/simulation/blk_mem_gen_v8_3.v \
   $memory_dir/sim/memory_block.v \

vlog \
   -work proc_lib \
   -novopt \
   -l memory_block.log \
   $memory_dir/memory_block_sim_netlist.v

vlog \
   -work proc_lib \
   -novopt \
   -l proc.log \
   -y $src_dir/ \
   -y $xilinx_vivado/data/verilog/src/unisims/ \
   -y $xilinx_vivado/data/verilog/src/unifast/ \
   -y $xilinx_vivado/data/verilog/src/unimacro/ \
   +libext+.v \
   +libext+.vh \
   +incdir+$includes_dir \
   $src_dir/proc_tb.v

# Optimize the design

# Load the design

# Run the simulation
