`timescale 1ns / 1ps

module MEM(
		input wire clk, rstn, i_MEM_regWe, i_MEM_dMemWe,
		input wire [4:0] i_MEM_WRA,
		input wire [31:0] i_MEM_WMA, i_MEM_aluOut i_MEM_rd2,
		
		output wire o_MEM_regWe,
		output wire [4:0] o_MEM_WRA,
		output wire [31:0] o_MEM_rData, o_MEM_aluOut
    ); 
    
    reg MEM_regWe, MEM_dMemWe;
	reg [4:0] MEM_WRA;
	reg [31:0] MEM_WMA, MEM_aluOut, MEM_rd2;

	assign o_MEM_regWe = MEM_regWe;
	assign o_MEM_WRA = MEM_WRA;
	assign o_MEM_aluOut = MEM_aluOut;

	always @(posedge clk or negedge rstn) begin
		if (!rstn) begin
			MEM_regWe <= 0;
			MEM_dMemWe <= 0;
			MEM_WRA <= 0;
			MEM_WMA <= 0;
			MEM_aluOut <= 0;
			MEM_rd2 <= 0;
		end else begin
			MEM_regWe <= i_MEM_regWe;
			MEM_dMemWe <= i_MEM_dMemWe;
			MEM_WRA <= i_MEM_WRA;
			MEM_WMA <= i_MEM_WMA;
			MEM_aluOut <= i_MEM_aluOut;
			MEM_rd2 <= i_MEM_rd2;
		end
	end
    
    DataMemory data_memory(
    	.clk					(clk),
    	.rstn					(rstn)
		.i_DMem_we				(MEM_regWe),
		.i_DMem_addr			(MEM_WMA),
		.i_DMem_wData			(MEM_rd2),
		.o_DMem_rData			(o_DMem_rData));
    
endmodule
