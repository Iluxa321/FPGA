#1/bin/bash
rm -rf sim
mkdir sim
cd sim

mkdir Inc
cp  ../../../Inc/conf.svh Inc/conf.svh
cp  ../../../Inc/data_type.svh Inc/data_type.svh
cp  ../../../Inc/if.svh Inc/if.svh

# start the simulation
vsim  -do ../test_bus.tcl

# return to the parent folder
cd ..
