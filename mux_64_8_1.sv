// Naisan Noorassa & Sabrina Hwang
// CSE 469: Computer Architecture
// 10/13/2022
// 
// Represents the 64x8:1 multiplexor used for the ALU
// All logic in code is constructed through basic gates, and
// all gates have a delay of 50ps, and are limited to a 
// maximum of 4 inputs. 

`timescale 1ns/10ps

module mux_64_8_1 (d, s, y);		  
	input logic [7:0][63:0] d;
	input logic [2:0] s;
	output logic [63:0] y;

	logic [63:0][7:0] d_flipped;
	
	// Flips components in 2D array d 
	genvar i, j;
	generate
		for (i = 0; i < 8; i++) begin : eachReg
			for (j = 0; j < 64; j++) begin : eachBit
				assign d_flipped[j][i] = d[i][j];
			end
		end
	endgenerate
	
	// Generates 64 multiplexors
	genvar k;
	generate
		for (k = 0; k < 64; k++) begin : eachMux
			mux_8_1 mux (.d(d_flipped[k]), .s(s), .y(y[k]));
		end
	endgenerate

endmodule


module mux_64_8_1_testbench();
	logic [7:0][63:0] d;
	logic [2:0] s;
	logic [63:0] y;
	
	mux_8_1 dut (.d, .s, .y);
	
	integer i, j, k;
	
	initial begin											// Tests all possible inputs
		for (i = 0; i < 2**8; i++) begin
			for (j = 0; j < 2**3; j++) begin
				for (k = 0; k < 2**64; k++) begin
					d[i] = k;
					s = j;
				end
			end
		end
	end
	
endmodule
