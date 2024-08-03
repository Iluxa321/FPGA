#1/bin/bash
rm -rf sim
mkdir sim
cd sim

cp ../main.hex main.hex
cp ../../../init_regfile.txt init_regfile.txt

# start the simulation
vsim -c  -do ../core_test.tcl

# return to the parent folder
cd ..
