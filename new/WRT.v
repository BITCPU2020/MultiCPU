`timescale 1ns / 1ps

module WRT(
		input wire clk, rstn, i_WRT_regWe,
		input wire [4:0] i_WRT_WRA,
		input wire [31:0] i_WRT_WRD,
		output wire o_WRT_regWe,
		output wire [4:0] o_WRT_WRA,
		output wire [31:0] o_WRT_rstW
	);
	
	reg WRT_regWe;
	reg [4:0] WRT_WRA;
	reg [31:0] WRT_rstW;

	assign o_WRT_regWe = WRT_regWe;
	assign o_WRT_WRA = WRT_WRA;
	assign o_WRT_rstW = WRT_rstW;

	always @(posedge clk or negedge rstn) begin
		if(!rstn) begin
			WRT_regWe <= 0;
			WRT_WRA <= 0;
			WRT_rstW <= 0;
		end else begin
			WRT_regWe <= i_WRT_regWe;
			WRT_WRA <= i_WRT_WRA;
			WRT_rstW <= i_WRT_WRD;
		end
	end
	
endmodule