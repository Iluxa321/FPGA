# create modelsim working library
vlib work

# compile all the Verilog sources
vlog  ../../Testbench/*.v 
vlog  ../../Verilog/*.v


# open the testbench module for simulation
vsim  work.testbench

do ../wave.do

# run the simulation
run -all

# expand the signals time diagram
wave zoom full