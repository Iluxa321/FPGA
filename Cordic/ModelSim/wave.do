onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/theta
add wave -noupdate /testbench/start
add wave -noupdate -format Analog-Step -height 74 -max 0.99996899999999989 -min -0.999969 /testbench/res_sin
add wave -noupdate -format Analog-Step -height 74 -max 0.99996899999999989 -min -0.999969 /testbench/res_cos
add wave -noupdate /testbench/res_angle
add wave -noupdate -radix decimal /testbench/init_val
add wave -noupdate /testbench/i
add wave -noupdate /testbench/en
add wave -noupdate /testbench/done
add wave -noupdate /testbench/clk
add wave -noupdate -radix hexadecimal /testbench/angle
add wave -noupdate /testbench/Y0
add wave -noupdate /testbench/X0
add wave -noupdate /testbench/B
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1711414913 ps} 0}
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
WaveRestoreZoom {0 ps} {1798681500 ps}
