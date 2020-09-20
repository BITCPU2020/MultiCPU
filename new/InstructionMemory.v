`timescale 1ns / 1ps

module InstructionMemory(
		input wire [31:0] i_InstructionMemory_PC,
		output wire [31:0] o_InstructionMemory_inst
	);
	
	reg [7:0] imem[255:0];
	initial begin
		$readmemh("D:/inst.txt", imem);
	end

	wire [7:0] addr = i_InstructionMemory_PC[7:0];
	assign o_InstructionMemory_inst = {imem[addr+3] , imem[addr+2], imem[addr+1], imem[addr]};
endmodule