`timescale 1ns / 1ps

module EXE(
		input wire clk, rstn,
		input wire [4:0] i_EXE_WRA,
		input wire i_EXE_dmemWe, i_EXE_regWe, i_EXE_sA1, i_EXE_sA2, i_EXE_sB, i_EXE_sWD,

		input wire [5:0] i_EXE_ALUop,
		input wire [31:0] i_EXE_rd1, i_EXE_rd2, i_EXE_num, i_EXE_sa,

		output wire o_EXE_dmemWe, o_EXE_regWe, o_EXE_sWD,

		output wire [4:0] o_EXE_WRA, o_EXE_sa
		output wire [31:0] o_EXE_aluOut,
		output wire [31:0] o_EXE_rd2,
	);
	
	reg EXE_dmemWe, EXE_regWe, EXE_sA1, EXE_sA2, EXE_sB, EXE_sWD;
	reg [4:0] EXE_WRA;
	reg [5:0] EXE_ALUop;
	reg [31:0] EXE_rd1, EXE_rd2, EXE_num, EXE_sa;

	assign o_EXE_dmemWe = EXE_dmemWe;
	assign o_EXE_regWe = EXE_regWe;
	assign o_EXE_sWD = EXE_sWD;
	assign o_EXE_WRA = EXE_WRA;
	assign o_EXE_rd2 = EXE_rd2;

	always @(posedge clk or negedge rstn) begin
		if (!rstn) begin
			EXE_dmemWe <= 0;
			EXE_regWe <= 0;
			EXE_sA1 <= 0;
			EXE_sA2 <= 0;
			EXE_sB <= 0;
			EXE_sWD <= 0;
			EXE_WRA <= 0;
			EXE_ALUop <= 0;
			EXE_rd1 <= 0;
			EXE_rd2 <= 0;
			EXE_num <= 0;
			EXE_sa <= 0;
		end
		else begin
			EXE_dmemWe <= i_EXE_dmemWe;
			EXE_regWe <= i_EXE_regWe;
			EXE_sA1 <= i_EXE_sA1;
			EXE_sA2 <= i_EXE_sA2;
			EXE_sB <= i_EXE_sB;
			EXE_sWD <= i_EXE_sWD;
			EXE_WRA <= i_EXE_WRA;
			EXE_ALUop <= i_EXE_ALUop;
			EXE_rd1 <= i_EXE_rd1;
			EXE_rd2 <= i_EXE_rd2;
			EXE_num <= i_EXE_num;
			EXE_sa <= i_EXE_sa;
		end
	end

	wire [31:0] EXE_tempA, EXE_A, EXE_B;

	mux #32 muxA1(
		.in0			(EXE_sa),
		.in1			(EXE_num),
		.select			(EXE_sA1),
		.out 			(EXE_tempA));
	mux #32 muxA2(
		.in0			(EXE_tempA),
		.in1			(EXE_rd1),
		.select			(EXE_sA2),
		.out			(EXE_A));
	mux #32 muxB(
		.in0			(EXE_num),
		.in1			(EXE_rd2),
		.select			(EXE_sB),
		.out			(EXE_B));
	ALU alu(
		.i_ALU_srcA		(EXE_A),
		.i_ALU_srcB		(EXE_B),
		.i_ALU_op		(EXE_ALUop),
		.o_ALU_aluOut	(o_EXE_aluOut));
endmodule