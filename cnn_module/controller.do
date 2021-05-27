quit -sim
# End time: 23:42:00 on May 26,2021, Elapsed time: 0:00:50
# Errors: 0, Warnings: 0
# Compile of controller.vhd was successful.
vsim work.controller
# End time: 00:13:00 on May 27,2021, Elapsed time: 0:04:11
# Errors: 0, Warnings: 0
# vsim work.controller 
# Start time: 00:13:00 on May 27,2021
# ** Note: (vsim-8009) Loading existing optimized design _opt
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading ieee.std_logic_arith(body)
# Loading ieee.std_logic_unsigned(body)
# Loading work.controller(controllerarc)#1
# vsim work.controller 
# Start time: 23:43:51 on May 26,2021
# ** Note: (vsim-3813) Design is being optimized due to module recompilation...
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading ieee.std_logic_arith(body)
# Loading ieee.std_logic_unsigned(body)
# Loading work.controller(controllerarc)#1
add wave -position end  sim:/controller/we
add wave -position end  sim:/controller/total_layer_count
add wave -position end  sim:/controller/start
add wave -position end  sim:/controller/reset_accumulator
add wave -position end  sim:/controller/reset
add wave -position end  sim:/controller/output_start_address_rom
add wave -position end  sim:/controller/output_start_address
add wave -position end  sim:/controller/output_size_rom
add wave -position end  sim:/controller/output_size
add wave -position end  sim:/controller/out_pool
add wave -position end  sim:/controller/out_conv
add wave -position end  sim:/controller/max_feature_maps_rom
add wave -position end  sim:/controller/max_feature_maps
add wave -position end  sim:/controller/max_depth_rom
add wave -position end  sim:/controller/max_depth
add wave -position end  sim:/controller/layer_type_rom
add wave -position end  sim:/controller/input_start_address_rom
add wave -position end  sim:/controller/input_start_address
add wave -position end  sim:/controller/input_size_rom
add wave -position end  sim:/controller/input_size
add wave -position end  sim:/controller/filter_start_address_rom
add wave -position end  sim:/controller/filter_start_address
add wave -position end  sim:/controller/filterAddress
add wave -position end  sim:/controller/enable_conv
add wave -position end  sim:/controller/done
add wave -position end  sim:/controller/current_layer_sig
add wave -position end  sim:/controller/clk
add wave -position end  sim:/controller/WORDSIZE
add wave -position end  sim:/controller/PoolAddress
add wave -position end  sim:/controller/MemAddress
add wave -position end  sim:/controller/IMMEDIATE_START_ADDRESS
add wave -position end  sim:/controller/EWF
add wave -position end  sim:/controller/EWB
add wave -position end  sim:/controller/ConvAddress
add wave -position end  sim:/controller/BuffAddress
add wave -position end  sim:/controller/ADDRESS_SIZE
force -freeze sim:/controller/clk 1 0, 0 {50 ns} -r 100
force -freeze sim:/controller/start 0 0
force -freeze sim:/controller/reset 0 0
step -over
run -continue
step -over
step
step
step
# Next activity is in 50 ns.
step
step
step
step
step
# Next activity is in 50 ns.
step
step
step
step
step
# Next activity is in 50 ns.
step
step
step
step
step
# Next activity is in 50 ns.
step
step
step
step
step
# Next activity is in 50 ns.
step
step
step
step
step
# Next activity is in 50 ns.
step
step
step
step
step
# Next activity is in 50 ns.
step
step
step
step
step
# Next activity is in 50 ns.
step
step
step
step
step
# Next activity is in 50 ns.
step
step
step
step
step
# Next activity is in 50 ns.
step
step
step
step
step
# Next activity is in 50 ns.
step
# Causality operation skipped due to absence of debug database file
force -freeze sim:/controller/start 1 0


