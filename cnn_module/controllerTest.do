vsim -gui work.controllertest
add wave -position insertpoint  \
sim:/controllertest/st \
sim:/controllertest/clock \
sim:/controllertest/r \
sim:/controllertest/w \
sim:/controllertest/EF \
sim:/controllertest/EB \
sim:/controllertest/oonv \
sim:/controllertest/ee_conv \
sim:/controllertest/oool \
sim:/controllertest/d \
sim:/controllertest/rulator \
sim:/controllertest/fss \
sim:/controllertest/B \
sim:/controllertest/M \
sim:/controllertest/C \
sim:/controllertest/P 
run 100 ns
run 100 ns
run 100 ns
run 100 ns
run 100 ns
run 100 ns
run 100 ns
run 1 ms
