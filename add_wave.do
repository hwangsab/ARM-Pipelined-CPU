onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /fullAddSub_64_testbench/A
add wave -noupdate -radix decimal /fullAddSub_64_testbench/B
add wave -noupdate -radix decimal /fullAddSub_64_testbench/sum
add wave -noupdate -radix decimal /fullAddSub_64_testbench/sub
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {169364 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {104663 ps} {185173 ps}
