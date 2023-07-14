// Naisan Noorassa & Sabrina Hwang
// CSE 469: Computer Architecture
// Lab 2
// 10/27/2022
// 
// Represents the 2:1 multiplexor that is used to build
// up to a 32:1 multiplexor. 
// All logic in code is constructed through basic gates, and
// all gates have a delay of 50ps, and are limited to a 
// maximum of 4 inputs. 

`timescale 1ns/10ps

module mux_2_1(d, s, y);
	input logic [1:0] d;
	input logic s;
	output logic y;
	
	logic ns;
	logic [1:0] sel_d;
	
	not #(0.05) n1 (ns, s);
	and #(0.05) a1 (sel_d[0], d[0], ns);
	and #(0.05) a2 (sel_d[1], d[1],  s);
	or  #(0.05) o1 (y, sel_d[0], sel_d[1]);
	
endmodule
