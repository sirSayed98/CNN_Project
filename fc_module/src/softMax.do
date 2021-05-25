vsim -gui work.softMax

add wave -position end  sim:/softMax/WORD_SIZE
add wave -position end  sim:/softMax/LAYER_SIZE
add wave -position end  sim:/softMax/N
add wave -position end  sim:/softMax/Z
add wave -position end  sim:/softMax/X
add wave -position end  sim:/softMax/Dom
add wave -position end  sim:/softMax/resVal
add wave -position end  sim:/softMax/resIdx
add wave -position end  sim:/softMax/k



force -freeze {sim:/softMax/X[9]} 10#69  0
force -freeze {sim:/softMax/X[8]} 10#9  0
force -freeze {sim:/softMax/X[7]} 10#6  0
force -freeze {sim:/softMax/X[6]} 10#8  0
force -freeze {sim:/softMax/X[5]} 10#2  0
force -freeze {sim:/softMax/X[4]} 10#20  0
force -freeze {sim:/softMax/X[3]} 10#49  0
force -freeze {sim:/softMax/X[2]} 10#1  0
force -freeze {sim:/softMax/X[1]} 10#99  0
force -freeze {sim:/softMax/X[0]} 10#0  0

run