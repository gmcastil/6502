onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu_top_tb/cpu_top_i0/clk
add wave -noupdate /cpu_top_tb/cpu_top_i0/rstn
add wave -noupdate -divider Registers
add wave -noupdate /cpu_top_tb/cpu_top_i0/IR
add wave -noupdate /cpu_top_tb/cpu_top_i0/A
add wave -noupdate /cpu_top_tb/cpu_top_i0/X
add wave -noupdate /cpu_top_tb/cpu_top_i0/Y
add wave -noupdate /cpu_top_tb/cpu_top_i0/S
add wave -noupdate /cpu_top_tb/cpu_top_i0/PC
add wave -noupdate /cpu_top_tb/cpu_top_i0/PCH
add wave -noupdate /cpu_top_tb/cpu_top_i0/PCL
add wave -noupdate /cpu_top_tb/cpu_top_i0/P
add wave -noupdate -divider {Proc Flags}
add wave -noupdate /cpu_top_tb/cpu_top_i0/N
add wave -noupdate /cpu_top_tb/cpu_top_i0/V
add wave -noupdate /cpu_top_tb/cpu_top_i0/B
add wave -noupdate /cpu_top_tb/cpu_top_i0/D
add wave -noupdate /cpu_top_tb/cpu_top_i0/I
add wave -noupdate /cpu_top_tb/cpu_top_i0/Z
add wave -noupdate /cpu_top_tb/cpu_top_i0/C
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2600000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 317
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 ps} {105 us}
