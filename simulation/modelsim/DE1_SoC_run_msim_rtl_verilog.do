transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/ringr/OneDrive/Documents/EE\ 371\ Labs/Lab0 {C:/Users/ringr/OneDrive/Documents/EE 371 Labs/Lab0/fullAdder.sv}
vlog -sv -work work +incdir+C:/Users/ringr/OneDrive/Documents/EE\ 371\ Labs/Lab0 {C:/Users/ringr/OneDrive/Documents/EE 371 Labs/Lab0/DE1_SoC.sv}

