onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /testbench_cordic_line_mode/a
add wave -noupdate -radix decimal /testbench_cordic_line_mode/b
add wave -noupdate -radix decimal /testbench_cordic_line_mode/c
add wave -noupdate -radix decimal /testbench_cordic_line_mode/res
add wave -noupdate -radix decimal /testbench_cordic_line_mode/error
add wave -noupdate /testbench_cordic_line_mode/A
add wave -noupdate /testbench_cordic_line_mode/B
add wave -noupdate /testbench_cordic_line_mode/C
add wave -noupdate /testbench_cordic_line_mode/RES
add wave -noupdate /testbench_cordic_line_mode/en
add wave -noupdate /testbench_cordic_line_mode/done
add wave -noupdate /testbench_cordic_line_mode/clk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ps} {535500 ps}
