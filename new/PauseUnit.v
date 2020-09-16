`timescale 1ns / 1ps

module PauseUnit(
		input wire clk, rstn,
		// target reg
		input wire [4:0] i_PauseUnit_WRA,
		// back propagation at each step
		input wire [31:0] i_PauseUnit_aluOutE, i_PauseUnit_dMemRDataM, i_PauseUnit_W,
		// new data
		input wire [31:0] i_PauseUnit_rd1, i_PauseUnit_rd2,

		// a factor that lead to pause, (another is lw)
		output wire o_PauseUnit_pause,
		input wire [31:0] o_PauseUnit_rd1, o_PauseUnit_rd2,
	);

	reg [4: 0] buff1, buff2, buff3;

	always @(posedge clk or negedge rstn) begin
		if (!rstn) begin
			buff1 <= 0;
			buff2 <= 0;
			buff3 <= 0;
		end else begin
			// queue: in, buff3, buff2, buff1, out
			buff3 <= i_PauseUnit_WRA;
			buff2 <= buff3;
			buff1 <= buff2;
		end
	end

	assign o_PauseUnit_rd1 = (o_PauseUnit_ra1 == buff3) ? i_PauseUnit_aluOutE : 
							(o_PauseUnit_ra1 == buff2) ? i_PauseUnit_dMemRDataM :
							(o_PauseUnit_ra1 == buff1) ? i_PauseUnit_W : o_PauseUnit_rd1;
	assign o_PauseUnit_rd2 = (o_PauseUnit_ra2 == buff3) ? i_PauseUnit_aluOutE : 
							(o_PauseUnit_ra2 == buff2) ? i_PauseUnit_dMemRDataM :
							(o_PauseUnit_ra2 == buff1) ? i_PauseUnit_W : o_PauseUnit_rd2;
	// matter to the nearest instruction only
	assign o_PauseUnit_pause = (o_PauseUnit_ra1 == buff1) || (o_PauseUnit_ra2 == buff1);

endmodule