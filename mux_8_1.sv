// Naisan Noorassa & Sabrina Hwang
// CSE 469: Computer Architecture
// Lab 2
// 10/27/2022
// 
// Represents the 8:1 multiplexor that is used to build
// up to a 32:1 multiplexor. 
// All logic in code is constructed through basic gates, and
// all gates have a delay of 50ps, and are limited to a 
// maximum of 4 inputs. 

`timescale 1ns/10ps

module mux_8_1(d, s, y);
	input logic [7:0] d;
	input logic [2:0] s;
	output logic y;
	
	logic [1:0] out;
	
	mux_4_1 m1 (.d(d[3:0]), .s(s[1:0]), .y(out[0]));
	mux_4_1 m2 (.d(d[7:4]), .s(s[1:0]), .y(out[1]));
	mux_2_1 m3 (.d(out), .s(s[2]), .y(y));
	
endmodule


module mux_8_1_testbench();
	logic [7:0] d;
	logic [2:0] s;
	logic y;
	
	mux_8_1 dut (.d, .s, .y);
	
	integer i, j;
	
	initial begin											// Tests all possible inputs
		for (i = 0; i < 2**8; i++) begin
			for (j = 0; j < 2**3; j++) begin
				d = i;
				s = j;
				
			end
		end
	end
	
endmodule

