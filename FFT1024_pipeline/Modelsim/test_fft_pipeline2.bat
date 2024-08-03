rem recreate a temp folder for all the simulation files
rd /s /q sim
md sim
cd sim

copy ..\..\init_RAM.hex
copy ..\..\init_ROM.hex
copy ..\..\Twiddle_factor_data\twiddle_factor32.txt
copy ..\..\Twiddle_factor_data\twiddle_factor256.txt
copy ..\..\Twiddle_factor_data\twiddle_factor1024.txt
copy ..\..\Data\data2.dat

rem start the simulation
vsim -do ../test_fft_pipeline2.tcl

rem return to the parent folder
cd ..