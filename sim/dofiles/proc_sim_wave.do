onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -noupdate /proc_tb/inst_proc/clk
# add wave -noupdate /proc_tb/resetn
# add wave -noupdate /proc_tb/rd_data
# add wave -noupdate /proc_tb/address
# add wave -noupdate /proc_tb/wr_data
# add wave -noupdate /proc_tb/wr_enable
# add wave -noupdate /proc_tb/alu_Y
# add wave -noupdate /proc_tb/alu_flags
# add wave -noupdate /proc_tb/alu_ctrl
# add wave -noupdate /proc_tb/alu_AI
# add wave -noupdate /proc_tb/alu_BI
# add wave -noupdate /proc_tb/alu_carry
# add wave -noupdate /proc_tb/alu_BCD
# add wave -noupdate /proc_tb/A
# add wave -noupdate /proc_tb/X
# add wave -noupdate /proc_tb/Y
# add wave -noupdate /proc_tb/S
# add wave -noupdate /proc_tb/PC
# add wave -noupdate /proc_tb/IR
# add wave -noupdate /proc_tb/P
# add wave -noupdate /proc_tb/state_ascii
# add wave -noupdate /proc_tb/IR_ascii
# add wave -noupdate /proc_tb/operand_LSB
# add wave -noupdate /proc_tb/operand_MSB
# add wave -noupdate /proc_tb/update_accumulator
# add wave -noupdate /proc_tb/updated_status
# add wave -noupdate /proc_tb/decoded_state
update
WaveRestoreZoom {0 ps} {2 us}

# add wave -noupdate /ber_control_tb/u_ber_control/clk
# add wave -noupdate /ber_control_tb/u_ber_control/sw_reset
# add wave -noupdate /ber_control_tb/u_ber_control/sw_start
# add wave -noupdate /ber_control_tb/u_ber_control/sw_lock_time_delay
# add wave -noupdate /ber_control_tb/u_ber_control/sw_ool_count_thresh
# add wave -noupdate /ber_control_tb/u_ber_control/sw_ool_cool_time
# add wave -noupdate /ber_control_tb/u_ber_control/sw_prbs_lock_chk_time
# add wave -noupdate /ber_control_tb/u_ber_control/sw_ber_seg_length
# add wave -noupdate /ber_control_tb/u_ber_control/sw_num_of_bers
# add wave -noupdate /ber_control_tb/u_ber_control/rmn
# add wave -noupdate /ber_control_tb/u_ber_control/prbs_chk_err
# add wave -noupdate /ber_control_tb/u_ber_control/lock_time_delay
# add wave -noupdate /ber_control_tb/u_ber_control/ool_count_thresh
# add wave -noupdate /ber_control_tb/u_ber_control/ool_cool_time
# add wave -noupdate /ber_control_tb/u_ber_control/prbs_lock_chk_time
# add wave -noupdate /ber_control_tb/u_ber_control/ber_seg_length
# add wave -noupdate /ber_control_tb/u_ber_control/num_of_bers
# add wave -noupdate -color Gray40 /ber_control_tb/u_ber_control/idfts_state_timer
# add wave -noupdate -color Gray40 /ber_control_tb/u_ber_control/lts_state_timer
# add wave -noupdate -color Gray40 /ber_control_tb/u_ber_control/ool_state_timer
# add wave -noupdate -color Gray40 /ber_control_tb/u_ber_control/bers_state_timer
# add wave -noupdate -color Gray40 /ber_control_tb/u_ber_control/tdfts_state_timer
# add wave -noupdate /ber_control_tb/u_ber_control/idfts_fail
# add wave -noupdate -radix unsigned /ber_control_tb/u_ber_control/prbs_chk_window_begin
# add wave -noupdate -radix unsigned /ber_control_tb/u_ber_control/prbs_chk_window_end
# add wave -noupdate /ber_control_tb/u_ber_control/prbs_chk_window
# add wave -noupdate /ber_control_tb/u_ber_control/prbs_chk_err_flag
# add wave -noupdate /ber_control_tb/u_ber_control/lts_timer_exp
# add wave -noupdate /ber_control_tb/u_ber_control/lts_rmn_fail
# add wave -noupdate /ber_control_tb/u_ber_control/lts_prbs_fail
# add wave -noupdate /ber_control_tb/u_ber_control/ool_count
# add wave -noupdate /ber_control_tb/u_ber_control/ool_timer_exp
# add wave -noupdate /ber_control_tb/u_ber_control/let_fiber_cool_flag
# add wave -noupdate /ber_control_tb/u_ber_control/lts_lock_fail
# add wave -noupdate /ber_control_tb/u_ber_control/bers_done_flag
# add wave -noupdate /ber_control_tb/u_ber_control/tdfts_fail
# add wave -noupdate /ber_control_tb/u_ber_control/bers_count
# add wave -noupdate /ber_control_tb/u_ber_control/run_status
# add wave -noupdate -color {Cornflower Blue} /ber_control_tb/u_ber_control/next_state
# add wave -noupdate -color {Cornflower Blue} /ber_control_tb/u_ber_control/present_state
# add wave -noupdate /ber_control_tb/u_ber_control/prbs_gen_en
# add wave -noupdate /ber_control_tb/u_ber_control/prbs_chk_en
# add wave -noupdate /ber_control_tb/u_ber_control/rct
# add wave -noupdate /ber_control_tb/u_ber_control/tct
# add wave -noupdate /ber_control_tb/u_ber_control/chan_status
# add wave -noupdate /ber_control_tb/u_ber_control/chan_ool_count
# add wave -noupdate /ber_control_tb/u_ber_control/chan_bers_count
# add wave -noupdate /ber_control_tb/u_ber_control/chan_total_bits_sent
# add wave -noupdate /ber_control_tb/u_ber_control/chan_total_bit_errs
# add wave -noupdate /ber_control_tb/u_ber_control/chan_current_state
# TreeUpdate [SetDefaultTree]
# WaveRestoreCursors {{Cursor 1} {3923137770 ps} 0}
# quietly wave cursor active 1
# configure wave -namecolwidth 193
# configure wave -valuecolwidth 100
# configure wave -justifyvalue left
# configure wave -signalnamewidth 1
# configure wave -snapdistance 10
# configure wave -datasetprefix 0
# configure wave -rowmargin 4
# configure wave -childrowmargin 2
# configure wave -gridoffset 0
# configure wave -gridperiod 1
# configure wave -griddelta 40
# configure wave -timeline 0
# configure wave -timelineunits fs
# update
# WaveRestoreZoom {0 ps} {4200 us}
