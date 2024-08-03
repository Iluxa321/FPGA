onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_ram/clk
add wave -noupdate /tb_ram/rst
add wave -noupdate /tb_ram/data
add wave -noupdate /tb_ram/mp/state
add wave -noupdate -color Gold -radix hexadecimal -childformat {{/tb_ram/cpu2master.addr -radix hexadecimal} {/tb_ram/cpu2master.wdata -radix hexadecimal} {/tb_ram/cpu2master.read -radix hexadecimal} {/tb_ram/cpu2master.write -radix hexadecimal} {/tb_ram/cpu2master.dataena -radix hexadecimal} {/tb_ram/cpu2master.burstcount -radix hexadecimal}} -expand -subitemconfig {/tb_ram/cpu2master.addr {-color Gold -height 44 -radix hexadecimal} /tb_ram/cpu2master.wdata {-color Gold -height 44 -radix hexadecimal} /tb_ram/cpu2master.read {-color Gold -height 44 -radix hexadecimal} /tb_ram/cpu2master.write {-color Gold -height 44 -radix hexadecimal} /tb_ram/cpu2master.dataena {-color Gold -height 44 -radix hexadecimal} /tb_ram/cpu2master.burstcount {-color Gold -height 44 -radix hexadecimal}} /tb_ram/cpu2master
add wave -noupdate -color Magenta -radix hexadecimal -childformat {{/tb_ram/master2cpu.rdata -radix hexadecimal} {/tb_ram/master2cpu.valid -radix hexadecimal} {/tb_ram/master2cpu.waitrequest -radix hexadecimal}} -expand -subitemconfig {/tb_ram/master2cpu.rdata {-color Magenta -radix hexadecimal} /tb_ram/master2cpu.valid {-color Magenta -radix hexadecimal} /tb_ram/master2cpu.waitrequest {-color Magenta -radix hexadecimal}} /tb_ram/master2cpu
add wave -noupdate -radix hexadecimal /tb_ram/slave2master
add wave -noupdate -color Cyan -radix hexadecimal /tb_ram/master2slave
add wave -noupdate /tb_ram/dut/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors
quietly wave cursor active 0
configure wave -namecolwidth 268
configure wave -valuecolwidth 345
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
WaveRestoreZoom {0 ps} {321831 ps}
