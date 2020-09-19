`timescale 1ns / 1ps

module sim_alu();

reg [31:0] i_ALU_srcA, i_ALU_srcB;
reg [4:0] i_ALU_op;

wire [31:0] o_ALU_aluOut;

parameter OP_ADD = 5'd1;
parameter OP_SUB = 5'd2;
parameter OP_AND = 5'd3;
parameter OP_OR = 5'd4;
parameter OP_XOR = 5'd5;
parameter OP_NOR = 5'd6;
parameter OP_CMP = 5'd7;
parameter OP_CMPU = 5'd8;
parameter OP_SL = 5'd9;
parameter OP_SR = 5'd10;
parameter OP_SRA = 5'd11;
parameter OP_LUI = 5'd12;
parameter OP_XAL = 5'd13;

ALU U_alu(
	.i_ALU_srcA(i_ALU_srcA),
	.i_ALU_srcB(i_ALU_srcB),
	.i_ALU_op(i_ALU_op),
	.o_ALU_aluOut(o_ALU_aluOut)
	);

initial begin
	i_ALU_op = OP_ADD;
	i_ALU_srcA = 32'h123;
	i_ALU_srcB = 32'h456;
	#10;
	i_ALU_op = OP_ADD;
	i_ALU_srcA = 32'h123;
	i_ALU_srcB = 32'h456;
	#10;
	i_ALU_op = OP_ADD;
	i_ALU_srcA = 32'hfffffffa;
	i_ALU_srcB = 32'h0000000b;
	#10;
	i_ALU_op = OP_SUB;
	i_ALU_srcA = 32'h456;
	i_ALU_srcB = 32'h123;
	#10;
	i_ALU_op = OP_SUB;
	i_ALU_srcA = 32'h123;
	i_ALU_srcB = 32'h123;
	#10;
	i_ALU_op = OP_SUB;
	i_ALU_srcA = 32'h123;
	i_ALU_srcB = 32'h456;
	#10;
	i_ALU_op = OP_AND;
	i_ALU_srcA = 32'hacaccaca;
	i_ALU_srcB = 32'hcacaacac;
	#10;
	i_ALU_op = OP_OR;
	i_ALU_srcA = 32'hacaccaca;
	i_ALU_srcB = 32'hcacaacac;
	#10;
	i_ALU_op = OP_XOR;
	i_ALU_srcA = 32'hacaccaca;
	i_ALU_srcB = 32'hcacaacac;
	#10;
	i_ALU_op = OP_NOR;
	i_ALU_srcA = 32'hacaccaca;
	i_ALU_srcB = 32'hcacaacac;
	#10;
	i_ALU_op = OP_CMPU;
	i_ALU_srcA = 32'h12345678;
	i_ALU_srcB = 32'h87654321;
	#10;
	i_ALU_op = OP_CMPU;
	i_ALU_srcA = 32'h12345678;
	i_ALU_srcB = 32'h12345678;
	#10;
	i_ALU_op = OP_CMPU;
	i_ALU_srcA = 32'h12345678;
	i_ALU_srcB = 32'h12345677;
	#10;
	i_ALU_op = OP_CMP;
	i_ALU_srcA = 32'h12345678;
	i_ALU_srcB = 32'h87654321;
	#10;
	i_ALU_op = OP_CMP;
	i_ALU_srcA = 32'hffffffff;
	i_ALU_srcB = 32'hfffffff0;
	#10;
	i_ALU_op = OP_CMP;
	i_ALU_srcA = 32'hffffffff;
	i_ALU_srcB = 32'hffffffff;
	#10;
	i_ALU_op = OP_CMP;
	i_ALU_srcA = 32'hffffffff;
	i_ALU_srcB = 32'h00000000;
	#10;
	i_ALU_op = OP_SL;
	i_ALU_srcA = 32'h3;
	i_ALU_srcB = 32'h12345678;
	#10;
	i_ALU_op = OP_SR;
	i_ALU_srcA = 32'h5;
	i_ALU_srcB = 32'h12345678;
	#10;
	i_ALU_op = OP_SRA;
	i_ALU_srcA = 32'h5;
	i_ALU_srcB = 32'h12345678;
	#10;
	i_ALU_op = OP_SRA;
	i_ALU_srcA = 32'h5;
	i_ALU_srcB = 32'hf2345678;
	#10;
	i_ALU_op = OP_LUI;
	i_ALU_srcA = 32'h00000000;
	i_ALU_srcB = 32'h12345678;
	#10;
	i_ALU_op = OP_XAL;
	i_ALU_srcA = 32'h12345678;
	i_ALU_srcB = 32'h00000000;
	#10;
	i_ALU_op = 32'b0;
end

endmodule