`timescale 1ns/10ps

module dec_1_16 (d, sel, y);
	input logic d;
	input logic [3:0] sel;
	output logic [15:0] y;
	
	logic [1:0] out;
	
	dec_1_2 d1 (.d(d), .sel(sel[3]), .y(out));
	dec_1_8 d2 (.d(out[0]), .sel(sel[2:0]), .y(y[7:0]));
	dec_1_8 d3 (.d(out[1]), .sel(sel[2:0]), .y(y[15:8]));
	
endmodule
