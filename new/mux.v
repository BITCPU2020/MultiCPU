`timescale 1ns / 1ps

module mux #(parameter WIDTH = 8)(
	input wire [WIDTH - 1 : 0] in0, in1,
	input wire select,
	output wire [WIDTH - 1 : 0] out
	);

	assign out = (select == 1) ? in1 : in0;

endmodule