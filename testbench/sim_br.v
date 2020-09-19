`timescale 1ns / 1ps

module sim_br();

parameter OP_JR = 4'd1;
parameter OP_J = 4'd2;
parameter OP_JAL = 4'd3;
parameter OP_BAL = 4'd4;
parameter OP_BGEZAL = 4'd5;
parameter OP_BLTZ = 4'd6;
parameter OP_BGEZ = 4'd7;
parameter OP_BLTZAL = 4'd8;
parameter OP_B = 4'd9;
parameter OP_BEQ = 4'd10;
parameter OP_BNE = 4'd11;
parameter OP_BLEZ = 4'd12;
parameter OP_BGTZ = 4'd13;

reg [3:0] i_BranchUnit_brOP;
reg [31:0] i_BranchUnit_A;
reg [31:0] i_BranchUnit_B;
reg [25:0] i_BranchUnit_target;
reg [31:0] i_BranchUnit_PC;

wire [31:0] o_BranchUnit_PC;
wire o_BranchUnit_clr;

BranchUnit U_br(
	.i_BranchUnit_brOP(i_BranchUnit_brOP),
	.i_BranchUnit_A(i_BranchUnit_A),
	.i_BranchUnit_B(i_BranchUnit_B),
	.i_BranchUnit_target(i_BranchUnit_target),
	.i_BranchUnit_PC(i_BranchUnit_PC),
	.o_BranchUnit_PC(o_BranchUnit_PC),
	.o_BranchUnit_clr(o_BranchUnit_clr)
	);

initial begin
	i_BranchUnit_target = 26'h3a5c396;
	i_BranchUnit_PC = 32'h87654321;

	// b: 87645179
	// j: 8e970e58

	i_BranchUnit_brOP = OP_JR;
	i_BranchUnit_A = 32'h12345678;
	#20;
	
	i_BranchUnit_brOP = OP_J;
	#10;
	i_BranchUnit_brOP = OP_JAL;
	#20;

	i_BranchUnit_brOP = OP_B;
	#10;
	i_BranchUnit_brOP = OP_BAL;
	#20;


	// A > 0
	i_BranchUnit_brOP = OP_BLTZ; // 0
	#10;
	i_BranchUnit_brOP = OP_BLTZAL; // 0
	#10;
	i_BranchUnit_brOP = OP_BLEZ; // 0
	#10;
	i_BranchUnit_brOP = OP_BGTZ; // 1
	#10;
	i_BranchUnit_brOP = OP_BGEZ; // 1
	#10;
	i_BranchUnit_brOP = OP_BGEZAL; // 1
	#20;

	// A < 0
	i_BranchUnit_A = 32'h87654321;
	i_BranchUnit_brOP = OP_BLTZ; // 1
	#10;
	i_BranchUnit_brOP = OP_BLTZAL; // 1
	#10;
	i_BranchUnit_brOP = OP_BLEZ; // 1
	#10;
	i_BranchUnit_brOP = OP_BGTZ; // 0
	#10;
	i_BranchUnit_brOP = OP_BGEZ; // 0
	#10;
	i_BranchUnit_brOP = OP_BGEZAL; // 0
	#20;

	// A = 0
	i_BranchUnit_A = 32'h00000000;
	i_BranchUnit_brOP = OP_BLTZ; // 0
	#10;
	i_BranchUnit_brOP = OP_BLTZAL; // 0
	#10;
	i_BranchUnit_brOP = OP_BLEZ; // 1
	#10;
	i_BranchUnit_brOP = OP_BGTZ; // 0
	#10;
	i_BranchUnit_brOP = OP_BGEZ; // 1
	#10;
	i_BranchUnit_brOP = OP_BGEZAL; // 1
	#20;


	i_BranchUnit_A = 32'h12345678;
	i_BranchUnit_B = 32'h12345678;
	i_BranchUnit_brOP = OP_BEQ;
	#10;
	i_BranchUnit_brOP = OP_BNE;
	#20;

	i_BranchUnit_A = 32'h12345678;
	i_BranchUnit_B = 32'h87654321;
	i_BranchUnit_brOP = OP_BEQ;
	#10;
	i_BranchUnit_brOP = OP_BNE;
	#20;

end

endmodule
