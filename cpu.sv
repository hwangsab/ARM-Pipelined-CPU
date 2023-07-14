// Naisan Noorassa & Sabrina Hwang
// CSE 469: Computer Architecture
// 11/10/22
// 
// Module that models the CPU

`timescale 1ns/10ps

`define DATA_MEM_SIZE		1024

module cpu(clk, rst, regs, pc, zero, neg, overflow, cout, datamem);
 
	input logic clk, rst;
	output logic zero, neg, overflow, cout;          // Stored Flag values
	output logic [63:0] pc;                          // Current PC
	output logic [31:0][63:0] regs;                  // Registers
	output logic [7:0] datamem [`DATA_MEM_SIZE-1:0]; // Datamem
	
	// Control signals
	logic Reg2Loc, RegWrite, SignExtend, ALUSrc,	Branch,
	      UncondBranch, BranchLessThan, BranchReg, PCWrite, FlagWrite,
			MemRead, MemWrite, MemToReg;
	logic [2:0] ALUCtrl;
	
	// Flags outputted from ALU
	logic alu_zero, alu_neg, alu_overflow, alu_cout;
	
	logic [63:0] ALUInput1, ALUInput2; // Inputs to ALU
	logic [63:0] RegReadData2;			  // Data read from Regfile's 2nd read line
	
	logic [63:0] MemReadData; // Data read from datamem
	
	logic [63:0] ALUOutput;      // Output from ALU
	logic [63:0] DatapathOutput; // Output from Datapath (either from ALU or memory)
	
	logic [31:0] instr;         // Current instruction
	logic [63:0] next_instr_pc; // PC + 4

 
	// Control unit
	control_unit control_unit (.opcode(instr[31:21]) , .Reg2Loc, .RegWrite, .SignExtend, .ALUSrc, .PCWrite, 
	                           .Branch, .UncondBranch, .BranchLessThan, .BranchReg, .ALUCtrl, .FlagWrite,
										.MemRead, .MemWrite, .MemToReg);
 
	// Instruction fetch
	instr_fetch instr_fetch (.clk, .rst, .ALUOutput, .neg_flag(neg), .overflow_flag(overflow), .alu_zero,
						          .Branch, .UncondBranch, .BranchLessThan, .BranchReg, // ctrl signal inputs
						          .pc, .next_instr_pc, .instr);
									 
	// Instruction decode
	instr_decode instr_decode (.clk, .rst, .instr, .DatapathOutput, 
							         .RegWrite, .Reg2Loc, .SignExtend, .ALUSrc, .PCWrite,
							         .ReadData2(RegReadData2), .ALUInput1, .ALUInput2, .next_instr_pc,
										.reg_outputs(regs));
										
	// ALU
	alu alu (.A(ALUInput1), .B(ALUInput2), .cntrl(ALUCtrl), .result(ALUOutput),
	         .negative(alu_neg), .zero(alu_zero), .overflow(alu_overflow), .carry_out(alu_cout));
	
	// Flip-flops to store Flags
	Enabled_D_FF dff1 (.q(zero),      .d(alu_zero),      .enable(FlagWrite), .reset(rst), .clk);
	Enabled_D_FF dff2 (.q(neg),       .d(alu_neg),       .enable(FlagWrite), .reset(rst), .clk);
	Enabled_D_FF dff3 (.q(overflow),  .d(alu_overflow),  .enable(FlagWrite), .reset(rst), .clk);
	Enabled_D_FF dff4 (.q(cout),      .d(alu_cout),      .enable(FlagWrite), .reset(rst), .clk);
	
	// Data memory
	datamem dm (.address(ALUOutput), .write_enable(MemWrite), .read_enable(MemRead),
               .write_data(RegReadData2), .clk, .xfer_size(4'd8), .read_data(MemReadData),
					.mem(datamem));
	
	// MemToReg mux
	genvar i;
	generate
		for (i = 0; i < 64; i++) begin : eachMux
			mux_2_1 m1 (.d({MemReadData[i], ALUOutput[i]}), .s(MemToReg), .y(DatapathOutput[i]));
		end
	endgenerate
	
endmodule


module cpu_testbench();
	logic clk, rst;
	logic zero, neg, overflow, cout;          // Stored Flag values
	logic [63:0] pc;                          // Current PC
	logic [31:0][63:0] regs;                  // Registers
	logic [7:0] datamem [`DATA_MEM_SIZE-1:0]; // Datamem
	
	parameter ClockDelay = 10000;
	integer i;
	
	cpu cpu (.clk, .rst, .zero, .neg, .overflow, .cout, .pc, .regs, .datamem);
	
	initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end
	
	initial begin
		rst <= 1'b1;
		@(posedge clk);
		rst <= 1'b0;
	
		for (i = 0; i < 100; i++) begin
			@(posedge clk); // loop through instructions
		end
		
		$stop;
	end
endmodule


