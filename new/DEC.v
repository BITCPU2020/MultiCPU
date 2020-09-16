`timescale 1ns / 1ps

module DEC(
		input wire clk, rstn, i_DEC_regWe,
		input wire [4:0] i_DEC_WRA;
		input wire [31:0] i_DEC_pc, i_DEC_inst,
		input wire [31:0] i_DEC_aluOutE, i_DEC_dMemRDataM, i_DEC_rstW,
		output wire o_DEC_regWe, o_DEC_dMemWe, o_DEC_swd,
		output wire [3:0] o_DEC_ALUop,
		output wire [4:0] o_DEC_WRA,
		output wire [31:0] o_DEC_pc, o_DEC_num, o_DEC_WRA, o_DEC_rd1, o_DEC_rd2
    );
    
	reg DEC_regWe;
	reg DEC_WRA;
	reg [31:0] DEC_pc, DEC_inst, DEC_aluOutE, DEC_dMemRDataM, DEC_rstW;

	always @(posedge clk or negedge rstn) begin
		if (!rstn) begin
			DEC_regWe <= 0;
			DEC_WRA <= 0;
			DEC_pc <= 0;
			DEC_inst <= 0;
			DEC_aluOutE <= 0;
			DEC_dMemRDataM <= 0;
			DEC_rstW <= 0;
		end else begin
			DEC_regWe <= i_DEC_regWe;
			DEC_WRA <= i_DEC_WRA;
			DEC_pc <= i_DEC_pc;
			DEC_inst <= i_DEC_inst;
			DEC_aluOutE <= i_DEC_aluOutE;
			DEC_dMemRDataM <= i_DEC_dMemRDataM;
			DEC_rstW <= i_DEC_rstW;
		end
	end

	wire [31:0] RegistorFile_rd1, RegistorFile_rd2;
	wire PauseUnit_pause;
	wire [5:0] DEC_opcodeF, DEC_functF;
	wire ControlUnit_sA1, ControlUnit_sA2, ControlUnit_sB, ControlUnit_swa;
	wire [4:0] DEC_ra1, DEC_ra2;
	wire [15:0] DEC_num, DEC_branchOffset;
	wire [25:0] DEC_jumpTarget;
	wire [3:0] DEC_BRop;

	assign DEC_opcode = DEC_inst[31:26];
	assign DEC_ra1 = DEC_inst[25:21];
	assign DEC_ra2 = DEC_inst[20:16];
	assign DEC_rt = DEC_inst[20:16];
	assign DEC_rd = DEC_inst[15:11];
	assign o_DEC_sa = DEC_inst[10:6];
	assign DEC_funct = DEC_inst[5:0];
	assign DEC_num = DEC_inst[15:0];
	assign DEC_offset = DEC_inst[15:0];
	assign DEC_target = DEC_inst[25:0];

	ControlUnit ctrl(
		.i_ControlUnit_opcode		(DEC_opcode),
		.i_ControlUnit_funct		(DEC_funct),
		.o_ContrlUnit_sA1			(ControlUnit_sA1),
		.o_ContrlUnit_sA2			(ControlUnit_sA2),
		.o_ContrlUnit_sB			(ControlUnit_sB),
		.o_ContrlUnit_swa			(o_DEC_swa),
		.o_ContrlUnit_swd			(o_DEC_swd),
		.o_ContrlUnit_isLoad		(ControlUnit_isLoad),
		.o_ContrlUnit_sign			(ControlUnit_sign),
		.o_ContrlUnit_sALU			(o_DEC_ALUop),
		.o_ContrlUnit_BRop			(ControlUnit_BRop),
		.o_ContrlUnit_dMemWe		(ControlUnit_dMemWe),
		.o_ContrlUnit_regWe			(ControlUnit_regWe)
		);
    RegistorFile registor_file(
    	.clk						(clk),
    	.rstn						(rstn),
    	.i_RegistorFile_we			(DEC_regWe),
    	.i_RegistorFile_ra1			(DEC_ra1),
    	.i_RegistorFile_ra2			(DEC_ra2),
    	.i_RegistorFile_wRA			(DEC_WRA),
    	.i_RegistorFile_rstW		(DEC_rstW),
    	.o_RegistorFile_rd1			(RegistorFile_rd1),
    	.o_RegistorFile_rd2			(RegistorFile_rd2));
    NumExtend num_extend(
    	.i_NumExtend_num			(DEC_num),
    	.i_NumExtend_sign			(ControlUnit_sign),
    	.o_NumExtend_num			(o_DEC_num));
    BranchUnit branch_unit(
    	.i_BranchUnit_BRop			(DEC_BRop),
		.i_BranchUnit_A 			(RegistorFile_rd1),
		.i_BranchUnit_B 			(RegistorFile_rd2),
		.i_BranchUnit_branchOffset	(DEC_branchOffset),
		.i_BranchUnit_jumpTarget	(DEC_jumpTarget),
		.i_BranchUnit_pause			(PauseUnit_pause),
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
		.o_PauseUnit_pause			(PauseUnit_pause),
		.o_PauseUnit_rd1			(o_DEC_rd1),
		.o_PauseUnit_rd2			(o_DEC_rd2));
    mux #5 muxWA(
    	.in0						(DEC_rt),
    	.in1						(DEC_rd),
    	.select						(DEC_swa),
    	.out						(o_DEC_WRA));
    
endmodule