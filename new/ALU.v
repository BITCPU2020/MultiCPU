`timescale 1ns / 1ps

module ALU(
		input wire [31:0] i_ALU_srcA, i_ALU_srcB,
		input wire [4:0] i_ALU_op,
		output wire [31:0] o_ALU_aluOut
	);

	parameter OP_ADD = 5'd1;
	parameter OP_SUB = 5'd2;
	parameter OP_AND = 5'd3;
	parameter OP_OR = 5'd4;
	parameter OP_XOR = 5'd5;
	parameter OP_NOR = 5'd6;
	parameter OP_CMP = 5'd7;
	parameter OP_CMPU = 5'd8;
	parameter OP_SL = 5'd9;
	parameter OP_SR = 5'd10;
	parameter OP_SRA = 5'd11;
	parameter OP_LUI = 5'd12;
	parameter OP_XAL = 5'd13;


	wire [32:0] ext_A = {i_ALU_srcA[31], i_ALU_srcA};	// sign_extend_A
	wire [32:0] ext_B = {i_ALU_srcB[31], i_ALU_srcB};	// sign_extend_B

	wire signed [31:0] signed_A = i_ALU_srcA;
	wire signed [31:0] signed_B = i_ALU_srcB;

	wire [32:0] result_ext_add = ext_A + ext_B;
	wire [32:0] result_ext_sub = ext_A - ext_B;

	wire [31:0] result_and = i_ALU_srcA & i_ALU_srcB;
	wire [31:0] result_or = i_ALU_srcA | i_ALU_srcB;
	wire [31:0] result_xor = i_ALU_srcA ^ i_ALU_srcB;
	wire [31:0] result_nor = ~result_or;

	wire [31:0] result_cmpu = (i_ALU_srcA < i_ALU_srcB) ? 32'b1 : 32'b0;

	wire [31:0] result_cmp = (signed_A < signed_B) ? 32'b1 : 32'b0;

	wire [31:0] result_sl = i_ALU_srcB << i_ALU_srcA;
	wire [31:0] result_sr = i_ALU_srcB >> i_ALU_srcA;
	wire [31:0] result_sra = signed_B >>> i_ALU_srcA;

	wire [31:0] result_lui = {i_ALU_srcB[15:0], 16'b0};

	wire [31:0] result_xal = i_ALU_srcA + 4;

	assign o_ALU_aluOut = 
		(i_ALU_op == OP_ADD) ? result_ext_add[31:0] :
		(i_ALU_op == OP_SUB) ? result_ext_sub[31:0] :
		(i_ALU_op == OP_AND) ? result_and :
		(i_ALU_op == OP_OR) ? result_or :
		(i_ALU_op == OP_XOR) ? result_xor :
		(i_ALU_op == OP_NOR) ? result_nor :
		(i_ALU_op == OP_CMPU) ? result_cmpu :
		(i_ALU_op == OP_CMP) ? result_cmp :
		(i_ALU_op == OP_SL) ? result_sl :
		(i_ALU_op == OP_SR) ? result_sr :
		(i_ALU_op == OP_SRA) ? result_sra :
		(i_ALU_op == OP_LUI) ? result_lui :
		(i_ALU_op == OP_XAL) ? result_xal :
		32'b0;
			
endmodule