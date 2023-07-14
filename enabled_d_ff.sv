// Naisan Noorassa & Sabrina Hwang
// CSE 469: Computer Architecture
// 11/10/22
// 
// Module that models an enabled DFF

`timescale 1ns/10ps

module Enabled_D_FF (q, d, enable, reset, clk);
	input logic d, enable, reset, clk;
	output logic q;
	
	logic temp;
	
	mux_2_1 m (.d({d, q}), .s(enable), .y(temp));
	
	D_FF dff (.d(temp), .q, .reset, .clk);
	
endmodule


module d_ff_testbench();
	logic clk, reset;
	logic d;
	logic q;
	logic enable;
	
	// Instantiates module to set up the test
	Enabled_D_FF dut (.clk, .reset, .d, .q, .enable);
	// Sets up a simulated clock to toggle
	parameter CLOCK_PERIOD = 100;
	// Forever toggles the clock
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2)
		clk <= ~clk;
	end
	
	// Tests the design
	initial begin
	@(posedge clk)
	enable <= 1;
	reset <= 1; @(posedge clk)
	reset <= 0; @(posedge clk)
	d <= 1; repeat (4) @(posedge clk)
	d <= 0; repeat (4) @(posedge clk)
	d <= 1; repeat (4) @(posedge clk)
	d <= 0; repeat (4) @(posedge clk)
	
	enable <= 0;
	reset <= 1; @(posedge clk)
	reset <= 0; @(posedge clk)
	d <= 1; repeat (4) @(posedge clk)
	d <= 0; repeat (4) @(posedge clk)
	d <= 1; repeat (4) @(posedge clk)
	d <= 0; repeat (4) @(posedge clk)
	$stop;
end
endmodule
