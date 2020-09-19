`timescale 1ns / 1ps
/*
	INPUT
		-I_WRA [4:0] 寄存器堆写地址
		-I_RD2 [31:0] 正确的寄存器输出2数据
		-I_ALU_OR_MEM ALU运算结果或数据存储器读出数据写入寄存器
		-I_ISBYTE 是否是对字节进行操作
		-I_DMEM_WE 数据存储器写使能
		-I_REG_WE 寄存器写使能
		-I_ALU_OUT [31:0] alu计算结果

	OUTPUT
		O_WRA [4:0] 寄存器堆写地址
		O_REG_WE 寄存器写使能
		O_WRD [31:0] 寄存器写内容

	BUFFER
		I_WRA [4:0] 寄存器堆写地址
		I_RD2 [31:0] 正确的寄存器输出2数据
		I_ALU_OR_MEM ALU运算结果或数据存储器读出数据写入寄存器
		I_ISBYTE 是否是对字节进行操作
		I_DMEM_WE 数据存储器写使能
		I_REG_WE 寄存器写使能
		I_ALU_OUT [31:0] alu计算结果
		O_...
*/

module MEM(
		input wire clk, rstn, i_MEM_regWe, i_MEM_dMemWe, i_MEM_sByte, i_MEM_sWRD,
		input wire [4:0] i_MEM_WRA,
		input wire [31:0] i_MEM_aluOut, i_MEM_rd2,
		
		output wire o_MEM_regWe,
		output wire [4:0] o_MEM_WRA,
		output wire [31:0] o_MEM_WRD
    ); 
    
    reg MEM_regWe, MEM_dMemWe, MEM_sByte, MEM_sWRD;
	reg [4:0] MEM_WRA;
	reg [31:0] MEM_aluOut, MEM_rd2;

	assign o_MEM_regWe = MEM_regWe;
	assign o_MEM_WRA = MEM_WRA;

	always @(posedge clk or negedge rstn) begin
		if (!rstn) begin
			MEM_regWe <= 0;
			MEM_dMemWe <= 0;
			MEM_sByte <= 0;
			MEM_sWRD <= 0;
			MEM_WRA <= 0;
			MEM_aluOut <= 0;
			MEM_rd2 <= 0;
		end else begin
			MEM_regWe <= i_MEM_regWe;
			MEM_dMemWe <= i_MEM_dMemWe;
			MEM_sByte <= i_MEM_sByte;
			MEM_sWRD <= i_MEM_sWRD;
			MEM_WRA <= i_MEM_WRA;
			MEM_aluOut <= i_MEM_aluOut;
			MEM_rd2 <= i_MEM_rd2;
		end
	end

	wire [31:0] MEM_rData;
    
    DataMemory data_memory(
    	.clk					(clk),
    	.rstn					(rstn),
		.i_DMem_dMemWe			(MEM_dMemWe),
		.i_DMem_sByte			(MEM_sByte),
		.i_DMem_addr			(MEM_aluOut),
		.i_DMem_wData			(MEM_rd2),
		.o_DMem_rData			(MEM_rData));
    
    mux #32 muxWD(
    	.in0					(MEM_aluOut),
    	.in1					(MEM_rData),
    	.select					(MEM_sWRD),
    	.out 					(o_MEM_WRD));
    


    
endmodule
