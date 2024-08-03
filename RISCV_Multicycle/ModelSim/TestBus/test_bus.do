onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_bus/clk
add wave -noupdate -color Yellow -radix hexadecimal -childformat {{/tb_bus/from_master.addr -radix hexadecimal} {/tb_bus/from_master.wdata -radix hexadecimal} {/tb_bus/from_master.read -radix hexadecimal} {/tb_bus/from_master.write -radix hexadecimal} {/tb_bus/from_master.dataena -radix hexadecimal} {/tb_bus/from_master.burstcount -radix hexadecimal}} -expand -subitemconfig {/tb_bus/from_master.addr {-color Yellow -radix hexadecimal} /tb_bus/from_master.wdata {-color Yellow -radix hexadecimal} /tb_bus/from_master.read {-color Yellow -radix hexadecimal} /tb_bus/from_master.write {-color Yellow -radix hexadecimal} /tb_bus/from_master.dataena {-color Yellow -radix hexadecimal} /tb_bus/from_master.burstcount {-color Yellow -radix hexadecimal}} /tb_bus/from_master
add wave -noupdate -color Cyan -radix hexadecimal -childformat {{/tb_bus/to_master.rdata -radix hexadecimal} {/tb_bus/to_master.valid -radix hexadecimal}} -expand -subitemconfig {/tb_bus/to_master.rdata {-color Cyan -height 44 -radix hexadecimal} /tb_bus/to_master.valid {-color Cyan -height 44 -radix hexadecimal}} /tb_bus/to_master
add wave -noupdate -color Cyan /tb_bus/m_waitrequest
add wave -noupdate -color {Medium Orchid} -radix hexadecimal -childformat {{/tb_bus/from_ufm.rdata -radix hexadecimal} {/tb_bus/from_ufm.valid -radix hexadecimal}} -expand -subitemconfig {/tb_bus/from_ufm.rdata {-color {Medium Orchid} -radix hexadecimal} /tb_bus/from_ufm.valid {-color {Medium Orchid} -radix hexadecimal}} /tb_bus/from_ufm
add wave -noupdate -color {Medium Orchid} /tb_bus/ufm_waitrequest
add wave -noupdate -color {Cadet Blue} -radix hexadecimal -childformat {{/tb_bus/from_ram.rdata -radix hexadecimal} {/tb_bus/from_ram.valid -radix hexadecimal}} -expand -subitemconfig {/tb_bus/from_ram.rdata {-color {Cadet Blue} -radix hexadecimal} /tb_bus/from_ram.valid {-color {Cadet Blue} -radix hexadecimal}} /tb_bus/from_ram
add wave -noupdate -color {Cadet Blue} /tb_bus/ram_waitrequest
add wave -noupdate -radix hexadecimal -childformat {{/tb_bus/to_slaves.addr -radix hexadecimal} {/tb_bus/to_slaves.wdata -radix hexadecimal} {/tb_bus/to_slaves.read -radix hexadecimal} {/tb_bus/to_slaves.write -radix hexadecimal} {/tb_bus/to_slaves.dataena -radix hexadecimal} {/tb_bus/to_slaves.burstcount -radix hexadecimal}} -expand -subitemconfig {/tb_bus/to_slaves.addr {-radix hexadecimal} /tb_bus/to_slaves.wdata {-radix hexadecimal} /tb_bus/to_slaves.read {-radix hexadecimal} /tb_bus/to_slaves.write {-radix hexadecimal} /tb_bus/to_slaves.dataena {-radix hexadecimal} /tb_bus/to_slaves.burstcount {-radix hexadecimal}} /tb_bus/to_slaves
add wave -noupdate /tb_bus/ufm_chsel
add wave -noupdate /tb_bus/ram_chsel
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 366
configure wave -valuecolwidth 466
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
WaveRestoreZoom {0 ps} {304500 ps}
