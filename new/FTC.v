`timescale 1ns / 1ps

module FTC(
		input wire clk, rstn, i_FTC_pause, i_FTC_we,
		input wire [31:0] i_FTC_PC,
		output wire [31:0] o_FTC_inst, o_FTC_PC
    );
	
	wire [31:0] ProgramCounter_PC;
    ProgramCounter program_counter(
    	.clk						(clk),
    	.rstn						(rstn),
    	.i_ProgramCounter_pause		(i_FTC_pause),
    	.i_ProgramCounter_we		(i_FTC_we),
    	.i_ProgramCounter_PC		(i_FTC_PC),
    	.o_ProgramCounter_PC		(ProgramCounter_PC),
    	.o_ProgramCounter_PC		(o_FTC_PC));
    InstructionMemory instruction_memory(
    	.i_InstructionMemory_PC		(ProgramCounter_PC),
    	.o_InstructionMemory_inst	(o_FTC_inst));
endmodule