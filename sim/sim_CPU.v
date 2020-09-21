`timescale 1ns / 1ps

module sim_CPU();
    
    reg clk, rstn;
    
    wire pauseD, clrE;
	wire [31:0] PCF, instF;
	
	wire dMemWeD, regWeD, sWRDD, sA0D, sAD, sBD, sByteD;
	wire [3:0] brOPD;
	wire [4:0] aluOPD, WRAD;
	wire [25:0] lowPCD;
	wire [31:0] numD, rd1D, rd2D, PCD;
	
	wire [31:0] rd2E, aluOutE, PCE;
	wire dMemWeE, regWeE, sByteE, sWRDE;
	wire [4:0] WRAE;
	
	wire regWeM;
	wire [4:0] WRAM;
	wire [31:0] WRDM;
	
	wire regWeW;
	wire [4:0] WRAW;
	wire [31:0] rstW;
    
	FTC ftc(
		.clk					(clk),
		.rstn					(rstn),
		.i_FTC_pause			(pauseD),
		.i_FTC_we				(clrE),
		.i_FTC_PC				(PCE),
		.o_FTC_inst				(instF),
		.o_FTC_PC				(PCF));
	DEC dec(
		.clk					(clk),
		.rstn					(rstn),
		.i_DEC_regWeW			(regWeW),
		.i_DEC_clr			    (clrE),
		.i_DEC_pause		    (pauseD),
		.i_DEC_WRAW				(WRAW),
		.i_DEC_PC				(PCF),
		.i_DEC_inst				(instF),
		.i_DEC_aluOutE			(aluOutE),
		.i_DEC_dMemRDataM		(WRDM),
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
	EXE exe(
		.clk					(clk),
		.rstn					(rstn),
		.i_EXE_regWe			(regWeD),
		.i_EXE_dmemWe			(dMemWeD),
		.i_EXE_sA				(sAD),
		.i_EXE_sB				(sBD),
		.i_EXE_sByte			(sByteD),
		.i_EXE_sWRD				(sWRDD),
		.i_EXE_srs				(sA0D),
		.i_EXE_clr  			(pauseD),
		.i_EXE_brOP				(brOPD),
		.i_EXE_aluOP			(aluOPD),
		.i_EXE_WRA				(WRAD),
		.i_EXE_lowPC			(lowPCD),
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
	WRT wrt(
		.clk					(clk),
		.rstn					(rstn),
		.i_WRT_regWe			(regWeM),
		.i_WRT_WRA				(WRAM),
		.i_WRT_WRD				(WRDM),
		.o_WRT_regWe			(regWeW),
		.o_WRT_WRA				(WRAW),
		.o_WRT_rstW				(rstW));
		
	initial begin
	   clk = 0;
	   rstn = 0;
    end
    
    always begin
        #20
        clk = ~clk;
    end
    
    always begin
        #25
        rstn = ~rstn;
        #2000
        rstn = ~rstn;
    end

endmodule
