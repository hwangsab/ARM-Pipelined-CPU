// Naisan Noorassa & Sabrina Hwang
// CSE 469: Computer Architecture
// Lab 2
// 10/27/2022
// 
// Module used for adding and subtracting two 64-bit logics.
// Subtracts if sub = 1 and adds o.w.
// Provides sum and carry_out outputs.

`timescale 1ns/10ps

module fullAddSub_64 (A, B, sub, sum, carry_out, overflow);
	input logic [63:0] A, B;
	input logic sub;
	output logic [63:0] sum;
	output logic carry_out, overflow;
	
	logic [63:0] not_B;   // ~B
	logic [63:0] sel_B;   // Selected between B and ~B based on sub
	logic [63:0] c_outs;  // Carry outs from each adder
	
	genvar i;
	generate
		for (i = 0; i < 64; i++) begin : eachBit
			not #(0.05) n (not_B[i], B[i]); // set not_B
			
			mux_2_1 add_or_sub (.d({not_B[i], B[i]}), .s(sub), .y(sel_B[i]));  // pick between B and ~B
			
			// Create fullAdders and chain together carries
			if (i == 0) begin
				fullAdder firstBit (.A(A[0]), .B(sel_B[0]), .sum(sum[0]), .carry_in(sub), .carry_out(c_outs[0]));
			end else begin
				fullAdder otherBit (.A(A[i]), .B(sel_B[i]), .sum(sum[i]), .carry_in(c_outs[i-1]), .carry_out(c_outs[i]));
			end
		end
	endgenerate
	
	assign carry_out = c_outs[63];
	
	xor #(0.05) x (overflow, c_outs[62], carry_out);
	
endmodule


module fullAddSub_64_testbench();
	logic [63:0] A, B, sum;
	logic sub;
	logic carry_out, overflow;
	
	fullAddSub_64 dut (.A, .B, .sum, .sub, .carry_out, .overflow);
	
	integer i, j;
	
	initial begin											// Tests all combinations of A and B
		for (i = 0; i < 2**64; i++) begin
			for (j = 0; j < 2**64; j++) begin
				A = i;
				B = j;
				sub = 0;
				#(50);
				assert (sum == (A + B));
				
				A = i;
				B = j;
				sub = 1;
				#(50);
				assert (sum == (A - B));
				
			end
		end
	end
endmodule
