`timescale 1ns / 1ps

module RegistorFile(
		input wire i_RegistorFile_clk, i_RegistorFile_rstn, i_RegistorFile_we,
		input wire [4:0] i_RegistorFile_ra1, i_RegistorFile_ra2,
		input wire [4:0] i_RegistorFile_writeAddr,
		input wire [31:0] i_RegistorFile_writeData,
		output wire [31:0] o_RegistorFile_rd1, o_RegistorFile_rd2
	);

	reg [31:0] registorFile [31:0];

	// read
	assign o_RegistorFile_rd1 = (i_RegistorFile_ra1 == 0) ? 0 : registorFile[i_RegistorFile_ra1];
	assign o_RegistorFile_rd2 = (i_RegistorFile_ra2 == 0) ? 0 : registorFile[i_RegistorFile_ra2];

	// write
	integer i;
	always @(posedge i_RegistorFile_clk) begin
		if(!i_RegistorFile_rstn)
			for(i = 0; i < 32; i = i + 1)
				registorFile[i] <= 32'b0;
		if(i_RegistorFile_we) begin
			registorFile[i_RegistorFile_writeAddr] <= i_RegistorFile_writeData;
		end
	end

endmodule