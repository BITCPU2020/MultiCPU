`timescale 1ns / 1ps

module DEC(
		input wire clk, rstn, i_DEC_regWeW,
		input wire [4:0] i_DEC_WRAW,
		input wire [31:0] i_DEC_PC, i_DEC_inst,
		input wire [31:0] i_DEC_aluOutE, i_DEC_dMemRDataM, i_DEC_rstW,
		
		output wire o_DEC_regWe, o_DEC_dMemWe, o_DEC_sWRD, o_DEC_pause, o_DEC_sA0, o_DEC_sA, o_DEC_sB, o_DEC_sByte,
		output wire [3:0] o_DEC_brOP,
		output wire [4:0] o_DEC_aluOP, o_DEC_WRA,
		output wire [25:0] o_DEC_lowPC,
		output wire [31:0] o_DEC_PC, o_DEC_num, o_DEC_rd1, o_DEC_rd2
	);
	
	reg DEC_clr, DEC_pause;
	reg [31:0] DEC_PC, DEC_inst;

	assign o_DEC_PC = DEC_PC;
	assign o_DEC_lowPC = DEC_inst[25:0];
	assign o_DEC_inst = DEC_inst;

	always @(posedge clk or negedge rstn) begin
		if (!rstn) begin
			DEC_clr <= 0;
			DEC_pause <= 0;
			DEC_PC <= 0;
			DEC_inst <= 0;
		end else if (!DEC_clr) begin
			DEC_PC <= i_DEC_PC;
			DEC_inst <= i_DEC_inst;
		end
	end

	wire [31:0] RegistorFile_rd1, RegistorFile_rd2;
	wire [15:0] muxImme_imme;
	wire [4:0] muxWA0_WRA0;
	wire PauseUnit_pause;
	wire ControlUnit_sImme, ControlUnit_srtrd, ControlUnit_sWRA, ControlUnit_sign;

	assign DEC_opcode = DEC_inst[31:26];
	assign DEC_ra1 = DEC_inst[25:21];
	assign DEC_ra2 = DEC_inst[20:16];
	assign DEC_rt = DEC_inst[20:16];
	assign DEC_rd = DEC_inst[15:11];
	assign DEC_sa = DEC_inst[10:6];
	assign DEC_funct = DEC_inst[5:0];
	assign DEC_num = DEC_inst[15:0];
	assign DEC_offset = DEC_inst[15:0];
	assign DEC_target = DEC_inst[25:0];

	ControlUnit ctrl(
		.opcode						(DEC_opcode),
		.funct						(DEC_funct),
		.rs							(DEC_rs),
		.rt							(DEC_rt),
		.o_ContrlUnit_sImme			(ControlUnit_sImme),
		.o_ContrlUnit_sA0			(o_DEC_sA0),
		.o_ContrlUnit_sA			(o_DEC_sA),
		.o_ContrlUnit_sB			(o_DEC_sB),
		.o_ContrlUnit_sWRA0			(ControlUnit_sWRA0),
		.o_ContrlUnit_sWRA			(ControlUnit_sWRA),
		.o_ContrlUnit_sWRD			(o_DEC_sWRD),
		.o_ContrlUnit_sLoad			(ControlUnit_isLoad),
		.o_ContrlUnit_sByte			(o_DEC_sByte),
		.o_ContrlUnit_sign			(ControlUnit_sign),
		.o_ContrlUnit_aluOP			(o_DEC_aluOP),
		.o_ContrlUnit_brOP			(o_DEC_brOP),
		.o_ContrlUnit_dMemWe		(o_DEC_dMemWe),
		.o_ContrlUnit_regWe			(o_DEC_regWe)
		);
	RegistorFile registor_file(
		.clk						(clk),
		.rstn						(rstn),
		.i_RegistorFile_regWe		(i_DEC_regWeW),
		.i_RegistorFile_ra1			(DEC_ra1),
		.i_RegistorFile_ra2			(DEC_ra2),
		.i_RegistorFile_WRA			(i_DEC_WRAW),
		.i_RegistorFile_WRD			(i_DEC_rstW),
		.o_RegistorFile_rd1			(RegistorFile_rd1),
		.o_RegistorFile_rd2			(RegistorFile_rd2));
	mux #16 muxImme(
		.in0						(DEC_num),
		.in1						({11'b0, DEC_sa}),
		.select						(ControlUnit_sImme),
		.out						(muxImme_imme));
	NumExtend num_extend(
		.i_NumExtend_num			(muxImme_imme),
		.i_NumExtend_sign			(ControlUnit_sign),
		.o_NumExtend_num			(o_DEC_num));
	PauseUnit pause_unit(
		.clk						(clk),
		.rstn						(rstn),
		.i_PauseUnit_aluOutE		(i_DEC_aluOutE),
		.i_PauseUnit_dMemRDataM		(i_DEC_dMemRDataM),
		.i_PauseUnit_rstW 			(i_DEC_rstW),
		.i_PauseUnit_ra1			(DEC_ra1),
		.i_PauseUnit_ra2			(DEC_ra2),
		.i_PauseUnit_rd1			(RegistorFile_rd1),
		.i_PauseUnit_rd2			(RegistorFile_rd2),
		.i_PauseUnit_regWa			(o_DEC_WRA),
		.i_PauseUnit_regWe			(o_DEC_regWe),
		.i_PauseUnit_isLoad			(ControlUnit_isLoad),
		.o_PauseUnit_pause			(o_DEC_pause),
		.o_PauseUnit_rd1			(o_DEC_rd1),
		.o_PauseUnit_rd2			(o_DEC_rd2));
	mux #5 muxWRA0(
		.in0						(DEC_rt),
		.in1						(DEC_rd),
		.select						(ControlUnit_srtrd),
		.out						(muxWA0_WRA0));
	mux #5 muxWRA(
		.in0						(muxWA0_WRA0),
		.in1						(5'b11111),
		.select						(ControlUnit_sWRA),
		.out						(o_DEC_WRA));
	
endmodule