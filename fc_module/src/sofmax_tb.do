vsim work.softmax_tb

add wave -position end  sim:/softmax_tb/WORD_SIZE
add wave -position end  sim:/softmax_tb/LAYER_SIZE
add wave -position end  sim:/softmax_tb/TEST_CASES_NUM
add wave -position end  sim:/softmax_tb/clk
add wave -position end  sim:/softmax_tb/reset
add wave -position end  sim:/softmax_tb/input_layer
add wave -position end  sim:/softmax_tb/resultExpected
add wave -position end  sim:/softmax_tb/circuit_output
add wave -position end  sim:/softmax_tb/vectornum
add wave -position end  sim:/softmax_tb/errors
add wave -position end  sim:/softmax_tb/testvectors
add wave -position end  sim:/softmax_tb/k

add wave -position end  sim:/mySoftmax/WORD_SIZE
add wave -position end  sim:/mySoftmax/LAYER_SIZE
add wave -position end  sim:/mySoftmax/N
add wave -position end  sim:/mySoftmax/Z
add wave -position end  sim:/mySoftmax/X
#add wave -position end  sim:/mySoftmax/Dom
add wave -position end  sim:/mySoftmax/resVal
add wave -position end  sim:/mySoftmax/resIdx
add wave -position end  sim:/mySoftmax/k

run