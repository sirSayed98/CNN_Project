vsim -gui work.convolutiontest
add wave -position insertpoint  \
sim:/convolutiontest/f \
sim:/convolutiontest/w \
sim:/convolutiontest/r
run 400 ps