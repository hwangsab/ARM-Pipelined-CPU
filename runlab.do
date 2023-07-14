# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./mux_2_1.sv"
vlog "./mux_4_1.sv"
vlog "./mux_8_1.sv"
vlog "./mux_16_1.sv"
vlog "./mux_32_1.sv"
vlog "./mux_64_8_1.sv"
vlog "./mux_64_32_1.sv"
vlog "./alu.sv"
vlog "./fullAddSub_64.sv"
vlog "./fullAdder.sv"
vlog "./CheckZero.sv"
vlog "./instr_fetch.sv"
vlog "./instructmem.sv"
vlog "./register.sv"
vlog "./regfile.sv"
vlog "./d_ff.sv"
vlog "./instr_decode.sv"
vlog "./control_unit.sv"
vlog "./dec_1_32.sv"
vlog "./dec_1_16.sv"
vlog "./dec_1_8.sv"
vlog "./dec_1_4.sv"
vlog "./dec_1_2.sv"
vlog "./enabled_d_ff.sv"
vlog "./cpu.sv"
vlog "./datamem.sv"


# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work cpu_testbench

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
