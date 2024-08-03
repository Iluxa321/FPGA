# create modelsim working library
vlib work

# compile all the Verilog sources
vlog  ../../Testbench/test_butterfly.v 
vlog  ../../Verilog/fft_pipeline.v 

# open the testbench module for simulation
vsim  work.test_butterfly

do ../test_butterfly.do

# run the simulation
run -all

# expand the signals time diagram
wave zoom full