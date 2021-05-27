vsim -gui work.pooltest
add wave -position insertpoint  \
sim:/pooltest/w \
sim:/pooltest/s
run 400 ps