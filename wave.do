onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu_testbench/clk
add wave -noupdate /cpu_testbench/rst
add wave -noupdate /cpu_testbench/zero
add wave -noupdate /cpu_testbench/neg
add wave -noupdate /cpu_testbench/overflow
add wave -noupdate /cpu_testbench/cout
add wave -noupdate -radix decimal /cpu_testbench/pc
add wave -noupdate -expand /cpu_testbench/regs
add wave -noupdate /cpu_testbench/datamem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {121104478 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 395
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {202533219 ps}
