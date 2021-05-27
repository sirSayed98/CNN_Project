vsim -gui work.system
add wave sim:/system/*
add wave sim:/system/imgdata
add wave sim:/system/convResult
add wave sim:/system/help
add wave sim:/system/reg_to_adder
add wave sim:/system/adder_result

mem load -i {D:/Study/Third Year/Second term/VLSI/CNN_Project/x.mem} /system/Ram_comp/ram

force -freeze sim:/system/clk 1 0, 0 {50 ps} -r 100

force -freeze sim:/system/start 0 0

run 10 ps

force -freeze sim:/system/start 1 0

run 100 ns