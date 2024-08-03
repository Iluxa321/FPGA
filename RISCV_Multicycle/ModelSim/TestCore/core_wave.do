onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_core/rst
add wave -noupdate /tb_core/dut/clk
add wave -noupdate -divider -height 35 Datapath
add wave -noupdate -radix hexadecimal /tb_core/dut/dp/addrRes
add wave -noupdate -radix hexadecimal /tb_core/dut/dp/instr
add wave -noupdate -radix unsigned /tb_core/dut/dp/rs2
add wave -noupdate -radix unsigned /tb_core/dut/dp/rs1
add wave -noupdate -radix unsigned /tb_core/dut/dp/rd
add wave -noupdate -radix hexadecimal /tb_core/dut/dp/resData
add wave -noupdate -radix hexadecimal /tb_core/dut/dp/rB
add wave -noupdate -radix hexadecimal /tb_core/writeData
add wave -noupdate -radix hexadecimal /tb_core/readData
add wave -noupdate -radix hexadecimal -childformat {{{/tb_core/dut/dp/RF/rfile[31]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[30]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[29]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[28]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[27]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[26]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[25]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[24]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[23]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[22]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[21]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[20]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[19]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[18]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[17]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[16]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[15]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[14]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[13]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[12]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[11]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[10]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[9]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[8]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[7]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[6]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[5]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[4]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[3]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[2]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[1]} -radix hexadecimal} {{/tb_core/dut/dp/RF/rfile[0]} -radix hexadecimal}} -subitemconfig {{/tb_core/dut/dp/RF/rfile[31]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[30]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[29]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[28]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[27]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[26]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[25]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[24]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[23]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[22]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[21]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[20]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[19]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[18]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[17]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[16]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[15]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[14]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[13]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[12]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[11]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[10]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[9]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[8]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[7]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[6]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[5]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[4]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[3]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[2]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[1]} {-height 15 -radix hexadecimal} {/tb_core/dut/dp/RF/rfile[0]} {-height 15 -radix hexadecimal}} /tb_core/dut/dp/RF/rfile
add wave -noupdate -divider -height 35 Controller
add wave -noupdate /tb_core/dut/cntr/mainFSM/state
add wave -noupdate /tb_core/dut/SrcB
add wave -noupdate /tb_core/dut/SrcA
add wave -noupdate /tb_core/dut/ResSrc
add wave -noupdate /tb_core/dut/ImmSrc
add wave -noupdate /tb_core/dut/DataSrc
add wave -noupdate /tb_core/dut/WDSrc
add wave -noupdate /tb_core/dut/AddrSrc
add wave -noupdate /tb_core/dut/RegWrite
add wave -noupdate /tb_core/dut/PCWrite
add wave -noupdate /tb_core/dut/IRWrite
add wave -noupdate /tb_core/dut/ALUControll
add wave -noupdate /tb_core/dut/compFlag
add wave -noupdate /tb_core/dut/zeroFlag
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {155027820 ps} 0}
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
WaveRestoreZoom {154333380 ps} {156069480 ps}
