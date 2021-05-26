
quit -sim
# End time: 23:42:00 on May 26,2021, Elapsed time: 0:00:50
# Errors: 0, Warnings: 0
# Compile of controller2.vhd was successful.
vsim work.controller2
# vsim work.controller2 
# Start time: 23:43:51 on May 26,2021
# ** Note: (vsim-3813) Design is being optimized due to module recompilation...
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading ieee.std_logic_arith(body)
# Loading ieee.std_logic_unsigned(body)
# Loading work.controller2(controller2arc)#1
add wave -position end  sim:/controller2/we
add wave -position end  sim:/controller2/total_layer_count
add wave -position end  sim:/controller2/start
add wave -position end  sim:/controller2/reset_accumulator
add wave -position end  sim:/controller2/reset
add wave -position end  sim:/controller2/output_start_address_rom
add wave -position end  sim:/controller2/output_start_address
add wave -position end  sim:/controller2/output_size_rom
add wave -position end  sim:/controller2/output_size
add wave -position end  sim:/controller2/out_pool
add wave -position end  sim:/controller2/out_conv
add wave -position end  sim:/controller2/max_feature_maps_rom
add wave -position end  sim:/controller2/max_feature_maps
add wave -position end  sim:/controller2/max_depth_rom
add wave -position end  sim:/controller2/max_depth
add wave -position end  sim:/controller2/layer_type_rom
add wave -position end  sim:/controller2/input_start_address_rom
add wave -position end  sim:/controller2/input_start_address
add wave -position end  sim:/controller2/input_size_rom
add wave -position end  sim:/controller2/input_size
add wave -position end  sim:/controller2/filter_start_address_rom
add wave -position end  sim:/controller2/filter_start_address
add wave -position end  sim:/controller2/filterAddress
add wave -position end  sim:/controller2/enable_conv
add wave -position end  sim:/controller2/done
add wave -position end  sim:/controller2/current_layer_sig
add wave -position end  sim:/controller2/clk
add wave -position end  sim:/controller2/WORDSIZE
add wave -position end  sim:/controller2/PoolAddress
add wave -position end  sim:/controller2/MemAddress
add wave -position end  sim:/controller2/IMMEDIATE_START_ADDRESS
add wave -position end  sim:/controller2/EWF
add wave -position end  sim:/controller2/EWB
add wave -position end  sim:/controller2/ConvAddress
add wave -position end  sim:/controller2/BuffAddress
add wave -position end  sim:/controller2/ADDRESS_SIZE
force -freeze sim:/controller2/clk 1 0, 0 {50 ns} -r 100
run
force -freeze sim:/controller2/reset 0 0
force -freeze sim:/controller2/start 0 0
force -freeze sim:/controller2/start 1 0
run
step -over
