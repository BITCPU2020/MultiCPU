`timescale 1ns / 1ps

module BranchUnit (
		input wire [31:0] i_BranchUnit_pc,
		input wire [3:0] i_BranchUnit_BRop,

		input wire [31:0] i_BranchUnit_A, i_BranchUnit_B,
		input wire [15:0] i_BranchUnit_branchOffset,
		input wire [15:0] i_BranchUnit_jumpTarget,
		input wire [31:0] i_BranchUnit_pause,

		output wire [31:0] o_BranchUnit_pc
	);
	
	wire equ;
    assign equ = (i_BranchUnit_A == i_BranchUnit_B);

    wire [31:0] t_BranchUnit_pc;
    assign t_BranchUnit_pc = i_BranchUnit_pc + 4;

    assign o_BranchUnit_pc = (i_BranchUnit_BRop==3'b010) ? {t_BranchUnit_pc[31:28], i_BranchUnit_jumpTarget, 2'b00} : 
            (i_BranchUnit_BRop==3'b100 && equ) ? (t_BranchUnit_pc + {{14{i_BranchUnit_branchOffset[15]}}, i_BranchUnit_branchOffset, 2'b00}) : 
            (i_BranchUnit_BRop==3'b001 && !equ) ? (t_BranchUnit_pc + {{14{i_BranchUnit_branchOffset[15]}}, i_BranchUnit_branchOffset, 2'b00}) :
            t_BranchUnit_pc;
endmodule