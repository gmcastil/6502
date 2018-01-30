set testbench "${env(TESTBENCH)}_tb"
puts "Simulation of $testbench addressing mode"

onerror {resume}
quietly WaveActivateNextPane {} 0

# -- Clock and Reset
add wave -noupdate -divider "Clock and Reset"
add wave -noupdate -binary /$testbench/clk_sys
add wave -noupdate -binary -label "Reset" /$testbench/resetn
add wave -noupdate -binary -label "Clock" /$testbench/inst_proc/clk

# -- Control Signals
add wave -noupdate -divider "Control Signals"
add wave -noupdate -ascii -label "Present State" /$testbench/inst_proc/state_ascii
add wave -noupdate -ascii -label "Instruction" /$testbench/inst_proc/IR_ascii
add wave -noupdate -hex -label "LSB" /$testbench/inst_proc/operand_LSB
add wave -noupdate -hex -label "MSB" /$testbench/inst_proc/operand_MSB
add wave -noupdate -binary /$testbench/inst_proc/update_accumulator
add wave -noupdate -hex /$testbench/inst_proc/updated_status
add wave -noupdate -hex /$testbench/inst_proc/decoded_state

# -- Data and Address
add wave -noupdate -divider "Data and Address"
add wave -noupdate -hex -label "Read Data" /$testbench/inst_proc/rd_data
add wave -noupdate -hex -label "Address" /$testbench/inst_proc/address
add wave -noupdate -hex -label "Write Data" /$testbench/inst_proc/wr_data
add wave -noupdate -hex -label "Write Enable" /$testbench/inst_proc/wr_enable

# -- Processor Registers
add wave -noupdate -divider "Processor Registers"
add wave -noupdate -hex -label "Accumulator" /$testbench/inst_proc/A
add wave -noupdate -hex -label "X Reg" /$testbench/inst_proc/X
add wave -noupdate -hex -label "Y Reg" /$testbench/inst_proc/Y
add wave -noupdate -hex -label "Stack Pointer" /$testbench/inst_proc/S
add wave -noupdate -hex -label "Program Counter" /$testbench/inst_proc/PC
add wave -noupdate -hex -label "Instruction Reg" /$testbench/inst_proc/IR

# -- Processor Status Registers
add wave -noupdate -divider "Processor Status Registers"
add wave -noupdate -binary -label "Carry" /$testbench/sim_proc_carry;
add wave -noupdate -binary -label "Zero" /$testbench/sim_proc_zero;
add wave -noupdate -binary -label "IRQ Disable" /$testbench/sim_proc_irq;
add wave -noupdate -binary -label "BCD Mode" /$testbench/sim_proc_decimal;
add wave -noupdate -binary -label "Break Instruction" /$testbench/sim_proc_break_inst;
add wave -noupdate -binary -label "Overflow" /$testbench/sim_proc_overflow;
add wave -noupdate -binary -label "Negative" /$testbench/sim_proc_negative;

# -- ALU Signals
add wave -noupdate -divider "ALU Signals"
add wave -noupdate -hex -label "AI" /$testbench/inst_alu/alu_AI
add wave -noupdate -hex -label "BI" /$testbench/inst_alu/alu_BI
add wave -noupdate -hex -label "Y" /$testbench/inst_alu/alu_Y
add wave -noupdate -hex -label "ALU Control " /$testbench/inst_alu/alu_ctrl
add wave -noupdate -binary -label "Carry In" /$testbench/inst_alu/alu_carry
add wave -noupdate -hex -label "ALU Flags" /$testbench/inst_alu/alu_flags
add wave -noupdate -binary -label "BCD" /$testbench/inst_alu/alu_BCD

# -- ALU Status Registers
add wave -noupdate -divider "ALU Status Registers"
add wave -noupdate -binary -label "Carry" /$testbench/sim_alu_carry;
add wave -noupdate -binary -label "Zero" /$testbench/sim_alu_zero;
add wave -noupdate -binary -label "IRQ Disable" /$testbench/sim_alu_irq;
add wave -noupdate -binary -label "BCD Mode" /$testbench/sim_alu_decimal;
add wave -noupdate -binary -label "Break Instruction" /$testbench/sim_alu_break_inst;
add wave -noupdate -binary -label "Overflow" /$testbench/sim_alu_overflow;
add wave -noupdate -binary -label "Negative" /$testbench/sim_alu_negative;

update
WaveRestoreZoom {0 ps} {2 us}
