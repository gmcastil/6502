# Running a simulation

# Some important parameters
set src_dir "../src"
set includes_dir "../src/includes"
set memory_dir "../build/memory_block"
set dofiles "./dofiles"

set vlib ${env(QUESTA_BIN)}/vlib
set vlog ${env(QUESTA_BIN)}/vlog
set vsim ${env(QUESTA_BIN)}/vsim

set xilinx_vivado ${env(XILINX_VIVADO)}

$vlib proc_lib

$vlog \
   -work proc_lib \
   -novopt \
   -l glbl.log \
   ${xilinx_vivado}/data/verilog/src/glbl.v

$vlog \
   -work proc_lib \
   -novopt \
   -l memory_block.log \
   -y ${xilinx_vivado}/data/verilog/src/unisims \
   -y ${xilinx_vivado}/data/verilog/src/unifast \
   -y ${xilinx_vivado}/data/verilog/src/unimacro \
   -y ${xilinx_vivado}/data/secureip \
   -y ${xilinx_vivado}/data/xsim/verilog/simprims_ver \
   +libext+.v \
   +libext+.vh \
   ${memory_dir}/sim/memory_block.v \
   ${memory_dir}/simulation/blk_mem_gen_v8_3.v
   #${memory_dir}/memory_block_stub.v

$vlog \
   -work proc_lib \
   -novopt \
   -l proc.log \
   -y ${src_dir} \
   -y ${xilinx_vivado}/data/verilog/src/unisims \
   -y ${xilinx_vivado}/data/verilog/src/unifast \
   -y ${xilinx_vivado}/data/verilog/src/unimacro \
   -y ${xilinx_vivado}/data/secureip \
   -y ${xilinx_vivado}/data/xsim/verilog/simprims_ver \
   +libext+.v \
   +libext+.vh \
   +incdir+${includes_dir} \
   ${src_dir}/proc_tb.v

set dofiles "./dofiles"
$vsim \
   -t 1ps \
   proc_lib.proc_tb \
   -do "log -r /*" \
   -do "do ${dofiles}/proc_sim_wave.do" \
   -do "do ${dofiles}/runsim.do" \
   -do "quit -sim" \
   -wlf proc_sim.wlf
