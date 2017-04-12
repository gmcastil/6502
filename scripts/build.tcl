# Make normal environment variables accesible to this script
global env

# and define the target board and device
set_property

# read in RTL
read_verilog $src_dir/6502.sv
read_verilog $src_dir/porf_gen.v

# read in IP

# read in constraints

# synthesize design
synth_design

# generate post-synthesis design checkpoint

# timing reports

# link design

# optimize design

# place design

# optimize physical design

# route design

# report timing summary

# post route timing report

#
