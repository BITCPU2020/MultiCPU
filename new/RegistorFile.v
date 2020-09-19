`timescale 1ns / 1ps

module RegistorFile(
		input wire clk, rstn, i_RegistorFile_we,
		input wire [4:0] i_RegistorFile_ra1, i_RegistorFile_ra2,
		input wire [4:0] i_RegistorFile_WRA,
		input wire [31:0] i_RegistorFile_rstW,
		output wire [31:0] o_RegistorFile_rd1, o_RegistorFile_rd2
	);

	reg [31:0] registorFile [31:0];

	// read
	assign o_RegistorFile_rd1 = (i_RegistorFile_ra1 == 0) ? 0 : registorFile[i_RegistorFile_ra1];
	assign o_RegistorFile_rd2 = (i_RegistorFile_ra2 == 0) ? 0 : registorFile[i_RegistorFile_ra2];

	// write
	integer i;
	always @(posedge clk) begin
		if(!rstn)
			for(i = 0; i < 32; i = i + 1)
				registorFile[i] <= 32'b0;
		if(i_RegistorFile_we) begin
			registorFile[i_RegistorFile_WRA] <= i_RegistorFile_rstW;
		end
	end

endmodule