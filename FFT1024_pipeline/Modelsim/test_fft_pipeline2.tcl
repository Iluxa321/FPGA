# create modelsim working library
vlib work

# compile all the Verilog sources
vlog  ../../Testbench/test_fft_pipeline2.v 
vlog  ../../Verilog/fft_pipeline.v
vlog  ../../Verilog/ram.v
vlog  ../../Verilog/rom.v 

# open the testbench module for simulation
vsim -gui -L altera_mf_ver work.test_fft_pipeline2

do ../test_fft_pipeline2.do

# run the simulation
run -all

# expand the signals time diagram
wave zoom full