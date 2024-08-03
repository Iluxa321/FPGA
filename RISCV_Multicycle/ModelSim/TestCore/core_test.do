onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /core_test/rst
add wave -noupdate /core_test/clk
add wave -noupdate /core_test/we_mem
add wave -noupdate -radix hexadecimal /core_test/InstrAddr
add wave -noupdate -radix hexadecimal /core_test/DataAddr
add wave -noupdate -radix hexadecimal /core_test/Instr
add wave -noupdate -radix decimal /core_test/core/datepath/alu_result
add wave -noupdate -radix decimal /core_test/dataFromMemToCore
add wave -noupdate -radix decimal /core_test/dataFromCoreToMem
add wave -noupdate -radix unsigned /core_test/rs2
add wave -noupdate -radix unsigned /core_test/rs1
add wave -noupdate -radix unsigned /core_test/rd
add wave -noupdate -radix unsigned /core_test/op
add wave -noupdate /core_test/core/controller/mainDecoder/funct3
add wave -noupdate /core_test/core/controller/aluDecoder/funct7
add wave -noupdate /core_test/core/controller/mainDecoder/SrcB
add wave -noupdate /core_test/core/controller/mainDecoder/SrcA
add wave -noupdate /core_test/core/controller/mainDecoder/WrMemSrc
add wave -noupdate /core_test/core/controller/mainDecoder/RdMemSrc
add wave -noupdate /core_test/core/controller/mainDecoder/ResSrc
add wave -noupdate /core_test/core/controller/mainDecoder/ImmSrc
add wave -noupdate /core_test/core/controller/mainDecoder/RegWrite
add wave -noupdate /core_test/core/controller/mainDecoder/MemWrite
add wave -noupdate /core_test/core/controller/mainDecoder/PCSrc
add wave -noupdate /core_test/core/controller/mainDecoder/JUMP
add wave -noupdate /core_test/core/controller/mainDecoder/BNE
add wave -noupdate /core_test/core/controller/mainDecoder/BLTU
add wave -noupdate /core_test/core/controller/mainDecoder/BLT
add wave -noupdate /core_test/core/controller/mainDecoder/BGEU
add wave -noupdate /core_test/core/controller/mainDecoder/BGE
add wave -noupdate /core_test/core/controller/mainDecoder/BEQ
add wave -noupdate /core_test/core/controller/mainDecoder/ALUOp
add wave -noupdate /core_test/core/controller/ALUControll
add wave -noupdate -radix hexadecimal -childformat {{{/core_test/core/datepath/rf/rfile[31]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[30]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[29]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[28]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[27]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[26]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[25]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[24]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[23]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[22]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[21]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[20]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[19]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[18]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[17]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[16]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[15]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[14]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[13]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[12]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[11]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[10]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[9]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[8]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[7]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[6]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[5]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[4]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[3]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[2]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[1]} -radix hexadecimal} {{/core_test/core/datepath/rf/rfile[0]} -radix hexadecimal}} -subitemconfig {{/core_test/core/datepath/rf/rfile[31]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[30]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[29]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[28]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[27]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[26]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[25]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[24]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[23]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[22]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[21]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[20]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[19]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[18]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[17]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[16]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[15]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[14]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[13]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[12]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[11]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[10]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[9]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[8]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[7]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[6]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[5]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[4]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[3]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[2]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[1]} {-height 15 -radix hexadecimal} {/core_test/core/datepath/rf/rfile[0]} {-height 15 -radix hexadecimal}} /core_test/core/datepath/rf/rfile
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1716884 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 212
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
WaveRestoreZoom {1706941 ps} {1748401 ps}
