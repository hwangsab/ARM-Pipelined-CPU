// Naisan Noorassa & Sabrina Hwang
// CSE 469: Computer Architecture
// 11/10/22
// 
// Module that models the CPU control unit

`timescale 1ns/10ps

module control_unit (opcode, 
							Reg2Loc, RegWrite, SignExtend, ALUSrc, PCWrite,
					      Branch, UncondBranch, BranchLessThan, BranchReg,
							ALUCtrl, FlagWrite, MemRead, MemWrite, MemToReg);
							
	parameter ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110;						
							
	input logic [10:0] opcode;
	
	output logic Reg2Loc,         // 0 -> Read Rm; 1 -> Read Rd
					 RegWrite,
					 SignExtend,		// 0 -> Use ALUImm; 1 -> Use DTAddr
					 ALUSrc,				// 0 -> Use data from Regfile; 1 -> Use immediate (DTAddr or ALUImm)
					 Branch,				// 0 -> No cond branch; 1 -> Cond branch possible
					 UncondBranch,    // 0 -> No uncond branch; 1 -> Unconditional branch
					 BranchLessThan,  // 0 -> Cond branch if zero; 1 -> Cond branch is less than
					 BranchReg,       // 0 -> Branch based on immediate; 1 -> Branch to contents of register
					 PCWrite,			// 0 -> Write output of datapath to reg; 1 -> Write next_instr_pc to reg
					 FlagWrite,
					 MemRead,
					 MemWrite,
					 MemToReg;			// 0 -> Choose output of ALU; 1 -> Choose output of datamem
					 
	output logic [2:0] ALUCtrl; // See alu.sv
	
	always_comb begin
		if (opcode == 11'h488 || opcode == 11'h489) begin
			// ADDI
			Reg2Loc = 1'bx;
			RegWrite = 1'b1;
			SignExtend = 1'b0;
			ALUSrc = 1'b1;
			Branch = 1'b0;
			UncondBranch = 1'b0;
			BranchLessThan = 1'bx;
			BranchReg = 1'bx;
			PCWrite = 1'b0;
			ALUCtrl = ALU_ADD;
			FlagWrite = 1'b0;
			MemRead = 1'b0;
			MemWrite = 1'b0;
			MemToReg = 1'b0;
		end else if (opcode == 11'h558) begin
			// ADDS
			Reg2Loc = 1'b0;
			RegWrite = 1'b1;
			SignExtend = 1'bx;
			ALUSrc = 1'b0;
			Branch = 1'b0;
			UncondBranch = 1'b0;
			BranchLessThan = 1'bx;
			BranchReg = 1'bx;
			PCWrite = 1'b0;
			ALUCtrl = ALU_ADD;
			FlagWrite = 1'b1;
			MemRead = 1'b0;
			MemWrite = 1'b0;
			MemToReg = 1'b0;
		end else if (opcode >= 11'h0A0 && opcode <= 11'h0BF) begin
			// B
			Reg2Loc = 1'bx;
			RegWrite = 1'b0;
			SignExtend = 1'bx;
			ALUSrc = 1'bx;
			Branch = 1'bx;
			UncondBranch = 1'b1;
			BranchLessThan = 1'bx;
			BranchReg = 1'b0;
			PCWrite = 1'bx;
			ALUCtrl = 3'bxxx;
			FlagWrite = 1'b0;
			MemRead = 1'b0;
			MemWrite = 1'b0;
			MemToReg = 1'bx;
		end else if (opcode >= 11'h2A0 && opcode <= 11'h2A7) begin
			// B.LT
			Reg2Loc = 1'bx;
			RegWrite = 1'b0;
			SignExtend = 1'bx;
			ALUSrc = 1'bx;
			Branch = 1'b1;
			UncondBranch = 1'b0;
			BranchLessThan = 1'b1;
			BranchReg = 1'b0;
			PCWrite = 1'bx;
			ALUCtrl = 3'bxxx;
			FlagWrite = 1'b0;
			MemRead = 1'b0;
			MemWrite = 1'b0;
			MemToReg = 1'bx;
		end else if (opcode >= 11'h4A0 && opcode <= 11'h4BF) begin
			// BL
			Reg2Loc = 1'bx;
			RegWrite = 1'b1;
			SignExtend = 1'bx;
			ALUSrc = 1'bx;
			Branch = 1'bx;
			UncondBranch = 1'b1;
			BranchLessThan = 1'bx;
			BranchReg = 1'b0;
			PCWrite = 1'b1;
			ALUCtrl = 3'bxxx;
			FlagWrite = 1'b0;
			MemRead = 1'b0;
			MemWrite = 1'b0;
			MemToReg = 1'bx;
		end else if (opcode == 11'h6B0) begin
			// BR
			Reg2Loc = 1'b1;
			RegWrite = 1'b0;
			SignExtend = 1'bx;
			ALUSrc = 1'b0;
			Branch = 1'bx;
			UncondBranch = 1'b1;
			BranchLessThan = 1'bx;
			BranchReg = 1'b1;
			PCWrite = 1'bx;
			ALUCtrl = ALU_PASS_B;
			FlagWrite = 1'b0;
			MemRead = 1'b0;
			MemWrite = 1'b0;
			MemToReg = 1'bx;
		end else if (opcode >= 11'h5A0 && opcode <= 11'h5A7) begin
			// CBZ
			Reg2Loc = 1'b1;
			RegWrite = 1'b0;
			SignExtend = 1'bx;
			ALUSrc = 1'b0;
			Branch = 1'b1;
			UncondBranch = 1'b0;
			BranchLessThan = 1'b0;
			BranchReg = 1'b0;
			PCWrite = 1'bx;
			ALUCtrl = ALU_PASS_B;
			FlagWrite = 1'b0;
			MemRead = 1'b0;
			MemWrite = 1'b0;
			MemToReg = 1'bx;
		end else if (opcode == 11'h7C2) begin
			// LDUR
			Reg2Loc = 1'bx;
			RegWrite = 1'b1;
			SignExtend = 1'b1;
			ALUSrc = 1'b1;
			Branch = 1'b0;
			UncondBranch = 1'b0;
			BranchLessThan = 1'bx;
			BranchReg = 1'bx;
			PCWrite = 1'b0;
			ALUCtrl = ALU_ADD;
			FlagWrite = 1'b0;
			MemRead = 1'b1;
			MemWrite = 1'b0;
			MemToReg = 1'b1;
		end else if (opcode == 11'h7C0) begin
			// STUR
			Reg2Loc = 1'b1;
			RegWrite = 1'b0;
			SignExtend = 1'b1;
			ALUSrc = 1'b1;
			Branch = 1'b0;
			UncondBranch = 1'b0;
			BranchLessThan = 1'bx;
			BranchReg = 1'bx;
			PCWrite = 1'bx;
			ALUCtrl = ALU_ADD;
			FlagWrite = 1'b0;
			MemRead = 1'b0;
			MemWrite = 1'b1;
			MemToReg = 1'bx;
		end else if (opcode == 11'h758) begin
			// SUBS
			Reg2Loc = 1'b0;
			RegWrite = 1'b1;
			SignExtend = 1'bx;
			ALUSrc = 1'b0;
			Branch = 1'b0;
			UncondBranch = 1'b0;
			BranchLessThan = 1'bx;
			BranchReg = 1'bx;
			PCWrite = 1'b0;
			ALUCtrl = ALU_SUBTRACT;
			FlagWrite = 1'b1;
			MemRead = 1'b0;
			MemWrite = 1'b0;
			MemToReg = 1'b0;
		end else begin
		   Reg2Loc = 1'bx;
			RegWrite = 1'b0;
			SignExtend = 1'bx;
			ALUSrc = 1'bx;
			Branch = 1'bx;
			UncondBranch = 1'bx;
			BranchLessThan = 1'bx;
			BranchReg = 1'bx;
			PCWrite = 1'bx;
			ALUCtrl = 3'bxxx;
			FlagWrite = 1'b0;
			MemRead = 1'b0;
			MemWrite = 1'b0;
			MemToReg = 1'bx;
		end
	end
	
endmodule



module control_unit_testbench();
	logic [10:0] opcode;
	
	logic Reg2Loc,         // 0 -> Read Rm; 1 -> Read Rd
			RegWrite,
			SignExtend,		// 0 -> Use ALUImm; 1 -> Use DTAddr
			ALUSrc,				// 0 -> Use data from Regfile; 1 -> Use immediate (DTAddr or ALUImm)
			Branch,				// 0 -> No cond branch; 1 -> Cond branch possible
			UncondBranch,    // 0 -> No uncond branch; 1 -> Unconditional branch
			BranchLessThan,  // 0 -> Cond branch if zero; 1 -> Cond branch is less than
			BranchReg,       // 0 -> Branch based on immediate; 1 -> Branch to contents of register
			PCWrite,			// 0 -> Write output of datapath to reg; 1 -> Write next_instr_pc to reg
			FlagWrite,
			MemRead,
			MemWrite,
			MemToReg;			// 0 -> Choose output of ALU; 1 -> Choose output of datamem
			
	logic [2:0] ALUCtrl;

	control_unit cu (.opcode, 
					  .Reg2Loc, .RegWrite, .SignExtend, .ALUSrc, .PCWrite,
					  .Branch, .UncondBranch, .BranchLessThan, .BranchReg,
					  .ALUCtrl, .FlagWrite, .MemRead, .MemWrite, .MemToReg);
					  
	integer i;		
	initial begin
		for (i = 0; i < 2**11; i++) begin
			opcode <= i;
			#(50);
		end
	end


endmodule
