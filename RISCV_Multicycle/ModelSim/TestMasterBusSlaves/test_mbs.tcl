# create modelsim working library
do msim_setup.tcl


# compile all the Verilog sources
# file_copy
com 
dev_com
elab

# open the testbench module for simulation
# vsim work.tb_core

do test_mbs.do
# do ../ram_mem.do


# run the simulation
run -all

# expand the signals time diagram
wave zoom full

mem display -addressradix d -dataradix hex  -wordsperline  2 -startaddress 0 -endaddress 30 /tb_port_bus_mem/ram/r/altsyncram_component/m_default/altsyncram_inst/mem_data

exit