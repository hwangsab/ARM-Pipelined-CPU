// Naisan Noorassa & Sabrina Hwang
// CSE 469: Computer Architecture
// Lab 2
// 10/27/2022
// 
// Represents the top-level module responsible for carrying out functions of 
// a simple ALU design: ADD, SUB, AND, OR, XOR, and MOV. 

`timescale 1ns/10ps

module alu (A, B, cntrl, result, negative, zero, overflow, carry_out);
	input logic [63:0] A, B;	// From registers(?)
	input logic [2:0] cntrl;	// 3-bit var to determine ALU instr
	
	output logic [63:0] result;
	output logic negative, zero, overflow, carry_out;
	
	// 8x1 mux
	// 000:			result = B						value of overflow and carry_out unimportant
	// 010:			result = A + B
	// 011:			result = A - B
	// 100:			result = bitwise A & B		value of overflow and carry_out unimportant
	// 101:			result = bitwise A | B		value of overflow and carry_out unimportant
	// 110:			result = bitwise A XOR B	value of overflow and carry_out unimportant
	
	logic [7:0] [63:0] ALU_option;		      // Sets up 8x1 MUX
	logic [63:0] sum;									// Temp var for storing adder result
	
	
	// Perform ADD/SUB and set carry_out + overflow flags
	fullAddSub_64 add_sub (.A(A), .B(B), .sub(cntrl[0]), .sum(sum), .carry_out, .overflow);
	
	// Set output of adder/subtracter to ADD/SUB options
	assign ALU_option[2] = sum;
	assign ALU_option[3] = sum;

	// Handle MOV, AND, OR, XOR
	genvar i;
	generate
		for (i = 0; i < 64; i++) begin : eachBit
			// AND Logic
			and #(0.05) and_logic (ALU_option[4][i], A[i], B[i]);
			
			// OR Logic
			or #(0.05) or_logic (ALU_option[5][i], A[i], B[i]);

			// XOR Logic
			xor #(0.05) xor_logic (ALU_option[6][i], A[i], B[i]);
			
			// MOV Logic
			assign ALU_option[0][i] = B[i];
		end
	endgenerate
	
	assign ALU_option[1] = {64{1'bx}};
	assign ALU_option[7] = {64{1'bx}};
	
	
	// Select between operations based on cntrl
	mux_64_8_1 select_output (.d(ALU_option), .s(cntrl), .y(result));	
	
	// Set negative and zero flags based on output
	assign negative = result[63];
	CheckZero cz (.in(result), .zero);

endmodule 
