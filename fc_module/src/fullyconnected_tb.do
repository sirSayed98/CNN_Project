vsim work.fullyconnected_tb

add wave -hex -position insertpoint sim:/fullyconnected_tb/* 
add wave -hex -position insertpoint sim:/fullyconnected_tb/resultExpected 
add wave -hex -position insertpoint sim:/fullyconnected_tb/resultExpected[4] 
add wave -hex -position insertpoint sim:/fullyconnected_tb/circuit_output[4] 
add wave -hex -position insertpoint sim:/fullyconnected_tb/testX 
add wave -hex -position insertpoint sim:/fullyconnected_tb/testW 
add wave -hex -position insertpoint sim:/fullyconnected_tb/testB 
add wave -hex -position insertpoint sim:/fullyconnected_tb/testZ 
add wave -hex -position insertpoint sim:/fullyconnected_tb/input_layer 
add wave -hex -position insertpoint sim:/fullyconnected_tb/weight 
add wave -hex -position insertpoint sim:/fullyconnected_tb/bias 
add wave -hex -position insertpoint sim:/fullyconnected_tb/myFullyConnected/intrmd
add wave -hex -position insertpoint sim:/fullyconnected_tb/myFullyConnected/* 

run -all