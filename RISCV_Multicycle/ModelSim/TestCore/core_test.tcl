# create modelsim working library
vlib work

# compile all the Verilog sources
vlog  ../../../Testbench/tb_core.sv 
vlog  ../../../RTL/ALU.v
vlog  ../../../RTL/controller.sv
vlog  ../../../RTL/datapath.sv
vlog  ../../../RTL/riscv.sv

# open the testbench module for simulation
vsim -c  work.tb_core

do ../mem.do
# do ../ram.do
do ../core_wave.do


# run the simulation
run -all

# expand the signals time diagram
wave zoom full
