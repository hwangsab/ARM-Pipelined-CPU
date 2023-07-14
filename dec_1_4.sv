`timescale 1ns/10ps

module dec_1_4 (d, sel, y);
	input logic d;
	input logic [1:0] sel;
	output logic [3:0] y;
	
	logic [1:0] out;
	
	dec_1_2 d1 (.d(d), .sel(sel[1]), .y(out));
	dec_1_2 d2 (.d(out[0]), .sel(sel[0]), .y(y[1:0]));
	dec_1_2 d3 (.d(out[1]), .sel(sel[0]), .y(y[3:2]));
	
endmodule
