set testbench "proc_tb"
puts "Beginning processor simulation..."

onerror {resume}
quietly WaveActivateNextPane {} 0

# -- Clock and Reset
add wave -noupdate -divider "Clock and Reset"
add wave -noupdate -binary -label "resetn" /$testbench/resetn
add wave -noupdate -binary -label "clk" /$testbench/inst_proc/clk

# -- Control Signals
add wave -noupdate -divider "Control Signals"
add wave -noupdate -ascii -label "Present State" /$testbench/inst_proc/state_ascii
add wave -noupdate -ascii -label "Instruction" /$testbench/inst_proc/IR_ascii
add wave -noupdate -hex -label "LSB" /$testbench/inst_proc/operand_LSB
add wave -noupdate -hex -label "MSB" /$testbench/inst_proc/operand_MSB
add wave -noupdate -binary /$testbench/inst_proc/updated_accumulator
add wave -noupdate -hex /$testbench/inst_proc/updated_status
add wave -noupdate -hex /$testbench/inst_proc/decoded_state

# -- Data and Address
add wave -noupdate -divider "Data and Address"
add wave -noupdate -hex -label "Write Data" /$testbench/inst_proc/wr_data
add wave -noupdate -hex -label "Read Data" /$testbench/inst_proc/rd_data
add wave -noupdate -hex -label "Address" /$testbench/inst_proc/address
add wave -noupdate -hex -label "Write Enable" /$testbench/inst_proc/wr_enable

# -- Processor Registers
add wave -noupdate -divider "Processor Registers"
add wave -noupdate -hex -label "A" /$testbench/inst_proc/A
add wave -noupdate -hex -label "X" /$testbench/inst_proc/X
add wave -noupdate -hex -label "Y" /$testbench/inst_proc/Y
add wave -noupdate -hex -label "S" /$testbench/inst_proc/S
add wave -noupdate -hex -label "PC" /$testbench/inst_proc/PC
add wave -noupdate -hex -label "IR" /$testbench/inst_proc/IR

# -- Processor Status Registers
add wave -noupdate -divider "Processor Status Registers"
add wave -noupdate -binary -label "Carry" /$testbench/carry;
add wave -noupdate -binary -label "Zero" /$testbench/zero;
add wave -noupdate -binary -label "IRQ Disable" /$testbench/irq;
add wave -noupdate -binary -label "BCD Mode" /$testbench/decimal;
add wave -noupdate -binary -label "Break Instruction" /$testbench/break_inst;
add wave -noupdate -binary -label "Overflow" /$testbench/overflow;
add wave -noupdate -binary -label "Negative" /$testbench/negative;

# -- ALU Signals
add wave -noupdate -divider "ALU Signals"
add wave -noupdate -hex -label "ALU Control " /$testbench/inst_proc/inst_alu/alu_control
add wave -noupdate -hex -label "AI" /$testbench/inst_proc/inst_alu/alu_AI
add wave -noupdate -hex -label "BI" /$testbench/inst_proc/inst_alu/alu_BI
add wave -noupdate -binary -label "Carry In" /$testbench/inst_proc/inst_alu/alu_carry_in
add wave -noupdate -hex -label "Y" /$testbench/inst_proc/inst_alu/alu_Y
add wave -noupdate -binary -label "Carry Out" /$testbench/inst_proc/inst_alu/alu_carry_out
add wave -noupdate -hex -label "Overflow" /$testbench/inst_proc/inst_alu/alu_overflow

update
WaveRestoreZoom {0 ps} {2 us}
