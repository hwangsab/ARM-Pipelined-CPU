// Test bench for ALU
`timescale 1ns/10ps

// Meaning of signals in and out of the ALU:

// Flags:
// negative: whether the result output is negative if interpreted as 2's comp.
// zero: whether the result output was a 64-bit zero.
// overflow: on an add or subtract, whether the computation overflowed if the inputs are interpreted as 2's comp.
// carry_out: on an add or subtract, whether the computation produced a carry-out.



module alustim();

	parameter delay = 100000;

	logic		[63:0]	A, B;
	logic		[2:0]		cntrl;
	logic		[63:0]	result;
	logic					negative, zero, overflow, carry_out ;

	parameter ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110;
	

	alu dut (.A, .B, .cntrl, .result, .negative, .zero, .overflow, .carry_out);

	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);

	integer i;
	logic [63:0] neg_B;
	logic [64:0] sim_res;
	logic [63:0] part_sim_res;
	initial begin
	
		// Testing PASS_B operations
		$display("%t testing PASS_B operations", $time);
		cntrl = ALU_PASS_B;
		for (i=0; i<100; i++) begin
			A = $random(); B = $random();
			#(delay);
			assert(result == B && negative == B[63] && zero == (B == '0));
		end
		
		// Testing ADD operations
		$display("%t testing ADD operations", $time);
		cntrl = ALU_ADD;
		for (i=0; i<100; i++) begin
			A = $random(); B = $random();
			sim_res = A + B;
			part_sim_res = A[62:0] + B[62:0]; // calculating carry-in
			
			#(delay);
			assert(result == sim_res[63:0]);
			assert(carry_out == sim_res[64]);
			assert(negative == sim_res[63]);
			assert(zero == (sim_res[63:0] == 0));
			assert(overflow == (sim_res[64] ^ part_sim_res[63]));
		end
		
		// Testing SUB operations
		$display("%t testing SUB operations", $time);
		cntrl = ALU_SUBTRACT;
		for (i=0; i<100; i++) begin
			A = $random(); B = $random();
			neg_B = ~B + 1;
			sim_res = A + neg_B;
			part_sim_res = A[62:0] + neg_B[62:0]; // calculating carry-in
			
			#(delay);
			assert(result == sim_res[63:0]);
			assert(carry_out == sim_res[64]);
			assert(negative == sim_res[63]);
			assert(zero == (sim_res[63:0] == 0));
			assert(overflow == (sim_res[64] ^ part_sim_res[63]));
		end
		
		// Testing AND operations
		$display("%t testing AND operations", $time);
		cntrl = ALU_AND;
		for (i=0; i<100; i++) begin
			A = $random(); B = $random();
			sim_res = A & B;
			
			#(delay);
			assert(result == sim_res[63:0]);
			assert(negative == sim_res[63]);
			assert(zero == (sim_res[63:0] == 0));
			// Carry & Overflow disregarded
		end
		
		// Testing OR operations
		$display("%t testing OR operations", $time);
		cntrl = ALU_OR;
		for (i=0; i<100; i++) begin
			A = $random(); B = $random();
			sim_res = A | B;
			
			#(delay);
			assert(result == sim_res[63:0]);
			assert(negative == sim_res[63]);
			assert(zero == (sim_res[63:0] == 0));
			// Carry & Overflow disregarded
		end
		
		// Testing XOR operations
		$display("%t testing XOR operations", $time);
		cntrl = ALU_XOR;
		for (i=0; i<100; i++) begin
			A = $random(); B = $random();
			sim_res = A ^ B;
			
			#(delay);
			assert(result == sim_res[63:0]);
			assert(negative == sim_res[63]);
			assert(zero == (sim_res[63:0] == 0));
			// Carry & Overflow disregarded
		end
		
		
	end
endmodule
