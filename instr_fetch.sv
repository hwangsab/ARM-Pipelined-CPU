// Naisan Noorassa & Sabrina Hwang
// CSE 469: Computer Architecture
// 11/10/22
// 
// Module that models the instruction fetch phase of instruction execution

`timescale 1ns/10ps

module instr_fetch (clk, rst, ALUOutput, neg_flag, overflow_flag, alu_zero,
						  Branch, UncondBranch, BranchLessThan, BranchReg, // ctrl signal inputs
						  pc, next_instr_pc, instr);
						  
	input logic clk, rst, Branch, UncondBranch, BranchLessThan, BranchReg, neg_flag, overflow_flag, alu_zero;
	input logic [63:0] ALUOutput;
	output logic [31:0] instr;
	output logic [63:0] pc, next_instr_pc;

	// Input and output of PC reg
	logic [63:0] pc_in, pc_out;
	
	// branch_pc and cbranch_pc are calculated from uncond and cond branch displacements and PC
	// next_instr_pc is PC + 4 (above in outputs)
	// imm_branch_pc is chosen between branch_pc and cbranch_pc based on whether we are doing a conditional branch or unconditional
	// chosen_branch_pc is chosen between ALUOutput (branch reg) and imm_branch_pc
	// pc_in is chosen between chosen_branch_pc and next_instr_pc
	logic [63:0] imm_branch_pc, branch_pc, cbranch_pc, chosen_branch_pc;
	
	logic [63:0] ubr_displacement, cbr_displacement;
	
	logic less_than, cond_true, br_taken, cond_br_taken;

	// Set up PC register
	register pc_reg (.clk, .rst, .data_in(pc_in), .write_enable(1'b1), .data_out(pc_out));
	assign pc = pc_out;
	
	// Instruction memory takes PC as input and outputs an instruction
	instructmem im (.address(pc_out), .instruction(instr), .clk);
	
	// Get branch displacements
	assign ubr_displacement  = {{36{instr[25]}}, instr[25:0], 2'b0}; // sign extend branch displacement & multiply by four
	assign cbr_displacement =  {{43{instr[23]}}, instr[23:5], 2'b0}; // sign extend cond branch displacement & multiply by four
	
	// Calculate PC + 4
	fullAddSub_64 pc_plus_4 (.A(pc_out), .B(64'd4), .sub(1'b0), .sum(next_instr_pc));
	
	// Calculate unconditional branch addr
	fullAddSub_64 pc_plus_br_disp (.A(pc_out), .B(ubr_displacement), .sub(1'b0), .sum(branch_pc));
	
	// Calculate conditional branch addr
	fullAddSub_64 pc_plus_cbr_disp (.A(pc_out), .B(cbr_displacement), .sub(1'b0), .sum(cbranch_pc));
	
	// Generate br_taken signal
	xor #(0.05) x1 (less_than, neg_flag, overflow_flag); // Less than if neg XOR overflow
	mux_2_1 m0 (.d({less_than, alu_zero}), .s(BranchLessThan), .y(cond_true)); // Choose between zero and less_than as condition
	and #(0.05) a1 (cond_br_taken, Branch, cond_true); // Cond branch if Branch and cond_true
	or  #(0.05) o1 (br_taken, cond_br_taken, UncondBranch); // Branch if UncondBranch OR (Branch AND condition)
	
	// Choose pc_in
	genvar i;
	generate
		for (i = 0; i < 64; i++) begin : eachMux
			// Choose between Branch and cond Branch immediate addrs
			mux_2_1 m1 (.d({branch_pc[i], cbranch_pc[i]}), .s(UncondBranch), .y(imm_branch_pc[i]));
			
			// Choose between branch immediate and branch register
			mux_2_1 m2 (.d({ALUOutput[i], imm_branch_pc[i]}), .s(BranchReg), .y(chosen_branch_pc[i]));
			
			// Choose between pc+4 and branch
			mux_2_1 m3 (.d({chosen_branch_pc[i], next_instr_pc[i]}), .s(br_taken), .y(pc_in[i]));
			
		end
	endgenerate
	
endmodule


module instr_fetch_testbench();
	logic clk, rst, Branch, UncondBranch, neg_flag, overflow_flag, BranchLessThan, BranchReg;
	logic [63:0] ALUOutput;
	logic [31:0] instr;
	logic [63:0] pc;
	
	parameter ClockDelay = 5000;
	integer i;
	
	instr_fetch dut (.clk, .rst, .instr, .Branch, .UncondBranch, .ALUOutput, .neg_flag, .overflow_flag, .pc, .BranchLessThan, .BranchReg);
	
	initial begin // Set up the clock
		clk <= 0;
		Branch <= 0;
		UncondBranch <= 0;
		ALUOutput <= 0;
		neg_flag <= 0;
		overflow_flag <= 0;
		BranchLessThan <= 0;
		BranchReg <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end
	
	initial begin
		rst <= 1'b1;
		@(posedge clk);
		rst <= 1'b0;
	
		for (i = 0; i < 10; i++) begin
			@(posedge clk); // loop through instructions
		end
		
		$stop;
	end

endmodule
