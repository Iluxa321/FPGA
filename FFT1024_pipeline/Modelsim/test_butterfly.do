onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /test_butterfly/A_re
add wave -noupdate -radix decimal /test_butterfly/A_img
add wave -noupdate -radix decimal /test_butterfly/B_re
add wave -noupdate -radix decimal /test_butterfly/B_img
add wave -noupdate -radix decimal /test_butterfly/W_re
add wave -noupdate -radix decimal /test_butterfly/W_img
add wave -noupdate -radix decimal /test_butterfly/X_re
add wave -noupdate -radix decimal /test_butterfly/X_img
add wave -noupdate -radix decimal /test_butterfly/Y_re
add wave -noupdate -radix decimal /test_butterfly/Y_img
add wave -noupdate /test_butterfly/W
add wave -noupdate /test_butterfly/i
add wave -noupdate /test_butterfly/fp3
add wave -noupdate /test_butterfly/fp2
add wave -noupdate /test_butterfly/fp1
add wave -noupdate /test_butterfly/clk
add wave -noupdate /test_butterfly/B
add wave -noupdate /test_butterfly/A
add wave -noupdate -radix decimal /test_butterfly/dut/b_re
add wave -noupdate -radix decimal /test_butterfly/dut/b_img
add wave -noupdate -radix decimal /test_butterfly/res_X_re
add wave -noupdate -radix decimal /test_butterfly/res_X_img
add wave -noupdate -radix decimal /test_butterfly/res_Y_re
add wave -noupdate -radix decimal /test_butterfly/res_Y_img
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12117 ps} 0}
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
WaveRestoreZoom {0 ps} {168 ns}
