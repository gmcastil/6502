onerror {resume}
quietly WaveActivateNextPane {} 0

# -- Clock and Reset
add wave -noupdate -divider "Clock and Reset"
add wave -noupdate -binary /proc_tb/clk_sys
add wave -noupdate -binary -label "Reset" /proc_tb/resetn
add wave -noupdate -binary -label "Clock" /proc_tb/inst_proc/clk

# -- Control Signals
add wave -noupdate -divider "Control Signals"
add wave -noupdate -ascii -label "Present State" /proc_tb/inst_proc/state_ascii
add wave -noupdate -ascii -label "Instruction" /proc_tb/inst_proc/IR_ascii
add wave -noupdate -hex -label "LSB" /proc_tb/inst_proc/operand_LSB
add wave -noupdate -hex -label "MSB" /proc_tb/inst_proc/operand_MSB
add wave -noupdate -binary /proc_tb/inst_proc/update_accumulator
add wave -noupdate -hex /proc_tb/inst_proc/updated_status
add wave -noupdate -hex /proc_tb/inst_proc/decoded_state

# -- Data and Address
add wave -noupdate -divider "Data and Address"
add wave -noupdate -hex -label "Read Data" /proc_tb/inst_proc/rd_data
add wave -noupdate -hex -label "Address" /proc_tb/inst_proc/address
add wave -noupdate -hex -label "Write Data" /proc_tb/inst_proc/wr_data
add wave -noupdate -hex -label "Write Enable" /proc_tb/inst_proc/wr_enable

# -- Processor Registers
add wave -noupdate -divider "Processor Registers"
add wave -noupdate -hex -label "Accumulator" /proc_tb/inst_proc/A
add wave -noupdate -hex -label "X Reg" /proc_tb/inst_proc/X
add wave -noupdate -hex -label "Y Reg" /proc_tb/inst_proc/Y
add wave -noupdate -hex -label "Stack Pointer" /proc_tb/inst_proc/S
add wave -noupdate -hex -label "Program Counter" /proc_tb/inst_proc/PC
add wave -noupdate -hex -label "Instruction Reg" /proc_tb/inst_proc/IR

# -- Processor Status Registers
add wave -noupdate -divider "Processor Status Registers"
add wave -noupdate -binary -label "Carry" /proc_tb/sim_proc_carry;
add wave -noupdate -binary -label "Zero" /proc_tb/sim_proc_zero;
add wave -noupdate -binary -label "IRQ Disable" /proc_tb/sim_proc_irq;
add wave -noupdate -binary -label "BCD Mode" /proc_tb/sim_proc_decimal;
add wave -noupdate -binary -label "Break Instruction" /proc_tb/sim_proc_break_inst;
add wave -noupdate -binary -label "Overflow" /proc_tb/sim_proc_overflow;
add wave -noupdate -binary -label "Negative" /proc_tb/sim_proc_negative;

# -- ALU Signals
add wave -noupdate -divider "ALU Signals"
add wave -noupdate -hex -label "AI" /proc_tb/inst_alu/alu_AI
add wave -noupdate -hex -label "BI" /proc_tb/inst_alu/alu_BI
add wave -noupdate -hex -label "Y" /proc_tb/inst_alu/alu_Y
add wave -noupdate -hex -label "ALU Control " /proc_tb/inst_alu/alu_ctrl
add wave -noupdate -binary -label "Carry In" /proc_tb/inst_alu/alu_carry
add wave -noupdate -hex -label "ALU Flags" /proc_tb/inst_alu/alu_flags
add wave -noupdate -binary -label "BCD" /proc_tb/inst_alu/alu_BCD

# -- ALU Status Registers
add wave -noupdate -divider "ALU Status Registers"
add wave -noupdate -binary -label "Carry" /proc_tb/sim_alu_carry;
add wave -noupdate -binary -label "Zero" /proc_tb/sim_alu_zero;
add wave -noupdate -binary -label "IRQ Disable" /proc_tb/sim_alu_irq;
add wave -noupdate -binary -label "BCD Mode" /proc_tb/sim_alu_decimal;
add wave -noupdate -binary -label "Break Instruction" /proc_tb/sim_alu_break_inst;
add wave -noupdate -binary -label "Overflow" /proc_tb/sim_alu_overflow;
add wave -noupdate -binary -label "Negative" /proc_tb/sim_alu_negative;

update
WaveRestoreZoom {0 ps} {2 us}
