`timescale 1ns / 1ps

module EXE(
		input wire clk, rstn, i_EXE_dmemWe, i_EXE_regWe, i_EXE_sA, i_EXE_sB, i_EXE_sByte, i_EXE_sWRD, i_EXE_srs, i_EXE_clr,
		input wire [3:0] i_EXE_brOP,
		input wire [4:0] i_EXE_aluOP, i_EXE_WRA,
		input wire [25:0] i_EXE_lowPC,
		input wire [31:0] i_EXE_rd1, i_EXE_rd2, i_EXE_num, i_EXE_PC,

		output wire o_EXE_dmemWe, o_EXE_regWe, o_EXE_sByte, o_EXE_sWRD, o_EXE_clr,
		output wire [4:0] o_EXE_WRA,
		output wire [31:0] o_EXE_rd2, o_EXE_aluOut, o_EXE_PC
	);
	
	reg EXE_dmemWe, EXE_regWe, EXE_sA, EXE_sB, EXE_sByte, EXE_sWRD, EXE_srs;
	reg [3:0] EXE_brOP;
	reg [4:0] EXE_aluOP, EXE_WRA;
	reg [25:0] EXE_lowPC;
	reg [31:0] EXE_rd1, EXE_rd2, EXE_num, EXE_PC;

	assign o_EXE_dmemWe = EXE_dmemWe;
	assign o_EXE_regWe = EXE_regWe;
	assign o_EXE_sByte = EXE_sByte;
	assign o_EXE_sWRD = EXE_sWRD;
	assign o_EXE_WRA = EXE_WRA;
	assign o_EXE_rd2 = EXE_rd2;

	always @(posedge clk or negedge rstn) begin
		if (!rstn || i_EXE_clr) begin
			EXE_dmemWe <= 0;
			EXE_regWe <= 0;
			EXE_srs <= 0;
			EXE_sA <= 0;
			EXE_sB <= 0;
			EXE_sByte <= 0;
			EXE_sWRD <= 0;
			EXE_brOP <= 0;
			EXE_aluOP <= 0;
			EXE_WRA <= 0;
			EXE_lowPC <= 0;
			EXE_rd1 <= 0;
			EXE_rd2 <= 0;
			EXE_num <= 0;
			EXE_PC <= 0;
		end else begin
			EXE_dmemWe <= i_EXE_dmemWe;
			EXE_regWe <= i_EXE_regWe;
			EXE_srs <= i_EXE_srs;
			EXE_sA <= i_EXE_sA;
			EXE_sB <= i_EXE_sB;
			EXE_sByte <= i_EXE_sByte;
			EXE_sWRD <= i_EXE_sWRD;
			EXE_brOP <= i_EXE_brOP;
			EXE_aluOP <= i_EXE_aluOP;
			EXE_WRA <= i_EXE_WRA;
			EXE_lowPC <= i_EXE_lowPC;
			EXE_rd1 <= i_EXE_rd1;
			EXE_rd2 <= i_EXE_rd2;
			EXE_num <= i_EXE_num;
			EXE_PC <= i_EXE_PC;
		end
	end

	wire [31:0] muxA0_rsA, muxA_A, muxB_B;

	mux #32 muxA0(
		.in0						(EXE_rd1),
		.in1						(EXE_PC),
		.select						(EXE_srs),
		.out 						(muxA0_rsA));
	mux #32 muxA(
		.in0						(muxA0_rsA),
		.in1						(EXE_num),
		.select						(EXE_sA),
		.out						(muxA_A));
	mux #32 muxB(
		.in0						(EXE_rd2),
		.in1						(EXE_num),
		.select						(EXE_sB),
		.out						(muxB_B));
	ALU alu(
		.i_ALU_srcA					(muxA_A),
		.i_ALU_srcB					(muxB_B),
		.i_ALU_op					(EXE_aluOP),
		.o_ALU_aluOut				(o_EXE_aluOut));
	BranchUnit branch_unit(
		.i_BranchUnit_A 			(EXE_rd1),
		.i_BranchUnit_B 			(EXE_rd2),
		.i_BranchUnit_brOP			(EXE_brOP),
		.i_BranchUnit_target		(EXE_lowPC),
		.i_BranchUnit_PC			(EXE_PC),
		.o_BranchUnit_PC			(o_EXE_PC),
		.o_BranchUnit_clr			(o_EXE_clr));
endmodule