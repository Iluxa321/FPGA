#1/bin/bash
rm -rf sim
mkdir sim
cd sim

mkdir Inc
cp  ../../../Inc/conf.svh Inc/conf.svh
cp  ../../../Inc/data_type.svh Inc/data_type.svh

# start the simulation
vsim -c -do ../test_ram.tcl

# return to the parent folder
cd ..
