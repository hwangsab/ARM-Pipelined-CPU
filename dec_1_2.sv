`timescale 1ns/10ps

module dec_1_2 (d, sel, y);
	input logic d;
	input logic sel;
	output logic [1:0] y;
	
	logic n_sel;
	
	not #(50) n1 (n_sel, sel);
	and #(50) a1 (y[0], d, n_sel);
	and #(50) a2 (y[1], d, sel);
	
endmodule

