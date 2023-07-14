// Naisan Noorassa & Sabrina Hwang
// CSE 469: Computer Architecture
// Lab 2
// 10/27/2022
// 
// Full adder module used to carry logic for ADD and SUB 
// functions within ALU design. 

`timescale 1ns/10ps

module fullAdder (A, B, carry_in, sum, carry_out);
	input logic A, B, carry_in;
	output logic sum, carry_out;
	
	logic A_xor_B, c_in_xor_AB, A_and_B;

	xor #(0.05) x (sum, A, B, carry_in);

	xor #(0.05) x2 (A_xor_B, A, B);
	and #(0.05) a1 (c_in_xor_AB, carry_in, A_xor_B);
	and #(0.05) a2 (A_and_B, A, B);
	or #(0.05) o1 (carry_out, A_and_B, c_in_xor_AB);
	
endmodule


module fullAdder_testbench();
	logic A, B, cin, sum, cout;
	
	fullAdder dut (A, B, cin, sum, cout);

	integer i;
	initial begin
		for (i = 0; i < 2**3; i++) begin
			{A, B, cin} = i; #10;
		end
	end
	
endmodule