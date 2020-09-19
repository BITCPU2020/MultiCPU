`timescale 1ns / 1ps

/*
	INPUT 
		-I_WRA [4:0] 寄存器堆写地址
		-I_REG_WE 寄存器写使能
		-I_WRD [31:0] 寄存器写内容

	OUTPUT
		-O_WRA [4:0] 寄存器堆写地址
		-O_REG_WE 寄存器写使能
		-O_WRD [31:0] 寄存器写内容

	BUFFER
		-I_WRA [4:0] 寄存器堆写地址
		-I_REG_WE 寄存器写使能
		-I_WRD [31:0] 寄存器写内容
		-O_WRA [4:0] 寄存器堆写地址
		-O_REG_WE 寄存器写使能
		-O_WRD [31:0] 寄存器写内容
*/

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
	reg [31:0] WRT_SWD;

	assign o_WRT_regWe = WRT_regWe;
	assign o_WRT_WRA = WRT_WRA;
	assign o_WRT_WRD = WRT_WRD;

	always @(posedge clk or negedge rstn) begin
		if(!rstn) begin
			WRT_regWe <= 0;
			WRT_WRA <= 0;
			WRT_WRD <= 0;
		end else begin
			WRT_regWe <= i_WRT_regWe;
			WRT_WRA <= i_WRT_WRA;
			WRT_WRD <= i_WRT_WRD;
		end
	end
    
endmodule