// Naisan Noorassa & Sabrina Hwang
// CSE 469: Computer Architecture
// 10/13/2022
// 
// Represents the 16:1 multiplexor that is used to build
// up to a 32:1 multiplexor. 
// All logic in code is constructed through basic gates, and
// all gates have a delay of 50ps, and are limited to a 
// maximum of 4 inputs. 

`timescale 1ns/10ps

module mux_16_1(d, s, y);
	input logic [15:0] d;
	input logic [3:0] s;
	output logic y;
	
	logic [1:0] out;
	
	mux_8_1 m1 (.d(d[7:0]),  .s(s[2:0]), .y(out[0]));
	mux_8_1 m2 (.d(d[15:8]), .s(s[2:0]), .y(out[1]));
	mux_2_1 m3 (.d(out), .s(s[3]), .y(y));
	
endmodule
