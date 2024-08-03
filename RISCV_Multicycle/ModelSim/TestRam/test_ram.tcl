# create modelsim working library
vlib work

# compile all the Verilog sources
vlog  -sv ../../../Testbench/tb_ram.sv 
vlog  -sv ../../../RTL/data_ram.sv 
vlog  ../../../RTL/ram.v 
vlog -sv ../../../RTL/masterPort.sv 

# open the testbench module for simulation
vsim -c -L altera_mf_ver work.tb_ram -logfile log.log


do ../test_ram.do
do ../mem.do




# run the simulation
run -all

# expand the signals time diagram
wave zoom full

mem display -addressradix d -dataradix hex  -wordsperline  2 -startaddress 0 -endaddress 15 /tb_ram/dut/r/altsyncram_component/m_default/altsyncram_inst/mem_data

exit
