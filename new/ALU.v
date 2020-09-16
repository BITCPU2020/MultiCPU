`timescale 1ns / 1ps

module ALU(
		input wire [31:0] i_ALU_srcA, i_ALU_srcB,
		input wire [5:0] i_ALU_op,
		output wire [31:0] o_ALU_aluOut
	);

	wire [32:0] eA = {i_ALU_srcA[31], i_ALU_srcA};	// extend_A
	wire [32:0] eB = {i_ALU_srcB[31], i_ALU_srcB};	// extend_B
	wire [32:0] eSum = eA + eB;
	wire [31:0] luiAns = {x2[15:0], 16'b0};

	// todo
			
endmodule