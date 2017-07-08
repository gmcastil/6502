# Creates a 64KB RAM from a COE file which must be provided as an argument
# at runtime.  This script is intended to be used to call Vivado in batch mode
# with -tclargs.
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

# Set some environment variables
set working_dir "./working"
if {[file writable $working_dir] == 0} {
    puts "ERROR: No working directory or working directory not writable."
    exit 2
}

set module_name "memory_block"
set module_dir "$working_dir/$module_name/"
set managed_ip_dir "$working_dir/managed_ip_project"

set part "xc7a35tcpg236-1"

# Create managed IP project
create_project managed_ip_project $managed_ip_dir -part $part -ip
set_property target_simulator XSim [current_project]

# Set IP properties
create_ip \
    -name blk_mem_gen \
    -vendor xilinx.com \
    -library ip \
    -version 8.3 \
    -module_name $module_name \
    -dir $working_dir

set_property -dict [list \
                        CONFIG.Write_Width_A {8} \
                        CONFIG.Write_Depth_A {65536} \
                        CONFIG.Load_Init_file {true} \
                        CONFIG.Coe_File $coe_file \
                        CONFIG.Read_Width_A {8} \
                        CONFIG.Write_Width_B {8} \
                        CONFIG.Read_Width_B {8}] [get_ips $module_name]

generate_target {instantiation_template} [get_files $module_dir/$module_name.xci]

generate_target all [get_files $module_dir/$module_name.xci]

export_ip_user_files \
    -of_objects [get_files $module_dir/$module_name.xci] \
    -no_script \
    -sync \
    -force \
    -quiet

create_ip_run [get_files -of_objects [get_fileset sources_1] $module_dir/$module_name.xci]

# Now synthesize, wait for it to complete and check the status afterwards
set synth_run $module_name\_synth_1
launch_runs -jobs 4 $synth_run
wait_on_run $synth_run
if {[get_property PROGRESS [get_runs $synth_run]] != "100%"} {
    error "ERROR: $synth_ruin failed"
    exit 2
}

# Now read out the EDIF netlist from the DCP that was created during synthesis
open_checkpoint "$module_name.dcp"
write_edif -verbose -force "$module_name.edf"
