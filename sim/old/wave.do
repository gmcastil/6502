onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Processor Signals}
add wave -noupdate /proc_top_tb/inst_proc/clk
add wave -noupdate /proc_top_tb/inst_proc/resetn
add wave -noupdate -radix hexadecimal /proc_top_tb/inst_proc/wr_data
add wave -noupdate -radix hexadecimal /proc_top_tb/inst_proc/rd_data
add wave -noupdate -radix hexadecimal /proc_top_tb/inst_proc/address
add wave -noupdate -radix ascii /proc_top_tb/inst_proc/state_ascii
add wave -noupdate -radix ascii /proc_top_tb/inst_proc/IR_ascii
add wave -noupdate -radix hexadecimal /proc_top_tb/inst_proc/operand_LSB
add wave -noupdate -radix hexadecimal /proc_top_tb/inst_proc/operand_MSB
add wave -noupdate /proc_top_tb/inst_proc/update_accumulator
add wave -noupdate -radix hexadecimal /proc_top_tb/inst_proc/updated_status
add wave -noupdate -radix hexadecimal /proc_top_tb/inst_proc/decoded_state
add wave -noupdate /proc_top_tb/inst_proc/wr_enable
add wave -noupdate -divider {Processor Registers}
add wave -noupdate -radix hexadecimal /proc_top_tb/inst_proc/A
add wave -noupdate -radix hexadecimal /proc_top_tb/inst_proc/X
add wave -noupdate -radix hexadecimal /proc_top_tb/inst_proc/Y
add wave -noupdate -radix hexadecimal /proc_top_tb/inst_proc/S
add wave -noupdate -radix hexadecimal /proc_top_tb/inst_proc/PC
add wave -noupdate -radix hexadecimal /proc_top_tb/inst_proc/IR
add wave -noupdate -radix hexadecimal /proc_top_tb/inst_proc/P
add wave -noupdate -divider ALU
add wave -noupdate /proc_top_tb/inst_alu/alu_ctrl
add wave -noupdate /proc_top_tb/inst_alu/alu_AI
add wave -noupdate /proc_top_tb/inst_alu/alu_BI
add wave -noupdate /proc_top_tb/inst_alu/alu_carry
add wave -noupdate /proc_top_tb/inst_alu/alu_BCD
add wave -noupdate /proc_top_tb/inst_alu/alu_flags
add wave -noupdate /proc_top_tb/inst_alu/alu_Y
add wave -noupdate /proc_top_tb/inst_alu/result
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 191
configure wave -valuecolwidth 81
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 100000
configure wave -griddelta 20
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 ps} {978 ps}
