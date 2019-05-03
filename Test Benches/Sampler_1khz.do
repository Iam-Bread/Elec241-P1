quit -sim
vsim work.sampler_1khz

# vsim work.sampler_1khz 
# Start time: 17:34:23 on Apr 24,2019
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.sampler_1khz(v1)

add wave -position insertpoint  \
sim:/sampler_1khz/CLK_DIV \
sim:/sampler_1khz/CLK_1MHZ \
sim:/sampler_1khz/ADCstart \
sim:/sampler_1khz/GOsample \
sim:/sampler_1khz/GOsample_internal

force -freeze sim:/sampler_1khz/CLK_1MHZ 1 0, 0 {500000 ps} -r 1000000
force -freeze sim:/sampler_1khz/ADCstart 1 5000000
run