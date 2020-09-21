`timescale 1ns / 1ps

module BranchUnit(
	input [31:0] i_BranchUnit_A,
	input [31:0] i_BranchUnit_B,
	input [3:0] i_BranchUnit_brOP,
	input [25:0] i_BranchUnit_target,
	input [31:0] i_BranchUnit_PC,

	output [31:0] o_BranchUnit_PC,
	output o_BranchUnit_clr 
    );

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

wire [31:0] pc_b = i_BranchUnit_PC + {{14{i_BranchUnit_target[15]}}, i_BranchUnit_target[15:0], 2'b0};
wire [31:0] pc_j = {i_BranchUnit_PC[31:28], i_BranchUnit_target[25:0], 2'b0};
wire [31:0] pc_jr = i_BranchUnit_A;

wire signed [31:0] signed_A = i_BranchUnit_A;

wire do_jr = (i_BranchUnit_brOP == OP_JR);
wire do_j = (i_BranchUnit_brOP == OP_J);
wire do_jal = (i_BranchUnit_brOP == OP_JAL);
wire do_bal = (i_BranchUnit_brOP == OP_BAL);
wire do_bgezal = (i_BranchUnit_brOP == OP_BGEZAL) && (signed_A >= 0);
wire do_bltz = (i_BranchUnit_brOP == OP_BLTZ) && (signed_A < 0);
wire do_bgez = (i_BranchUnit_brOP == OP_BGEZ) && (signed_A >= 0);
wire do_bltzal = (i_BranchUnit_brOP == OP_BLTZAL) && (signed_A < 0);
wire do_b = (i_BranchUnit_brOP == OP_B);
wire do_beq = (i_BranchUnit_brOP == OP_BEQ) && (i_BranchUnit_A == i_BranchUnit_B);
wire do_bne = (i_BranchUnit_brOP == OP_BNE) && (i_BranchUnit_A != i_BranchUnit_B);
wire do_blez = (i_BranchUnit_brOP == OP_BLEZ) && (signed_A <= 0);
wire do_bgtz = (i_BranchUnit_brOP == OP_BGTZ) && (signed_A > 0);

assign o_BranchUnit_clr = do_jr || do_j || do_jal || do_bal || do_bgezal 
							|| do_bltz || do_bgez || do_bltzal || do_b 
							|| do_beq || do_bne || do_blez || do_bgtz;

assign o_BranchUnit_PC = do_jr ? pc_jr :
							(do_j || do_jal) ? pc_j :
							(do_bal || do_bgezal || do_bltz || do_bgez || do_bltzal || do_b 
							|| do_beq || do_bne || do_blez || do_bgtz) ? pc_b : 0;

endmodule
