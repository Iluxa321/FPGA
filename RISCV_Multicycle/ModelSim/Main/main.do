onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/clk
add wave -noupdate /tb/rst
add wave -noupdate -group cpu_master -radix hexadecimal /tb/cpu/addr
add wave -noupdate -group cpu_master -radix hexadecimal /tb/cpu/wdata
add wave -noupdate -group cpu_master -radix hexadecimal /tb/cpu/rdata
add wave -noupdate -group cpu_master -radix hexadecimal /tb/cpu/dataena
add wave -noupdate -group cpu_master -radix hexadecimal /tb/cpu/write
add wave -noupdate -group cpu_master -radix hexadecimal /tb/cpu/read
add wave -noupdate -group cpu_master -radix hexadecimal /tb/cpu/done
add wave -noupdate -height 17 -group Instr -color Magenta -radix hexadecimal /tb/cpu/dp/instr
add wave -noupdate -height 17 -group Instr -color Magenta -radix unsigned /tb/cpu/dp/rs1
add wave -noupdate -height 17 -group Instr -color Magenta -radix unsigned /tb/cpu/dp/rs2
add wave -noupdate -height 17 -group Instr -color Magenta -radix unsigned /tb/cpu/dp/rd
add wave -noupdate -height 17 -group Instr -color Magenta -radix hexadecimal /tb/cpu/dp/op
add wave -noupdate -height 17 -group Instr -color Magenta -radix hexadecimal /tb/cpu/dp/funct3
add wave -noupdate -height 17 -group Instr -color Magenta -radix hexadecimal /tb/cpu/dp/funct7
add wave -noupdate -height 17 -group bus_slaves -color Gold -radix hexadecimal /tb/bus/to_slaves.addr
add wave -noupdate -height 17 -group bus_slaves -color Gold -radix hexadecimal /tb/bus/to_slaves.wdata
add wave -noupdate -height 17 -group bus_slaves -color Gold -radix hexadecimal /tb/bus/to_slaves.read
add wave -noupdate -height 17 -group bus_slaves -color Gold -radix hexadecimal /tb/bus/to_slaves.write
add wave -noupdate -height 17 -group bus_slaves -color Gold -radix hexadecimal /tb/bus/to_slaves.dataena
add wave -noupdate -height 17 -group bus_slaves -color Gold -radix hexadecimal /tb/bus/to_slaves.burstcount
add wave -noupdate -height 17 -group bus_slaves -color Gold -radix hexadecimal /tb/bus/ufm_chsel
add wave -noupdate -height 17 -group bus_slaves -color Gold -radix hexadecimal /tb/bus/ram_chsel
add wave -noupdate -height 17 -group bus_slaves -color Gold -radix hexadecimal /tb/bus/seg_chsel
add wave -noupdate /tb/cpu/cntr/mainFSM/state
add wave -noupdate /tb/fsmState
add wave -noupdate /tb/fsmNext
add wave -noupdate -expand -group SEG -color {Cornflower Blue} -radix hexadecimal /tb/seg_periph/hex_data
add wave -noupdate -expand -group SEG -color {Cornflower Blue} -radix hexadecimal /tb/seg_periph/hex_controll
add wave -noupdate -expand -group SEG -color {Cornflower Blue} -radix hexadecimal /tb/seg_periph/data
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
configure wave -timelineunits us
update
WaveRestoreZoom {0 ps} {17881500 ps}
