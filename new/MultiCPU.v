`timescale 1ns / 1ps

module MultiCPU(
		input wire clk, rstn
    );
	
	wire [5:0] opcodeF, functF;
	wire [4:0] rsF, rtF, rdF, saF;
	wire [15:0] offsetF, numF;
	wire [16:0] targetF;
	wire [31:0] instF;
	
	wire sA1D, sA2D, sBD, swaD, swdD, isLoadD, signD, dMemWeD, regWeD;
	wire [3:0] sALUD;
	wire [3:0] BRopD;

	wire [31:0] aluOutE;
    
//    wire
    
	assign opcodeF = instF[31:26];
	assign ra1F = instF[25:21];
	assign ra2F = instF[20:16];
	assign rsF = instF[25:21];
	assign rtF = instF[20:16];
	assign rdF = instF[15:11];
	assign saF = instF[10:6];
	assign functF = instF[5:0];
	assign numF = instF[15:0];
	assign offsetF = instF[15:0];
	assign targetF = instF[25:0];

	FTC ftc(
    	.clk					(clk),
    	.rstn					(rstn),
		.i_FTC_pc				(pcD),
		.o_FTC_inst				(instF)
		.o_FTC_pc				(pcF));
    DEC dec(
    	.clk					(clk),
		.rstn					(rstn),
		.i_DEC_regWe			(regWeW),
		.i_DEC_WRA				(WRAW),
		.i_DEC_pc				(pcF),
		.i_DEC_inst				(instF),
		.i_DEC_aluOutE			(aluOutE),
		.i_DEC_dMemRDataM		(dMemRDataM),
		.i_DEC_rstW				(rstW),
		.o_DEC_regWe			(regWeD),
		.o_DEC_dMemWe			(dMemWeD),
		.o_DEC_swd				(swdD),
		.o_DEC_ALUop			(sALUD),
		.o_DEC_WRA				(WRAD),
		.o_DEC_sa				(saD)
		.o_DEC_pc				(pcD),
		.o_DEC_num				(eNumD),
		.o_DEC_rd1				(rd1D),
		.o_DEC_rd2				(rd2D));
    EXE exe(
    	.clk					(clk),
		.rstn					(rstn),
		.i_EXE_WRA				(WRAD),
		.i_EXE_dmemWe			(dMemWeD),
		.i_EXE_regWe			(regWeD),
		.i_EXE_sA1				(sA1D),
		.i_EXE_sA2				(sA2D),
		.i_EXE_sB				(sBD),
		.i_EXE_sWD				(swdD),
		.i_EXE_ALUop			(sALUD),
		.i_EXE_rd1				(rd1D),
		.i_EXE_rd2				(rd2D),
		.i_EXE_num				(eNumD),
		.i_EXE_sa				(saD),
		.o_EXE_dmemWe			(dMemWeE),
		.o_EXE_regWe			(regWeE),
		.o_EXE_sWD				(swdE),
		.o_EXE_WRA				(WRAE),
		.o_EXE_aluOut			(aluOutE)
		.o_EXE_rd2				(rd2E));
    MEM mem(
    	.clk					(clk),
		.rstn					(rstn),
		.i_MEM_regWe			(regWeE),
		.i_MEM_dMemWe			(dMemWeE),
		.i_MEM_sWD				(swdE)
		.i_MEM_WRA				(WRAE),
		.i_MEM_aluOut			(aluOutE),
		.i_MEM_rd2				(rd2E),	
		.o_MEM_regWe			(regWeF),
		.o_MEM_sWD				(swdM)
		.o_MEM_WRA				(WRAF),
		.o_MEM_rData			(dMemRDataM),
		.o_MEM_aluOut			(aluOutM));
    WRT wrt(
    	.clk					(clk),
    	.rstn					(rstn),
		.i_WRT_regWe			(regWeM),
		.i_WRT_sWD				(swdM),
		.i_WRT_WRA				(WRAM),
		.i_WRT_aluOut			(aluOutM),
		.i_WRT_dMemData			(dMemRDataM),
		.o_WRT_regWe			(regWeW),
		.o_WRT_WRA				(WRAW),
		.o_WRT_rstW				(rstW));
endmodule