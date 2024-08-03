onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test_fft_pipeline/dut/done
add wave -noupdate /test_fft_pipeline/dut/clk
add wave -noupdate -label B0_addr_A -radix unsigned /test_fft_pipeline/dut/dp/mem_bank0/_addr_A
add wave -noupdate -label B0_addr_B -radix unsigned /test_fft_pipeline/dut/dp/mem_bank0/_addr_B
add wave -noupdate -label B1_addr_A -radix unsigned /test_fft_pipeline/dut/dp/mem_bank1/_addr_A
add wave -noupdate -label B1_addr_B -radix unsigned /test_fft_pipeline/dut/dp/mem_bank1/_addr_B
add wave -noupdate -radix unsigned /test_fft_pipeline/dut/agu/addr_A
add wave -noupdate -radix unsigned /test_fft_pipeline/dut/agu/addr_B
add wave -noupdate -radix unsigned -childformat {{{/test_fft_pipeline/dut/dp/del_addr_A[2]} -radix unsigned} {{/test_fft_pipeline/dut/dp/del_addr_A[1]} -radix unsigned} {{/test_fft_pipeline/dut/dp/del_addr_A[0]} -radix unsigned}} -subitemconfig {{/test_fft_pipeline/dut/dp/del_addr_A[2]} {-height 15 -radix unsigned} {/test_fft_pipeline/dut/dp/del_addr_A[1]} {-height 15 -radix unsigned} {/test_fft_pipeline/dut/dp/del_addr_A[0]} {-height 15 -radix unsigned}} /test_fft_pipeline/dut/dp/del_addr_A
add wave -noupdate -radix unsigned -childformat {{{/test_fft_pipeline/dut/dp/del_addr_B[2]} -radix unsigned} {{/test_fft_pipeline/dut/dp/del_addr_B[1]} -radix unsigned} {{/test_fft_pipeline/dut/dp/del_addr_B[0]} -radix unsigned}} -expand -subitemconfig {{/test_fft_pipeline/dut/dp/del_addr_B[2]} {-height 15 -radix unsigned} {/test_fft_pipeline/dut/dp/del_addr_B[1]} {-height 15 -radix unsigned} {/test_fft_pipeline/dut/dp/del_addr_B[0]} {-height 15 -radix unsigned}} /test_fft_pipeline/dut/dp/del_addr_B
add wave -noupdate /test_fft_pipeline/dut/controller/state
add wave -noupdate -radix unsigned /test_fft_pipeline/dut/controller/cnt
add wave -noupdate /test_fft_pipeline/dut/controller/rst_addr
add wave -noupdate /test_fft_pipeline/dut/controller/en_swap
add wave -noupdate /test_fft_pipeline/dut/controller/done
add wave -noupdate -radix hexadecimal /test_fft_pipeline/dut/dp/Y
add wave -noupdate -radix hexadecimal /test_fft_pipeline/dut/dp/X
add wave -noupdate -radix unsigned /test_fft_pipeline/cnt2
add wave -noupdate /test_fft_pipeline/dut/start
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {344964 ps} 0}
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
WaveRestoreZoom {312937 ps} {513201 ps}
