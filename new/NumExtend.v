`timescale 1ns / 1ps

module NumExtend(
		input wire [15:0] i_NumExtend_num,
		input wire i_NumExtend_sign,
		output wire [31:0] o_NumExtend_num
	);
	
	assign o_NumExtend_num = (i_NumExtend_sign == 0 || i_NumExtend_num[15] == 0) ? {16'h0000, i_NumExtend_num} : {16'hffff, i_NumExtend_num};

endmodule