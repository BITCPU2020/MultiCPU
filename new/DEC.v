`timescale 1ns / 1ps

module DEC(
		input wire clk, rstn, i_DEC_we, i_DEC_swra, i_DEC_BRop, i_DEC_sign,
		input wire [5:0] i_DEC_rt, i_DEC_rd,
		input wire [??:0] i_DEC_BRop,
		input wire [15:0] i_DEC_branchOffset, i_DEC_num,
		input wire [25:0] i_DEC_jumpTarget,
		input wire [31:0] i_DEC_ra1, i_DEC_ra2, i_DEC_writeAddr, i_DEC_writeData,
		input wire [31:0] i_DEC_aluOutE, i_DEC_dMemRDataM, i_DEC_rstW,
		
		output wire o_PauseUnit_pause,
		output wire [31:0] o_DEC_pc, o_DEC_num, o_DEC_WRA, o_DEC_rd1, o_DEC_rd2
    );
    
	reg [??:0] DEC_BRop;
	reg [15:0] DEC_branchOffset, DEC_num;
	reg [25:0] DEC_jumpTarget;
	reg DEC_we, DEC_sign, DEC_swra;
	reg [31:0] DEC_ra1, DEC_ra2, DEC_writeAddr, DEC_writeData, DEC_aluOutE, DEC_dMemRDataM, DEC_rstW;

	always @(posedge clk or negedge rst) begin
		if (!rstn) begin
			DEC_BRop <= 0;
			DEC_branchOffset <= 0;
			DEC_num <= 0;
			DEC_jumpTarget <= 0;
			DEC_we <= 0;
			DEC_sign <= 0;
			DEC_ra1 <= 0;
			DEC_ra2 <= 0;
			DEC_writeAddr <= 0;
			DEC_writeData <= 0;
			DEC_aluOutE <= 0;
			DEC_dMemRDataM <= 0;
			DEC_rstW <= 0;
		end else begin
			DEC_BRop <= i_DEC_BRop;
			DEC_branchOffset <= i_DEC_branchOffset;
			DEC_num <= i_DEC_num;
			DEC_jumpTarget <= i_DEC_jumpTarget;
			DEC_we <= i_DEC_we;
			DEC_sign <= i_DEC_sign;
			DEC_ra1 <= i_DEC_ra1;
			DEC_ra2 <= i_DEC_ra2;
			DEC_writeAddr <= i_DEC_writeAddr;
			DEC_writeData <= i_DEC_writeData;
			DEC_aluOutE <= i_DEC_aluOutE;
			DEC_dMemRDataM <= i_DEC_dMemRDataM;
			DEC_rstW <= i_DEC_rstW;
		end
	end

	wire [31:0] RegistorFile_rd1, RegistorFile_rd2;
    RegistorFile registor_file(
    	.clk						(clk),
    	.rstn						(rstn),
    	.i_RegistorFile_we			(DEC_we),
    	.i_RegistorFile_ra1			(DEC_ra1),
    	.i_RegistorFile_ra2			(DEC_ra2),
    	.i_RegistorFile_writeAddr	(DEC_writeAddr),
    	.i_RegistorFile_writeData	(DEC_writeData),
    	.o_RegistorFile_rd1			(RegistorFile_rd1),
    	.o_RegistorFile_rd2			(RegistorFile_rd2));
    NumExtend num_extend(
    	.i_NumExtend_num			(DEC_num),
    	.i_NumExtend_sign			(DEC_sign),
    	.o_NumExtend_num			(o_DEC_num));
    BranchUnit branch_unit(
    	.i_BranchUnit_BRop			(DEC_BRop),
		.i_BranchUnit_A 			(RegistorFile_rd1),
		.i_BranchUnit_B 			(RegistorFile_rd2),
		.i_BranchUnit_branchOffset	(DEC_branchOffset),
		.i_BranchUnit_jumpTarget	(DEC_jumpTarget),
		.o_BranchUnit_pc			(o_DEC_pc));
    PauseUnit pause_unit(
    	.clk						(clk),
    	.rstn						(rstn),
		.i_PauseUnit_aluOutE		(DEC_aluOutE),
		.i_PauseUnit_dMemRDataM		(DEC_dMemRDataM),
		.i_PauseUnit_W 				(DEC_rstW),
		.i_PauseUnit_ra1			(DEC_ra1),
		.i_PauseUnit_ra2			(DEC_ra2),
		.i_PauseUnit_rd1			(RegistorFile_rd1),
		.i_PauseUnit_rd2			(RegistorFile_rd2),
		.o_PauseUnit_pause			(o_DEC_pause),
		.o_PauseUnit_rd1			(o_DEC_rd1),
		.o_PauseUnit_rd2			(o_DEC_rd2));
    mux #5 muxWA(
    	.in0						(DEC_rt),
    	.in1						(DEC_rd),
    	.select						(DEC_swrsa),
    	.out						(o_DEC_WRA));
    
endmodule
