rem recreate a temp folder for all the simulation files
rd /s /q sim
md sim
cd sim

copy ..\..\twiddle_factor.txt
copy ..\..\Data\data_A.txt
copy ..\..\Data\data_B.txt
copy ..\..\Data\data_X.txt
copy ..\..\Data\data_Y.txt


rem start the simulation
vsim -do ../test_butterfly.tcl

rem return to the parent folder
cd ..