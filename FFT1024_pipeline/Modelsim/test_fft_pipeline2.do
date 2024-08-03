onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /test_fft_pipeline2/cnt
add wave -noupdate -radix unsigned /test_fft_pipeline2/addr_wr
add wave -noupdate -radix unsigned /test_fft_pipeline2/addr_rd
add wave -noupdate /test_fft_pipeline2/clk
add wave -noupdate /test_fft_pipeline2/load
add wave -noupdate /test_fft_pipeline2/done
add wave -noupdate /test_fft_pipeline2/dut/reg_swap
add wave -noupdate /test_fft_pipeline2/reset
add wave -noupdate /test_fft_pipeline2/start
add wave -noupdate /test_fft_pipeline2/dut/controller/state
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
WaveRestoreZoom {0 ps} {2074800 ps}
