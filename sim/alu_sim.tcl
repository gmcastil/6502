# Runs a simulation for the 6502 ALU

set src_dir "../src"
set includes_dir "../src/includes"
set testbench_dir "../testbench"
set dofiles_dir "./dofiles"

set vlib ${env(QUESTA_BIN)}/vlib
set vlog ${env(QUESTA_BIN)}/vlog
set vsim ${env(QUESTA_BIN)}/vsim

set xilinx_vivado ${env(XILINX_VIVADO)}

set library_name "alu_lib"

# Create an empty library before compiling source code into a compiled
# database
$vlib $library_name

# Compile the global set/reset library
$vlog \
   -work $library_name \
   -novopt \
   -l glbl.log\
   $xilinx_vivado/data/verilog/src/glbl.v

# Compile ALU source and testbench
$vlog \
   -work $library_name \
   -novopt \
   -l alu.log \
   -y $src_dir \
   -y $xilinx_vivado/data/verilog/src/unisims \
   -y $xilinx_vivado/data/verilog/src/unifast \
   -y $xilinx_vivado/data/verilog/src/unimacro \
   -y $xilinx_vivado/data/secureip \
   -y $xilinx_vivado/data/xsim/verilog/simprims_ver \
   +libext+.v \
   +libext+.vh \
   +incdir+$includes_dir \
   $testbench_dir/alu_tb.sv

# Finally, run the entire simulation
do $dofiles_dir/alu_sim.do
