RTLSRCDIR = ../src
TBSRCDIR = ../tb_src
libs:
        vlib forte_rtl_lib
        vlib forte_gls_lib
        vlib forte_tb_lib

compile_rtl:
# compile the vhdl sources DRU and DRU_PHY
        vcom \
        -work forte_rtl_lib \
        -l log1.log \
        $(RTLSRCDIR)/ip/DRU/*.vhd
# compile verilog where file doesn't match module, like encrypted fifo IP
        vlog \
        -work forte_rtl_lib \
        -l log2.log \
        $(RTLSRCDIR)/ip/async_fifo_1w_x_32d/hdl/fifo_generator_v13_1_rfs.v

        vlog \
        -work forte_rtl_lib \
        -l log3.log \
        $(RTLSRCDIR)/ip/async_fifo_1w_x_32d/simulation/fifo_generator_vlog_beh.v

# Xilinx glbl
        vlog \
        -work forte_rtl_lib \
        ${XILINX_VIVADO}/data/verilog/src/glbl.v

# Everything else, note DRU/PHY.sv has to be explicitly compiled because it is instantiated within VHDL,
# compiled previously
        vlog \
        -sv \
        -work forte_rtl_lib \
        -l log4.log \
        -y $(RTLSRCDIR)/rtl \
        -y $(RTLSRCDIR)/ip/DRU \
        -y $(RTLSRCDIR)/ip/PRBS \
        -y $(RTLSRCDIR)/ip/ila_core \
        -y $(RTLSRCDIR)/ip/rx_ila_core \
        -y $(RTLSRCDIR)/ip/async_fifo_1w_x_32d/sim \
        -y ${XILINX_VIVADO}/data/verilog/src/unisims \
        -y ${XILINX_VIVADO}/data/verilog/src/unifast \
        -y ${XILINX_VIVADO}/data/verilog/src/unimacro \
        +libext+.v \
        +libext+.sv \
        $(RTLSRCDIR)/ip/DRU/PHY.sv $(RTLSRCDIR)/rtl/iaps_top.sv
        cat log1.log log2.log log3.log log4.log > compile_logs/compile_rtl.log
        \rm -rf log[1-4].log

compile_tb:
        vlog \
        -sv \
        -l compile_logs/compile_tb.log \
        -work forte_tb_lib \
        $(TBSRCDIR)/tb_iaps.sv
vopt_rtl:
        vopt \
        +acc \
        -work forte_tb_lib \
        -l compile_logs/vopt_rtl.log \
        tb_iaps \
        forte_rtl_lib.glbl \
        -L forte_rtl_lib \
        -o tb_iaps_opt
sim_gui:
        vsim \
        -t 1ps \
        forte_tb_lib.tb_iaps_opt \
        -do "log -r /*; do dofiles/runsim_script.do" \
        -do "do dofiles/iaps_top_BER_ch1_wave.do"

sim:
        vsim \
        -c \
        -t 1ps \
        forte_tb_lib.tb_iaps_opt \
        -do "log -r /*; quit"

compile_gls:
        vlog  \
        -work forte_gls_lib \
        -l compile_logs/compile_gls.log \
        ../build/Forte/iaps_top.vg
# Xilinx glbl
        vlog \
        -work forte_gls_lib \
        ${XILINX_VIVADO}/data/verilog/src/glbl.v

vopt_gls:
        vopt \
        +acc=rpn \
        -work forte_tb_lib \
        -L /apps/qsim_10.5_libs/vivado_2017.2/simprims_ver \
        forte_gls_lib.Forte_Forte_0_0_iaps_top \
        forte_gls_lib.glbl \
        -sdfmax /=../build/Forte/iaps_top.sdf \
        -o iaps_top_g_opt

do_it_all: libs compile_rtl compile_tb vopt_rtl sim

rtl_sim: libs compile_rtl compile_tb vopt_rtl sim_gui

gls_sim: libs compile_gls compile_tb vopt_gls sim_gui

clean:
        \rm -rf *_lib work compile_logs/*.log
