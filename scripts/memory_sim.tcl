# Set some environment variables

if {$argc == 0} {
    puts "ERROR: Path to a valid COE file must be provided."
    exit 1
} else {
    set coe_file [lindex $argv 0]
}

if {[file exists $coe_file] == 0} {
    puts "ERROR: COE file not found at $coe_file."
    exit 1
}

set working_dir "./working"
if {[file writable $working_dir] == 0} {
    puts "ERROR: No working directory or working directory not writable."
    exit 2
}

set module_name "memory_block"
set module_dir "$working_dir/$module_name/"
set module_sim_name "memory_block_sim"
set module_sim_dir "$working_dir/$module_name\_sim/"

set part "xc7a35tcpg236-1"

# Create a new Vivado project and add the necessary simulation files to it
create_project $module_sim_name $module_sim_dir -part $part

# Memory block files
add_files -norecurse "$module_dir/memory_block.edf"
add_files -norecurse "$module_dir/memory_block.mif"
add_files -norecurse "$module_dir/sim/memory_block.v"
add_files -norecurse "$module_dir/simulation/blk_mem_gen_v8_3.v"
add_files -norecurse $coe_file

# Don't forget the actual memory testbench, too
add_files -norecurse "../src/memory_tb.v"

# Import them into the current project
import_files -force -norecurse
update_compile_order -fileset sources_1

launch_simulation
source memory_tb.tcl
restart
run 656us
save_wave_config $module_sim_dir/memory_tb_behav.wcfg

puts "To open simulation, run vivado $module_sim_dir/$module_sim_dir.sim/sim_1/behav/memory_tb_behav.wdb"
