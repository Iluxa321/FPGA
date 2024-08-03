#1/bin/bash
rm -rf Inc
# mkdir libraries
# cd sim

mkdir Inc
cp  ../../Inc/conf.svh Inc/conf.svh
cp  ../../Inc/data_type.svh Inc/data_type.svh
cp  ../../Inc/if.svh Inc/if.svh
cp ../../init_regfile.txt init_regfile.txt

# start the simulation
vsim  -do ./main.tcl



# return to the parent folder
cd ..
