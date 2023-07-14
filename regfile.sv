// Naisan Noorassa & Sabrina Hwang
// CSE 469: Computer Architecture
// 10/13/2022
// 
// Module that constructs a 32 by 64 register file, which has stored an array
// of 32 different 64-bit registers that are constructed from positive 
// edge-triggered D flip-flops. 
// 
// Parameters: 
//		ReadData1: 		Bus that has stored the values being output
//		ReadData2: 		Bus that has stored the values being output
//		WriteData: 		Data that is being written
//		ReadRegister1: Selects the registers whose values are output on the 
//							ReadData1 bus
//		ReadRegister2: Selects the registers whose values are output on the 
//							ReadData2 bus
//		WriteRegister: Input bus that selects the target of the write
// 	RegWrite: 		Enables information on WriteData to be written into the
//							register
//		clk: 				Clock being used		

`timescale 1ns/10ps

module regfile (ReadData1, ReadData2, WriteData, 
					 ReadRegister1, ReadRegister2, WriteRegister,
					 RegWrite, clk, reg_outputs);

					 
	input logic	[4:0] 	ReadRegister1, ReadRegister2, WriteRegister;
	input logic [63:0]	WriteData;
	input logic 			RegWrite, clk;
	output logic [63:0]	ReadData1, ReadData2;
	
	output logic [31:0][63:0] reg_outputs;
	logic [31:0] write_enables;
	
	dec_1_32 dec (.d(RegWrite), .sel(WriteRegister), .y(write_enables));
	
	genvar i;
	generate
		for (i = 0; i < 31; i++) begin : eachReg
			register r (.clk(clk), .rst(1'b0), .data_in(WriteData), .write_enable(write_enables[i]), .data_out(reg_outputs[i]));
		end
	endgenerate
	
	// 31 register is hardwired to zero 
	assign reg_outputs[31] = 64'b0;
	
	mux_64_32_1 mux1 (.d(reg_outputs), .s(ReadRegister1), .y(ReadData1));
						
	mux_64_32_1 mux2 (.d(reg_outputs), .s(ReadRegister2), .y(ReadData2));
	
endmodule
