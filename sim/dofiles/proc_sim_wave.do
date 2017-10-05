onerror {resume}
quietly WaveActivateNextPane {} 0

# -- Clock and Reset
add wave -noupdate -divider "Clock and Reset"
add wave -noupdate -binary /proc_tb/clk_sys
add wave -noupdate -binary /proc_tb/resetn
add wave -noupdate -binary /proc_tb/inst_proc/clk

# -- Processor Registers
add wave -noupdate -divider "Processor Registers"
add wave -noupdate -hex /proc_tb/inst_proc/A
add wave -noupdate -hex /proc_tb/inst_proc/X
add wave -noupdate -hex /proc_tb/inst_proc/Y
add wave -noupdate -hex /proc_tb/inst_proc/S
add wave -noupdate -hex /proc_tb/inst_proc/PC
add wave -noupdate -hex /proc_tb/inst_proc/IR
add wave -noupdate -hex /proc_tb/inst_proc/P

# -- Data and Address
add wave -noupdate -divider "Data and Address"
add wave -noupdate -hex /proc_tb/inst_proc/rd_data
add wave -noupdate -hex /proc_tb/inst_proc/address
add wave -noupdate -hex /proc_tb/inst_proc/wr_data
add wave -noupdate -hex /proc_tb/inst_proc/wr_enable

# -- Control Signals
add wave -noupdate -divider "Control Signals"
add wave -noupdate -ascii -label "Present State" /proc_tb/inst_proc/state_ascii
add wave -noupdate -ascii -label "Instruction" /proc_tb/inst_proc/IR_ascii
add wave -noupdate -hex /proc_tb/inst_proc/operand_LSB
add wave -noupdate -hex /proc_tb/inst_proc/operand_MSB
add wave -noupdate -binary /proc_tb/inst_proc/update_accumulator
add wave -noupdate -hex /proc_tb/inst_proc/updated_status
add wave -noupdate -hex /proc_tb/inst_proc/decoded_state

# -- ALU Signals
add wave -noupdate -divider "ALU Signals"
add wave -noupdate -hex -label "AI" /proc_tb/inst_proc/alu_AI
add wave -noupdate -hex -label "BI" /proc_tb/inst_proc/alu_BI
add wave -noupdate -hex -label "Y" /proc_tb/inst_proc/alu_Y
add wave -noupdate -hex -label "ALU Control " /proc_tb/inst_proc/alu_ctrl
add wave -noupdate -binary -label "Carry In" /proc_tb/inst_proc/alu_carry
add wave -noupdate -hex -label "ALU Flags" /proc_tb/inst_proc/alu_flags
add wave -noupdate -binary -label "BCD" /proc_tb/inst_proc/alu_BCD

update
WaveRestoreZoom {0 ps} {2 us}
