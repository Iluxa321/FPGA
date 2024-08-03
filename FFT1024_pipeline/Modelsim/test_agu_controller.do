onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test_controller_and_agu/WRmem
add wave -noupdate /test_controller_and_agu/work
add wave -noupdate /test_controller_and_agu/start
add wave -noupdate /test_controller_and_agu/rst_swap
add wave -noupdate /test_controller_and_agu/rst_addr
add wave -noupdate /test_controller_and_agu/reset
add wave -noupdate /test_controller_and_agu/inc_addr
add wave -noupdate /test_controller_and_agu/en_swap
add wave -noupdate /test_controller_and_agu/conv_end
add wave -noupdate /test_controller_and_agu/clk
add wave -noupdate /test_controller_and_agu/addr_Tw
add wave -noupdate -radix unsigned /test_controller_and_agu/addr_B
add wave -noupdate -radix unsigned /test_controller_and_agu/addr_A
add wave -noupdate /test_controller_and_agu/dut/state
add wave -noupdate -radix unsigned /test_controller_and_agu/dut/cnt
add wave -noupdate -radix unsigned -childformat {{{/test_controller_and_agu/del_addr_B[2]} -radix unsigned} {{/test_controller_and_agu/del_addr_B[1]} -radix unsigned} {{/test_controller_and_agu/del_addr_B[0]} -radix unsigned}} -expand -subitemconfig {{/test_controller_and_agu/del_addr_B[2]} {-height 15 -radix unsigned} {/test_controller_and_agu/del_addr_B[1]} {-height 15 -radix unsigned} {/test_controller_and_agu/del_addr_B[0]} {-height 15 -radix unsigned}} /test_controller_and_agu/del_addr_B
add wave -noupdate -radix unsigned /test_controller_and_agu/del_addr_A
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {207858 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {115085 ps} {360829 ps}
