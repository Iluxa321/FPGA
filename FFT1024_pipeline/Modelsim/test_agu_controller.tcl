# create modelsim working library
vlib work

# compile all the Verilog sources
vlog  ../../Testbench/test_controller_and_agu.v 
vlog  ../../Verilog/fft_pipeline.v


# open the testbench module for simulation
vsim work.test_controller_and_agu

do ../test_agu_controller.do

# run the simulation
run -all

# expand the signals time diagram
wave zoom full