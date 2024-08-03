rem recreate a temp folder for all the simulation files
rd /s /q sim
md sim
cd sim

copy ..\..\coef.txt


rem start the simulation
vsim -do ../test_cordic_line_mode.tcl

rem return to the parent folder
cd ..