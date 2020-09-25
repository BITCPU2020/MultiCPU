`timescale 1ns / 1ps
module ProgramCounter(
	input clk,
	input rstn,
	input i_ProgramCounter_pause,
	input i_ProgramCounter_we,
	input [31:0] i_ProgramCounter_PC,

	output [31:0] o_ProgramCounter_PC,
	output [31:0] o_ProgramCounter_PC_PLUS
    );

reg [31:0] reg_addr;

assign o_ProgramCounter_PC = reg_addr;
assign o_ProgramCounter_PC_PLUS = reg_addr + 32'h4;

always @(posedge clk or negedge rstn) begin
	if (!rstn) begin
		// reset
		reg_addr <= 32'h4;
	end
	else if (i_ProgramCounter_pause) begin
		reg_addr <= reg_addr;
	end
	else if (i_ProgramCounter_we) begin
		reg_addr <= i_ProgramCounter_PC;
	end
	else begin
		reg_addr <= o_ProgramCounter_PC_PLUS;
	end
end

endmodule
