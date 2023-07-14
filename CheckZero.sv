// Naisan Noorassa & Sabrina Hwang
// CSE 469: Computer Architecture
// Lab 2
// 10/27/2022
// 
// Module used for checking if the input is zero

`timescale 1ns/10ps

module CheckZero(in, zero);
	input logic [63:0] in;
	output logic zero;
	
	logic [15:0] nor_results; 
	logic [3:0] and_results;
	
	// NOR all bits of input
	genvar i;
	generate
		for (i = 0; i < 16; i++) begin : eachNor
			nor #(0.05) (nor_results[i], in[i*4], in[i*4+1], in[i*4+2], in[i*4+3]);
		end
	endgenerate
	
	// AND the results of the NORs
	genvar j;
	generate
		for (j = 0; j < 4; j++) begin :eachAnd
			and #(0.05) (and_results[j], nor_results[j*4], nor_results[j*4+1], nor_results[j*4+2], nor_results[j*4+3]);
		end
	endgenerate
	
	// AND the results of the ANDs
	and #(0.05) (zero, and_results[0], and_results[1], and_results[2], and_results[3]);
	
endmodule
	
	
	
module CheckZero_testbench();
	logic [63:0] in;
	logic zero;
	
	CheckZero dut (.in, .zero);
	
	integer i;
	
	initial begin											// Tests all possible inputs
		for (i = 0; i < 2**64; i++) begin
			in = i;
		end
	end
endmodule
