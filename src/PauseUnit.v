`timescale 1ns / 1ps

module PauseUnit(
	input clk,
	input rstn,
	input [31:0] i_PauseUnit_aluOutE,
	input [31:0]i_PauseUnit_dMemRDataM,
	input [31:0] i_PauseUnit_rstW,
	input [4:0] i_PauseUnit_ra1,
    input [4:0] i_PauseUnit_ra2,
    input [31:0] i_PauseUnit_rd1,
    input [31:0] i_PauseUnit_rd2,
    input [4:0] i_PauseUnit_regWa,
    input i_PauseUnit_regWe,
    input i_PauseUnit_isLoad,

    output o_PauseUnit_pause,
    output [31:0] o_PauseUnit_rd1,
    output [31:0] o_PauseUnit_rd2
	);

reg reg_exe_isL;

reg reg_exe_we;
reg reg_mem_we;
reg reg_wrt_we;

reg [4:0] reg_exe_wa;
reg [4:0] reg_mem_wa;
reg [4:0] reg_wrt_wa;

assign o_PauseUnit_pause = reg_exe_isL && reg_exe_we && (reg_exe_wa == i_PauseUnit_ra1 || reg_exe_wa == i_PauseUnit_ra2);

assign o_PauseUnit_rd1 = (reg_exe_we && reg_exe_wa == i_PauseUnit_ra1) ? i_PauseUnit_aluOutE :
							(reg_mem_we && reg_mem_wa == i_PauseUnit_ra1) ? i_PauseUnit_dMemRDataM : 
							(reg_wrt_we && reg_wrt_wa == i_PauseUnit_ra1) ? i_PauseUnit_rstW : 
							i_PauseUnit_rd1;

assign o_PauseUnit_rd2 = (reg_exe_we && reg_exe_wa == i_PauseUnit_ra2) ? i_PauseUnit_aluOutE :
							(reg_mem_we && reg_mem_wa == i_PauseUnit_ra2) ? i_PauseUnit_dMemRDataM : 
							(reg_wrt_we && reg_wrt_wa == i_PauseUnit_ra2) ? i_PauseUnit_rstW : 
							i_PauseUnit_rd2;

always @(posedge clk or negedge rstn) begin
	if (!rstn) begin
		// reset
		reg_exe_isL <= 0;
		reg_exe_we <= 0;
		reg_mem_we <= 0;
		reg_wrt_we <= 0;
		reg_exe_wa <= 4'b0;
		reg_mem_wa <= 4'b0;
		reg_wrt_wa <= 4'b0;
	end
	else if (o_PauseUnit_pause) begin
		reg_exe_isL <= 0;
		reg_exe_we <= 0;
		reg_exe_wa <= 4'b0;

		reg_mem_we <= reg_exe_we;
		reg_mem_wa <= reg_exe_wa;

		reg_wrt_we <= reg_mem_we;
		reg_wrt_wa <= reg_mem_wa;
	end
	else begin
		reg_exe_isL <= i_PauseUnit_isLoad;
		reg_exe_we <= i_PauseUnit_regWe;
		reg_exe_wa <= i_PauseUnit_regWa;

		reg_mem_we <= reg_exe_we;
		reg_mem_wa <= reg_exe_wa;

		reg_wrt_we <= reg_mem_we;
		reg_wrt_wa <= reg_mem_wa;
	end
end

endmodule