`timescale 1ns / 1ps

module MultiCPU(
		input wire clk, rstn
    );
	
	wire [5:0] opcode,funct;
	wire [4:0] rs, rt, rd, sa;

	ControlUnit ctrl(
		);
    FTC ftc(
    	.clk					(clk),
    	.rstn					(rstn),
		.i_FTC_pc				(),
		.o_FTC_inst				());
    DEC dec(
    	.clk					(clk), 
		.rstn					(rstn), 
		.i_DEC_we				(), 
		.i_DEC_swra				(), 
		.i_DEC_BRop				(), 
		.i_DEC_sign,			(),
		.i_DEC_rt				(), 
		.i_DEC_rd,				(),
		.i_DEC_BRop,			(),
		.i_DEC_branchOffset		(), 
		.i_DEC_num,				(),
		.i_DEC_jumpTarget,		(),
		.i_DEC_ra1				(), 
		.i_DEC_ra2				(), 
		.i_DEC_writeAddr		(), 
		.i_DEC_writeData,		(),
		.i_DEC_aluOutE			(), 
		.i_DEC_dMemRDataM		(), 
		.i_DEC_rstW,			(),
		.o_PauseUnit_pause,		(),
		.o_DEC_pc				(), 
		.o_DEC_num				(), 
		.o_DEC_WRA				(), 
		.o_DEC_rd1				(), 
		.o_DEC_rd2				());
    EXE exe(
    	clk						(clk),
		rstn					(rstn),
		i_EXE_WRA				(),
		i_EXE_dmemWe			(),
		i_EXE_regWe				(),
		i_EXE_sA1				(),
		i_EXE_sA2				(),
		i_EXE_sB				(),
		i_EXE_sWD				(),
		i_EXE_ALUop				(),
		i_EXE_rd1				(),
		i_EXE_rd2				(),
		i_EXE_num				(),
		i_EXE_shrmt				(),
		o_EXE_dmemWe			(),
		o_EXE_regWe				(),
		o_EXE_sWD				(),
		o_EXE_WRA				(),
		o_EXE_ALUout			());
    MEM mem(
    	clk						(clk),
		rstn					(rstn),
		i_MEM_regWe				(),
		i_MEM_dMemWe			(),
		i_MEM_WRA				(),
		i_MEM_WMA				(),
		i_MEM_aluOut			(),
		 i_MEM_rd2				(),		
		o_MEM_regWe				(),
		o_MEM_WRA				(),
		o_MEM_rData				(),
		o_MEM_aluOut			());
    WRT wrt(
    	clk						(clk),
    	rstn					(rstn),
		i_WRT_regWe				(),
		i_WRT_dMemWe			(),
		i_WRT_WRA				(),
		i_WRT_aluOut			(),
		i_WRT_dMemData			(),
		o_WRT_regWe				(),
		o_WRT_WRA				(),
		o_WRT_rstW				());
endmodule