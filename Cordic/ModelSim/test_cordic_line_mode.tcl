# create modelsim working library
vlib work

# compile all the Verilog sources
vlog  ../../Testbench/testbench_cordic_line_mode.v 
vlog  ../../Verilog/cordic.v


# open the testbench module for simulation
vsim  work.testbench_cordic_line_mode

do ../line_mode_wave.do

# run the simulation
run -all

# expand the signals time diagram
wave zoom full