onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -noupdate -binary /memory_tb/memory_inst/clk
add wave -noupdate -binary /memory_tb/memory_inst/resetn
add wave -noupdate -binary /memory_tb/memory_inst/enable
add wave -noupdate -hex /memory_tb/memory_inst/address
add wave -noupdate -binary /memory_tb/memory_inst/wr_enable
add wave -noupdate -hex /memory_tb/memory_inst/wr_data
add wave -noupdate -hex /memory_tb/memory_inst/rd_data

add wave -noupdate -hex /memory_tb/operand_MSB
add wave -noupdate -hex /memory_tb/operand_LSB

configure wave -namecolwidth 164
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 10400
configure wave -gridperiod 20800
configure wave -griddelta 20
configure wave -timeline 0
configure wave -timelineunits us

update
WaveRestoreZoom {0 ps} {2 us}
