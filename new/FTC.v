`timescale 1ns / 1ps

module FTC(
		input wire clk, rstn,
		input wire [31:0] i_FTC_pc,
		output wire [31:0] o_FTC_inst, o_FTC_pc
    );
	
	// separate at ProgramCounter
	wire [31:0] FTC_pc;
    ProgramCounter program_counter(clk, rstn, i_FTC_pc, o_FTC_pc);
    InstructionMemory instruction_memory(FTC_pc, o_FTC_inst);
endmodule