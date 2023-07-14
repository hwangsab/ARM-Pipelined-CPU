// Naisan Noorassa & Sabrina Hwang
// CSE 469: Computer Architecture
// 10/13/2022
// 
// Module that takes data being input and constructs
// registers. Each register is an array of 64 D flip-flops
// with enables
// 
// Parameters: 
//		clk: 				Clock being used
//		data_in:			Data being input to each register
//		write_enable:	Enable of the D flip-flop
//		data_out:		Data output from each register

`timescale 1ns/10ps

module register(clk, rst, data_in, write_enable, data_out);
	output logic [63:0] data_out;
	input logic clk, rst, write_enable;
	input logic [63:0] data_in;
	
	logic [63:0] d;
	
	// Select our d input to the DFFs between data_in and data_out based on write_enable using muxes
	// If write_enable = 0, d = data_out, if write_enable = 1, d = data_in
	genvar i;
	generate
		for (i = 0; i < 64; i++) begin : eachMux
			mux_2_1 m (.d({data_in[i], data_out[i]}), .s(write_enable), .y(d[i]));
		end
	endgenerate
	
	
	// Construct 64 DFFs
	genvar j;
	generate
		for (j = 0; j < 64; j++) begin : eachDff
			D_FF d (.d(d[j]), .q(data_out[j]), .reset(rst), .clk(clk));
		end
	endgenerate
	
endmodule


module register_testbench();
	logic [63:0] data_out;
	logic clk, rst, write_enable;
	logic [63:0] data_in;
	
	parameter ClockDelay = 10000;
	integer i;
	
	register dut (.clk, .rst, .data_in, .write_enable, .data_out);
	
	initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end
	
	initial begin
		rst <= 1'b1;
		@(posedge clk);
		rst <= 1'b0;
	
		for (i = 0; i < 2**64; i++) begin
			write_enable <= 1;
			data_in <= i;
			@(posedge clk);
			rst <= 1;
			@(posedge clk);
			rst <= 0;
			write_enable <= 0;
			@(posedge clk);
		end
		
		$stop;
	end
	
endmodule
