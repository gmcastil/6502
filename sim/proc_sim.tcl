# Running a simulation

# Some important parameters
set src_dir "../src/"
set includes_dir "../src/includes/"
set xilinx_vivado "/opt/Xilinx/Vivado/2017.1/"
set memory_dir "../build/memory_block/"

# Create the working design library
vlib proc_lib

# The Xilinx global has to be compiled outside for some reason
vlog \
   -work proc_lib \
   -l glbl.log \
   $xilinx_vivado/data/verilog/src/glbl.v

vlog \
   -work proc_lib \
   -l memory_block.log \
   -y $xilinx_vivado/data/verilog/src/unisims/ \
   -y $xilinx_vivado/data/verilog/src/unifast/ \
   -y $xilinx_vivado/data/verilog/src/unimacro/ \
   -y $xilinx_vivado/data/secureip/ \
   -y $xilinx_vivado/data/xsim/verilog/simprims_ver \
   +libext+.v \
   +libext+.vh \
   $memory_dir/memory_block_stub.v

vlog \
   -work proc_lib \
   -l proc.log \
   -y $src_dir/ \
   -y $xilinx_vivado/data/verilog/src/unisims/ \
   -y $xilinx_vivado/data/verilog/src/unifast/ \
   -y $xilinx_vivado/data/verilog/src/unimacro/ \
   -y $xilinx_vivado/data/secureip/ \
   -y $xilinx_vivado/data/xsim/verilog/simprims_ver \
   +libext+.v \
   +libext+.vh \
   +incdir+$includes_dir \
   $src_dir/proc_tb.v

vsim \
   -t 1ps \
   proc_lib.proc_tb \
   -do "log -r /*;"
