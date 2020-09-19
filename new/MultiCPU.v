`timescale 1ns / 1ps

module MultiCPU(
		input wire clk, rstn
	);

	wire [31:0] PCF, instF;
	FTC ftc(
		.clk					(clk),
		.rstn					(rstn),
		.i_FTC_pause			(pauseD),
		.i_FTC_we				(clrE),
		.i_FTC_pc				(PCE),
		.o_FTC_inst				(instF),
		.o_FTC_pc				(PCF));

	wire dMemWeD, regWeD, sWRDD, pauseD, sA0D, sAD, sBD, sByteD;
	wire [3:0] brOPD;
	wire [4:0] aluOPD, WRAD;
	wire [15:0] lowPCD;
	wire [31:0] numD, rd1D, rd2D;
	DEC dec(
		.clk					(clk),
		.rstn					(rstn),
		.i_DEC_regWeW			(regWeW),
		.i_DEC_WRAW				(WRAW),
		.i_DEC_PC				(PCF),
		.i_DEC_inst				(instF),
		.i_DEC_aluOutE			(aluOutE),
		.i_DEC_dMemRDataM		(dMemRDataM),
		.i_DEC_rstW				(rstW),
		.o_DEC_regWe			(regWeD),
		.o_DEC_dMemWe			(dMemWeD),
		.o_DEC_sWRD				(sWRDD),
		.o_DEC_pause			(pauseD),
		.o_DEC_sA0				(sA0D),
		.o_DEC_sA				(sAD),
		.o_DEC_sB				(sBD),
		.o_DEC_sByte			(sByteD),
		.o_DEC_brOP				(brOPD),
		.o_DEC_aluOP			(aluOPD),
		.o_DEC_WRA				(WRAD),
		.o_DEC_lowPC			(lowPCD),
		.o_DEC_PC				(PCD),
		.o_DEC_num				(numD),
		.o_DEC_rd1				(rd1D),
		.o_DEC_rd2				(rd2D));
	wire dMemWeE, regWeE, sByteE, sWRDE, clrE;
	wire [4:0] WRAE;
	wire [31:0] rd2E, aluOutE, PCE;
	EXE exe(
		.clk					(clk),
		.rstn					(rstn),
		.i_EXE_regWe			(regWeD),
		.i_EXE_dmemWe			(dMemWeD),
		.i_EXE_sA				(sAD),
		.i_EXE_sB				(sBD),
		.i_EXE_sByte			(sByteD),
		.i_EXE_sWRD				(sWRDD),
		.i_EXE_pause			(pauseD),
		.i_EXE_brOP				(brOPD),
		.i_EXE_aluOP			(aluOPD),
		.i_EXE_WRA				(WRAD),
		.i_EXE_rd1				(rd1D),
		.i_EXE_rd2				(rd2D),
		.i_EXE_num				(numD),
		.i_EXE_PC				(PCD),
		.o_EXE_dmemWe			(dMemWeE),
		.o_EXE_regWe			(regWeE),
		.o_EXE_sByte			(sByteE),
		.o_EXE_sWRD				(sWRDE),
		.o_EXE_clr				(clrE),
		.o_EXE_WRA				(WRAE),
		.o_EXE_rd2				(rd2E),
		.o_EXE_aluOut			(aluOutE),
		.o_EXE_PC				(PCE));
	wire regWeM;
	wire [4:0] WRAM;
	wire [31:0] WRDM;
	MEM mem(
		.clk					(clk),
		.rstn					(rstn),
		.i_MEM_regWe			(regWeE),
		.i_MEM_dMemWe			(dMemWeE),
		.i_MEM_sByte			(sByteE),
		.i_MEM_sWRD				(sWRDE),
		.i_MEM_WRA				(WRAE),
		.i_MEM_aluOut			(aluOutE),
		.i_MEM_rd2				(rd2E),	
		.o_MEM_regWe			(regWeM),
		.o_MEM_WRA				(WRAM),
		.o_MEM_WRD				(WRDM));
	wire regWeW;
	wire [4:0] WRAW;
	wire [31:0] rstW;
	WRT wrt(
		.clk					(clk),
		.rstn					(rstn),
		.i_WRT_regWe			(regWeM),
		.i_WRT_WRA				(WRAM),
		.i_WRT_WRD				(WRDM),
		.o_WRT_regWe			(regWeW),
		.o_WRT_WRA				(WRAW),
		.o_WRT_rstW				(rstW));
endmodule