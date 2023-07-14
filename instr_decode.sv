// Naisan Noorassa & Sabrina Hwang
// CSE 469: Computer Architecture
// 11/10/22
// 
// Module that models the instruction decode phase of instruction execution

`timescale 1ns/10ps
`define DATA_MEM_SIZE		1024

module instr_decode (clk, rst, instr, DatapathOutput, 
							RegWrite, Reg2Loc, SignExtend, ALUSrc, PCWrite,
							ReadData2, ALUInput1, ALUInput2, next_instr_pc, reg_outputs);
							
	input logic [31:0] instr;
	input logic clk, rst, Reg2Loc, RegWrite, SignExtend, PCWrite, ALUSrc;
	input logic [63:0] DatapathOutput, next_instr_pc;
	output logic [63:0] ALUInput1, ALUInput2;
	output logic [63:0] ReadData2;
	output logic [31:0][63:0] reg_outputs;
	
	logic [4:0]    R30;
	logic [4:0]    Rn, Rm, Rd;
	logic	[4:0] 	ReadRegister1, ReadRegister2, WriteRegister;
	logic [63:0]	ReadData1;
	logic [63:0]   WriteData;
	
	logic [63:0] ALUImm;
	logic [63:0] DTAddr;	
	logic [63:0] temp;
	
	assign Rn = instr[9:5];
	assign Rm = instr[20:16];
	assign Rd = instr[4:0];
	assign R30 = 5'd30;
	
	
	// **** Pick Read1, Read2, and Write Registers **** //
	assign ReadRegister1 = Rn;
	
	// WriteRegister chooses between Rd and 30 (hardcoded for BL)
	// ReadRegister2 chooses between Rm and Rd
	genvar i;
	generate
		for (i = 0; i < 5; i++) begin : eachMux1
			mux_2_1 m1 (.d({Rd[i], Rm[i]}), .s(Reg2Loc), .y(ReadRegister2[i]));
			
			mux_2_1 m2 (.d({R30[i], Rd[i]}), .s(PCWrite), .y(WriteRegister[i]));
		end
	endgenerate
	

	
	// **** Pick ALU Inputs **** //
	assign ALUInput1 = ReadData1;
	
	assign ALUImm = {52'b0, instr[21:10]}; // Zero-extended ALU immediate
	assign DTAddr = {{55{instr[20]}}, instr[20:12]}; // Sign-extended DT address

	// ALU Input 2 chooses between ReadData2, ALUImm, and DTAddr
	genvar j;
	generate
		for (j = 0; j < 64; j++) begin : eachMux2
			mux_2_1 m3 (.d({DTAddr[j], ALUImm[j]}), .s(SignExtend), .y(temp[j]));
			mux_2_1 m4 (.d({temp[j], ReadData2[j]}), .s(ALUSrc), .y(ALUInput2[j]));
		end
	endgenerate
	
	
	// *** Pick WriteData *** //
	generate
		for (i = 0; i < 64; i++) begin : eachMux3
			// WriteData chooses between next_instr_pc (for BL instr) and DatapathOutput
			mux_2_1 m5 (.d({next_instr_pc[i], DatapathOutput[i]}), .s(PCWrite), .y(WriteData[i]));
		end
	endgenerate

	// Instantiate Register file
	regfile rf (.ReadRegister1, .ReadRegister2, .WriteRegister, .WriteData, .RegWrite, .clk, .ReadData1, .ReadData2, .reg_outputs);
endmodule


module instr_decode_testbench();
	logic [31:0] instr;
	logic clk, rst, Reg2Loc, RegWrite, SignExtend, PCWrite, ALUSrc;
	logic [63:0] DatapathOutput, next_instr_pc;
	logic [63:0] ALUInput1, ALUInput2;
	logic [63:0] ReadData2;
	
	parameter ClockDelay = 5000;
	
	instr_decode dut (.clk, .rst, .instr, .DatapathOutput, 
							.RegWrite, .Reg2Loc, .SignExtend, .ALUSrc, .PCWrite,
							.ReadData2, .ALUInput1, .ALUInput2, .next_instr_pc);
							
	initial begin // Set up the clock
		clk <= 0;
		instr <= 0;
		DatapathOutput <= 0;
		RegWrite <= 0;
		Reg2Loc <= 0;
		SignExtend <= 0;
		ALUSrc <= 0;
		PCWrite <= 0;

		forever #(ClockDelay/2) clk <= ~clk;
	end
	
	initial begin
		rst <= 1'b1;
		@(posedge clk);
		rst <= 1'b0;
	
		instr <= 32'b1001000100_000000000001_11111_00000; // ADDI X0, X31, #1
		Reg2Loc = 1'bx;
		RegWrite = 1'b1;
		SignExtend = 1'b0;
		ALUSrc = 1'b1;
		PCWrite = 1'b0;
		
		@(posedge clk);
		
		#(ClockDelay/4); // Wait for outputs to stabilize
		assert(ALUInput1 == 0);
		assert(ALUInput2 == 1);
		assert(ReadData2 == 0);
		
		@(posedge clk);
		
		instr <= 32'b11101011000_00000_000000_11111_00001; // SUBS X1, X31, X0
		Reg2Loc = 1'b0;
		RegWrite = 1'b1;
		SignExtend = 1'bx;
		ALUSrc = 1'b0;
		PCWrite = 1'b0;
		
		@(posedge clk);
		
		#(ClockDelay/4); // Wait for outputs to stabilize
		assert(ALUInput1 == 0);
		assert(ALUInput2 == ReadData2);
		
		$stop;
	end

endmodule



