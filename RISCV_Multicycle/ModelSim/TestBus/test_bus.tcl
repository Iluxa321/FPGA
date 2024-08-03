# create modelsim working library
vlib work

# compile all the Verilog sources
vlog  -sv ../../../Testbench/tb_bus.sv 
vlog  -sv ../../../RTL/Components/bus.sv 


# open the testbench module for simulation
vsim  -L altera_mf_ver work.tb_bus 


do ../test_bus.do
# do ../mem.do




# run the simulation
run -all

# expand the signals time diagram
wave zoom full

exit
