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

start_gui
create_project managed_ip_project /home/castillo/code/managed_ip_project -part xc7a35tcpg236-1 -ip
INFO: [IP_Flow 19-234] Refreshing IP repositories
INFO: [IP_Flow 19-1704] No user IP repositories specified
INFO: [IP_Flow 19-2313] Loaded Vivado IP repository '/opt/Xilinx/Vivado/2017.1/data/ip'.
set_property target_simulator XSim [current_project]
create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.3 -module_name memory_block -dir /home/castillo/code
set_property -dict [list CONFIG.Write_Width_A {8} CONFIG.Write_Depth_A {65536} CONFIG.Load_Init_File {true} CONFIG.Coe_File {/home/castillo/code/6502/scripts/basic.coe} CONFIG.Read_Width_A {8} CONFIG.Write_Width_B {8} CONFIG.Read_Width_B {8}] [get_ips memory_block]
INFO: [IP_Flow 19-3484] Absolute path of file '/home/castillo/code/6502/scripts/basic.coe' provided. It will be converted relative to IP Instance files '../6502/scripts/basic.coe'
generate_target {instantiation_template} [get_files /home/castillo/code/memory_block/memory_block.xci]
INFO: [IP_Flow 19-1686] Generating 'Instantiation Template' target for IP 'memory_block'...
generate_target all [get_files  /home/castillo/code/memory_block/memory_block.xci]
INFO: [IP_Flow 19-1686] Generating 'Synthesis' target for IP 'memory_block'...
INFO: [IP_Flow 19-1686] Generating 'Simulation' target for IP 'memory_block'...
INFO: [IP_Flow 19-1686] Generating 'Miscellaneous' target for IP 'memory_block'...
INFO: [IP_Flow 19-1686] Generating 'Change Log' target for IP 'memory_block'...
generate_target: Time (s): cpu = 00:00:06 ; elapsed = 00:00:06 . Memory (MB): peak = 6198.676 ; gain = 0.000 ; free physical = 28829 ; free virtual = 37731
export_ip_user_files -of_objects [get_files /home/castillo/code/memory_block/memory_block.xci] -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] /home/castillo/code/memory_block/memory_block.xci]
launch_runs -jobs 4 memory_block_synth_1
[Mon Jul  3 16:36:20 2017] Launched memory_block_synth_1...
Run output will be captured here: /home/castillo/code/managed_ip_project/managed_ip_project.runs/memory_block_synth_1/runme.log
export_simulation -of_objects [get_files /home/castillo/code/memory_block/memory_block.xci] -directory /home/castillo/code/ip_user_files/sim_scripts -ip_user_files_dir /home/castillo/code/ip_user_files -ipstatic_source_dir /home/castillo/code/ip_user_files/ipstatic -lib_map_path [list {modelsim=/home/castillo/code/managed_ip_project/managed_ip_project.cache/compile_simlib/modelsim} {questa=/home/castillo/code/managed_ip_project/managed_ip_project.cache/compile_simlib/questa} {ies=/home/castillo/code/managed_ip_project/managed_ip_project.cache/compile_simlib/ies} {vcs=/home/castillo/code/managed_ip_project/managed_ip_project.cache/compile_simlib/vcs} {riviera=/home/castillo/code/managed_ip_project/managed_ip_project.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet
close_project

# Build the memory block
# From the design checkpoint, extract the EDIF netlist
# Find the simulation
# Need the following files:
#  - .mif file in lieu of the coe file
#  -
#
#
