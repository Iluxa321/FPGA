rem recreate a temp folder for all the simulation files
rd /s /q sim
md sim
cd sim

copy ..\..\init_RAM.hex
copy ..\..\init_ROM.hex
copy ..\..\Data\data2.dat

rem start the simulation
vsim -do ../test_fft_pipeline.tcl

rem return to the parent folder
cd ..