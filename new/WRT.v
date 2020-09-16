`timescale 1ns / 1ps

module WRT(
		input wire clk, rstn, i_WRT_regWe, i_WRT_sWD,
		input wire [4:0] i_WRT_WRA,
		input wire [31:0] i_WRT_aluOut, i_WRT_dMemData,
		output wire o_WRT_regWe,
		output wire [4:0] o_WRT_WRA,
		output wire [31:0] o_WRT_rstW
    );
    
	reg WRT_regWe, WRT_dMemWe;
	reg [4:0] WRT_WRA;
	reg [31:0] WRT_aluOut, WRT_dMemData;

	assign o_WRT_regWe = WRT_regWe;
	assign o_WRT_WRA = WRT_WRA;

	always @(posedge clk or negedge rstn) begin
		if(!rstn) begin
			WRT_regWe <= 0;
			WRT_dMemWe <= 0;
			WRT_WRA <= 0;
			WRT_aluOut <= 0;
			WRT_dMemData <= 0;
		end else begin
			WRT_regWe <= i_WRT_regWe;
			WRT_dMemWe <= i_WRT_dMemWe;
			WRT_WRA <= i_WRT_WRA;
			WRT_aluOut <= i_WRT_aluOut;
			WRT_dMemData <= i_WRT_dMemData;
		end
	end

    mux #32 muxWD(WRT_aluOut, WRT_dMemData, WRT_dMemWe, o_WRT_rstW);
    
endmodule