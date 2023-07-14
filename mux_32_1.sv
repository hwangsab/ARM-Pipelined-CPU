// Naisan Noorassa & Sabrina Hwang
// CSE 469: Computer Architecture
// 10/13/2022
// 
// Represents the 32:1 multiplexor that is used to construct
// the large 64x32:1 multiplexors. 
// All logic in code is constructed through basic gates, and
// all gates have a delay of 50ps, and are limited to a 
// maximum of 4 inputs. 

`timescale 1ns/10ps

module mux_32_1(d, s, y);
	input logic [31:0] d;
	input logic [4:0] s;
	output logic y;

	logic [1:0] out;

	mux_16_1 m1 (.d(d[15:0]),  .s(s[3:0]), .y(out[0]));
	mux_16_1 m2 (.d(d[31:16]), .s(s[3:0]), .y(out[1]));
	mux_2_1 m3  (.d(out), .s(s[4]), .y(y));

endmodule
			 