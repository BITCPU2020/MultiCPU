`timescale 1ns / 1ps

module sim_pc();

reg clk;
reg rstn;
reg pause;
reg we;
reg [31:0] i_pc;

wire [31:0] o_pc;
wire [31:0] o_pc_plus;

ProgramCounter program_counter(
	.clk						(clk),
	.rstn						(rstn),
	.i_ProgramCounter_pause		(pause),
	.i_ProgramCounter_we		(we),
	.i_ProgramCounter_PC		(i_pc),
	.o_ProgramCounter_PC		(o_pc),
	.o_ProgramCounter_PC_PLUS	(o_pc_plus));

initial begin
	clk = 0;
	rstn = 1;
	pause = 0;
	we = 0;
	#20;
	rstn = 0;
	#20;
	rstn = 1;
end

always begin
	clk = ~clk;
	#10;
end

integer n = 0;
always @(posedge clk) begin
	case(n)
		5: pause <= 1;
		6: pause <= 0;
		8: begin
			we <= 1;
			i_pc <= 32'h12345678;
		end
		9: begin
			we <= 0;
			i_pc <= 0;
		end
	endcase;

	n <= n + 1;
end

endmodule
