SRC_DIR="../src/"

XILINX_VIVADO="/opt/Xilinx/Vivado/2017.1/"

# Parse design files
xvlog -work work \
      $SRC_DIR/memory_top_tb.v \
      $SRC_DIR/memory_top.v \
      $SRC_DIR/memory_block.v \
      $SRC_DIR/memc.v \
      $XILINX_VIVADO/data/verilog/src/unimacro/BRAM_SINGLE_MACRO.v \
      $XILINX_VIVADO/data/verilog/src/glbl.v

# Elaborate and generate a design snapshot
xelab -debug typical -L glbl -L unimacro memory_top_tb

# Simulate the design snapshot
xsim memory_sim -t memory_sim.tcl
