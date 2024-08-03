onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench_cordic_hyperbolic_mode/Y0
add wave -noupdate /testbench_cordic_hyperbolic_mode/X0
add wave -noupdate -radix decimal /testbench_cordic_hyperbolic_mode/Y
add wave -noupdate -radix decimal /testbench_cordic_hyperbolic_mode/X
add wave -noupdate /testbench_cordic_hyperbolic_mode/theta
add wave -noupdate /testbench_cordic_hyperbolic_mode/rB
add wave -noupdate /testbench_cordic_hyperbolic_mode/rA
add wave -noupdate /testbench_cordic_hyperbolic_mode/en
add wave -noupdate /testbench_cordic_hyperbolic_mode/done
add wave -noupdate /testbench_cordic_hyperbolic_mode/clk
add wave -noupdate -radix decimal /testbench_cordic_hyperbolic_mode/angle
add wave -noupdate -radix decimal /testbench_cordic_hyperbolic_mode/c1/y_i
add wave -noupdate -radix decimal /testbench_cordic_hyperbolic_mode/c1/x_i
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
