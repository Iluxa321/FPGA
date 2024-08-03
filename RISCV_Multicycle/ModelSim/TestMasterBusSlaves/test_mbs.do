onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_port_bus_mem/clk
add wave -noupdate /tb_port_bus_mem/rst
add wave -noupdate -group cpu_master_port -color Gold -radix hexadecimal /tb_port_bus_mem/ctrl_port/addr
add wave -noupdate -group cpu_master_port -color Gold -radix hexadecimal /tb_port_bus_mem/ctrl_port/wdata
add wave -noupdate -group cpu_master_port -color Gold -radix hexadecimal /tb_port_bus_mem/ctrl_port/read
add wave -noupdate -group cpu_master_port -color Gold -radix hexadecimal /tb_port_bus_mem/ctrl_port/write
add wave -noupdate -group cpu_master_port -color Gold -radix hexadecimal /tb_port_bus_mem/ctrl_port/dataena
add wave -noupdate -group cpu_master_port -color Gold -radix hexadecimal /tb_port_bus_mem/ctrl_port/burstcount
add wave -noupdate -group cpu_master_port -color Gold -radix hexadecimal /tb_port_bus_mem/ctrl_port/rdata
add wave -noupdate -group cpu_master_port -color Gold -radix hexadecimal /tb_port_bus_mem/ctrl_port/valid
add wave -noupdate -group cpu_master_port -color Gold -radix hexadecimal /tb_port_bus_mem/ctrl_port/waitrequest
add wave -noupdate -group master_bus_port -radix hexadecimal /tb_port_bus_mem/mtr/addr
add wave -noupdate -group master_bus_port -radix hexadecimal /tb_port_bus_mem/mtr/wdata
add wave -noupdate -group master_bus_port -radix hexadecimal /tb_port_bus_mem/mtr/read
add wave -noupdate -group master_bus_port -radix hexadecimal /tb_port_bus_mem/mtr/write
add wave -noupdate -group master_bus_port -radix hexadecimal /tb_port_bus_mem/mtr/valid
add wave -noupdate -group master_bus_port -radix hexadecimal /tb_port_bus_mem/mtr/waitrequest
add wave -noupdate -group master_bus_port -radix hexadecimal /tb_port_bus_mem/mtr/dataena
add wave -noupdate -group master_bus_port -radix hexadecimal /tb_port_bus_mem/mtr/burstcount
add wave -noupdate -group master_bus_port -radix hexadecimal /tb_port_bus_mem/mtr/rdata
add wave -noupdate -group bus_slave -radix hexadecimal /tb_port_bus_mem/to_slaves.addr
add wave -noupdate -group bus_slave -radix hexadecimal /tb_port_bus_mem/to_slaves.wdata
add wave -noupdate -group bus_slave -radix hexadecimal /tb_port_bus_mem/to_slaves.read
add wave -noupdate -group bus_slave -radix hexadecimal /tb_port_bus_mem/to_slaves.write
add wave -noupdate -group bus_slave -radix hexadecimal /tb_port_bus_mem/to_slaves.dataena
add wave -noupdate -group bus_slave -radix hexadecimal /tb_port_bus_mem/to_slaves.burstcount
add wave -noupdate -group bus_slave /tb_port_bus_mem/ufm_chsel
add wave -noupdate -group bus_slave /tb_port_bus_mem/ram_chsel
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1014219 ps} 0}
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
configure wave -timelineunits us
update
WaveRestoreZoom {0 ps} {3727500 ps}
