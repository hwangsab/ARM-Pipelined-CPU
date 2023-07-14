// Naisan Noorassa & Sabrina Hwang
// CSE 469: Computer Architecture
// 10/13/2022
// 
// Represents the 64x32:1 multiplexor used for the 32 by 64
// ARM register file. 
// All logic in code is constructed through basic gates, and
// all gates have a delay of 50ps, and are limited to a 
// maximum of 4 inputs. 

`timescale 1ns/10ps

module mux_64_32_1 (d, s, y);		  
	input logic [31:0][63:0] d;
	input logic [4:0] s;
	output logic [63:0] y;

	logic [63:0][31:0] d_flipped;
	
	// Flips components in 2D array d so that they fit 
	// parameters for the register file. 
	genvar i, j;
	generate
		for (i = 0; i < 32; i++) begin : eachReg
			for (j = 0; j < 64; j++) begin : eachBit
				assign d_flipped[j][i] = d[i][j];
			end
		end
	endgenerate
	
	// Generates 64 multiplexors
	genvar k;
	generate
		for (k = 0; k < 64; k++) begin : eachMux
			mux_32_1 mux (.d(d_flipped[k]), .s(s), .y(y[k]));
		end
	endgenerate

endmodule
