# Some important parameters
set src_dir "../src"
set includes_dir "../src/includes"
set memory_dir "../build/memory_block"
set dofiles_dir "./dofiles"
set log_dir "./logs"
set tb_dir "../testbench"
set sim_dir "./"
set lib_name "proc_lib"

set vlib ${env(QUESTA_PATH)}/vlib
set vlog ${env(QUESTA_PATH)}/vlog
set vsim ${env(QUESTA_PATH)}/vsim

set xilinx_vivado ${env(XILINX_VIVADO)}

$vlib ${sim_dir}/${lib_name}

$vlog \
   -work ${lib_name} \
   -novopt \
   -l ${log_dir}/glbl.log \
   ${xilinx_vivado}/data/verilog/src/glbl.v

$vlog \
   -work ${lib_name} \
   -novopt \
   -l ${log_dir}/memory_block.log \
   -y ${xilinx_vivado}/data/verilog/src/unisims \
   -y ${xilinx_vivado}/data/verilog/src/unifast \
   -y ${xilinx_vivado}/data/verilog/src/unimacro \
   -y ${xilinx_vivado}/data/secureip \
   -y ${xilinx_vivado}/data/xsim/verilog/simprims_ver \
   +libext+.v \
   +libext+.vh \
   +libext+.sv \
   ${memory_dir}/sim/memory_block.v \
   ${memory_dir}/simulation/blk_mem_gen_v8_3.v

$vlog \
   -work ${lib_name} \
   -novopt \
   -l ${log_dir}/proc.log \
   -y ${src_dir} \
   -y ${xilinx_vivado}/data/verilog/src/unisims \
   -y ${xilinx_vivado}/data/verilog/src/unifast \
   -y ${xilinx_vivado}/data/verilog/src/unimacro \
   -y ${xilinx_vivado}/data/secureip \
   -y ${xilinx_vivado}/data/xsim/verilog/simprims_ver \
   +libext+.v \
   +libext+.vh \
   +libext+.sv \
   +incdir+${includes_dir} \
   ${tb_dir}/absolute_tb.sv

$vsim \
   -t 1ps \
   -novopt \
   -c \
   -do ${dofiles_dir}/proc_sim.do \
   -do "quit -f;" \
   ${lib_name}.absolute_tb
