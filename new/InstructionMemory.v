`timescale 1ns / 1ps

module InstructionMemory(
		input wire [31:0] i_iMem_addr,
		output wire [31:0] o_iMem_data
	);
	
	reg [7:0] imem[255:0];
	initial begin
		$readmemh("D:/inst.txt", imem);
	end

	wire [7:0] addr = i_iMem_addr[7:0];
	assign o_iMem_data = {imem[i_iMem_addr+3] , imem[i_iMem_addr+2], imem[i_iMem_addr+1], imem[i_iMem_addr]};
endmodule