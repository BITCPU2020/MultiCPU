`timescale 1ns / 1ps

module sim_next();
	reg [15:0] i_NumExtend_num;
	reg i_NumExtend_sign;
	wire [31:0] o_NumExtend_num;

	NumExtend next(
		.i_NumExtend_num(i_NumExtend_num),
		.i_NumExtend_sign(i_NumExtend_sign),
		.o_NumExtend_num(o_NumExtend_num)
		);

	initial begin
		i_NumExtend_num = 16'hf234;
		i_NumExtend_sign = 0;
		# 10
		i_NumExtend_num = 16'h0234;
		i_NumExtend_sign = 0;
		# 10
		i_NumExtend_num = 16'hf234;
		i_NumExtend_sign = 1;
		# 10
		i_NumExtend_num = 16'h0234;
		i_NumExtend_sign = 1;	
	end

endmodule