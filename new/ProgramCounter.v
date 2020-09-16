`timescale 1ns / 1ps

module ProgramCounter(
		input wire i_ProgramCounter_clk,
		input wire i_ProgramCounter_rstn,
		input wire [31:0] i_ProgramCounter_pc,
		output wire [31:0] o_ProgramCounter_pc
	);
	
	reg [31:0] pc_reg;
	assign o_ProgramCounter_pc = pc_reg;
	always @(posedge i_ProgramCounter_clk) begin
		if (!i_ProgramCounter_rstn) begin
			pc_reg <= 32'b0;
		end else begin
			pc_reg <= i_ProgramCounter_pc;
		end
	end

endmodule